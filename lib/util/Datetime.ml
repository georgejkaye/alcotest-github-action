open Core
open Core_unix

module Time_float_unix = struct
  include Time_float_unix

  let to_unix_timestamp dt =
    Time_float_unix.to_span_since_epoch dt |> Span.to_sec |> Int.of_float
end
