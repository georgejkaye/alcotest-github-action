module Make (EnvironmentExtras : Object.T) = struct
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
    extra : EnvironmentExtras.t option;
  }
  [@@deriving show, yojson]
end
