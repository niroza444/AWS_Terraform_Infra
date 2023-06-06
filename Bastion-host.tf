resource "aws_instance" "cloud_project-bastion" {
  ami                    = lookup(var.AMIS, var.AWS_REGION)
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.cloud_projectkey.key_name
  subnet_id              = module.vpc.public_subnets[0]
  count                  = var.instance_count
  vpc_security_group_ids = [aws_security_group.cloud_project-bastion-sg.id]

  tags = {
    Name    = "cloud_project-bastion"
    PROJECT = "cloud_project"
  }

  provisioner "file" {
    content     = templatefile("templates/db-deploy.tmpl", { rds-endpoint = aws_db_instance.cloud_project-rds.address, dbuser = var.dbuser, dbpass = var.dbpass })
    destination = "/tmp/cloud_project-dbdeploy.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/cloud_project-dbdeploy.sh",
      "sudo /tmp/cloud_project-dbdeploy.sh"
    ]
  }

  connection {
    user        = var.USERNAME
    private_key = file(var.PRIV_KEY_PATH)
    host        = self.public_ip
  }
  depends_on = [aws_db_instance.cloud_project-rds]
}