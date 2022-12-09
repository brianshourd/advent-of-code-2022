#!/bin/bash

set -euo pipefail

show_usage() {
  cat <<EOF
Run tests:
  ./run.bash test
Run a problem
  ./run.bash <day> <part> < <input_file>
e.g.
  ./run.bash 5 2 < ./src/inputs/day5.txt
  # Do part 2 of day 5
EOF
}

if [ -z ${1:-} ]; then
  echo "ERROR: argument required"
  show_usage
  exit 1
fi

if [ "${1:-}" = "test" ]; then
  bats test/
elif [ "${1:-}" = "bats" ]; then
  bats ${@:2}
elif [ -f "src/day${1:-}.bash" ]; then
  source "src/day${1:-}.bash"
  if [ "${2:-}" = "1" ]; then
    part1
  elif [ "${2:-}" = "2" ]; then
    part2
  else
    echo "ERROR: argument required"
    show_usage
    exit 1
  fi
else
  show_usage
  exit 1
fi
