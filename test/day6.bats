setup() {
  source "./src/day6.bash"
}

@test "day6 part 1 test 1" {
  run part1 < <(echo -n "mjqjpqmgbljsphdztnvjfqwrcgsmlb")
  [ "$status" -eq 0 ]
  [ "$output" -eq 7 ]
}

@test "day6 part 1 test 2" {
  run part1 < <(echo -n "bvwbjplbgvbhsrlpgdmjqwftvncz")
  [ "$status" -eq 0 ]
  [ "$output" -eq 5 ]
}

@test "day6 part 1 test 3" {
  run part1 < <(echo -n "nppdvjthqldpwncqszvftbrmjlhg")
  [ "$status" -eq 0 ]
  [ "$output" -eq 6 ]
}

@test "day6 part 1 test 4" {
  run part1 < <(echo -n "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg")
  [ "$status" -eq 0 ]
  [ "$output" -eq 10 ]
}

@test "day6 part 1 test 5" {
  run part1 < <(echo -n "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw")
  [ "$status" -eq 0 ]
  [ "$output" -eq 11 ]
}

@test "day6 part 1 test 6" {
  run part1 < <(echo -n "abcdefghijklmnopqrstuvwxyz")
  [ "$status" -eq 0 ]
  [ "$output" -eq 4 ]
}

@test "day6 part 2 test 1" {
  run part2 < <(echo -n "mjqjpqmgbljsphdztnvjfqwrcgsmlb")
  [ "$status" -eq 0 ]
  [ "$output" -eq 19 ]
}

@test "day6 part 2 test 2" {
  run part2 < <(echo -n "bvwbjplbgvbhsrlpgdmjqwftvncz")
  [ "$status" -eq 0 ]
  [ "$output" -eq 23 ]
}

@test "day6 part 2 test 3" {
  run part2 < <(echo -n "nppdvjthqldpwncqszvftbrmjlhg")
  [ "$status" -eq 0 ]
  [ "$output" -eq 23 ]
}

@test "day6 part 2 test 4" {
  run part2 < <(echo -n "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg")
  [ "$status" -eq 0 ]
  [ "$output" -eq 29 ]
}

@test "day6 part 2 test 5" {
  run part2 < <(echo -n "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw")
  [ "$status" -eq 0 ]
  [ "$output" -eq 26 ]
}
