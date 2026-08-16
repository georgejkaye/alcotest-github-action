open! Core

val get_name : string -> (string, string) Either.t
val get_id : string -> (string, string) Either.t
val get_test_headlines : string -> Headline.t list
