provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "lambda-sns-buc" {
  bucket = "lambda-sns-buc"
}

resource "aws_s3_bucket_object" "lambda-sns-object" {
  bucket = aws_s3_bucket.lambda-sns-buc.id
  key    = "lambda/lambda_function.zip"
  source = "./lambda/lambda_function.zip"
  #etag   = filemd5("${path.module}/lambda/lambda_function.zip")

  provisioner "local-exec" {
    command = "md5sum ./lambda/lambda_function.py | cut -d ' ' -f 1 > lambda_md5.txt"
  }

  lifecycle {
    create_before_destroy = true
  }
} 

data "local_file" "lambda_md5" {
  filename = "lambda_md5.txt"

  depends_on = [aws_s3_bucket_object.lambda-sns-object]
}



resource "aws_sns_topic" "example_topic" {
  name = "example-topic"
}

resource "aws_sqs_queue" "example_queue" {
  name = "example-queue"
}

resource "aws_sns_topic_subscription" "example_subscription" {
  topic_arn = aws_sns_topic.example_topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.my_lambda.arn
}

resource "aws_lambda_function" "my_lambda" {
  function_name    = "my-lambda"
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.8"
  role             = aws_iam_role.lambda_role.arn
  filename         = aws_s3_bucket_object.lambda-sns-object.id
  source_code_hash = data.local_file.lambda_md5.content_base64sha256

  environment {
    variables = {
      KEY = "VALUE"
    }
  }

 # Add SNS topic as a destination
  destination_config {
    on_success {
      destination = aws_sns_topic.example_topic.arn
    }
    on_failure {
      destination = aws_sns_topic.example_topic.arn
    }
  }
}


resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

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
