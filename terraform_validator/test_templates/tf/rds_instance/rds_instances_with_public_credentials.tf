# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}


resource "aws_db_instance" "default" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
}


#{
#  "Parameters": {
#    "DB1Username": {
#      "Type": "String",
#      "Default": "shameshame"
#    },
#    "DB1Password": {
#      "Type": "String",
#      "Default": "datpassword"
#    }
#  },
#  "Resources": {
#    "BadDb1": {
#      "Type": "AWS::RDS::DBInstance",
#      "Properties": {
#        "SourceDBInstanceIdentifier": "sampleDbInstance",
#        "MasterUsername": {
#          "Ref": "DB1Username"
#        },
#        "MasterUserPassword": {
#          "Ref": "DB1Password"
#        },
#        "PubliclyAccessible": false
#      }
#    },
#    "BadDb2": {
#      "Type": "AWS::RDS::DBInstance",
#      "Properties": {
#        "SourceDBInstanceIdentifier": "sampleDbInstance",
#        "MasterUsername": "one-master-to-rule-them-all",
#        "MasterUserPassword": "secret",
#        "PubliclyAccessible": false
#      }
#    }
#  }
#}