output "cluster_id" {
  description = "OCID of the OKE cluster."
  value       = oci_containerengine_cluster.this.id
}

output "cluster_endpoints" {
  description = "Kubernetes API endpoint(s) for the cluster."
  value       = oci_containerengine_cluster.this.endpoints
}

output "kubernetes_version" {
  description = "Kubernetes version deployed on the cluster."
  value       = local.kubernetes_version
}

output "node_pool_id" {
  description = "OCID of the node pool."
  value       = oci_containerengine_node_pool.this.id
}
