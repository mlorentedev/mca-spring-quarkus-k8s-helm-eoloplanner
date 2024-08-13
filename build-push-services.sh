#!/usr/bin/env bash

# Default values
DOCKERHUB_NAME=manloralm
IMAGE_TAG=v0.1

# Parse command line options
while getopts "u:v:" opt; do
    case $opt in
        u) DOCKERHUB_NAME="$OPTARG";;
        v) IMAGE_TAG="$OPTARG";;
        \?) echo "Usage: $0 [-u DOCKERHUB_NAME] [-v IMAGE_TAG]"
            exit 1;;
    esac
done

shift $((OPTIND-1))

# Exit immediately if any command fails
set -e

# Build and push a service to DockerHub
build_and_push() {
    local service="$1"

    case "$service" in
        server)
            printf "Building %s using Quarkus plugin for Docker\n" "$service"
            ./$service/mvnw -f ./$service/pom.xml clean package -Dquarkus.container-image.build=true -Dquarkus.container-image.image.name=${DOCKERHUB_NAME}/${service}:${IMAGE_TAG}
            docker push $DOCKERHUB_NAME/$service:$IMAGE_TAG
            ;;
        planner)
            printf "Building %s using JIB plugin for Spring\n" "$service"
            ./$service/mvnw -f ./$service/pom.xml clean
            ./$service/mvnw -f ./$service/pom.xml compile jib:build -DskipTests -Dimage=$DOCKERHUB_NAME/$service:$IMAGE_TAG
            ;;
        weatherservice)
            printf "Building %s using multi-stage Dockerfile\n" "$service"
            ./$service/mvnw -f ./$service/pom.xml clean package -Pnative -Dquarkus.native.container-build=true
            docker build -t $DOCKERHUB_NAME/$service:$IMAGE_TAG ./$service
            docker push $DOCKERHUB_NAME/$service:$IMAGE_TAG
            ;;
        toposervice)
            printf "Building %s using Buildpacks with GraalVM Native\n" "$service"
            ./$service/mvnw -f ./$service/pom.xml clean install
            ./$service/mvnw -f ./$service/pom.xml -Pnative spring-boot:build-image -Dspring-boot.build-image.imageName=${DOCKERHUB_NAME}/${service}:${IMAGE_TAG}
            docker push ${DOCKERHUB_NAME}/${service}:${IMAGE_TAG}
            ;;
        *)
            printf "Unknown service: %s\n" "$service"
            exit 1
            ;;
    esac
}

# Iterate through all subdirectories and build/push each service
for service in */; do
    build_and_push ${service%%/}
done
