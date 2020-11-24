#!/bin/bash
set -e

if [ "$1" = 'catalina.sh' ]; then

  if [ ! -d "$DATA_DIR" ]; then
        echo "$Data directory '$DATA_DIR' does not exist. Creating it..."
        mkdir -p "$DATA_DIR"
    fi

    #Set geonetwork data dir
    export CATALINA_OPTS="$CATALINA_OPTS -Dgeonetwork.dir=$DATA_DIR"

    #Setting host (use $DB_HOST if it's set, otherwise use "postgres")
    DB_HOST="${DB_HOST:-postgres}"
    echo "db host: $DB_HOST"

    #Setting port
    DB_PORT="${POSTGRES_DB_PORT:-5432}"
    echo "db port: $DB_PORT"

    if [ -z "$DB_USERNAME" ] || [ -z "$DB_PASSWORD" ]; then
        echo >&2 "you must set DB_USERNAME and DB_PASSWORD"
        exit 1
    fi


    #Create databases, if they do not exist yet (http://stackoverflow.com/a/36591842/433558)
    echo  "$DB_HOST:$DB_PORT:*:$DB_USERNAME:$DB_PASSWORD" > ~/.pgpass
    chmod 0600 ~/.pgpass
    if psql -h "$DB_HOST" -U "$DB_USERNAME" -p "$DB_PORT" -tqc "SELECT 1 FROM pg_database WHERE datname = '$DB_NAME'" | grep -q 1; then
        echo "Database '$DB_NAME' exists; skipping createdb"
    elif psql -h "$DB_HOST" -U "$DB_USERNAME" -p "$DB_PORT" -d "$DB_DATABASE" -tqc "SELECT 1 FROM pg_database WHERE datname = '$DB_DATABASE'" | grep -q 1;then
        echo "Database '$DB_DATABASE' already exist; skipping database creation"
    else
        echo "Database '$DB_DATABASE' doesn't exist. Creating it..."
        createdb -h "$DB_HOST" -U "$DB_USERNAME" -p "$DB_PORT" -O "$DB_USERNAME" "$DB_DATABASE"
    fi
    rm ~/.pgpass

    #Write connection string for GN
    cp -f /usr/local/tomcat/webapps/geonetwork/WEB-INF/config-db/jdbc.properties ~/jdbc.properties.new
    sed -ri '/^jdbc[.](username|password|database|host|port)=/d' ~/jdbc.properties.new
    cp -f ~/jdbc.properties.new /usr/local/tomcat/webapps/geonetwork/WEB-INF/config-db/jdbc.properties
    echo "jdbc.username=$DB_USERNAME" >> /usr/local/tomcat/webapps/geonetwork/WEB-INF/config-db/jdbc.properties
    echo "jdbc.password=$DB_PASSWORD" >> /usr/local/tomcat/webapps/geonetwork/WEB-INF/config-db/jdbc.properties
    echo "jdbc.database=$DB_DATABASE" >> /usr/local/tomcat/webapps/geonetwork/WEB-INF/config-db/jdbc.properties
    echo "jdbc.host=$DB_HOST" >> /usr/local/tomcat/webapps/geonetwork/WEB-INF/config-db/jdbc.properties
    echo "jdbc.port=$DB_PORT" >> /usr/local/tomcat/webapps/geonetwork/WEB-INF/config-db/jdbc.properties

    #Fixing an hardcoded port on the connection string (bug fixed on development branch)
#    sed -i -e 's#5432#${jdbc.port}#g' /usr/local/tomcat/webapps/geonetwork/WEB-INF/config-db/postgres.xml

    # change default database provider to postgresql
    cp -f /usr/local/tomcat/webapps/geonetwork/WEB-INF/config-node/srv.xml ~/srv.xml.new
    sed -i -e 's#<import resource="../config-db/${geonetwork.db.type:h2}.xml"/>#<!--<import resource="../config-db/${geonetwork.db.type:h2}.xml"/-->#g' ~/srv.xml.new && \
    sed -i -e 's#<!--<import resource="../config-db/postgres.xml"/>-->#<import resource="../config-db/postgres.xml"/>#g' ~/srv.xml.new
    cp -f ~/srv.xml.new /usr/local/tomcat/webapps/geonetwork/WEB-INF/config-node/srv.xml


	mkdir -p "$DATA_DIR"

	#Set geonetwork data dir
	export CATALINA_OPTS="$CATALINA_OPTS -Dgeonetwork.dir=$DATA_DIR"
	#export CATALINA_HOME="/usr/local/tomcat"

	 # Reconfigure Elasticsearch & Kibana if necessary
    if [ "$ES_HOST" != "localhost" ]; then
       sed -i "s#http://localhost:9200#${ES_PROTOCOL}://${ES_HOST}:${ES_PORT}#g" /usr/local/tomcat/webapps/geonetwork/WEB-INF/web.xml ;
      sed -i "s#http://localhost:9200#${ES_PROTOCOL}://${ES_HOST}:${ES_PORT}#g" /usr/local/tomcat/webapps/geonetwork/WEB-INF/config.properties ;
   fi;

   if [ "$ES_PROTOCOL" != "http" ] ; then
      sed -i "s#es.protocol=http#es.protocol=${ES_PROTOCOL}#" /usr/local/tomcat/webapps/geonetwork/WEB-INF/config.properties ;
    fi

    if [ "$ES_PORT" != "9200" ] ; then
      sed -i "s#es.port=9200#es.port=${ES_PORT}#" /usr/local/tomcat/webapps/geonetwork/WEB-INF/config.properties ;
    fi
    if [ "$ES_USERNAME" != "" ] ; then
      sed -i "s#es.username=#es.username=${ES_USERNAME}#" /usr/local/tomcat/webapps/geonetwork/WEB-INF/config.properties ;
    fi
    if [ "$ES_PASSWORD" != "" ] ; then
      sed -i "s#es.password=#es.password=${ES_PASSWORD}#" /usr/local/tomcat/webapps/geonetwork/WEB-INF/config.properties ;
    fi

    if [ "$KB_URL" != "http://localhost:5601" ]; then
      sed -i "s#kb.url=http://localhost:5601#kb.url=${KB_URL}#" /usr/local/tomcat/webapps/geonetwork/WEB-INF/config.properties ;
      sed -i "s#http://localhost:5601#${KB_URL}#g" /usr/local/tomcat/webapps/geonetwork/WEB-INF/web.xml ;
    fi

    sed -i "s#es.index.records_public=#es.index.records_public=gn-records#" /usr/local/tomcat/webapps/geonetwork/WEB-INF/config.properties ;
fi

exec "$@"
