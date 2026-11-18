#!/usr/bin/env bash
# Round-trip tests: encode, then decode, and compare with the original.

cd "$(dirname "$0")/.."
TOOL=./encdec.sh
pass=0; fail=0

check() {   # check <name> <expected> <actual>
  if [[ "$2" == "$3" ]]; then
    echo "PASS  $1"; pass=$((pass+1))
  else
    echo "FAIL  $1  (expected '$2', got '$3')"; fail=$((fail+1))
  fi
}

# --- known values ---
check "base64 encode" "SGVsbG8=" "$($TOOL encode -m base64 -t 'Hello')"
check "base64 decode" "Hello"    "$($TOOL decode -m base64 -t 'SGVsbG8=')"
check "hex encode"    "4869"     "$($TOOL encode -m hex -t 'Hi')"
check "binary encode" "01000001" "$($TOOL encode -m binary -t 'A' | tr -d ' ')"
check "rot13 encode"  "Uryyb"    "$($TOOL encode -m rot13 -t 'Hello')"

# --- round trips for text and numbers ---
for method in base64 hex binary rot13; do
  for input in "Hello World" "1234567890" "sp@cial !#\$ chars"; do
    enc="$($TOOL encode -m "$method" -t "$input")"
    dec="$($TOOL decode -m "$method" -t "$enc")"
    check "$method round-trip: $input" "$input" "$dec"
  done
done

# --- file round trips (text + random binary file) ---
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
cp examples/sample.txt "$tmp/text.bin"
head -c 300 /dev/urandom > "$tmp/random.bin"

for method in base64 hex binary; do
  for f in text.bin random.bin; do
    $TOOL encode -m "$method" -f "$tmp/$f"  -o "$tmp/enc" 2>/dev/null
    $TOOL decode -m "$method" -f "$tmp/enc" -o "$tmp/dec" 2>/dev/null
    if cmp -s "$tmp/$f" "$tmp/dec"; then
      echo "PASS  $method file round-trip: $f"; pass=$((pass+1))
    else
      echo "FAIL  $method file round-trip: $f"; fail=$((fail+1))
    fi
  done
done

# --- bad input must fail ---
if $TOOL decode -m hex -t "xyz" >/dev/null 2>&1; then
  echo "FAIL  invalid hex should fail"; fail=$((fail+1))
else
  echo "PASS  invalid hex is rejected"; pass=$((pass+1))
fi

echo; echo "Passed: $pass   Failed: $fail"
[[ $fail -eq 0 ]]
