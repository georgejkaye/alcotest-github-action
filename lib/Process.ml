module Make (F : Util.Wrapper.File_wrapper.Interface) = struct
  open! Util.Json

  module Root =
    Ctrf.Root.MakeWithNoExtras (Ctrf.Object.Empty) (Ctrf.Object.Empty)

  module Report = Parser.Report.Make (F)

  let run fs ~alcotest_input_path ~build_root_dir ~ctrf_output_path
      ~start_timestamp ~end_timestamp ~alcotest_version =
    match F.read_file fs alcotest_input_path with
    | Second msg -> failwith msg
    | First test_output -> (
        match Parser.Output.get_id test_output with
        | Second msg -> failwith msg
        | First test_run_id ->
            let test_run_name =
              match Parser.Output.get_name test_output with
              | First name -> name
              | Second _ -> "Test run"
            in
            let test_log_root =
              Parser.Paths.get_test_logs_root_path ~build_root_dir test_run_id
            in
            let test_headlines = Parser.Output.get_test_headlines test_output in
            let test_report =
              Report.of_test_headlines fs ~name:test_run_name ~id:test_run_id
                ~start_timestamp ~end_timestamp ~version:alcotest_version
                ~log_root:test_log_root test_headlines
            in
            F.write_file fs ~path:ctrf_output_path
              ~contents:
                (Report.to_ctrf test_report
                |> Root.to_yojson
                |> Yojson.remove_nulls
                |> Yojson.Safe.to_string))
end
