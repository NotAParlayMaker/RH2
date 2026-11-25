# Contributing

This repository keeps a copy of a release. `lean/` is the release after `scripts/restructure.py` (refer to [SOURCE.md](SOURCE.md)). Do not change the files in `lean/` by hand. A change to the layout goes in `scripts/restructure.py`, with new `manifests/files.sha256` and `manifests/moves.tsv`. A change to a proof goes in a new numbered file in `patches/` (a `git diff` of `lean/` with a header that explains it), with a new `manifests/files.sha256`. Compile the changed modules before you submit the patch. A pull request that changes `lean/` any other way fails the workflow `source`.

You can help in these ways:

- Correct or add to the docs in `docs/`.
- Improve the scripts in `scripts/`.
- Report a build result: the machine, the time, the memory, the disk and the output of `#print axioms`. Open an issue with the form "Build report".

The written explanation of the proof is in [tamnd/riemann](https://github.com/tamnd/riemann). Send text about the mathematics there.

Write in plain technical English. Use short sentences and the active voice. Put one paragraph on one line.
