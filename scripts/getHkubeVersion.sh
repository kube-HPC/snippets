#!/bin/bash
hash helm &> /dev/null
if [ $? -ne 0 ]
then
  echo "helm v3 is required and could not be found"
  exit
fi
helm_version=$(helm version)
echo $helm_version | grep -q 'Version:"v3'
has_helm3=$?
if [ $has_helm3 -ne 0 ]
then
  echo "helm v3 is required and could not be found"
  echo "found helm version: ${helm_version} "
  exit
fi
BASE_DIR=${BASE_DIR:-$HOME/install/dockers}
if [ -z $DEV_VERSION ]; then
  HKUBE_CHART_REPO="hkube/hkube"
  helm repo add hkube https://hkube.io/helm
else
  HKUBE_CHART_REPO="hkube-dev/hkube"
  helm repo add hkube-dev https://hkube.io/helm/dev
fi
helm repo update
CHART_INFO=$(helm search repo hkube|grep "${HKUBE_CHART_REPO}")
LATEST_VERSION=$( echo $CHART_INFO | awk '{print $2}')
APP_VERSION=$( echo $CHART_INFO | awk '{print $3}')
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
curl -Lo hkubectl.exe https://github.com/kube-HPC/hkubectl/releases/download/$(curl -s https://api.github.com/repos/kube-HPC/hkubectl/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')/hkubectl-win.exe
curl -Lo hkubectl-macos https://github.com/kube-HPC/hkubectl/releases/download/$(curl -s https://api.github.com/repos/kube-HPC/hkubectl/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')/hkubectl-macos
if [ ! -z $PREV_VERSION ]
then
  helm pull --untar ${HKUBE_CHART_REPO} --untardir hkube-${PREV_VERSION} --version ${PREV_VERSION}
  ./image-export-import export --path $PWD --semver ./hkube/values.yaml --prevVersion  ./hkube-${PREV_VERSION}/hkube/values.yaml
  ./image-export-import exportThirdparty --path $PWD --chartPath ./hkube/ --prevChartPath ./hkube-${PREV_VERSION}/hkube/ --options "etcd-operator.enable=true,jaeger.enable=true,nginx-ingress.enable=true"
  rm -rf hkube-${PREV_VERSION}
else
  ./image-export-import export --path $PWD --semver ./hkube/values.yaml
  ./image-export-import exportThirdparty --path $PWD --chartPath ./hkube/ --options "etcd-operator.enable=true,jaeger.enable=true,nginx-ingress.enable=true,minio.enable=true"
fi

sleep 5
mv ${APP_VERSION} dockers/hkube
mv thirdparty dockers/
echo compressing 
tar cfz hkube-${VERSION}.tgz hkube dockers image-export-import hkubectl
if [ ! -z $OBFUSCATE ]
then
  base64 hkube-${VERSION}.tgz >hkube-${VERSION}.tgz.b64
  tar cfvz hkube-${VERSION}.tgz hkube-${VERSION}.tgz.b64
fi
echo ${VERSION} is ready at $(realpath hkube-${VERSION}.tgz)

