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
    
    read EC_CID"?EC_CID: "
    read EC_CSC"?EC_CSC: "
    read SAC_NS"?Namespace: "
    read ClaimName"?ClaimName: "
    read K8_SECRT_NAME"?K8_SECRT_NAME: "
    
    #read -p "EC_CID: " cid
    #read -p "EC_CSC: " csc
    #read -p "Namespace: " SAC_NS
    #read -p "ClaimName: " ClaimName
    #read -p "K8_SECRT_NAME: " K8_SECRT_NAME
    
    #read -p "EC_CID: " cid
    #read -p "EC_CSC: " csc
    EC_CID=$(printf '%s' "$EC_CID" | base64)
    EC_CSC=$(printf '%s' "$EC_CSC" | base64)
    
    #K8_SECRT_NAME="ec-secret"
    SAC_MSTR_NAME="sac-mstr"
    SAC_SLAV_NAME="sac-slav"
    #SVC_APP_NAME="svc"
    #SAC_NS="$nsc"
    
    #EC_ADM_TKN="my-legacy-admin-token"
    #EC_SETTING=$(printf '{"%s":{"ids":["my-aid-1","my-aid-2"],"trustedIssuerIds":["legacy-cf-uaa-url"]}}' "$EC_SVC_ID" | base64 | tr '\n' ' ') 
    #EC_SVC_ID="EC_SVC_ID"

    kubectl delete deployments "$SAC_MSTR_NAME"
    kubectl delete svc "$SAC_MSTR_NAME"
    kubectl delete deployments "$SAC_SLAV_NAME"
    kubectl delete svc "$SAC_SLAV_NAME"
    kubectl delete secrets "$K8_SECRT_NAME"
    
    curl -Ss -o sac.yaml https://raw.githubusercontent.com/ayasuda-ge/sac/main/k8s/sac.yaml
    sed -i "" "s|{EC_CID}|$EC_CID|g" sac.yaml
    sed -i "" "s|{EC_CSC}|$EC_CSC|g" sac.yaml
    sed -i "" "s|{K8_SECRT_NAME}|$K8_SECRT_NAME|g" sac.yaml
    sed -i "" "s|{SAC_MSTR_NAME}|$SAC_MSTR_NAME|g" sac.yaml
    sed -i "" "s|{SAC_SLAV_NAME}|$SAC_SLAV_NAME|g" sac.yaml
    sed -i "" "s|{SAC_NS}|$SAC_NS|g" sac.yaml
    sed -i "" "s|{ClaimName}|$ClaimName|g" sac.yaml
    
    kubectl apply -f sac.yaml
    
    #echo completing svc1.1 bootstrap ..
    #sleep 15
    #kubectl apply -f svc1.1.yml
    
    exit 0
}

echo failed k8 deployment
