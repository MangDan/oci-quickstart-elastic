# Gets a list of Availability Domains
data "oci_identity_availability_domains" "ADs" {
  compartment_id = var.tenancy_ocid
}

data "oci_core_vnic_attachments" "elk_vnics" {
  compartment_id      = var.compartment_ocid
  availability_domain = var.availability_domain
  instance_id         = oci_core_instance.ELK[0].id
}

data "oci_core_vnic" "elk_vnic" {
  vnic_id = lookup(data.oci_core_vnic_attachments.elk_vnics.vnic_attachments[0], "vnic_id")
}
