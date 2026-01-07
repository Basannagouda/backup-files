#!/bin/bash
set -e

ENVIRONMENT=${ANSIBLE_ENV:-prod}
TF_DIR="../Environment/$ENVIRONMENT"

# Get instance IPs from terraform output
IPS=$(terraform -chdir="$TF_DIR" output -json new_instance_ips | jq -r '.[]')

# Build JSON inventory
cat <<EOF
{
  "all": {
    "hosts": [
      $(echo "$IPS" | sed 's/^/"/;s/$/"/' | paste -sd "," -)
    ],
    "vars": {
      "ansible_user": "ubuntu",
      "ansible_ssh_private_key_file": "/home/basannagouda_biradar/.ssh/${ENVIRONMENT}-my-key"
    }
  }
}
EOF
