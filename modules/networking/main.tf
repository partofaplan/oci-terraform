# ── VCN ───────────────────────────────────────────────────────────────────────

resource "oci_core_vcn" "this" {
  compartment_id = var.compartment_ocid
  display_name   = "${var.name_prefix}-vcn"
  cidr_blocks    = [var.vcn_cidr]
  dns_label      = replace(var.name_prefix, "-", "")
  freeform_tags  = var.freeform_tags
}

resource "oci_core_internet_gateway" "this" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.name_prefix}-igw"
  enabled        = true
  freeform_tags  = var.freeform_tags
}

resource "oci_core_route_table" "public" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.name_prefix}-rt"
  freeform_tags  = var.freeform_tags

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.this.id
  }
}

# ── Security lists ────────────────────────────────────────────────────────────

resource "oci_core_security_list" "api_endpoint" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.name_prefix}-sl-api"
  freeform_tags  = var.freeform_tags

  # kubectl from internet
  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false
    tcp_options {
      min = 6443
      max = 6443
    }
  }

  # kubelet → API server
  ingress_security_rules {
    protocol    = "6"
    source      = var.nodes_subnet_cidr
    source_type = "CIDR_BLOCK"
    stateless   = false
    tcp_options {
      min = 6443
      max = 6443
    }
  }

  # OKE control plane tunnel
  ingress_security_rules {
    protocol    = "6"
    source      = var.nodes_subnet_cidr
    source_type = "CIDR_BLOCK"
    stateless   = false
    tcp_options {
      min = 12250
      max = 12250
    }
  }

  # Path MTU discovery
  ingress_security_rules {
    protocol    = "1"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false
    icmp_options {
      type = 3
      code = 4
    }
  }

  # Control plane → kubelet
  egress_security_rules {
    protocol         = "6"
    destination      = var.nodes_subnet_cidr
    destination_type = "CIDR_BLOCK"
    stateless        = false
    tcp_options {
      min = 10250
      max = 10250
    }
  }

  # Control plane tunnel → nodes
  egress_security_rules {
    protocol         = "6"
    destination      = var.nodes_subnet_cidr
    destination_type = "CIDR_BLOCK"
    stateless        = false
    tcp_options {
      min = 12250
      max = 12250
    }
  }

  egress_security_rules {
    protocol         = "1"
    destination      = var.nodes_subnet_cidr
    destination_type = "CIDR_BLOCK"
    stateless        = false
    icmp_options {
      type = 3
      code = 4
    }
  }
}

resource "oci_core_security_list" "nodes" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.name_prefix}-sl-nodes"
  freeform_tags  = var.freeform_tags

  # Control plane → worker (kubelet, kube-proxy, tunnel)
  ingress_security_rules {
    protocol    = "all"
    source      = var.api_subnet_cidr
    source_type = "CIDR_BLOCK"
    stateless   = false
  }

  # Pod-to-pod and node-to-node within the cluster
  ingress_security_rules {
    protocol    = "all"
    source      = var.nodes_subnet_cidr
    source_type = "CIDR_BLOCK"
    stateless   = false
  }

  # NodePort traffic from load balancer subnet
  ingress_security_rules {
    protocol    = "6"
    source      = var.lb_subnet_cidr
    source_type = "CIDR_BLOCK"
    stateless   = false
    tcp_options {
      min = 30000
      max = 32767
    }
  }

  # Path MTU discovery
  ingress_security_rules {
    protocol    = "1"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false
    icmp_options {
      type = 3
      code = 4
    }
  }

  # All egress — nodes need internet access for image pulls (public subnet, no NAT)
  egress_security_rules {
    protocol         = "all"
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    stateless        = false
  }
}

resource "oci_core_security_list" "lb" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.name_prefix}-sl-lb"
  freeform_tags  = var.freeform_tags

  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false
    tcp_options {
      min = 80
      max = 80
    }
  }

  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false
    tcp_options {
      min = 443
      max = 443
    }
  }

  egress_security_rules {
    protocol         = "6"
    destination      = var.nodes_subnet_cidr
    destination_type = "CIDR_BLOCK"
    stateless        = false
    tcp_options {
      min = 30000
      max = 32767
    }
  }
}

# ── Subnets ───────────────────────────────────────────────────────────────────

resource "oci_core_subnet" "api_endpoint" {
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_vcn.this.id
  display_name      = "${var.name_prefix}-subnet-api"
  cidr_block        = var.api_subnet_cidr
  dns_label         = "api"
  route_table_id    = oci_core_route_table.public.id
  security_list_ids = [oci_core_security_list.api_endpoint.id]
  freeform_tags     = var.freeform_tags
}

resource "oci_core_subnet" "nodes" {
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_vcn.this.id
  display_name      = "${var.name_prefix}-subnet-nodes"
  cidr_block        = var.nodes_subnet_cidr
  dns_label         = "nodes"
  route_table_id    = oci_core_route_table.public.id
  security_list_ids = [oci_core_security_list.nodes.id]
  freeform_tags     = var.freeform_tags
}

resource "oci_core_subnet" "lb" {
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_vcn.this.id
  display_name      = "${var.name_prefix}-subnet-lb"
  cidr_block        = var.lb_subnet_cidr
  dns_label         = "lb"
  route_table_id    = oci_core_route_table.public.id
  security_list_ids = [oci_core_security_list.lb.id]
  freeform_tags     = var.freeform_tags
}
