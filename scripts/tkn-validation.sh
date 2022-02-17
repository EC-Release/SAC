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
function int_a () {

  if [[ -z $EXEC_DAT ]]; then
    printf "empty request."
    return
  else
    STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://cognito-idp.$region.amazonaws.com/$userpool/.well-known/jwks.json)
    if [ $STATUS -eq 200 ]; then
      echo "Got 200! proceeding to next step..."
    else
      echo "Got $STATUS : invalid token"
      return      
  fi
  
}
