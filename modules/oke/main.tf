# ── Kubernetes version ────────────────────────────────────────────────────────

data "oci_containerengine_cluster_option" "this" {
  cluster_option_id = "all"
  compartment_id    = var.compartment_ocid
}

locals {
  all_k8s_versions   = sort(data.oci_containerengine_cluster_option.this.kubernetes_versions)
  kubernetes_version = local.all_k8s_versions[length(local.all_k8s_versions) - 1]
}

# ── Cluster ───────────────────────────────────────────────────────────────────

resource "oci_containerengine_cluster" "this" {
  compartment_id     = var.compartment_ocid
  name               = "${var.name_prefix}-oke"
  kubernetes_version = local.kubernetes_version
  vcn_id             = var.vcn_id
  type               = "BASIC_CLUSTER"
  freeform_tags      = var.freeform_tags

  endpoint_config {
    subnet_id            = var.api_endpoint_subnet_id
    is_public_ip_enabled = true
  }

  options {
    service_lb_subnet_ids = [var.lb_subnet_id]

    kubernetes_network_config {
      pods_cidr     = "10.244.0.0/16"
      services_cidr = "10.96.0.0/16"
    }

    add_ons {
      is_kubernetes_dashboard_enabled = false
      is_tiller_enabled               = false
    }
  }
}

# node_pool_os_arch = "X86_64" tells the API to return only x86_64-compatible
# images, removing the need for client-side architecture filtering.
data "oci_containerengine_node_pool_option" "this" {
  node_pool_option_id = oci_containerengine_cluster.this.id
  compartment_id      = var.compartment_ocid
  node_pool_os_arch   = "X86_64"
}

locals {
  # Filter for Oracle Linux 7.9 OKE images (x86_64 already guaranteed by node_pool_os_arch)
  oke_images    = [for s in data.oci_containerengine_node_pool_option.this.sources : s if s.source_type == "IMAGE" && can(regex("Oracle-Linux-7\\.9.*OKE", s.source_name))]
  node_image_id = local.oke_images[0].image_id
}

# ── Node pool ─────────────────────────────────────────────────────────────────

resource "oci_containerengine_node_pool" "this" {
  cluster_id     = oci_containerengine_cluster.this.id
  compartment_id = var.compartment_ocid
  name           = "${var.name_prefix}-nodepool"
  node_shape     = var.node_shape
  freeform_tags  = var.freeform_tags

  dynamic "node_shape_config" {
    for_each = can(regex("Flex", var.node_shape)) ? [1] : []
    content {
      ocpus         = var.node_ocpus
      memory_in_gbs = var.node_memory_gb
    }
  }

  node_source_details {
    source_type             = "IMAGE"
    image_id                = local.node_image_id
    boot_volume_size_in_gbs = 50
  }

  node_config_details {
    size = var.node_count

    placement_configs {
      availability_domain = var.availability_domain
      subnet_id           = var.node_subnet_id
    }
  }
}
