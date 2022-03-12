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

EC_SETTING=$(printf '{"%s":{"ids":["my-aid-1","my-aid-2"],"trustedIssuerIds":["legacy-cf-uaa-url"]}}' "$EC_SVC_ID" | base64 -w0)   
ZONE_ID="my-zone-id-from-predix"

migrate "$ZONE_ID" "$EC_SETTING"
