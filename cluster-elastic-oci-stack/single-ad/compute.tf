resource "oci_core_instance" "BastionHost" {
  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[0]["name"]
  fault_domain = data.oci_identity_fault_domains.FDs.fault_domains[0]["name"]
  compartment_id      = var.compartment_ocid
  display_name        = "BastionHost"
  shape               = var.BastionShape

  create_vnic_details {
    subnet_id              = oci_core_subnet.BastionSubnetAD1.id
    skip_source_dest_check = true
  }

  metadata = {
    ssh_authorized_keys = chomp(file(var.ssh_public_key))
 #   user_data           = base64encode(file(var.BastionBootStrap))
  }

  source_details {
    source_id   = var.InstanceImageOCID[var.region]
    source_type = "image"
  }

  timeouts {
    create = var.create_timeout
  }
}

resource "null_resource" "bastion-remote-exec" {
  depends_on = [oci_core_instance.BastionHost]
  
  connection {
    agent       = false
    timeout     = "1m"
    host        = oci_core_instance.BastionHost.public_ip
    user        = "opc"
    private_key = file(var.ssh_private_key)
#    script_path = "/tmp/${var.BastionBootStrap}"
  }

  provisioner "file" {
    source      = "scripts/${var.BastionBootStrap}"
    destination = "/tmp/${var.BastionBootStrap}"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/${var.BastionBootStrap}",
      "sudo /tmp/${var.BastionBootStrap}"
    ]
  }
}

resource "oci_core_instance" "ESMasterNode1" {
  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[0]["name"]
  fault_domain = data.oci_identity_fault_domains.FDs.fault_domains[0]["name"]
  compartment_id      = var.compartment_ocid
  display_name        = "ESMasterNode1"
  shape               = var.MasterNodeShape
  #depends_on          = [oci_core_instance.BastionHost]

  create_vnic_details {
    subnet_id        = oci_core_subnet.PrivSubnetAD1.id
    assign_public_ip = false
  }

  metadata = {
    ssh_authorized_keys = chomp(file(var.ssh_public_key))
#    user_data           = base64encode(file(var.ESBootStrap))
  }

  source_details {
    source_id               = var.InstanceImageOCID[var.region]
    source_type             = "image"
    boot_volume_size_in_gbs = var.BootVolSize
  }

  timeouts {
    create = var.create_timeout
  }
}

resource "null_resource" "esmaster1-remote-exec" {
  depends_on = [oci_core_instance.ESMasterNode1]
  
  connection {
    agent               = false
    timeout             = "100s"
    host                = oci_core_instance.ESMasterNode1.private_ip
    user                = "opc"
    private_key         = file(var.ssh_private_key)
    bastion_host        = oci_core_instance.BastionHost.public_ip
    bastion_user        = "opc"
    bastion_private_key = file(var.ssh_private_key)
#    script_path = "/tmp/${var.ESBootStrap}"
  }

  provisioner "file" {
    source      = "scripts/${var.ESBootStrap}"
    destination = "/tmp/${var.ESBootStrap}"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/${var.ESBootStrap}",
      "sudo /tmp/${var.ESBootStrap}"
    ]
  }
}

resource "oci_core_instance" "ESMasterNode2" {
  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[0]["name"]
  fault_domain = data.oci_identity_fault_domains.FDs.fault_domains[1]["name"]
  compartment_id      = var.compartment_ocid
  display_name        = "ESMasterNode2"
  shape               = var.MasterNodeShape
  #depends_on          = [oci_core_instance.BastionHost]

  create_vnic_details {
    subnet_id        = oci_core_subnet.PrivSubnetAD1.id
    assign_public_ip = false
  }

  metadata = {
    ssh_authorized_keys = chomp(file(var.ssh_public_key))
#    user_data           = base64encode(file(var.ESBootStrap))
  }

  source_details {
    source_id               = var.InstanceImageOCID[var.region]
    source_type             = "image"
    boot_volume_size_in_gbs = var.BootVolSize
  }

  timeouts {
    create = var.create_timeout
  }
}

resource "null_resource" "esmaster2-remote-exec" {
  depends_on = [oci_core_instance.ESMasterNode2]

  connection {
    agent               = false
    timeout             = "100s"
    host                = oci_core_instance.ESMasterNode2.private_ip
    user                = "opc"
    private_key         = file(var.ssh_private_key)
    bastion_host        = oci_core_instance.BastionHost.public_ip
    bastion_user        = "opc"
    bastion_private_key = file(var.ssh_private_key)
#    script_path = "/tmp/${var.ESBootStrap}"
  }

  provisioner "file" {
    source      = "scripts/${var.ESBootStrap}"
    destination = "/tmp/${var.ESBootStrap}"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/${var.ESBootStrap}",
      "sudo /tmp/${var.ESBootStrap}"
    ]
  }
}

resource "oci_core_instance" "ESMasterNode3" {
  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[0]["name"]
  fault_domain = data.oci_identity_fault_domains.FDs.fault_domains[2]["name"]
  compartment_id      = var.compartment_ocid
  display_name        = "ESMasterNode3"
  shape               = var.MasterNodeShape
  #depends_on          = [oci_core_instance.BastionHost]

  create_vnic_details {
    subnet_id        = oci_core_subnet.PrivSubnetAD1.id
    assign_public_ip = false
  }

  metadata = {
    ssh_authorized_keys = chomp(file(var.ssh_public_key))
#    user_data           = base64encode(file(var.ESBootStrap))
  }

  source_details {
    source_id               = var.InstanceImageOCID[var.region]
    source_type             = "image"
    boot_volume_size_in_gbs = var.BootVolSize
  }

  timeouts {
    create = var.create_timeout
  }
}

