#!/bin/bash

sudo yum install -y amazon-cloudwatch-agent

# Write Cloudwatch agent configuration file
sudo cat >> /opt/aws/amazon-cloudwatch-agent/bin/config.json <<EOF
{
    "agent": {
            "metrics_collection_interval": 60,
            "run_as_user": "cwagent"
    },
    "metrics": {
            "metrics_collected": {
                    "disk": {
                            "measurement": [
                                    "used_percent"
                            ],
                            "metrics_collection_interval": 60,
                            "resources": [
                                    "*"
                            ]
                    },
                    "mem": {
                            "measurement": [
                                    "mem_used_percent"
                            ],
                            "metrics_collection_interval": 60,
                            "resources": [
                                    "*"
                            ]

                    }
            }
    }
}
EOF

# Start Cloudwatch agent
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json

sudo systemctl start amazon-cloudwatch-agent.service
