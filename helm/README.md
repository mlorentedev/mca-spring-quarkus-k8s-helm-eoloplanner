# Deploying the app with Helm

## Links

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/eoloplanner-mlorente-jagarrido)](https://artifacthub.io/packages/search?repo=eoloplanner-mlorente-jagarrido)

[GitHub repository](https://github.com/manulorente/mcloudapps-M3/tree/main/Containers-P04-rec)

## Setup

Run docker:

```sh
sudo service docker start
```

Execute minikube with virtualbox driver:

```sh
minikube start
```

Enable the ingress addon first to access the client app:

```sh
minikube addons enable ingress
```

## Running the app

To package and publish and install the helm chart:

```sh
./deploy.sh -i
```

To uninstall:

```sh
./deploy.sh -u
```

## Associate domain name to minikube

```sh
echo "`minikube ip` mastercloudapps" | sudo tee --append /etc/hosts >/dev/null
```

## Verification

The app will be accesible in [http://mastercloudapps](http://mastercloudapps)

The REST API for the service **toposervice** is also working in [http://mastercloudapps/toposervice](http://mastercloudapps/toposervice).

Any HTTP request will be handled properly. For example:

```sh
curl --location --request GET 'http://mastercloudapps/toposervice/api/topographicdetails/sevilla'
```
