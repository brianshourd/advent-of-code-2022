#!/bin/bash

set -euo pipefail

parse_input() {
  jq -sRc \
    --argjson directions '{"R":[1,0],"U":[0,1],"L":[-1,0],"D":[0,-1]}' \
    -f <(cat <<EOF
split("\n")
| map(
  capture("^(?<d>[DLRU]) (?<n>[0-9]+)\$")
  | {d: \$directions[.d], n: .n | tonumber}
)
EOF
)
}

build_update_map() {
  jq -nc -f <(cat <<EOF
{
  "[0,0]": [0,0],
  "[1,0]": [0,0],
  "[-1,0]": [0,0],
  "[0,1]": [0,0],
  "[0,-1]": [0,0],
  "[2,0]": [1,0],
  "[-2,0]": [-1,0],
  "[0,2]": [0,1],
  "[0,-2]": [0,-1],
  "[2,1]": [1,1],
  "[2,-1]": [1,-1],
  "[-2,1]": [-1,1],
  "[-2,-1]": [-1,-1],
  "[1,2]": [1,1],
  "[-1,2]": [-1,1],
  "[1,-2]": [1,-1],
  "[-1,-2]": [-1,-1],
  "[2,2]": [1,1],
  "[2,-2]": [1,-1],
  "[-2,2]": [-1,1],
  "[-2,-2]": [-1,-1]
}
EOF
)
}

follow_tail() {
  jq \
    --argjson numknots "$1" \
    --argjson updatemap "$(build_update_map)" \
    -f <(cat <<EOF
def get_new_tpos(\$tpos):
  \$updatemap[[.[0] - \$tpos[0], .[1] - \$tpos[1]] | @json] as \$tpos_shift
  | [\$tpos[0] + \$tpos_shift[0], \$tpos[1] + \$tpos_shift[1]];
map(. as \$i | [range(\$i.n) | \$i.d])
| flatten(1)
| reduce .[] as \$i (
  { visits: {"[0,0]": 1}, knots: [range(\$numknots) | [0,0]] };
  . as { visits: \$visits, knots: \$knots }
  | [.knots[0][0] + \$i[0], .knots[0][1] + \$i[1]] as \$nhpos
  | [
    foreach .knots[1:][] as \$tpos(
      \$nhpos;
      get_new_tpos(\$tpos)
    )
  ]
  | {
    knots: ([\$nhpos] + .),
    visits: (
      .[-1] as \$t
      | \$visits
      | .[\$t | @json] |= (. // 0) + 1
    )
  }
)
| .visits
| length
EOF
)
}

part1() {
  parse_input | follow_tail 2
}

part2() {
  parse_input | follow_tail 10
}
