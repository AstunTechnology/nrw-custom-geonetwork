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
	# the default values are set in default.local
	add_header Strict-Transport-Security $hdr_strict_transport_security;
	add_header X-Content-Type-Options $hdr_x_content_type_options;
	add_header Permissions-Policy $hdr_permissions_policy;

	#limit_req zone=ip burst=100 delay=75;
	client_max_body_size 30M;
	proxy_send_timeout          36000;
	proxy_read_timeout         36000;
	send_timeout                36000;
	proxy_intercept_errors on;
	error_page 404 /custom_404.html;
	if ($http_x_forwarded_proto = "http") {
				rewrite ^/(.*)$ https://$host$request_uri;
			}
}

location = /custom_404.html {
			root /usr/share/nginx/html;
			internal;
    	}