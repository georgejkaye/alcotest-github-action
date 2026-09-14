open! Core

type t

val make :
  name:string ->
  id:string ->
  version:string ->
  start_timestamp:Time_float_unix.t ->
  end_timestamp:Time_float_unix.t ->
  count:int ->
  passed:int ->
  failed:int ->
  suites:int ->
  ?tests:Test.t list ->
  unit ->
  t

val pp : Format.formatter -> t -> unit
val show : t -> string
val equal : t -> t -> bool

val of_test_headlines :
  name:string ->
  id:string ->
  start_timestamp:Time_float_unix.t ->
  end_timestamp:Time_float_unix.t ->
  version:string ->
  log_root:Fpath.t ->
  Headline.t list ->
  t

module Root :
    module type of
      Ctrf.Root.MakeWithNoExtras (Ctrf.Object.Empty) (Ctrf.Object.Empty)

val to_ctrf : t -> Root.t
