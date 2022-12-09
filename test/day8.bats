setup() {
  source "./src/day8.bash"
}

@test "day8 part 1" {
  run part1 < ./test/inputs/day8.txt
  [ "$status" -eq 0 ]
  [ "$output" -eq 21 ]
}

@test "day8 part 2" {
  run part2 < ./test/inputs/day8.txt
  [ "$status" -eq 0 ]
  [ "$output" -eq 8 ]
}
