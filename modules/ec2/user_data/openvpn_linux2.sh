#!/bin/bash
sudo yum update -y
sudo yum upgrade -y
sudo yum -y remove openvpn-as-yum
sudo yum -y install https://as-repository.openvpn.net/as-repo-amzn2.rpm
sudo yum -y install openvpn-as
#/usr/local/openvpn_as/init.log >> credentials