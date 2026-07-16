terraform {
  required_version = ">= 1.0"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

# The token is read from var.cloudflare_api_token, which Terraform pulls
# from the TF_VAR_cloudflare_api_token environment variable. In Spacelift
# you set this as a *secret* environment variable on the stack, so the
# token never lands in git or in plan/apply logs.
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
