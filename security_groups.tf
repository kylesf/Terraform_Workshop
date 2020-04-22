resource "aws_security_group" "load_balancer_security_group" {
  name        = "load_balancer_security_group"
  description = "Set HTTP up for load balance"

  vpc_id = aws_vpc.VPC.id

  # Http port
  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outgoing connectinogs
  egress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "Webserver_zone_a" {
  name        = "web server a"
  description = "Open up port for server"

  vpc_id = aws_vpc.VPC.id

  # SSH port
  ingress {
    from_port = "22"
    to_port   = "22"
    protocol  = "TCP"

    # Lock to bastions
    cidr_blocks = [var.Public-subnet-bastion-a-CIDR, var.Public-subnet-bastion-b-CIDR]
  }

  # Http port
  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outgoing connectinogs
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "Webserver_zone_b" {
  name        = "web server b"
  description = "Open up port for server"

  vpc_id = aws_vpc.VPC.id

  # SSH port
  ingress {
    from_port = "22"
    to_port   = "22"
    protocol  = "TCP"

    # Lock to bastion
    cidr_blocks = [var.Public-subnet-bastion-a-CIDR, var.Public-subnet-bastion-b-CIDR]
  }

  # Http port
  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outgoing connectinogs
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "bastion_server" {
  name        = "bastion_server"
  description = "Security group for bastion"

  vpc_id = aws_vpc.VPC.id

  # SSH port
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]

    # cidr_blocks = ["YOUR-IP/32"]
  }

  # Outgoing connectinogs
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "DB_server" {
  name        = "db_server"
  description = "Security group for DB"

  vpc_id = aws_vpc.VPC.id

  # DB port
  ingress {
    from_port = "5432"
    to_port   = "5432"
    protocol  = "TCP"

    # Lock to web servers
    cidr_blocks = [var.Public-subnet-server-a-CIDR, var.Public-subnet-server-b-CIDR]
  }

  # Outgoing connectinogs
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
