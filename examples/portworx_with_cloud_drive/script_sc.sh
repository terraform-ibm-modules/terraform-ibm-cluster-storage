#!/bin/bash
## TODO: Once cloud drive support is introduced to production, update this URL to fetch storage classes.
response=$(curl -s -d '{"parameters": { "cloud_drive": "Yes"}}' -H "Content-Type: application/json" -X POST https://px-osb-test-2.tapas-iks-1.us-east.containers.appdomain.cloud/sclist)
echo $response| jq '.options[] | .value'