#!/bin/bash

set -e

ENVIRONMENT=${ANSIBLE_ENV:-prod}
TF_DIR="../Environment/$ENVIRONMENT"

# Get public instance private IPs as a JSON array
IPS_JSON=$(terraform -chdir="$TF_DIR" output -json public_instance_private_ips 2>/dev/null || echo "[]")

# Get bastion public IPs as a JSON array
BASTION_IPS_JSON=$(terraform -chdir="$TF_DIR" output -json public_instance_public_ips 2>/dev/null || echo "[]")

# Parse the IPs into a bash array
readarray -t IPS < <(echo "$IPS_JSON" | jq -r '.[]')

# Get the first bastion public IP
BASTION_IP=$(echo "$BASTION_IPS_JSON" | jq -r '.[0]')

# Output valid JSON for Ansible (new dynamic inventory format)
cat <<EOF
{
  "all": {
    "hosts": [
$(for ip in "${IPS[@]}"; do echo "      \"$ip\","; done | sed '$s/,$//')
    ],
    "vars": {}
  },
  "_meta": {
    "hostvars": {
$(for ip in "${IPS[@]}"; do
  echo "      \"$ip\": {"
  echo "        \"ansible_user\": \"ubuntu\"," 
  echo "        \"ansible_ssh_private_key_file\": \"${HOME}/.ssh/${ENVIRONMENT}-my-key\"," 
  echo "        \"ansible_ssh_common_args\": \"-o ProxyJump=ubuntu@${BASTION_IP}\""
  echo "      },"
done | sed '$s/,$//')
    }
  }
}
EOF
