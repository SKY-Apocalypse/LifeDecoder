# encdec-shell

A small, beginner-friendly **encoder / decoder** written in plain Bash.
It can encode and decode text, strings, numbers and whole files.

## Methods

| Method   | Example (`Hi`)       | Notes                              |
|----------|----------------------|------------------------------------|
| `base64` | `SGk=`               | default method                     |
| `hex`    | `4869`               | 2 hex digits per byte              |
| `binary` | `01001000 01101001`  | 8 bits per byte                    |
| `rot13`  | `Uv`                 | letters only; encode = decode      |

Numbers are treated as text, so `encode -t 2026` works with every method.

## Project layout

```
encdec-shell/
├── encdec.sh          # main command (parses options, picks the method)
├── lib/
│   ├── common.sh      # die() and list_methods()
│   ├── base64.sh      # base64_encode / base64_decode
│   ├── hex.sh         # hex_encode / hex_decode
│   ├── binary.sh      # binary_encode / binary_decode
│   └── rot13.sh       # rot13_encode / rot13_decode
├── tests/run_tests.sh # round-trip tests
├── examples/          # sample.txt and demo.sh
└── Makefile           # make test / make demo
```

## Usage

```bash
chmod +x encdec.sh

# text / string
./encdec.sh encode -m base64 -t "Hello World"
./encdec.sh decode -m base64 -t "SGVsbG8gV29ybGQ="

# numbers
./encdec.sh encode -m hex -t 12345

# from stdin
echo "secret" | ./encdec.sh encode -m binary

# files (input with -f, output with -o)
./encdec.sh encode -m base64 -f examples/sample.txt -o sample.enc
./encdec.sh decode -m base64 -f sample.enc -o sample.out
```

| Option | Meaning                                   |
|--------|-------------------------------------------|
| `-m`   | method (default `base64`)                 |
| `-t`   | text, string or number                    |
| `-f`   | read input from a file                    |
| `-o`   | write output to a file                    |
| `-h`   | help                                      |

## How it works

Every method is two small functions, `<method>_encode` and `<method>_decode`,
that **read stdin and write stdout**. `encdec.sh` builds the function name
(e.g. `hex` + `encode` -> `hex_encode`) and pipes the input into it.

## Add your own method

Create `lib/mymethod.sh` with `mymethod_encode()` and `mymethod_decode()`.
It is loaded automatically, no other changes needed.

## Run the tests

```bash
make test
```

Requires Bash 4+ and standard tools (`base64`, `od`, `tr`, `fold`).
