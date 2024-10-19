# EoloPlanner microservices application

This project consists of multiple services that manage topology data, weather information, planning, and general operations. The services are designed to communicate via RabbitMQ, with MongoDB and MySQL as data storage backends.

[Video](https://drive.google.com/file/d/14eQm9iGEsF6P2vXCFCtKzBGzeLR3FdMY/view?usp=sharing)

## Tech Stack

| **Technology** | **Description** |
|----------------|-----------------|
| JVM | GraalVM 17.0.8 |
| Backend | Spring Boot 2.5.5, Quarkus 2.3.0 |
| Database | MySQL 8.0.26, MongoDB 4.4.9 |
| Messaging | RabbitMQ 3.9.7 |
| Dependencies | Maven 3.8.2 |
| Containerization | Docker 20.10.8, Docker Compose 1.29.2 |
| Dev Containers | Visual Studio Code 1.60.2 |
| Orchestrator | Kubernetes 1.22.2, Helm 3.7.0 |

## Features

- Containerized microservices using Docker
- Microservices include TopoService, WeatherService, Planner, and Server
- Integration of MongoDB, MySQL, and RabbitMQ for service communication
- Kubernetes and Helm configurations for production-level deployments
- Environment-specific configurations for development and production

## Overview

- **TopoService**: Provides topographic details of a location. MongoDB is used for storing topology data.
- **WeatherService**: Provides weather information of a location using gRPC. The service is built using Quarkus.
- **Planner**: This service coordinates between TopoService and WeatherService. It retrieves data from both services (using REST and gRPC) .
- **Server**: The main server for the system, responsible for managing general operations and data from other services. It connects to a MySQL database and RabbitMQ for messaging.

## Getting started

### Prerequisites

- Docker
- Docker Compose
- Maven
- GraalVM
- Visual Studio Code

### Running the Application (Dev environment)

1. Clone the repository

2. Navigate to the project directory

3. Deploy auxiliary services MySQL, MongoDB and RabbitMQ  

    ``` bash
    docker-compose -f docker-compose-dev.yml up
    ```  

4. Build and run services in containers using dev containers with VSCode

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

### Running the Application (Prod environment)

1. Clone the repository

2. Navigate to the project directory

3. Log in to Docker

    ``` bash
    docker login
    ```

4. Build and publish all services  

    ``` bash
    docker login
    ./build-push-services.sh -u YOUR_DOCKERHUB_NAME -v YOUR_IMAGE_TAG
    ```

5. Deploy all services in containers

    ``` bash
    docker-compose -f docker-compose-prod.yml up
    ```

### Kubernetes and Helm deployment

For production environments, you can also deploy the services using Kubernetes and Helm.

1. Kubernetes manifests are located in the `k8s` directory.

    ``` bash
    kubectl apply -f k8s/
    ```

2. Helm charts are located in the `helm` directory.

    ``` bash
    helm install eoloplanner helm/
    ```

## Services endpoint  

The app will be served in <http://localhost:8080>  

## Clean up

To remove all containers, images, and generated data, run the following script:

``` bash
./clean-all.sh
```

## Change Log

| **Version** | **Description** |
|-------------|-----------------|
| 0.0.1       | Initial release |

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
