####### try number 1 error says
####### Load Balancer is not ready yet
# resource "kubernetes_service_v1" "ingress-svc" {
#   metadata {
#     name = "ingress-service"
#   }
#   spec {
#     port {
#       port        = 80
#       target_port = 80
#       protocol    = "TCP"
#     }
#     type = "LoadBalancer"
#   }
# }


# resource "kubernetes_ingress_v1" "ingress" {
#   wait_for_load_balancer = true
#   metadata {
#     name = "ingress"
#   }
#   spec {
#     ingress_class_name = "nginx"
#     rule {
#       http {
#         path {
#           path = "/*"
#           backend {
#             service {
#               #name = kubernetes_service.ingress-svc.metadata.0.name
#               name = kubernetes_service_v1.ingress-svc.metadata.0.name
#               port {
#                 number = 80
#               }
#             }
#           }
#         }
#       }
#     }
#   }
# }

###### this is try number 2 error 
###### says Waiting for rollout to finish: 2 replicas wanted; 0 replicas Ready

# #-------------- CREATE DEPLOYMENT -----------------------------------------------------

# resource "kubernetes_deployment" "deploy" {
#   metadata {
#     name = "capstone"
#     labels = {
#       App = "capstone"
#     }
#   }

#   spec {
#     replicas = 2
#     selector {
#       match_labels = {
#         App = "capstone"
#       }
#     }
#     template {
#       metadata {
#         labels = {
#           App = "capstone"
#         }
#       }
#       spec {
#         container {
#           image = "capstoneacr123.azurecr.io/capstone-container"
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

# resource "kubernetes_service" "capstone-service" {
#   metadata {
#     name = "service"
#   }
#   spec {
#     selector = {
#       App = kubernetes_deployment.deploy.spec.0.template.0.metadata[0].labels.App
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
#   value = kubernetes_service.capstone-service.status.0.load_balancer.0.ingress.0.ip
# }


