#!/bin/bash
apt -y update 
apt -y upgrade
systemctl enable glusterd -y
apt-get -y install software-properties-common
add-apt-repository -y ppa:gluster/glusterfs-5

apt install -y glusterfs-client

# only run this after gluster server is ready
mount -t glusterfs gs.node.1:/distributed_vol /mnt/gfsvol/
df -hTP /mnt/gfsvol/
# gs.node.1:/distributed_vol /mnt/gfsvol glusterfs defaults,_netdev 0 0