# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}


resource "aws_sns_topic" "MySNSTopic" {
  name = "MySNSTopic"
}

resource "aws_sns_topic_policy" "default" {
  arn = "${aws_sns_topic.MySNSTopic.arn}"

  policy = "${data.aws_iam_policy_document.sns-topic-policy.json}"
}

data "aws_iam_policy_document" "mysnspolicyA" {
  policy_id = "MyTopicPolicy"

  statement {
    actions = [
      "SNS:Publish"
    ]

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::111111111111:user/will.rubel"]
    }

    resources = [
      "${aws_sns_topic.MySNSTopic.arn}",
    ]

    sid = "MyTopicPolicy"
  }
}
