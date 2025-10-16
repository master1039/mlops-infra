RESOURCE_GROUP="MY_MLOPS_RG"
LOCATION="eastus2"
WORKSPACE_NAME="mlops-workspace-NC"
CLUSTER_NAME="mlops-cluster"

az group create -n $RESOURCE_GROUP -l $LOCATION

az ml workspace create -n $WORKSPACE_NAME -g $RESOURCE_GROUP -l $LOCATION

#az ml workspace set -g $RESOURCE_GROUP -w $WORKSPACE_NAME

az configure --defaults group=$RESOURCE_GROUP workspace=$WORKSPACE_NAME

az ml compute create --name $CLUSTER_NAME \
                        --type amlcompute \
                        --size Standard_DS11_V2 \
                        --min-instances 0 \
                        --max-instances 1

