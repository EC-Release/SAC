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
    return
  fi
  
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" $3
  if [ $STATUS != "200"* ]; then
    echo "Got $STATUS : invalid region or userpool"
  else
    echo "Got 200! proceeding to next step..."
    return      
  fi
  
}
