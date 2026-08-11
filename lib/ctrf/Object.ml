open! Core

module type T = sig
  type t

  val pp : Format.formatter -> t -> unit
  val show : t -> string
  val to_yojson : t -> Yojson.Safe.t
  val of_yojson : Yojson.Safe.t -> (t, string) result
end
