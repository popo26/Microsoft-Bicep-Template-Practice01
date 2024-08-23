param appServiceAppName string = 'toylaunch${uniqueString(resourceGroup().id)}' //This needs to be unique globally
param location string = 'southeastasia'
param storageAccountName string = 'toylaunch${uniqueString(resourceGroup().id)}' //This needs to be unique globally

@allowed([
  'nonprod'
  'prod'
])
param environmentType string

var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'


resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountSkuName
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}


module appService 'modules/appService.bicep' = {
  name: 'appService'
  params: {
    location: location
    appServiceAppName: appServiceAppName
    environmentType:environmentType
  }
}

output appServiceAppHostName string = appService.outputs.appServiceAppHostName
