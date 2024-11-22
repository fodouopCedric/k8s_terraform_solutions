# main.tf

# Kubernetes provider configuration
provider "kubernetes" {
  config_path = "~/.kube/config"
}

# Module for creating namespaces for users
module "user_resources" {
  source = "./modules/user"

  usernames      = var.usernames
  namespace_names = var.namespace_names
}

# Module for creating roles and role bindings for users
module "user_roles_and_bindings" {
  source = "./modules/user_role_binding"

  usernames      = var.usernames
  namespace_names = var.namespace_names
  role_names      = var.role_names
}
