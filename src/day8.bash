#!/bin/bash

set -euo pipefail

parse_input() {
  jq -sRc 'split("\n") | map(select(. != "") | split("") | map(tonumber))'
}

part1() {
  parse_input \
    | jq -c -f <(cat <<EOF
def left_vis: map(
  [
    foreach .[] as \$h(
      [-1, null];
      [[.[0], \$h] | max, \$h > .[0]];
      .[1]
    )
  ]
);
[
  left_vis
  , (map(reverse) | left_vis | map(reverse))
  , (transpose | left_vis | transpose)
  , (transpose | map(reverse) | left_vis | map(reverse) | transpose)
]
| map(flatten)
| transpose
| map(any | select(.))
| length
EOF
)
}

part2() {
  parse_input \
    | jq -c -f <(cat <<EOF
def left_vis: map(
  [
    to_entries
    | foreach .[]  as {key: \$i, value: \$h}(
      {lasti: [range(10) | 0], out: 0};
      {
        lasti: (.lasti | .[\$h] |= \$i),
        out: (\$i - (.lasti[\$h:] | max))
      };
      .out
    )
  ]
);
[
  left_vis
  , (map(reverse) | left_vis | map(reverse))
  , (transpose | left_vis | transpose)
  , (transpose | map(reverse) | left_vis | map(reverse) | transpose)
]
| map(flatten)
| transpose
| map(reduce .[] as \$i(1; . * \$i))
| max
EOF
)
}
