server {

    # redirect welsh URL plus rewrite URL shown in header
    listen 80;
    listen  [::]:80;
    root /var/www/html;
    server_name test.metadata.cyfoethnaturiol.cymru;

    # default geonetwork in docker

    location /geonetwork {

        add_header X-Frame-Options "SAMEORIGIN" always;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass      http://geonetwork:8080;
        add_header Cache-Control "no-store";
        #limit_req zone=ip burst=100 delay=75;
        client_max_body_size 30M;
        proxy_send_timeout          36000;
        proxy_read_timeout         36000;
        send_timeout                36000;
        proxy_intercept_errors on;
        error_page 404 /404.html;
        #if ($http_x_forwarded_proto = "http") {
         #           rewrite ^/(.*)$ https://$host$request_uri;
         #      }
    }

    location = / {
        return 301 /geonetwork/cym/cym/catalog.search;
    }

    
    access_log /var/log/nginx/cy-access.log;
    error_log /var/log/nginx/cy-error.log;
}
