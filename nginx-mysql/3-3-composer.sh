#!/bin/bash

#cd /usr/local
curl -sS https://getcomposer.org/installer | php
php composer.phar

mv composer.phar /usr/local/bin/composer