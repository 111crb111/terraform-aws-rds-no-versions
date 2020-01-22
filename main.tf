provider "aws" {
  alias  = "primary"
  region = var.primary_region

  
}

provider "aws" {
  alias  = "secondary"
  region = var.secondary_region

  
}

resource "aws_rds_global_cluster" "example" {
 provider = "aws.primary"

  global_cluster_identifier = "example"
}

############################################################################################

resource "aws_rds_cluster" "primary" {
  provider = "aws.primary"

  engine_mode               = "serverless"
 # global_cluster_identifier = aws_rds_global_cluster.example.id
}

resource "aws_rds_cluster_instance" "primary" {
  provider = "aws.primary"

  cluster_identifier = aws_rds_cluster.primary.id
  instance_class = var.aurora_instance_class
  engine = "aurora"
}

############################################################################################

resource "aws_rds_cluster" "secondary" {
  depends_on = ["aws_rds_cluster_instance.primary"]
  provider   = "aws.secondary"

  engine_mode               = "serverless"
  global_cluster_identifier = aws_rds_global_cluster.example.id
}

resource "aws_rds_cluster_instance" "secondary" {
 provider = "aws.secondary"

  cluster_identifier = aws_rds_cluster.secondary.id
  instance_class = var.aurora_instance_class
  engine = "aurora"
}
