output "bucket_name" {
  description = "Name of the object storage bucket."
  value       = oci_objectstorage_bucket.this.name
}

output "bucket_namespace" {
  description = "Object storage namespace."
  value       = data.oci_objectstorage_namespace.this.namespace
}

output "block_volume_ids" {
  description = "OCIDs of the block volumes."
  value       = [oci_core_volume.this.id]
}
