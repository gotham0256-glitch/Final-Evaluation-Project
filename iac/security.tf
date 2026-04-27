resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group" "ecs_sg" {
  vpc_id = aws_vpc.main.id
}
