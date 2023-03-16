# --- NEW KEY PAIRS ---
resource "tls_private_key" "key-pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_sensitive_file" "pem_file" {
  filename = "../infrastructure/keypairs/${var.key_purpose}-key.pem"
  file_permission = "400"
  content = tls_private_key.key-pair.private_key_pem
}

resource "aws_key_pair" "aws-key-pair" {
  key_name   = "${var.key_purpose}-key"
  public_key = tls_private_key.key-pair.public_key_openssh
}
