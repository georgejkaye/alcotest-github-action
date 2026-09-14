open! Core
open! Lib
module Paths = Parser.Paths

let get_test_logs_root_path () =
  let test_run_id = "123456" in
  let expected =
    {%string|./_build/default/test/_build/_tests/%{test_run_id}|}
  in
  let result = Paths.get_test_logs_root_path test_run_id in
  Alcotest.check Helpers.Testable.string "get_test_logs_root_path" expected
    (Fpath.to_string result)

let tests =
  ( "Parser.Paths",
    [
      Alcotest.test_case "get_test_logs_root_path" `Quick
        get_test_logs_root_path;
    ] )
