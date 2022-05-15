#!/bin/bash
CM=${1}
if [ -z $CM ]; then
  echo "Usage: $0 <configmap-name>"
  exit 1
fi
if [ ! -z $2 ]; then
  NS="-n $2"
fi
kubectl get cm $NS "$CM" -o json|jq --raw-output '.data | keys[] as $k | "\($k): \(.[$k])"'
