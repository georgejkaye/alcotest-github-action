open Core

let with_out_file path ?(binary = false) =
  Out_channel.with_file ~binary (Fpath.to_string path)

let with_in_file path ?(binary = false) =
  In_channel.with_file ~binary (Fpath.to_string path)

let file_exists path =
  Sys_unix.file_exists ~follow_symlinks:true (Fpath.to_string path)

let read_file path =
  match file_exists path with
  | `No -> Second [%string "File %{Fpath.to_string path} does not exist"]
  | `Unknown ->
      Second [%string "Cannot determine if file %{Fpath.to_string path} exists"]
  | `Yes ->
      First
        (with_in_file ~binary:false
           ~f:(fun file -> In_channel.input_all file)
           path)

let write_file path s =
  with_out_file path ~binary:false ~f:(fun file ->
      Out_channel.output_string file s)
