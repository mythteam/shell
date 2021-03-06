#!/bin/bash
yum -y install cmake ncurses-devel libaio bison gcc-c++ gcc

#boost
#wget https://dl.bintray.com/boostorg/release/1.64.0/source/boost_1_64_0.tar.gz
#tar -xf boost_1_64_0.tar.gz
#cd boost_1_64_0
#./bootstrap.sh
#./b2 install


soft=mysql-5.7.17
softPkg=$soft.tar.gz


# install mysql
groupadd mysql
useradd -g mysql mysql -s /bin/false
mkdir -p /data/mysql
chown -R mysql:mysql /data/mysql
mkdir -p /usr/local/mysql

cd /usr/local/src/

 
wget http://mirrors.sohu.com/mysql/MySQL-5.7/$softPkg
tar zxvf $softPkg
cd $soft

cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DMYSQL_DATADIR=/data/mysql -DSYSCONFDIR=/etc -DDOWNLOAD_BOOST=1 -DWITH_BOOST=/usr/local/boost
make
make install
cd /usr/local/mysql
cp ./support-files/my-default.cnf /etc/my.cnf

cp ./support-files/mysql.server /etc/rc.d/init.d/mysqld
chmod 755 /etc/init.d/mysqld
chkconfig mysqld on

ln -s /usr/local/mysql/lib/mysql /usr/lib/mysql
ln -s /usr/local/mysql/include/mysql /usr/include/mysql
#ln -s /tmp/mysql.sock /var/lib/mysql/mysql.sock

######################
# vi /etc/my.cnf in [mysqld] section
# datadir = /data/mysql
#
# vi /etc/rc.d/init.d/mysqld #edit
# basedir = /usr/local/mysql #MySQL installation path
# datadir = /data/mysql #MySQl database data path
#
# Then go to /usr/local/mysql and execute
# cd /usr/local/mysql
# ./scripts/mysql_install_db --user=mysql --datadir=/data/mysql --basedir=/usr/local/mysql #Generate mysql system database
#
######################

######################
#
# mysql start: service mysqld start
# mysql stop: service mysqld stop
# mysql restart: service mysqld restart
#
# /usr/local/mysql/bin/mysqladmin -u root -p password "123456" #change root password
#
# reset root password
# 1. stop mysql
# 2. mysqld_safe --skip-grant-tables &
# 3. mysql -u root
# 	> use mysql;
# 	> update user set password=PASSWORD("NEW-ROOT-PASSWORD") where User='root';
# 	> flush privileges;
# 	> quit;
# 4. restart mysql
#
######################
