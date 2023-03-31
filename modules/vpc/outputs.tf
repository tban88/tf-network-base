######################## DATA: VPC ########################

output "vpc_id" {
  value = { for k, v in aws_vpc.new_vpc : k => v.id }
}

/*
# If you need to output ids individually uncomment below using the key (i.e = PROD-VPC, NONPROD-VPC, etc)
output "vpc_id" {
  value = aws_vpc.new_vpc["PROD-VPC"].id
}
*/
