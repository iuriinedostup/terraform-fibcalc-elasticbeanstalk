variable "vpc_id" {
  type    = string
  default = ""
}

variable "subnets" {
  type    = list(string)
  default = [""]
}

variable "default_tags" {
  default = {
    App = "Multi Docker"
  }
}