# Base64: text/file <-> A-Z a-z 0-9 + /

base64_encode() {
  base64 | tr -d '\n'     # one single line
}

base64_decode() {
  # GNU/Linux/new macOS use -d, older macOS uses -D
  if echo "YQ==" | base64 -d >/dev/null 2>&1; then
    base64 -d
  else
    base64 -D
  fi
}
