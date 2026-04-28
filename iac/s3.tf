# resource "aws_s3_bucket" "input" {
#   bucket = "final-project-input-bucket-unique"
# }
resource "aws_s3_bucket" "input" {
 bucket = "final-project-input-${random_id.suffix.hex}"
 force_destroy = true  # Allows terraform to delete the bucket even if itcontains objects
}
resource "random_id" "suffix" {
 byte_length = 4
}
#Tell s3 to send all events (like uploads) to eventbridge
resource "aws_s3_bucket_notification" "eventbridge" {
 bucket      = aws_s3_bucket.input.id
 eventbridge = true
}
# resource "aws_s3_bucket" "output" {
#   bucket = "final-project-output-bucket-unique"
# }

