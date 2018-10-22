# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}


resource "aws_db_instance" "PublicDB" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "sampleDbInstance"
  parameter_group_name = "default.mysql5.7"
  publicly_accessible = false

  tags {
    Name        = "ResourceOwner"
    Environment = "resourceowner"
  }
  tags {
    Name        = "DeployedBy"
    Environment = "deployedby"
  }
  tags {
    Name        = "Name"
    Environment = "name"
  }
  tags {
    Name        = "Project"
    Environment = "project"
  }
}


#{
#  "Resources": {
#    "PublicDB": {
#      "Type": "AWS::RDS::DBInstance",
#      "Properties": {
#        "SourceDBInstanceIdentifier": "sampleDbInstance",
#        "PubliclyAccessible": false,
#        "Tags" : [
#          {
#            "Key" : "ResourceOwner",
#            "Value" : "resourceowner"
#          },
#          {
#            "Key" : "DeployedBy",
#            "Value" : "deployedby"
#          },
#          {
#            "Key" : "Name",
#            "Value" : "name"
#          },
#          {
#            "Key" : "Project",
#            "Value" : "project"
#          }
#        ]
#      }
#    }
#  }
#}
