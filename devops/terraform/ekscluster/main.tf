provider "aws" {
  region     = var.aws_region
  assume_role {
	  role_arn    = var.iam_assume_role_arn
  }
}

/***************Cluster Creation********************/
resource "aws_eks_cluster" "eks-cluster" {
  name     = var.eks_cluster_name
  role_arn = var.eks_cluster_role
  version = var.eks_version

  vpc_config {
    subnet_ids              = var.subnet_ids
    security_group_ids      = var.security_group_ids
    endpoint_private_access = true
    endpoint_public_access  = false
  }
  
  tags = var.tags
}

/***************Node Creation********************/
resource "aws_eks_node_group" "eks-node-group" {
  # for_each        = var.NodeDetails
  for_each = {
    for key, value in var.NodeDetails : key => value
    if lookup(var.NodeCustomerMap, key)
  }
  cluster_name    = var.eks_cluster_name
  node_group_name = "${var.environment_name}-${each.value.node_group_name}"
  node_role_arn   = var.node_role_arn
  subnet_ids     = var.subnet_ids
  labels         = merge(each.value.labels, { "namespace" = var.environment_name })
  instance_types = each.value.instance_types
  capacity_type  = each.value.capacity_type
  ami_type       = var.ami_type
  version        = var.eks_version

  tags = merge(var.node_group_tags,
    { "Name" = "${var.environment_name}-EKS-Node-Group" },
    var.scp_tags
  )
  scaling_config {
    desired_size = each.value.desired_size
    max_size     = each.value.max_size
    min_size     = each.value.min_size
  }

  update_config {
    #    max_unavailable = 1
    max_unavailable_percentage = 30
  }

  depends_on = [aws_eks_cluster.eks-cluster]

}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = var.eks_cluster_name
}

provider "kubernetes" {
  host                   = aws_eks_cluster.eks-cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks-cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
}

resource "kubernetes_config_map_v1_data" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
  data = {
    mapRoles = yamlencode([
      {
        groups   = ["system:bootstrappers", "system:nodes"]
        rolearn  = replace(var.node_role_arn, replace("/", "/^//", ""), "")
        username = "system:node:{{EC2PrivateDNSName}}"
      },
      {
        "groups": ["system:masters"], 
        "rolearn": replace(var.devops_role_arn, replace("/", "/^//", ""), "")
        "username": "{{Sessionname}}" 
      },
      {
        "groups": ["system:masters"], 
        "rolearn": replace(var.dev_role_arn, replace("/", "/^//", ""), "")
        "username": "dev-user" 
      },
      {
        "groups": ["system:masters"], 
        "rolearn": replace(var.ccoe_role_arn, replace("/", "/^//", ""), "")
        "username": "ccoe-user" 
      }])
  }
  force = true
  depends_on = [aws_eks_node_group.eks-node-group]
}

# S3 Bucket Name of state file, Region, Workspace, Environment & Project Needs to be updated in environment variables
terraform {
  backend "s3" {
	region		= "ap-south-1"
    bucket      = "iflyloyatlys3"
    key         = "terraform.tfstate"
	workspace_key_prefix = "iLoyalTFState/EKS/Cluster"
  }
}
