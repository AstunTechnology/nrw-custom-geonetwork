# syntax = docker/dockerfile:1.0-experimental
FROM tomcat:8.5-jdk8

#ENV CATALINA_HOME=/var/lib/tomcat8
ENV GN_FILE geonetwork.war
ENV DATA_DIR=$CATALINA_HOME/webapps/geonetwork/WEB-INF/data
ENV JAVA_OPTS="-Djava.security.egd=file:/dev/./urandom -Djava.awt.headless=true -server -Xms512m -Xmx2024m -XX:NewSize=512m -XX:MaxNewSize=1024m -XX:+UseConcMarkSweepGC"

ENV ES_HOST elasticsearch
ENV ES_PROTOCOL http
ENV ES_PORT 9200
ENV ES_USERNAME ""
ENV ES_PASSWORD ""
ENV KB_URL http://kibana:5601

WORKDIR $CATALINA_HOME/webapps

RUN --mount=type=secret,id=creds,dst=/run/secrets/creds.txt \
	 curl -fSL -o ${GN_FILE} \
	 -K /run/secrets/creds.txt \
     "https://api.bitbucket.org/2.0/repositories/astuntech/geonetwork-build/downloads/geonetwork.war" && \
     mkdir -p geonetwork && \
     unzip -e ${GN_FILE} -d geonetwork && \
     rm ${GN_FILE}

#Set geonetwork data dir
COPY ./docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["catalina.sh", "run"]

