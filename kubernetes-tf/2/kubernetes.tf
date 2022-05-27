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

#-------------- CREATE DEPLOYMENT -----------------------------------------------------

# resource "kubernetes_deployment" "nginx" {
#   metadata {
#     name = "scalable-nginx-example"
#     labels = {
#       App = "ScalableNginxExample"
#     }
#   }

#   spec {
#     replicas = 2
#     selector {
#       match_labels = {
#         App = "ScalableNginxExample"
#       }
#     }
#     template {
#       metadata {
#         labels = {
#           App = "ScalableNginxExample"
#         }
#       }
#       spec {
#         container {
#           image = "nginx:1.7.8"
#           name  = "example"

#           port {
#             container_port = 80
#           }

#           resources {
#             limits = {
#               cpu    = "0.5"
#               memory = "512Mi"
#             }
#             requests = {
#               cpu    = "250m"
#               memory = "50Mi"
#             }
#           }
#         }
#       }
#     }
#   }
# }

# #-------------- CREATE LOAD BALANCER -----------------------------------------------------

# resource "kubernetes_service" "nginx" {
#   metadata {
#     name = "nginx-example"
#   }
#   spec {
#     selector = {
#       App = kubernetes_deployment.nginx.spec.0.template.0.metadata[0].labels.App
#     }
#     port {
#       port        = 80
#       target_port = 80
#     }

#     type = "LoadBalancer"
#   }
# }

# #-------------- OUTPUT PUBLIC IP -----------------------------------------------------

# output "lb_ip" {
#   value = kubernetes_service.nginx.status.0.load_balancer.0.ingress.0.ip
# }