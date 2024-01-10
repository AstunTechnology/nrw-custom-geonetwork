location /keycloak {


	# forward keycloak requests to port 8180

	proxy_pass http://keycloak:8180;
	proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
	}