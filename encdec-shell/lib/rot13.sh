# ROT13: shift each letter by 13 (digits and symbols stay the same).
# Encoding and decoding are the same operation.

rot13_encode() {
  tr 'A-Za-z' 'N-ZA-Mn-za-m'
}

rot13_decode() {
  rot13_encode
}
