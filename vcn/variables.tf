variable "compartment_ocid" {
}

variable "vcn_cidr" {
  default     = "11.0.0.0/16"
  description = "CIDR for Virtual Cloud Network (VCN)"
}

variable "vcn_dns_label" {
  default     = "adbd"
  description = "DNS label for Virtual Cloud Network (VCN)"
}

