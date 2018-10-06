#!/usr/bin/env bash

yum install httpd -y
systemctl enable httpd.service
systemctl start httpd.service
