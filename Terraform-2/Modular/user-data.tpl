#!/bin/bash
sudo apt update -y 
sudo apt install apache2 -y
sudo systemctl start apache2
sudo systemctl enable apache2
sudo mkdir -p /var/www/html
cd /var/www
sudo chmod 777 html
cd html
echo $(hostname -f) > index.html
cd ../../..
cd home/ubuntu
sudo apt update -y
sudo curl https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -O
sudo apt update -y
sudo apt install python2 -y
sudo python2 ./awslogs-agent-setup.py --region us-east-2
cd /var/awslogs/etc/
sudo service awslogs start
sudo service awslogs enable