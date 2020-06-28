#!/bin/bash
BASE_DIR=${BASE_DIR:-$HOME/install/dockers}
helm repo update
if [ -z $DEV_VERSION ]; then
  HKUBE_CHART_REPO="hkube/hkube"
else
  HKUBE_CHART_REPO="hkube-dev/hkube"
fi
LATEST_VERSION=$(helm search repo hkube|grep "${HKUBE_CHART_REPO}" | awk '{print $2}')
VERSION=${VERSION:-$LATEST_VERSION}
echo downloading version $VERSION

DIR=${BASE_DIR}/hkube-${VERSION}
mkdir -p ${DIR}
cd ${DIR}
helm pull --untar ${HKUBE_CHART_REPO} --version ${VERSION}
mkdir -p dockers
# cp $HOME/dev/hkube/image-exprort-import/image-export-import .
curl -Lo image-export-import https://github.com/kube-HPC/image-exprort-import/releases/download/$(curl -s https://api.github.com/repos/kube-HPC/image-exprort-import/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')/image-export-import \
&& chmod +x image-export-import

curl -Lo hkubectl https://github.com/kube-HPC/hkubectl/releases/download/$(curl -s https://api.github.com/repos/kube-HPC/hkubectl/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')/hkubectl-linux \
&& chmod +x hkubectl
if [ ! -z $PREV_VERSION ]
then
  helm pull --untar ${HKUBE_CHART_REPO} --untardir hkube-${PREV_VERSION} --version ${PREV_VERSION}
  ./image-export-import export --path $PWD --semver ./hkube/values.yaml --prevVersion  ./hkube-${PREV_VERSION}/hkube/values.yaml
  ./image-export-import exportThirdparty --path $PWD --chartPath ./hkube/ --prevChartPath ./hkube-${PREV_VERSION}/hkube/ --options "etcd-operator.enable=true,jaeger.enable=true,nginx-ingress.enable=true"
  rm -rf hkube-${PREV_VERSION}
else
  ./image-export-import export --path $PWD --semver ./hkube/values.yaml
  ./image-export-import exportThirdparty --path $PWD --chartPath ./hkube/ --options "etcd-operator.enable=true,jaeger.enable=true,nginx-ingress.enable=true"
fi

sleep 5
mv ${VERSION} dockers/hkube
mv thirdparty dockers/
echo compressing 
tar cfz hkube-${VERSION}.tgz hkube dockers image-export-import hkubectl
if [ ! -z $OBFUSCATE ]
then
  base64 hkube-${VERSION}.tgz >hkube-${VERSION}.tgz.b64
  tar cfvz hkube-${VERSION}.tgz hkube-${VERSION}.tgz.b64
fi
echo ${VERSION} is ready at $(realpath hkube-${VERSION}.tgz)

