module Datetime = Lib.Util.Datetime

let to_unix_timestamp () =
  let timestamp =
    Time_float_unix.parse ~fmt:"%Y-%m-%dT%H:%M:%S" "2026-09-14T21:20:09"
      ~zone:Time_float_unix.Zone.utc
  in
  let expected = 1789420809 in
  let result = Datetime.Time_float_unix.to_unix_timestamp timestamp in
  Alcotest.check Helpers.Testable.int "to_unix_timestamp" expected result

let parse_iso_result_ok () =
  let timestamp_string = "2026-09-14T21:20:09" in
  let expected =
    Ok
      (Time_float_unix.of_span_since_epoch
         (Time_float_unix.Span.of_sec 1789420809.))
  in
  let result = Datetime.Time_float_unix.parse_iso_result timestamp_string in
  Alcotest.check
    (Helpers.Testable.result Helpers.Testable.time_float_unix
       Helpers.Testable.exn)
    "parse_iso_result_ok" expected result

let parse_iso_result_ok_non_utc () =
  let timestamp_string = "2026-09-14T22:20:09" in
  let expected =
    Ok
      (Time_float_unix.of_span_since_epoch
         (Time_float_unix.Span.of_sec 1789420809.))
  in
  let result =
    Datetime.Time_float_unix.parse_iso_result timestamp_string
      ~zone:(Time_float_unix.Zone.of_utc_offset ~hours:1)
  in
  Alcotest.check
    (Helpers.Testable.result Helpers.Testable.time_float_unix
       Helpers.Testable.exn)
    "parse_iso_result_ok_non_utc" expected result

let parse_iso_result_error () =
  let timestamp_string = "2026-09-1421:20:09" in
  let expected = Error (Stdlib.Failure "unix_strptime: match failed") in
  let result = Datetime.Time_float_unix.parse_iso_result timestamp_string in
  Alcotest.check
    (Helpers.Testable.result Helpers.Testable.time_float_unix
       Helpers.Testable.exn)
    "parse_iso_result_error" expected result

let parse_iso () =
  let timestamp_string = "2026-09-14T21:20:09" in
  let expected =
    Time_float_unix.of_span_since_epoch
      (Time_float_unix.Span.of_sec 1789420809.)
  in
  let result = Datetime.Time_float_unix.parse_iso timestamp_string in
  Alcotest.check Helpers.Testable.time_float_unix "parse_iso" expected result

let parse_iso_non_utc () =
  let timestamp_string = "2026-09-14T22:20:09" in
  let expected =
    Time_float_unix.of_span_since_epoch
      (Time_float_unix.Span.of_sec 1789420809.)
  in
  let result =
    Datetime.Time_float_unix.parse_iso
      ~zone:(Time_float_unix.Zone.of_utc_offset ~hours:1)
      timestamp_string
  in
  Alcotest.check Helpers.Testable.time_float_unix "parse_iso_non_utc" expected
    result

let parse_iso_exn () =
  let timestamp_string = "2026-09-1421:20:09" in
  Alcotest.check_raises "parse_iso_exn"
    (Stdlib.Failure "unix_strptime: match failed") (fun () ->
      let _ = Datetime.Time_float_unix.parse_iso timestamp_string in
      ())

let tests =
  ( "Util.Datetime",
    [
      Alcotest.test_case "to_unix_timestamp" `Quick to_unix_timestamp;
      Alcotest.test_case "parse_iso_result_ok" `Quick parse_iso_result_ok;
      Alcotest.test_case "parse_iso_result_ok_non_utc" `Quick
        parse_iso_result_ok_non_utc;
      Alcotest.test_case "parse_iso_result_error" `Quick parse_iso_result_error;
      Alcotest.test_case "parse_iso" `Quick parse_iso;
      Alcotest.test_case "parse_iso_non_utc" `Quick parse_iso_non_utc;
      Alcotest.test_case "parse_iso_exn" `Quick parse_iso_exn;
    ] )
