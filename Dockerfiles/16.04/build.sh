#!/bin/bash

pwd

docker build -t r7de-build1604 \
	--build-arg UID=$(id -u $USER) \
	--build-arg GID=$(id -g $USER) \
	--build-arg USER_NAME=$(echo $USER) \
	--build-arg ssh_prv_key="$(cat ~/.ssh/id_ed25519)" \
	--build-arg ssh_pub_key="$(cat ~/.ssh/id_ed25519.pub)" \
	./Dockerfiles/16.04
