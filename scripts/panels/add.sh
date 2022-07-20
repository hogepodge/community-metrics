#!/bin/bash

set -euo pipefail

: ${OPENSEARCH_URL:=https://localhost:9200}
: ${OPENSEARCH_DASHBOARDS_URL:=http://localhost:5601}
: ${OPENSEARCH_USERNAME:=admin}
: ${OPENSEARCH_PASSWORD:=admin}
: ${DASHBOARDS_FILE:=scripts/panels/dashboards_index_patterns.ndjson}
: ${MENU_FILE:=scripts/panels/menu.json}

echo -n "Setting dynamic mapping: "
curl -XPUT -k -s \
    -u "${OPENSEARCH_USERNAME}:${OPENSEARCH_PASSWORD}" \
    "${OPENSEARCH_URL}/.kibana/_mapping" \
    -H 'Content-Type: application/json' \
    -d @- << EOF | tee /dev/tty \
    | jq -e '.acknowledged == true' >/dev/null
{
  "dynamic": true
}
EOF

echo
echo -n "Importing dashboards and index patterns to OpenSearch Dashboards: "
curl -XPOST -k -s \
    -u "${OPENSEARCH_USERNAME}:${OPENSEARCH_PASSWORD}" \
    "${OPENSEARCH_DASHBOARDS_URL}/api/saved_objects/_import?overwrite=true" \
    -H "osd-xsrf: true" \
    --form file=@"${DASHBOARDS_FILE}" \
    | jq -e '.success == true' > /dev/null && echo OK || echo ERROR

echo
echo -n "Creating menu: "
curl -XPUT -k -s \
    -u "${OPENSEARCH_USERNAME}:${OPENSEARCH_PASSWORD}" \
    "${OPENSEARCH_URL}/.kibana/_doc/metadashboard" \
    -H 'Content-Type: application/json' \
    -d @"${MENU_FILE}" | tee /dev/tty \
    | jq -e '.result == "created" or .result == "updated"' >/dev/null


