provider "aws" {
  region = "us-east-2"
}

module "child_accounts" {
  source = "github.com/LikianS/Devopslab//DevOps/ch6/scripts/tofu/modules/aws-organization"

  # Set to false if you already enabled AWS Organizations in your account
  create_organization = true

  dev_account_email   = "killian.diboues+dev@gmail.com"
  stage_account_email = "killian.diboues+stage@gmail.com"
  prod_account_email  = "killian.diboues+prod@gmail.com"
}
