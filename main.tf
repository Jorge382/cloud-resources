data "aws_iam_policy_document" "example" {
  statement {
    sid    = "new policy"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:sts::248189943700:assumed-role/AWSReservedSSO_EKS-alumnos_a4561514b13725b0/jorge.vidal@campusdual.com"]
    }

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:DeleteRepository",
      "ecr:BatchDeleteImage",
      "ecr:SetRepositoryPolicy",
      "ecr:DeleteRepositoryPolicy",
    ]
  }
}

module "ecr" {
  source = "/home/jorge/Documentos/Bootcamp/Personal/cloud-resources/modulo_ecr/"
  repository_name  = "my-ecr-repo-jvs"
  policy_document = data.aws_iam_policy_document.example.json 
}

module "eks_managed_node_groups" {
    module_path = "./modules"
    source = "/home/jorge/Documentos/Bootcamp/Personal/cloud-resources/modulo_eks/"
    instance_type = "t3.small"  # Define el tipo de instancia EC2 (ejemplo)
    tag_value = "jvs"  # El valor del tag para el recurso
    vpc_id     = "vpc-002427d5be38383d7"
    subnets = ["subnet-0c74de2d5b377a9e7", "subnet-0ba9c83b2abfca63b", "subnet-01aa073f6dedf4aae"]
}