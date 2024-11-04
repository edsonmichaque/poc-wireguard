
# WireGuard VPN Setup Guide

A simple guide to deploy a WireGuard VPN server on DigitalOcean using Terraform and Ansible.

## 1. Infrastructure Setup (Terraform)

### Prerequisites
- Terraform installed
- DigitalOcean account and API token
- SSH key pair

### Deploy Server

1. Generate SSH key:
```bash
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_vpn -C "vpn-key"
```

2. Configure variables:
```bash
cp terraform/terraform.tfvars.example terraform/terraform.tfvars
# Edit terraform.tfvars with your DO token and region
```

3. Deploy infrastructure:
```bash
cd terraform
terraform init
terraform apply
```

This will create:
- Ubuntu 24.04 droplet (1GB RAM, 1 CPU)
- Firewall rules for SSH (22) and WireGuard (51820)
- SSH key configuration

## 2. Server Configuration (Ansible)

1. Create inventory with the server IP from Terraform output:
```ini
[wireguard]
your-server-ip ansible_user=root
```

2. Run Ansible playbook:
```bash
cd ../
ansible-playbook -i hosts.ini ansible/playbook.yml
```

The playbook will:
- Install WireGuard
- Configure server and client keys
- Set up networking and firewall rules
- Generate client configuration

## 3. Client Setup

### Linux
```bash
sudo apt install wireguard
sudo cp client.conf /etc/wireguard/wg0.conf
sudo chmod 600 /etc/wireguard/wg0.conf
sudo wg-quick up wg0
```

### macOS
1. Install WireGuard:
```bash
brew install wireguard-tools
```

2. Copy configuration:
```bash
sudo mkdir -p /etc/wireguard
sudo cp client.conf /etc/wireguard/wg0.conf
sudo chmod 600 /etc/wireguard/wg0.conf
sudo wg-quick up wg0
```

### iOS/Android
1. Install qrencode:
```bash
sudo apt install qrencode
```

2. Generate QR code:
```bash
qrencode -t ansiutf8 < client.conf
```

3. Scan QR code with the WireGuard mobile app

## Basic Usage

Start VPN:
```bash
sudo wg-quick up wg0
```

Stop VPN:
```bash
sudo wg-quick down wg0
```

Check connection:
```bash
sudo wg show
```

## Troubleshooting

1. Check WireGuard status:
```bash
sudo systemctl status wg-quick@wg0
```

2. View logs:
```bash
sudo journalctl -xeu wg-quick@wg0
```

3. Verify firewall rules:
```bash
sudo ufw status
```