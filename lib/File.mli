open! Core

val read_file : Fpath.t -> (string, string) Either.t
val write_file : Fpath.t -> string -> unit
