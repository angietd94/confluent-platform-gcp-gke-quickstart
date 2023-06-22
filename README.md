# Confluent Platform Quickstart: Installing on GKE Kubernetes service on GCP
<br>
Quick start installation of Confluent Platform on Kubernetes GKE service by GCP (Google Cloud Platform).
<br>
This guide is intended for Proof of Concept or testing, and is working and tested on MacOS. <br>
I recorder a videdo of this procedure and you can watch it here.
<br>
<br>
## First steps:

First of all download the repo in your local machine with git clone.
<br>
Make sure that you have gcloud installed and it's in your PATH.
<br>
https://jansutris10.medium.com/install-google-cloud-sdk-using-homebrew-on-mac-2952c9c7b5a1  --> Step 2

<br>
Enter in the folder with cd and let install.sh be executable with chmod +x.

# Set the GKE cluster details

Inside install.sh, please change the following according to your preferences and profile:<br>
```
PROJECT_ID="<put-your-project-id-here"
```

If you want to use an already existing cluster correct the part :
```
#CLUSTER_NAME="<your-cluster-name>"
#ZONE="<your-favourite-zone>"
```
<br>
If not, it will automatically create one with your MacOS Hostname. Here:

```
HOSTNAME=$(hostname | tr '[:upper:]' '[:lower:]' | tr -cd '[[:alnum:]]._-')
CLUSTER_NAME="$HOSTNAME-cp"
ZONE="europe-west1-b"
```
# When ready.. Launch the script
```
./install.sh
```
Then all the magic will happen to install Helm and Confluent Platform with Helm.
<br>
CP services are installed by the yml file included here:
```
kubectl apply -f confluent-platform.yaml
```
<br>
Have fun!
<br>

In the end, once all the pods are working, for ease of use we will forward the Control center to our Localhost.
```
kubectl port-forward controlcenter-0 9021:9021


open http://localhost:9021
```
