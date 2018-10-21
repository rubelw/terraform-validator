# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}

          
resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "test_lambda" {
  filename         = "lambda_function_payload.zip"
  function_name    = "lambda_function_name"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "exports.test"
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

#    "lambdaPermissionDeleteAlias": {
#      "Type": "AWS::Lambda::Permission",
#      "Properties": {
#        "Action": "lambda:DeleteAlias",
#        "FunctionName": {
#          "Ref": "AppendItemToListFunction"
#        },
#        "Principal": "*",
#        "SourceAccount": "806199016981",
#        "SourceArn": "arn:aws:sns:us-east-1:806199016981:AmazonIpSpaceChanged"
#      }
#    },

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