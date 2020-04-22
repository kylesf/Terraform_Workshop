resource "aws_s3_bucket" "server-files-bucket" {
  bucket = var.random_s3_name
  acl    = "private"
}

resource "aws_s3_bucket_object" "server-files" {
  bucket = aws_s3_bucket.server-files-bucket.bucket
  key    = "server-files.tar.gz"
  source = "./server_files.tar.gz"
}

resource "aws_s3_bucket_object" "boot-file" {
  bucket = aws_s3_bucket.server-files-bucket.bucket
  key    = "bootstrap.sh"
  source = "./webserver_scripts/bootstrap.sh"
}
