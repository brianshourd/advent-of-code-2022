#!/bin/bash

set -euo pipefail

declare -g heights
heights=$(jq -cn '
  "abcdefghijklmnopqrstuvwxyz" | split("") | with_entries({key: .value, value: .key})
')

parse_input() {
  jq -sRc \
    --argjson heights "$heights" \
    -f <(cat <<EOF
split("\n")
| map(
  select(. != "")
  | split("")
)
| { map: ., x: 0, y: 0, start: null, end: null }
| until(
  (.start != null) and (.end != null) and (.x == 0) and (.y == 0);
  if (.map[.y][.x] == "S") then
    .start = [.x, .y]
    | .map[.y][.x] = \$heights["a"]
  elif (.map[.y][.x] == "E") then
    .end = [.x, .y]
    | .map[.y][.x] = \$heights["z"]
  else
    .map[.y][.x] |= \$heights[.]
  end
  | .x = (.x + 1) % (.map[0] | length)
  | .y = (.y + 1) % (.map | length)
)
| { map: .map, start: .start, end: .end }
EOF
)
}

impl() {
  jq \
    --argjson starts "$1" \
    -f <(cat <<EOF
. += {
  done: false
  , paths: \$starts
  , found: (\$starts | map({key: @json, value: true}) | from_entries)
  , steps: 0
}
| (.map[0] | length) as \$w
| (.map | length) as \$h
| until(
  .done or (.paths | length) == 0;
  . as \$acc
  | .paths |= (
    map(
      . as [\$x, \$y]
      | [.[0] + 1, .[1]]
      , [.[0] - 1, .[1]]
      , [.[0], .[1] + 1]
      , [.[0], .[1] - 1]
      | if .[0] < 0 or .[0] >= \$w or .[1] < 0 or .[1] >= \$h then empty else . end
      | if (\$acc.found[. | @json] // false) then empty else . end
      | if \$acc.map[.[1]][.[0]] - \$acc.map[\$y][\$x] > 1 then empty else . end
    )
    | unique
  )
  | .steps |= . + 1
  | .found = .found + (.paths | map({key: @json, value: true}) | from_entries)
  | if (.found[\$acc.end | @json] // false) then .done = true else . end
)
| .steps
EOF
)
}

part1() {
  declare input
  input=$(parse_input)
  impl $(jq -c '[.start]' <<< "$input") <<< "$input"
}

part2() {
  declare input
  input=$(parse_input)
  declare starts
  starts=$(jq -c -f <(cat <<EOF
.map as \$map
| [
  range(\$map[0] | length)
  | . as \$x
  | range(\$map | length)
  | . as \$y
  | select(\$map[\$y][\$x] == 0)
  | [\$x, \$y]
]
EOF
) <<< "$input")
  impl "$starts" <<< "$input"
}
