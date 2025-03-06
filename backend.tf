terraform {
  backend "s3" {
    bucket = "anirban-iac-lab-tfstate"
    key    = "terraform/terraform.tfstate"
    region = "ap-south-1"

    dynamodb_table = "anirban_terraform-state-lock"
    encrypt        = true
    profile = "PowerUserPlusRole-160071257600"
  }
}