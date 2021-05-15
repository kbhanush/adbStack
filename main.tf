# Create Virtual Cloud Network (VCN)
module "create_net" {
  source = "./vcn"

  compartment_ocid = var.compartment_id
  vcn_cidr         = var.vcn_cidr
  vcn_dns_label    = var.vcn_dns_label
}

data "oci_identity_availability_domain" "ad" {
  compartment_id = var.compartment_id
  ad_number      = var.atp_ad_num
}


# Create bastion host
resource "oci_core_instance" "create_bastion" {
  compartment_id      = var.compartment_id
  availability_domain = data.oci_identity_availability_domain.ad.name
  shape               = "VM.Standard2.1"
  display_name        = "devtools"
  create_vnic_details {
    hostname_label = "devtools"
    subnet_id      = module.create_net.basNetId
  }
  metadata = {
    #ssh_authorized_keys = "${var.bastion_ssh_public_key}"
    ssh_authorized_keys = trimspace(file(var.bastion_ssh_public_key_file))
  }
  source_details {
    source_id = "ocid1.image.oc1.iad.aaaaaaaaiu73xa6afjzskjwvt3j5shpmboxtlo7yw4xpeqpdz5czpde7px2a"
    source_type             = "image"
    boot_volume_size_in_gbs = "120"
  }
}

output "BastionPubIP" {
  value = oci_core_instance.create_bastion.public_ip
}