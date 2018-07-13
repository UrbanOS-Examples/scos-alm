#!/bin/bash

#fetch certbot to use lets encrypt
wget https://dl.eff.org/certbot-auto

#generate certificate
chmod +x certbot-auto
./certbot-auto certonly --agree-tos --email scos_alm_account@pillartechnology.com --standalone -d ${dns_name} -n

apt-get update
apt-get install -y nginx

cat <<EOF >/etc/nginx/sites-available/jenkins-relay
server {
  listen 80;

  server_name ${dns_name};

  return 301 https://\$server_name\$request_uri;
}

server {
  listen 443 ssl;

  server_name ${dns_name};
  ssl_certificate /etc/letsencrypt/live/${dns_name}/fullchain.pem; # managed by Certbot
  ssl_certificate_key /etc/letsencrypt/live/${dns_name}/privkey.pem; # managed by Certbot
  ssl_protocols       TLSv1.1 TLSv1.2;
  ssl_ciphers         HIGH:!aNULL:!MD5;

  location "/" {
    return 403;
  }

  location "/github-webhook" {
    proxy_pass http://${jenkins_host}:${jenkins_port}/github-webhook/;
    limit_except POST {
      deny all;
    }
  }
}
EOF

ln -s /etc/nginx/sites-available/jenkins-relay /etc/nginx/sites-enabled/jenkins-relay

service nginx restart

echo "0 0,12 * * * python -c 'import random; import time; time.sleep(random.random() * 3600)' && /certbot-auto renew" >> /root/cert-renew.cron
crontab /root/cert-renew.cron