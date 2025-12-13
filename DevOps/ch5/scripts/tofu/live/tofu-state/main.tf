provider "aws" {
  region = "us-east-2"
}

module "state" {
  source = "../../modules/state-bucket"

  # TODO: fill in your own bucket name!
  name = "devopslab-likian-state"
}
