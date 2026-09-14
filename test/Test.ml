let () =
  Alcotest.run "Alcotest_action"
    [
      Parser_tests.Headline_tests.tests;
      Parser_tests.Output_tests.tests;
      Parser_tests.Paths_tests.tests;
    ]
