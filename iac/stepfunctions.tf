resource "aws_sfn_state_machine" "main" {
  name     = "final-project-state-machine"
  role_arn = aws_iam_role.main.arn
  definition = <<EOF
{
  "StartAt": "CheckEC2",
  "States": {
    "CheckEC2": {
      "Type": "Task",
      "Resource": "arn:aws:states:::aws-sdk:ec2:describeInstances",
      "Next": "StartEC2"
    },
    "StartEC2": {
      "Type": "Task",
      "Resource": "arn:aws:states:::aws-sdk:ec2:startInstances",
      "Next": "RunECSTask"
    },
    "RunECSTask": {
      "Type": "Task",
      "Resource": "arn:aws:states:::ecs:runTask.sync",
      "Parameters": {
        "Cluster": "${aws_ecs_cluster.main.name}",
        "TaskDefinition": "${aws_ecs_task_definition.main.arn}",
        "LaunchType": "FARGATE",
        "NetworkConfiguration": {
          "AwsvpcConfiguration": {
            "Subnets": ["${aws_subnet.public.id}"],
            "SecurityGroups": ["${aws_security_group.ecs_sg.id}"],
            "AssignPublicIp": "ENABLED"
          }
        }
      },
      "End": true
    }
  }
}
EOF
}
