# A single, deliberately low-risk TXT record.
#
# It only ever creates spacelift-demo.brettfullmer.com and never references
# your live A / CNAME / MX records, so applying — or destroying — this demo
# cannot affect real traffic to brettfullmer.com. That makes it a safe thing
# to plan, apply, and tear down live during a walkthrough.
resource "cloudflare_record" "spacelift_demo" {
  zone_id = var.cloudflare_zone_id
  name    = var.record_name
  type    = "TXT"
  content = "Managed by Spacelift + Terraform - demo record"
  ttl     = 300
  comment = "Created for a Spacelift Stack demo. Safe to delete."
}
