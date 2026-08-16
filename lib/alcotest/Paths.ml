open! Core

let get_test_logs_root_path test_run_id =
  let open Fpath in
  First
    (Fpath.v "."
    / "_build"
    / "default"
    / "test"
    / "_build"
    / "_tests"
    / test_run_id)
