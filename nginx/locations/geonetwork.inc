#  workaround for preventing malicious requests - resolves SUPPORT-23128
location /geonetwork/doc/api/index.html {
    if ($query_string ~ configUrl=) {
        return 301 $uri;
    }
    proxy_pass http://geonetwork:8080;
}

# workaround for security vulnerability of WFS Indexing - resolves MET-790
location ~ /api/workers/data/wfs/[0-9a-z]+ { deny all; }

# prevent access to stack trace endpoint
location ~ /geonetwork/jolokia/read/[0-9a-z]+ { deny all; }

location /geonetwork {

# default geonetwork in docker

	proxy_set_header Host $host;
	proxy_set_header X-Real-IP $remote_addr;
	proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
	proxy_pass      http://geonetwork:8080;

	# update headers to prevent duplication
	# the default values are set in default.local
	add_header X-Frame-Options $hdr_x_frame_options;


	# add security headers for NRW 
	add_header Content-Security-Policy "script-src 'self' 'unsafe-inline' 'unsafe-eval' https://*.googletagmanager.com; img-src 'self' https://*.google-analytics.com https://*.googletagmanager.com https://*.openstreetmap.org; connect-src 'self' https://*.google-analytics.com https://*.analytics.google.com https://*.googletagmanager.com;";

	# the default values for the headers below are set in default.local
	add_header Strict-Transport-Security $hdr_strict_transport_security;
	add_header X-Content-Type-Options $hdr_x_content_type_options;
	add_header Permissions-Policy $hdr_permissions_policy;
	add_header Referrer-Policy $hdr_referrer_policy;
	add_header Cross-Origin-Embedder-Policy $hdr_coep;
	add_header Cross-Origin-Opener-Policy $hdr_coop;
	add_header Cross-Origin-Resource-Policy $hdr_corp;

	#limit_req zone=ip burst=100 delay=75;

	client_max_body_size 30M;
	proxy_send_timeout         360s;
	proxy_read_timeout         360s;
	proxy_connect_timeout      360s;
	send_timeout               360s;

	proxy_intercept_errors on;

	error_page 404 /custom_404.html;
	error_page 401 /custom_401.html;
	error_page 500 /50x.html;
	error_page 502 /50x.html;

	if ($http_x_forwarded_proto = "http") {
				rewrite ^/(.*)$ https://$host$request_uri;
			}
}

location = /custom_404.html {
			root /usr/share/nginx/html;
			internal;
}

location = /custom_401.html {
			root /usr/share/nginx/html;
			internal;
}

location = /50x.html {
			root /usr/share/nginx/html;
			internal;
}
