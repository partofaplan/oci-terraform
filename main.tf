locals {
  name_prefix = "${var.project}-${var.environment}"
  common_tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

module "networking" {
  source = "./modules/networking"

  compartment_ocid  = var.compartment_ocid
  name_prefix       = local.name_prefix
  vcn_cidr          = var.vcn_cidr
  api_subnet_cidr   = var.api_subnet_cidr
  nodes_subnet_cidr = var.nodes_subnet_cidr
  lb_subnet_cidr    = var.lb_subnet_cidr
  freeform_tags     = local.common_tags
}

module "oke" {
  source = "./modules/oke"

  compartment_ocid       = var.compartment_ocid
  name_prefix            = local.name_prefix
  availability_domain    = data.oci_identity_availability_domains.ads.availability_domains[0].name
  vcn_id                 = module.networking.vcn_id
  api_endpoint_subnet_id = module.networking.api_endpoint_subnet_id
  node_subnet_id         = module.networking.nodes_subnet_id
  lb_subnet_id           = module.networking.lb_subnet_id
  node_shape             = var.node_shape
  node_ocpus             = var.node_ocpus
  node_memory_gb         = var.node_memory_gb
  node_count             = var.node_count
  freeform_tags          = local.common_tags
}

module "storage" {
  source = "./modules/storage"

  compartment_ocid         = var.compartment_ocid
  sandbox_compartment_ocid = coalesce(var.sandbox_compartment_ocid, var.compartment_ocid)
  name_prefix              = local.name_prefix
  bucket_access_type       = var.bucket_access_type
  freeform_tags            = local.common_tags
}
