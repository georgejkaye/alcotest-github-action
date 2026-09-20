module type Interface = sig
  val get_uuid_string : unit -> string
end

module UuidV4 : Interface = struct
  let get_uuid_string () =
    Uuidm.v4_gen (Random.State.make_self_init ()) () |> Uuidm.to_string
end
