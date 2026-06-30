open Core
open Lib

let test_headline_regex =
  Re.Perl.re "(?:  \\[(OK)\\]  |> \\[(FAIL)\\])        (.*?)([0-9]+)   (.*)\\."
  |> Re.compile

let get_test_headlines lines =
  List.fold_left lines ~init:[] ~f:(fun acc cur ->
      match Re.exec_opt test_headline_regex cur with
      | None -> acc
      | Some m ->
          let test_suite = String.strip (Re.Group.get m 3) in
          let index = Int.of_string (Re.Group.get m 4) in
          let name = Re.Group.get m 5 in
          let success =
            match Re.Group.get_opt m 1 with Some _ -> true | _ -> false
          in
          let open Test_headline in
          { test_suite; index; name; success } :: acc)
  |> List.rev

let get_test_log_root lines length =
  let line = List.nth_exn lines (length - 2) in
  let path_string = String.slice line 22 (String.length line - 2) in
  match Fpath.of_string path_string with
  | Ok p -> First p
  | Error (`Msg m) -> Second m

let run input =
  let lines = String.split_lines input in
  let length = List.length lines in
  let test_log_root_opt = get_test_log_root lines length in
  match test_log_root_opt with
  | Second err -> failwith err
  | First test_log_root ->
      let test_headlines = get_test_headlines lines in
      let test_report =
        Test_report.test_report_of_test_headline_list test_headlines
          test_log_root
      in
      printf "%s" (Test_report.string_of_test_report test_report)

let params =
  let open Command.Param in
  anon ("input" %: string)

let command =
  Command.basic ~summary:"Process Alcotest output"
    ~readme:(fun () -> "Todo")
    (Command.Param.map params ~f:(fun input () -> run input))

let () = Command_unix.run ~version:"1.0" ~build_info:"RWO" command
