open Ppx_compare_lib.Builtin

type 'a explicit_option = 'a option [@@deriving show, yojson, equal]
