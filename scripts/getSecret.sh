#!/bin/bash
SECRET=${1:-docker-credentials-secret}
if [ ! -z $2 ]; then
  NS="-n $2"
fi
kubectl get secrets $NS "$SECRET" -o json|jq --raw-output '.data | keys[] as $k | "\($k): \(.[$k] | @base64d)"'
