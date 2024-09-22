output "subnet_ids" {
    value = data.aws_subnets.default_vpc_subnets.ids
}

output "vpc_id" {
  value = data.aws_vpc.default.id
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default_vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
