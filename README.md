# Umami in Azure

I was looking for a GDPR compliant and free alternative to Google Analytics and I found Umami. It's simple UI has been a dream to use and I'm enternally grateful Umami respects the user's privacy so I don't have to display that annoying cookie banner. Check out below to get it deployed in minutes.

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
To run it, clone this repository, navigate to it in terminal and then run Bicep
using the following command.

```sh
az deployment sub create --location australiaeast --template-file infra/main.bicep
```

## Password and Hash Salt

This will prompt you enter a few parameters. Keep note of the password you set (securely) so you can login to the database directly.
The sqlserver username is set to `umami`, if you need to change it, edit the `mysql.bicep` file.

A [hash salt](https://auth0.com/blog/adding-salt-to-hashing-a-better-way-to-store-passwords/) is used when hashing passwords, to make it more secure.
Note that passwords are hashed and NOT stored as plain text in the database.

You can use any random string for the password and hash salt but you can also use the following:
https://bitwarden.com/password-generator/

# Different Location

You can change the location in the `az deployment` command to somewhere closer.  
Run the following command and use one of the values from the `Name` column.

```sh
az account list-locations -o table
```

# Important
We are using Azure Container Apps (ACA) to host Umami. ACA are serverless containers which scale down to 0 (saving you money), 
but this also means they are slow to load the first time if they have been inactive for a while. So if it's taking
a while to load, don't panic :smile: Give it 10-20 seconds to spin up and you can sign in.

# Set Up Umami
Follow the [official Umami documentation](https://umami.is/docs/login) from the `Login` stage!
