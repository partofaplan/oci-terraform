output "vcn_id" {
  description = "OCID of the VCN."
  value       = oci_core_vcn.this.id
}

output "api_endpoint_subnet_id" {
  description = "OCID of the OKE API endpoint subnet."
  value       = oci_core_subnet.api_endpoint.id
}

output "nodes_subnet_id" {
  description = "OCID of the worker node subnet."
  value       = oci_core_subnet.nodes.id
}

output "lb_subnet_id" {
  description = "OCID of the load balancer subnet."
  value       = oci_core_subnet.lb.id
}
