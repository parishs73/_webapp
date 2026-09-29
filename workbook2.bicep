param workbookName string ='Http2xx-Monitoring-Workbook'
param webAppName string //= 'demodash-jmre75moeoexeg-web-app'
param resourceGroupName string = resourceGroup().name
param subscriptionId string = subscription().subscriptionId
param location string =  resourceGroup().location

resource appServiceWorkbook 'Microsoft.Insights/workbooks@2023-06-01' = {
  name: guid(workbookName)
  identity: {
    type: 'None'
  }
  location: location
  kind: 'shared'
  properties: {
    category: 'workbook'
    displayName: 'Web App Http 2xx Dashboard2'
    sourceId: '/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}'
    version: 'Notebook/1.0'
    serializedData: string({
      version: 'Notebook/1.0'
      items: [
        {
          type: 10
          content: {
            version: 'MetricsItem/2.0'
            size: 0 // 0 = Medium size, 1 = Large, etc.
            resourceType: 'microsoft.web/sites'
            metricScope: 0
            resourceIds: [
              // Points the graph directly to the targeted Web App resource ID
              '/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.Web/sites/${webAppName}']
                timeContext:{
                  durationMs:86400000
                }
                metrics:[
                  {
                    metric: 'microsoft.web/sites--Http2xx'
                    namespace: 'microsoft.web/sites'
                    aggregation: 1
                  }
                  {
                    metric: 'microsoft.web/sites--Http4xx'
                    namespace: 'microsoft.web/sites'
                    aggregation: 1
                  }
                  {
                    metric: 'microsoft.web/sites--Http5xx'
                    namespace: 'microsoft.web/sites'
                    aggregation: 1
                  }
                ]
            chartType: 2 // 2 corresponds to a Line Chart
                
              
            
            gridSettings: {
              rowLimit: 1000
            }
          }
          name: 'Http Metric Chart'
        }
      ]
    })

  }
  dependsOn: []

}


output workbookId string = appServiceWorkbook.id
