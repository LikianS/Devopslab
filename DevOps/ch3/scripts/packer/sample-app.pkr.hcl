packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "aws_region" {
  type    = string
  default = "us-east-2"
}

source "amazon-ebs" "amazon_linux" {
  ami_name      = "packer-sample-app-{{timestamp}}"
  instance_type = "t3.micro"  # t3 est mieux supporté que t2 sur AL2023
  region        = var.aws_region
  ssh_username  = "ec2-user"

  source_ami_filter {
    filters = {
      # C'est ici qu'on change pour Amazon Linux 2023
      name                = "al2023-ami-2023.*-x86_64"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    owners      = ["amazon"]
    most_recent = true
  }
}

build {
  sources = ["source.amazon-ebs.amazon_linux"]

  provisioner "file" {
    sources     = ["app.js", "app.config.js"]
    destination = "/tmp/"
  }

  provisioner "shell" {
    inline = [
      # 1. Mise à jour du système (dnf est le nouveau yum)
      "sleep 30",
      "sudo dnf update -y",

      # 2. Installation de Node.js 20 (Version LTS recommandée)
      "curl -fsSL https://rpm.nodesource.com/setup_20.x | sudo bash -",
      "sudo dnf install -y nodejs",
      "sudo npm install pm2 -g",

      # 3. Création de l'utilisateur et préparation des dossiers
      "sudo useradd -m app-user",
      "sudo mv /tmp/app.js /home/app-user/",
      "sudo mv /tmp/app.config.js /home/app-user/",
      
      # On s'assure que app-user possède bien ses fichiers
      "sudo chown -R app-user:app-user /home/app-user",

      # 4. Configuration du service systemd via Root
      # Cette commande génère le script de démarrage mais ne lance pas encore le processus
      "sudo env PATH=$PATH:/usr/bin pm2 startup systemd -u app-user --hp /home/app-user",

      # 5. Démarrage de l'application via l'utilisateur (Login Shell)
      # On se connecte proprement en tant que 'app-user' pour lancer l'app
      # Cela évite les conflits de permissions root/user
      "sudo su - app-user -c 'pm2 start app.js'",
      "sudo su - app-user -c 'pm2 save'",
      
      # 6. Activation finale du service
      "sudo systemctl enable pm2-app-user"
    ]
  }
}
