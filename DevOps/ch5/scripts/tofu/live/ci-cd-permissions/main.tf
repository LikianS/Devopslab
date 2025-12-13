provider "aws" {
  region = "us-east-2"
}

module "oidc_provider" {
  # Lien mis à jour vers VOTRE module oidc
  source = "../../modules/github-aws-oidc"

  provider_url = "https://token.actions.githubusercontent.com"
}

module "iam_roles" {
  # Lien mis à jour vers VOTRE module iam-roles
  source = "../../modules/gh-actions-iam-roles"

  name              = "lambda-sample"
  oidc_provider_arn = module.oidc_provider.oidc_provider_arn

  enable_iam_role_for_testing = true
  enable_iam_role_for_plan    = true
  enable_iam_role_for_apply   = true

  # --- MODIFICATION IMPORTANTE ICI ---
  # J'ai remplacé "brikis98/..." par votre repo "LikianS/Devopslab"
  github_repo      = "LikianS/Devopslab"
  
  lambda_base_name = "lambda-sample"

  # TODO: Attention ! Vous devez mettre ICI les noms uniques de VOTRE bucket et table
  # (ceux que vous avez créés dans le dossier tofu-state)
  tofu_state_bucket         = "devopslab-likian-state" 
  tofu_state_dynamodb_table = "devopslab-likian-state" 
}
