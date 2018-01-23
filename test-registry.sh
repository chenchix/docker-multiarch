#!/bin/bash

## This script will test creating a manifest list against a specified registry
## that claims to support the Docker v2 distribution API and the v2.2 image
## specification.

## It expects `manifest-tool` to be in the $PATH as well as the docker client.
## You must be authenticated via `docker login` to the registry provided or
## whatever method that registry provides for inserting docker authentication.

_REGISTRY="${1}"
_IMAGENAME="${2}"
_IMAGELIST="${2}_x86_64
${2}_arm64"
VERSION="latest"

[ -z "${_REGISTRY}" ] && {
	echo "Please provide a registry URL + namespace/repo name as the first parameter"
	exit 1
}

echo "Warning: some commands will fail if you are not authenticated to ${_REGISTRY}"

echo ">> 1: Pulling required images from DockerHub"
for i in $_IMAGELIST; do
	docker pull ${_REGISTRY}/${i}:$VERSION
done

echo ">> 2: Tagging and pushing images to registry ${_REGISTRY}"
for i in $_IMAGELIST; do
	target="${i/\//_}"
	echo docker tag ${i}:$VERSION ${_REGISTRY}/${target}:$VERSION
	docker tag ${i}:$VERSION ${_REGISTRY}/${target}:$VERSION
	docker push ${_REGISTRY}/${target}:$VERSION
done

echo ">> 4: Attempt creating manifest list on registry ${_REGISTRY}"

sed s,__REGISTRY__,${_REGISTRY}, test-registry.yml > test-registry.yaml
sed s,__NAME__,${_IMAGENAME}, test-registry.yaml >> test-registry.yaml

manifest-tool --debug push from-spec test-registry.yaml

