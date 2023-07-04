#!/usr/bin/bash

# pull and run clamav container; non-interactive for cron
# send logs to clamav-logs
# move infected files to clamav-quarantine

# make sure we have the environment variables available
set -a; source /home/astun/docker-geonetwork/.env-local; set +a
# make directories for quarantine and logs if they don't exist

mkdir -p /home/astun/clamav-logs /home/astun/clamav-quarantine

# unset $DOCKER_CONTENT_TRUST because the av container is not signed
unset DOCKER_CONTENT_TRUST

# set up output file from sample with environment variables and such like
cp output.txt.sample output.txt
sed -i -e "s|TOADDRESS|$EMAIL_ADDR|g" output.txt
sed -i -e "s|FROMADDRESS|$EMAIL_ADDR|g" output.txt
sed -i -e "s|SUBJECT|$GN_SITE_NAME antivirus output $(date +%Y-%m-%d)|g" output.txt

# change the first mounted volume to match the correct directory to scan
docker run --rm -v /var/lib/docker/volumes:/scan:ro -v /home/astun/clamav-logs:/logs:rw -v /home/astun/clamav-quarantine:/quarantine:rw tquinnelly/clamav-alpine --log=logs/output.txt --move=quarantine

# ensure the log file is created even if the container doesn't run for some reason
if [ ! -f /home/astun/clamav-logs/output.txt ]; then
        echo -e "Antivirus job ran, but no output was generated\n" >> /home/astun/clamav-logs/output.txt
fi

# append logs to output email file
cat /home/astun/clamav-logs/output.txt >> output.txt

# send email with output.txt as body
#curl -v --url smtps://$SMTP_URL_CLAMAV --ssl-reqd  --mail-from $EMAIL_ADDR --mail-rcpt $EMAIL_ADDR  --user $SMTP_USERNAME:$SMTP_PASSWORD -F '=</home/astun/clamav-logs/output.txt;encoder=quoted-printable' -H "Subject: $GN_SITE_NAME  antivirus output $(date +%Y-%m-%d)" -H "From: $EMAIL_ADDR <$EMAIL_ADDR>" -H "To: $EMAIL_ADDR <$EMAIL_ADDR>"
ssmtp metadata@astuntechnology.com < output.txt

# remove the old log file and output email file
rm /home/astun/clamav-logs/output.txt
rm /home/astun/docker-geonetwork/clamav/output.txt

# reset $DOCKER_CONTENT_TRUST
export DOCKER_CONTENT_TRUST=1

