resource "aws_instance" "preprocess" {
 ami           = "ami-0f5ee92e2d63afc18" # Amazon Linux 2 (update if needed)
 instance_type = "t3.micro"
 subnet_id     = aws_subnet.public.id
 vpc_security_group_ids = [aws_security_group.ec2_sg.id]
 iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
 user_data = <<EOF
#!/bin/bash
echo "Preprocessing started" > /home/ec2-user/output.txt
EOF
 tags = {
   Name = "preprocess-ec2"
 }
}
