# Shared helpers

die() {
  echo "Error: $*" >&2
  exit 1
}

# Lists every method that has an *_encode function
list_methods() {
  declare -F | awk '{print $3}' | grep '_encode$' | sed 's/_encode$//' | tr '\n' ' '
}
