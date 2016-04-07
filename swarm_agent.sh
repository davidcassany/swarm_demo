#!/bin/bash

IP=$1
TOKEN=$2

sudo zypper search --installed-only docker
if [ $? -ne 0  ] ; then
  sudo zypper --non-interactive install docker
fi

sed -i "s|\(DOCKER_OPTS=\).*|\1\"-H tcp://0.0.0.0:2375\"|" /etc/sysconfig/docker

sudo systemctl restart docker || exit 1

for i in 0 1 2 3 4 5 6 7 8 9 ; do

  sudo docker run --restart unless-stopped -d swarm join --addr=$IP:2375 token://$TOKEN
  if [ $? -eq 0 ] ; then
    sudo docker build -t "david/db" /vagrant/dataBase || exit 1
    sudo docker build -t "david/webapp" /vagrant/webapp || exit 1
    break;
  fi

  echo "Waiting docker daemon to start, retrying in 2 seconds..." 1>&2
  sleep 2 

done

if [ "$3" == "master" ] ; then
  echo "Starting the master swarm agent..." 1>&2
  sudo docker run --restart unless-stopped -d -p 23755:2375 swarm manage token://$TOKEN || exit 1
fi

exit 0

