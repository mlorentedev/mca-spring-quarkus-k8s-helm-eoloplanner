#!/bin/bash

set -e

export DEPLOYMENT_NAME=EoloPlanner
export NAMESPACE=eoloplanner
export REPO_NAME=httpd-web-server
export URL=https://raw.githubusercontent.com/manulorente/mastercloudapps-co-p04/main

function deploy() {

    # Package the Helm chart
    helm package ./$DEPLOYMENT_NAME -d ./$DEPLOYMENT_NAME/charts

    # Create or update the Helm repository index
    helm repo index ./$DEPLOYMENT_NAME/charts --url $URL/$DEPLOYMENT_NAME/charts --merge ./$DEPLOYMENT_NAME/charts/index.yaml

    # Commit and push changes to Git
    git add .
    git commit -m "New version"
    git push origin

    # Add the Helm repository
    helm repo add $REPO_NAME $URL/$DEPLOYMENT_NAME/charts --force-update

    # Update Helm repositories
    helm repo update

    # Install the Helm chart
    helm install $NAMESPACE $REPO_NAME/$DEPLOYMENT_NAME
}

function uninstall() {

    # Uninstall the Helm chart and remove the Helm repository
    helm repo remove $REPO_NAME
    helm uninstall $NAMESPACE

}

function remove() {
    
        # Remove the Helm chart
        rm -rf ./$DEPLOYMENT_NAME/charts
    
}

if [ $# -eq 0 ]; then
    echo "No option provided. Please use -i to deploy and install, or -u to uninstall."
    exit 1
fi

while getopts ":iud" opt; do
    case $opt in
        i) # Deploy and Install Helm chart
            deploy
            ;;
        u) # Uninstall Helm chart
            uninstall
            ;;
        d) # Remove Helm chart
            remove
            ;;            
        \?) # Invalid option
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done
