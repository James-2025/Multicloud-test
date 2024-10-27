# aws_instance.tf
provider "aws" {
  region = "us-east-1"  # Adjust as needed
}

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"  # Replace with a valid AMI for your region
  instance_type = "t2.micro"

  provisioner "file" {
    source      = "index.html"
    destination = "/var/www/html/index.html"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install -y apache2",
      "sudo mv /var/www/html/index.html /var/www/html/",
      "sudo systemctl start apache2",
      "sudo systemctl enable apache2"
    ]
  }

  tags = {
    Name = "aws-web-server"
  }
}
