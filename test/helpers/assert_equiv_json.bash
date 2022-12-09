assert_equiv_json() {
  actual=$1
  expected=$2
  actual_fmt=$(jq -cS . <<< "$actual")
  expected_fmt=$(jq -cS . <<< "$expected")
  if [ "${actual_fmt}" = "${expected_fmt}" ]; then
    return 0
  else
    echo "actual: ${actual_fmt}" &1>2
    echo "expected: ${expected_fmt}" &1>2
    return 1
  fi
}
