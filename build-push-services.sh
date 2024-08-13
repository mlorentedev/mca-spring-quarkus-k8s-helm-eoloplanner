#!/bin/bash

DOCKER_USER=manloralm

# Build and push all services to Docker Hub
build_and_push() {
    service=$1
    if [ -z "$service" ]; then
        echo "No service specified"
        exit 1
    fi
    # Service with Quarkus + JIB (native image doesn't work with Windows)    
    if [ "$service" = "server" ] || [ "$service" = "weatherservice" ]; then
        cd $service
        ./mvnw clean install -DskipTests
        cd ..
    fi
    # Service with Spring-Boot + JIB (Buildpacks doesn't work with my machine)
    if [ "$service" = "toposervice" ]; then
        cd $service
        ./mvnw compile jib:build -DskipTests -Dimage=$DOCKER_USER/$service:v0.1
        cd ..
    fi
    # Service with Spring-Boot + Multi-stage Dockerfile
    if [ "$service" = "planner" ]; then
        cd $service
        docker build -f Dockerfile -t $DOCKER_USER/$service .
        docker push $DOCKER_USER/$service:latest
        cd ..
    fi
}

for service in */; do
    echo "Building ${service%%/}"
    build_and_push ${service%%/}
done