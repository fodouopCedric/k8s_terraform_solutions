# modules/user_role_binding/main.tf

resource "kubernetes_role" "user_role" {
  count = length(var.role_names)

  metadata {
    name      = var.role_names[count.index]
    namespace = var.namespace_names[count.index]
  }

  rule {
    api_groups = [""]
    resources  = ["pods"]
    verbs      = ["list", "get"]
  }

  rule {
    api_groups = [""]
    resources  = ["services"]
    verbs      = ["list", "get"]
  }
}

resource "kubernetes_role_binding" "user_role_binding" {
  count = length(var.role_names)

  metadata {
    name      = "${var.role_names[count.index]}-binding"
    namespace = var.namespace_names[count.index]
  }

  subject {
    kind      = "User"
    name      = var.usernames[count.index]
    namespace = var.namespace_names[count.index]
  }

  role_ref {
    kind     = "Role"
    name     = var.role_names[count.index]
    api_group = "rbac.authorization.k8s.io"
  }
}

output "roles" {
  description = "List of created roles"
  value       = kubernetes_role.user_role[*].metadata[0].name
}

output "role_bindings" {
  description = "List of created role bindings"
  value       = kubernetes_role_binding.user_role_binding[*].metadata[0].name
}
