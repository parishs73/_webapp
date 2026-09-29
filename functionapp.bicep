param location string
param prefix string

resource funcStorage 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: '${substring(replace(prefix, '-', ''), 0, 15)}fstor'
  location: location
  sku: {
    name: 'Standard_LRS' // Lowest cost base tier, minuscule billing only if limits exceeded
  }
  kind: 'StorageV2'
}

resource funcPlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: '${prefix}-func-plan'
  location: location
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
}

resource functionApp 'Microsoft.Web/sites@2023-12-01' = {
  name: '${prefix}-function-app'
  location: location
  kind: 'functionapp'
  properties: {
    serverFarmId: funcPlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${funcStorage.name};AccountKey=${funcStorage.listKeys().keys[0].value};EndpointSuffix=${environment().suffixes.storage}'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet'
        }
      ]
    }
  }
}
