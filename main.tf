terraform {
  required_version = ">= 1.0"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

# A credential-free resource so Spacelift runs can plan and apply
# without needing any cloud provider secrets. Great for smoke-testing
# the stack end to end.
resource "random_pet" "test" {
  length    = 2
  separator = "-"
}

resource "random_integer" "test" {
  min = 1
  max = 1000
}
