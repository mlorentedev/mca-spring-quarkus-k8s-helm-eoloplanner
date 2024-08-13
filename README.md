# Docker and containers

Dockerize few microservices to operate together.  

## Dev environment: launch services manually  

### Create docker-compose-dev.yml to configure MySQL, MongoDB and RabbitMQ  

``` bash
 docker-compose -f docker-compose-dev.yml up
```  

or

``` bash
 docker run -d --name mysql --network host -p 3306:3306 -e MYSQL_HOST=mysql -e MYSQL_DATABASE=eoloplantsDB -e MYSQL_USER=root -e MYSQL_ROOT_PASSWORD=password --restart=on-failure mysql:8.0.22
```

``` bash
 docker run -d --name mongo --network host -p 27017:27017 -e MONGO_PORT=27017 -e MONGO_HOST=mongo -e MONGO_INITDB_DATABASE=topo --restart=on-failure mongo:jammy
```

``` bash
 docker run -d --name rabbitmq --network host -p 5672:5672 -p 15672:15672 -e RABBIT_PORT=5672 -e RABBIT_USER=root -e RABBIT_PASS=password --restart=on-failure rabbitmq:3.11.10
```

### Build and publish all services  

``` bash
 docker run -it -d --name weatherservice --network host -e WEATHER_PORT=9090 -p 9090:9090 manloralm/weatherservice:v0.1
```

``` bash
 docker run -it -d --name toposervice --network host -e TOPO_PORT=8181 -e TOPO_HOST=toposervice -e MONGO_PORT=27017 -e MONGO_HOST=localhost -e MONGO_INITDB_DATABASE=topo -d -p 8181:8181 manloralm/toposervice:v0.1
```

``` bash
 docker run -it -d --name planner --network host -e WEATHER_PORT=9090 -e RABBIT_PORT=5672 -p 8080:8080 manloralm/planner:latest
```

``` bash
 docker run -it -d --name server --network host -e MYSQL_HOST=mysql -e MYSQL_USER=root -e MYSQL_ROOT_PASSWORD=password -e MYSQL_PASSWORD=password -e MYSQL_DATABASE=eoloplantsDB -e RABBIT_PORT=5672 -p 3000:3000 manloralm/server:v0.1
```

## Prod environment: dockerize and publish all services in DockerHub  

``` bash
./build-push-services.sh 
```

## Execute services running below command

``` bash
 docker-compose -f docker-compose-prod.yml up
```

## Services endpoint  

The app will be served in <http://localhost:3000>  

## To remove all containers  

``` bash
docker rm -f $(docker ps -a -q)
```
