# modules/user_role_binding/variables.tf

variable "usernames" {
  description = "List of usernames"
  type        = list(string)
}

variable "namespace_names" {
  description = "List of namespace names"
  type        = list(string)
}

variable "role_names" {
  description = "List of role names"
  type        = list(string)
}
