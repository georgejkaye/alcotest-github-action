module String = struct
  include Core.String

  let split_on_pattern ?(drop_pattern = true) s ~pattern =
    match Core.String.substr_index s ~pattern with
    | None -> (s, None)
    | Some i ->
        ( (match i with 0 -> "" | _ -> Core.String.slice s 0 i),
          Some
            (Core.String.slice s
               (i + if drop_pattern then Core.String.length pattern else 0)
               (Core.String.length s)) )
end
