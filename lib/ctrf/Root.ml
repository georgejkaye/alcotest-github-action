module RunInsight = struct
  module Make (RunInsightExtras : Object.T) = struct
    type t = {
      passRate : MetricDelta.t option;
      failRate : MetricDelta.t option;
      flakyRate : MetricDelta.t option;
      averageRunDuration : MetricDelta.t option;
      p95RunDuration : MetricDelta.t option;
      averageTestDuration : MetricDelta.t option;
      runsAnalyzed : int option;
      extra : RunInsightExtras.t option;
    }
    [@@deriving show, yojson]
  end
end

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
    (ResultsExtras : Object.T)
    (RunInsightExtras : Object.T)
    (BaselineExtras : Object.T)
    (RootExtras : Object.T) =
struct
  module Results =
    Results.Make (ToolExtras) (SummaryExtras) (TestLabels) (TestParameters)
      (RetryAttemptExtras)
      (EnvironmentExtras)
      (StepExtras)
      (TestInsightExtras)
      (TestExtras)
      (ResultsExtras)

  module RunInsight = RunInsight.Make (RunInsightExtras)
  module Baseline = Baseline.Make (BaselineExtras)

  type t = {
    reportFormat : string;
    specVersion : string;
    reportId : string option;
    timestamp : string option;
    generatedBy : string option;
    results : Results.t option;
    insights : RunInsight.t option;
    baseline : Baseline.t option;
    extra : RootExtras.t option;
  }
  [@@deriving show, yojson]
end
