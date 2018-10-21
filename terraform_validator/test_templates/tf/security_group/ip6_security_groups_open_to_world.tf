# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = false
  tags {
    Name = "Main"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "main"
  }
}

resource "aws_route_table" "r" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "10.0.1.0/24"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
  tags {
    Name = "main"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = "${aws_subnet.main.id}"
  route_table_id = "${aws_route_table.r.id}"
}

resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "172.2.0.0/16"
}

resource "aws_security_group" "InstanceSecurityGroup4" {
  name        = "InstanceSecurityGroup4"
  description = "InstanceSecurityGroup4"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


}


resource "aws_security_group" "InstanceSecurityGroup3" {
  name        = "InstanceSecurityGroup3"
  description = "InstanceSecurityGroup3"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


}

resource "aws_security_group" "InstanceSecurityGroup2" {
  name        = "InstanceSecurityGroup2"
  description = "InstanceSecurityGroup2"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


}

resource "aws_security_group" "InstanceSecurityGroup" {
  name        = "InstanceSecurityGroup"
  description = "InstanceSecurityGroup"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
