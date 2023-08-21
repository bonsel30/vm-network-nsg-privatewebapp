param parpupipname string = 'pupip${uniqueString(resourceGroup().id)}'

@description('Default location is location of resourcegroup')
param parlocation string 

resource respupip 'Microsoft.Network/publicIPAddresses@2022-01-01' = {
  name: parpupipname
  sku: {
    name:'Basic'
    tier:'Regional'
  }
  location:parlocation
  properties:{
    publicIPAddressVersion:'IPv4'
      }
}

output publicipid string = respupip.id
