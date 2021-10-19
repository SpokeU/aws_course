#!/bin/bash
sudo yum install -y java-1.8.0-openjdk-devel
aws s3 cp s3://omyshkoweek2bucket/helloworld.txt /home/ec2-user/s3File.txt