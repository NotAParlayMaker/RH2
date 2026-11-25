#!/bin/sh
set -eu

usage() {
  echo "Usage: scripts/audit-proof.sh [--statements | --full [/absolute/path/to/lean4lean]]" >&2
  exit 2
}

mode=${1:---statements}
case "$mode" in
  --statements) [ "$#" -le 1 ] || usage ;;
  --full) [ "$#" -le 2 ] || usage ;;
  *) usage ;;
esac
if [ "$#" -eq 2 ]; then
  case "$2" in
    /*) [ -f "$2" ] && [ -x "$2" ] || usage ;;
    *) usage ;;
  esac
fi

cd "$(dirname "$0")/../lean"
lake build Statements
lake env lean ../scripts/audit-statements.lean

if [ "$mode" = "--full" ]; then
  lake build +Main
  lake env lean ../scripts/audit-axioms.lean
  if [ "$#" -eq 2 ]; then
    lake env "$2" --fresh Main
  fi
fi
