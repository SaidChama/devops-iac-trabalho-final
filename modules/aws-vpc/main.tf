resource "aws_vpc" "final_work_vpc" {
    cidr_block           = "10.0.0.0/16"
    enable_dns_support   = true
    enable_dns_hostnames = true

    tags = {
        Name = "Final_work_vpc"
    }
}

resource "aws_subnet" "final_work_subnet_1" {
    vpc_id = aws_vpc.final_work_vpc.id
    cidr_block              = "10.0.1.0/24"
    map_public_ip_on_launch = true
    availability_zone       = "us-east-1a"

    tags = {
        Name = "Final_work_subnet_1"
    }
}

resource "aws_subnet" "final_work_subnet_2" {
    vpc_id = aws_vpc.final_work_vpc.id
    cidr_block              = "10.0.2.0/24"
    map_public_ip_on_launch = true
    availability_zone       = "us-east-1b"

    tags = {
        Name = "Final_work_subnet_2"
    }
}

resource "aws_internet_gateway" "final_work_igw" {
    vpc_id = aws_vpc.final_work_vpc.id

    tags = {
        Name = "Final_work_igw"
    }
}

resource "aws_route_table" "final_work_rt" {
    vpc_id         = aws_vpc.final_work_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.final_work_igw.id
    }
}

resource "aws_route_table_association" "final_work_rta" {
    subnet_id = aws_subnet.final_work_subnet_1.id
    route_table_id = aws_route_table.final_work_rt.id
}