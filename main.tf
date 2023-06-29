provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-bucket"
}

resource "aws_s3_bucket_object" "example_object" {
  bucket = aws_s3_bucket.example_bucket.id
  key    = "lambda_function.py"
  source = "${path.module}/lambda/lambda_function.py"
  etag   = filemd5("${path.module}/lambda/lambda_function.py")
}

resource "aws_sns_topic" "example_topic" {
  name = "example-topic"
}

resource "aws_sqs_queue" "example_queue" {
  name = "example-queue"
}

resource "aws_sns_topic_subscription" "example_subscription" {
  topic_arn = aws_sns_topic.example_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.example_queue.arn
}

resource "aws_lambda_function" "example_lambda" {
  function_name    = "example-lambda"
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.8"
  role             = aws_iam_role.example_role.arn
  filename         = aws_s3_bucket_object.example_object.id
  source_code_hash = filebase64sha256("path/to/lambda_function.py")

  environment {
    variables = {
      KEY = "VALUE"
    }
  }
}

resource "aws_iam_role" "example_role" {
  name = "example-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
