# ── OCI authentication ────────────────────────────────────────────────────────

variable "tenancy_ocid" {
  description = "OCID of the tenancy."
  type        = string
}

variable "user_ocid" {
  description = "OCID of the IAM user running Terraform."
  type        = string
}

variable "fingerprint" {
  description = "Fingerprint of the API key."
  type        = string
}

variable "private_key_path" {
  description = "Local path to the PEM private key for the API key pair."
  type        = string
}

variable "region" {
  description = "OCI region identifier (e.g. us-chicago-1)."
  type        = string
  default     = "us-chicago-1"
}

# ── Compartment ───────────────────────────────────────────────────────────────

variable "compartment_ocid" {
  description = "OCID of the compartment where all resources are created."
  type        = string
}

variable "sandbox_compartment_ocid" {
  description = "OCID of the sandbox compartment for demo_sandbox_bucket. Defaults to compartment_ocid when not set."
  type        = string
  default     = null
}

# ── Project metadata ──────────────────────────────────────────────────────────

variable "project" {
  description = "Short project / application name used as a name prefix."
  type        = string
  default     = "myapp"
}

variable "environment" {
  description = "Deployment environment label (dev | staging | prod)."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

# ── Networking ────────────────────────────────────────────────────────────────

variable "vcn_cidr" {
  description = "CIDR block for the VCN."
  type        = string
  default     = "10.0.0.0/16"
}

variable "api_subnet_cidr" {
  description = "CIDR for the OKE API endpoint subnet."
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

# ── OKE ───────────────────────────────────────────────────────────────────────

variable "node_shape" {
  description = "Compute shape for OKE worker nodes."
  type        = string
  default     = "VM.Standard3.Flex"
}

variable "node_ocpus" {
  description = "OCPUs per worker node (Flex shapes only)."
  type        = number
  default     = 1
}

variable "node_memory_gb" {
  description = "Memory in GB per worker node (Flex shapes only). Minimum 6 GB for Kubernetes."
  type        = number
  default     = 6
}

variable "node_count" {
  description = "Total number of worker nodes."
  type        = number
  default     = 3
}

# ── Storage ───────────────────────────────────────────────────────────────────

variable "bucket_access_type" {
  description = "Visibility of the object storage bucket (NoPublicAccess | ObjectRead | ObjectReadWithoutList)."
  type        = string
  default     = "NoPublicAccess"
}
