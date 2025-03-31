variable "compartment_ocid" {
  description = "The OCID of the compartment to create resources in"
  type        = string
}

variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
}

variable "vcn_cidr" {
  description = "The CIDR block for the VCN"
  type        = string
}

variable "private_cidr" {
  description = "The CIDR block for the first private subnet"
  type        = string
}

variable "private_cidr_2" {
  description = "The CIDR block for the second private subnet"
  type        = string
}

variable "public_cidr" {
  description = "The CIDR block for the public subnet"
  type        = string
}

variable "vcn_dns_label" {
  description = "The DNS label for the VCN"
  type        = string
}

variable "defined_tags" {
  description = "Defined tags to be applied to all resources"
  type        = map(string)
  default     = {}
}
