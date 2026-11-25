#!/usr/bin/env python3
"""Turn the released Lean tree into the layout kept in this repository, or back.

Usage:
  scripts/restructure.py [--moves FILE] [LEAN_DIR]   apply the layout
  scripts/restructure.py --check [LEAN_DIR]          exit 1 if the layout is not final
  scripts/restructure.py --undo FILE [LEAN_DIR]      restore the release layout

LEAN_DIR holds lakefile.toml and src/ (default: lean/ in this repository).
The script changes only file locations and `import` lines. It never changes a
declaration, a namespace or a proof.

The layout: a directory that holds exactly one .lean file and nothing else is
replaced by that file. `src/P/D/F.lean` becomes `src/P/D.lean`, and every
`import P.D.F` becomes `import P.D`. This repeats until no such directory is
left, so the layout is a fixpoint: --check on the output finds nothing to do.

A directory is kept when
  - a file `P/D.lean` (in any letter case) already exists next to it, or
  - the new module would belong to a different lakefile library than the old
    one, or to none (libraries can set different Lean options).

--moves FILE  write one "old<TAB>new" line per moved file, paths relative to the
              repository root (lean/src/...), sorted by old path.
--undo FILE   read such a list and move each file back, with the imports. On the
              repository tree this gives the release byte for byte, so it can be
              checked against manifests/release-files.sha256 without a download.

The script stops with an error when an `import` line is outside a file header,
because it would not rewrite that line.
"""
import argparse
import os
import re
import sys

try:
    import tomllib
except ImportError:  # Python < 3.11
    sys.exit("restructure.py needs Python 3.11 or later (tomllib)")

IMPORT = re.compile(rb"^import[ \t]+(\S+)[ \t]*$")
PREFIX = "lean/src/"


def lib_matchers(lakefile):
    with open(lakefile, "rb") as f:
        cfg = tomllib.load(f)
    libs = []
    for lib in cfg.get("lean_lib", []):
        pats = list(lib.get("globs", [])) + list(lib.get("roots", []))
        libs.append((lib["name"], pats or [lib["name"]]))
    return libs


def glob_match(pat, mod):
    if pat.endswith(".+"):  # strict submodules
        return mod.startswith(pat[:-1])
    if pat.endswith(".*"):  # the module and its submodules
        return mod == pat[:-2] or mod.startswith(pat[:-1])
    return mod == pat


def library_of(libs, mod):
    for name, pats in libs:
        if any(glob_match(p, mod) for p in pats):
            return name
    return None


def module_of(rel):
    return rel[: -len(".lean")].replace("/", ".")


def list_files(src):
    out = []
    for dirpath, _, filenames in os.walk(src):
        for name in filenames:
            out.append(os.path.relpath(os.path.join(dirpath, name), src).replace(os.sep, "/"))
    return out


def plan(files, libs):
    """Return {old path: final path} for the whole fixpoint, computed in memory."""
    current = {f: f for f in files}  # current path -> original path
    while True:
        children = {}  # directory -> (files, has subdirectory)
        for path in current:
            parts = path.split("/")
            for i in range(1, len(parts)):
                d = "/".join(parts[:i])
                entry = children.setdefault(d, [[], False])
                if i == len(parts) - 1:
                    entry[0].append(path)
                else:
                    entry[1] = True
        taken = {p.lower() for p in current}
        moves = []
        for d, (dfiles, has_sub) in sorted(children.items()):
            if has_sub or len(dfiles) != 1 or not dfiles[0].endswith(".lean"):
                continue
            old, new = dfiles[0], d + ".lean"
            if new.lower() in taken:
                continue
            lib = library_of(libs, module_of(old))
            if lib is None or library_of(libs, module_of(new)) != lib:
                continue
            taken.add(new.lower())
            moves.append((old, new))
        if not moves:
            break
        for old, new in moves:
            current[new] = current.pop(old)
    return {orig: cur for cur, orig in current.items() if orig != cur}


def apply(src, moves):
    """Move files (old -> new) and rewrite the imports of every .lean file once."""
    renames = {module_of(o).encode(): module_of(n).encode() for o, n in moves.items()}
    if len(set(renames.values())) != len(renames):
        sys.exit("two files would get the same module name")
    files = list_files(src)
    # Rewrite first, so that a failure leaves the files where they were.
    rewritten = 0
    for rel in files:
        if rel.endswith(".lean") and rewrite_imports(os.path.join(src, rel), renames):
            rewritten += 1
    for old, new in sorted(moves.items()):
        dst = os.path.join(src, new)
        if os.path.exists(dst):
            sys.exit(f"cannot move src/{old}: src/{new} exists")
        os.makedirs(os.path.dirname(dst), exist_ok=True)
        os.rename(os.path.join(src, old), dst)
    for dirpath, _, _ in sorted(os.walk(src), key=lambda t: -len(t[0])):
        if dirpath != src and not os.listdir(dirpath):
            os.rmdir(dirpath)
    print(f"moved {len(moves)} files, rewrote imports in {rewritten} files", file=sys.stderr)


def rewrite_imports(path, renames):
    with open(path, "rb") as f:
        data = f.read()
    lines = data.split(b"\n")
    in_header, dirty = True, False
    for i, line in enumerate(lines):
        m = IMPORT.match(line)
        if m is None:
            if line.strip():
                in_header = False
            continue
        if not in_header:
            sys.exit(f"{path}:{i + 1}: import outside the header")
        new = renames.get(m.group(1))
        if new is not None:
            lines[i] = b"import " + new
            dirty = dirty or lines[i] != line
    if dirty:
        with open(path, "wb") as f:
            f.write(b"\n".join(lines))
    return dirty


def read_moves(path):
    moves = {}
    with open(path, encoding="utf-8") as f:
        for n, line in enumerate(f, 1):
            old, new = line.rstrip("\n").split("\t")
            if not (old.startswith(PREFIX) and new.startswith(PREFIX)):
                sys.exit(f"{path}:{n}: paths must start with {PREFIX}")
            moves[old[len(PREFIX):]] = new[len(PREFIX):]
    return moves


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("lean_dir", nargs="?",
                    default=os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "lean"))
    mode = ap.add_mutually_exclusive_group()
    mode.add_argument("--check", action="store_true")
    mode.add_argument("--moves")
    mode.add_argument("--undo")
    args = ap.parse_args()

    lean = os.path.normpath(args.lean_dir)
    src = os.path.join(lean, "src")

    if args.undo:
        apply(src, {new: old for old, new in read_moves(args.undo).items()})
        return

    moves = plan(list_files(src), lib_matchers(os.path.join(lean, "lakefile.toml")))
    if args.check:
        if moves:
            for old, new in sorted(moves.items())[:20]:
                print(f"would move src/{old} -> src/{new}")
            sys.exit(f"{len(moves)} files left to move")
        return
    apply(src, moves)
    if args.moves:
        with open(args.moves, "w", encoding="utf-8") as f:
            for old, new in sorted(moves.items()):
                f.write(f"{PREFIX}{old}\t{PREFIX}{new}\n")


if __name__ == "__main__":
    main()
