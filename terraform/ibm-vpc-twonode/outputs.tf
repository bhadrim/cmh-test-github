# Web server Floating IP address
output "web_server_floating_ip_address" {
  value = "${ibm_is_floating_ip.test_floatingip.address}"
}

# Web server private IP address
output "web_server_private_ip_address" {
  value = "${ibm_is_instance.web-server.primary_network_interface.0.primary_ipv4_address}"
}


