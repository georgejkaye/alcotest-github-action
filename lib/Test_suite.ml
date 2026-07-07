open Core

type t = {
  name : string;
  successes : int;
  failures : int;
  tests : Test_run.t list;
}

let to_strings ts =
  [%string
    "%{ts.name}: %{Int.to_string ts.successes}/%{Int.to_string (ts.successes + \
     ts.failures)} passed\n\
     ======================================================\n"]
  :: List.map ts.tests ~f:Test_run.to_string
