resource "aws_key_pair" "raf" {
    key_name = "raf-key"
    public_key = "${file(var.ssh_pubkey_file)}"
}
