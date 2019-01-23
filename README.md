# nginx-with-multi-php-fpm

### Requirements:
- VirtualBox
- Vagrant
- DnsMasq or alternative

### Pre-Installation:
Add the following to your host file and dnsmasq.
| IP Address | Hostname |
| --- | --- |
| 192.168.168.101 | multi-php.v.local |

### Installation:
```sh
git clone git@github.com:gpetrache-at-ca/nginx-with-multi-php-fpm.git vm
cd vm
vagrant up --provision
```

### Usage:
Use domain in your browser to view desired php version.
| Domain | PHP Version |
| ------ | ------ |
| php55.multi-php.v.local | v5.5 |
| php56.multi-php.v.local | v5.6 |
| php73.multi-php.v.local | v7.3 |

### Configuration:
##### Files:
- [PHP-FPM 5.5](https://github.com/gpetrache-at-ca/nginx-with-multi-php-fpm/blob/master/configs/php/fpm/55/www.conf)
- [PHP-FPM 5.6](https://github.com/gpetrache-at-ca/nginx-with-multi-php-fpm/blob/master/configs/php/fpm/56/www.conf)
- [PHP-FPM 7.3](https://github.com/gpetrache-at-ca/nginx-with-multi-php-fpm/blob/master/configs/php/fpm/73/www.conf)
- [Nginx](https://github.com/gpetrache-at-ca/nginx-with-multi-php-fpm/blob/master/configs/nginx/multi-php.v.local.conf)
##### Notes:
- PHP-FPM listens to different ports

| PHP Version | IP and Port |
| ------ | ------ |
| v5.5 | 127.0.0.1:9055 |
| v5.6 | 127.0.0.1:9000 |
| v7.3 | 127.0.0.1:9073 |

- Nginx implements upstream for multiple php-fpm instance.
```
    upstream php56 {
        server 127.0.0.1:9000;
    }
    upstream php55 {
        server 127.0.0.1:9055;
    }
    upstream php73 {
        server 127.0.0.1:9073;
    }
    server (
        ...
        set $phpfpm "php56";
        if ($domain ~ "^(.*)\.multi-php\.v\.local$") {
            set $phpfpm $1;
        }
        ...
        location ~ ^(.+\.php)(?:/.+)?$ {
            fastcgi_pass $phpfpm;
            ...
        }
    )
```