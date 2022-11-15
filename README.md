# Umami in Azure

I was looking for a GDPR compliant and Open Source alternative to Google Analytics, and I found [Umami](https://umami.is).
It's simple UI is a pleasure to use on both mobile and desktop, which you can check out yourself at [Umami's Live Demo](https://app.umami.is/share/8rmHaheU/umami.is). Another big plus is that Umami respects the user's privacy and doesn't collect identifiable data, which means I don't have to display that annoying cookie banner. If this sounds like something you'd be interested in, check out the steps below to get it deployed in minutes.

# Login to Azure

To get started you need the following:

- [Azure Cli](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Azure Subscription](https://azure.microsoft.com/en-au/free/)

Before deploying Umami to Azure you need to be logged into your Azure and set it to your subscription.
Open a terminal, run the following commands, and follow the interactive login.

```sh
az login
az account set --subscription <subscriptionId>
```

# Deploy

Once logged in, we will run a simple command and follow the prompts to deploy Umami.
To run it, [clone this repository](https://github.com/tombrereton/umami-azure), navigate to it in terminal and then run Bicep using the following command.

```sh
az deployment sub create --location australiaeast --template-file infra/main.bicep
```

### Parameters

- `appName` e.g. `"umami"`
- `env` e.g. `2` for `"pdn"`
- `databasePassword` e.g. from [password-generator](https://bitwarden.com/password-generator/)
- `hashSalt` e.g. from [password-generator](https://bitwarden.com/password-generator/)

### Resource Group
The Bicep file will deploy all the resources to a resource group called, `rg-[appName]-[env]`

## Password and Hash Salt

The command will prompt you to enter a few parameters.
When prompted for the `databasePassword` and `hashSalt`, I recommend
storing them somewhere secure like a password manager.

You can use the `databasePassword` you entered, with the sqlserver username `"umami"` to login
into the database directly. If you want to change the username, edit it in the
`mysql.bicep` file.

> Note that you do _not_ need to record the `databasePassword` and `hashSalt` to login to Umami, only to login to the database or to point a new Umami app at an existing database.

Note that a [hash salt](https://auth0.com/blog/adding-salt-to-hashing-a-better-way-to-store-passwords/) is used when hashing passwords, to make it more secure.

You can use any random string for the password and hash salt, but it is recommended to use something like the following: [bitwarden.com/password-generator](https://bitwarden.com/password-generator/)

# Different Location

You can change the `--location` in the `az deployment` command to somewhere closer.  
Run the following command and use one of the values from the `Name` column.

```sh
az account list-locations -o table
```

# Important

We are using [Azure Container Apps](https://learn.microsoft.com/en-us/azure/container-apps/overview) (ACA) to host Umami. ACA are serverless containers which scale down to zero (saving you money),
but this also means they are slow to load the first time if they have been inactive for a while. So if it's taking
a while to load, don't panic! Give it 10-20 seconds to spin up and then you can login.

# Azure Resources

The Bicep files deploy the following main resources:

- [Azure Container App](https://learn.microsoft.com/en-us/azure/container-apps/overview)
- MySql Server and Database

It also deploys the supporting resources for the Azure Container App:

- Container App Environment
- Log Analytics Workspace

# Next Steps

Follow the [official Umami documentation](https://umami.is/docs/login) from the `Login` stage!

To get the url for the login either navigate to the ACA in the Azure Portal or run the following
command in the terminal.

```sh
 az deployment group show \
  -g "rg-umami-pdn" \
  -n "aca-umami" \
  --query properties.outputs.fqdn.value
```

> Your Umami installation will create a default administrator account with the username **admin** and the password **umami**.
>
> The first thing you will want to do is log in and change your password.
