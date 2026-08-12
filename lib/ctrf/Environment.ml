module type Extras = sig
  module Environment : Object.T
end

module EmptyExtras = struct
  module Environment = Object.Empty
end

module Make (Extras : Extras) = struct
  type t = {
    reportName : string option;
    appName : string option;
    appVersion : string option;
    buildId : string option;
    buildName : string option;
    buildNumber : string option;
    buildUrl : string option;
    repositoryName : string option;
    repositoryUrl : string option;
    commit : string option;
    branchName : string option;
    osPlatform : string option;
    osRelease : string option;
    testEnvironment : string option;
    healthy : bool option;
    extra : Extras.Environment.t option;
  }
  [@@deriving show, yojson]
end

module MakeWithNoExtras = Make (EmptyExtras)
