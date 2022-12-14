setup() {
  source "./src/day14.bash"
  source "./test/helpers/assert_equiv_json.bash"
}

@test "day14 parse_input" {
  run parse_input < "./test/inputs/day14.txt"
  [ "$status" -eq 0 ]
  expected='[[{"x":498,"y":4},{"x":498,"y":6},{"x":496,"y":6}],[{"x":503,"y":4},{"x":502,"y":4},{"x":502,"y":9},{"x":494,"y":9}]]'
  assert_equiv_json "$output" "$expected"
}

@test "day14 part1" {
  run part1 < ./test/inputs/day14.txt
  [ "$status" -eq 0 ]
  [ "$output" -eq 24 ]
}

@test "day14 part2" {
  run part2 < ./test/inputs/day14.txt
  [ "$status" -eq 0 ]
  [ "$output" -eq 93 ]
}
