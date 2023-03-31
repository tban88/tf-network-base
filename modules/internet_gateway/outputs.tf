output "igw_id" {
  value = { for k, v in aws_internet_gateway.new_igw : k => v.id }
}