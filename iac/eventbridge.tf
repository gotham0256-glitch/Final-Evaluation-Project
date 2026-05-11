# eventbridge rule 
resource "aws_cloudwatch_event_rule" "s3_upload" {
 name = "s3-upload-trigger"
 event_pattern = jsonencode({
   source = ["aws.s3"],
   detail-type = ["Object Created"],
   detail = {
     bucket = {
       name = [aws_s3_bucket.input.bucket]
     }
   }
 })
}
#Defines the action when the rule is triggered
resource "aws_cloudwatch_event_target" "stepfunction" {
  #Connects this target to your S3 event rule.
  rule      = aws_cloudwatch_event_rule.s3_upload.name
  #identifier for this target 
  target_id = "StepFunctionTarget" 
  # specify the destination a Step Function (State Machine).
  arn       = aws_sfn_state_machine.main.arn
  role_arn  = aws_iam_role.eventbridge_role.arn
  
input_transformer {
    input_paths = {
      bucket = "$.detail.bucket.name"
      key    = "$.detail.object.key"
    }
    input_template = <<EOF
{
  "bucket": "<bucket>",
  "key": "<key>"
}
EOF
  }
}
 