#!/usr/bin/env bash

clean_service() {
    local service=$1

    if [ -z "$service" ]; then
        printf "No service specified\n" >&2
        exit 1
    fi
    
    mvn -f "$service/pom.xml" clean
}

cleanup_containers_and_data() {
    docker rm -f $(docker ps -a -q) 2>/dev/null || true
    sudo rm -rf data || true
}

main() {
    
    cleanup_containers_and_data

    for service in */; do
        if [ "$service" != "." ]; then  # Skip current directory
            clean_service "${service%%/}"
        fi    
    done
}

main
