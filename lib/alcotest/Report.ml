open! Core
open Core_unix
open Yojson
open! Util.Datetime

type t = {
  name : string;
  id : string;
  version : string;
  start_timestamp : Time_float_unix.t;
  end_timestamp : Time_float_unix.t;
  count : int;
  passed : int;
  failed : int;
  suites : int;
  tests : Test.t list;
}

let get_test_log_content th log_root =
  let log_path = Headline.to_log_path th log_root in
  match File.read_file log_path with
  | Second msg -> msg
  | First content -> content

module StringSet = Core.Set.Make (String)

let of_test_headlines ~name ~id ~start_timestamp ~end_timestamp ~version
    (ths : Headline.t list) log_root =
  List.fold (List.rev ths) ~init:(0, 0, 0, StringSet.empty, [])
    ~f:(fun (count, passed, failed, suites, acc) cur ->
      let log_content = get_test_log_content cur log_root in
      let cur_test_suite = cur.test_suite in
      let test : Test.t =
        {
          name = cur.name;
          suite = cur_test_suite;
          index = cur.index;
          success = cur.success;
          log = log_content;
        }
      in
      let new_passed, new_failed =
        if cur.success then (passed + 1, failed) else (passed, failed + 1)
      in
      let new_suites = Core.Set.add suites cur_test_suite in
      (count + 1, new_passed, new_failed, new_suites, test :: acc))
  |> fun (count, passed, failed, suites, acc) ->
  (count, passed, failed, suites, List.rev acc)
  |> fun (count, passed, failed, suites, tests) ->
  {
    name;
    id;
    version;
    start_timestamp;
    end_timestamp;
    count;
    passed;
    failed;
    suites = Set.length suites;
    tests;
  }

module Root = Ctrf.Root.MakeWithNoExtras (Ctrf.Object.Empty) (Ctrf.Object.Empty)

let to_ctrf_tool report =
  Root.Results.Tool.make ~name:"Alcotest" ~version:report.version ()

let to_ctrf_summary report =
  let start = Time_float_unix.to_unix_timestamp report.start_timestamp in
  let stop = Time_float_unix.to_unix_timestamp report.end_timestamp in
  Root.Results.Summary.make ~tests:report.count ~passed:report.passed
    ~failed:report.failed ~pending:0 ~skipped:0 ~other:0 ~flaky:0
    ~suites:report.suites ~start ~stop ~duration:(stop - start) ()

let to_ctrf_tests report =
  List.map report.tests ~f:(fun test ->
      Root.Results.Test.make ~name:test.name
        ~status:(if test.success then Passed else Failed)
        ~duration:0
        ~suite:(String.split ~on:'.' test.suite)
        ~message:test.log ())

let to_ctrf_environment report =
  let get_workflow_url =
    let server_url = Sys.getenv_exn "GITHUB_SERVER_URL" in
    let repo = Sys.getenv_exn "GITHUB_REPOSITORY" in
    let run_id = Sys.getenv_exn "GITHUB_RUN_ID" in
    [%string "%{server_url}/%{repo}/actions/runs/%{run_id}"]
  in
  Root.Results.Environment.make
    ~appName:(Sys.getenv_exn "GITHUB_REPOSITORY")
    ~buildId:(Sys.getenv_exn "GITHUB_RUN_ID")
    ~buildName:(Sys.getenv_exn "GITHUB_WORKFLOW")
    ~buildNumber:(Sys.getenv_exn "GITHUB_RUN_NUMBER" |> Int.of_string)
    ~buildUrl:get_workflow_url
    ~commit:(Sys.getenv_exn "GITHUB_SHA")
    ~branchName:(Sys.getenv_exn "GITHUB_REF")
    ~osPlatform:(Sys.getenv_exn "RUNNER_OS")
    ()

let to_ctrf_results report =
  Root.Results.make ~tool:(to_ctrf_tool report)
    ~summary:(to_ctrf_summary report) ~tests:(to_ctrf_tests report)
    ~environment:(to_ctrf_environment report)

let to_ctrf tr =
  Root.make ~reportFormat:"CTRF" ~specVersion:"0.0.0"
    ~reportId:Util.Uuid.get_string
    ~timestamp:(Time_float_unix.to_string tr.start_timestamp)
    ~generatedBy:"alcotest-github-action"
    ~results:
      (Root.Results.make ~tool:(to_ctrf_tool tr) ~summary:(to_ctrf_summary tr)
         ~tests:(to_ctrf_tests tr) ~environment:(to_ctrf_environment tr) ())
    ()
