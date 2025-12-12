provider "aws" {
  region = "us-east-2"
}

module "function" {
  # Lien mis à jour vers VOTRE module lambda
  source = "github.com/LikianS/Devopslab//DevOps/ch3/scripts/tofu/modules/lambda"

  name = var.name

  src_dir = "${path.module}/src"
  runtime = "nodejs20.x"
  handler = "index.handler"

  memory_size = 128
  timeout     = 5

  environment_variables = {
    NODE_ENV = "production"
  }
}

module "gateway" {
  # Lien mis à jour vers VOTRE module api-gateway
  source = "github.com/LikianS/Devopslab//DevOps/ch3/scripts/tofu/modules/api-gateway"

  name = var.name
  function_arn       = module.function.function_arn
  api_gateway_routes = ["GET /"]
}
