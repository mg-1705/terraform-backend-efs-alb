terraform {
  backend "s3"{
    bucket = "madhuryt-17839backend"
    key = "terraform.tfstate"
    region = "us-east-2"
  }
}