resource "aws_route53_zone" "primary" {
  name = "tc.digitalcncloud.org"
}

resource "aws_route53_record" "ns-to-alb" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "tc.digitalcncloud.org"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}