variable "environment_name" {
  type  = string
}

variable "aws_region" {
  type  = string
}

/*variable "availability_zone" {
  type  = string
}*/

variable "iam_assume_role_arn" {
  type  = string
}

variable "subnet_ids" {
  type  = list
}

variable "security_group_ids" {
  type  = list(string)
}

# Tags should be added here #
variable "tags" {
  type  = map(string)
}

variable "common_tags" {
  type  = map(string)
}

variable "account_workspace" {
  type = string
}

/* service control policy tags */
variable "scp_tags" {
  type = map(string)
}

/* AMI Type for node group */
variable "ami_type" {
  type = string
}

# EKS Latest version should be added here#
variable "eks_version" {
  type = string
}

variable "eks_cluster_name" {
  type = string
}

# Account ID should be added here#
variable "eks_cluster_role" {
  type = string
}

variable "node_role_arn" {
  type = string
}

variable "devops_role_arn" {
  type = string
}

variable "dev_role_arn" {
  type = string
}

variable "ccoe_role_arn" {
  type = string
}

variable "node_group_tags" {
  type = map(string)
}

/* variable "launch_template_name" {
  type = string
} */

/* variable "image_id" {
  type = string
}
 */

 variable "NodeDetails" {
  description = "Map of micro services to EKS node group."
  type        = map(any)
}
  

/* The NodeCustomerMap to be configured based on the micro services to be deployed for the customer.
   For optional components, mark them as false. Eg - "NodeGroup, defaut" = false 
*/
variable "NodeCustomerMap" {
  type = map(any)
}



