/*Copyright © 2018, Oracle and/or its affiliates. All rights reserved.

The Universal Permissive License (UPL), Version 1.0*/

# Public Route Table
resource "oci_core_route_table" "PublicRT" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn1.id
  display_name   = "${var.vcn_dns_label}pubrt"

  route_rules {
    destination       = local.anywhere
    network_entity_id = oci_core_internet_gateway.igw.id
  }
}

# Private Route Table
resource "oci_core_route_table" "PrivateRT" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn1.id
  display_name   = "${var.vcn_dns_label}pvtrt"

  route_rules {
    destination       = data.oci_core_services.svcgtw_services.services[0]["cidr_block"]
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.svcgtw.id
  }
  route_rules {
    destination       = local.anywhere
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.natgtw.id
  }
}

