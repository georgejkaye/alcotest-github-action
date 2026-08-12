module type Extras = sig
  module Tool : Object.T
end

module EmptyExtras = struct
  module Tool = Object.Empty
end

module Make (Extras : Extras) = struct
  type t = {
    name : string;
    version : string option;
    extra : Extras.Tool.t option;
  }
  [@@deriving show, yojson]
end

module MakeWithNoExtras = Make (EmptyExtras)
