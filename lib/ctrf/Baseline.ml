module Make (BaselineExtra : Object.T) = struct
  type t = {
    reportId : string;
    timestamp : string option;
    source : string option;
    buildNumber : int option;
    buildName : string option;
    buildUrl : string option;
    commit : string option;
    extra : BaselineExtra.t option;
  }
  [@@deriving show, yojson]
end
