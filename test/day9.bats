setup() {
  source "./src/day9.bash"
}

@test "day9 part 1" {
  run part1 < ./test/inputs/day9.txt
  [ "$status" -eq 0 ]
  [ "$output" -eq 13 ]
}

@test "day9 part 2" {
  run part2 < ./test/inputs/day9.txt
  [ "$status" -eq 0 ]
  [ "$output" -eq 1 ]
}

@test "day9 part 2 ex 2" {
  run part2 < ./test/inputs/day9_2.txt
  [ "$status" -eq 0 ]
  [ "$output" -eq 36 ]
}
