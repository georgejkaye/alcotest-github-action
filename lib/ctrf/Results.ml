module type Extras = sig
  module Tool : Tool.Extras
  module Summary : Summary.Extras
  module Test : Test.Extras
  module Environment : Environment.Extras
  module Results : Object.T
end

module EmptyExtras = struct
  module Tool = Tool.EmptyExtras
  module Summary = Summary.EmptyExtras
  module Test = Test.EmptyExtras
  module Environment = Environment.EmptyExtras
  module Results = Object.Empty
end

module Make
    (Extras : Extras)
    (TestLabels : Object.T)
    (TestParameters : Object.T) =
struct
  module Tool = Tool.Make (Extras.Tool)
  module Summary = Summary.Make (Extras.Summary)
  module Test = Test.Make (Extras.Test) (TestLabels) (TestParameters)
  module Environment = Environment.Make (Extras.Environment)

  type t = {
    tool : Tool.t;
    summary : Summary.t;
    tests : Test.t list;
    environment : Environment.t option;
    extra : Extras.Results.t option;
  }
  [@@deriving show, yojson]
end

module MakeWithNoExtras = Make (EmptyExtras)
