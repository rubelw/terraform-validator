# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}


resource "aws_sqs_queue" "queue1" {
  name = "queue1"
}

resource "aws_sqs_queue" "queue1b" {
  name = "queue1b"
}

resource "aws_sqs_queue" "queue1c" {
  name = "queue1c"
}

resource "aws_sqs_queue" "queue1d" {
  name = "queue1d"
}

resource "aws_sqs_queue" "queue2" {
  name = "queue2"
}

resource "aws_sqs_queue" "queue2b" {
  name = "queue2b"
}

resource "aws_sqs_queue" "queue2c" {
  name = "queue2c"
}



resource "aws_sqs_queue_policy" "mysqspolicy1" {
  queue_url = "${aws_sqs_queue.queue1.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "MyQueuePolicy",
      "Effect": "Allow",
      "Principal": {"AWS" : "arn:aws:iam::123123123123:user/some.user"},
      "Action": [ "sqs:*"],
      "Resource": "*"
    }
  ]
}
POLICY
}

resource "aws_sqs_queue_policy" "mysqspolicy1b" {
  queue_url = "${aws_sqs_queue.queue1b.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "Allow_user_SendMessage",
      "Effect": "Allow",
      "Principal": {"AWS" : "arn:aws:iam::123123123123:user/some.user"},
      "Action": [ "sqs:*"],
      "Resource": "*"
    }
  ]
}
POLICY
}


resource "aws_sqs_queue_policy" "mysqspolicy1c" {
  queue_url = "${aws_sqs_queue.queue1c.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "Allow_User_SendMessage",
      "Effect": "Allow",
      "Principal": {"AWS" : "arn:aws:iam::123123123123:user/some.user"},
      "Action": [ "*"],
      "Resource": "*"
    }
  ]
}
POLICY
}

resource "aws_sqs_queue_policy" "mysqspolicy1d" {
  queue_url = "${aws_sqs_queue.queue1d.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "Allow_User_SendMessage",
      "Effect": "Allow",
      "Principal": {"AWS" : "arn:aws:iam::123123123123:user/some.user"},
      "Action": [ "*"],
      "Resource": "*"
    }
  ]
}
POLICY
}


resource "aws_sqs_queue_policy" "mysqspolicy2" {
  queue_url = "${aws_sqs_queue.queue2.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "Allow_User_SendMessage",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "*"
    }
  ]
}
POLICY
}



resource "aws_sqs_queue_policy" "mysqspolicy2b" {
  queue_url = "${aws_sqs_queue.queue2b.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "Allow_User_SendMessage",
      "Effect": "Allow",
      "Principal": {"AWS":"*"},
      "Action": "sqs:SendMessage",
      "Resource": "*"
    }
  ]
}
POLICY
}

resource "aws_sqs_queue_policy" "mysqspolicy2c" {
  queue_url = "${aws_sqs_queue.queue2c.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "Allow_User_SendMessage",
      "Effect": "Allow",
      "Principal": {"AWS":"*"},
      "Action": "sqs:SendMessage",
      "Resource": "*"
    }
  ]
}
POLICY
}

