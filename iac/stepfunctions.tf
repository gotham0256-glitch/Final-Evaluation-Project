resource "aws_sfn_state_machine" "main" {
 name     = "final-project-state-machine"
 role_arn = aws_iam_role.main.arn
 definition = <<EOF
{
 "StartAt": "StartEC2",
 "States": {
   "StartEC2": {
     "Type": "Task",
     "Resource": "arn:aws:states:::aws-sdk:ec2:startInstances",
     "Parameters": {
       "InstanceIds": ["${aws_instance.preprocess.id}"]
     },
     "Next": "WaitState"
   },
   "WaitState": {
     "Type": "Wait",
     "Seconds": 30,
     "Next": "RunECSTask"
   },
   "RunECSTask": {
     "Type": "Task",
     "Resource": "arn:aws:states:::ecs:runTask.sync",
     "Parameters": {
       "Cluster": "${aws_ecs_cluster.main.arn}",
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
