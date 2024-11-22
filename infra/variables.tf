variable "region" {
  description = "AWS region for the resources"
  default     = "eu-west-1"
}

variable "BUCKET_NAME" {
  description = "S3 bucket name for storing generated images"
  default     = "pgr301-couch-explorers"
}

variable "state_bucket" {
  description = "S3 bucket for storing Terraform state"
  default     = "pgr301-2024-terraform-state"
}

variable "s3_image_path_prefix" {
  description = "Prefix path for images in the S3 bucket"
  default     = "21/generated_images/"
}
