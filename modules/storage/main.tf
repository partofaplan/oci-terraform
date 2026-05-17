# ── Object storage ────────────────────────────────────────────────────────────

resource "oci_objectstorage_namespace" "this" {
  compartment_id = var.compartment_ocid
}

resource "oci_objectstorage_bucket" "this" {
  compartment_id = var.compartment_ocid
  namespace      = data.oci_objectstorage_namespace.this.namespace
  name           = "${var.name_prefix}-bucket"
  access_type    = var.bucket_access_type
  freeform_tags  = var.freeform_tags

  # Emit a versioning-enabled bucket; safe to remove if not needed
  versioning = "Enabled"
}

data "oci_objectstorage_namespace" "this" {
  compartment_id = var.compartment_ocid
}

# ── Block volume ──────────────────────────────────────────────────────────────

resource "oci_core_volume" "this" {
  compartment_id      = var.compartment_ocid
  availability_domain = var.availability_domain
  display_name        = "${var.name_prefix}-volume"
  size_in_gbs         = var.block_volume_size_gb
  freeform_tags       = var.freeform_tags

  source_details {
    # Creates a blank volume; swap type to "volume" or "volumeBackup" to clone
    type = "none"
  }
}
