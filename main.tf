locals {
  name_prefix = "${var.project}-${var.environment}"
  common_tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

module "networking" {
  source = "./modules/networking"

  compartment_ocid    = var.compartment_ocid
  name_prefix         = local.name_prefix
  vcn_cidr            = var.vcn_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  freeform_tags       = local.common_tags
}

module "compute" {
  source = "./modules/compute"

  compartment_ocid   = var.compartment_ocid
  name_prefix        = local.name_prefix
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  subnet_id          = module.networking.private_subnet_id
  shape              = var.instance_shape
  ocpus              = var.instance_ocpus
  memory_gb          = var.instance_memory_gb
  image_id           = var.instance_image_id
  ssh_public_key     = var.ssh_public_key
  instance_count     = var.instance_count
  freeform_tags      = local.common_tags
}

module "storage" {
  source = "./modules/storage"

  compartment_ocid     = var.compartment_ocid
  name_prefix          = local.name_prefix
  bucket_access_type   = var.bucket_access_type
  block_volume_size_gb = var.block_volume_size_gb
  availability_domain  = data.oci_identity_availability_domains.ads.availability_domains[0].name
  freeform_tags        = local.common_tags
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}
