open! Core

module Yojson = struct
  include Yojson

  let rec remove_nulls (json : Safe.t) =
    match json with
    | `Assoc entries ->
        `Assoc
          (List.fold entries ~init:[] ~f:(fun acc (key, json) ->
               match json with
               | `Null -> acc
               | json -> (key, remove_nulls json) :: acc)
          |> List.rev)
    | `List jsons -> `List (List.map jsons ~f:remove_nulls)
    | json -> json
end
