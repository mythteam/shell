#!/bin/bash

name=imagick
version=3.1.1
fullname=$name-$version
softPkg=$fullname.tar.gz

yum -y install ImageMagick-devel

# install
cd /usr/local/src
wget https://github.com/mkoppanen/$name/archive/$version.tar.gz -O $softPkg

tar zxvf $softPkg
cd /usr/local/src/$fullname

/usr/local/php/bin/phpize

./configure --with-php-config=/usr/local/php/bin/php-config

make
make install


######################
#
#
# Modify php.ini to add extensions
#
# restart php-fpm
#
######################


