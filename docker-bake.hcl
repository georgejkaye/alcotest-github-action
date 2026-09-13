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
  cache-from = ["type=gha,scope=opam-builder-cache"]
  cache-to   = ["type=gha,mode=max,scope=opam-builder-cache"]
}

target "test_stage" {
  context    = "."
  dockerfile = "Dockerfile"
  target     = "tester"
  cache-from = ["type=gha,scope=opam-tester-cache"]
  cache-to   = ["type=gha,mode=max,scope=opam-tester-cache"]
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