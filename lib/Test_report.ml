open Core

type test_run = { name : string; index : int; success : bool; log : string }

let string_of_test_run tr =
  let success_string = if tr.success then "PASS" else "FAIL" in
  [%string
    "%{Int.to_string tr.index}) %{tr.name}: %{success_string}\n\n%{tr.log}"]

type test_suite = {
  name : string;
  successes : int;
  failures : int;
  tests : test_run list;
}

let lines_of_test_suite ts =
  [%string
    "%{ts.name}: %{Int.to_string ts.successes}/%{Int.to_string (ts.successes + \
     ts.failures)}\n\n"]
  :: List.map ts.tests ~f:string_of_test_run

type test_report = { suites : test_suite list }

let string_of_test_report tr =
  List.fold tr.suites ~init:[] ~f:(fun acc cur -> acc @ lines_of_test_suite cur)
  |> String.concat ~sep:"\n"

let get_test_log_content th log_root =
  let log_path = Test_headline.log_path_of_test_headline th log_root in
  print_endline [%string "accessing %{Fpath.to_string log_path}"];
  match File.read_file log_path with
  | Second msg -> msg
  | First content -> content

let test_report_of_test_headline_list (ths : Test_headline.test_headline list)
    log_root =
  List.fold (List.rev ths) ~init:[] ~f:(fun acc cur ->
      let log_content = get_test_log_content cur log_root in
      let cur_test_suite = cur.test_suite in
      let cur_success = cur.success in
      let test_run =
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
              if String.equal test_suite.name cur_test_suite then
                ( true,
                  {
                    name = test_suite.name;
                    successes =
                      (if cur_success then test_suite.successes + 1
                       else test_suite.successes);
                    failures =
                      (if cur_success then test_suite.failures
                       else test_suite.failures + 1);
                    tests = test_run :: test_suite.tests;
                  } )
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
          tests = [ test_run ];
        }
        :: updated_acc)
  |> List.rev
  |> fun suites -> { suites }
