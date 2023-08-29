output "endpoint" {
  value = aws_eks_cluster.eks-test.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.eks-test.certificate_authority[0].data
}