open Core
open Lib
open Fpath
open! Util.Json
open! Util.Datetime
module Root = Ctrf.Root.MakeWithNoExtras (Ctrf.Object.Empty) (Ctrf.Object.Empty)

let run ~alcotest_input_path ~ctrf_output_path ~start_timestamp ~end_timestamp
    ~alcotest_version =
  match File.read_file alcotest_input_path with
  | Second msg -> failwith msg
  | First test_output -> (
      match Alcotest.Output.get_id test_output with
      | Second msg -> failwith msg
      | First test_run_id -> (
          let test_run_name =
            match Alcotest.Output.get_name test_output with
            | First name -> name
            | Second _ -> "Test run"
          in
          match Alcotest.Paths.get_test_logs_root_path test_run_id with
          | Second err -> failwith err
          | First test_log_root ->
              let test_headlines =
                Alcotest.Output.get_test_headlines test_output
              in
              let test_report =
                Alcotest.Report.of_test_headlines ~name:test_run_name
                  ~id:test_run_id ~start_timestamp ~end_timestamp
                  ~version:alcotest_version test_headlines test_log_root
              in
              File.write_file ctrf_output_path
                (Alcotest.Report.to_ctrf test_report
                |> Root.to_yojson
                |> Yojson.remove_nulls
                |> Yojson.Safe.to_string)))

let params =
  let open Command.Param in
  both (anon ("output" %: string)) (anon ("input" %: string))

let get_argument_name_string = function
  | "" -> ""
  | name -> [%string " %{name}"]

let path_of_string_arg_exn ?(arg_name = "") path =
  let argument_name_string = get_argument_name_string arg_name in
  match Fpath.of_string path with
  | Ok path -> path
  | Error (`Msg error) ->
      failwith
        [%string
          "Error when parsing argument%{argument_name_string} (%{path}): \
           %{error}"]

let datetime_of_string_arg_exn ?(arg_name = "") arg =
  let argument_name_string = get_argument_name_string arg_name in
  match Time_float_unix.parse_result arg with
  | Ok datetime -> datetime
  | Error exn ->
      failwith
        [%string
          "Error when parsing argument %{argument_name_string} (%{arg}): \
           %{Exn.to_string exn}"]

let command =
  Command.basic ~summary:"Process Alcotest output"
    ~readme:(fun () -> "Todo")
    (let%map_open.Command alcotest_input_path_string =
       anon ("alcotest_input_path" %: string)
     and ctrf_output_path = anon ("test_summary_output_path" %: string)
     and start_timestamp = anon ("start_timestamp" %: string)
     and end_timestamp = anon ("end_timestamp" %: string)
     and alcotest_version = anon ("alcotest_version" %: string) in
     fun () ->
       run
         ~alcotest_input_path:
           (path_of_string_arg_exn ~arg_name:"alcotest_input_path"
              alcotest_input_path_string)
         ~ctrf_output_path:
           (path_of_string_arg_exn ~arg_name:"test_summary_output_path"
              ctrf_output_path)
         ~start_timestamp:(datetime_of_string_arg_exn start_timestamp)
         ~end_timestamp:(datetime_of_string_arg_exn end_timestamp)
         ~alcotest_version)

let () = Command_unix.run ~version:"1.0" command