resource "null_resource" "esmaster3-remote-exec" {
  depends_on = [oci_core_instance.ESMasterNode3]
  
  connection {
    agent               = false
    timeout             = "100s"
    host                = oci_core_instance.ESMasterNode3.private_ip
    user                = "opc"
    private_key         = file(var.ssh_private_key)
    bastion_host        = oci_core_instance.BastionHost.public_ip
    bastion_user        = "opc"
    bastion_private_key = file(var.ssh_private_key)
#    script_path = "/tmp/${var.ESBootStrap}"
  }

  provisioner "file" {
    source      = "scripts/${var.ESBootStrap}"
    destination = "/tmp/${var.ESBootStrap}"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/${var.ESBootStrap}",
      "sudo /tmp/${var.ESBootStrap}"
    ]
  }
}

resource "oci_core_instance" "ESDataNode1" {
  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[0]["name"]
  fault_domain = data.oci_identity_fault_domains.FDs.fault_domains[0]["name"]
  compartment_id      = var.compartment_ocid
  display_name        = "ESDataNode1"
  shape               = var.DataNodeShape
  #depends_on          = [oci_core_instance.BastionHost]

  create_vnic_details {
    subnet_id        = oci_core_subnet.PrivSubnetAD1.id
    assign_public_ip = false
  }

  metadata = {
    ssh_authorized_keys = chomp(file(var.ssh_public_key))
#    user_data           = base64encode(file(var.ESBootStrap))
  }

  source_details {
    source_id               = var.InstanceImageOCID[var.region]
    source_type             = "image"
    boot_volume_size_in_gbs = var.BootVolSize
  }

  timeouts {
    create = var.create_timeout
  }
}

resource "null_resource" "esdata1-remote-exec" {
  depends_on = [oci_core_instance.ESDataNode1]

  connection {
    agent               = false
    timeout             = "100s"
    host                = oci_core_instance.ESDataNode1.private_ip
    user                = "opc"
    private_key         = file(var.ssh_private_key)
    bastion_host        = oci_core_instance.BastionHost.public_ip
    bastion_user        = "opc"
    bastion_private_key = file(var.ssh_private_key)
#    script_path = "/tmp/${var.ESBootStrap}"
  }

  provisioner "file" {
    source      = "scripts/${var.ESBootStrap}"
    destination = "/tmp/${var.ESBootStrap}"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/${var.ESBootStrap}",
      "sudo /tmp/${var.ESBootStrap}"
    ]
  }
}

resource "oci_core_instance" "ESDataNode2" {
  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[0]["name"]
  fault_domain = data.oci_identity_fault_domains.FDs.fault_domains[1]["name"]
  compartment_id      = var.compartment_ocid
  display_name        = "ESDataNode2"
  shape               = var.DataNodeShape
  depends_on          = [oci_core_instance.BastionHost]

  create_vnic_details {
    subnet_id        = oci_core_subnet.PrivSubnetAD1.id
    assign_public_ip = false
  }

  metadata = {
    ssh_authorized_keys = chomp(file(var.ssh_public_key))
#    user_data           = base64encode(file(var.ESBootStrap))
  }

  source_details {
    source_id               = var.InstanceImageOCID[var.region]
    source_type             = "image"
    boot_volume_size_in_gbs = var.BootVolSize
  }

  timeouts {
    create = var.create_timeout
  }
}

resource "null_resource" "esdata2-remote-exec" {
  depends_on = [oci_core_instance.ESDataNode2]
  
  connection {
    agent               = false
    timeout             = "100s"
    host                = oci_core_instance.ESDataNode2.private_ip
    user                = "opc"
    private_key         = file(var.ssh_private_key)
    bastion_host        = oci_core_instance.BastionHost.public_ip
    bastion_user        = "opc"
    bastion_private_key = file(var.ssh_private_key)
#    script_path = "/tmp/${var.ESBootStrap}"
  }

  provisioner "file" {
    source      = "scripts/${var.ESBootStrap}"
    destination = "/tmp/${var.ESBootStrap}"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/${var.ESBootStrap}",
      "sudo /tmp/${var.ESBootStrap}"
    ]
  }
}

resource "oci_core_instance" "ESDataNode3" {
  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[0]["name"]
  fault_domain = data.oci_identity_fault_domains.FDs.fault_domains[2]["name"]
  compartment_id      = var.compartment_ocid
  display_name        = "ESDataNode3"
  shape               = var.DataNodeShape
  depends_on          = [oci_core_instance.BastionHost]

  create_vnic_details {
    subnet_id        = oci_core_subnet.PrivSubnetAD1.id
    assign_public_ip = false
  }

  metadata = {
    ssh_authorized_keys = chomp(file(var.ssh_public_key))
#    user_data           = base64encode(file(var.ESBootStrap))
  }

  source_details {
    source_id               = var.InstanceImageOCID[var.region]
    source_type             = "image"
    boot_volume_size_in_gbs = var.BootVolSize
  }

  timeouts {
    create = var.create_timeout
  }
}

resource "null_resource" "esdata3-remote-exec" {
  depends_on = [oci_core_instance.ESDataNode3]

  connection {
    agent               = false
    timeout             = "100s"
    host                = oci_core_instance.ESDataNode3.private_ip
    user                = "opc"
    private_key         = file(var.ssh_private_key)
    bastion_host        = oci_core_instance.BastionHost.public_ip
    bastion_user        = "opc"
    bastion_private_key = file(var.ssh_private_key)
#    script_path = "/tmp/${var.ESBootStrap}"
  }

  provisioner "file" {
    source      = "scripts/${var.ESBootStrap}"
    destination = "/tmp/${var.ESBootStrap}"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/${var.ESBootStrap}",
      "sudo /tmp/${var.ESBootStrap}"
    ]
  }
}