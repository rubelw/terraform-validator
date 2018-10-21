# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}

          
# Create a new load balancer
resource "aws_elb" "bar" {
  name               = "foobar-terraform-elb"
  availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]

  access_logs {
    bucket        = "foo"
    bucket_prefix = "bar"
    interval      = 60
  }

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port      = 8000
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/certName"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }

  instances                   = ["${aws_instance.foo.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name = "foobar-terraform-elb"
  }
}



#{
#  "Resources": {
#    "elb1": {
#      "Type" : "AWS::ElasticLoadBalancing::LoadBalancer",
#      "Properties" : {
#        "AvailabilityZones" : [
#          "eu-west-1a"
#        ],
#        "Listeners" : [
#          {
#            "LoadBalancerPort" : "80",
#            "InstancePort" : "80",
#            "Protocol" : "HTTP"
#          }
#        ]
#      }
#    },
#    "elb2": {
#      "Type" : "AWS::ElasticLoadBalancing::LoadBalancer",
#      "DependsOn": "S3BucketPolicy",

#      "Properties" : {
#        "AccessLoggingPolicy": {
#          "Enabled": false,
#          "S3BucketName": "fakebucketfakebucket"
#        },
#        "AvailabilityZones" : [
#          "eu-west-1a"
#        ],
#        "Listeners" : [
#          {
#            "LoadBalancerPort" : "80",
#            "InstancePort" : "80",
#            "Protocol" : "HTTP"
#          }
#        ]
#      }
#    },
#    "elb3": {
#      "Type" : "AWS::ElasticLoadBalancing::LoadBalancer",
#      "DependsOn": "S3BucketPolicy",
#      "Properties" : {
#        "AccessLoggingPolicy": {
#          "Enabled": true,
#          "S3BucketName": "fakebucketfakebucket",
#          "S3BucketPrefix": "prefix"
#        },
#        "AvailabilityZones" : [
#          "eu-west-1a"
#        ],
#        "Listeners" : [
#          {
#            "LoadBalancerPort" : "80",
#            "InstancePort" : "80",
#            "Protocol" : "HTTP"
#          }
#        ]
#      }
#    },
#    "S3Bucket" : {
#      "Type" : "AWS::S3::Bucket",
#      "Properties" : {
#        "BucketName" : "fakebucketfakebucket"
#      }
#    },

#    "S3BucketPolicy": {
#      "Type": "AWS::S3::BucketPolicy",
#      "Properties": {
#        "Bucket": {
#          "Ref": "S3Bucket"
#        },
#        "PolicyDocument": {
#          "Id": "Policy1429136655940",
#          "Version": "2012-10-17",
#          "Statement": [
#            {
#              "Sid": "Stmt1429136633762",
#              "Action": [
#                "s3:PutObject"
#              ],
#              "Effect": "Allow",
#              "Resource": "arn:aws:s3:::fakebucketfakebucket/prefix/AWSLogs/111111111111/*",
#              "Principal": {
#                "AWS": [
#                  "156460612806"
#                ]
#              }
#            }
#          ]
#        }
#      }
#    }
#  }
#}