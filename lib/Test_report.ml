open Core
open Yojson

type t = { name : string; id : string; suites : Test_suite.t list }

let string_of_test_report tr =
  List.fold tr.suites ~init:[] ~f:(fun acc cur ->
      acc @ Test_suite.to_strings cur)
  |> String.concat ~sep:"\n"

let get_test_log_content th log_root =
  let log_path = Test_headline.log_path_of_test_headline th log_root in
  match File.read_file log_path with
  | Second msg -> msg
  | First content -> content

let of_test_headlines ~name ~id (ths : Test_headline.t list) log_root =
  List.fold (List.rev ths) ~init:[] ~f:(fun acc cur ->
      let log_content = get_test_log_content cur log_root in
      let cur_test_suite = cur.test_suite in
      let cur_success = cur.success in
      let test_case : Test_case.t =
        {
          name = cur.name;
          index = cur.index;
          success = cur.success;
          log = log_content;
        }
      in
      let updated, updated_acc =
        List.fold_left acc ~init:(false, [])
          ~f:(fun (updated_ind, acc) test_suite ->
            let updated_ind, updated_test_suite =
              let open Test_suite in
              if String.equal test_suite.name cur_test_suite then
                let suite : Test_suite.t =
                  {
                    name = test_suite.name;
                    successes =
                      (if cur_success then test_suite.successes + 1
                       else test_suite.successes);
                    failures =
                      (if cur_success then test_suite.failures
                       else test_suite.failures + 1);
                    tests = test_case :: test_suite.tests;
                  }
                in
                (true, suite)
              else (false, test_suite)
            in
            (updated_ind, updated_test_suite :: acc))
      in
      if updated then updated_acc
      else
        {
          name = cur.test_suite;
          successes = (if cur_success then 1 else 0);
          failures = (if cur_success then 0 else 1);
          tests = [ test_case ];
        }
        :: updated_acc)
  |> List.rev
  |> fun suites -> { name; id; suites }

let to_json tr =
  `Assoc
    [
      ("name", `String tr.name);
      ("id", `String tr.id);
      ( "suites",
        `List
          (List.map tr.suites ~f:(fun suite ->
               `Assoc
                 [
                   ("name", `String suite.name);
                   ("pass", `Int suite.successes);
                   ("fail", `Int suite.failures);
                   ( "tests",
                     `List
                       (List.map suite.tests ~f:(fun test ->
                            `Assoc
                              [
                                ("index", `Int test.index);
                                ("name", `String test.name);
                                ("pass", `Bool test.success);
                                ("output", `String test.log);
                              ])) );
                 ])) );
    ]
