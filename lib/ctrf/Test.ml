module Attachment = struct
  module Make (AttachmentExtras : Object.T) = struct
    type t = {
      name : string;
      contentType : string;
      path : string;
      extra : AttachmentExtras.t option;
    }
    [@@deriving show, yojson]
  end
end

module TestInsight = struct
  module Make (TestInsightExtras : Object.T) = struct
    type t = {
      passRate : MetricDelta.t option;
      failRate : MetricDelta.t option;
      flakyRate : MetricDelta.t option;
      averageTestDuration : MetricDelta.t option;
      p95testDuration : MetricDelta.t option;
      executedInRuns : int option;
      extra : TestInsightExtras.t option;
    }
    [@@deriving show, yojson]
  end
end

module Status = struct
  type t =
    | Passed [@json "passed"]
    | Failed [@json "failed"]
    | Skipped [@json "skipped"]
    | Pending [@json "pending"]
    | Other [@json "other"]
  [@@deriving show, yojson]
end

module RetryAttempt = struct
  module Make (AttachmentExtras : Object.T) (RetryAttemptExtras : Object.T) =
  struct
    module Attachment = Attachment.Make (AttachmentExtras)

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
      extra : RetryAttemptExtras.t option;
    }
    [@@deriving show, yojson]
  end
end

module Step = struct
  module Make (StepExtras : Object.T) = struct
    type t = { name : string; status : Status.t; extra : StepExtras.t }
    [@@deriving show, yojson]
  end
end

module Make
    (Labels : Object.T)
    (Parameters : Object.T)
    (RetryAttemptExtras : Object.T)
    (StepExtras : Object.T)
    (AttachmentExtras : Object.T)
    (TestInsightExtras : Object.T)
    (TestExtras : Object.T) =
struct
  module Step = Step.Make (StepExtras)
  module Attachment = Attachment.Make (AttachmentExtras)

  module RetryAttempt =
    RetryAttempt.Make (AttachmentExtras) (RetryAttemptExtras)

  module TestInsight = TestInsight.Make (TestInsightExtras)

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
    extra : TestExtras.t option;
  }
  [@@deriving show, yojson]
end
