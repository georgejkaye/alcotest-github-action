open Util.Make

type t = {
  name : string;
  suite : string;
  index : int;
  success : bool;
  log : string;
  trace : string explicit_option;
}
[@@deriving show, make]
