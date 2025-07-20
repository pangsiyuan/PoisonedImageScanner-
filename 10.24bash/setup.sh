#!/bin/bash
echo "yum upgrade"
yum -y upgrade
echo "install docker"
curl -fsSL https://test.docker.com -o test-docker.sh
sudo sh test-docker.sh
echo "start docker"
systemctl start docker
echo "install epel"
yum  install  -y  epel-release
echo "install clamav"
yum  install  -y  clamav  clamd  clamav-update
echo "freshclam"
freshclam
echo "end"
