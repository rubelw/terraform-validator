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
  parameter_group_name = "default.mysql5.7",
  publicly_accessible = false
}



#{
#  "Resources": {
#    "PublicDB": {
#      "Type": "AWS::RDS::DBInstance",
#      "Properties": {
#        "SourceDBInstanceIdentifier": "sampleDbInstance",
#        "PubliclyAccessible": false
#      }
#    }
#  }
#}
