variable ami {
    type = string
    default = "ami-0aff18ec83b712f05"
}

variable instance_type {
    type = string
    default = "t2.micro"
}

variable vpc_cidr_block {
    type = string
    default = "10.0.0.0/16"
}

variable public_subnet_cidr {
    type = string
    default = "10.0.1.0/24"
}

variable ingressrules {
    type = list(number)
    default = [22, 80, 8080, 8443]
}

variable egressrules {
    type = list(number)
    default = [22, 80, 8080, 8443]
}
