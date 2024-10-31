output "droplet_ip" {
  value = digitalocean_droplet.wireguard.ipv4_address
}
