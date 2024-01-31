#!/bin/bash

read -p "Enter the number of repetitions: " repetitions

# Function to generate the config with increasing keyPath value
rm config.yaml
touch config.yaml
generate_config() {
    local keyPathVal="/v1/kv/data/kv/100_keys/"
    local configFile="config.yaml"
    for ((i=1; i<=$repetitions; i++)); do
        echo "type: \"hashicorp\"
keyType: \"BLS\"
tlsEnabled: \"true\"
keyPath: \"$keyPathVal$i\"
keyName: \"value\"
tlsKnownServersPath: \"/web3config/knownClients.txt\"
serverHost: \"vault-svc\"
serverPort: \"8200\"
timeout: \"10000\"
token: \"hvs.DgBs2KFvUZbf1Q8lTtib4jbv\"" >> "$configFile"

        # Add "---" separator except for the last repetition
        if [ $i -lt $repetitions ]; then
            echo "---" >> "$configFile"
        fi
    done
}

generate_config

echo "Config file generated."
