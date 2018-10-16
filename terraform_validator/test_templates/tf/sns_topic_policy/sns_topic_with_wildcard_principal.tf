# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}


resource "aws_sns_topic" "MySNSTopic" {
  name = "MySNSTopic"
}

resource "aws_sns_topic_policy" "mysnspolicy0" {
  arn = "${aws_sns_topic.MySNSTopic.arn}"

  policy = "${data.aws_iam_policy_document.sns-topic-policy.json}"
}


data "aws_iam_policy_document" "sns-topic-policy" {
  policy_id = "MyTopicPolicy"

  statement {
    actions = [
      "SNS:Publish"
    ]
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      "*"
    ]

    sid = "MyTopicPolicy"
  }
}

data "aws_iam_policy_document" "sns-topic-policy" {
  policy_id = "MyTopicPolicy"

  statement {
    actions = [
      "SNS:Publish"
    ]
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      "*"
    ]

    sid = "MyTopicPolicy"
  }
}


resource "aws_sns_topic" "MySNSTopic2" {
  name = "MySNSTopic2"
}

resource "aws_sns_topic_policy" "mysnspolicy2" {
  arn = "${aws_sns_topic.MySNSTopic2.arn}"

  policy = "${data.aws_iam_policy_document.sns-topic-policy.json}"
}

data "aws_iam_policy_document" "sns-topic-policy" {
  policy_id = "MyTopicPolicy"

  statement {
    actions = [
      "SNS:Publish"
    ]
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      "*"
    ]

    sid = "MyTopicPolicy"
  }
}

data "aws_iam_policy_document" "sns-topic-policy" {
  policy_id = "MyTopicPolicy"

  statement {
    actions = [
      "SNS:Publish"
    ]
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      "*"
    ]

    sid = "MyTopicPolicy"
  }
}


