# Handle the root /zeppelin path and all API/App requests
location /zeppelin/ {
    # rewrite /zeppelin to /zeppelin/ to avoid 405 Method Not Allowed on POSTs
    rewrite ^/zeppelin$ /zeppelin/ permanent;

    proxy_pass http://zeppelin:8083/zeppelin/;

    # Standard Proxy Headers
    proxy_set_header Host $http_host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-NginX-Proxy true;
    
    # Context header helps Zeppelin understand its subpath
    proxy_set_header X-Forwarded-Context /zeppelin;

    # Timeouts (60s)
    client_max_body_size 30M;
    proxy_send_timeout 60000;
    proxy_read_timeout 60000;
    send_timeout 60000;

    # Intercept internal redirects and force them to the external HTTPS URL
    proxy_redirect http://zeppelin:8083/zeppelin/ https://metadata.naturalresources.wales/zeppelin/;

    ## NRW CORS logic
    proxy_hide_header 'Access-Control-Allow-Origin';
    proxy_hide_header 'Access-Control-Allow-Credentials';
    proxy_hide_header 'X-Frame-Options'; 

    if ($cors_origin != "") {
        add_header 'Access-Control-Allow-Origin' $cors_origin always;
        add_header 'Access-Control-Allow-Credentials' 'true' always;
        add_header 'Vary' 'Origin' always;
    }

    # Handle Preflight OPTIONS
    if ($request_method = 'OPTIONS') {
        add_header 'Access-Control-Allow-Origin' $cors_origin always;
        add_header 'Access-Control-Allow-Credentials' 'true' always;
        add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, DELETE, OPTIONS, HEAD' always;
        add_header 'Access-Control-Allow-Headers' 'DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Authorization,X-XSRF-TOKEN' always;
        add_header 'Access-Control-Max-Age' 1728000;
        add_header 'Vary' 'Origin' always;
        return 204;
    }

    # Frame and Cookie security
    add_header Content-Security-Policy "frame-ancestors 'self' https://*.naturalresources.wales https://*.cyfoethnaturiol.cymru;" always;
    
    # Map all variations of cookie paths to the secure subpath
    proxy_cookie_path /zeppelin "/zeppelin; Secure; SameSite=None";
    proxy_cookie_path / "/zeppelin; Secure; SameSite=None";
}

# Handle the persistent notebook connection
location /zeppelin/ws {
    proxy_pass http://zeppelin:8083/zeppelin/ws;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "Upgrade";

    # Pass Host and Origin so the session is validated
    proxy_set_header Host $http_host;
    proxy_set_header Origin $http_origin;

    # Re-apply the cookie path mapping for the WebSocket handshake
    proxy_cookie_path /zeppelin "/zeppelin; Secure; SameSite=None";
    proxy_cookie_path / "/zeppelin; Secure; SameSite=None";
}
