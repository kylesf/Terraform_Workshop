resource "aws_vpc_dhcp_options" "mainDHCP" {
  domain_name         = var.DNS_Zone
  domain_name_servers = ["AmazonProvidedDNS"]
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = aws_vpc.VPC.id
  dhcp_options_id = aws_vpc_dhcp_options.mainDHCP.id
}

resource "aws_route53_zone" "primary" {
  name = var.DNS_Zone
  vpc {
    vpc_id = aws_vpc.VPC.id
  }
}

resource "aws_route53_record" "database" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = format("%s%s", "database.", var.DNS_Zone)
  type    = "CNAME"
  ttl     = "60"
  records = [aws_db_instance.private-DB.address]
}
