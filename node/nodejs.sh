#!/bin/bash

pkg=node-v5.3.0-linux-x64

cd /usr/local

wget https://nodejs.org/dist/v5.3.0/$pkg.tar.gz

tar -zxvf $pkg.tar.gz

rm -f $pkg.tar.gz

mv $pkg nodejs


#ln -s /usr/local/nodejs/bin/node /usr/local/bin/node
#ln -s /usr/local/nodejs/bin/npm /usr/local/bin/npm

PATH=$PATH:/usr/local/nodejs/bin
