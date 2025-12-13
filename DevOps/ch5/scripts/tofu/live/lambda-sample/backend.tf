terraform {
  backend "s3" {
    bucket = "devopslab-likian-state" # Replace
    key = "td5/scripts/tofu/live/lambda-sample"
    region = "us-east-2" # Your AWS region
    encrypt = true
    dynamodb_table = "devopslab-likian-state" # Replace
  }
}
