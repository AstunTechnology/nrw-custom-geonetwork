#!/usr/bin/bash

# pull and run clamav container; non-interactive for cron
# send logs to clamav-logs
# move infected files to clamav-quarantine

# set the correct home directory
home_directory=/home/astun

# set the email address to ONLY reiceive alerts in case of viruses being found
alert_email=support@astuntechnology.com

# make sure we have the environment variables available
set -a; source $home_directory/docker-geonetwork/.env; set +a

# make directories for quarantine and logs if they don't exist
mkdir -p $home_directory/clamav-logs $home_directory/clamav-quarantine

# unset $DOCKER_CONTENT_TRUST because the av container is not signed
unset DOCKER_CONTENT_TRUST

# change to correct directory
cd $home_directory/docker-geonetwork/clamav

# set custom ssmtp.conf
cat << EOF > ssmtp.conf
mailhub=$SMTP:$SMTP_PORT
AuthUser=$SMTP_USERNAME
AuthPass=$SMTP_PASSWORD
AuthMethod=LOGIN
UseSTARTTLS=YES
useTLS=YES
Hostname=uat.astuntechnology.com
FromLineOverride=YES
TLS_CA_File=/etc/pki/tls/certs/ca-bundle.crt
EOF

# set up output file from sample with environment variables and such like
cp output.txt.sample output.txt
sed -i -e "s|TOADDRESS|$EMAIL_ADDR|g" output.txt
sed -i -e "s|FROMADDRESS|$EMAIL_ADDR|g" output.txt
sed -i -e "s|SUBJECT|$GN_SITE_NAME antivirus output $(date +%Y-%m-%d)|g" output.txt

# change the first mounted volume to match the correct directory to scan
docker run --rm -v /var/lib/docker/volumes:/scan:ro -v $home_directory/clamav-logs:/logs:rw -v $home_directory/clamav-quarantine:/quarantine:rw tquinnelly/clamav-alpine --log=logs/logs.txt --move=quarantine

# ensure the log file is created even if the container doesn't run for some reason
if [ ! -f $home_directory/clamav-logs/logs.txt ]; then
        echo -e "Antivirus job may have ran, but no logs were generated\n" >> output.txt
fi

# append logs to output email file
cat $home_directory/clamav-logs/logs.txt >> output.txt

# add scan summary to a separate file
tail -11 $home_directory/clamav-logs/logs.txt > scan_summary.txt

scan_summary="scan_summary.txt"

# extract the number of infected files from the scan summary
infected_files=$(grep "Infected files:" "$scan_summary" | awk '{print $3}')

# check if the number of infected files is greater than 0
if [ "$infected_files" -gt 0 ]; then
        # set up infected output file from sample with environment variables and such like
        cp infected_output.txt.sample infected_output.txt
        sed -i -e "s|TOADDRESS|$alert_email|g" infected_output.txt
        sed -i -e "s|FROMADDRESS|$EMAIL_ADDR|g" infected_output.txt
        sed -i -e "s|SUBJECT|ALERT! $GN_SITE_NAME has infected files $(date +%Y-%m-%d)|g" infected_output.txt

        echo -e "WARNING: $infected_files infected files on $GN_SITE_NAME MUST be moved to quarantine!\n\nAntivirus Log" >> infected_output.txt

        cat $home_directory/clamav-logs/logs.txt >> infected_output.txt

        # send alert email with infected_output.txt as body
        /usr/sbin/ssmtp -v -C ssmtp.conf $alert_email < infected_output.txt

fi

# send email with output.txt as body to metadata email group
/usr/sbin/ssmtp -v -C ssmtp.conf metadata@astuntechnology.com < output.txt

# remove all files created
rm $home_directory/clamav-logs/logs.txt ssmtp.conf scan_summary.txt output.txt infected_output.txt

# reset $DOCKER_CONTENT_TRUST
export DOCKER_CONTENT_TRUST=1
