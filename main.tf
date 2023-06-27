resource "aws_iam_role" "cloudwatch_agent_role" {
  name = "CloudWatchAgentRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent_policy_attachment" {
  role       = aws_iam_role.cloudwatch_agent_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
resource "aws_iam_instance_profile" "cloudwatch_agent_profile" {
  name = "CloudWatchAgentInstanceProfile"

  role = aws_iam_role.cloudwatch_agent_role.name
}

resource "aws_instance" "cloudwatch_instance" {
  ami                  = var.ami
  instance_type        = var.instance_type
  key_name             = var.key_name
  user_data            = file("userdata.sh")
  iam_instance_profile = aws_iam_instance_profile.cloudwatch_agent_profile.name
  vpc_security_group_ids = var.sg_name
  tags = {
    Name = "cw-instance"
  }
}

resource "aws_cloudwatch_dashboard" "EC2_Dashboard" {
  dashboard_name = "EC2-Dashboard"
  dashboard_body = <<EOF
{
  "widgets": [
    {
      "type": "metric",
      "width": 12,
      "height": 6,
      "x": 0,
      "y": 0,
      "properties": {
        "metrics": [
          [
            "CWAgent",
            "mem_used_percent",
            "host",
            "${aws_instance.cloudwatch_instance.private_dns}"
          ]
        ],
        "view": "timeSeries",
        "stacked": false,
        "region": "ap-south-1",
        "stat": "Average",
        "period": 300,
        "title": "Memory Utilization",
        "legend": {
          "position": "right"
        }
      }
    }
  ]
}
EOF
}
