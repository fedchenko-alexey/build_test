#!/bin/bash

help() {
  echo "Using:"
  echo "build.sh ssh_key_name"
  echo "example: ./build.sh id_rsa"
  exit
}

if [ -z $1 ]; then
  help
fi

if [ ! -e "/home/$USER/.ssh/$1" ] && [ ! -e "/home/$USER/.ssh/$1.pub" ]; then
  echo 'SSH keys not available'
  exit
fi

echo "UID=$(id -u $USER) GID=$(id -g $USER) USER_NAME=$USER"
echo "$1 : $1.pub"

docker build -t r7de-build1804 \
	--build-arg UID=$(id -u $USER) \
	--build-arg GID=$(id -g $USER) \
	--build-arg USER_NAME=$(echo $USER) \
	--build-arg ssh_prv_key="$(cat ~/.ssh/$1)" \
	--build-arg ssh_pub_key="$(cat ~/.ssh/$1.pub)" \
	./Dockerfiles/18.04
