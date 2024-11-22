# variables.tf

# List of usernames (4 users in this case)
variable "usernames" {
  description = "List of usernames"
  type        = list(string)
  default     = ["user1", "user2", "user3", "user4"]
}

# List of namespace names (one for each user)
variable "namespace_names" {
  description = "List of namespace names"
  type        = list(string)
  default     = ["user1-namespace", "user2-namespace", "user3-namespace", "user4-namespace"]
}

# List of role names for each user
variable "role_names" {
  description = "List of role names"
  type        = list(string)
  default     = ["user1-role", "user2-role", "user3-role", "user4-role"]
}
