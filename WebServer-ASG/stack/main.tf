

data "aws_availability_zones" "all" {}

resource "aws_autoscaling_group" "tf-asg" {
  name = "tf-asg"
  launch_configuration = aws_launch_configuration.tf-launch-config.id
  availability_zones   = data.aws_availability_zones.all.names
  target_group_arns = aws_lb_target_group.tf-lb-tg.name

  min_size = 1
  max_size = 1

  load_balancers    = [aws_elb.tf-elb.name]
  health_check_type = "ELB"

  tag {
    key                 = "Name"
    value               = "terraform-test"
    propagate_at_launch = true
  }

    tag {
    key                 = "CreatedBy"
    value               = "Santiago"
    propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "tf-launch-config" {
  name = "tf-launch-config"
  image_id        = "ami-0b69ea66ff7391e80" # Amazon Linux 2
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.tf-ec2-sg.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_lb_target_group" "tf-lb-tg" {
  name     = "tf-lb-tg"
  port     = 80
  protocol = "HTTP"

  tags = {
    Name = "terraform-test"
    CreatedBy = "Santiago"
  }
}


resource "aws_security_group" "tf-ec2-sg" {
  name = "tf-ec2-sg"

  # Inbound HTTP from anywhere
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-test"
    CreatedBy = "Santiago"
  }

}


resource "aws_elb" "tf-elb" {
  name               = "tf-elb"
  security_groups    = [aws_security_group.tf-elb-sg.id]
  availability_zones = data.aws_availability_zones.all.names

  health_check {
    target              = "HTTP:${var.server_port}/"
    interval            = 30
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  #Adds a listener for incoming HTTP requests.
  listener {
    lb_port           = var.elb_port
    lb_protocol       = "http"
    instance_port     = var.server_port
    instance_protocol = "http"
  }

  tags = {
    Name = "terraform-test"
    CreatedBy = "Santiago"
  }
}

resource "aws_security_group" "tf-elb-sg" {
  name = "tf-elb-sg"

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound HTTP from anywhere
  ingress {
    from_port   = var.elb_port
    to_port     = var.elb_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-test"
    CreatedBy = "Santiago"
  }
}