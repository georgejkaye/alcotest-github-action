open! Core
open! Lib
module File_wrapper = Helpers.Test_file_wrapper
module Report = Parser.Report.Make (File_wrapper)
module Testable_report = Helpers.Testable.Report (File_wrapper)

let ( / ) = Fpath.( / )
let timestamp_fmt = "%Y-%m-%dT%H:%M:%s"

let of_test_headlines () =
  let test_log_1 = "test output 1" in
  let test_log_2 = "test output 2" in
  let test_trace_2 =
    "Raised at Alcotest_engine__Test.check in file \"test/file.ml, lines \
     100-234, characters 4-19\n\
     Called from Dune__exe__Test in file \"test/test_files/types.ml\", lines \
     19-28, characters 2-50"
  in
  let test_log_3 = "test output 3" in
  let test_trace_3 =
    "Raised at Alcotest_engine__Test.check in file \"test/file.ml, lines \
     216-226, characters 4-19\n\
     Called from Dune__exe__Test in file \"test/test_files/types.ml\", lines \
     10-12, characters 2-50"
  in
  let test_log_4 = "test output 4" in
  let log_root = Fpath.v "/test/log/path/_build/_tests/123456" in
  let fs =
    File_wrapper.init_state
    |> File_wrapper.write_file
         ~path:(log_root / "test_suite_1.001.output")
         ~contents:test_log_1
    |> File_wrapper.write_file
         ~path:(log_root / "test_suite_1.002.output")
         ~contents:
           (String.concat ~sep:"\n" [ test_log_2; ""; ""; test_trace_2 ])
    |> File_wrapper.write_file
         ~path:(log_root / "test_suite_2.001.output")
         ~contents:
           (String.concat ~sep:"\n" [ test_log_3; ""; ""; test_trace_3 ])
    |> File_wrapper.write_file
         ~path:(log_root / "test_suite_2.002.output")
         ~contents:test_log_4
  in
  let name = "test_run" in
  let id = "123456" in
  let start_timestamp =
    Time_float_unix.parse ~fmt:timestamp_fmt "2026-09-14T21:20:09"
      ~zone:Time_float_unix.Zone.utc
  in
  let end_timestamp =
    Time_float_unix.parse ~fmt:timestamp_fmt "2026-09-14T21:20:17"
      ~zone:Time_float_unix.Zone.utc
  in
  let version = "1.9.1" in
  let headline1 =
    Parser.Headline.make ~test_suite:"test_suite_1" ~index:1 ~name:"test_1"
      ~success:true
  in
  let headline2 =
    Parser.Headline.make ~test_suite:"test_suite_1" ~index:2 ~name:"test_2"
      ~success:false
  in
  let headline3 =
    Parser.Headline.make ~test_suite:"test_suite_2" ~index:1 ~name:"test_3"
      ~success:false
  in
  let headline4 =
    Parser.Headline.make ~test_suite:"test_suite_2" ~index:2 ~name:"test_4"
      ~success:true
  in
  let headlines = [ headline1; headline2; headline3; headline4 ] in
  let tests =
    [
      Parser.Test.make ~name:"test_1" ~suite:"test_suite_1" ~index:1
        ~success:true ~log:test_log_1 ~trace:None;
      Parser.Test.make ~name:"test_2" ~suite:"test_suite_1" ~index:2
        ~success:false ~log:test_log_2 ~trace:(Some test_trace_2);
      Parser.Test.make ~name:"test_3" ~suite:"test_suite_2" ~index:1
        ~success:false ~log:test_log_3 ~trace:(Some test_trace_3);
      Parser.Test.make ~name:"test_4" ~suite:"test_suite_2" ~index:2
        ~success:true ~log:test_log_4 ~trace:None;
    ]
  in
  let expected =
    Report.make ~name ~id ~version ~start_timestamp ~end_timestamp ~count:4
      ~passed:2 ~failed:2 ~suites:2 ~tests ()
  in
  let result =
    Report.of_test_headlines fs ~name ~id ~start_timestamp ~end_timestamp
      ~version ~log_root headlines
  in
  Alcotest.check Testable_report.report "of_test_headlines" expected result

let tests =
  ( "Parser.Report",
    [ Alcotest.test_case "of_test_headlines" `Quick of_test_headlines ] )
