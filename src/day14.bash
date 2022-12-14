#!/bin/bash

set -euo pipefail

parse_input() {
  jq -sRc -f <(cat <<EOF
split("\n")
| map(
  select(. != "")
  | split(" -> ")
  | map(
    capture("^(?<x>[0-9]+),(?<y>[0-9]+)\$") | map_values(tonumber)
  )
)
EOF
)
}

build_map() {
  jq -c -f <(cat <<EOF
def line_to(\$p2):
  . as \$p1
  | [
    if \$p1.x == \$p2.x then
      range(((\$p1.y - \$p2.y) | fabs) + 1)
      | { x: \$p1.x, y: (([\$p1.y, \$p2.y] | min) + .) }
    else
      range(((\$p1.x - \$p2.x) | fabs) + 1)
      | { x: (([\$p1.x, \$p2.x] | min) + .), y: \$p1.y }
    end
  ];

(flatten | . + [{x:500,y:0}] | [(map(.x) | min, max), (map(.y) | min, max)]) as \$borders
| (
  map(
    [
      foreach .[1:][] as \$p2(
        {p1: .[0], line: null};
        {p1: \$p2 , line: (.p1 | line_to(\$p2))};
        .line
      )
    ]
  )
  | flatten
  | unique
  | map({key: . | @json, value: true})
  | from_entries
) as \$rocks
| (\$borders[3] - \$borders[2] + 2) as \$h
| ([\$borders[0], 500 - \$h] | min) as \$minx
| ([\$borders[1], 500 + \$h] | max) as \$maxx
| [
  range(\$borders[2]; \$borders[3] + 2)
  | . as \$y
  | [
    range(\$minx; \$maxx + 1)
    | . as \$x
    | if (\$rocks | has(({x: \$x, y: \$y}) | @json)) then "#" else "." end
  ]
]
| {
  map: .
  , xoffset: \$minx
  , yoffset: \$borders[2]
}
EOF
)
}

render_state() {
  jq -r --argjson start "$1" -f <(cat <<EOF
. as {\$rocks, \$obstructions, \$path}
| (\$obstructions | keys | map(fromjson) | . + [\$start] | [(map(.x) | min, max), (map(.y) | min, max)]) as \$borders
| (\$path | map({key: (. | @json), value: true}) | from_entries) as \$pathset
| [
  range(\$borders[2]; \$borders[3] + 1)
  | . as \$y
  | [
    range(\$borders[0]; \$borders[1] + 1)
    | {x:., y:\$y} as \$p
    | if \$p == \$start then
      "+"
    elif (\$rocks | has(\$p | @json)) then
      "#"
    elif (\$obstructions | has(\$p | @json)) then
      "o"
    elif (\$pathset | has(\$p | @json)) then
      "~"
    else
      "."
    end
  ]
  | join("")
]
| join("\n")
EOF
)
}

declare -g pour_sand_def
pour_sand_def=$(cat <<EOF
def pour_sand(\$start; \$floory):
  def isopen(\$map):
    . as {\$x, \$y}
    | ((\$map[\$y] // []) | .[\$x]) == ".";
  def loop(\$path; \$map; \$sands):
    \$path[0] as \$p
    | if (\$path | length) == 0 or \$p.y > \$floory then
      {path: \$path, map: \$map, sands: \$sands}
    else
      [
        limit(1;
          0, -1, 1
          | {x: (\$p.x + .), y: (\$p.y + 1)}
          | select(isopen(\$map))
        )
      ]
      | if length == 1 then
        loop(. + \$path; \$map; \$sands)
      else
        loop(\$path[1:]; \$map | .[\$p.y][\$p.x] = "o"; \$sands + 1)
      end
    end;
  . + loop([\$start]; .map; 0);
EOF
)

part1() {
  parse_input | build_map | jq -cr -f <(cat <<EOF
$pour_sand_def
pour_sand({x: (500 - .xoffset), y: (0 - .yoffset)}; (.map | length) - 2)
| .sands
EOF
)
}

part2() {
  parse_input | build_map | jq -cr -f <(cat <<EOF
$pour_sand_def
pour_sand({x: (500 - .xoffset), y: (0 - .yoffset)}; .map | length)
| .sands
EOF
)
}
