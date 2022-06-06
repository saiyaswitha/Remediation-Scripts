resource "aws_eks_cluster" "test" {
  name                      = var.cluster_name
  role_arn = aws_iam_role.test.arn
  depends_on = [aws_cloudwatch_log_group.test,aws_iam_role_policy_attachment.test-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.test-AmazonEKSVPCResourceController,]
  enabled_cluster_log_types = ["api", "audit"]
  vpc_config {
    subnet_ids = module.vpc.private_subnets
  }
}

 #IAM role creation for letting EKS to work under your behalf
resource "aws_iam_role" "test" {
  name = "eks-cluster-test"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "test-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.test.name
}
resource "aws_iam_role_policy_attachment" "test-AmazonEKSServiceRolePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServiceRolePolicy"
  role       = aws_iam_role.test.name
}

resource "aws_iam_role_policy_attachment" "test-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.test.name
}

resource "aws_cloudwatch_log_group" "test" {
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = 7
}