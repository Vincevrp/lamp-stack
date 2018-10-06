#!/bin/bash

sed -i "s/SELINUX=permissive/SELINUX=enforcing/g" /etc/selinux/config
setenforce 1
