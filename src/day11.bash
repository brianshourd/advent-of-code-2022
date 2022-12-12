#!/bin/bash

set -euo pipefail

parse_input() {
  jq -sRc \
    -f <(cat <<EOF
def get_items: { items: .is | split(", ") | map(tonumber) };
def get_operation:
  if .op == "*" then
    if .a == "old" and .b == "old" then
      { kind: "square" }
    elif .a == "old" then
      { kind: "mult", factor: .b | tonumber }
    else
      empty
    end
  elif .op == "+" then
    { kind: "add", shift: .b | tonumber }
  else
    empty
  end
  | { operation: . };
def get_test: { test: { divisor: .d , iftrue: .ma, iffalse: .mb } | map_values(tonumber) };

split("\n\n")
| map(
  [
    ( capture("Starting items: (?<is>[0-9, ]+)\n") | get_items )
    , ( capture("Operation: new = (?<a>[^ ]+) (?<op>[*+]) (?<b>[^ \n]+)") | get_operation )
    , (
      capture("Test: divisible by (?<d>[0-9]+)\n +If true: throw to monkey (?<ma>[0-9]+)\n +If false: throw to monkey (?<mb>[0-9]+)")
      | get_test
    )
  ]
  | add
)
EOF
)
}

impl() {
  parse_input | \
    jq -c \
      --argjson part "$1" \
      --argjson numrounds "$2" \
      -f <(cat <<EOF
def repeat(f; \$n): if \$n > 0 then f | repeat(f; \$n - 1) else . end;
def do_turn(\$rules; \$modulus; \$turn):
  .inspections[\$turn] += (.items[\$turn] | length)
  | until(
    .items[\$turn][0] == null;
    \$rules[\$turn] as \$rule
    | (.items[\$turn][0]) as \$worry
    | (if \$rule.operation.kind == "mult" then
      \$worry * \$rule.operation.factor
    elif \$rule.operation.kind == "square" then
      \$worry * \$worry
    elif \$rule.operation.kind == "add" then
      \$worry + \$rule.operation.shift
    else
      0
    end) as \$worry
    | (\$worry % \$modulus) as \$worry
    | (if \$part == 1 then \$worry / 3 | floor else \$worry end) as \$worry
    | if \$worry % \$rule.test.divisor == 0 then
      .items[\$rule.test.iftrue] += [\$worry]
    else
      .items[\$rule.test.iffalse] += [\$worry]
    end
    | .items[\$turn] = .items[\$turn][1:]
  );
def do_round(\$rules; \$modulus):
  def _do_round(\$turn):
    if \$turn >= (\$rules | length) then
      .
    else
      do_turn(\$rules; \$modulus; \$turn) | _do_round(\$turn + 1)
    end;
  _do_round(0);

map(del(.items)) as \$rules
| { items: map(.items), inspections: [range(length) | 0] }
| (\$rules | map(.test.divisor) | reduce .[] as \$i(1; . * \$i)) as \$modulus
| repeat(do_round(\$rules; \$modulus); \$numrounds)
| .inspections
| sort
| .[-1] * .[-2]
EOF
)
}

part1() {
  impl 1 20
}

part2() {
  impl 2 10000
}
