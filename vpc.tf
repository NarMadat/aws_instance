locals {
  aws = data.aws_availability_zones.available.names
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "custom-vpc-01" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "custom-vpc-01" 
  }
}

resource "aws_internet_gateway" "my_custom_igw" {
  vpc_id = aws_vpc.custom-vpc-01.id

  tags = {
    Name = "my_custom_igw"
  }
}

resource "aws_route_table" "my_custom_public_rt" {
  vpc_id = aws_vpc.custom-vpc-01.id

  tags = {
    Name = "my_custom_public_rt"
  }
}

resource "aws_route" "default_route" {
    route_table_id = aws_route_table.my_custom_public_rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_custom_igw.id
}

resource "aws_default_route_table" "my_custom_private_rt" {
  default_route_table_id = aws_vpc.custom-vpc-01.default_route_table_id

  tags = {
    Name = "my_custom_private_rt"
  }
}

resource "aws_subnet" "my_custom_pub_sub" {
  count = length(var.public_cidrs)
  vpc_id = aws_vpc.custom-vpc-01.id
  cidr_block = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone = local.aws[count.index]

  tags = {
    Name = "my_custom_pub_sub-${count.index + 1}"
  }
}

resource "aws_route_table_association" "my_custom_public_assoc" {
  count = length(var.public_cidrs)
  subnet_id = aws_subnet.my_custom_pub_sub[count.index].id
  route_table_id = aws_route_table.my_custom_public_rt.id
}

resource "aws_subnet" "my_custom_priv_sub" {
  count = length(var.private_cidrs)
  vpc_id = aws_vpc.custom-vpc-01.id
  cidr_block = var.private_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone = local.aws[count.index]

  tags = {
    Name = "my_custom_priv_sub-${count.index + 1}"
  }
}

resource "aws_security_group" "my_custom_sg" {
    name        = "public_SG"
    description = "Security group for public instances Allow TLS inbound traffic and all outbound traffic"
    vpc_id      = aws_vpc.custom-vpc-01.id

    tags = {
        Name = "Public_SG"
    }
}

resource "aws_security_group_rule" "allow_ingress_all" {
    type              = "ingress"
    from_port         = 0
    to_port           = 65535
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = aws_security_group.my_custom_sg.id
}

# outbound
resource "aws_security_group_rule" "allow_egress_all" {
    type              = "egress"
    from_port         = 0
    to_port           = 65535
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
    security_group_id = aws_security_group.my_custom_sg.id
}

resource "aws_key_pair" "deployer" {
  key_name = "deployer-key"
  public_key = file("./my_personal_key.pub")
}

resource "aws_instance" "my_custom_terraform" {
  count         = 1
  ami           = "ami-0e2c8caa4b6378d8c"
  key_name      = aws_key_pair.deployer.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_custom_pub_sub[count.index].id
  vpc_security_group_ids = [aws_security_group.my_custom_sg.id]

  tags = {
    Name = "MyCustomTerraformInstance"
  }
  root_block_device {
    volume_size = var.main_vol_size
  }

  provisioner "local-exec" {
    command = "echo '${self.public_ip}' >> aws_hosts" 
  }

  provisioner "local-exec" {
    when = destroy
    command = "sed -i '/^[0-9]/d' aws_hosts"
  }
}
