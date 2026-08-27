open! Core

module type T = sig
  type t

  val pp : Format.formatter -> t -> unit
  val show : t -> string
  val to_yojson : t -> Yojson.Safe.t
  val of_yojson : Yojson.Safe.t -> (t, string) result
end

module Empty : T = struct
  type t = unit [@@deriving show]

  let to_yojson = function _ -> `Assoc []
  let of_yojson = function `Assoc [] -> Ok () | _ -> Error "Object.Empty.t"
  let v = ()
end
