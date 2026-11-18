#!/usr/bin/env bash
# A quick tour. Run from the project root:  ./examples/demo.sh
cd "$(dirname "$0")/.."

echo "== Text =="
./encdec.sh encode -m base64 -t "Hello World"; echo
./encdec.sh decode -m base64 -t "SGVsbG8gV29ybGQ="; echo

echo "== Numbers =="
./encdec.sh encode -m hex -t 2026; echo
./encdec.sh decode -m hex -t 32303236; echo

echo "== File: encode, then decode =="
./encdec.sh encode -m base64 -f examples/sample.txt -o /tmp/sample.b64
./encdec.sh decode -m base64 -f /tmp/sample.b64 -o /tmp/sample.out
cat /tmp/sample.out
