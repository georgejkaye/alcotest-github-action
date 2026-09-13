variable "RUNNER_TEMP" {
  default = "./tmp"
}

group "default" {
  targets = ["builder", "tester"]
}

target "builder" {
  context    = "."
  dockerfile = "Dockerfile"
  target     = "builder_workspace"
  output     = ["type=local,dest=${RUNNER_TEMP}/build-env"]
}

target "tester" {
  context    = "."
  dockerfile = "Dockerfile"
  target     = "test_workspace"
  output     = ["type=local,dest=${RUNNER_TEMP}/test-env"]
}