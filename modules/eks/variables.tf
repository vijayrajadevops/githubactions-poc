variable "subnet_ids" {
  description = "List of subnet IDs to associate with the EKS cluster"
  type        = list(string)
}