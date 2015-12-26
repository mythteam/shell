#!/bin/bash

#curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh | bash

soft=node-v5.2.0
softPkg=$soft-linux-x64.tar.gz

cd /usr/local/src

wget https://nodejs.org/dist/v5.2.0/$softPkg

tar zxvf $softPkg

cd /usr/local/src/$soft

#######################
#
# nvm install v4.2.3
# npm i bower -g --allow-root
#
# #####################