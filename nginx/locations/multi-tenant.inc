location = / {
	return 301 https://uat.metadata.astuntechnology.com/geonetwork/srv/api/sources;
	allow all;
}

location = /geonetwork/srv/api/sources {
	allow all;
	proxy_pass http://geonetwork:8080/geonetwork/srv/api/sources;	
}

# IP restriction if needed
#location /geonetwork/srv {
#	set_real_ip_from 10.100.0.0/16; # Load balancer do not change
#	real_ip_header X-Forwarded-For;
#	allow 52.215.14.121; # Astun VPN do not change
#	allow 54.229.227.107; # geohealthcheck and sitemonitor
#	deny all;
#	proxy_pass http://geonetwork:8080/geonetwork/srv;
#	proxy_set_header Host $host;
#	proxy_intercept_errors on;
#	error_page 500 =404 @null;
#	error_page 301 =404 @null;
#	proxy_connect_timeout       1800;
#	proxy_send_timeout          1800;
#	proxy_read_timeout         1800;
#	send_timeout                1800;	
#
#	}
