output "endpoint" {
  value = aws_eks_cluster.ModMed.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.ModMed.certificate_authority[0].data
}