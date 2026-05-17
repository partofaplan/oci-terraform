output "bucket_name" {
  description = "Name of the object storage bucket."
  value       = oci_objectstorage_bucket.this.name
}

output "bucket_namespace" {
  description = "Object storage namespace."
  value       = data.oci_objectstorage_namespace.this.namespace
}

output "sandbox_bucket_name" {
  description = "Name of the sandbox bucket."
  value       = oci_objectstorage_bucket.sandbox.name
}
