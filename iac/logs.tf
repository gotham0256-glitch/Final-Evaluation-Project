# resource "aws_cloudwatch_log_group" "main" {
 # name = "/aws/stepfunctions/final-project"
#}

 resource "aws_cloudwatch_log_group" "ecs" {
   name = "/aws/ecs/final-project"
 }

# resource "aws_cloudwatch_log_resource_policy" "stepfunction" {
#   policy_name = "stepfunction-log-policy"
#   policy_document = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid = "AllowStepFunctionsLogging"
#         Effect = "Allow"
#         Principal = {
#           Service = "states.amazonaws.com"
#         }
#         Action = [
#          "logs:CreateLogStream",
#           "logs:PutLogEvents",
#           "logs:CreateLogDelivery",
# "logs:GetLogDelivery",
# "logs:UpdateLogDelivery",
# "logs:DeleteLogDelivery",
# "logs:ListLogDeliveries",
# "logs:PutResourcePolicy",
# "logs:DescribeResourcePolicies",
# "logs:DescribeLogGroups"
#         ]
#         Resource = "*"
#       }
#     ]
#   })
#}
 
