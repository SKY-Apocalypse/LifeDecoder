# Hex: every byte becomes 2 hex digits ("Hi" -> 4869)

hex_encode() {
  od -An -v -tx1 | tr -d ' \n'
}

hex_decode() {
  local clean
  clean="$(tr -d ' \n\r')"
  [[ "$clean" =~ ^([0-9a-fA-F]{2})*$ ]] || die "input is not valid hex"

  if command -v xxd >/dev/null 2>&1; then
    printf '%s' "$clean" | xxd -r -p
  else
    # fallback: take 2 digits at a time and print that byte
    printf '%s' "$clean" | fold -w2 | while read -r h || [[ -n "$h" ]]; do
      printf "\\x$h"
    done
  fi
}
