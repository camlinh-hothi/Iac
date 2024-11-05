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

resource "docker_network" "nginx_network" {
  name = "nginx_net"
}

resource "docker_image" "php_image" {
  name         = "custom-php"
  keep_locally = true
}

resource "docker_image" "nginx_image" {
  name         = "nginx:latest"
  keep_locally = true
}

resource "docker_image" "mariadb_image" {
  name         = "mariadb:latest"
  keep_locally = true
}

resource "docker_container" "mariadb_container" {
  name  = "mariadb"
  image = docker_image.mariadb_image.name

  env = [
    "MYSQL_ROOT_PASSWORD=password",
    "MYSQL_DATABASE=testdb"
  ]

  networks_advanced {
    name = docker_network.nginx_network.name
  }

  ports {
    internal = 3306
    external = 3307
  }

  volumes {
    host_path      = "${abspath("${path.root}/data")}"
    container_path = "/var/lib/mysql"
  }
}

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

resource "docker_container" "nginx_container" {
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
