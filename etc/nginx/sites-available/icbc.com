###############################################################
####### Configuracion Nginx para icbc ##########
###############################################################
upstream icbc {
    server  icbc.com;  
}

server {

  listen 443 ssl;
  server_name icbc.com;
  fastcgi_param HTTPS on;

  ssl_certificate /etc/ssl/server.pem;
  ssl_certificate_key /etc/ssl/server.key;
  ssl_protocols SSLv3 TLSv1 TLSv1.1 TLSv1.2;

  index index.php index.html;
  error_log  /var/log/nginx/error.log;
  access_log /var/log/nginx/access.log;
  root /var/www/html/www_icbc;

  location \ {
    proxy_pass  http://icbc;
    include /etc/nginx/includes/proxy.conf;
    try_files $uri $uri/ /index.php?q=$uri&$args;
  }
  location ~ \.php$ {
    fastcgi_pass store_icbc:9000;
    include /etc/nginx/includes/site.conf;
  }
  include /etc/nginx/includes/generalsite.conf;
}