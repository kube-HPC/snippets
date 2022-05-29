#!/bin/bash
ALG_NAME=$3
SOURCE=$1
DEST=$2
if [[ -z "$ALG_NAME" || -z "$SOURCE" || -z "$DEST" ]]
then
  echo usage: copyAlg.sh source dest algorithm-name
  exit -1
fi
echo Copy alg $ALG_NAME from $SOURCE to $DEST
ALG=`curl -s -k ${SOURCE}/hkube/api-server/api/v1/store/algorithms/${ALG_NAME}`
# echo $ALG
curl -s -k -X POST ${DEST}/hkube/api-server/api/v1/store/algorithms/apply -H "Content-Type: multipart/form-data" -F "payload=${ALG}"
