#!/bin/sh
# Download the release from https://alpo.ge again and compare it with the tree in lean/.
# Usage: scripts/verify-source.sh [work-directory]
# The script exits with code 0 when each hash matches and each file is the same. It needs curl, tar and sha256sum or shasum.
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

echo "unpack and check each file"
tar xzf lean.tar.gz -C tree
(cd tree && sha -c --quiet "$root/manifests/files.sha256")

echo "check that lean/ has no other files"
(cd tree && find lean -type f | LC_ALL=C sort) > released.txt
(cd "$root" && find lean -type f | LC_ALL=C sort) > local.txt
if ! diff -q released.txt local.txt >/dev/null; then
	echo "the file lists are not the same:"
	diff released.txt local.txt | head -20
	exit 1
fi
echo "ok: lean/ is the same as the release"
