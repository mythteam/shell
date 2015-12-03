#!/bin/bash

soft=redis-2.8.23
softPkg=$soft.tar.gz

cd /usr/local/src
wget http://download.redis.io/releases/$softPkg
tar zxvf $softPkg
cd /usr/local/src/$soft

make

cp src/* /usr/local/redis

cp redis.conf  /etc


######################
#
# vi /etc/redis.conf
# modify:
#
#   daemonize yes
#
# start:
# /usr/local/redis/redis-server /etc/redis.conf
#
#
#
#
######################
