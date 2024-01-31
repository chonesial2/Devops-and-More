#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin

str1="0/1"
ENV=dev
for input0 in $(seq 0 0)
do
kubectl get pod -n "$ENV" | grep vault-"$input0"
if [ "$?" = 0 ]; then
	status=`kubectl get pod -n "$ENV" | grep vault | awk '{print $2}'`
		if [ "$status" = "$str1" ]; then
			for input1 in $(seq 0 0)
			do
				kubectl exec vault-"$input1" -n "$ENV" -- vault operator init -address=https://localhost:8200 -tls-skip-verify -key-shares=1 -key-threshold=1 -format=json > "$ENV"_keys.json
      				kubectl cp "$ENV"_keys.json vault-"$input1":/tls/ -n "$ENV"
				export VAULT_UNSEAL_KEY=$(cat "$ENV"_keys.json | jq -r ".unseal_keys_b64[]")
				echo $VAULT_UNSEAL_KEY
				export VAULT_ROOT_KEY=$(cat "$ENV"_keys.json | jq -r ".root_token")
				echo $VAULT_ROOT_KEY
				kubectl exec vault-"$input1" -n "$ENV" -- vault operator unseal -address=https://localhost:8200 -tls-skip-verify $VAULT_UNSEAL_KEY
			        kubectl exec vault-"$input1" -n "$ENV" -- vault login -address=https://localhost:8200 -tls-skip-verify $VAULT_ROOT_KEY
			        kubectl exec vault-"$input1" -n "$ENV" -- vault secrets enable  -address=https://localhost:8200 -tls-skip-verify -version=2 kv        
				sleep 10
			done
			break
		else
			echo "false"
		fi
else
	echo "None.No vault pod."
fi
done


