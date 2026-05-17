variable "compartment_ocid" {
  description = "Compartment OCID."
  type        = string
}

variable "name_prefix" {
  description = "Prefix applied to all resource display names."
  type        = string
}

variable "availability_domain" {
  description = "Availability domain name for the instances."
  type        = string
}

variable "subnet_id" {
  description = "Subnet OCID where instances are placed."
  type        = string
}

variable "shape" {
  description = "Compute shape (e.g. VM.Standard.E4.Flex)."
  type        = string
}

variable "ocpus" {
  description = "Number of OCPUs (for Flex shapes)."
  type        = number
  default     = 1
}

variable "memory_gb" {
  description = "Memory in GB (for Flex shapes)."
  type        = number
  default     = 16
}

variable "image_id" {
  description = "Platform image OCID."
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key authorised on instances."
  type        = string
}

variable "instance_count" {
  description = "Number of instances to create."
  type        = number
  default     = 1
}

variable "freeform_tags" {
  description = "Freeform tags applied to all resources."
  type        = map(string)
  default     = {}
}
