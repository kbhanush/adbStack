/* Network */
locals {
  // VCN is /16
  bastion_subnet_prefix = cidrsubnet(var.vcn_cidr, 6, 0)
  lb_subnet_prefix      = cidrsubnet(var.vcn_cidr, 6, 1)
  web_subnet_prefix     = cidrsubnet(var.vcn_cidr, 6, 2)
  app_subnet_prefix     = cidrsubnet(var.vcn_cidr, 6, 3)
  fss_subnet_prefix     = cidrsubnet(var.vcn_cidr, 6, 4)
  db_subnet_prefix      = cidrsubnet(var.vcn_cidr, 6, 5)
}

data "oci_core_services" "svcgtw_services" {
  filter {
    name   = "name"
    values = [".*Object.*Storage"]
    regex  = true
  }
}

resource "oci_core_vcn" "vcn1" {
  cidr_block     = var.vcn_cidr
  compartment_id = var.compartment_ocid
  #display_name   = var.vcn_dns_label
  display_name   = "Kris-terraform-VCN-1"
  dns_label      = var.vcn_dns_label
}

# Internet Gateway
resource "oci_core_internet_gateway" "igw" {
  compartment_id = var.compartment_ocid
  display_name   = "${var.vcn_dns_label}igw"
  vcn_id         = oci_core_vcn.vcn1.id
}

# NAT (Network Address Translation) Gateway
resource "oci_core_nat_gateway" "natgtw" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn1.id
  display_name   = "${var.vcn_dns_label}natgtw"
}

# Service Gateway
resource "oci_core_service_gateway" "svcgtw" {
  compartment_id = var.compartment_ocid
  services {
    service_id = data.oci_core_services.svcgtw_services.services[0]["id"]
  }
  vcn_id       = oci_core_vcn.vcn1.id
  display_name = "${var.vcn_dns_label}svcgtw"
}

# Dynamic Routing Gateway (DRG)
resource "oci_core_drg" "drg" {
  compartment_id = var.compartment_ocid
  display_name   = "${var.vcn_dns_label}drg"
}

resource "oci_core_drg_attachment" "drg_attachment" {
  drg_id       = oci_core_drg.drg.id
  vcn_id       = oci_core_vcn.vcn1.id
  display_name = "${var.vcn_dns_label}drgattch"
}

resource "oci_core_subnet" "bastion_subnet" {
  cidr_block        = local.bastion_subnet_prefix
  display_name      = "bastion"
  dns_label         = "bastion"
  security_list_ids = [oci_core_security_list.BastionSecList.id]
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_vcn.vcn1.id
  route_table_id    = oci_core_route_table.PublicRT.id
  dhcp_options_id   = oci_core_vcn.vcn1.default_dhcp_options_id
}

resource "oci_core_subnet" "lb_subnet" {
  cidr_block        = local.lb_subnet_prefix
  display_name      = "lb"
  dns_label         = "lb"
  security_list_ids = [oci_core_security_list.WebSecList.id]
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_vcn.vcn1.id
  route_table_id    = oci_core_route_table.PublicRT.id
  dhcp_options_id   = oci_core_vcn.vcn1.default_dhcp_options_id
}

resource "oci_core_subnet" "web_subnet" {
  cidr_block        = local.web_subnet_prefix
  display_name      = "web"
  dns_label         = "web"
  security_list_ids = [oci_core_security_list.WebSecList.id]
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_vcn.vcn1.id
  route_table_id    = oci_core_route_table.PublicRT.id
  dhcp_options_id   = oci_core_vcn.vcn1.default_dhcp_options_id
}

resource "oci_core_subnet" "app_subnet" {
  cidr_block                 = local.app_subnet_prefix
  display_name               = "app"
  dns_label                  = "app"
  security_list_ids          = [oci_core_security_list.PrivateSecList.id]
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_vcn.vcn1.id
  route_table_id             = oci_core_route_table.PrivateRT.id
  dhcp_options_id            = oci_core_vcn.vcn1.default_dhcp_options_id
  prohibit_public_ip_on_vnic = true
}

resource "oci_core_subnet" "fss_subnet" {
  cidr_block                 = local.fss_subnet_prefix
  display_name               = "fss"
  dns_label                  = "fss"
  security_list_ids          = [oci_core_security_list.PrivateSecList.id]
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_vcn.vcn1.id
  route_table_id             = oci_core_route_table.PrivateRT.id
  dhcp_options_id            = oci_core_vcn.vcn1.default_dhcp_options_id
  prohibit_public_ip_on_vnic = true
}

resource "oci_core_subnet" "db_subnet" {
  cidr_block                 = local.db_subnet_prefix
  display_name               = "db"
  dns_label                  = "db"
  security_list_ids          = [oci_core_security_list.PrivateSecList.id]
  compartment_id             = var.compartment_ocid
  vcn_id                     = oci_core_vcn.vcn1.id
  route_table_id             = oci_core_route_table.PrivateRT.id
  dhcp_options_id            = oci_core_vcn.vcn1.default_dhcp_options_id
  prohibit_public_ip_on_vnic = true
}

