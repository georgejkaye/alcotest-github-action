open Ppx_compare_lib.Builtin

type t = { current : int option; baseline : int option; change : int option }
[@@deriving equal, make, show, yojson]
