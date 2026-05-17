output "vcn_id" {
  description = "OCID of the VCN."
  value       = module.networking.vcn_id
}

output "public_subnet_id" {
  description = "OCID of the public subnet."
  value       = module.networking.public_subnet_id
}

output "private_subnet_id" {
  description = "OCID of the private subnet."
  value       = module.networking.private_subnet_id
}

output "instance_ids" {
  description = "OCIDs of the compute instances."
  value       = module.compute.instance_ids
}

output "instance_private_ips" {
  description = "Private IP addresses of the compute instances."
  value       = module.compute.instance_private_ips
}

output "object_storage_bucket_name" {
  description = "Name of the object storage bucket."
  value       = module.storage.bucket_name
}

output "block_volume_ids" {
  description = "OCIDs of the block volumes."
  value       = module.storage.block_volume_ids
}
