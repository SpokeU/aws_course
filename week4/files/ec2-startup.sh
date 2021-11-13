#!/bin/bash
sudo su
yum update -y
yum install httpd -y
service httpd start
chkconfig httpd on
cd var/www/html
echo "<html><h1>This is WebServer from ${server} subnet</h1></html>" > index.html