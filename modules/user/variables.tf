# modules/user/variables.tf

variable "usernames" {
  description = "List of usernames"
  type        = list(string)
}

variable "namespace_names" {
  description = "List of namespace names"
  type        = list(string)
}
