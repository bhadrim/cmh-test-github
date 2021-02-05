provider "ibm" {
  region = "${var.region}"
}

resource "random_integer" "key" {
  min     = 1
  max     = 50000
}

resource "ibm_is_vpc" "test_vpc" {
  name = "test-vpc-${random_integer.key.result}"
  tags    = ["${concat(var.tags, module.camtags.tagslist)}"]
}

resource "ibm_is_subnet" "test_subnet" {
  name            = "test-subnet-${random_integer.key.result}"
  vpc             = "${ibm_is_vpc.test_vpc.id}"
  zone            = "${var.zone}"
}

resource "ibm_is_ssh_key" "test_sshkey" {
  name       = "test-ssh-${random_integer.key.result}"
  public_key = "${var.public_ssh_key}"
}

## Web server VSI
resource "ibm_is_instance" "web-server" {
  name    = "web-server-vsi-${random_integer.key.result}"
  image   = "${var.image_id}"
  profile = "${var.profile}"

  primary_network_interface {
    subnet = "${ibm_is_subnet.test_subnet.id}"
  }

  vpc     = "${ibm_is_vpc.test_vpc.id}"
  zone    = "${var.zone}"
  keys    = ["${ibm_is_ssh_key.test_sshkey.id}"]
  tags    = ["${concat(var.tags, module.camtags.tagslist)}"]
}

## Attach floating IP address to web server VSI
resource "ibm_is_floating_ip" "test_floatingip" {
  name   = "test-fip"
  target = "${ibm_is_instance.web-server.primary_network_interface.0.id}"
}

module "camtags" {
  source  = "../Modules/camtags"
}
