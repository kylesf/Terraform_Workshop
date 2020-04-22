resource "aws_instance" "bastion_server_a" {
  ami           = var.ami_type
  instance_type = "t2.micro"

  associate_public_ip_address = "true"
  subnet_id                   = aws_subnet.Public_bastion_zone_a.id
  vpc_security_group_ids      = [aws_security_group.bastion_server.id]

  key_name = var.pem_key

  tags = {
    Name = "bastion_server_zone_a"
  }

  user_data = <<-EOF
  #!/bin/bash
  sudo apt-get update
  sudo apt-get upgrade
  EOF
}

resource "aws_instance" "bastion_server_b" {
  ami           = var.ami_type
  instance_type = "t2.micro"

  associate_public_ip_address = "true"
  subnet_id                   = aws_subnet.Public_bastion_zone_b.id
  vpc_security_group_ids      = [aws_security_group.bastion_server.id]

  key_name = var.pem_key

  tags = {
    Name = "bastion_server_zone_b"
  }

  user_data = <<-EOF
  #!/bin/bash
  sudo apt-get update
  sudo apt-get upgrade
  EOF
}

resource "aws_instance" "webserver_a" {
  ami                         = var.ami_type
  instance_type               = "t2.micro"
  key_name                    = var.pem_key
  subnet_id                   = aws_subnet.Public_webserver_zone_a.id
  vpc_security_group_ids      = [aws_security_group.Webserver_zone_a.id]
  associate_public_ip_address = "true"
  iam_instance_profile        = aws_iam_instance_profile.webserver_profile.id

  tags = {
    Name = "server_zone_a"
  }

  user_data = <<-EOF
  #!/bin/bash
  sudo apt-get update
  sudo apt-get -y install awscli
  sudo mkdir /srv/www
  aws s3 cp s3://"${aws_s3_bucket.server-files-bucket.bucket}"/server-files.tar.gz /srv/www/server-files.tar.gz
  aws s3 cp s3://"${aws_s3_bucket.server-files-bucket.bucket}"/bootstrap.sh /tmp/bootstrap.sh
  sudo chmod +x /tmp/bootstrap.sh
  sudo  /tmp/bootstrap.sh > /tmp/stdout.txt 2> /tmp/stderr.txt
  sleep 5
  sudo service lenslocked.com restart
  sudo echo export ELB="${aws_lb.main_lb.dns_name}" >> /etc/profile
  sudo service caddy restart
  EOF
}

resource "aws_instance" "webserver_b" {
  ami                         = var.ami_type
  instance_type               = "t2.micro"
  key_name                    = var.pem_key
  subnet_id                   = aws_subnet.Public_webserver_zone_b.id
  vpc_security_group_ids      = [aws_security_group.Webserver_zone_b.id]
  associate_public_ip_address = "true"
  iam_instance_profile        = aws_iam_instance_profile.webserver_profile.id

  tags = {
    Name = "server_zone_b"
  }

  user_data = <<-EOF
  #!/bin/bash
  sudo apt-get update
  sudo apt-get -y install awscli
  sudo mkdir /srv/www
  aws s3 cp s3://"${aws_s3_bucket.server-files-bucket.bucket}"/server-files.tar.gz /srv/www/server-files.tar.gz
  aws s3 cp s3://"${aws_s3_bucket.server-files-bucket.bucket}"/bootstrap.sh /tmp/bootstrap.sh
  sudo chmod +x /tmp/bootstrap.sh
  sudo  /tmp/bootstrap.sh > stdout.txt 2> stderr.txt
  sleep 5
  sudo service lenslocked.com restart
  sudo echo export ELB="${aws_lb.main_lb.dns_name}" >> /etc/profile
  sudo service caddy restart
  EOF
}

resource "aws_db_instance" "private-DB" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "12.2"
  instance_class         = "db.t2.micro"
  name                   = "lenslocked_prod"
  username               = "KyleF"
  password               = "abc123XYZ123"
  db_subnet_group_name   = aws_db_subnet_group.db.id
  vpc_security_group_ids = [aws_security_group.DB_server.id]
  skip_final_snapshot    = true
}
