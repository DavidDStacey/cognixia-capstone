# cognixia-capstone

## General Info:

The application does the following: 
* GET /{any_number} returns the roman numeral equivalent of that number
* GET /ping returns the static text "pong".
* GET /version returns the version of the application.


## Technologies:

Created with:
* Azure
* AzureDevops
* Terraform
* Kubernetes
* Docker

## Setup:

Using Terraform you create the kubernetes cluster along with the namespaces: <br/>
`terraform init`<br/>
`terraform validate`<br/>
`terraform plan`<br/>
`terraform apply`<br/>

Azure is used to store the container in the ACR. <br/>
AzureDevops is used to create a pipeline that continuously deploys when there are updates to the github repo.


Namespaces:
* Dev
* QA
* Staging
* Prod

note: pipeline no longer functions as resources have been taken down
