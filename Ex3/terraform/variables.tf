variable "aws_region" {
  description = "La région AWS pour les ressources"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Type d'instance EC2 pour les services"
  default     = "t2.micro"
}

variable "aws_access_key" {}
variable "aws_secret_key" {}
