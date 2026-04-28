data "aws_iam_policy_document" "assume_role" {
 statement {
   actions = ["sts:AssumeRole"]
   principals {
     type = "Service"
     identifiers = [
       "ec2.amazonaws.com",
       "ecs-tasks.amazonaws.com",
       "states.amazonaws.com"
     ]
   }
 }
}
resource "aws_iam_role" "main" {
 name               = "final-project-role"
 assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
resource "aws_iam_instance_profile" "ec2_profile" {
 name = "ec2-profile"
 role = aws_iam_role.main.name
}
resource "aws_iam_role_policy_attachement" "ec2_full" {  #ec2
  role = aws_iam_role.main.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role_policy_attachment" "ecs_exec" {   #ecs
 role       = aws_iam_role.main.name
 policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
resource "aws_iam_role_policy_attachment" "step_fn" {   # step_function
 role       = aws_iam_role.main.name
 policy_arn = "arn:aws:iam::aws:policy/AWSStepFunctionsFullAccess"
}
resource "aws_iam_role_policy_attachment" "eventbridge" {
 role       = aws_iam_role.main.name
 policy_arn = "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess"
}