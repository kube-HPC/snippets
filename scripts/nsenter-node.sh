#!/bin/bash
# set -x

for i in ${@:2}
do
  cmd="$cmd, \"$i\""
done
cmd=${cmd:-', "su", "-"'}
node=${1}
nodeName=$(kubectl get node ${node} -o template --template='{{index .metadata.labels "kubernetes.io/hostname"}}') 
nodeSelector='"nodeSelector": { "kubernetes.io/hostname": "'${nodeName:?}'" },'
podName=${USER}-nsenter-${node}

kubectl run ${podName:?} --restart=Never -it  --image overriden --overrides '
{
  "spec": {
    "hostPID": true,
    "hostNetwork": true,
    '"${nodeSelector?}"'
    "tolerations": [{
        "operator": "Exists"
    }],
    "imagePullSecrets": [
        {
            "name": "hkube-imagepullsecret"
        }
    ],
    "containers": [
      {
        "name": "nsenter",
        "image": "alexeiled/nsenter:2.34",
        "command": [
          "/nsenter", "--all", "--target=1", "--" '"${cmd}"'
        ],
        "stdin": true,
        "tty": true,
        "securityContext": {
          "privileged": true
        },
        "resources": {
          "requests": {
            "memory": "512Mi",
            "cpu": "100m"
          },
          "limits": {
            "memory": "512Mi",
            "cpu": "100m"
          }
        }
      }
    ]
  }
}' --attach "$@"