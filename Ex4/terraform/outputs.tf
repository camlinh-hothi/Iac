output "nginx_public_ip" {
  value = aws_instance.nginx_instance.public_ip
}

output "php_public_ip" {
  value = aws_instance.php_instance.public_ip
}

output "db_public_ip" {
  value = aws_instance.db_instance.public_ip
}
