# change portal in location and return line to match correct sub-portal root
location =  /geonetwork/northlincs-gov-uk/eng/csw {
	allow all;
	return 301 /geonetwork/northlincs-gov-uk/eng/csw-inspire?$query_string;
}

# change portal in location and return line to match correct sub-portal root
location   /geonetwork/northlincs-gov-uk/eng/csw-inspire {
	allow all;
	proxy_pass http://127.0.0.1:8080/geonetwork/northlincs-gov-uk/eng/csw-inspire;
}

	
# IP restriction if needed
# NOT USED FOR INSPIRE ONLY CUSTOMERS
# 1) add additional allow lines for customer's IP range
# 2) change portal in location and proxy_pass to match correct sub-portal root
location /geonetwork/northlincs-gov-uk {
	set_real_ip_from 10.100.0.0/16; # Load balancer do not change
	real_ip_header X-Forwarded-For;
	allow 52.215.14.121; # Astun VPN do not change
	allow 10.100.0.0/16; # Astun API gateway do not change
	allow 46.235.175.53; # North Lincs external IP
	allow 35.177.206.164; # North Lincs iShareGIS
	allow 3.9.51.251; # NE Lincs iShareGIS?
	allow 35.176.33.157; # N Lincs iShare Maps
	allow 52.56.69.255; # NE Lincs iShare Maps?
	deny all;
	proxy_pass http://127.0.0.1:8080/geonetwork/northlincs-gov-uk;
	proxy_set_header Host $host;
	proxy_intercept_errors on;
	#error_page 500 =404 @null;
	#error_page 301 =404 @null;
        proxy_connect_timeout       1800;
        proxy_send_timeout          1800;
        proxy_read_timeout         1800;
        send_timeout                1800;	

}








