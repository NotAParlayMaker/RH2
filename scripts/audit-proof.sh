#!/bin/sh
set -eu

cd "$(dirname "$0")/../lean"
lake build Statements
lake env lean ../scripts/audit-statements.lean
