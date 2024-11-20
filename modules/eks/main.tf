resource "aws_eks_cluster" "ModMed" {
  name     = "EKS-cluster-ModMed"
  role_arn = aws_iam_role.ModMed.arn

  vpc_config {
    subnet_ids = var.subnet_ids  
  }

  
  depends_on = [
    aws_iam_role_policy_attachment.ModMed-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.ModMed-AmazonEKSVPCResourceController,
  ]
}

#IAM ROLE code 
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ModMed" {
  name               = "eks-cluster-role-ModMed"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "ModMed-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.ModMed.name
}

# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "ModMed-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.ModMed.name
}

resource "aws_eks_node_group" "ModMed" {
  cluster_name    = aws_eks_cluster.ModMed.name
  node_group_name = "Node_group_ModMed"
  node_role_arn   = aws_iam_role.ModMed.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.ModMed-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.ModMed-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.ModMed-AmazonEC2ContainerRegistryReadOnly,
  ]

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}

resource "aws_iam_role" "ModMed_node_group_rule" {
  name = "eks-node-group-ModMed"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "ModMed-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.ModMed.name
}

resource "aws_iam_role_policy_attachment" "ModMed-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.ModMed.name
}

resource "aws_iam_role_policy_attachment" "ModMed-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.ModMed.name
}