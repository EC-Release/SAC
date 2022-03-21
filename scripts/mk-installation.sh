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

if [[ $(type -t insertData) != function ]]; then
  source <(wget -q -O - https://raw.githubusercontent.com/EC-Release/sdk/disty/scripts/libs/db.sh)
fi

kubectl get pods -A

printf "\n\n*** EC k8 installation\n\n"
kubectl config view

wget -q -O spec.yaml https://raw.githubusercontent.com/ayasuda-ge/sac/main/k8s/deply.yaml
kubectl apply -f spec.yaml
