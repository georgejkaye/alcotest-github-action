group "default" {
  targets = ["builder_export", "tester_export"]
}

target "builder" {
  context    = "."
  dockerfile = "Dockerfile"
  target     = "builder"
}

target "tester" {
  context    = "."
  dockerfile = "Dockerfile"
  target     = "tester"
}