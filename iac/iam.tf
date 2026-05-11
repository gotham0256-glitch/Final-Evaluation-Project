#This defines who is allowed to assume (use) permission/trust the role.
data "aws_iam_policy_document" "assume_role" {
 statement {
  #This means services can “take” this role temporarily.
   actions = ["sts:AssumeRole"]
   principals {
     type = "Service"
     identifiers = [
       "ec2.amazonaws.com",
       "ecs-tasks.amazonaws.com",
       "states.amazonaws.com",
       

     ]
   }
 }
}
#Creates the IAM role.
resource "aws_iam_role" "main" {
 name               = "final-project-role"
 #Attaches the trust policy
 assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
resource "aws_iam_instance_profile" "ec2_profile" { #creates an instance profile for EC2 to use the IAM role
 name = "ec2-profile"
 role = aws_iam_role.main.name
}

resource "aws_iam_role_policy_attachment" "policies" {  #
 for_each = {
   ec2_full    = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
   ecs_exec    = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
   step_fn     = "arn:aws:iam::aws:policy/AWSStepFunctionsFullAccess"
   eventbridge = "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess"
 }
 role       = aws_iam_role.main.name #kis role pe attach karna hai policies, yeh value loop ke bahar se aayegi, kyunki sab policies same role pe attach karni hai
 policy_arn = each.value  #kis policy ko attach karna hai role pe, yeh value each loop se aayegi
}

 resource "aws_iam_role_policy" "stepfunction_logs" {
  role = aws_iam_role.main.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
         "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ]
        Resource = "*"
      }
    ]
  })
 }
 # EventBridge role to trigger Step Function
resource "aws_iam_role" "eventbridge_role" {
 name = "eventbridge-stepfunction-role"
 assume_role_policy = jsonencode({
   Version = "2012-10-17"
   Statement = [{
     Effect = "Allow"
     Principal = {
       Service = "events.amazonaws.com"
     }
     Action = "sts:AssumeRole"
   }]
 })
}
# EventBridge permission to trigger Step function
resource "aws_iam_role_policy" "eventbridge_policy" {
 role = aws_iam_role.eventbridge_role.id
 policy = jsonencode({
   Version = "2012-10-17"
   Statement = [{
     Effect = "Allow"
     Action = "states:StartExecution"
     Resource = aws_sfn_state_machine.main.arn
   }]
 })
}
 