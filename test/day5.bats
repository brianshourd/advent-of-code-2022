setup() {
  source "./src/day5.bash"
  source "./test/helpers/assert_equiv_json.bash"
}

@test "day5 parse input" {
  run parse_input < './test/inputs/day5.txt'
  [ "$status" -eq 0 ]
  expected=$(cat <<EOF
{
  "stacks": [
    ["Z", "N"],
    ["M", "C", "D"],
    ["P"]
  ],
  "instructions": [
    {"move": 1, "from": 2, "to": 1},
    {"move": 3, "from": 1, "to": 3},
    {"move": 2, "from": 2, "to": 1},
    {"move": 1, "from": 1, "to": 2}
  ]
}
EOF
)
  assert_equiv_json "$output" "$expected"
}

@test "day5 puzzle 1" {
  run part1 < './test/inputs/day5.txt'
  [ "$status" -eq 0 ]
  [ "$output" = "CMZ" ]
}

@test "day5 puzzle 2" {
  run part2 < './test/inputs/day5.txt'
  [ "$status" -eq 0 ]
  [ "$output" = "MCD" ]
}
