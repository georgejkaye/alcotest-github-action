open! Core

type t = (string * string) list

let v = []
let getenv env key = List.Assoc.find ~equal:String.equal env key

let getenv_exn env key =
  match getenv env key with
  | Some result -> result
  | None -> raise Stdlib.Not_found

let add_env_variable ~env = List.Assoc.add env ~equal:String.equal
