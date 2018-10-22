# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}

variable "DB1Username" {
  type = "string"
  default = "shameshame"

}

variable "DB1Password" {
  type = "string"
  default = "datpassword"

}
resource "aws_db_instance" "BadDb1" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "sampleDbInstance"
  username             = "${var.DB1Username}"
  password             = "${var.DB1Password}"
  parameter_group_name = "default.mysql5.7",
  publicly_accessible = false
}

resource "aws_db_instance" "BadDb2" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "sampleDbInstance"
  username             = "one-master-to-rule-them-all"
  password             = "secret"
  parameter_group_name = "default.mysql5.7",
  publicly_accessible = false
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