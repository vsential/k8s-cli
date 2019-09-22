# Kubernetes Client

[![Build Status](https://travis-ci.org/vsential/k8s-cli.svg?branch=master)](https://travis-ci.org/vsential/k8s-cli)
[![Release](https://img.shields.io/github/v/release/vsential/k8s-cli?style=plastic)](https://github.com/vsential/k8s-cli/releases)

# Supported tags and respective `Dockerfile` links
* `v1.16.0`, `latest`    [(v1.16.0/Dockerfile)](https://github.com/vsential/k8s-cli/blob/v1.16.0/Dockerfile)*
* `v1.15.4`,    [(v1.15.4/Dockerfile)](https://github.com/vsential/k8s-cli/blob/v1.15.4/Dockerfile)
* `v1.14.6`,    [(v1.14.6/Dockerfile)](https://github.com/vsential/k8s-cli/blob/v1.14.6/Dockerfile)
* `v1.13.10`,    [(v1.13.10/Dockerfile)](https://github.com/vsential/k8s-cli/blob/v1.13.10/Dockerfile)


## Overview
This container provides the Kubernetes client kubectl which can be used to interact with a Kubernetes cluster

## Run
`docker run --rm jamesbowling/k8s-cli:``git rev-parse --abbrev-ref HEAD`` --server=http://<server-name>:8080 get pods`

## Data Container

In order to get kube spec files accessible via the kubectl container please use the following data container that exposes a data volume under /data. It dumps everything under cwd in the data container.

```
cat ~/bin/mk-data-container 
#!/usr/bin/env sh

WORKDIR="$1"

if [ -z $WORKDIR ]; then
    WORKDIR='.'
fi

cd $WORKDIR
echo "FROM debian:jessie\n\nVOLUME [ '/data' ]\n\nCOPY * /data/" > ./Dockerfile.data-container
docker rm data
docker build -f ./Dockerfile.data-container -t temp/data .
docker run --name data temp/data
rm ./Dockerfile.data-container
```

## Data container with kubectl container
```
docker run --rm -it --volumes-from data k8s/kubectl:<tag> --server=http://<server-name>:8080 create -f /data/controller.yml
```