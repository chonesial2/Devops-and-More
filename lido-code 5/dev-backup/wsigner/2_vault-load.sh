#!/bin/bash

# Replace these values with your HashiCorp Vault configuration
VAULT_ADDRESS="https://localhost:8200"
VAULT_TOKEN="hvs.DgBs2KFvUZbf1Q8lTtib4jbv"
SECRET_PATH="kv/100_keys"
ENV=dev

# Replace with the path to your text file containing private keys
FILE_PATH="$ENV""-private_keys.txt"

# Read private keys from the text file and store them in an array
readarray -t private_keys < "$FILE_PATH"

# Function to store private keys in HashiCorp Vault
store_private_keys_in_vault() {
  for index in "${!private_keys[@]}"; do
    kubectl exec -it vault-0 -n "$ENV" -- sh -c "vault kv put -address='$VAULT_ADDRESS' -tls-skip-verify -mount=kv '$SECRET_PATH/$((index + 1))' value='${private_keys[index]}'"
  done
}

# Call the function to store private keys in Vault
store_private_keys_in_vault

