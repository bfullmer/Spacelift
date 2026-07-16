output "demo_record_hostname" {
  description = "Fully-qualified name of the TXT record this stack manages."
  value       = cloudflare_record.spacelift_demo.hostname
}

output "demo_record_value" {
  description = "The TXT record content, so you can confirm the apply with dig."
  value       = cloudflare_record.spacelift_demo.content
}
