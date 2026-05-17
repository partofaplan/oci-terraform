output "object_storage_bucket_name" {
  description = "Name of the object storage bucket."
  value       = module.storage.bucket_name
}

output "sandbox_bucket_name" {
  description = "Name of the sandbox bucket."
  value       = module.storage.sandbox_bucket_name
}
