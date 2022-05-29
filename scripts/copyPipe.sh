#!/bin/bash
function copyAlg {
    #!/bin/bash
    local ALG_NAME=$3
    local SOURCE=$1
    local DEST=$2
    if [[ -z "$ALG_NAME" || -z "$SOURCE" || -z "$DEST" ]]
    then
        echo usage: copyAlg.sh source dest algorithm-name
        exit -1
    fi
    echo Copy alg $ALG_NAME from $SOURCE to $DEST
    ALG=`curl -s -k ${SOURCE}/hkube/api-server/api/v1/store/algorithms/${ALG_NAME}`
    # echo $ALG
    curl -s -k -X POST ${DEST}/hkube/api-server/api/v1/store/algorithms/apply -H "Content-Type: multipart/form-data" -F "payload=${ALG}"
    
}
PIPE_NAME=$3
SOURCE=$1
DEST=$2
if [[ -z "$PIPE_NAME" || -z "$SOURCE" || -z "$DEST" ]]
then
    echo usage: copyPipe.sh source dest pipeline-name
    exit -1
fi
echo Copy pipeline $PIPE_NAME from $SOURCE to $DEST
PIPE=`curl -s -k ${SOURCE}/hkube/api-server/api/v1/store/pipelines/${PIPE_NAME}`
ALGORITHMS=`echo "${PIPE}" | jq -r .nodes[].algorithmName|sort|uniq`
for i in ${ALGORITHMS}
do
    echo $i
    copyAlg "${SOURCE}" "${DEST}" "${i}"
done
curl -s -k -X POST ${DEST}/hkube/api-server/api/v1/store/pipelines -H "Content-Type: application/json" --data-binary "${PIPE}"
