data "oci_objectstorage_namespace" "this" {
  compartment_id = var.compartment_ocid
}

resource "oci_objectstorage_bucket" "this" {
  compartment_id = var.compartment_ocid
  namespace      = data.oci_objectstorage_namespace.this.namespace
  name           = "${var.name_prefix}-bucket"
  access_type    = var.bucket_access_type
  versioning     = "Enabled"
  freeform_tags  = var.freeform_tags
}

resource "oci_objectstorage_bucket" "sandbox" {
  compartment_id = var.sandbox_compartment_ocid
  namespace      = data.oci_objectstorage_namespace.this.namespace
  name           = "demo_sandbox_bucket"
  access_type    = "NoPublicAccess"
  freeform_tags  = var.freeform_tags
}
