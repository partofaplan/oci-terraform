variable "compartment_ocid" {
  description = "Compartment OCID."
  type        = string
}

variable "name_prefix" {
  description = "Prefix applied to all resource display names."
  type        = string
}

variable "vcn_cidr" {
  description = "CIDR block for the VCN. Must not overlap with pods_cidr (10.244.0.0/16) or services_cidr (10.96.0.0/16)."
  type        = string
  default     = "10.0.0.0/16"
}

variable "api_subnet_cidr" {
  description = "CIDR for the OKE API endpoint subnet. A /28 is sufficient."
  type        = string
  default     = "10.0.0.0/28"
}

variable "nodes_subnet_cidr" {
  description = "CIDR for the worker node subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "lb_subnet_cidr" {
  description = "CIDR for the load balancer subnet."
  type        = string
  default     = "10.0.2.0/24"
}

variable "freeform_tags" {
  description = "Freeform tags applied to all resources."
  type        = map(string)
  default     = {}
}
