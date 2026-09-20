open! Lib
open! Core

let string = Alcotest.string
let int = Alcotest.int

let exn =
  Alcotest.testable Exn.pp (fun a b ->
      Sexp.equal (Exn.sexp_of_t a) (Exn.sexp_of_t b))

let fpath = Alcotest.testable Fpath.pp Fpath.equal

let either at bt =
  Alcotest.testable
    (fun ppf -> function
      | First a -> (Alcotest.pp at) ppf a | Second b -> (Alcotest.pp bt) ppf b)
    (fun a b ->
      match (a, b) with
      | First a, First b -> (Alcotest.equal at) a b
      | Second a, Second b -> (Alcotest.equal bt) a b
      | _ -> false)

let result at bt =
  Alcotest.testable
    (fun ppf -> function
      | Ok a -> (Alcotest.pp at) ppf a | Error b -> (Alcotest.pp bt) ppf b)
    (fun a b ->
      match (a, b) with
      | Ok a, Ok b -> (Alcotest.equal at) a b
      | Error a, Error b -> (Alcotest.equal bt) a b
      | _ -> false)

let list at = Alcotest.(list at)
let headline = Alcotest.testable Parser.Headline.pp Parser.Headline.equal

module Report
    (File : Lib.Util.Wrapper.File_wrapper.Interface)
    (Uuid : Lib.Util.Wrapper.Uuid_wrapper.Interface)
    (Env : Lib.Util.Wrapper.Env_wrapper.Interface) =
struct
  module Report = Lib.Parser.Report.Make (File) (Uuid) (Env)

  let report = Alcotest.testable Report.pp Report.equal
end

module Root = Ctrf.Root.MakeWithNoExtras (Ctrf.Object.Empty) (Ctrf.Object.Empty)

let root_with_no_extras = Alcotest.testable Root.pp Root.equal
let time_float_unix = Alcotest.testable Time_float_unix.pp Time_float_unix.equal
let yojson = Alcotest.testable Yojson.Safe.pp Yojson.Safe.equal
