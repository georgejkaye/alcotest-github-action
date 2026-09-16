open! Core

let default_test_root =
  let open Fpath in
  Fpath.v "." / "_build" / "default" / "test" / "_build"

let get_test_logs_root_path ?(build_root_dir = None) test_run_id =
  let open Fpath in
  let build_root_dir =
    match build_root_dir with Some d -> d | None -> default_test_root
  in
  build_root_dir / "_tests" / test_run_id
