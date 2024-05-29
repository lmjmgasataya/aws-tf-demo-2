## Create VPC, subnet, IGW
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "demo_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "demo vpc"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "demo_public_subnet" {
  vpc_id     = aws_vpc.demo_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "demo public subnet"
  }
}

resource "aws_subnet" "demo_private_subnet" {
  vpc_id     = aws_vpc.demo_vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "demo private subnet"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "demo_igw" {
  vpc_id = aws_vpc.demo_vpc.id

  tags = {
    Name = "demo igw"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "demo_public_rt" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_igw.id
  }

  tags = {
    Name = "demo public route table"
  }
}

resource "aws_route_table" "demo_private_rt" {
  vpc_id = aws_vpc.demo_vpc.id

  tags = {
    Name = "demo private route table"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "demo_public_rta" {
  subnet_id      = aws_subnet.demo_public_subnet.id
  route_table_id = aws_route_table.demo_public_rt.id
}

resource "aws_route_table_association" "demo_private_rta" {
  subnet_id      = aws_subnet.demo_private_subnet.id
  route_table_id = aws_route_table.demo_private_rt.id
}

## Create IAM role, S3
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
resource "aws_iam_role" "demo_role" {
  name = "demo_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy
resource "aws_iam_role_policy" "demo_policy" {
  name = "demo_policy"
  role = aws_iam_role.demo_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
        ]
        Effect = "Allow"
        # Resource = "*"
        Resource = "${aws_s3_bucket.demo_bucket.arn}/*"
      },
    ]
  })
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "demo_bucket" {
  bucket = "demo-bucket-lm"

  tags = {
    Name = "Demo bucket LM"
  }
}

## Create EC2
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["amazon"] # Canonical
# }

resource "aws_instance" "demo_instance" {
  # ami                  = data.aws_ami.ubuntu.id
  # https://cloud-images.ubuntu.com/locator/ec2/
  ami                    = "ami-0b1d56f717447bdcf"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.demo_private_subnet.id
  iam_instance_profile   = aws_iam_instance_profile.demo_instance_profile.name
  vpc_security_group_ids = ["${aws_security_group.demo_security_group.id}"]

  tags = {
    Name = "Demo Instance"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile
resource "aws_iam_instance_profile" "demo_instance_profile" {
  name = "demo_instance_profile"
  role = aws_iam_role.demo_role.name
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "demo_security_group" {
  name        = "demo_security_group"
  description = "Demo security group"
  vpc_id      = aws_vpc.demo_vpc.id

  tags = {
    Name = "demo_security_group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.demo_security_group.id
  cidr_ipv4         = aws_vpc.demo_vpc.cidr_block
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.demo_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
