resource "oci_core_instance" "this" {
  count = var.instance_count

  compartment_id      = var.compartment_ocid
  availability_domain = var.availability_domain
  display_name        = "${var.name_prefix}-instance-${count.index + 1}"
  shape               = var.shape
  freeform_tags       = var.freeform_tags

  shape_config {
    ocpus         = var.ocpus
    memory_in_gbs = var.memory_gb
  }

  source_details {
    source_type = "image"
    source_id   = var.image_id
  }

  create_vnic_details {
    subnet_id        = var.subnet_id
    assign_public_ip = false
    display_name     = "${var.name_prefix}-vnic-${count.index + 1}"
    hostname_label   = "${var.name_prefix}-${count.index + 1}"
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }

  # Replace instance when image changes rather than in-place update
  lifecycle {
    ignore_changes = [source_details[0].source_id]
  }
}
