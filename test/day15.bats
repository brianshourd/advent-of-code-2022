setup() {
  source "./src/day15.bash"
  source "./test/helpers/assert_equiv_json.bash"
}

@test "day15 parse_input" {
  input=$(cat <<EOF
Sensor at x=2, y=18: closest beacon is at x=-2, y=15
Sensor at x=9, y=16: closest beacon is at x=10, y=16
EOF
)
  run parse_input <<< "${input}"
  [ "$status" -eq 0 ]
  expected='[{"s":{"x":2,"y":18},"b":{"x":-2,"y":15}},{"s":{"x":9,"y":16},"b":{"x":10,"y":16}}]'
  assert_equiv_json "$output" "$expected"
}

@test "day15 part1" {
  run part1 10 < ./test/inputs/day15.txt
  [ "$status" -eq 0 ]
  [ "$output" -eq 26 ]
}

@test "day15 part2" {
  run part2 0 20 < ./test/inputs/day15.txt
  [ "$status" -eq 0 ]
  [ "$output" -eq 56000011 ]
}
