open! Core

type t

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
