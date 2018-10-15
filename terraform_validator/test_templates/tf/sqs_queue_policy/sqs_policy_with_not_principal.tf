# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}


resource "aws_sqs_queue" "queue1" {
  name = "examplequeue"
}

resource "aws_sqs_queue_policy" "test" {
  queue_url = "${aws_sqs_queue.q.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "NotPrincipal": {"AWS":"arn:aws:iam::111111111111:user/will.rubel"},
      "Action": "sqs:SendMessage",
      "Resource": "*"
    }
  ]
}
POLICY
}

