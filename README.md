# Introduction 
This project creates several resources:
1. A virtual network with two subnets: Subnet1 and Subnet2 
2. A Virtual Machine (server 2019) with a public IP and a private IP in subnet1
3. A NSG linked to subnet both subnets. A pieline variable will ask for your interet ip address. This variable is used to allow your internet ip adress to allow RDP into the vm.
4. A WebApp:
4a. A private link for the WebApp, private link is in subnet2
4b. The WebApp downloads a "hello world" image from another github location (https://github.com/Azure-Samples/nodejs-docs-hello-world)
5. A private DNS zone for the web app private link (privatelink.azurewebsites.net)

The webapp is not reachable from the internet, but can be reached from the vm.

# Getting Started
1. Register the yaml pipeline in your own tenant.
2. Run the pipeline
3. Select a location (either north or west europe)
4. Lookup your internet ip adddress (via whatismyip.com) and enter it in the inputfield using x.x.x.x/32
5. When finished a vm with a webapp should now exist. 


# Build and Test
1. The webapp is unreachable from the internet, but is reachable from the vm.
2. RDP into the VM.
3. Browse to the webapp from the vm (should work, can tkae a few minutes before the webapp is available).
4. Browse to the vm from your own device (should not work)

# Contribute
Please feel free to download the project and run it yourself
