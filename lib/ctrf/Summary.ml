module Make (SummaryExtras : Object.T) = struct
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
    extra : SummaryExtras.t option;
  }
  [@@deriving show, yojson]
end
