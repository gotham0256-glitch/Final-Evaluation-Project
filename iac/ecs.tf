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
  container_definitions    = <<DEFINITION
[
  {
    "name": "final-container",
    "image": "amazonlinux",
    "essential": true,
    "command": ["echo", "Hello from ECS"]
  }
]
DEFINITION
}

resource "aws_ecs_service" "main" {
  name            = "final-project-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = [aws_subnet.public.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
  desired_count = 0
}
