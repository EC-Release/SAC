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
# $1: <EXEC_DAT>
# $2: <EXEC_MAP>
# $3: <EXEC_URL>
function int_a () {

  if [[ -z $EXEC_DAT ]]; then
    printf "empty request."
    return -1
  fi
  
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" $3
  if [ $STATUS != "200"* ]; then
    printf "%s" "{\"error\":\"error from aws token verification.\"}"
    return -1
  else
    echo "check if Cognito-userpool key exists in the map"
    ref=$(key_exists $1 $2)
    if [[ $ref != 0 ]]; then
      printf "key does not exist in the map."
      return -1
    fi
    echo "check svc-id now"
    printf "%s" "{\"decision\":\"PERMIT\"}"
    return 0      
  fi
  
}

# Check if Cognito-userpool key exists
# Usage: array_key_exists $array_name $key
# Returns: 0 = key exists, 1 = key does NOT exist
function key_exists() {
    local _array_name="$1"
    local _key="$2"
    local _cmd='echo ${!'$_array_name'[@]}'
    local _array_keys=($(eval $_cmd))
    local _key_exists=$(echo " ${_array_keys[@]} " | grep " $_key " &>/dev/null; echo $?)
    [[ "$_key_exists" = "0" ]] && return 0 || return 1
}
