#!/bin/bash

set -euo pipefail

parse_input() {
  jq -sRc \
    -f <(cat <<EOF
split("\n")
| map(
  limit(1;
    capture("^(?<kind>noop)\$")
    , (capture("^(?<kind>addx) (?<n>[-]?[0-9]+)\$") | {kind, n: .n | tonumber})
  )
)
EOF
)
}

impl() {
  parse_input | jq -c -f <(cat <<EOF
def get_val: .val = if (.x - .pos | fabs) <= 1 then "#" else " " end;
def up_pos(\$n): .pos += \$n | .pos %= 40;
[
  foreach .[] as \$i(
    { x: 1, pos: -1, val: null };
    if \$i.kind == "addx" then
      (up_pos(1) | get_val)
      , (up_pos(2) | get_val | .x += \$i.n)
    else
      up_pos(1) | get_val
    end
  )
]
EOF
)
}

part1() {
  impl | jq -f <(cat <<EOF
. as \$output
| [range(20; 221; 40)]
| map(. * (\$output[. - 2].x // 0))
| add
EOF
)
}

part2() {
  impl | jq -r -f <(cat <<EOF
map(.val)
| .[0:40], .[40:80], .[80:120], .[120:160], .[160:200], .[200:240]
| join("")
EOF
)
}
