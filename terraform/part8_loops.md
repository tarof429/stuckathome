# Loops

## Using count

The `count` keyword can be used to iterate through a list and create multiple resources. It is often used with `count.index` which is the distinct index number corresponding to an instance.

An example is shown below:

```
var "server_names" {
    list(string)
    default = ["eenie", "meenie", "moe"]
}
resource "aws_instance" "db" {
    ami = "ami-0604d81f2fd264c7b"
    instance_type = "t2.micro"
    count = 3
    tags = {
        Name = var.server_names[count.index]
    }
}
```

Terraform's `length()` function gives you the ability to calculate the length of a list.

```
resource "aws_instance" "db" {
    ami = "ami-0604d81f2fd264c7b"
    instance_type = "t2.micro"
    count = length(var.server_names)
    tags = {
        Name = var.server_names[count.index]
    }
}
```

There is another idiom that's often used with `count`. That is the `*` expression. If we want to output all the private IPs of EC2 instances, we could write:

```
output "PrivateIP" {
    value = [aws_instance.db.*.private_ip]
}
```

See the `count` example.

The `count_with_modules` adds a module to the `count` example. 

## Using for_each

The `for_each` keyword is often useful for creating security groups. This is because security groups may need to specify multiple ports.

We actually used `for_each` in the `alb` example. Below is a snippet where we used `for_each` with dynamic, which is a keyword to indicate code that will be generated on the fly:

```
variable "ingressrules" {
  type    = list(number)
  default = [22, 8080]
}
...
resource "aws_security_group" "web_traffic" {
  name        = "web-traffic"
  description = "Allow SSH and HTTP"

  dynamic "ingress" {
    iterator = port
    for_each = var.ingressrules

    content {
      protocol    = "tcp"
      from_port   = port.value
      to_port     = port.value
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
...
```
