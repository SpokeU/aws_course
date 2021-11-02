#!/bin/bash
sudo yum install -y java-1.8.0-openjdk-devel
aws s3 cp s3://omyshkoweek3bucket/rds-script.sql /home/ec2-user/rds-script.sql
aws s3 cp s3://omyshkoweek3bucket/dynamodb-script.sh /home/ec2-user/dynamodb-script.sh