#-------------- CONFIG PROVIDER -----------------------------------------------------

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.0.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }
  }
}

# retrieve outputs from existing aks cluster
data "terraform_remote_state" "aks" {
  backend = "local"

  config = {
    path = "../1/terraform.tfstate"
  }
}

# Retrieve AKS cluster information
provider "azurerm" {
  features {}
}

data "azurerm_kubernetes_cluster" "cluster" {
  name                = data.terraform_remote_state.aks.outputs.kubernetes_cluster_name
  resource_group_name = data.terraform_remote_state.aks.outputs.resource_group_name
}

provider "kubernetes" {
  host = data.azurerm_kubernetes_cluster.cluster.kube_config.0.host

  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.cluster_ca_certificate)
}


#-------------- CREATE NameSpace -----------------------------------------------------

resource "kubernetes_namespace" "prod-ns" {
  metadata {
    annotations = {
      name = "production"
    }
    labels = {
      env = "production"
    }
    name = "production"
  }
}

resource "kubernetes_namespace" "dev-ns" {
  metadata {
    annotations = {
      name = "dev"
    }

    labels = {
      env = "dev"
    }

    name = "dev"
  }
}

resource "kubernetes_namespace" "qa-ns" {
  metadata {
    annotations = {
      name = "qa"
    }

    labels = {
      env = "qa"
    }

    name = "qa"
  }
}

resource "kubernetes_namespace" "staging-ns" {
  metadata {
    annotations = {
      name = "staging"
    }

    labels = {
      env = "staging"
    }

    name = "staging"
  }
}