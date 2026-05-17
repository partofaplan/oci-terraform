output "instance_ids" {
  description = "OCIDs of the compute instances."
  value       = oci_core_instance.this[*].id
}

output "instance_private_ips" {
  description = "Private IP addresses of the compute instances."
  value       = oci_core_instance.this[*].private_ip
}

output "instance_display_names" {
  description = "Display names of the compute instances."
  value       = oci_core_instance.this[*].display_name
}
