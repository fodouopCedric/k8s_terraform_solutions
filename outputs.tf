# outputs.tf

output "user_namespaces" {
  description = "The names of the created namespaces"
  value       = module.user_resources.namespaces
}

output "user_roles" {
  description = "The names of the created roles"
  value       = module.user_roles_and_bindings.roles
}

output "user_role_bindings" {
  description = "The names of the created role bindings"
  value       = module.user_roles_and_bindings.role_bindings
}
