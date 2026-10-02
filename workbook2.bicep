param workbookName string = 'Http2xx-Monitoring-Workbook'
param webAppName string //= 'demodash-jmre75moeoexeg-web-app'
param resourceGroupName string = resourceGroup().name
param subscriptionId string = subscription().subscriptionId
param location string = resourceGroup().location

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
              '/subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.Web/sites/${webAppName}'
            ]
            timeContext: {
              durationMs: 86400000
            }
            metrics: [
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
        {
          type: 3
          content: {
            version: 'KqlItem/1.0'
            query: '''AppRequests
            | summarize
             totalRequests = count(),
             AverageResponseTimeMs = round(avg(DurationMs), 2),
             SlowResponses = countif(DurationMs > 2200),
             ErrorCount = countif(ResultCode == 500),
             StandardSuccess = countif(ResultCode ==200 and DurationMs < 2000)
             by Name
            '''
            size: 1
            timeContext: {
              durationMs: 86400000
            }
            queryType: 0
            resourceType: 'microsoft.operationalinsights/workspaces'
            crossComponentResources: [
              '/subscriptions/574a07c8-b128-4a24-ac5f-1b8550b5a804/resourcegroups/webapp-sa-rg/providers/microsoft.operationalinsights/workspaces/pizza-app-q4o6gevbs7fkm-log-workspace'
            ]
          }
          name: 'query - 1'
        }
        {
          type: 3
          content: {
            version: 'KqlItem/1.0'
            query: '''AppRequests
        | summarize
           total = count(),
           AVGResponseTimeMS = avg(DurationMs)
           by ResultCode, Name'''
            size: 0
            timeContext: {
              durationMs: 86400000
            }
            queryType: 0
            resourceType: 'microsoft.operationalinsights/workspaces'
            crossComponentResources: [
              '/subscriptions/574a07c8-b128-4a24-ac5f-1b8550b5a804/resourceGroups/webapp-sa-rg/providers/Microsoft.OperationalInsights/workspaces/pizza-app-q4o6gevbs7fkm-log-workspace'
            ]
          }
          name: 'query - 2'
        }
      ]
    })
  }
  dependsOn: []
}

output workbookId string = appServiceWorkbook.id
