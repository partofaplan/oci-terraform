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
  description = "OCI region identifier (e.g. us-ashburn-1)."
  type        = string
  default     = "us-ashburn-1"
}

# ── Compartment ───────────────────────────────────────────────────────────────

variable "compartment_ocid" {
  description = "OCID of the compartment where all resources are created."
  type        = string
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

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet."
  type        = string
  default     = "10.0.2.0/24"
}

# ── Compute ───────────────────────────────────────────────────────────────────

variable "instance_shape" {
  description = "Compute shape for instances (Flex shapes recommended)."
  type        = string
  default     = "VM.Standard.E4.Flex"
}

variable "instance_ocpus" {
  description = "Number of OCPUs for Flex shapes."
  type        = number
  default     = 1
}

variable "instance_memory_gb" {
  description = "Memory in GB for Flex shapes."
  type        = number
  default     = 16
}

variable "instance_image_id" {
  description = "OCID of the platform image (OS) for compute instances."
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key to authorise on compute instances."
  type        = string
}

variable "instance_count" {
  description = "Number of compute instances to create."
  type        = number
  default     = 1
}

# ── Storage ───────────────────────────────────────────────────────────────────

variable "bucket_access_type" {
  description = "Visibility of the object storage bucket (NoPublicAccess | ObjectRead | ObjectReadWithoutList)."
  type        = string
  default     = "NoPublicAccess"
}

variable "block_volume_size_gb" {
  description = "Size of each block volume in GB."
  type        = number
  default     = 50
}
