packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "golden-ami" {
  ami_name        = "golden-ami-{{timestamp}}"
  instance_type   = "t3.micro"
  region          = "ap-south-1"
  source_ami      = "ami-02b8269d5e85954ef"
  ssh_username    = "ubuntu"
  ami_description = "An Ubuntu Linux 2 AMI with Nginx installed and configured to serve a static website."
}

build {
  sources = [
    "source.amazon-ebs.golden-ami"
  ]

  provisioner "shell" {
    inline = [
      "sudo apt update -y",
      "sudo apt install nginx -y",
      "sudo systemctl enable nginx",
      "sudo rm /var/www/html/*.html",
      #"echo '<html><body><h1>Welcome to the Golden AMI Website! powered by DIM Nov team </h1></body></html>' | sudo tee /var/www/html/index.html",
      "sudo systemctl start nginx"
    ]
    #source      = "path/to/your/local/index.html"
    #destination = "/var/www/html/index.html"
  }
}
