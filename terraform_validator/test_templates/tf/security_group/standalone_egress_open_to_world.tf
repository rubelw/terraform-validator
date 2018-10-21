# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}


resource "aws_security_group_rule" "securityGroupEgress" {
  type            = "egress"
  from_port       = 45
  to_port         = 45
  protocol        = "tcp"
  cidr_blocks     = ["0.0.0.0/0"]

  security_group_id = "sg-12341234e"
}




#{
#  "Resources": {
#    "securityGroupEgress" : {
#      "Type" : "AWS::EC2::SecurityGroupEgress",
#      "Properties" : {
#        "GroupId": "sg-12341234",
#        "CidrIp" : "0.0.0.0/0",
#        "FromPort" : 45,
#        "ToPort" : 45,
#        "IpProtocol" : "tcp"
#      }
#    }
#  }
#}