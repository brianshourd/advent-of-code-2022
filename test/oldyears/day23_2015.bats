setup() {
  source "./src/oldyears/day23_2015.bash"
}

@test "day23 part 1" {
  run part1 < ./test/oldyears/inputs/day23_2015.txt
  [ "$status" -eq 0 ]
  [ "$output" -eq 2 ]
}
