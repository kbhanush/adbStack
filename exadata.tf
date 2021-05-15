// Copyright (c) 2017, 2021, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Mozilla Public License v2.0

resource "oci_database_autonomous_exadata_infrastructure" "test_autonomous_exadata_infrastructure" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_id
  display_name        = "ADBDtest"
  license_model       = "LICENSE_INCLUDED"

  shape     = var.exashape
  subnet_id      = module.create_net.dbNetId
}

data "oci_database_autonomous_exadata_infrastructures" "test_autonomous_exadata_infrastructures" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_id
  display_name        = "TestExadata"
  state               = "AVAILABLE"
}

data "oci_database_autonomous_exadata_infrastructure" "test_autonomous_exadata_infrastructure" {
  autonomous_exadata_infrastructure_id = oci_database_autonomous_exadata_infrastructure.test_autonomous_exadata_infrastructure.id
}

output "test_autonomous_exadata_infrastructures" {
  value = [data.oci_database_autonomous_exadata_infrastructures.test_autonomous_exadata_infrastructures.autonomous_exadata_infrastructures]
}

