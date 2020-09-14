resource "aws_security_group" "http" {
  name        = "sghttp"
  description = "Security Group para Acesso HTTP"
  vpc_id      = var.vpc_id

  # Porta de Entrada
  ingress {
    description = "Entrada HTTP"
    from_port   = var.http
    to_port     = var.http
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Porta de Saída
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }
  tags = merge(
    var.tags,
    map(
      "Name", "sg-http-pvt"
    )
  )
}

resource "aws_security_group" "https" {
  name        = "sghttps"
  description = "Security Group para Acesso HTTPS"
  vpc_id      = var.vpc_id

  # Porta de Entrada
  ingress {
    description = "Entrada HTTPS"
    from_port   = var.https
    to_port     = var.https
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Porta de Saída
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }
  tags = merge(
    var.tags,
    map(
      "Name", "sg-https"
    )
  )
}

resource "aws_security_group" "mysql" {
  name        = "sgdbmysql"
  description = "Security Group para Acesso MySQL"
  vpc_id      = var.vpc_id

  # Porta de Entrada
  ingress {
    description = "Entrada MySQL"
    from_port   = var.mysql
    to_port     = var.mysql
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Porta de Saída
  egress {
    from_port   = var.mysql
    to_port     = var.mysql
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  tags = merge(
    var.tags,
    map(
      "Name", "sg-db-mysql"
    )
  )
}

resource "aws_security_group" "ssh" {
  name        = "sgssh"
  description = "Security Group para Acesso SSH"
  vpc_id      = var.vpc_id

  # Porta de Entrada
  ingress {
    description = "Entrada SSH"
    from_port   = var.ssh
    to_port     = var.ssh
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # Porta de Saída
  egress {
    from_port   = var.ssh
    to_port     = var.ssh
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  tags = merge(
    var.tags,
    map(
      "Name", "sg-ssh"
    )
  )
}

resource "aws_security_group" "openvpn" {
  name        = "sgopenvpn"
  description = "Security Group para Acesso OpenVPN"
  vpc_id      = var.vpc_id

  # Porta de Entrada
  ingress {
    description = "Entrada AUTH OPENVPN"
    from_port   = var.openvpn
    to_port     = var.openvpn
    protocol    = "udp"
    cidr_blocks = [var.all_access]
  }

  # Porta de Saída
  egress {
    from_port   = var.openvpn
    to_port     = var.openvpn
    protocol    = "udp"
    cidr_blocks = [var.all_access]
  }
  tags = merge(
    var.tags,
    map(
      "Name", "sg-openvpn"
    )
  )
}

resource "aws_security_group" "alb" {
  name        = "sg-alb-public"
  description = "Security Group para Loadbalancer"
  vpc_id      = var.vpc_id

  # Porta de Entrada HTTP
  ingress {
    description = "http"
    from_port   = var.http
    to_port     = var.http
    protocol    = "tcp"
    cidr_blocks = [var.all_access]
  }

  # Porta de Entrada HTTPS
  ingress {
    description = "https"
    from_port   = var.https
    to_port     = var.https
    protocol    = "tcp"
    cidr_blocks = [var.all_access]
  }

  # Porta de Saída
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = [var.all_access]
  }
  tags = merge(
    var.tags,
    map(
      "Name", "sg-alb-public"
    )
  )
}


resource "aws_security_group" "docker" {
  name = "sgswarmcluster"

  # Allow all inbound
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.all_access]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.all_access]
  }

  # Enable ICMP
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [var.all_access]
  }
    tags = merge(
    var.tags,
    map(
      "Name", "sg-alb-docker"
    )
  )
}