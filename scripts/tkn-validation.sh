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
  printf "{\"hello2\":\"world2\",\"dataFromRequest\":%s,\"appParams\":%s}" "$1" "$2"
  #printf "{\"req\":%s,\"appParams\":%s}" "$1" "$2"
  svcId=$(echo $1 | jq -r '.svcId')
  token=$(echo $1 | jq -r '.token')
  #res=$(echo $2 | jq '.appParams.EC_SVC_MAP | contains("$svcId")')
  map=$(echo $2 | jq -r '.EC_SVC_MAP')
  res=$(grep "$svcId" map | cut -d':' -f1)
  
  printf "{\"svc\":%s,\"token\":%s,\"map\":%s,\"res\":%s}" "$svcId" "$token" "$map" "$res"
  exit 0 
}

