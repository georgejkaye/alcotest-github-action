module Make
    (ToolExtras : Object.T)
    (SummaryExtras : Object.T)
    (TestLabels : Object.T)
    (TestParameters : Object.T)
    (RetryAttemptExtras : Object.T)
    (EnvironmentExtras : Object.T)
    (StepExtras : Object.T)
    (TestInsightExtras : Object.T)
    (TestExtras : Object.T)
    (ResultsExtras : Object.T) =
struct
  module Test =
    Test.Make (TestLabels) (TestParameters) (RetryAttemptExtras) (StepExtras)
      (RetryAttemptExtras)
      (TestInsightExtras)
      (TestExtras)

  module Tool = Tool.Make (ToolExtras)
  module Environment = Environment.Make (EnvironmentExtras)
  module Summary = Summary.Make (SummaryExtras)

  type t = {
    tool : Tool.t;
    summary : Summary.t;
    tests : Test.t list;
    environment : Environment.t option;
    extra : ResultsExtras.t option;
  }
  [@@deriving show, yojson]
end
