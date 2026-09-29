param location string
param workbookName string
param logWorkspaceId string

resource azureWorkbook 'Microsoft.Insights/workbooks@2023-06-01' = {
  name: guid(workbookName)
  location: location
  kind: 'shared'
  properties: {
    category: 'workbook'
    displayName: 'Free Architecture Live Tracker'
    serializedData: string({
      version: 'Notebook/1.0'
      items: [
        {
          type: 1
          content: {
            json: '### Live Environment Monitoring\nThis workbook pulls diagnostic events running inside your free-tier App Service and Cosmos DB resources.'
          }
          name: 'text_header'
        }
        {
          type: 3
          content: {
            version: 'KqlParameterItem/1.0'
            query: 'AppRequests | summarize Count = count() by bin(TimeGenerated, 5m)'
            size: 0
            timeContext: {
              durationMs: 86400000
            }
            queryType: 0
            resourceType: 'microsoft.operationalinsights/workspaces'
            crossComponentResources: [
              logWorkspaceId
            ]
            visualization: 'linechart'
            title: 'Live Frontend Hits (5-Minute Intervals)'
          }
          name: 'live_traffic_chart'
        }
      ]
    })
  }
}
