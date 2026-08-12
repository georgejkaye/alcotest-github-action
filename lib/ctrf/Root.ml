module RunInsight = struct
  module type Extras = sig
    module RunInsight : Object.T
  end

  module EmptyExtras = struct
    module RunInsight = Object.Empty
  end

  module Make (Extras : Extras) = struct
    type t = {
      passRate : MetricDelta.t option;
      failRate : MetricDelta.t option;
      flakyRate : MetricDelta.t option;
      averageRunDuration : MetricDelta.t option;
      p95RunDuration : MetricDelta.t option;
      averageTestDuration : MetricDelta.t option;
      runsAnalyzed : int option;
      extra : Extras.RunInsight.t option;
    }
    [@@deriving show, yojson]
  end

  module MakeWithNoExtras = Make (EmptyExtras)
end

module type Extras = sig
  module Results : Results.Extras
  module RunInsight : RunInsight.Extras
  module Baseline : Baseline.Extras
  module Root : Object.T
end

module EmptyExtras = struct
  module Results = Results.EmptyExtras
  module RunInsight = RunInsight.EmptyExtras
  module Baseline = Baseline.EmptyExtras
  module Root = Object.Empty
end

module Make
    (Extras : Extras)
    (TestLabels : Object.T)
    (TestParameters : Object.T) =
struct
  module Results = Results.Make (Extras.Results) (TestLabels) (TestParameters)
  module RunInsight = RunInsight.Make (Extras.RunInsight)
  module Baseline = Baseline.Make (Extras.Baseline)

  type t = {
    reportFormat : string;
    specVersion : string;
    reportId : string option;
    timestamp : string option;
    generatedBy : string option;
    results : Results.t option;
    insights : RunInsight.t option;
    baseline : Baseline.t option;
    extra : Extras.Root.t option;
  }
  [@@deriving show, yojson]
end

module MakeWithNoExtras = Make (EmptyExtras)
