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

let get_test_logs_root_path lines length original_root =
  let line = List.nth_exn lines (length - 2) in
  let path_string = String.slice line 22 (String.length line - 2) in
  match Fpath.of_string path_string with
  | Ok p -> (
      match Fpath.relativize p ~root:original_root with
      | Some q -> First q
      | None ->
          Second
            [%string
              "Could not find %{Fpath.to_string original_root} in \
               %{Fpath.to_string p}"])
  | Error (`Msg m) -> Second m

let run dune_runtest_input_path dune_runtest_root_path test_summary_output_path
    =
  match File.read_file dune_runtest_input_path with
  | Second msg -> failwith msg
  | First test_output -> (
      let lines = String.split_lines test_output in
      let length = List.length lines in
      match get_test_logs_root_path lines length dune_runtest_root_path with
      | Second err -> failwith err
      | First test_log_root ->
          let test_headlines = get_test_headlines lines in
          let test_report =
            Test_report.of_test_headlines test_headlines test_log_root
          in
          File.write_file test_summary_output_path
            (Yojson.to_string (Test_report.to_json test_report)))

let params =
  let open Command.Param in
  both (anon ("output" %: string)) (anon ("input" %: string))

let path_of_string_arg_exn ?(arg_name = "") path =
  let argument_name_string =
    match arg_name with "" -> "" | name -> [%string " %{name}"]
  in
  match Fpath.of_string path with
  | Ok path -> path
  | Error (`Msg error) ->
      failwith
        [%string
          "Error when parsing argument%{argument_name_string} (%{path}): \
           %{error}"]

let command =
  Command.basic ~summary:"Process Alcotest output"
    ~readme:(fun () -> "Todo")
    (let%map_open.Command dune_runtest_input_path_string =
       anon ("dune_runtest_input_path" %: string)
     and dune_runtest_root_path_string =
       anon ("dune_runtest_root_path" %: string)
     and test_summary_output_path_string =
       anon ("test_summary_output_path" %: string)
     in
     fun () ->
       run
         (path_of_string_arg_exn ~arg_name:"dune_runtest_input_path"
            dune_runtest_input_path_string)
         (path_of_string_arg_exn ~arg_name:"dune_runtest_root_path"
            dune_runtest_root_path_string)
         (path_of_string_arg_exn ~arg_name:"test_summary_output_path"
            test_summary_output_path_string))

let () = Command_unix.run ~version:"1.0" command
