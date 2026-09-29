$COSMOSDB_NAME =(az cosmosdb list --query [].name -o tsv)
$RG = 'pizza-app'

$COSMOSDB_ENDPOINT =(az cosmosdb show -g $RG -n $COSMOSDB_NAME --query documentEndpoint -o tsv)

$COSMOSDB_KEY = (az cosmosdb keys list -g $RG -n $COSMOSDB_NAME --query primaryMasterKey -o tsv)

Write-Output "KEY = $COSMOSDB_KEY"
Write-Output "DB NAME = $COSMOSDB_NAME"
Write-Output "ENDPOINT = $COSMOSDB_ENDPOINT"