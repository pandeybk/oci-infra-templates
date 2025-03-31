terraform {
  required_version = ">= 1.0"
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 6.12.0"
    }
  }
}

# Get availability domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_ocid
}

# Get the latest Oracle Linux image
data "oci_core_images" "oracle_linux" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Oracle Linux"
  operating_system_version = "8"
  shape                   = var.bastion_shape
  sort_by                 = "TIMECREATED"
  sort_order              = "DESC"
}

# Create Network Security Group for Bastion
resource "oci_core_network_security_group" "bastion_nsg" {
  compartment_id = var.compartment_ocid
  vcn_id         = var.vcn_id
  display_name   = "${var.cluster_name}-bastion-nsg"
  defined_tags   = var.defined_tags
}

# Allow SSH access to bastion from anywhere
resource "oci_core_network_security_group_security_rule" "bastion_ssh_ingress" {
  network_security_group_id = oci_core_network_security_group.bastion_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6"
  description              = "Allow SSH access to bastion"
  source                   = "0.0.0.0/0"
  tcp_options {
    destination_port_range {
      min = 22
      max = 22
    }
  }
}

# Allow bastion to access first private subnet
resource "oci_core_network_security_group_security_rule" "bastion_private_egress_1" {
  network_security_group_id = oci_core_network_security_group.bastion_nsg.id
  direction                 = "EGRESS"
  protocol                  = "6"
  description              = "Allow bastion to access first private subnet"
  destination              = var.private_cidr
  source_type              = "CIDR_BLOCK"
  tcp_options {
    destination_port_range {
      min = 22
      max = 22
    }
  }
}

# Allow bastion to access second private subnet
resource "oci_core_network_security_group_security_rule" "bastion_private_egress_2" {
  network_security_group_id = oci_core_network_security_group.bastion_nsg.id
  direction                 = "EGRESS"
  protocol                  = "6"
  description              = "Allow bastion to access second private subnet"
  destination              = var.private_cidr_2
  source_type              = "CIDR_BLOCK"
  tcp_options {
    destination_port_range {
      min = 22
      max = 22
    }
  }
}

# Create Bastion Host
resource "oci_core_instance" "bastion" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_ocid
  display_name        = "${var.cluster_name}-bastion"
  shape              = var.bastion_shape

  shape_config {
    ocpus         = var.bastion_ocpus
    memory_in_gbs = var.bastion_memory_in_gbs
  }

  create_vnic_details {
    subnet_id        = var.public_subnet_id
    assign_public_ip = true
    nsg_ids          = [oci_core_network_security_group.bastion_nsg.id]
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.oracle_linux.images[0].id
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }

  defined_tags = var.defined_tags
}

# Output the bastion host public IP
output "bastion_public_ip" {
  value = oci_core_instance.bastion.public_ip
}

# Output the bastion host private IP
output "bastion_private_ip" {
  value = oci_core_instance.bastion.private_ip
} 