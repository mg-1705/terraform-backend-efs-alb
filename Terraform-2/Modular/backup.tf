terraform {
  backend "s3"{
    bucket = "madhuryt-17839backend"
    key = "terraform.tfstate"
    region = "us-east-2"
    access_key=""
    secret_key=""
  }
}
