resource "aws_instance" "prometheus_instance" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  key_name      = var.deployer

  tags = {
    Name = "prometheus-instance"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y prometheus",
      "sudo systemctl start prometheus",
      "sudo systemctl enable prometheus"
    ]

    /* connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    } */
  }

  /* connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key_path)
    host        = self.public_ip
  } */
}

resource "aws_ami" "prometheus_ami" {
  name               = "prometheus-ami"
  description        = "AMI with Prometheus installed"
  virtualization_type = "hvm"

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  root_device_name = "/dev/sda1"
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 8
  }

  snapshot_id = aws_ebs_snapshot.prometheus_snapshot.id
}

resource "aws_ebs_snapshot" "prometheus_snapshot" {
  volume_id = aws_ebs_volume.prometheus_volume.id
}

resource "aws_ebs_volume" "prometheus_volume" {
  availability_zone = var.availability_zone
  size              = 8
}

output "prometheus_instance_ip" {
  value = aws_instance.prometheus_instance.public_ip
}
