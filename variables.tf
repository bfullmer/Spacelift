variable "cloudflare_api_token" {
  description = "Cloudflare API token scoped to Zone:DNS:Edit on the brettfullmer.com zone. Provide via TF_VAR_cloudflare_api_token (a Spacelift secret env var). Never commit it."
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "Zone ID for brettfullmer.com. Find it in the Cloudflare dashboard: pick the domain, then Overview -> API (right sidebar)."
  type        = string
}

variable "record_name" {
  description = "Subdomain (relative to the zone) for the demo TXT record."
  type        = string
  default     = "spacelift-demo"
}
