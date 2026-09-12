module Headline = Lib.Parser.Headline

let log_root = Fpath.v "/test/log/root"

let to_log_path_single_digit_index () =
  let headline =
    Headline.make ~test_suite:"Test_suite" ~index:1 ~name:"test" ~success:true
  in
  let result = Headline.to_log_path headline log_root in
  let expected = Fpath.v "/test/log/root/Test_suite.001.output" in
  Alcotest.check Helpers.Testable.fpath "to_log_path" result expected

let to_log_path_double_digit_index () =
  let headline =
    Headline.make ~test_suite:"Test_suite" ~index:11 ~name:"test" ~success:true
  in
  let result = Headline.to_log_path headline log_root in
  let expected = Fpath.v "/test/log/root/Test_suite.011.output" in
  Alcotest.check Helpers.Testable.fpath "to_log_path" result expected

let to_log_path_triple_digit_index () =
  let headline =
    Headline.make ~test_suite:"Test_suite" ~index:111 ~name:"test" ~success:true
  in
  let result = Headline.to_log_path headline log_root in
  let expected = Fpath.v "/test/log/root/Test_suite.111.output" in
  Alcotest.check Helpers.Testable.fpath "to_log_path" result expected

let tests =
  ( "Parser.Headline",
    [
      Alcotest.test_case "to_log_path_single_digit_index" `Quick
        to_log_path_single_digit_index;
      Alcotest.test_case "to_log_path_double_digit_index" `Quick
        to_log_path_double_digit_index;
      Alcotest.test_case "to_log_path_triple_digit_index" `Quick
        to_log_path_triple_digit_index;
    ] )
