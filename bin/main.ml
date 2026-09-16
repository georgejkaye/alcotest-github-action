open Core
open Fpath
open! Lib.Util.Datetime
module File_wrapper = Lib.Util.Wrapper.File_wrapper.System
module Process = Lib.Process.Make (File_wrapper)

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
  Command.basic ~summary:"Process Parser.output"
    ~readme:(fun () -> "Todo")
    (let%map_open.Command alcotest_input_path_string =
       anon ("alcotest_input_path" %: string)
     and ctrf_output_path = anon ("test_summary_output_path" %: string)
     and start_timestamp = anon ("start_timestamp" %: string)
     and end_timestamp = anon ("end_timestamp" %: string)
     and alcotest_version = anon ("alcotest_version" %: string)
     and build_root_dir = anon (maybe ("build_root_dir" %: string)) in
     fun () ->
       let _ =
         Process.run File_wrapper.init_state
           ~alcotest_input_path:
             (path_of_string_arg_exn ~arg_name:"alcotest_input_path"
                alcotest_input_path_string)
           ~build_root_dir:
             (match build_root_dir with
             | Some p ->
                 if String.is_empty p then None
                 else Some (path_of_string_arg_exn ~arg_name:"build_root_dir" p)
             | None -> None)
           ~ctrf_output_path:
             (path_of_string_arg_exn ~arg_name:"test_summary_output_path"
                ctrf_output_path)
           ~start_timestamp:(datetime_of_string_arg_exn start_timestamp)
           ~end_timestamp:(datetime_of_string_arg_exn end_timestamp)
           ~alcotest_version
       in
       ())

let () = Command_unix.run ~version:"1.0" command
