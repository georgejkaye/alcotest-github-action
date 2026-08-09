open! Core

val get_name : string -> (string, string) Either.t
val get_id : string -> (string, string) Either.t
val get_test_headlines : string -> Test_headline.t list
val get_test_logs_root_path : string -> (Fpath.t, string) Either.t
