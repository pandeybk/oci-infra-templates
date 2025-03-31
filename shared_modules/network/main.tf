terraform {
  required_version = ">= 1.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 6.12.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.12.1"
    }
  }
}

resource "oci_core_vcn" "openshift_vcn" {
  cidr_blocks = [
    var.vcn_cidr,
  ]
  compartment_id = var.compartment_ocid
  display_name   = var.cluster_name
  dns_label      = var.vcn_dns_label
  defined_tags   = var.defined_tags
}

resource "time_sleep" "wait_for_vcn_creation" {
  depends_on      = [oci_core_vcn.openshift_vcn]
  create_duration = "180s"
}

resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = var.compartment_ocid
  display_name   = "InternetGateway"
  vcn_id         = oci_core_vcn.openshift_vcn.id
  defined_tags   = var.defined_tags
}

resource "oci_core_nat_gateway" "nat_gateway" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.openshift_vcn.id
  display_name   = "NatGateway"
  defined_tags   = var.defined_tags
}

resource "oci_core_service_gateway" "service_gateway" {
  compartment_id = var.compartment_ocid
  services {
    service_id = data.oci_core_services.oci_services.services[0]["id"]
  }
  vcn_id       = oci_core_vcn.openshift_vcn.id
  display_name = "ServiceGateway"
  defined_tags = var.defined_tags
}

# Allow SSH access from bastion to control plane nodes
resource "oci_core_network_security_group_security_rule" "control_plane_ssh_from_bastion" {
  network_security_group_id = oci_core_network_security_group.cluster_controlplane_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6"
  description              = "Allow SSH access from bastion subnet"
  source                   = var.public_cidr
  tcp_options {
    destination_port_range {
      min = 22
      max = 22
    }
  }
}
