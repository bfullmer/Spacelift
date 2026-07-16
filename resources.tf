# Additional credential-free resources to give Spacelift more to plan.

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "random_uuid" "run_id" {}

resource "random_password" "token" {
  length  = 20
  special = true
}

locals {
  environment = "spacelift-test"
}
