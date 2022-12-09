#!/bin/bash

set -euo pipefail

parse_input() {
  jq -sRc \
    -f <(cat <<EOF
split("\n")
| reduce .[] as \$item (
  [[]];
  if \$item == "" then [[]] + . else .[0] += [\$item] end
)
| map(
  select(length > 0)
  | map(tonumber)
)
| reverse
EOF
)
}

part1() {
  parse_input | jq 'map(add) | max'
}

part2() {
  parse_input | jq 'map(add) | sort_by(0 - .)[0:3] | add'
}
