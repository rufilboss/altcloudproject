resource "aws_eks_cluster" "cluster" {
  name     = "my-k8s-cluster"
  role_arn = aws_iam_role.cluster.arn

  vpc_config {
    subnet_ids = aws_subnet.private.*.id
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks,
  ]
}
