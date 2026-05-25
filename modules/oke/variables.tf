variable "compartment_ocid" {
  description = "Compartment OCID."
  type        = string
}

variable "name_prefix" {
  description = "Prefix applied to all resource display names."
  type        = string
}

variable "availability_domain" {
  description = "Availability domain for the node pool."
  type        = string
}

variable "vcn_id" {
  description = "OCID of the VCN."
  type        = string
}

variable "api_endpoint_subnet_id" {
  description = "OCID of the subnet for the Kubernetes API endpoint."
  type        = string
}

variable "node_subnet_id" {
  description = "OCID of the subnet for worker nodes."
  type        = string
}

variable "lb_subnet_id" {
  description = "OCID of the subnet for OCI load balancers created by Kubernetes services."
  type        = string
}

variable "node_shape" {
  description = "Compute shape for worker nodes."
  type        = string
  default     = "VM.Standard3.Flex"
}

variable "node_ocpus" {
  description = "OCPUs per node (Flex shapes only)."
  type        = number
  default     = 1
}

variable "node_memory_gb" {
  description = "Memory in GB per node (Flex shapes only). Minimum 6 GB for Kubernetes system pods."
  type        = number
  default     = 6
}

variable "node_count" {
  description = "Total number of worker nodes in the pool."
  type        = number
  default     = 3
}

variable "freeform_tags" {
  description = "Freeform tags applied to all resources."
  type        = map(string)
  default     = {}
}
