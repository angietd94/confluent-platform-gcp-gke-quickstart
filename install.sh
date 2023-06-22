#!/bin/bash


# taking inspiration from this link from Confluent
# https://github.com/confluentinc/confluent-kubernetes-examples/tree/master/quickstart-deploy
#
#put in path the position where you have 
# open ~/.bash_profile
# export PATH=/Users/<youruse>/bin:$PATH

brew update

# Install python
brew install python

# Check the version
python3 --version

git clone https://github.com/confluentinc/cp-helm-charts.git 

# Set the GCP project ID
PROJECT_ID="sales-engineering-206314"

# Set the GKE cluster details
#CLUSTER_NAME="angelica-cp"
#ZONE="europe-west1-b"



# Set the GKE cluster details
HOSTNAME=$(hostname | tr '[:upper:]' '[:lower:]' | tr -cd '[[:alnum:]]._-')
CLUSTER_NAME="$HOSTNAME-cp"
ZONE="europe-west1-b"

# Set the cluster size
CLUSTER_SIZE="3"  # Number of nodes in the cluster

# Set the node machine type
MACHINE_TYPE="n1-standard-4"  # Machine type for each node in the cluster

# Set the Confluent Platform version
CONFLUENT_VERSION="6.2.1"  # Version of Confluent Platform to install


# Authenticate with GCP using your Google account
gcloud auth login

# Set the current project
gcloud config set project $PROJECT_ID

# Set the default zone
gcloud config set compute/zone $ZONE

#Creating a new cluster with such characteristics
gcloud container clusters create $CLUSTER_NAME --num-nodes=$CLUSTER_SIZE --machine-type=$MACHINE_TYPE --min-cpu-platform "Intel Skylake" --enable-autoscaling --min-nodes=1 --max-nodes=10

# Configure Docker to use gcloud as a credential helper
gcloud auth configure-docker

# Install and configure the Kubernetes command-line tool (kubectl)
gcloud components install kubectl


#Verify that the data here is correct
nano ~/.config/gcloud/configurations/config_default


# Fetch cluster credentials
gcloud container clusters get-credentials $CLUSTER_NAME

# Verify cluster access
kubectl cluster-info

# Create a new Kubernetes namespace for Confluent Platform
kubectl create namespace confluent

#https://github.com/confluentinc/cp-helm-chartsç
#https://docs.confluent.io/operator/current/co-deploy-cfk.html

#Install Helm
brew install helm

# Add the Confluent Helm repository

helm repo add confluentinc https://packages.confluent.io/helm


# Update the Helm repository
helm repo update

kubectl config set-context --current --namespace=confluent



# Install Confluent Platform using Helm

helm upgrade --install confluent-operator confluentinc/confluent-for-kubernetes --namespace confluent


#Here if you want you can add defaults when installing the operator (the same way as changing the values.yaml), for example :

#helm upgrade --install confluent-operator confluentinc/confluent-for-kubernetes --set podSecurity.enabled=true --set podSecurity.securityContext.fsGroup=1001 --set podSecurity.securityContext.runAsUser=1001


helm test confluent-operator



kubectl apply -f confluent-platform.yaml

echo "Waiting for all pods to be running..."
while [[ $(kubectl get pods -n confluent -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}' | tr ' ' '\n' | uniq) != "True" ]]; do
  sleep 5
done

#If gets stucked just CTRL + C and get check again the pods.

kubectl get pods -w  
kubectl port-forward controlcenter-0 9021:9021


open http://localhost:9021








