## getHkubeVersion.sh
downloads a new version (images and chart)
```$ getHkubeVersion.sh``` 

options (set as env variables)  
|options|description|default|
|-------|-----------|-------|
|DEV_VERSION|download dev version from hkube-dev or stable from hkube|false|
|PREV_VERSION|last version to compare to. if set will only download diffs|empty|
|SPLIT|splits the final tgz into 100MB chunks |false|
|BASE_DIR|download folder|$HOME/install/dockers/|
|VERSION|the version to download|latest from the chosen helm repository|

```DEV_VERSION=true PREV_VERSION=v1.2.143 OBFUSCATE=true getHkubeVersion.sh```

## Utils
> requires [jq](https://stedolan.github.io/jq/) to be installed  

| command | description |
|---------|-------------|
| `logs POD_NAME` | get the logs of the pod |
| `logp POD_NAME` | get the logs of the pod and parse the json message |
| `logw POD_NAME` | get the logs of the worker container and parse the json message |
| `loga POD_NAME` | get the logs of the algorunner container |
| `pods` | get the pods in the current namespace |
| `svc` | get the services in the current namespace |
| `describe POD_NAME` | describe the pod |
| `cluster-info` | get cluster info (api server address) |
| `getSecret SECRET_NAME` | prints the values (base64 decoded) of the secret |
| `getCm CM_NAME` | prints the values of all keys in the configmap |
