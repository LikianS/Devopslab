provider "aws" {
  region = "us-east-2"
}

module "sample_app" {
  source = "github.com/LikianS/DevOps.git//td2/modules/ec2-instance"

  ami_id = "ami-003ec441a78bf4f52"
  name   = "sample-app-from-github"
}
