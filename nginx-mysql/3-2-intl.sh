#!/bin/bash

dest=/usr/local/src
dir=`pwd`
icu=icu4c-56_1-RHEL6-x64.tgz
intlVer=intl-3.0.0
intl=$intlVer.tgz

# copy files
cp $dir/../pkgs/* $dest

# install
cd $dest

# install icu
tar zxvf $icu
cd icu/source

./configure

make
make install

cd $dest
tar zxvf $intl
cd $intlVer
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


