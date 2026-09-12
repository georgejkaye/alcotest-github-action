open! Lib
open! Core

let string = Alcotest.string
let int = Alcotest.int
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

let list at = Alcotest.(list at)
let headline = Alcotest.testable Parser.Headline.pp Parser.Headline.equal
