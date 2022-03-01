#!/bin/bash
#
#  Copyright (c) 2019 General Electric Company. All rights reserved.
#
#  The copyright to the computer software herein is the property of
#  General Electric Company. The software may be used and/or copied only
#  with the written permission of General Electric Company or in accordance
#  with the terms and conditions stipulated in the agreement/contract
#  under which the software has been supplied.
#

# verify the Cognito token and validate service-id from the map
# $1: <dataFromRequest>
# $2: <appParams>
function int_a () {
  #printf "{\"hello2\":\"world2\",\"dataFromRequest\":%s,\"appParams\":%s}" "$1" "$2"
  #printf "{\"req\":%s,\"appParams\":%s}" "$1" "$2"
  if [[ -z $1 ]]; then
    printf "%s" "{\"error\":\"empty request\",\"decision\":\"DENY\"}"
    exit 1
  fi
  region=$(echo $1 | jq -r '.region')
  svcId=$(echo $1 | jq -r '.svcId')
  token=$(echo $1 | jq -r '.token')
  if [[ -z $region || -z $svcId || -z $token ]]; then
    printf "%s" "{\"error\":\"required parameters missing in the request\",\"decision\":\"DENY\"}"
    exit 1
  fi  
  map=$(echo $2 | jq -r '.EC_SVC_MAP')
  res=$(echo "$map" | grep "$svcId" &>/dev/null; echo $?)
  #printf "{\"region\":%s,\"svc\":%s,\"token\":%s,\"map\":%s,\"res\":%s}" "$region" "$svcId" "$token" "$map" "$res"
  if [[ $res != "0" ]]; then
    printf "%s" "{\"error\":\"service-id does not exist in the map.\",\"decision\":\"DENY\"}"
    #exit 0
  else
    userpool=$(echo "$map" | cut -d':' -f1 | cut -d'"' -f2 | cut -d'"' -f1)
    
    jwtdec=$(echo "$token" | jq -R 'split(".") | .[0] | @base64d | fromjson')

    kid=$(echo "$jwtdec" | jq -r '.kid')

    printf "{\"userpool\":%s,\"kid\":%s}" "$userpool" "$kid"
    url=https://cognito-idp.$region.amazonaws.com/$userpool/.well-known/jwks.json
    #printf "{\"url\":\"%s\"}" "$url"
    resp="$(curl -s $url)"
    #printf "{\"resp\":\"%s\"}" "${resp}"
    #printf "%s" "$resp"
    val_resp=$(echo "${resp}" | grep "$kid" &>/dev/null; echo $?)
    printf "{\"val_resp\":%s}" "$val_resp"
    if [[ $val_resp != "0" ]]; then
      printf "%s" "{\"error\":\"invalid token.\",\"decision\":\"DENY\"}"
    else
      printf "%s" "{\"decision\":\"PERMIT\"}"
    fi
    #if [[ ! -z $jwtdec ]]; then
    #  kid=$(echo $jwtdec | jq -r '.kid')
    #  printf "%s" "$kid"
    #fi  
  fi 
  #printf "%s" "{\"decision\":\"PERMIT\"}"
  exit 0 
}

