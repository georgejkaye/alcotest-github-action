open Core
let params =
  let open Command.Param in
  anon ("input" %: string)

let command =
  Command.basic ~summary:"Process Alcotest output"
    ~readme:(fun () -> "Todo")
    (Command.Param.map params ~f:(fun input () ->
      print_endline input))

let () = Command_unix.run ~version:"1.0" ~build_info:"RWO" command
