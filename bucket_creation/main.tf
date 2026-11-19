provider "aws"{

}

resource "aws_s3_bucket" "s3_backend" {

    bucket = "s3-statefile-test-terraform"
    region="us-east-1"
  
}