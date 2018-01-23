#!/bin/bash
DOCKER_USER=
DOCKER_PASSWORD=

function usage {

	echo $0 DOCKER-USER IMAGENAME
}


if [[ -z ${DOCKER_USER} ]]; 
	then
		echo "You must setup DOCKER_USER variable"
		exit
fi

if [[ -z ${DOCKER_PASSWORD} ]]; 
	then
		echo "You must setup DOCKER_PASSWORD variable"
		exit
fi


if [[ $# -ne 2 ]]; 
   	then usage; exit
fi

export GOPATH=`pwd`

if [[ ! -f .stamp_git ]];
then
	mkdir -p src/github.com/
	cd src/github.com/
	git clone https://github.com//manifest-tool.git
	cd manifest-tool && make binary
	cd ../../../../
	touch .stamp_git
fi

export PATH=$PATH:$GOPATH/src/github.com//manifest-tool

registry=$1
imagename=$2

docker login -p ${DOCKER_PASSWORD}  -u ${DOCKER_USER}

echo "--- Creating containers ---"
docker build . -t ${imagename}_arm64 --build-arg ARCH=arm64  -f Dockerfile
docker build . -t ${imagename}_x86_64 --build-arg ARCH=x86_64  -f Dockerfile
echo "--- Creating containers - Done ---"

echo "--- Tagging containers ---"

docker tag ${imagename}_x86_64 ${registry}/${imagename}_x86_64:latest
docker tag ${imagename}_arm64 ${registry}/${imagename}_arm64:latest

echo "--- Tagging containers - Done ---"

echo "--- Pushing containers to ${registry} ---"

docker push ${registry}/${imagename}_x86_64:latest
docker push ${registry}/${imagename}_arm64:latest

echo "--- Pushing containers to ${registry} - Done ---"


echo "--- Doing the magic - Merging images ---"
./test-registry.sh ${registry} ${imagename}


echo "--- Doing the magic - Merging images - Done ---"




