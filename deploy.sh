#!/bin/bash

set -e
set -o pipefail

APIC_LTE_STATUS=$(apic-lte status)

#DEFAULT ENVIRONMENT
DP_SERVER="https://localhost:2000"
DP_ORGANZ="localtest"
DP_CATALG="sandbox"
DP_APPLIC="sandbox-test-app"
DP_CONSOG="sandbox-test-org"

#API ENVIRONMENT
API_NAME=miapitest01
API_URL="https://localhost:9444/$DP_ORGANZ/$DP_CATALG/$API_NAME/"

#CREDENCIALES
API_USR=$(echo -e "$APIC_LTE_STATUS" | grep -oP "(?<=client id: )[^,]+" | xargs)
API_SEC=$(echo -e "$APIC_LTE_STATUS" | grep -oP "(?<=client secret: )[^ ]+" | xargs)

#DEPLOY
PRODUCT_FILE=miproduct01.yaml
PRODUCT_URL=$(apic products:publish -s $DP_SERVER -o $DP_ORGANZ  -c $DP_CATALG $PRODUCT_FILE |  grep published | awk -F ']' '{print $2}' | xargs)

sed "s/REPLACEPRODUCTURL/${PRODUCT_URL//\//\\/}/" misubtest01.yaml > substemp.yaml

apic subscriptions:create -s $DP_SERVER -o $DP_ORGANZ --app $DP_APPLIC -c $DP_CATALG --consumer-org $DP_CONSOG substemp.yaml

rm -f substemp.yaml
sleep 10

for item in {1..10}; do
    curl -s -k -X GET ${API_URL} -H "X-IBM-Client-Id: ${API_USR}" -H "X-IBM-Client-Secret: ${API_SEC}" | jq    
    sleep 2
done

#sleep 5

#apic products:delete -s $DP_SERVER -o $DP_ORGANZ --scope catalog -c $DP_CATALG miproduct01:1.0.0
