open Fpath

let append_child parent seg =
  match parent with Some p -> p / seg | None -> Fpath.v seg
