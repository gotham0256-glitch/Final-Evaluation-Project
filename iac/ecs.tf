resource "aws_ecs_cluster" "main" {
 name = "final-project-cluster"
}
resource "aws_ecs_task_definition" "main" {
 family                   = "final-project-task"
 network_mode             = "awsvpc"
 requires_compatibilities = ["FARGATE"]
 cpu                      = "256"
 memory                   = "512"
 execution_role_arn       = aws_iam_role.main.arn

container_definitions = jsonencode([
  {
    name      = "final-container"
    image     = "public.ecr.aws/amazonlinux/amazonlinux:latest"
    essential = true
    command   = ["echo", "Main processing from ECS"]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/aws/ecs/final-project"
        awslogs-region        = "ap-south-1"
        awslogs-stream-prefix = "ecs"
      }
    }
  }
])
}
 