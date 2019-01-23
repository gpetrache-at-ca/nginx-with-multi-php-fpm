#!/usr/bin/env bash

yum update -y && yum install -y epel-release

# Install Repo
yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm   #CentOS/RHEL 7
cp /vagrant-nfs/configs/nginx/nginx.repo /etc/yum.repos.d/nginx/repo

yum --enablerepo=remi -y install  \
    nginx \
    php55-php \
    php55-php-cli \
    php55-php-fpm \
    php56-php \
    php56-php-cli \
    php56-php-fpm \
    php73-php \
    php73-php-cli \
    php73-php-fpm

if [ ! -f /usr/bin/php ]; then
    ln -s /opt/remi/php56/root/usr/bin/php /usr/bin/php
fi
if [ ! -f /usr/bin/php-cgi ]; then
    ln -s /opt/remi/php56/root/usr/bin/php-cgi /usr/bin/php-cgi
fi
if [ ! -f /usr/bin/phar ]; then
    ln -s /opt/remi/php56/root/usr/bin/phar.phar /usr/bin/phar
fi
if [ ! -f /usr/bin/phpize ]; then
    ln -s /opt/remi/php56/root/usr/bin/phpize /usr/bin/phpize
fi

# Disable SElinux
setenforce 0

usermod -a -G apache root
cp -R /vagrant-nfs/app /var/www/html/app
chown -R root:apache /var/www/html/app

systemctl stop nginx
systemctl stop php56-php-fpm
systemctl stop php55-php-fpm
systemctl stop php73-php-fpm

mkdir -p /etc/nginx/sites-enabled/
cp /vagrant-nfs/configs/nginx/nginx.conf /etc/nginx/nginx.conf
cp /vagrant-nfs/configs/nginx/multi-php.v.local.conf /etc/nginx/sites-enabled/multi-php.v.local.conf
cp /vagrant-nfs/configs/php/fpm/56/www.conf /opt/remi/php56/root/etc/php-fpm.d/www.conf
cp /vagrant-nfs/configs/php/fpm/55/www.conf /opt/remi/php55/root/etc/php-fpm.d/www.conf
cp /vagrant-nfs/configs/php/fpm/73/www.conf /etc/opt/remi/php73/php-fpm.d/www.conf

systemctl start nginx
systemctl start php56-php-fpm
systemctl start php55-php-fpm
systemctl start php73-php-fpm

systemctl enable nginx
systemctl enable php56-php-fpm
systemctl enable php55-php-fpm
systemctl enable php73-php-fpm