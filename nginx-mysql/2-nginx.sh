#!/bin/bash

soft=nginx-1.9.4
softPkg=$soft.tar.gz


# install pcre for nginx
cd /usr/local/src
wget http://sourceforge.net/projects/pcre/files/pcre/8.35/pcre-8.35.tar.gz
tar zxvf pcre-8.35.tar.gz
cd pcre-8.35
./configure --prefix=/usr/local/pcre
make
make install


# install nginx
groupadd www
useradd -g www www -s /bin/false

cd /usr/local/src/
wget http://nginx.org/download/$softPkg
tar zxvf $softPkg
cd /usr/local/src/$soft
./configure --prefix=/usr/local/nginx \
--without-http_memcached_module \
--user=www \
--group=www \
--with-http_stub_status_module \
--with-openssl=/usr/ \
--with-pcre=/usr/local/src/pcre-8.35

make
make install

echo '#!/bin/bash
# nginx Startup script for the Nginx HTTP Server
# it is v.0.0.2 version.
# chkconfig: - 85 15
# description: Nginx is a high-performance web and proxy server.
#              It has a lot of features, but it is not for everyone.
# processname: nginx
# pidfile: /var/run/nginx.pid
# config: /usr/local/nginx/conf/nginx.conf
nginxd=/usr/local/nginx/sbin/nginx
nginx_config=/usr/local/nginx/conf/nginx.conf
nginx_pid=/var/run/nginx.pid
RETVAL=0
prog="nginx"
# Source function library.
. /etc/rc.d/init.d/functions
# Source networking configuration.
. /etc/sysconfig/network
# Check that networking is up.
[ ${NETWORKING} = "no" ] && exit 0
[ -x $nginxd ] || exit 0
# Start nginx daemons functions.
start() {
if [ -e $nginx_pid ];then
   echo "nginx already running...."
   exit 1
fi
   echo -n $"Starting $prog: "
   daemon $nginxd -c ${nginx_config}
   RETVAL=$?
   echo
   [ $RETVAL = 0 ] && touch /var/lock/subsys/nginx
   return $RETVAL
}
# Stop nginx daemons functions.
stop() {
        echo -n $"Stopping $prog: "
        killproc $nginxd
        RETVAL=$?
        echo
        [ $RETVAL = 0 ] && rm -f /var/lock/subsys/nginx /var/run/nginx.pid
}
# reload nginx service functions.
reload() {
    echo -n $"Reloading $prog: "
    #kill -HUP `cat ${nginx_pid}`
    killproc $nginxd -HUP
    RETVAL=$?
    echo
}
# See how we were called.
case "$1" in
start)
        start
        ;;
stop)
        stop
        ;;
reload)
        reload
        ;;
restart)
        stop
        start
        ;;
status)
        status $prog
        RETVAL=$?
        ;;
*)
        echo $"Usage: $prog {start|stop|restart|reload|status|help}"
        exit 1
esac
exit $RETVAL
' >> /etc/init.d/nginx

chmod 775 /etc/rc.d/init.d/nginx
chkconfig nginx on

#copy files
dir=`pwd`
mkdir -p /usr/local/nginx/conf/vhosts

cat >> /usr/local/nginx/conf/gzip.conf <<EOF
gzip          on;
gzip_min_length     1024;
gzip_comp_level     5;
gzip_buffers        8 16k;
gzip_http_version   1.1;
gzip_proxied        any;
gzip_types        text/plain text/javascript application/x-javascript text        /css text/xml application/xml application/atom-xml application/rss-xml a        pplication/xhtml-xml image/svg-xml text/x-json application/json;
gzip_disable        "msie6";
EOF

cat >> /usr/local/nginx/conf/vhosts/website.conf <<EOF
server {
    listen  80;
    server_name  www.lxpgw.com;
    root  /home/www.lxpgw.com/frontend/web;
    index index.php;
    charset utf-8;

    error_log logs/www.lxpgw.com.log;

    location / {
      try_files $uri $uri/ /index.php?$args;
    }

    error_page   404  /pages/404.html;

    error_page   500 502 503 504  /50x.html;
    #location = /50x.html {
      #root html;
    #}
    if ($http_user_agent ~* (YYSpider)) {
       return 403;
    }
    location ~ \.(js|css|png|jpg|gif|ico|pdf|mov|fla|zip|rar|ttf|woff|woff2|eot|svg|otf|tpl|json)$ {
      add_header Access-Control-Allow-Origin *;
      #try_files $uri = 404;
    }

    location ~ \.php$ {
      try_files $uri = 404;
      fastcgi_pass  127.0.0.1:9000;
      fastcgi_index index.php;
      fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
      include   fastcgi_params;
    }

    location ~ /\.(ht|svn|git) {
      deny all;
    }
    location ~ ^/status$ {
      include fastcgi_params;
      fastcgi_pass 127.0.0.1:9000;
      fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
}
EOF

######################
#
# close server tokens:
# server_tokens off;
#
# nginx start: service nginx start
# nginx stop: service nginx stop
# nginx restart: service nginx restart
#
#
#
#
######################


