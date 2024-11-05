#!/bin/bash
# Extraire les IP des instances depuis Terraform
nginx_ip=$(terraform output -raw nginx_public_ip)
php_ip=$(terraform output -raw php_public_ip)

echo "Nginx IP: $nginx_ip"
echo "PHP IP: $php_ip"
