provider "aws" {
  region = var.aft_home_region
  assume_role {
    role_arn    = "arn:${var.aft_partion}:iam::${var.aft_management_account_id}:role/AWSAFTAdmin"
  }
  default_tags {
    tags = {
      managed_by = "AFT"
    }
  }
}