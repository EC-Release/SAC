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
    EC_CID=$(printf '%s' "$cid" | base64 | tr '\n' ' ')
    EC_CSC=$(printf '%s' "$csc" | base64 | tr '\n' ' ')
    
    K8_SECRT_NAME="ec-secret"
    SAC_MSTR_NAME="sac-mstr"
    SAC_SLAV_NAME="sac-slav"
    SVC_APP_NAME="svc"
    
    EC_ADM_TKN="my-legacy-admin-token"
    EC_SETTING=$(printf '{"%s":{"ids":["my-aid-1","my-aid-2"],"trustedIssuerIds":["legacy-cf-uaa-url"]}}' "$EC_SVC_ID" | base64 -w0) 
    EC_SVC_ID="my-test-id"

    kubectl delete ingress "${SVC_APP_NAME}"-igs
    kubectl delete deployments "$SVC_APP_NAME"
    kubectl delete svc "$SVC_APP_NAME"
    kubectl delete deployments "$SAC_MSTR_NAME"
    kubectl delete svc "$SAC_MSTR_NAME"
    kubectl delete deployments "$SAC_SLAV_NAME"
    kubectl delete svc "$SAC_SLAV_NAME"
    kubectl delete secrets "$K8_SECRT_NAME"
    
    curl -Ss -o spec.yaml https://raw.githubusercontent.com/ayasuda-ge/sac/main/k8s/deply.yaml
    sed -i "" "s|{EC_CID}|$EC_CID|g" spec.yaml
    sed -i "" "s|{EC_CSC}|$EC_CSC|g" spec.yaml
    sed -i "" "s|{K8_SECRT_NAME}|$K8_SECRT_NAME|g" spec.yaml
    sed -i "" "s|{SAC_MSTR_NAME}|$SAC_MSTR_NAME|g" spec.yaml
    sed -i "" "s|{SAC_SLAV_NAME}|$SAC_SLAV_NAME|g" spec.yaml
    
    curl -Ss -o spec-svc.yaml https://raw.githubusercontent.com/ayasuda-ge/sac/main/k8s/svc1.1.yml
    sed -i "" "s|{EC_CID}|$EC_CID|g" spec-svc.yaml
    sed -i "" "s|{EC_CSC}|$EC_CSC|g" spec-svc.yaml
    sed -i "" "s|{K8_SECRT_NAME}|$K8_SECRT_NAME|g" spec-svc.yaml
    sed -i "" "s|{SAC_MSTR_NAME}|$SAC_MSTR_NAME|g" spec-svc.yaml
    sed -i "" "s|{SAC_SLAV_NAME}|$SAC_SLAV_NAME|g" spec-svc.yaml
    sed -i "" "s|{SVC_APP_NAME}|$SVC_APP_NAME|g" spec-svc.yaml
    
    sed -i "" "s|{EC_ADM_TKN}|$EC_ADM_TKN|g" spec-svc.yaml
    sed -i "" "s|{EC_SETTING}|$EC_SETTING|g" spec-svc.yaml
    sed -i "" "s|{EC_SVC_ID}|$EC_SVC_ID|g" spec-svc.yaml
    
    kubectl apply -f spec.yaml
    kubectl apply -f spec-svc.yaml
    
    exit 0
}

echo failed k8 deployment
