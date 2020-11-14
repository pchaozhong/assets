output "vpc_id" {
  value = { for v in aws_vpc.main: v.tags.Name => v.id }
}

output "subnet_id" {
  value = { for v in aws_subnet.main : v.tags.Name => v.id }
}
