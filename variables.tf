variable "vpc_id" {
  type = string
  default = "vpc-7a12f903"
}

variable "subnets" {
  type = list(string)
  default = ["subnet-7e645336", "subnet-5137560b", "subnet-572d0931"]
}

variable "default_tags" {
  default = {
    App = "Multi Docker"
    Project = "Udemy"
  }
}