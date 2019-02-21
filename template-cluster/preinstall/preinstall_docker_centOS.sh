#!/bin/bash
sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
    
#check packer version for modify below docker-ce install package version
yum list docker-ce --showduplicates | sort -r
    
#sudo yum -y install docker-ce-18.06.1.ce
#since rancher not support 18.06
sudo yum install -y --setopt=obsoletes=0 \
  docker-ce-17.03.1.ce-1.el7.centos \
  docker-ce-selinux-17.03.1.ce-1.el7.centos
  
sudo systemctl start docker
sudo usermod -aG docker $(whoami)

echo 'please logout before you use docker'