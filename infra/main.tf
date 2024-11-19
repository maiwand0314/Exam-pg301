terraform {
  required_version = ">= 1.9.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.74.0"
    }
  }
  backend "s3" {
    bucket         = "pgr301-2024-terraform-state"
    key            = "terraform/state"
    region         = "eu-west-1"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}

# SQS Queue
resource "aws_sqs_queue" "image_processing_queue" {
  name                        = "image-processing-queue"
  visibility_timeout_seconds  = 30
  message_retention_seconds   = 86400
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda-sqs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Policy for Lambda Permissions
resource "aws_iam_role_policy" "sqs_lambda_policy" {
  name   = "sqs_lambda_policy"
  role   = aws_iam_role.lambda_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Resource = aws_sqs_queue.image_processing_queue.arn
      },
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.BUCKET_NAME}",
          "arn:aws:s3:::${var.BUCKET_NAME}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "bedrock:InvokeModel"
        ]
        Resource = "*"
      }
    ]
  })
}

# CloudWatch Log Group for Lambda
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/image-processor"
  retention_in_days = 14
}

# Lambda Function
resource "aws_lambda_function" "image_processor" {
  function_name = "image-processor"
  filename      = "lambda_sqs.zip"
  handler       = "lambda_sqs.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_role.arn
  timeout       = 15

  environment {
    variables = {
      BUCKET_NAME          = var.BUCKET_NAME
      S3_IMAGE_PATH_PREFIX = var.s3_image_path_prefix
      BEDROCK_REGION       = "us-east-1"
      MODEL_ID             = "amazon.titan-image-generator-v1"
    }
  }

  source_code_hash = filebase64sha256("lambda_sqs.zip")

  # Ensure CloudWatch Log Group is created first
  depends_on = [aws_cloudwatch_log_group.lambda_log_group]
}

# Lambda Event Source Mapping for SQS
resource "aws_lambda_event_source_mapping" "sqs_to_lambda" {
  event_source_arn = aws_sqs_queue.image_processing_queue.arn
  function_name    = aws_lambda_function.image_processor.arn
  batch_size       = 5
  enabled          = true
}
