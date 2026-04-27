resource "aws_s3_bucket" "input" {
  bucket = "final-project-input-bucket-unique"
}

resource "aws_s3_bucket" "output" {
  bucket = "final-project-output-bucket-unique"
}
