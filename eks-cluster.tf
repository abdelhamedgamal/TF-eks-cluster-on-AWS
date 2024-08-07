provider "kubernetes" {
  host = data.aws_eks_cluster.myapp_cluster.endpoint
  token = data.aws_eks_cluster_auth.myapp_cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.myapp_cluster.certificate_authority.0.data)
}
data "aws_eks_cluster" "myapp_cluster" {
  name = module.eks.cluster_id
}
data "aws_eks_cluster_auth" "myapp_cluster" {
  name = module.eks.cluster_id
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "myapp-eks-cluster"
  cluster_version = "1.30"
  subnet_ids      = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id
  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  }
  eks_managed_node_groups = {
    example = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t2.small"]
      min_size     = 3
      max_size     = 6
      desired_size = 3
    }
  }
  cluster_endpoint_public_access  = true
  enable_cluster_creator_admin_permissions = true

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

 # control_plane_subnet_ids = ["subnet-xyzde987", "subnet-slkjf456", "subnet-qeiru789"]

  # Cluster access entry
  # To add the current caller identity as an administrator

  #access_entries = {
    # One access entry with a policy associated
   # example = {
    #  kubernetes_groups = []
     # principal_arn     = "arn:aws:iam::123456789012:role/something"

      #policy_associations = {
       # example = {
        #  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
         # access_scope = {
          #  namespaces = ["default"]
           # type       = "namespace"
         # }
       # }
      #}
    #}
  #}

  tags = {
    Environment = "devolopment"
    application   = "myapp"
  }
}