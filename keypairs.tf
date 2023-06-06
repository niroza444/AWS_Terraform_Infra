resource "aws_key_pair" "cloud_projectkey" {
  key_name   = "cloud_projectkey"
  public_key = file(var.PUB_KEY_PATH)
}