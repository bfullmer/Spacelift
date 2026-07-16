output "pet_name" {
  description = "Randomly generated pet name, proving the run applied successfully."
  value       = random_pet.test.id
}

output "lucky_number" {
  description = "Randomly generated integer."
  value       = random_integer.test.result
}

output "resource_suffix" {
  description = "Random lowercase suffix, handy for naming test resources."
  value       = random_string.suffix.result
}

output "run_id" {
  description = "Random UUID generated for this run."
  value       = random_uuid.run_id.result
}

output "environment" {
  description = "Static local used to label this test environment."
  value       = local.environment
}
