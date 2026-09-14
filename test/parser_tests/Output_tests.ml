open! Core
open! Lib
module Output = Parser.Output

module Output_helpers : sig
  val make :
    executable_name:string ->
    run_id:string ->
    headlines:Parser.Headline.t list ->
    string
end = struct
  let get_fail_file_declaration () =
    String.concat ~sep:"\n"
      [
        {%string|File "test/dune", line 2, characters 7-11|};
        {%string|2 |  (name test)|};
      ]

  let get_test_declaration test_run_name test_run_id =
    String.concat ~sep:"\n"
      [
        {%string|Testing `%{test_run_name}'.|};
        {%string|This run has ID `%{test_run_id}'.|};
      ]

  let get_output_test_line ?(all_previous_passed = false) ~highest_index
      ~longest_suite_name (headline : Parser.Headline.t) =
    let result =
      if headline.success then "  [OK]  "
      else if all_previous_passed then "> [FAIL]"
      else "  [FAIL]"
    in
    let suite_name =
      String.pad_right ~len:longest_suite_name headline.test_suite
    in
    let index_chars = Int.to_string highest_index |> String.length in
    let test_index =
      String.pad_left ~len:index_chars (Int.to_string headline.index)
    in
    let test_name = headline.name ^ "." in
    {%string|%{result}         %{suite_name}        %{test_index}   %{test_name}|}

  let make ~executable_name ~run_id ~(headlines : Parser.Headline.t list) =
    let longest_suite_name, highest_index, has_failure =
      List.fold headlines ~init:(0, 0, false)
        ~f:(fun (longest_suite_name, highest_index, has_failure) cur ->
          ( Int.max (String.length cur.test_suite) longest_suite_name,
            Int.max cur.index highest_index,
            has_failure || not cur.success ))
    in
    let test_lines =
      List.fold headlines ~init:(true, [])
        ~f:(fun (all_previous_passed, acc) cur ->
          ( all_previous_passed && not cur.success,
            get_output_test_line ~all_previous_passed ~highest_index
              ~longest_suite_name cur
            :: acc ))
      |> snd
      |> List.rev
      |> String.concat ~sep:"\n"
    in
    let all_lines =
      [
        (if has_failure then get_fail_file_declaration () else "");
        get_test_declaration executable_name run_id;
        test_lines;
      ]
    in
    String.concat ~sep:"\n\n"
      (List.filter all_lines ~f:(fun x -> not (String.is_empty x)))
end

let get_name () =
  let executable_name = "test_executable" in
  let output =
    Output_helpers.make ~executable_name ~run_id:"123456"
      ~headlines:
        [
          Parser.Headline.make ~test_suite:"test_suite" ~index:1 ~name:"test"
            ~success:true;
        ]
  in
  let expected = First executable_name in
  let result = Parser.Output.get_name output in
  Alcotest.check
    (Helpers.Testable.either Helpers.Testable.string Helpers.Testable.string)
    "get_name" expected result

let get_id () =
  let run_id = "123456" in
  let output =
    Output_helpers.make ~executable_name:"test_executable" ~run_id
      ~headlines:
        [
          Parser.Headline.make ~test_suite:"test_suite" ~index:1 ~name:"test"
            ~success:true;
        ]
  in
  let expected = First run_id in
  let result = Parser.Output.get_id output in
  Alcotest.check
    (Helpers.Testable.either Helpers.Testable.string Helpers.Testable.string)
    "get_name" expected result

let get_test_headlines () =
  let headline1 =
    Parser.Headline.make ~test_suite:"test_suite_1" ~index:1 ~name:"test_1"
      ~success:true
  in
  let headline2 =
    Parser.Headline.make ~test_suite:"test_suite_1" ~index:2 ~name:"test_2"
      ~success:false
  in
  let headline3 =
    Parser.Headline.make ~test_suite:"test_suite_2" ~index:1 ~name:"test_1"
      ~success:false
  in
  let headline4 =
    Parser.Headline.make ~test_suite:"test_suite_2" ~index:2 ~name:"test_2"
      ~success:true
  in
  let headlines = [ headline1; headline2; headline3; headline4 ] in
  let output =
    Output_helpers.make ~executable_name:"test_executable" ~run_id:"123456"
      ~headlines
  in
  let result = Parser.Output.get_test_headlines output in
  Alcotest.check
    (Helpers.Testable.list Helpers.Testable.headline)
    "get_name" headlines result

let tests =
  ( "Parser.Output",
    [
      Alcotest.test_case "get_name" `Quick get_name;
      Alcotest.test_case "get_id" `Quick get_id;
      Alcotest.test_case "get_test_headlines" `Quick get_test_headlines;
    ] )
