resource "aws_cloudwatch_log_group" "main" {
  name = "/aws/stepfunctions/final-project"
}

resource "aws_cloudwatch_log_group" "ecs" {
  name = "/aws/ecs/final-project"
}
