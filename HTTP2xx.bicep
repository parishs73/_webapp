@description('The friendly name for the workbook that is used in the Gallery or Saved List.  This name must be unique within a resource group.')
param workbookDisplayName string = 'HTTP2xx'

@description('The gallery that the workbook will been shown under. Supported values include workbook, tsg, etc. Usually, this is \'workbook\'')
param workbookType string = 'workbook'

@description('The id of resource instance to which the workbook will be associated')
param workbookSourceId string = '/subscriptions/574a07c8-b128-4a24-ac5f-1b8550b5a804/resourcegroups/test-webapp'

@description('The unique guid for this workbook instance')
param workbookId string = newGuid()

resource workbookId_resource 'microsoft.insights/workbooks@2022-04-01' = {
  name: workbookId
  location: resourceGroup().location
  kind: 'shared'
  properties: {
    displayName: workbookDisplayName
    serializedData: string({
      version: 'Notebook/1.0'
      items: [
        {
          type: 10
          content: {
            version: 'MetricsItem/2.0'
            size: 0
            chartType: 2
            resourceType: 'microsoft.web/sites'
            metricScope: 0
            resourceIds: [
              '/subscriptions/574a07c8-b128-4a24-ac5f-1b8550b5a804/resourceGroups/test-webapp/providers/Microsoft.Web/sites/demodash-jmre75moeoxeg-web-app'
            ]
            timeContext: {
              durationMs: 86400000
            }
            metrics: [
              { namespace: 'microsoft.web/sites', metric: 'microsoft.web/sites--Http2xx', aggregation: 1 }
            ]
            gridSettings: {
              rowLimit: 10000
            }
          }
          name: 'metric - 0'
        }
      ]
      isLocked: false
      fallbackResourceIds: [
        '/subscriptions/574a07c8-b128-4a24-ac5f-1b8550b5a804/resourcegroups/test-webapp'
      ]
    })
    version: '1.0'
    sourceId: workbookSourceId
    category: workbookType
  }
  dependsOn: []
}

output workbookId string = workbookId_resource.id
