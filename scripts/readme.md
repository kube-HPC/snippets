## getHkubeVersion.sh
downloads a new version (images and chart)
```$ getHkubeVersion.sh``` 

options (set as env variables)  
|options|description|default|
|-------|-----------|-------|
|DEV_VERSION|download dev version from hkube-dev or stable from hkube|false|
|PREV_VERSION|last version to compare to. if set will only download diffs|empty|
|OBFUSCATE|base64|false|
|BASE_DIR|download folder|$HOME/install/dockers/|
|VERSION|the version to download|latest from the chosen helm repository|

```DEV_VERSION=true PREV_VERSION=v1.2.143 OBFUSCATE=true getHkubeVersion.sh```
