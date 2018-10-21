# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}




resource "aws_security_group_rule" "securityGroupIngress" {
  type            = "ingress"
  from_port       = 46
  to_port         = 46
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "sg-12341234"
}

#{
#  "Resources": {
#    "securityGroupIngress" : {
#      "Type" : "AWS::EC2::SecurityGroupIngress",
#      "Properties" : {
#        "GroupId": "sg-12341234",
#        "CidrIp" : "0.0.0.0/0",
#        "FromPort" : 46,
#        "ToPort" : 46,
#        "IpProtocol" : "tcp"
#      }
#    }
#  }
#}