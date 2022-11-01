# Umami in Azure

# Prereqs
Before setting up Umami in Azure you need to be logged into your Azure and set it to your subscription.

```sh
az login
az account set --subscription <subscriptionId>
```

Also we need at least Azure CLI 2.20.0 or later installed to run Bicep commands.

 https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install

# Creating Azure Resources
We will use Bicep to create the resources. To run it, clone this repository, navigate to it in terminal and then run Bicep.

```sh
az deployment sub create --location AustraliaEast --template-file infra/main.bicep
```

This will prompt you enter a few parameters. Keep note of the password you set (securely), so that you can log in later. The username is set to `umami`.


https://www.thorsten-hans.com/how-to-deploy-azure-container-apps-with-bicep/


https://learn.microsoft.com/en-us/azure/container-apps/github-actions-cli?tabs=bash