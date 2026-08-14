type t = { current : int option; baseline : int option; change : int option }
[@@deriving make, show, yojson]
