#!/bin/bash
#
#  Copyright (c) 2020 General Electric Company. All rights reserved.
#
#  The copyright to the computer software herein is the property of
#  General Electric Company. The software may be used and/or copied only
#  with the written permission of General Electric Company or in accordance
#  with the terms and conditions stipulated in the agreement/contract
#  under which the software has been supplied.
#
#  Author: apolo.yasuda@ge.com; apolo.yasuda.ge@gmail.com
#

source <(wget -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/libs/db.sh)

kubectl get pods -A

printf "\n\n*** EC k8 installation\n\n"
kubectl config view

read -p "Please enter a cluster name for the service account creation: " cluster_name
APISERVER=$(kubectl config view -o jsonpath="{.clusters[?(@.name==\"$cluster_name\")].cluster.server}")

kubectl apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: ec-bot
EOF

kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: ec-bot-token
  annotations:
    kubernetes.io/service-account.name: ec-bot
type: kubernetes.io/service-account-token
EOF

while ! kubectl describe secret ec-bot-token | grep -E '^token' >/dev/null; do
  echo "waiting for token..." >&2
  sleep 1
done
printf "\n\n*** secret detail\n\n"
kubectl get secret ec-bot-token -o json
# get the token value
TOKEN=$(kubectl get secret ec-bot-token -o jsonpath='{.data.token}' | base64 --decode)
printf "\n\n*** TOKEN: %s. APISERVER: %s\n\n" "$TOKEN" "$APISERVER"

# test endpoint
curl -X GET $APISERVER/api --header "Authorization: Bearer $TOKEN" --insecure
