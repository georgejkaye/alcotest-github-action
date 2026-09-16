open! Core

let default_test_root =
  let open Fpath in
  Fpath.v "." / "_build" / "default" / "test"

let get_test_logs_root_path ?(test_root_dir = None) test_run_id =
  let open Fpath in
  let test_root_dir =
    match test_root_dir with Some d -> d | None -> default_test_root
  in
  First (test_root_dir / "_tests" / test_run_id)
