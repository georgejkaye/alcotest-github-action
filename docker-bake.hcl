variable "RUNNER_TEMP" {
  default = "./tmp"
}

group "default" {
  targets = ["builder_export", "tester_export"]
}

target "builder_stage" {
  context    = "."
  dockerfile = "Dockerfile"
  target     = "builder"
}

target "tester_stage" {
  context    = "."
  dockerfile = "Dockerfile"
  target     = "tester"
}

target "builder_export" {
  inherits   = ["builder_stage"]
  target     = "builder_workspace"
  output     = ["type=local,dest=${RUNNER_TEMP}/build-env"]
}

target "tester_export" {
  inherits   = ["tester_stage"]
  target     = "tester_workspace"
  output     = ["type=local,dest=${RUNNER_TEMP}/test-env"]
}