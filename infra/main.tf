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
resource "aws_sqs_queue" "image_processing_queue_devops21" {
  name                        = "image-processing-queue-devops21"
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

# IAM Policy for Lambda tillatelser
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
        Resource = aws_sqs_queue.image_processing_queue_devops21.arn
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
  name              = "/aws/lambda/image-processor-devops21"
  retention_in_days = 14
}

# Lambda Function
resource "aws_lambda_function" "image_processor_devops21" {
  function_name = "image-processor-devops21"
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

  depends_on = [aws_cloudwatch_log_group.lambda_log_group]
}

# # Kobler SQS-Queuen til Lambda-funksjonen
resource "aws_lambda_event_source_mapping" "sqs_to_lambda" {
  event_source_arn = aws_sqs_queue.image_processing_queue_devops21.arn
  function_name    = aws_lambda_function.image_processor_devops21.arn
  batch_size       = 5
  enabled          = true
}

# CloudWatch-alarm for ApproximateAgeOfOldestMessage
resource "aws_cloudwatch_metric_alarm" "sqs_age_of_oldest_message" {
  alarm_name          = "SQS-AgeOfOldestMessage-High"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = 60 # Angir terskelen for alder (60 sekunder)
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  statistic           = "Maximum"
  period              = 60 # Kontrollerer hver 60 sekund
  alarm_description   = "Varsel: Den eldste meldingen i køen er eldre enn terskelen."

  # Refererer til SQS-køen
  dimensions = {
    QueueName = aws_sqs_queue.image_processing_queue_devops21.name
  }

  # Koble alarmen til SNS-topic
  alarm_actions = [aws_sns_topic.sqs_alerts_topic.arn]
}

# Oppretter SNS-topic for varsler
resource "aws_sns_topic" "sqs_alerts_topic" {
  name = "sqs-alerts-topic"
}

# Oppretter abonnement for e-post til SNS-topic
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.sqs_alerts_topic.arn
  protocol  = "email"
  endpoint  = var.alert_email
}
