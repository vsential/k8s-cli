# Kubernetes Client

### Container Details

# Supported tags and respective `Dockerfile` links
* `v1.15.3`, `latest`    [(v1.15.3/Dockerfile)](https://github.com/lachie83/k8s-kubectl/blob/v1.15.3/Dockerfile)
* `v1.14.6`,    [(v1.14.6/Dockerfile)](https://github.com/lachie83/k8s-kubectl/blob/v1.14.6/Dockerfile)
* `v1.13.10`,    [(v1.13.10/Dockerfile)](https://github.com/lachie83/k8s-kubectl/blob/v1.13.10/Dockerfile)
* `v1.12.10`,    [(v1.12.10/Dockerfile)](https://github.com/lachie83/k8s-kubectl/blob/v1.12.10/Dockerfile)
* `v1.11.9`,    [(v1.11.9/Dockerfile)](https://github.com/lachie83/k8s-kubectl/blob/v1.11.9/Dockerfile)
* `v1.10.12`,   [(v1.10.12/Dockerfile)](https://github.com/lachie83/k8s-kubectl/blob/v1.10.12/Dockerfile)


## Overview
This container provides the Kubernetes client kubectl which can be used to interact with a Kubernetes cluster

## Build
`make docker_build`

## Run
`docker run --rm lachlanevenson/k8s-kubectl:``git rev-parse --abbrev-ref HEAD`` --server=http://<server-name>:8080 get pods`

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

