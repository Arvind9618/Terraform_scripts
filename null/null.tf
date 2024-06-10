resource "null_resource" "nr" {
  provisioner "file" {
    source      = "./null.tf"
    destination = "./null.tf"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = "18.135.45.237"  
      private_key = file("./zds.pem")
    }
  }
}
