variable "location" {
  default = "Denmark East"
}

variable "resource_group_name" {
  default = "Denmark-east-rg"
}

variable "image_id" {
  default = "/subscriptions/7ba54b86-56e1-4dd5-a544-23df4caeb2aa/resourceGroups/Denmark-east-rg/providers/Microsoft.Compute/galleries/rhel10.1/images/1.0.0/versions/1.0.0"
}

variable "components" {
  default = {
    frontend = "Standard_B1s"
    mysql = "Standard_B1s"
    valkey = "Standard_B1s"
    mongodb = "Standard_B1s"
    rabbitmq = "Standard_B1s"
    catalogue = "Standard_B1s"
    user = "Standard_B1s"
    cart = "Standard_B1s"
    shipping = "Standard_B1s"
    order = "Standard_B1s"
    notification = "Standard_B1s"
    ratings = "Standard_B1s"
  }
}