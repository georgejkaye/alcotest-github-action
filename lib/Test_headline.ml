type test_headline = {
  test_suite : string;
  index : int;
  name : string;
  success : bool;
}
[@@deriving show, make]

let string_of_test_headline th =
  let success_string = if th.success then "PASS" else "FAIL" in
  [%string
    "%{th.test_suite}:%{Int.to_string th.index} - %{th.name} - \
     %{success_string}"]

let log_path_of_test_headline th log_root =
  let test_index_string =
    let index_string = Int.to_string th.index in
    if String.length index_string < 2 then [%string "00%{index_string}"]
    else if String.length index_string < 3 then [%string "0%{index_string}"]
    else index_string
  in
  let log_file_basename =
    [%string "%{th.test_suite}.%{test_index_string}.output"]
  in
  let open Fpath in
  log_root / log_file_basename
