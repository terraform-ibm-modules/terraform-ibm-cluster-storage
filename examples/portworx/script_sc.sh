#!/bin/bash
response=$(curl -s -d '{"parameters": { "cloud_drive": "Yes"}, "region": "us-south"}' -H "Content-Type: application/json" -X POST https://px-osb-test-2.tapas-iks-1.us-east.containers.appdomain.cloud/sclist)
echo $response| jq '.options[] | .value'