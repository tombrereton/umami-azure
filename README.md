# Umami in Azure

I was looking for a GDPR compliant and free alternative to Google Analytics and I found [Umami](https://umami.is).
It's simple UI is a pleasure to use (both mobile and desktop) and I'm very grateful Umami respects the user's privacy
so I don't have to display that annoying cookie banner. Check out below to get it deployed in minutes.

# Login

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
To run it, [fork and clone this repository](https://github.com/tombrereton/umami-azure), navigate to it in terminal and then run Bicep
using the following command.

```sh
az deployment sub create --location australiaeast --template-file infra/main.bicep
```

## Password and Hash Salt

The command will prompt you to enter a few parameters.
When prompted for the `databasePassword` and `hashSalt`, I recommend 
storing them somewhere secure like a password manager. 

You can use the `databasePassword` and the sqlserver username  `umami` to login 
into the database directly. If you want to change the username, edit it in the
`mysql.bicep` file.

> Note that you do _not_ need to record the `databasePassword` and `hashSalt` to login to Umami, only to login to the database or to point a new Umami app at an existing database.

A [hash salt](https://auth0.com/blog/adding-salt-to-hashing-a-better-way-to-store-passwords/) is used when hashing passwords, to make it more secure.
Note that passwords are hashed and NOT stored as plain text in the database.

You can use any random string for the password and hash salt but you can also use the following:

[bitwarden.com/password-generator](https://bitwarden.com/password-generator/)

# Different Location

You can change the `--location` in the `az deployment` command to somewhere closer.  
Run the following command and use one of the values from the `Name` column.

```sh
az account list-locations -o table
```

# Important

We are using Azure Container Apps (ACA) to host Umami. ACA are serverless containers which scale down to 0 (saving you money),
but this also means they are slow to load the first time if they have been inactive for a while. So if it's taking
a while to load, don't panic :smile: Give it 10-20 seconds to spin up and then you can sign in.

# Azure Resources
The Bicep files deploy the following main resources:
- Azure Container App
- MySql Server and Database

It also deploys the supporting resources for the Azure Container App:
- Container App Environment
- Log Analytics Workspace

# Log into Umami

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
