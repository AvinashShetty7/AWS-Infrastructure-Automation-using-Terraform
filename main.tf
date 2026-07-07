

resource "aws_vpc" "mydemovpc" {
  cidr_block       = var.vpc_range
  instance_tenancy = "default"

  tags = {
    Name = "mydemovpc"
  }
}

resource "aws_subnet" "publicsubnet1" {
  vpc_id     = aws_vpc.mydemovpc.id
  cidr_block = var.cidr_public1
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "publicsubnet1"
  }
}

resource "aws_subnet" "publicsubnet2" {
  vpc_id     = aws_vpc.mydemovpc.id
  cidr_block = var.cidr_public2
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "publicsubnet2"
  }
}

resource "aws_subnet" "privatesubnet1" {
  vpc_id     = aws_vpc.mydemovpc.id
  cidr_block = var.cidr_private1
  availability_zone = "ap-south-1a"

  tags = {
    Name = "privatesubnet1"
  }
}

resource "aws_subnet" "privatesubnet2" {
  vpc_id     = aws_vpc.mydemovpc.id
  cidr_block = var.cidr_private2
  availability_zone = "ap-south-1b"

  tags = {
    Name = "privatesubnet2"
  }
}

# ----------- ELASTIC IP-------------------

resource "aws_eip" "eipfornat1" {
  domain   = "vpc"
}

resource "aws_eip" "eipfornat2" {
  domain   = "vpc"
}

# ----------- INTERNET GATEWAY -------------------
resource "aws_internet_gateway" "mydemoigw" {
  vpc_id = aws_vpc.mydemovpc.id

  tags = {
    Name = "mydemoigw"
  }
}

# ----------- NAT GATEWAY -------------------

resource "aws_nat_gateway" "mydemoNAT1" {
  allocation_id = aws_eip.eipfornat1.id
  subnet_id     = aws_subnet.publicsubnet1.id

  tags = {
    Name = "mydemoNAT1"
  }

  depends_on = [aws_internet_gateway.mydemoigw]
}

resource "aws_nat_gateway" "mydemoNAT2" {
  allocation_id = aws_eip.eipfornat2.id
  subnet_id     = aws_subnet.publicsubnet2.id

  tags = {
    Name = "mydemoNAT2"
  }

  depends_on = [aws_internet_gateway.mydemoigw]
}


# ------------ ROUTETABLEE ---------------------------

resource "aws_route_table" "RTforpublicsubnet" {
  vpc_id = aws_vpc.mydemovpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mydemoigw.id
  }

  tags = {
    Name = "RTforpublicsubnet"
  }
}

resource "aws_route_table" "RTforprivatesubnet1" {
  vpc_id = aws_vpc.mydemovpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.mydemoNAT1.id
  }

  tags = {
    Name = "RTforprivatesubnet1"
  }
}

resource "aws_route_table" "RTforprivatesubnet2" {
  vpc_id = aws_vpc.mydemovpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.mydemoNAT2.id

  }

  tags = {
    Name = "RTforprivatesubnet2"
  }
}

# ------------ ROUTETABLEE Association for public and private subnet ---------------------------

resource "aws_route_table_association" "publicsubnet1Association" {
  subnet_id      = aws_subnet.publicsubnet1.id
  route_table_id = aws_route_table.RTforpublicsubnet.id
}

resource "aws_route_table_association" "publicsubnet2Association" {
  subnet_id      = aws_subnet.publicsubnet2.id
  route_table_id = aws_route_table.RTforpublicsubnet.id
}

resource "aws_route_table_association" "privatesubnet1Association" {
  subnet_id      = aws_subnet.privatesubnet1.id
  route_table_id = aws_route_table.RTforprivatesubnet1.id
}

resource "aws_route_table_association" "privatesubnet2Association" {
  subnet_id      = aws_subnet.privatesubnet2.id
  route_table_id = aws_route_table.RTforprivatesubnet2.id
}

# ------------ SECURITY GROUP FOR EC2 ---------------------------

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.mydemovpc.id

  tags = {
    Name = "demoSG"
  }

   ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    description = "tcp access"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    description = "http access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ------------  EC2 cration JUMP host ---------------------------
resource "aws_instance" "jumphost" {
  ami                     = var.ami_for_jumphost
  instance_type           = var.instance_type_for_jumphost
  subnet_id = aws_subnet.publicsubnet1.id
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  key_name =var.key_name
  tags = {
    Name = "bastian"
  }
}

# ------------ AUTO SCALE GROUP FOR EC2 ---------------------------

resource "aws_launch_template" "demotamplate" {
  name_prefix   = "Demotemplate"
  image_id      = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = [ aws_security_group.allow_tls.id ]
  key_name = var.key_name
  user_data = file("${path.module}/userdata.sh")
  
}

resource "aws_autoscaling_group" "bar" {
  # availability_zones = ["ap-south-1a","ap-south-1b"]
  desired_capacity   = 2
  max_size           = 4
  min_size           = 1
  vpc_zone_identifier = [ aws_subnet.privatesubnet1.id,aws_subnet.privatesubnet2.id ]

  target_group_arns = [ aws_lb_target_group.mydemoTG.arn ]

  launch_template {
    id      = aws_launch_template.demotamplate.id
  }
}

# ------------ TARGET GROUPS ---------------------------

resource "aws_lb_target_group" "mydemoTG" {
  name     = "my-target-group"
  port     = 8000
  protocol = "HTTP"
  vpc_id   = aws_vpc.mydemovpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# ------------ APPLICATION lb ---------------------------

resource "aws_lb" "mydemoLB" {
  name               = "mydemoLB"
  load_balancer_type = var.load_balancer_type
  security_groups    = [aws_security_group.allow_tls.id]
  subnets            = [aws_subnet.publicsubnet1.id ,aws_subnet.publicsubnet2.id]

  tags = {
    Environment = "production"
  }
}

# ------------ APPLICATION lb ---------------------------

resource "aws_lb_listener" "mydemolblisterner" {
  load_balancer_arn = aws_lb.mydemoLB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mydemoTG.arn
  }
}





