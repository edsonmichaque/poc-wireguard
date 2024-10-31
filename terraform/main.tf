resource "digitalocean_ssh_key" "default" {
  name       = "default-ssh-key"
  public_key = file("~/.ssh/id_ed25519_vpn.pub")
}

resource "digitalocean_droplet" "wireguard" {
  name     = "wireguard-vpn"
  size     = "s-1vcpu-1gb"
  image    = "ubuntu-24-04-x64"
  region   = var.region
  ssh_keys = [digitalocean_ssh_key.default.id]

  tags = ["vpn", "wireguard"]
}

resource "digitalocean_firewall" "wireguard" {
  name = "wireguard-firewall"

  droplet_ids = [digitalocean_droplet.wireguard.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "udp"
    port_range       = "51820"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range           = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range           = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
