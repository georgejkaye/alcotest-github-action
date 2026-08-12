module type Extras = sig
  module Tool : Object.T
end

module Make (Extras : Extras) = struct
  type t = {
    name : string;
    version : string option;
    extra : Extras.Tool.t option;
  }
  [@@deriving show, yojson]
end
