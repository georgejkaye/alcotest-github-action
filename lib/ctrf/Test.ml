module Attachment = struct
  module type Extras = sig
    module Attachment : Object.T
  end

  module EmptyExtras = struct
    module Attachment = Object.Empty
  end

  module Make (Extras : Extras) = struct
    type t = {
      name : string;
      contentType : string;
      path : string;
      extra : Extras.Attachment.t option;
    }
    [@@deriving make, show, yojson]
  end
end

module TestInsight = struct
  module type Extras = sig
    module TestInsight : Object.T
  end

  module EmptyExtras = struct
    module TestInsight = Object.Empty
  end

  module Make (Extras : Extras) = struct
    type t = {
      passRate : MetricDelta.t option;
      failRate : MetricDelta.t option;
      flakyRate : MetricDelta.t option;
      averageTestDuration : MetricDelta.t option;
      p95testDuration : MetricDelta.t option;
      executedInRuns : int option;
      extra : Extras.TestInsight.t option;
    }
    [@@deriving make, show, yojson]
  end
end

module Status = struct
  type t = Passed | Failed | Skipped | Pending | Other [@@deriving show]

  let to_yojson t =
    `String
      (match t with
      | Passed -> "passed"
      | Failed -> "failed"
      | Skipped -> "skipped"
      | Pending -> "pending"
      | Other -> "other")

  let of_yojson = function
    | `String "passed" -> Ok Passed
    | `String "failed" -> Ok Failed
    | `String "skipped" -> Ok Skipped
    | `String "pending" -> Ok Pending
    | `String "other" -> Ok Other
    | _ -> Error "Could not parse as test status"
end

module RetryAttempt = struct
  module type Extras = sig
    module Attachment : Attachment.Extras
    module RetryAttempt : Object.T
  end

  module EmptyExtras = struct
    module Attachment = Attachment.EmptyExtras
    module RetryAttempt = Object.Empty
  end

  module Make (Extras : Extras) = struct
    module Attachment = Attachment.Make (Extras.Attachment)

    type t = {
      attempt : int;
      status : Status.t;
      duration : int option;
      message : string option;
      trace : string option;
      line : int option;
      snippet : string option;
      stdout : string list option;
      stderr : string list option;
      start : int option;
      stop : int option;
      attachment : Attachment.t list option;
      extra : Extras.RetryAttempt.t option;
    }
    [@@deriving make, show, yojson]
  end
end

module Step = struct
  module type Extras = sig
    module Step : Object.T
  end

  module EmptyExtras = struct
    module Step = Object.Empty
  end

  module Make (Extras : Extras) = struct
    type t = { name : string; status : Status.t; extra : Extras.Step.t }
    [@@deriving make, show, yojson]
  end
end

module type Extras = sig
  module RetryAttempt : RetryAttempt.Extras
  module Step : Step.Extras
  module Attachment : Attachment.Extras
  module TestInsight : TestInsight.Extras
  module Test : Object.T
end

module EmptyExtras = struct
  module RetryAttempt = RetryAttempt.EmptyExtras
  module Step = Step.EmptyExtras
  module Attachment = Attachment.EmptyExtras
  module TestInsight = TestInsight.EmptyExtras
  module Test = Object.Empty
end

module Make (Extras : Extras) (Labels : Object.T) (Parameters : Object.T) =
struct
  module Step = Step.Make (Extras.Step)
  module Attachment = Attachment.Make (Extras.Attachment)
  module RetryAttempt = RetryAttempt.Make (Extras.RetryAttempt)
  module TestInsight = TestInsight.Make (Extras.TestInsight)

  type t = {
    name : string;
    status : Status.t;
    duration : int;
    id : string option;
    start : int option;
    stop : int option;
    suite : string list option;
    message : string option;
    trace : string option;
    snippet : string option;
    ai : string option;
    line : string option;
    rawStatus : string option;
    tags : string list option;
    labels : Labels.t option;
    type_ : string option; [@key "type"]
    filePath : string option;
    retries : int option;
    flaky : bool option;
    stdout : string list option;
    stderr : string list option;
    threadId : string option;
    browser : string option;
    device : string option;
    screenshot : string option;
    parameters : Parameters.t option;
    steps : Step.t list option;
    attachments : Attachment.t list option;
    retryAttempt : RetryAttempt.t option;
    insights : TestInsight.t list option;
    extra : Extras.Test.t option;
  }
  [@@deriving make, show, yojson]
end

module MakeWithNoExtras = Make (EmptyExtras)
