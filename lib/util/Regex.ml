open! Core

let get_regex regex_string = Re.Perl.re regex_string |> Re.compile

let get_regex_match ~regex ~summary input_string =
  match Re.exec_opt regex input_string with
  | None -> Second [%string "Could not find %{summary} in %{input_string}"]
  | Some m -> First (Re.Group.get m 1)
