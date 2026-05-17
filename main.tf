locals {
  name_prefix = "${var.project}-${var.environment}"
  common_tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

module "storage" {
  source = "./modules/storage"

  compartment_ocid         = var.compartment_ocid
  sandbox_compartment_ocid = coalesce(var.sandbox_compartment_ocid, var.compartment_ocid)
  name_prefix              = local.name_prefix
  bucket_access_type       = var.bucket_access_type
  freeform_tags            = local.common_tags
}
