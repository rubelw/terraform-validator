# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}

          


resource "aws_lambda_function" "AppendItemToListFunction" {
  filename         = "lambda_function_payload.zip"
  function_name    = "lambda_function_name"
  role             = "${aws_iam_role.LambdaExecutionRole.arn}"
  handler          = "index.handler"
  source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  runtime          = "nodejs8.10"

  environment {
    variables = {
      foo = "bar"
    }
  }
}


#{
#  "Resources" : {
#    "AppendItemToListFunction": {
#      "Type": "AWS::Lambda::Function",
#      "Properties": {
#        "Handler": "index.handler",
#        "Role": { "Fn::GetAtt" : ["LambdaExecutionRole", "Arn"] },
#        "Code": {
#          "ZipFile":  { "Fn::Join": ["", [
#            "var response = require('cfn-response');",
#            "exports.handler = function(event, context) {",
#            "   var responseData = {Value: event.ResourceProperties.List};",
#            "   responseData.Value.push(event.ResourceProperties.AppendedItem);",
#            "   response.send(event, context, response.SUCCESS, responseData);",
#            "};"
#          ]]}
#        },
#        "Runtime": "nodejs6.10"
#      }
#    },

resource "aws_lambda_permission" "lambdaPermission" {
  statement_id   = "AllowExecutionFromCloudWatch"
  action         = "lambda:InvokeFunction"
  function_name  = "${aws_lambda_function.test_lambda.function_name}"
  principal      = "*"
  source_arn     = "arn:aws:sns:us-east-1:806199016981:AmazonIpSpaceChanged"
}


#    "lambdaPermission": {
#      "Type": "AWS::Lambda::Permission",
#      "Properties": {
#        "Action": "lambda:InvokeFunction",
#        "FunctionName": {
#          "Ref": "AppendItemToListFunction"
#        },
#        "Principal": "*",
#        "SourceAccount": "806199016981",
#        "SourceArn": "arn:aws:sns:us-east-1:806199016981:AmazonIpSpaceChanged"
#      }
#    },

resource "aws_lambda_permission" "lambdaPermission2" {
  statement_id   = "AllowExecutionFromCloudWatch"
  action         = "lambda:InvokeFunction"
  function_name  = "${aws_lambda_function.test_lambda.function_name}"
  principal      = "555555555555"
  source_arn     = "arn:aws:sns:us-east-1:806199016981:AmazonIpSpaceChanged"
}


#    "lambdaPermission2": {
#      "Type": "AWS::Lambda::Permission",
#      "Properties": {
#        "Action": "lambda:InvokeFunction",
#        "FunctionName": {
#          "Ref": "AppendItemToListFunction"
#        },
#        "Principal": 555555555555,
#        "SourceAccount": "806199016981",
#        "SourceArn": "arn:aws:sns:us-east-1:806199016981:AmazonIpSpaceChanged"
#      }
#    },

resource "aws_iam_role" "LambdaExecutionRole" {
  name = "LambdaExecutionRole"
  path = '/'
  assume_role_policy = "${data.aws_iam_policy_document.example.json}"


data "aws_iam_policy_document" "example" {
  statement {
    effect = "allow"
    actions = [
      "logs:*",
    ],
    resources = [
     "arn:aws:logs:*:*:*"
    ]
  }
  statement {
    effect = "allow"
    actions = [
      "sts:AssumeRole",
    ],
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }

}


#    "LambdaExecutionRole": {
#      "Type": "AWS::IAM::Role",
#      "Properties": {
#        "AssumeRolePolicyDocument": {
#          "Version": "2012-10-17",
#          "Statement": [{ "Effect": "Allow", "Principal": {"Service": ["lambda.amazonaws.com"]}, "Action": ["sts:AssumeRole"] }]
#        },
#        "Path": "/",
#        "Policies": [{
#          "PolicyName": "root",
#          "PolicyDocument": {
#            "Version": "2012-10-17",
#            "Statement": [{ "Effect": "Allow", "Action": ["logs:*"], "Resource": "arn:aws:logs:*:*:*" }]
#          }
#        }]
#      }
#    }
#  }
#}