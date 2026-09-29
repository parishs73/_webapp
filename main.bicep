targetScope = 'resourceGroup'

param location string = resourceGroup().location
// Change this unique prefix to prevent naming conflicts on global Azure paths
param appPrefix string = 'pizza-app-${uniqueString(resourceGroup().id)}' //must be lowercase
param appInsightsLocation string = 'southafricanorth'
param workbookName string = 'monitoring-book2'
param subscriptionId string = subscription().subscriptionId
param resourceGroupName string = resourceGroup().name

// Deploy Database
module databaseLayer './cosmos.bicep' = {
  name: 'CosmosDeployment'
  params: {
    location: location
    prefix: appPrefix
  }
}

// Deploy Frontend + Log Analytics
module webLayer './appservice.bicep' = {
  name: 'WebDeployment'
  params: {
    logLocation: appInsightsLocation
    location: location
    prefix: appPrefix
    cosmosAccountName: databaseLayer.outputs.cosmosAccountName
  }
}

// Deploy Background Serverless Engine
module computeLayer './functionapp.bicep' = {
  name: 'FunctionDeployment'
  params: {
    location: location
    prefix: appPrefix
  }
}

/*
// NEW CONFIGURATION: Replaces the broken dashboard format with a clean workbook asset
module workbookLayer './workbook.bicep' = {
  name: 'WorkbookDeployment'
  params: {
    location: appInsightsLocation
    workbookName: '${appPrefix}-monitoring-book'
    logWorkspaceId: webLayer.outputs.logAnalyticsId
  }
}
*/

module workbookLayer2 './workbook2.bicep' = {
  name: 'WorkbookDeployment2'
  params: {
    location: appInsightsLocation
    workbookName: workbookName //'${appPrefix}-monitoring-book'
    webAppName: webLayer.outputs.webAppname
    subscriptionId: subscriptionId
    resourceGroupName: resourceGroupName
  }
}

/*
// NEW: Automatically deploy the pre-populated monitoring dashboard
module dashboardLayer './dashboard.bicep' = {
  name: 'DashboardDeployment'
  params: {
    location: appInsightsLocation
    dashboardName: '${appPrefix}-monitoring-board'
    logWorkspaceId: webLayer.outputs.logAnalyticsId
    webAppName: '${appPrefix}-web-app'
  }
}
*/
// comment out multiple lines of code below to remove the broken dashboard deployment


output generatedAppName string = appPrefix
output logWorkspaceResourceId string = webLayer.outputs.logAnalyticsId
