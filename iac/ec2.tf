resource "aws_instance" "preprocess" {
 ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 (update if needed)
 instance_type = "t2.micro"
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
