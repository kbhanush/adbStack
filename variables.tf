variable "tenancy_ocid" {
}
#Default compartment workshopDevCompartment in Tenant atpdpreview11
variable "compartment_id" {
  default = "ocid1.compartment.oc1..aaaaaaaa22lrsx3p2o2gyrorw6vijcgsozs2um5zqa6b54daoatibzuvpakq"
}

variable "region" {
  default = "us-ashburn-1"
}

variable "atp_ad_num" {
  default = 3
}

variable "exashape" {
  default = "Exadata.Quarter3.100"
}
variable "bastion_ssh_public_key_file" {
  default = "./devkey.pub"
}

variable "vcn_cidr" {
  default     = "10.0.0.0/16"
  description = "CIDR for Virtual Cloud Network (VCN)"
}

variable "vcn_dns_label" {
  default     = "adbd"
  description = "DNS label for Virtual Cloud Network (VCN)"
}

