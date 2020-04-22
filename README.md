# Terraform Workshop

## Pre Workshop Checklist

----
- [Terraform Workshop](#terraform-workshop)
  - [Pre Workshop Checklist](#pre-workshop-checklist)
    - [Setup AWS Account](#setup-aws-account)
    - [Install Terraform](#install-terraform)
    - [Grab Starter Code](#grab-starter-code)
    - [Initialize Environment](#initialize-environment)
    - [Final Setup](#final-setup)
  - [Workshop](#workshop)
    - [What is Terraform and what is it good for?](#what-is-terraform-and-what-is-it-good-for)
    - [Terraform Syntax](#terraform-syntax)
    - [Terraform Commands](#terraform-commands)
    - [What are we doing in todays workshop](#what-are-we-doing-in-todays-workshop)
      - [Let's look at our architecture](#lets-look-at-our-architecture)
      - [Let's look at our code](#lets-look-at-our-code)
      - [Let's go!](#lets-go)
  - [Post Workshop Checklist](#post-workshop-checklist)
  - [Terraform Resources](#terraform-resources)

----

### Setup AWS Account

***

You can use your current account but if you no longer have the free tier offers than running this workshop may cost more. We suggest using a new account as described [here](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/) in order to get the free tier. 

Currently, I have found no credits to help offset any potential costs to this lab. Most of what I will use is in the free tier. I will update any cost received with running this lab in under the span of an hour. 

*NOTE:* In this lab we will be tearing down the infrastructure we will spin up. Be sure to double check that everything has been correctly torn down when you are down to ensure that you are not billed.

Now that we have our account set up we are going to do some basic security practices:

Begin by heading over to the Identity and Access Management (IAM) dashboard [here](https://console.aws.amazon.com/iam/home?#/home). Here we will see five basic recommendations to lock down your account. The first one is completed for you. Activation MFA on your root account is up to you. We will start creating an IAM user for this workshop [here](https://console.aws.amazon.com/iam/home?#/users).

1 ) Set your user details for this workshop. Make sure to check both Programmatic access and AWS Management Console access for this workshop. Once you understand Terraform you do not need console access (aka the web gui).

2) For permissions select `Attach existing policies directly` and then create policy. Select JSON and replace the default with what is in file `policy.json` in the `misc` folder. This will give our workshop user on the permissions needed to participate in this lab. 

3) No tags, review user, accept and then download the csv credentials. 

4) Grab the AWS User sign in link for convenience. Looks like: `https://0497100681.signin.aws.amazon.com/console`

5) Log into the console as your new user. 

Lastly, before we proceed make sure that you select your working region dashboard `us-west-2`

*[Back to Top](#terraform-workshop)*

### Install Terraform
*****

Terraform is distributed as a single Golang binary. Install Terraform by unzipping it and moving it to a directory included in your system's PATH . 

Instructions for installing Terraform binary can be found [here](https://www.terraform.io/downloads.html). 

~ Alterative install method
For those on Mac with brew: `brew install terraform`
For those on Linux with brew: `brew install terraform`

Test out your install with `terraform -v`

*[Back to Top](#terraform-workshop)*

### Grab Starter Code 
*****

Incase you have not grabbed the code we are going to work with today, do so now.

`git clone https://github.com/San-Jose-Technology-Group/Terraform_Workshop.git`

*[Back to Top](#terraform-workshop)*

### Initialize Environment
*****

In our workshop folder create a file called `terraform.tfvars` and add your access key and secret key for your IAM user that we created:

```
access_key = "YOUR_ACCESS_KEY"
secret_key = "YOUR_SECRET_KEY"
```

*[Back to Top](#terraform-workshop)*

### Final Setup 
*****

Last step is to create a key pair to allow you to ssh into the system. Navigate to the EC2 dashboard and select Key Pair or use this [link](https://us-west-2.console.aws.amazon.com/ec2/v2/home?region=us-west-2#KeyPairs:sort=keyName). Create a Key Pair, give it a name and download it. 

Give your key pair proper permissions with `chmod 600 your-ec2-keypair.pem`

We will be using ssh key forwarding to move from our bastion instance to our webserver. To learn more about this check our this [article](https://aws.amazon.com/blogs/security/securely-connect-to-linux-instances-running-in-a-private-amazon-vpc/)


*[Back to Top](#terraform-workshop)*

## Workshop

### What is Terraform and what is it good for? 
 
So what is Terraform? Terraform is a high level language used to manage infrastructure. It does this using the Hashicorp language (HCL). You can use it to interact, manage or work with all sort of infrastructure through their supported providers. It allows a versioned method for maintaining infrastructure.

To get a sense of the providers that are supported checkout: [Providers](https://www.terraform.io/docs/providers/index.html)

What may be a surprise is that many of the providers would be thought of as you only using their dashboard but now you can have accountability and transparency for provider settings. 

All infra is defined in a state file that can be store remotely.

*[Back to Top](#terraform-workshop)*

### Terraform Syntax

Live version of syntax coverage.

-  [Resource Syntax](https://www.terraform.io/docs/configuration/resources.html)
-  [Providers](https://www.terraform.io/docs/configuration/providers.html)
-  [Input](https://www.terraform.io/docs/configuration/variables.html)
-  [Output](https://www.terraform.io/docs/configuration/outputs.html)

[Everything Else](https://www.terraform.io/docs/configuration/index.html)

*[Back to Top](#terraform-workshop)*

### Terraform Commands

Here are the commands we are going to cover in our live workshop today. For more information check the docs [here](https://www.terraform.io/docs/commands/index.html).

```
apply              Builds or changes infrastructure
destroy            Destroy Terraform-managed infrastructure
fmt                Rewrites config files to canonical format
graph              Create a visual graph of Terraform resources
init               Initialize a Terraform working directory
plan               Generate and show an execution plan
show               Inspect Terraform state or plan
taint              Manually mark a resource for recreation
untaint            Manually unmark a resource as tainted
validate           Validates the Terraform files
version            Prints the Terraform version
```

*[Back to Top](#terraform-workshop)*

### What are we doing in todays workshop

In today's workshop we will be covering Infrastructure as Code, a basic web Infrastructure, setting you web Infrastructure with Terraform and bringing it all together in order to give you the stepping stones to implement your own Infrastructure as Code. 

We will be deploying a photo gallery web app in Go. This can be found, learned and built over at https://www.usegolang.com/

*[Back to Top](#terraform-workshop)*

#### Let's look at our architecture 

Live version of architecture coverage.

Here is a scary version of our Terraform Graph

![Architecture_Messy](/misc/graph.svg)

Here is a more palatable version!

![Architecture](/misc/arch.png)


*[Back to Top](#terraform-workshop)*

#### Let's look at our code

Live version of code coverage.

*[Back to Top](#terraform-workshop)*

#### Let's go!

To deploy the architecture, all that needs to be done is to run `./launch.sh`. 

Be aware that this infrastructure does not use secure endpoints. If deploying for a real application you need to (at the very least) set up https on the load balancer and restrict traffic to the webservers from only the load balancer. We do not do this today so no one needs to come with a domain name and can deploy this infra with single script. 

*[Back to Top](#terraform-workshop)*

## Post Workshop Checklist

When you are done be sure to run `terraform destroy` and confirm with `yes` to remove the infrastructure that was deployed. *FAILING TO DUE THIS CAN INCUR UNWANTED CHARGES!*

*[Back to Top](#terraform-workshop)*

## Terraform Resources

- [Learn Terraform from Terraform!](https://learn.hashicorp.com/terraform)
- [Terraform Docs](https://www.terraform.io/docs/index.html)

*[Back to Top](#terraform-workshop)*