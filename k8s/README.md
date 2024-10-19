# Deployment in Kubernetes

## Deployment

Run docker:

```sh
sudo service docker start
```

Execute minikube:

```sh
minikube start
```

Enable the ingress addon first to access the client app:

```sh
minikube addons enable ingress
```

Apply all the infrastructure resources and wait until everything is up:

```sh
kubectl apply -f volumes/
kubectl apply -f ingresses/
kubectl apply -f services/
```

To view al resources in the cluster in real time:

```sh
watch -n 1 kubectl get pods,services,deployments
```

or just:

```sh
minikube dashboard
```

## Associate domain name to IP to get access

```sh
echo "`minikube ip` cluster-ip" | sudo tee --append /etc/hosts >/dev/null
```

## Verification

The app will be accesible in [http://cluster-ip](http://cluster-ip)

The REST API for the service **toposervice** is also working in [http://cluster-ip/toposervice](http://cluster-ip/toposervice).

Any HTTP request will be handled properly. For example:

```sh
curl --location --request GET 'http://cluster-ip/toposervice/api/topographicdetails/sevilla'
```

Deleting mysql and mongodb pods to force them to be recreated and demostrat persistence on volumes:

```sh
kubectl delete pod <mysql_pod_name>
kubectl delete pod <mongodb_pod_name>
```
