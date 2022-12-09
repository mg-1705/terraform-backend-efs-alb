terraform {
  backend "s3"{
    bucket = "madhuryt-17839backend"
    key = "terraform.tfstate"
    region = "us-east-2"
    access_key="AKIAQTO6MJDC3Z4KYCNS"
    secret_key="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"
  }
}
