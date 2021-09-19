#!/bin/bash
apt -y update 
apt -y upgrade
systemctl enable glusterd -y
apt-get -y install software-properties-common
add-apt-repository -y ppa:gluster/glusterfs-5

apt install -y glusterfs-server

# run below commands in master node (eg: node 1)
gluster peer probe gs.node.2
gluster peer probe gs.node.3

gluster peer status
gluster pool list

# create distributed volume
gluster volume create distributed_vol transport tcp \
  gs.node.1:/gfsvolume/gv0 \
  gs.node.2:/gfsvolume/gv0 \
  gs.node.3:/gfsvolume/gv0

gluster volume start distributed_vol
gluster volume info