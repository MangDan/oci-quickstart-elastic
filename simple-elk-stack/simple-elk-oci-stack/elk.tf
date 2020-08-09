data "template_file" "ELK" {
  template = file("./scripts/elk.sh")
}

resource "oci_core_instance" "ELK" {
  count               = var.num_nodes
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_ocid
  display_name        = "ELK-${count.index}"
  shape               = local.instance_shape

  create_vnic_details {
    subnet_id        = oci_core_subnet.ELKSubnet.id
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "elk-${count.index}"
  }

  source_details {
    source_type = "image"
    source_id   = local.images[var.region]
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key)
    user_data           = base64encode(data.template_file.ELK.rendered)
  }
}

# https://docs.cloud.oracle.com/en-us/iaas/images/image/54f930a3-0bf3-4f5d-b573-10eeeb7c7b03/
# Oracle-Linux-7.7-2020.03.23-0
locals {
  images = {
    ap-melbourne-1	= "ocid1.image.oc1.ap-melbourne-1.aaaaaaaakh4vq4fswqw7ftjiix7qbdzdrvhyq44upcgm66nbfcefg6miwosa"
    ap-mumbai-1	    = "ocid1.image.oc1.ap-mumbai-1.aaaaaaaa6rvxc6vju5grxdydrbhzou7ayukiljhog75o222rxsunoi3p6zxq"
    ap-osaka-1	    = "ocid1.image.oc1.ap-osaka-1.aaaaaaaa23apvyouh3fuiw7aqjo574zsmgdwtetato6uxgu7tct7y4uaqila"
    ap-seoul-1	    = "ocid1.image.oc1.ap-seoul-1.aaaaaaaautl44ij44xudvnu3boasvuvucowuz4avdigc2csahzqmtb37sfwa"
    ap-sydney-1	    = "ocid1.image.oc1.ap-sydney-1.aaaaaaaaalaybaovkxlwr3etmvyavmec6uftnluicausjety3fmbr5geapcq"
    ap-tokyo-1	    = "ocid1.image.oc1.ap-tokyo-1.aaaaaaaa3i5j5ackcuimnjh7ns3xjwedwq7r6ejgu7eikwaqd6m3sqbjgrqq"
    ca-montreal-1	  = "ocid1.image.oc1.ca-montreal-1.aaaaaaaaqswshvu66v5u236nb5kyvtdyrnjjciyeu4smx6xzgr33dcdn3zzq"
    ca-toronto-1	  = "cid1.image.oc1.ca-toronto-1.aaaaaaaa6onp4oo4n2plt7pxbdskjsuoinny6ust237mn5oeofp3pi474xza"
    eu-amsterdam-1	= "ocid1.image.oc1.eu-amsterdam-1.aaaaaaaashhgpi4jrjvogh2ditlujvspzujci2giy7ju5bndneh4hlcrfjwa"
    eu-frankfurt-1	= "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaadvi77prh3vjijhwe5xbd6kjg3n5ndxjcpod6om6qaiqeu3csof7a"
    eu-zurich-1	    = "ocid1.image.oc1.eu-zurich-1.aaaaaaaa4ltjbbkhdrcrnefzwts43ryjvka7clmubvndhcie633d4gyezflq"
    me-jeddah-1	    = "ocid1.image.oc1.me-jeddah-1.aaaaaaaabs62ebfqfdjnvk25jxhkvss3bluwjay24mfvmqqtduz4ctbvjcva"
    sa-saopaulo-1	  = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaaq6usivsg6wduije3aptwfoxvqfqfrpxq34isfssjmy676p2dduda"
    uk-gov-london-1	= "ocid1.image.oc4.uk-gov-london-1.aaaaaaaazjplti3mj44tdkpvcugi5dbjfdz6eqh3tobc3wsrdg5wprxom3sa"
    uk-london-1	    = "ocid1.image.oc1.uk-london-1.aaaaaaaaw5gvriwzjhzt2tnylrfnpanz5ndztyrv3zpwhlzxdbkqsjfkwxaq"
    us-ashburn-1	  = "ocid1.image.oc1.iad.aaaaaaaa6tp7lhyrcokdtf7vrbmxyp2pctgg4uxvt4jz4vc47qoc2ec4anha"
    us-langley-1	  = "ocid1.image.oc2.us-langley-1.aaaaaaaanpy5qap45zeroc7u5unxcn6cbkea5bymx4ubbqmk4psqqe27moeq"
    us-luke-1	      = "ocid1.image.oc2.us-luke-1.aaaaaaaahy2n6lnu4lwmllfqphpj32uk6vyo5x2pbv2n4zfzttqjmjb54lbq"
    us-phoenix-1	  = "ocid1.image.oc1.phx.aaaaaaaa6hooptnlbfwr5lwemqjbu3uqidntrlhnt45yihfj222zahe7p3wq"
  }

  instance_shape = "VM.Standard2.2"

  availability_domain = 1
}
