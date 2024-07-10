#!/bin/bash

sudo apt-get update
sudo apt-get install apache2 -y
mkdir -p /home/ubuntu/dir1
sudo rm -rf /var/www/html/*
sudo git clone https://github.com/amolshete/card-website.git /var/www/html
sudo chown -R www-data:www-data /var/www/html
sudo systemctl restart apache2
