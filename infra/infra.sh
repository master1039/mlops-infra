RESOURCE_GROUP="MY_MLOPS_RG"
LOCATION="eastus2"
WORKSPACE_NAME="mlops-workspace-automation"
CLUSTER_NAME="mlops-cluster"

az group create -n $RESOURCE_GROUP -l $LOCATION

az ml workspace create -n $WORKSPACE_NAME -g $RESOURCE_GROUP -l $LOCATION

az ml workspace set -g $RESOURCE_GROUP -w $WORKSPACE_NAME

az ml create compute --name $CLUSTER_NAME \
                        --type amlcompute \
                        --size Standard_DS11_V2 \
                        --min-instance 0 --max-instance 1

