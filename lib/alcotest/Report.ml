open Core
open Core_unix
open Yojson

type t = {
  name : string;
  id : string;
  timestamp : Time_float_unix.t;
  tests : int;
  passed : int;
  failed : int;
  cases : Case.t list;
}

let get_test_log_content th log_root =
  let log_path = Headline.to_log_path th log_root in
  match File.read_file log_path with
  | Second msg -> msg
  | First content -> content

let of_test_headlines ~name ~id ~timestamp (ths : Headline.t list) log_root =
  List.fold (List.rev ths) ~init:(0, 0, 0, [])
    ~f:(fun (tests, passed, failed, acc) cur ->
      let log_content = get_test_log_content cur log_root in
      let cur_test_suite = cur.test_suite in
      let test_case : Case.t =
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
      (tests + 1, new_passed, new_failed, test_case :: acc))
  |> fun (tests, passed, failed, acc) ->
  (tests, passed, failed, List.rev acc) |> fun (tests, passed, failed, cases) ->
  { name; id; timestamp; tests; passed; failed; cases }

module Root = Ctrf.Root.MakeWithNoExtras (Ctrf.Object.Empty) (Ctrf.Object.Empty)

let to_ctrf tr version = failwith "todo"
(* Root.make ~reportFormat:"CTRF" ~specVersion:"0.0.0"
    ~reportId:Util.Uuid.get_string
    ~timestamp:(Time_float_unix.to_string tr.timestamp)
    ~generatedBy:"alcotest-github-action"
    ~results:(List.map tr.suites ~f:(fun suite -> Root.Results.make
    ~tool: (Root.Results.Tool.make ~name:"Alcotest" ~version ())
    ~summary: (Root.Results.Summary.make ~tests:)

    ~tests:))
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
    ] *)
