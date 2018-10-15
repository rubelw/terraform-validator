# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}


resource "aws_sqs_queue" "q" {
  name = "examplequeue"
}


resource "aws_sqs_queue" "q2" {
  name = "examplequeue"
}


resource "aws_sqs_queue_policy" "QueuePolicyWithNotAction" {
  queue_url = "${aws_sqs_queue.q.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": {"AWS":"arn:aws:iam::111111111111:user/will.rubel"},
      "NotAction": ["sqs:Break*"],
      "Resource": "*"
    }
  ]
}
POLICY
}

resource "aws_sqs_queue_policy" "QueuePolicyWithNotAction2" {
  queue_url = "${aws_sqs_queue.q2.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": {"AWS":"arn:aws:iam::111111111111:user/will.rubel"},
      "NotAction":  "sqs:Break*",
      "Resource": "*"
    }
  ]
}
POLICY
}

