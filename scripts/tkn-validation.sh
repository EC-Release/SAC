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
  region=$(echo $1 | jq -r '.region')
  svcId=$(echo $1 | jq -r '.svcId')
  token=$(echo $1 | jq -r '.token')
  map=$(echo $2 | jq -r '.EC_SVC_MAP')
  res=$(echo "$map" | grep "$svcId" &>/dev/null; echo $?)
  printf "{\"region\":%s,\"svc\":%s,\"token\":%s,\"map\":%s,\"res\":%s}" "$region" "$svcId" "$token" "$map" "$res"
  if [[ $res != "0" ]]; then
    printf "%s" "{\"error\":\"service-id does not exist in the map.\"}"
    #exit 0
  else
    userpool=$(echo "$map" | cut -d':' -f1 | cut -d'"' -f2 | cut -d'"' -f1)
    printf "%s" "$userpool"
    #printf "%s" "{\"message\":\"service-id exists in the map, proceeding to next step\"}"
    jwtdec=$ jq -R 'split(".") | .[0] | @base64d | fromjson' <<< "$token"
    printf "%s" "$jwtdec"
    ki=(echo "$jwtdec" | jq -r '.kid')
    printf "%s" "$ki"
    #if [[ ! -z $jwtdec ]]; then
    #  kid=$(echo $jwtdec | jq -r '.kid')
    #  printf "%s" "$kid"
    #fi  
  fi  
  exit 0 
}

