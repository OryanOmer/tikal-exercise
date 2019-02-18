provider "aws" {}

resource "aws_instance" "example" {
  ami           = "ami-0ac019f4fcb7cb7e6"
  instance_type = "t2.micro"
  key_name      = "aws-servers"
  tags {
    Name = "Jenkins-CI"
  }

  provisioner "remote-exec" {
    inline = [
      "echo -e \"Host *\n    StrictHostKeyChecking no\" > /home/ubuntu/.ssh/config",
      "sudo apt-get update -y",
      "sudo apt-get install -y software-properties-common",
      "sudo apt-add-repository ppa:ansible/ansible -y",
      "sudo apt-get update -y",
      "sudo apt-get install -y ansible",
    ]

    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = "${file("~/cloud/aws-servers.pem")}"
    }
  }
}

output "public_ip_address" {
  value = "${aws_instance.example.public_ip}"
}
