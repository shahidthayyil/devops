aws_region        = "ap-south-1"

/* Account workspace should be the name space of the EKS cluster and Environment Name should be the name of the Environment 
*/
account_workspace = "iFlyDevOpsCluster"
environment_name  = "iflydevopscluster"
eks_cluster_name = "iLoyal-EKS-iFlyDevOpsCluster"
eks_cluster_role = "arn:aws:iam::861764844105:role/IBS_eks_cluster_Role"
eks_version = "1.30"
/*AMI Type (Change based on x86/arm (AL2_x86_64,AL2_ARM_64))*/
ami_type = "AL2_ARM_64"
iam_assume_role_arn = "arn:aws:iam::861764844105:role/IBS_LOB_Assume_Role"
subnet_ids          = ["subnet-03d5e1dc3b853e680","subnet-0246a1fd6a349f318"]
security_group_ids  = ["sg-03f78a78057ae203e"]
availability_zone     = "ap-south-1a"
common_tags           = {"product"="iLoyal 5.x"}
/* EKS Cluster Name should be used */
eks_tags = {
  "Name" = "iLoyal-EKS-iFlyDevOpsCluster"
}
scp_tags = {
  "Environment" = "IT-DEV",
  "CostCenter" = "iFlyLoyalty",
  "Project" = "DevShared",
  "Owner" = "Dev",
  "CostType" = "iFlyLoyalty-Opex"
}
tags = {
  "Name" = "iLoyal-EKS-iFlyDevOpsCluster"
  "Environment" = "IT-DEV",
  "CostCenter" = "iFlyLoyalty",
  "Project" = "DevShared",
  "Owner" = "Dev",
  "CostType" = "iFlyLoyalty-Opex"
}
key_name = "iflyloyalty-mumbai-rnd"
node_role_arn = "arn:aws:iam::861764844105:role/IBS_eks_node_group_Role"
devops_role_arn = "arn:aws:iam::861764844105:role/IBS_IT_DevOps_Role"
dev_role_arn = "arn:aws:iam::861764844105:role/AWSReservedSSO_IT_DEV_AWS_Access_6d2ffdc9c0e4cc27"
ccoe_role_arn = "arn:aws:iam::861764844105:role/AWSReservedSSO_IT_CCOE_AWS_Access_fc14bdf1b5173589"

node_group_tags = {
  "kubernetes.io/cluster/iLoyal-EKS-iFlyDevOpsCluster"     = "owned",
  "k8s.io/cluster-autoscaler/iLoyal-EKS-iFlyDevOpsCluster" = "owned",
  "k8s.io/cluster-autoscaler/enabled"         = "TRUE"
}
NodeDetails = {
    cluster-nodegroup = {
      node_group_name = "iloyal-cluster"
            capacity_type   = "ON_DEMAND"
            instance_types  = ["t4g.xlarge"]
            desired_size    = 1
            max_size        = 2
            min_size        = 1
            labels = {
                service     = "iloyal-cluster"
            }
    },
}

/* The NodeCustomerMap to be configured based on the micro services to be deployed for the customer.
   For optional components, mark them as false. Eg - "NodeGroup1" = false 
*/
NodeCustomerMap = {"cluster-nodegroup" = true,
"demo"= false}

#/* Launch Template For Node Groups Configurations */
#launch_template_name  = "NotRequired"
#image_id              = "NotRequired"