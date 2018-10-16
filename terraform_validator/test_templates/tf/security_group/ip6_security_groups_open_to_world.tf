# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}



resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = ["pl-12c4e678"]
  }
}
Basic usage with tags:

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "allow_all"
  }
}



#{
#   "Resources" : {
#      "InstanceSecurityGroup4" : {
#         "Properties" : {
#            "VpcId" : {
#               "Ref" : "VPC"
#            },
#            "SecurityGroupIngress" : [
#               {
#                  "FromPort" : "22",
#                  "CidrIpv6" : "2001:800::/21",
#                  "ToPort" : "22",
#                  "IpProtocol" : "tcp"
#               }
#            ],
#            "GroupDescription" : "InstanceSecurityGroup4"
#         },
#         "Type" : "AWS::EC2::SecurityGroup",
#         "DependsOn" : [
#            "Subnet"
#         ]
#      },
#      "RouteTable" : {
#         "Properties" : {
#            "VpcId" : {
#               "Ref" : "VPC"
#            }
#         },
#         "Type" : "AWS::EC2::RouteTable"
#      },
#      "SubnetIPv6" : {
#         "Type" : "AWS::EC2::SubnetCidrBlock",
#         "Properties" : {
#            "Ipv6CidrBlock" : {
#               "Fn::Join" : [
#                  "",
#                  [
#                    {
#                      "Fn::Select": [
#                        0,
#                        {
#                          "Fn::Split": [
#                            "::",
#                            {
#                              "Fn::Select": [
#                                0,
#                                {
#                                  "Fn::GetAtt": [
#                                    "VPC",
#                                    "Ipv6CidrBlocks"
#                                  ]
#                                }
#                              ]
#                            }
#                          ]
#                        }
#                      ]
#                    },
#                     "::dead:beef/64"
#                  ]
#               ]
#            },
#            "SubnetId" : {
#               "Ref" : "Subnet"
#            }
#         },
#         "DependsOn" : [
#            "VPC",
#            "VPCIPv6"
#         ]
#      },
#      "InstanceSecurityGroup3" : {
#         "Type" : "AWS::EC2::SecurityGroup",
#         "Properties" : {
#            "GroupDescription" : "InstanceSecurityGroup3",
#            "SecurityGroupIngress" : [
#               {
#                  "ToPort" : "22",
#                  "CidrIpv6" : "::/0",
#                  "FromPort" : "22",
#                  "IpProtocol" : "tcp"
#               }
#            ],
#            "VpcId" : {
#               "Ref" : "VPC"
#            }
#         },
#         "DependsOn" : [
#            "Subnet"
#         ]
#      },
#      "VPCIPv6" : {
#         "Properties" : {
#            "AmazonProvidedIpv6CidrBlock" : true,
#            "VpcId" : {
#               "Ref" : "VPC"
#            }
#         },
#         "Type" : "AWS::EC2::VPCCidrBlock"
#      },
#      "InstanceSecurityGroup" : {
#         "DependsOn" : [
#            "Subnet"
#         ],
#         "Type" : "AWS::EC2::SecurityGroup",
#         "Properties" : {
#            "VpcId" : {
#               "Ref" : "VPC"
#            },
#            "SecurityGroupIngress" : [
#               {
#                  "FromPort" : "22",
#                  "CidrIpv6" : "0000:0000:0000:0000:0000:0000:0000:0000/0",
#                  "ToPort" : "22",
#                  "IpProtocol" : "tcp"
#               }
#            ],
#            "GroupDescription" : "InstanceSecurityGroup"
#         }
#      },
#      "VPC" : {
#         "Properties" : {
#            "EnableDnsSupport" : true,
#            "Tags" : [
#               {
#                  "Value" : "IPv6",
#                  "Key" : "Name"
#               }
#            ],
#            "CidrBlock" : "10.0.0.0/16",
#            "InstanceTenancy" : "default",
#            "EnableDnsHostnames" : true
#         },
#         "Type" : "AWS::EC2::VPC"
#      },
#      "InstanceSecurityGroup2" : {
#         "Properties" : {
#            "VpcId" : {
#               "Ref" : "VPC"
#            },
#            "SecurityGroupIngress" : [
#               {
#                  "CidrIpv6" : "0000::/0",
#                  "FromPort" : "22",
#                  "ToPort" : "22",
#                  "IpProtocol" : "tcp"
#               }
#            ],
#            "GroupDescription" : "InstanceSecurityGroup2"
#         },
#         "Type" : "AWS::EC2::SecurityGroup",
#         "DependsOn" : [
#            "Subnet"
#         ]
#      },
#      "Subnet" : {
#         "Type" : "AWS::EC2::Subnet",
#         "Properties" : {
#            "CidrBlock" : "10.0.0.0/24",
#            "VpcId" : {
#               "Ref" : "VPC"
#            },
#            "MapPublicIpOnLaunch" : false
#         }
#      },
#      "RouteSubnet" : {
#         "DependsOn" : [
#            "RouteTable",
#            "Subnet"
#         ],
#         "Properties" : {
#            "SubnetId" : {
#               "Ref" : "Subnet"
#            },
#            "RouteTableId" : {
#               "Ref" : "RouteTable"
#            }
#         },
#         "Type" : "AWS::EC2::SubnetRouteTableAssociation"
#      }
#   }
#}
