# modules/user/main.tf

resource "kubernetes_namespace" "user_namespace" {
  count = length(var.namespace_names)

  metadata {
    name = var.namespace_names[count.index]
  }
}

output "namespaces" {
  description = "List of created namespaces"
  value       = kubernetes_namespace.user_namespace[*].metadata[0].name
}
