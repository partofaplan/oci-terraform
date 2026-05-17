variable "compartment_ocid" {
  description = "Compartment OCID."
  type        = string
}

variable "name_prefix" {
  description = "Prefix applied to all resource display names."
  type        = string
}

variable "availability_domain" {
  description = "Availability domain for block volumes."
  type        = string
}

variable "bucket_access_type" {
  description = "Object storage bucket visibility (NoPublicAccess | ObjectRead | ObjectReadWithoutList)."
  type        = string
  default     = "NoPublicAccess"
}

variable "block_volume_size_gb" {
  description = "Size of each block volume in GB (min 50, max 32768)."
  type        = number
  default     = 50

  validation {
    condition     = var.block_volume_size_gb >= 50 && var.block_volume_size_gb <= 32768
    error_message = "block_volume_size_gb must be between 50 and 32768."
  }
}

variable "freeform_tags" {
  description = "Freeform tags applied to all resources."
  type        = map(string)
  default     = {}
}
