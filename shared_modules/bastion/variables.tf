variable "compartment_ocid" {
  description = "The OCID of the compartment to create resources in"
  type        = string
}

variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
}

variable "vcn_id" {
  description = "The OCID of the VCN"
  type        = string
}

variable "public_subnet_id" {
  description = "The OCID of the public subnet where the bastion host will be created"
  type        = string
}

variable "private_cidr" {
  description = "The CIDR block of the first private subnet"
  type        = string
}

variable "private_cidr_2" {
  description = "The CIDR block of the second private subnet"
  type        = string
}

variable "bastion_shape" {
  description = "The shape of the bastion host instance"
  type        = string
  default     = "VM.Standard.E4.Flex"
}

variable "bastion_ocpus" {
  description = "Number of OCPUs for the bastion host"
  type        = number
  default     = 1
}

variable "bastion_memory_in_gbs" {
  description = "Amount of memory in GBs for the bastion host"
  type        = number
  default     = 4
}

variable "ssh_public_key" {
  description = "The SSH public key to be used for the bastion host"
  type        = string
}

variable "defined_tags" {
  description = "Defined tags to be applied to all resources"
  type        = map(string)
  default     = {}
} 