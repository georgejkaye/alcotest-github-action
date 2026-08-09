open Core
open Lib
open Fpath

let run dune_runtest_input_path test_summary_output_path =
  match File.read_file dune_runtest_input_path with
  | Second msg -> failwith msg
  | First test_output -> (
      match Test_run.get_id test_output with
      | Second msg -> failwith msg
      | First test_run_id -> (
          let test_run_name =
            match Test_run.get_name test_output with
            | First name -> name
            | Second _ -> "Test run"
          in
          match Test_run.get_test_logs_root_path test_run_id with
          | Second err -> failwith err
          | First test_log_root ->
              let test_headlines = Test_run.get_test_headlines test_output in
              let test_report =
                Test_report.of_test_headlines ~name:test_run_name
                  ~id:test_run_id test_headlines test_log_root
              in
              File.write_file test_summary_output_path
                (Yojson.to_string (Test_report.to_json test_report))))

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
     and test_summary_output_path_string =
       anon ("test_summary_output_path" %: string)
     in
     fun () ->
       run
         (path_of_string_arg_exn ~arg_name:"dune_runtest_input_path"
            dune_runtest_input_path_string)
         (path_of_string_arg_exn ~arg_name:"test_summary_output_path"
            test_summary_output_path_string))

let () = Command_unix.run ~version:"1.0" command
