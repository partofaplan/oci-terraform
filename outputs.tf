output "cluster_id" {
  description = "OCID of the OKE cluster."
  value       = module.oke.cluster_id
}

output "cluster_endpoints" {
  description = "Kubernetes API endpoint(s)."
  value       = module.oke.cluster_endpoints
}

output "kubernetes_version" {
  description = "Kubernetes version deployed on the cluster."
  value       = module.oke.kubernetes_version
}

output "node_pool_id" {
  description = "OCID of the OKE node pool."
  value       = module.oke.node_pool_id
}

output "object_storage_bucket_name" {
  description = "Name of the object storage bucket."
  value       = module.storage.bucket_name
}

output "sandbox_bucket_name" {
  description = "Name of the sandbox bucket."
  value       = module.storage.sandbox_bucket_name
}
