#!/usr/bin/env bash

echoerr() { echo "$@" 1>&2; }

if [ ! -f $1 ] || ([ $# -ne 1 ] && [ $# -ne 2 ])
then
    echoerr Queries the github graphql API
    echoerr "Usage:"
    echoerr
    echoerr "$0 somefile.gql"
fi

# read the gql query from the file named in the argument
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

TOKEN=$(cat $DIR/token)
QUERY=$(jq -n \
           --arg q "$(cat $1 | tr -d '\n')" \
           --arg v "$(cat $2)" \
           '{ query: $q, variables: $v }')

curl 'https://api.opensea.io/graphql/' \
  -H 'authority: api.opensea.io' \
  -H 'accept: */*' \
  -H 'x-build-id: GBEenpG3YHeDfvEqWa7R0' \
  -H 'x-viewer-address: 0x5f86b149b2f2e51911e3cd719f34eba439d2da5a' \
  -H 'x-viewer-chain: ETHEREUM' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 11_2_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.114 Safari/537.36' \
  -H "x-api-key: $TOKEN" \
  -H 'content-type: application/json' \
  -H 'sec-gpc: 1' \
  -H 'origin: https://opensea.io' \
  -H 'sec-fetch-site: same-site' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-dest: empty' \
  -H 'referer: https://opensea.io/' \
  -H 'accept-language: en-US,en;q=0.9' \
  --data "$QUERY" \
  --compressed
