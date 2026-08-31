open! Core

let test_run_name_regex = Util.Regex.get_regex "Testing `(.*)'."
let test_run_id_regex = Util.Regex.get_regex "This run has ID `(.*)'."

let test_headline_regex =
  Util.Regex.get_regex
    "    (?:\\[(OK)\\]  |\\[(FAIL)\\])        (.*?)([0-9]+)   (.*)\\."

let get_data ~regex ~summary test_output =
  match Re.exec_opt regex test_output with
  | None -> Second [%string "Could not find %{summary}"]
  | Some m -> First (Re.Group.get m 1)

let get_name =
  get_data ~regex:test_run_name_regex ~summary:"Testing `(name)'. line"

let get_id =
  get_data ~regex:test_run_id_regex ~summary:"This run has ID `(id)'. line"

let get_test_headlines test_output =
  let lines = String.split_lines test_output in
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
          let open Headline in
          { test_suite; index; name; success } :: acc)
  |> List.rev
