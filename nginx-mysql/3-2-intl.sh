#!/bin/bash

dest=/usr/local/src
icu=icu4c-56_1-src.tgz
intlVer=intl-3.0.0
intl=$intlVer.tgz

# install
cd $dest

wget http://download.icu-project.org/files/icu4c/56.1/$icu
#wget https://raw.githubusercontent.com/mythteam/shell/master/pkgs/$icu
#wget https://raw.githubusercontent.com/mythteam/shell/master/pkgs/$intl

# install icu
tar zxvf $icu
cd icu/source

./configure

make
make install

#cd $dest
#tar zxvf $intl
#cd $intlVer
#/usr/local/php/bin/phpize

#./configure --with-php-config=/usr/local/php/bin/php-config

#make
#make install


######################
#
#
# Modify php.ini to add extensions
#
# restart php-fpm
#
######################


