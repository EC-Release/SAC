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

kubectl get pods

read -p "EC_CID: " EC_CID
read -p "EC_CSC: " EC_CSC

wget -q -O spec.yaml https://raw.githubusercontent.com/ayasuda-ge/sac/main/k8s/deply.yaml
sed -i "s|{{EC_CID}}|$aid|g" spec.yaml
sed -i "s|{{EC_CSC}}|$aid|g" spec.yaml

kubectl apply -f spec.yaml
