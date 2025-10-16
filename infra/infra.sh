RESOURCE_GROUP="MY_MLOPS_RG"
LOCATION="eastus2"
WORKSPACE_NAME="mlops-workspace-nervecentre-e"
CLUSTER_NAME="mlops-cluster"
STORAGE_NAME="mlopsstorage1039ge"  
FUNCTION_NAME="mlops-function"
PLAN_NAME="mlops-func-plan"

echo "🔹 Creating Resource Group: $RESOURCE_GROUP ..."
az group create -n $RESOURCE_GROUP -l $LOCATION

echo "🔹 Creating Azure ML Workspace: $WORKSPACE_NAME ..."
az ml workspace create -n $WORKSPACE_NAME -g $RESOURCE_GROUP -l $LOCATION

#az ml workspace set -g $RESOURCE_GROUP -w $WORKSPACE_NAME

az configure --defaults group=$RESOURCE_GROUP workspace=$WORKSPACE_NAME

echo "🔹 Creating Compute Cluster: $COMPUTE_NAME ..."
az ml compute create --name $CLUSTER_NAME \
                        --type amlcompute \
                        --size Standard_DS11_V2 \
                        --min-instances 0 \
                        --max-instances 1 \
                        --resource-group $RESOURCE_GROUP \
                        --workspace-name $WORKSPACE_NAME

echo "Creating Dedicated Blob Storage: $STORAGE_NAME ..."
az storage account create \
  --name $STORAGE_NAME \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --sku Standard_LRS

az storage container create \
  --name "data-artifacts" \
  --account-name $STORAGE_NAME

echo "Storage created: https://$STORAGE_NAME.blob.core.windows.net/data-artifacts"

echo "🔹 Creating Azure Function: $FUNCTION_NAME ..."
az functionapp plan create \
  --resource-group $RESOURCE_GROUP \
  --name $PLAN_NAME \
  --location $LOCATION \
  --sku B1

az functionapp create \
  --resource-group $RESOURCE_GROUP \
  --name $FUNCTION_NAME \
  --storage-account $STORAGE_NAME \
  --plan $PLAN_NAME \
  --runtime python \
  --functions-version 4

echo "✅ Azure Function created: $FUNCTION_NAME"

echo "Infra setup complete!"
echo "Resource Group: $RESOURCE_GROUP"
echo "Workspace: $WORKSPACE_NAME"
echo "Compute: $COMPUTE_NAME"
echo "Storage: $STORAGE_NAME"
echo "Function: $FUNCTION_NAME"