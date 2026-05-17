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

# ── Storage ───────────────────────────────────────────────────────────────────

variable "bucket_access_type" {
  description = "Visibility of the object storage bucket (NoPublicAccess | ObjectRead | ObjectReadWithoutList)."
  type        = string
  default     = "NoPublicAccess"
}
