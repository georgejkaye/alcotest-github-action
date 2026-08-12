module type Extras = sig
  module Baseline : Object.T
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
  [@@deriving show, yojson]
end
