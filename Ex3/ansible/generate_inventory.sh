#!/bin/bash

# Obtenir les IPs depuis les outputs Terraform
nginx_ip=$(terraform output -raw nginx_public_ip)
php_ip=$(terraform output -raw php_public_ip)

# Générer le fichier d'inventaire Ansible
cat <<EOF > inventory.ini
[nginx]
nginx-server ansible_host=$nginx_ip ansible_user=ec2-user

[php]
php-server ansible_host=$php_ip ansible_user=ec2-user
EOF

echo "Inventaire Ansible généré avec succès dans ansible/inventory.ini"
