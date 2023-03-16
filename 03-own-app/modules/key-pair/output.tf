output "key_name" {
    value = aws_key_pair.aws-key-pair.key_name
}

output "key_path" {
    value = local_sensitive_file.pem_file.filename
}