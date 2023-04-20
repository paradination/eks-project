# Region and Profile Information
aws_region = "us-east-1"
aws_profile = "default"


# VPC and Networking Information
vpc_id =  aws_vpc.main-vpc.id
control_plane_subnet_ids =  [aws_subnet.main-subnet[0].id , aws_subnet.main-subnet[2].id] #Public Subnetids
subnet_ids =  [aws_subnet.main-subnet[1].id, aws_subnet.main-subnet[3].id] #Private Subnet IDS


# EKS Cluster Information
cluster_name = "eks-demo"
cluster_version = "1.23"
cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
cluster_endpoint_private_access = "true"
cluster_endpoint_public_access = "true"


eks_managed_node_groups = {
   green = {
      min_size     = 1
      max_size     = 10
      desired_size = 1

      instance_types = ["t2.large"]
      capacity_type  = "ON_DEMAND"
    }
 }
