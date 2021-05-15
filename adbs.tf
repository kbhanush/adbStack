// Copyright (c) 2017, 2021, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Mozilla Public License v2.0

resource "oci_database_autonomous_container_database" "test_autonomous_container_database" {
  #Required
  autonomous_exadata_infrastructure_id = oci_database_autonomous_exadata_infrastructure.test_autonomous_exadata_infrastructure.id
  display_name                         = "Kris-terraform-test-CDB"
  patch_model                          = "RELEASE_UPDATES"

  compartment_id               = var.compartment_id
  service_level_agreement_type = "STANDARD"

  maintenance_window_details {
    preference = "CUSTOM_PREFERENCE"

    days_of_week {
      name = "MONDAY"
    }

    hours_of_day = ["4"]

    months {
      name = "JANUARY"
    }

    months {
      name = "APRIL"
    }

    months {
      name = "JULY"
    }

    months {
      name = "OCTOBER"
    }

    weeks_of_month = ["2"]
  }
  rotate_key_trigger = "true"
}

resource "random_string" "autonomous_database_admin_password" {
  length      = 16
  min_numeric = 1
  min_lower   = 1
  min_upper   = 1
  min_special = 1
}

resource "oci_database_autonomous_database" "test_autonomous_database" {
  #Required
  admin_password           = random_string.autonomous_database_admin_password.result
  compartment_id           = var.compartment_id
  cpu_core_count           = "1"
  data_storage_size_in_tbs = "1"
  db_name                  = "atpdb1"

  #Optional
  autonomous_container_database_id = oci_database_autonomous_container_database.test_autonomous_container_database.id
  db_workload                      = "OLTP"
  display_name                     = "kris-terraform-test-ADB"
  is_dedicated                     = "true"
  rotate_key_trigger = "true"
}

data "oci_database_autonomous_container_databases" "test_autonomous_container_databases" {
  #Required
  compartment_id = var.compartment_id

  #Optional
  autonomous_exadata_infrastructure_id = oci_database_autonomous_exadata_infrastructure.test_autonomous_exadata_infrastructure.id
  availability_domain                  = data.oci_identity_availability_domain.ad.name
  display_name                         = "Kris-terraform-test-CDB"
  state                                = "AVAILABLE"
}

data "oci_database_autonomous_databases" "autonomous_databases" {
  #Required
  compartment_id = var.compartment_id

  #Optional
  autonomous_container_database_id = oci_database_autonomous_container_database.test_autonomous_container_database.id
  display_name                     = oci_database_autonomous_database.test_autonomous_database.display_name
  db_workload                      = "OLTP"
}

data "oci_database_autonomous_exadata_infrastructure_ocpu" "test_autonomous_exadata_infrastructure_ocpu" {
  #Required
  autonomous_exadata_infrastructure_id = oci_database_autonomous_exadata_infrastructure.test_autonomous_exadata_infrastructure.id
}

output "autonomous_database_consumed_cpu" {
  value = data.oci_database_autonomous_exadata_infrastructure_ocpu.test_autonomous_exadata_infrastructure_ocpu.consumed_cpu
}

output "autonomous_database_admin_password" {
  value = random_string.autonomous_database_admin_password.result
}

output "autonomous_database_high_connection_string" {
  value = lookup(
    oci_database_autonomous_database.test_autonomous_database.connection_strings[0].all_connection_strings,
    "high",
    "unavailable",
  )
}

output "autonomous_databases" {
  value = data.oci_database_autonomous_databases.autonomous_databases.autonomous_databases
}

output "autonomous_container_databases" {
  value = data.oci_database_autonomous_container_databases.test_autonomous_container_databases.autonomous_container_databases
}

