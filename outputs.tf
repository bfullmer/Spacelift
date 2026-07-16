output "pet_name" {
  description = "Randomly generated pet name, proving the run applied successfully."
  value       = random_pet.test.id
}

output "lucky_number" {
  description = "Randomly generated integer."
  value       = random_integer.test.result
}
