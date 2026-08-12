module type Extras = sig
  module Summary : Object.T
end

module EmptyExtras = struct
  module Summary = Object.Empty
end

module Make (Extras : Extras) = struct
  type t = {
    tests : int;
    passed : int;
    failed : int;
    pending : int;
    skipped : int;
    other : int;
    flaky : int option;
    suites : int option;
    start : int;
    stop : int;
    duration : int option;
    extra : Extras.Summary.t option;
  }
  [@@deriving show, yojson]
end

module MakeWithNoExtras = Make (EmptyExtras)
