variable "compartment_ocid" {
  description = "Compartment OCID."
  type        = string
}

variable "sandbox_compartment_ocid" {
  description = "OCID of the sandbox compartment where demo_sandbox_bucket is created."
  type        = string
}

variable "name_prefix" {
  description = "Prefix applied to all resource display names."
  type        = string
}

variable "bucket_access_type" {
  description = "Object storage bucket visibility (NoPublicAccess | ObjectRead | ObjectReadWithoutList)."
  type        = string
  default     = "NoPublicAccess"
}

variable "freeform_tags" {
  description = "Freeform tags applied to all resources."
  type        = map(string)
  default     = {}
}
