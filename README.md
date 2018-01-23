# docker-multiarch
One docker image to rule them all


SUMMARY
=======

With this set of scripts you can create an image that can be executed in arm64 and x86_64 at a time.

Dockerfile and test code in src can be used to test the script


HOW TO
======

Dockerfile:

The key thing is to add this lines in your Dockerfile
```
ARG ARCH
RUN if [[ "${ARCH}"X == "x86_64"X ]]; then DO X86_64 STUFF \
else DO ARM64 STUFF; fi
```
And call docker build by passing --build-arg=ARCHITECTURE


USAGE
=====
First, you need an account in docker.io, and then setup variables into run.sh DOCKER_PASSWORD and DOCKER_USER, then run the script

```
./run.sh DOCKER-USER IMAGENAME
```

DOCKER-USER: docker user in docker.io
IMAGENAME: descriptive name for the image to be pushed.

This procedure will create 3 images in your repository: x86_64, arm64 and multiarch one


DEPLOY
======

For x86_64 arch run this:
	```docker run USERNAME/IMAGENAME_multiarch```

For arm64 arch run this:	
	```docker run USERNAME/IMAGENAME_multiarch```


