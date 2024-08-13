# Docker and containers

Dockerize few microservices to operate together with GraalVM 17.0.8+9.1 and Maven 3.9.4

[Video](https://drive.google.com/file/d/14eQm9iGEsF6P2vXCFCtKzBGzeLR3FdMY/view?usp=sharing)

## Dev environment

### Deploy auxiliary services MySQL, MongoDB and RabbitMQ  

``` bash
docker-compose -f docker-compose-dev.yml up
```  

### Build and run services in containers using dev containers with VSCode

#### TOPOSERVICE  

``` bash
export TOPO_PORT=8181
export SPRING_DATA_MONGODB_HOST=localhost
export SPRING_DATA_MONGODB_PORT=27017
export SPRING_DATA_MONGODB_DATABASE=topoDB
export SPRING_DATA_MONGODB_AUTHENTICATION_DATABASE=admin
export SPRING_DATA_MONGODB_USERNAME=root
export SPRING_DATA_MONGODB_PASSWORD=password
mvn spring-boot:run
```

#### WEATHERSERVICE  

``` bash
export QUARKUS_GRPC_SERVER_HOST=localhost
export QUARKUS_GRPC_SERVER_PORT=9090 
mvn quarkus:dev
```

#### PLANNER

``` bash
export TOPO_HOST=toposervice
export TOPO_PORT=8181
export GRPC_CLIENT_WEATHERSERVER_ADDRESS=static://weatherservice:9090 
export SPRING_CLOUD_STREAM_RABBIT_BINDER_NODES=rabbitmq:5672
export SPRING_RABBITMQ_HOST=localhost
export SPRING_RABBITMQ_PORT=5672
export SPRING_RABBITMQ_USERNAME=root
export SPRING_RABBITMQ_PASSWORD=password
mvn spring-boot:run
```

#### SERVER

``` bash
export QUARKUS_DATASOURCE_DB_KIND=mysql
export QUARKUS_DATASOURCE_JDBC_URL=jdbc:mysql://localhost/eoloplantsDB
export QUARKUS_DATASOURCE_USERNAME=root
export QUARKUS_DATASOURCE_PASSWORD=password
export RABBITMQ_HOST=localhost
export RABBITMQ_PORT=5672
export RABBITMQ_USERNAME=root
export RABBITMQ_PASSWORD=password 
mvn quarkus:dev
```

## Prod environment  

### Build and publish all services  

``` bash
docker login
./build-push-services.sh -u YOUR_DOCKERHUB_NAME -v YOUR_IMAGE_TAG
```

### Deploy all services in containers

``` bash
docker-compose -f docker-compose-prod.yml up
```

## Services endpoint  

The app will be served in <http://localhost:8080>  

## Remove all containers, images and generated data

``` bash
./clean-all.sh
```
