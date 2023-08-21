param parvirtualnetworkid string
param parZonename string

resource resPrivateDNSZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: parZonename
  location: 'global'
}


resource resvnetLinks 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: resPrivateDNSZone
  name: 'link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: parvirtualnetworkid
    }
  }
}




output websitednszoneid string = resPrivateDNSZone.id
output websitednszonename string = resPrivateDNSZone.name


