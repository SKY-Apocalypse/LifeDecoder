# Binary: every byte becomes 8 bits, separated by spaces ("A" -> 01000001)

binary_encode() {
  local n i bits
  for n in $(od -An -v -tu1); do          # n = byte value 0..255
    bits=""
    for i in 7 6 5 4 3 2 1 0; do
      bits+=$(( (n >> i) & 1 ))
    done
    printf '%s ' "$bits"
  done
}

binary_decode() {
  local b
  for b in $(cat); do
    [[ "$b" =~ ^[01]{1,8}$ ]] || die "invalid binary group: $b"
    printf "\\$(printf '%03o' "$((2#$b))")"   # bits -> number -> byte
  done
}
