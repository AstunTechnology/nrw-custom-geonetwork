server {

    # redirect welsh URL plus rewrite URL shown in header
    listen 80;
    listen  [::]:80;
    root /var/www/html;
    server_name metadata.cyfoethnaturiol.cymru;

    # redirect welsh URLs to the geonetwork/cym URL
    location /geonetwork/cym {
        rewrite ^/cym(.*)$  https://metadata.naturalresources.wales/geonetwork/eng$1 permanent;
    }

    # Redirect all other requests to the English site
    location / {
        rewrite ^/(.*)$ https://metadata.naturalresources.wales/$1 permanent;
    }

    location ^~ /files {
        alias /var/www/html/files;
    }
    
    include locations/*.inc;

    include sites-available/*.inc;

    access_log /var/log/nginx/cy-access.log;
    error_log /var/log/nginx/cy-error.log;
}