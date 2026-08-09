type t = { name : string; index : int; success : bool; log : string }

let to_string tr =
  let success_string = if tr.success then "PASS" else "FAIL" in
  [%string
    "%{Int.to_string tr.index}) %{tr.name}: %{success_string}\n\n\
     %{tr.log}\n\
     -------------------------------\n"]
