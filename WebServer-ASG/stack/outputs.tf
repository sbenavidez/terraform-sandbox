output "clb_dns_name" {
  value       = aws_elb.tf-elb.dns_name
  description = "Load balancer DNS Name"
}