#!/usr/bin/env python3
"""Turn the released Lean tree into the layout kept in this repository.

Usage: scripts/restructure.py [--check] [--moves FILE] [LEAN_DIR]

LEAN_DIR is the directory that holds lakefile.toml and src/ (default: lean/ next to
this script's parent). The script changes only file locations and `import` lines.
It never changes a declaration, a namespace or a proof.

The change: a directory that holds exactly one .lean file and nothing else is
replaced by that file. `src/P/D/F.lean` becomes `src/P/D.lean`, and every
`import P.D.F` becomes `import P.D`. The script repeats this until no such
directory is left, so running it on its own output changes nothing.

A directory is kept when
  - `P/D.lean` already exists next to it, or
  - the new module would belong to a different lakefile library than the old one
    (libraries can set different Lean options), or to none.

--check     change nothing; exit with code 1 when the script would move a file.
--moves F   write one "old<TAB>new" line per moved file (paths relative to LEAN_DIR).
"""
import argparse
import os
import re
import sys
import tomllib

IMPORT = re.compile(r"^import[ \t]+(\S+)[ \t]*$")


def lib_matchers(lakefile):
    with open(lakefile, "rb") as f:
        cfg = tomllib.load(f)
    libs = []
    for lib in cfg.get("lean_lib", []):
        pats = list(lib.get("globs", [])) + list(lib.get("roots", []))
        if not pats:
            pats = [lib["name"]]
        libs.append((lib["name"], pats))
    return libs


def glob_match(pat, mod):
    if pat.endswith(".+"):
        return mod.startswith(pat[:-1])
    if pat.endswith(".*"):
        return mod == pat[:-2] or mod.startswith(pat[:-1])
    return mod == pat


def library_of(libs, mod):
    for name, pats in libs:
        if any(glob_match(p, mod) for p in pats):
            return name
    return None


def module_of(rel):
    return rel[: -len(".lean")].replace("/", ".")


def plan_round(src, libs):
    """Return a list of (old_rel, new_rel) moves for one round."""
    moves = []
    taken = {p.lower() for p in all_files(src)}
    for dirpath, dirnames, filenames in os.walk(src):
        if dirpath == src or dirnames or len(filenames) != 1:
            continue
        (name,) = filenames
        if not name.endswith(".lean"):
            continue
        old = os.path.relpath(os.path.join(dirpath, name), src)
        new = os.path.relpath(dirpath, src) + ".lean"
        if new.lower() in taken:
            continue
        lib = library_of(libs, module_of(old))
        if lib is None or library_of(libs, module_of(new)) != lib:
            continue
        taken.add(new.lower())
        moves.append((old, new))
    return sorted(moves)


def all_files(src):
    for dirpath, _, filenames in os.walk(src):
        for name in filenames:
            yield os.path.relpath(os.path.join(dirpath, name), src)


def rewrite_imports(src, renames):
    """Replace each `import Old` by `import New` in the header of every .lean file."""
    changed = 0
    for rel in all_files(src):
        if not rel.endswith(".lean"):
            continue
        path = os.path.join(src, rel)
        with open(path, "rb") as f:
            data = f.read()
        lines = data.split(b"\n")
        dirty = False
        for i, line in enumerate(lines):
            text = line.decode("utf-8")
            m = IMPORT.match(text)
            if not m:
                if text.strip() == "":
                    continue
                break  # the header ends at the first line that is not an import
            new = renames.get(m.group(1))
            if new is not None:
                lines[i] = text.replace(m.group(1), new, 1).encode("utf-8")
                dirty = True
        if dirty:
            with open(path, "wb") as f:
                f.write(b"\n".join(lines))
            changed += 1
    return changed


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("lean_dir", nargs="?",
                    default=os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "lean"))
    ap.add_argument("--check", action="store_true")
    ap.add_argument("--moves")
    args = ap.parse_args()

    lean = os.path.normpath(args.lean_dir)
    src = os.path.join(lean, "src")
    libs = lib_matchers(os.path.join(lean, "lakefile.toml"))

    origin = {}  # current path -> path in the input tree
    while True:
        moves = plan_round(src, libs)
        if not moves:
            break
        if args.check:
            for old, new in moves[:20]:
                print(f"would move src/{old} -> src/{new}")
            print(f"{len(moves)} directories left to flatten", file=sys.stderr)
            sys.exit(1)
        renames = {module_of(o): module_of(n) for o, n in moves}
        for old, new in moves:
            os.rename(os.path.join(src, old), os.path.join(src, new))
            os.rmdir(os.path.dirname(os.path.join(src, old)))
            origin[new] = origin.pop(old, old)
        n = rewrite_imports(src, renames)
        print(f"moved {len(moves)} files, rewrote imports in {n} files", file=sys.stderr)

    if args.moves:
        with open(args.moves, "w") as f:
            for new, old in sorted(origin.items(), key=lambda kv: kv[1]):
                f.write(f"lean/src/{old}\tlean/src/{new}\n")


if __name__ == "__main__":
    main()
