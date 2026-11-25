#!/bin/sh
# Download the release from https://alpo.ge again, check it, apply scripts/restructure.py and compare the result with lean/.
# Usage: scripts/verify-source.sh [work-directory]
# The script exits with code 0 when each hash matches and each file is the same. It needs curl, tar, python3 (3.11 or later) and sha256sum or shasum.
set -eu

root=$(cd "$(dirname "$0")/.." && pwd)
work=${1:-$(mktemp -d)}
base=https://alpo.ge

if command -v sha256sum >/dev/null 2>&1; then
	sha() { sha256sum "$@"; }
else
	sha() { shasum -a 256 "$@"; }
fi

mkdir -p "$work/parts" "$work/tree"
cd "$work/parts"
for i in 01 02 03 04 05 06 07 08 09 10 11 12 13 14; do
	[ -f "lean.tar.gz.part$i" ] || curl -fsSL -o "lean.tar.gz.part$i" "$base/lean.tar.gz.part$i"
done
echo "check the parts"
sha -c "$root/manifests/parts.sha256"

cat lean.tar.gz.part* > ../lean.tar.gz
cd "$work"
echo "check the archive"
grep ' lean.tar.gz$' "$root/manifests/release.sha256" | sha -c -

echo "unpack and check each file of the release"
rm -rf tree && mkdir tree
tar xzf lean.tar.gz -C tree
(cd tree && sha -c --quiet "$root/manifests/release-files.sha256")
(cd tree && find lean -type f | LC_ALL=C sort) > released.txt
if ! cut -c67- "$root/manifests/release-files.sha256" | diff -q - released.txt >/dev/null; then
	echo "the release has files that are not in manifests/release-files.sha256"
	exit 1
fi

echo "apply scripts/restructure.py to the release"
python3 "$root/scripts/restructure.py" --moves moves.tsv tree/lean
if ! diff -q moves.tsv "$root/manifests/moves.tsv" >/dev/null; then
	echo "the moves are not the same as manifests/moves.tsv:"
	diff moves.tsv "$root/manifests/moves.tsv" | head -20
	exit 1
fi

echo "compare the result with lean/"
(cd tree && sha -c --quiet "$root/manifests/files.sha256")
(cd tree && find lean -type f | LC_ALL=C sort) > result.txt
(cd "$root" && find lean -type f | LC_ALL=C sort) > local.txt
if ! diff -q result.txt local.txt >/dev/null; then
	echo "the file lists are not the same:"
	diff result.txt local.txt | head -20
	exit 1
fi
(cd "$root" && sha -c --quiet "$root/manifests/files.sha256")
echo "ok: lean/ is the release after scripts/restructure.py"
