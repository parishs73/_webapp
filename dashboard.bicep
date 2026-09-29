param location string
param dashboardName string
param logWorkspaceId string
param webAppName string

resource portalDashboard 'Microsoft.Portal/dashboards@2020-09-01-preview' = {
  name: dashboardName
  location: location
  properties: {
    lenses: [
      {
        order: 0
        parts: any([
          // 1. Markdown Info Tile (Works flawlessly)
          {
            position: {
              x: 0
              y: 0
              colSpan: 4
              rowSpan: 4
            }
            metadata: {
              inputs: []
              type: 'Extension/HubsExtension/PartType/MarkdownPart'
              settings: {
                content: {
                  settings: {
                    title: 'Free Architecture Tracker'
                    subtitle: 'Demo App Controls'
                    content: '### Environment Overview\nThis dashboard tracks the diagnostic loops running inside your free-tier App Service, Serverless Functions, and Cosmos DB instances.'
                    markdownSource: 1
                  }
                }
              }
            }
          }
          // 2. FIXED: Modern Live Log Analytics Query Tile
          {
            position: {
              x: 4
              y: 0
              colSpan: 6
              rowSpan: 4
            }
            metadata: {
              inputs: [
                {
                  name: 'resourceId'
                  value: logWorkspaceId
                }
              ]
              type: 'Extension/Microsoft_Azure_Monitoring/PartType/AnalyticsPart'
              settings: {
                content: {
                  query: 'AppRequests | summarize Count = count() by bin(TimeGenerated, 5m)'
                  title: 'Frontend Hits (5m Granularity)'
                  chartType: 'LineChart'
                }
              }
            }
          }
          // 3. App Service Performance Metrics Chart (Works flawlessly)
          {
            position: {
              x: 0
              y: 4
              colSpan: 10
              rowSpan: 4
            }
            metadata: {
              inputs: [
                {
                  name: 'options'
                  value: {
                    chart: {
                      metrics: [
                        {
                          resourceMetadata: {
                            id: resourceId('Microsoft.Web/sites', webAppName)
                          }
                          name: 'CpuTime'
                          aggregationType: 1
                        }
                      ]
                      title: 'App Service CPU Consumption'
                      chartType: 2
                    }
                  }
                }
              ]
              type: 'Extension/HubsExtension/PartType/MetricsChartPart'
            }
          }
        ])
      }
    ]
    metadata: {
      model: {
        timeRange: {
          value: {
            relative: {
              duration: 24
              timeUnit: 1
            }
          }
          type: 'MsPortalFx.Composition.Configuration.TimeRange'
        }
      }
    }
  }
}
