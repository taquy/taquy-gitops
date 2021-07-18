data "aws_route53_zone" "zone" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "sub_domains" {
  count = length(var.records.apps)

  zone_id =  data.aws_route53_zone.zone.zone_id
  name    = "${var.records.apps[count.index]}.${var.domain_name}"
  type    = "A"
  ttl     = "300"
  records = [
    var.vm_public_ip
  ]
}

resource "aws_route53_record" "main_domain" {
  zone_id =  data.aws_route53_zone.zone.zone_id
  name    = var.domain_name
  type    = "A"
  ttl     = "300"
  records = [
    var.vm_public_ip
  ]
}