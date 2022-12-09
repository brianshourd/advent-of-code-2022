setup() {
  source "./src/day2.bash"
}

@test "day2 puzzle 1" {
  run part1 < './test/inputs/day2.txt'
  [ "$status" -eq 0 ]
  [ "$output" = "15" ]
}

@test "day2 puzzle 2" {
  run part2 < './test/inputs/day2.txt'
  [ "$status" -eq 0 ]
  [ "$output" = "12" ]
}
