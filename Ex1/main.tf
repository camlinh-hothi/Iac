# Spécifiez le provider Docker
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Créer un réseau Docker
resource "docker_network" "nginx_network" {
  name = "nginx_net"
}

# Créer l'image Docker PHP-FPM
resource "docker_image" "php_image" {
  name         = "php:7.4-fpm"
  keep_locally = true
}

# Créer l'image Docker NGINX
resource "docker_image" "nginx_image" {
  name         = "nginx:latest"
  keep_locally = true
}

# Container PHP-FPM
resource "docker_container" "php_container" {
  name  = "php-fpm"
  image = docker_image.php_image.name

  networks_advanced {
    name = docker_network.nginx_network.name
  }

  volumes {
    host_path      = "${abspath("${path.root}/src")}"
    container_path = "/var/www/html"
  }
}

# Container NGINX
resource "docker_container" "nginx_container" {
  #depends_on = [docker_container.php]
  name  = "nginx"
  image = docker_image.nginx_image.name

  networks_advanced {
    name = docker_network.nginx_network.name
  }

  ports {
    internal = 80
    external = 8080
  }

  volumes {
    host_path      = "${abspath("${path.root}/config/nginx.conf")}"
    container_path = "/etc/nginx/conf.d/default.conf"
  }
}
