resource "aws_security_group" "ec2-terraform" {
  name = "terraform-example-instance"
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_configuration" "test_ec2" {
  image_id        = var.ami_id
  instance_type   = var.ec2_type
  security_groups = [aws_security_group.ec2-terraform.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg_test" {
  launch_configuration = aws_launch_configuration.test_ec2.name
  vpc_zone_identifier  = var.subnet_ids

  target_group_arns = [var.target_group_arn]
  health_check_type = "ELB"

  min_size = 2
  max_size = 5

  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }
}
