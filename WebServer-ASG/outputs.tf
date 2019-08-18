output "clb_dns_name" {
  value       = aws_elb.example.dns_name
  description = "Load balancer DNS Name"
}