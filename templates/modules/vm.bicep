@description('Default location is location of resourcegroup')
param parlocation string 

@minLength(1)
@maxLength(15)
@description('Name of virtualmachine, for windows maximum of 15 characters')
param parvmwindows2019name string = 'bons30vm2019'
param parvm2019hwprofile string = 'Standard_D2s_v3'
@description('The Windows version for the VM. This will pick a fully patched image of this given Windows version.')
@allowed([
  '2008-R2-SP1'
  '2012-Datacenter'
  '2012-R2-Datacenter'
  '2016-Nano-Server'
  '2016-Datacenter-with-Containers'
  '2016-Datacenter'
  '2019-Datacenter'
  '2019-Datacenter-Core'
  '2019-Datacenter-Core-smalldisk'
  '2019-Datacenter-Core-with-Containers'
  '2019-Datacenter-Core-with-Containers-smalldisk'
  '2019-Datacenter-smalldisk'
  '2019-Datacenter-with-Containers'
  '2019-Datacenter-with-Containers-smalldisk'
])
param parOSVersion string = '2019-Datacenter'
@secure()
param parserver2019password string
@secure()
param parserver2019adminname string
param parnicwin2019name string = 'bons30${uniqueString(resourceGroup().id)}'
param parpublicip string
param parsubnet1id string

var vartagwin2019vm = {
  owner: 'Jeroen Bonsel'
  Department: 'Thuis'
}

resource resvmwindows2019 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: parvmwindows2019name
  location: parlocation
  tags: vartagwin2019vm

  properties: {
    hardwareProfile:{
      vmSize:parvm2019hwprofile
    }
    networkProfile:{
      networkInterfaces:[
        {
          id:resnicwin2019.id
        }
      ]
    }
    osProfile:{
      adminPassword:parserver2019password
      adminUsername:parserver2019adminname
      computerName:parvmwindows2019name
    }
    storageProfile:{
      imageReference:{
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: parOSVersion
        version: 'latest'
      }
    }
  }

}

resource resnicwin2019 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: parnicwin2019name
  location:parlocation
  properties:{
    ipConfigurations:[
      {
        name:'ipconfig1'
        properties:{
          subnet:{
            id: parsubnet1id  

          }
          privateIPAddressVersion:'IPv4'
          privateIPAllocationMethod:'Dynamic'
          publicIPAddress:{
            id: parpublicip
          }
        }
      }
    ]
    
  }
}


