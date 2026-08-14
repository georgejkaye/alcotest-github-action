module type Extras = sig
  module Baseline : Object.T
end

module EmptyExtras = struct
  module Baseline = Object.Empty
end

module Make (Extras : Extras) = struct
  type t = {
    reportId : string;
    timestamp : string option;
    source : string option;
    buildNumber : int option;
    buildName : string option;
    buildUrl : string option;
    commit : string option;
    extra : Extras.Baseline.t option;
  }
  [@@deriving make, show, yojson]
end

module MakeWithNoExtras = Make (EmptyExtras)
