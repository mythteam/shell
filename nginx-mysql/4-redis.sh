#!/bin/bash

soft=redis-4.0.1
softPkg=$soft.tar.gz

cd /usr/local/src
wget http://download.redis.io/releases/$softPkg
tar zxvf $softPkg
cd /usr/local/src/$soft

make

mkdir -p /usr/local/redis
cp src/* /usr/local/redis

cp redis.conf  /etc

sed -i 's/daemonize no/daemonize yes/' /etc/redis.conf
#sed -i 's/bind 127.0.0.1/bind 0.0.0.0/g' /etc/redis.conf
sed -i 's/timeout 0/timeout 30/' /etc/redis.conf
sed -i 's/tcp-keepalive 0/tcp-keepalive 60/' /etc/redis.conf
#sed -i 's/# requirepass foobared/requirepass passw0rd/g' /etc/redis.conf
sed -i 's/# maxclients 10000/maxclients 10000/' /etc/redis.conf

/usr/local/redis/redis-server /etc/redis.conf

######################
#
# start:
# /usr/local/redis/redis-server /etc/redis.conf
#
######################
