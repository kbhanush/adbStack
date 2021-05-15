/*Copyright © 2018, Oracle and/or its affiliates. All rights reserved.

The Universal Permissive License (UPL), Version 1.0*/

output "vcnid" {
  description = "ocid of VCN"
  value       = oci_core_vcn.vcn1.id
}

output "default_dhcp_id" {
  description = "ocid of default DHCP options"
  value       = oci_core_vcn.vcn1.default_dhcp_options_id
}

output "igw_id" {
  description = "ocid of internet gateway"
  value       = oci_core_internet_gateway.igw.id
}

output "natgtw_id" {
  description = "ocid of service gateway"
  value       = oci_core_nat_gateway.natgtw.id
}

output "svcgtw_id" {
  description = "ocid of service gateway"
  value       = oci_core_service_gateway.svcgtw.id
}

output "drgid" {
  value = oci_core_drg.drg.id
}

output "basNetId" {
  value = oci_core_subnet.bastion_subnet.id
}

output "lbNetId" {
  value = oci_core_subnet.lb_subnet.id
}

output "webNetId" {
  value = oci_core_subnet.web_subnet.id
}

output "appNetId" {
  value = oci_core_subnet.app_subnet.id
}

output "fssNetId" {
  value = oci_core_subnet.fss_subnet.id
}

output "dbNetId" {
  value = oci_core_subnet.db_subnet.id
}

