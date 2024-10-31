# WireGuard VPN Setup

## Prerequisites
- Terraform installed
- Ansible installed
- DigitalOcean account and API token
- SSH key added to DigitalOcean

## Initial Setup
1. Create a `terraform.tfvars` file in the terraform directory with:
do_token     = "your_digitalocean_api_token"
ssh_key_name = "your_ssh_key_name"
