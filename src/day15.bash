#!/bin/bash

set -euo pipefail

parse_input() {
  jq -sRc -f <(cat <<EOF
split("\n")
| map(
  select(. != "")
  | capture("^Sensor at x=(?<sx>-?[0-9]+), y=(?<sy>-?[0-9]+): closest beacon is at x=(?<bx>-?[0-9]+), y=(?<by>-?[0-9]+)\$")
  | map_values(tonumber)
  | { s: { x: .sx, y: .sy }, b: { x: .bx, y: .by } }
)
EOF
)
}

part1() {
  declare -i line
  line=${1:-2000000}
  declare input
  input=$(parse_input)
  jq -cr \
    --argjson line "${line}" \
    -f <(cat <<EOF
def isect(\$y):
  (((.b.x - .s.x) | fabs) + ((.b.y - .s.y) | fabs)) as \$r
  | (\$r - (\$y - .s.y | fabs)) as \$a
  | if \$a < 0 then empty else [(.s.x - \$a), (.s.x + \$a + 1)] end;
(map(.b | select(.y == \$line) | .x) | unique | length) as \$beacons
| map(isect(\$line))
| sort_by(.[0])
| reduce .[1:][] as \$r (
  [.[0]];
  if .[0][1] >= \$r[0] then .[0][1] |= ([., \$r[1]] | max) else [\$r] + . end
)
| map(.[1] - .[0])
| add
| . - \$beacons
EOF
) <<< "${input}"
}

# This solution takes advantage of the statement that there is exactly one space
# where the unknown beacon could be, and the relatively small number of sensors.
# Each sensor and beacon describes a circle. The unknown beacon must lie on a
# circle one larger than one of these. Each pair of sensors then describes two
# such circles. With manhattan distance, each circle is actually four line
# segments, so discounting parallel lines, there are 8 possible intersections
# between two circles, and we can quickly filter to only those the proper
# distance from both centers (and with whole units). The `isects` function
# calculates these intersections.
# Technically, two manhattan circles can intersect in far more than two points
# if two (or more) of their sides are on the same line. In this instance, we can
# discount those, because even if the point in question lies on such a line, it
# must also intersect another circle, or else there would be more than one point
# in the final answer.
# With 32 sensors, so 496 pairs, up to 2 potential intersections per pair makes
# up to 992 potential points to check. Each must be checked against every
# (other) sensor to ensure that it is out of range, so up to 29760 checks. This
# is O(n^3) in the number of sensors n, but n is small so it's fine.
part2() {
  declare -i low
  declare -i high
  low=${1:-0}
  high=${2:-4000000}
  declare input
  input=$(parse_input)
  jq -cr \
    --argjson low "${low}" \
    --argjson high "${high}" \
    -f <(cat <<EOF
def inbounds: [(.x, .y) | . >= \$low and . <= \$high] | all;
def intp: [(.x, .y) | . == (. | floor)] | all;
def dist(\$p): ((.x - \$p.x) | fabs) + ((.y - \$p.y) | fabs);
def isects(\$circ):
  ([., \$circ], [\$circ, .]) as [\$c1, \$c2]
  | (-1, 1) as \$r1m
  | (-1, 1) as \$r2m
  | {
    x: ((\$r2m * \$c2.r + \$r1m * \$c1.r + \$c2.s.y - \$c1.s.y + \$c2.s.x + \$c1.s.x) / 2)
    , y: ((\$r2m * \$c2.r - \$r1m * \$c1.r + \$c2.s.y + \$c1.s.y + \$c2.s.x - \$c1.s.x) / 2)
  }
  | select(intp and dist(\$c1.s) == \$c1.r and dist(\$c2.s) == \$c2.r and inbounds);
(map(.r = (. as \$o | .s | dist(\$o.b)) + 1 | del(.b))) as \$input
| [
  range(0; \$input | length) as \$i
  | range(\$i + 1; \$input | length) as \$j
  | \$input[\$i]
  | isects(\$input[\$j])
]
| unique[]
| select(
  . as \$p
  | \$input
  | map((.s | dist(\$p)) >= .r)
  | all
)
| .x * 4000000 + .y
EOF
) <<< "${input}"
}
