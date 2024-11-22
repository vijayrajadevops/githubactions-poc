variable "datadog_secret_name" {
  type        = string
  description = "Name of the secret that has Datadog credentials. null for no datadog deployment"
  default     = null
}

variable "eks_cluster_name" {
  type        = string
  description = "Name of the eks cluster"
  default     = null
}