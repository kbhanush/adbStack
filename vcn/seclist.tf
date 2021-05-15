/*Copyright © 2018, Oracle and/or its affiliates. All rights reserved.

The Universal Permissive License (UPL), Version 1.0*/

locals {
  tcp_protocol  = "6"
  udp_protocol  = "17"
  all_protocols = "all"
  anywhere      = "0.0.0.0/0"
  db_port       = "1521"
  ssh_port      = "22"
  http_port     = "80"
  ssl_port      = "443"
  rdp_port      = "3389"
  fss_ports     = ["2048", "2050", "111"]
}

# Bastion Security List
resource "oci_core_security_list" "BastionSecList" {
  compartment_id = var.compartment_ocid
  display_name   = "BastionSecList"
  vcn_id         = oci_core_vcn.vcn1.id

  egress_security_rules {
    protocol    = local.all_protocols
    destination = local.anywhere
    /*tcp_options {
            "min" = "${local.ssh_port}"
            "max" = "${local.ssh_port}"
        }*/
  }

  ingress_security_rules {
    tcp_options {
      min = local.ssh_port
      max = local.ssh_port
    }

    protocol = local.tcp_protocol
    source   = local.anywhere
  }
  ingress_security_rules {
    #Allow anything from the private subnets
    protocol = local.all_protocols
    source   = var.vcn_cidr
  }
}

# Public Load Balancer Security List
resource "oci_core_security_list" "WebSecList" {
  compartment_id = var.compartment_ocid
  display_name   = "WebSecList"
  vcn_id         = oci_core_vcn.vcn1.id

  egress_security_rules {
    protocol    = local.tcp_protocol
    destination = local.anywhere
  }

  ingress_security_rules {
    tcp_options {
      min = local.http_port
      max = local.http_port
    }

    protocol = local.tcp_protocol
    source   = local.anywhere
  }
  ingress_security_rules {
    tcp_options {
      min = local.ssl_port
      max = local.ssl_port
    }

    protocol = local.tcp_protocol
    source   = local.anywhere
  }
  ingress_security_rules {
    #Allow anything from the private subnets
    protocol = local.all_protocols
    source   = var.vcn_cidr
  }
}

# Private subnet Security List that allows any traffic so make sure it subnet is NOT public
resource "oci_core_security_list" "PrivateSecList" {
  compartment_id = var.compartment_ocid
  display_name   = "PrivateSecList"
  vcn_id         = oci_core_vcn.vcn1.id

  egress_security_rules {
    protocol    = local.all_protocols
    destination = local.anywhere
  }

  ingress_security_rules {
    protocol = local.all_protocols
    source   = local.anywhere
  }
}

