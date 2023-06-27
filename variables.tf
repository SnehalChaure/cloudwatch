variable "ami" {
  default = "ami-057752b3f1d6c4d6c"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "aws-key-pair"
}

variable "count_num" {
  default = "1"
}

variable "sg_name" {
  default= ["sg-0d6d7a5932a86d274"]
}