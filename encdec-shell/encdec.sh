#!/usr/bin/env bash
# encdec.sh - a simple encoder / decoder
# Usage: ./encdec.sh <encode|decode> [-m method] [-t "text"] [-f infile] [-o outfile]

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load every method (base64, hex, binary, rot13) from lib/
for lib in "$ROOT"/lib/*.sh; do
  source "$lib"
done

usage() {
  cat <<USAGE
Usage: $0 <encode|decode> [options]

Options:
  -m METHOD   base64 (default) | hex | binary | rot13
  -t TEXT     text, string or number to process
  -f FILE     read input from a file
  -o FILE     write output to a file (default: print to screen)
  -h          show this help

If neither -t nor -f is given, input is read from stdin.

Examples:
  $0 encode -m base64 -t "Hello World"
  $0 decode -m base64 -t "SGVsbG8gV29ybGQ="
  $0 encode -m hex    -t 12345
  $0 decode -m hex    -f examples/sample.hex -o out.txt
  echo "secret" | $0 encode -m binary
USAGE
}

# ---- 1. pick action ----
[[ $# -ge 1 ]] || { usage; exit 1; }
action="$1"; shift
case "$action" in
  encode|decode) ;;
  -h|--help|help) usage; exit 0 ;;
  *) die "unknown action '$action' (use encode or decode)" ;;
esac

# ---- 2. read options ----
method="base64"; text=""; has_text=0; infile=""; outfile=""
while getopts "m:t:f:o:h" opt; do
  case "$opt" in
    m) method="$OPTARG" ;;
    t) text="$OPTARG"; has_text=1 ;;
    f) infile="$OPTARG" ;;
    o) outfile="$OPTARG" ;;
    h) usage; exit 0 ;;
    *) usage; exit 1 ;;
  esac
done

# ---- 3. find the function, e.g. "hex_encode" ----
func="${method}_${action}"
declare -F "$func" >/dev/null || die "unsupported method '$method' (available: $(list_methods))"

# ---- 4. get input: file, text, or stdin ----
read_input() {
  if [[ -n "$infile" ]]; then
    [[ -f "$infile" ]] || die "file not found: $infile"
    cat "$infile"
  elif [[ $has_text -eq 1 ]]; then
    printf '%s' "$text"
  else
    cat
  fi
}

# ---- 5. run it and send output ----
if [[ -n "$outfile" ]]; then
  read_input | "$func" > "$outfile"
  echo "Saved to $outfile" >&2
else
  read_input | "$func"
  # add a newline only when printing to a terminal
  if [[ -t 1 ]]; then echo; fi
fi
