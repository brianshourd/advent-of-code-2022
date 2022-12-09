setup() {
  source "./src/day1.bash"
  source "./test/helpers/assert_equiv_json.bash"
}

@test "day1 input parsing" {
  run parse_input < './test/inputs/day1.txt'
  [ "$status" -eq 0 ]
  expected='[[1000,2000,3000],[4000],[5000,6000],[7000,8000,9000],[10000]]'
  assert_equiv_json "$output" "$expected"
}

@test "day1 puzzle 1" {
  run part1 < './test/inputs/day1.txt'
  [ "$status" -eq 0 ]
  [ "$output" = "24000" ]
}

@test "day1 puzzle 2" {
  run part2 < './test/inputs/day1.txt'
  [ "$status" -eq 0 ]
  [ "$output" = "45000" ]
}
