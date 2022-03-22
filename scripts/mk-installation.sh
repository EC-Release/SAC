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

kubectl config view && kubectl get pods && {

    read -p "EC_CID: " cid
    read -p "EC_CSC: " csc
    EC_CID=$(printf '%s' "$cid" | base64 -w0)
    EC_CSC=$(printf '%s' "$csc" | base64 -w0)

    wget -q -O spec.yaml https://raw.githubusercontent.com/ayasuda-ge/sac/main/k8s/deply.yaml
    sed -i "s|{{EC_CID}}|$EC_CID|g" spec.yaml
    sed -i "s|{{EC_CSC}}|$EC_CSC|g" spec.yaml

    kubectl apply -f spec.yaml
}
