#!/bin/sh
# Scan lean/src for the ways to put an unchecked fact into a Lean proof.
# Usage: scripts/scan.sh
# The script prints the count for each pattern. It exits with code 1 when a pattern has more hits than docs/SCAN.md allows.
# The patterns use POSIX classes and no \\b, so that they work with each grep.
# A text scan cannot prove that a proof uses no axiom. Only "#print axioms" on the built environment can show that.
set -eu

cd "$(dirname "$0")/../lean/src"
fail=0

# git grep is much faster than grep on 175,000 files. Use grep when the tree is not in a git work tree.
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
	search() { git grep -nE "$1" -- '*.lean' || true; }
else
	search() { grep -rEn --include='*.lean' "$1" . || true; }
fi

check() {
	name=$1 allowed=$2 pattern=$3
	n=$(search "$pattern" | wc -l | tr -d ' ')
	printf '%-22s %6s (allowed %s)\n' "$name" "$n" "$allowed"
	if [ "$n" -gt "$allowed" ]; then
		search "$pattern" | head -20
		fail=1
	fi
}

check sorry 0 '(^|[^[:alnum:]_])sorry([^[:alnum:]_]|$)'
check admit 0 '(^|[^[:alnum:]_])admit([^[:alnum:]_]|$)'
check sorryAx 0 'sorryAx'
check axiom 0 '^[[:space:]]*(private[[:space:]]+|protected[[:space:]]+)?axiom[[:space:]]'
check native_decide 0 'native_decide|ofReduceBool|trustCompiler'
check implemented_by 0 'implemented_by|@\[extern'
check unsafe 0 '(^|[^[:alnum:]_])unsafe([^[:alnum:]_]|$)'
check opaque 0 '^[[:space:]]*opaque[[:space:]]'
check skipKernelTC 0 'skipKernelTC'
check run_cmd 5 '(^|[^[:alnum:]_])run_cmd([^[:alnum:]_]|$)'
check initialize 0 '^[[:space:]]*(builtin_)?initialize([^[:alnum:]_]|$)'
check macro_syntax_elab 26 '^[[:space:]]*(elab|macro|syntax|macro_rules|elab_rules)([^[:alnum:]_]|$)'
check maxHeartbeats_0 4 'maxHeartbeats[[:space:]]+0'

exit $fail
