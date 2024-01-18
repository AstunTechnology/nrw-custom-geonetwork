# Docker Geonetwork NRW TEST BRANCH

Instructions for deploying a customised GeoNetwork install (from a web archive file) including the following supporting software and services:

* ElasticSearch
* Kibana
* Zeppelin (optional)
* Nginx
* PostgreSQL/PostGIS (mandatory but can be RDS)
* Datahub (optional)
* OGC-API records service (optional)

It includes files for building and testing GeoNetwork locally, and also on Docker.

More detailed documentation on the various components can be found in [Confluence](https://astuntech.atlassian.net/wiki/spaces/MET/pages/2831286291/Other+components-+setup+and+usage).

## QUICK START

**For local or server build optionally including Postgres and Zeppelin**

###

Install (please don't use the snap version for installing):

* docker
* docker-compose (see below for instructions)
* ssmtp (only needed on server- for running clamav)

### Prep

* Clone this repository locally and check out the correct branch for the client you are working for.
* Look at the `services\geonetwork\volumes` section of `docker-compose.yml` and ensure that you match the file structure for any volumes that are not inside this repository, e.g. those where the local path starts with `../`. These are generally schema plugins and can be found on [Github](https://github.com/astuntechnology).
* Clone the required repositories to the same level in your file system as `docker-geonetwork` and match the folder names so that you can refer to the mounted files using the location e.g. `../iso19139.gemini23/...`.

### Database Prep- Existing PostgreSQL server (i.e. RDS)

* If you already have a postgres server running then create a user for geonetwork with at least database creation privileges.
* Copy `.env-local.sample` to `.env-local` and edit the following credentials:

```
POSTGRES_DB_NAME=
POSTGRES_DB_HOST=
POSTGRES_DB_PASSWORD=
POSTGRES_DB_USERNAME=
POSTGRES_DB_PORT=
```

* Leave the other credentials as is for the moment.
* From the root `docker-geonetwork` directory run:

```
docker-compose --env-file .env-local up
```
  
* You only need to include Zeppelin if you're specifically testing it, but if you do, make sure its docker-compose file `docker-compose-zeppelin.yml` is included in your `COMPOSE_FILE` variable at the top of `.env-local`

### Database Prep- using included Postgres container

* If you need to use the included Postgres container (because you don't have a postgres server running) then copy `.env-local.sample` to `.env-local` and edit the following credentials. Note that in this scenario `POSTGRES_DB_HOST` has the container name `postgres` rather than `localhost`.

```
POSTGRES_DB_NAME=
POSTGRES_DB_HOST=postgres
POSTGRES_DB_PASSWORD=
POSTGRES_DB_USERNAME=
POSTGRES_DB_PORT=5432
```

* Make sure that the docker-compose file for Postgres `docker-compose-postgres.yml` is included in your `COMPOSE_FILE` variable at the top of `.env-local`
* Start up the containers using:

```
docker-compose --env-file .env-local up
```

* You only need to include Zeppelin if you're specifically testing it, but if you do, make sure its docker-compose file `docker-compose-zeppelin.yml` is included in your `COMPOSE_FILE` variable at the top of `.env-local`

### Datahub Prep

* Make sure that the relevant service section in the `docker-compose.yml` is not commented out (i.e. that you have `services\datahub`)
* Provide GeoNetwork with the server's external IP address in `.env-local` under:

```
# Datahub
DH_HOST=
```

### OGC-API records service Prep

* Make sure that the relevant service section in the `docker-compose.yml` is not commented out (i.e. that you have `services\ogc-api-records-service`)
* For Gemini records a couple of extra files need to be added as volume overrides in the `services\ogc-api-records-service` section of `docker-compose.yml`:

```
volumes:
  - ./ogc-api/copy/copy-iso19139.gemini23.xsl:/workspace/BOOT-INF/classes/xslt/ogcapir/formats/copy/copy-iso19139.gemini23.xsl
  - ./ogc-api/copy/copy-iso19139.gemini22.xsl:/workspace/BOOT-INF/classes/xslt/ogcapir/formats/copy/copy-iso19139.gemini22.xsl
```

## ADVANCED

If all you're doing is running GeoNetwork locally for dev purposes then the quick start section above is all you need.

If you're starting from scratch with a new client then there's a whole bunch of additional prep that you need to do, to set up repositories and such like. Exactly how much work you need to do depends on what the client needs access to, in other words if they want to see the code for their own development purposes.

### Is the client likely to want to access to core geonetwork code and/or the docker customisations and config?

**If the answer to the above is NO (default):**

* Create a new branch of <https://bitbucket.org/astuntech/core-geonetwork/src/3.10.x> with the format `custom/clientshortname` (eg `custom/scotgov`).
* Create a branch of this repository with the form `clientshortname.geonetworkversion` (eg `scotgov.3.10.x`).

*Note that the 3.10.x and 3.12.x branches are rectified with <https://github.com/geonetwork/core-geonetwork> 3.10.x and 3.12.x about once a month- by pulling changes from core into a local copy, pushing them to this repository and doing a pull request per custom branch to get the custom branches up to date. Generally this works just fine but occasionally there's a conflict- in which case bitbucket provides instructions on how to resolve locally.*

*Note that so far we didn't need to make any core changes to catalogs running on version 4.2.x, therefore there is no branch for this in <https://bitbucket.org/astuntech/core-geonetwork/src>, so you will need to create one if needed and rectify it with <https://github.com/geonetwork/core-geonetwork/tree/main> by pulling changes from core into a local copy, pushing them to this repository and doing a pull request per custom branch to get the custom branches up to date. Generally this works just fine but occasionally there's a conflict- in which case bitbucket provides instructions on how to resolve locally.*

**If the answer is YES:**

* Create a new branch of <https://github.com/AstunTechnology/custom-geonetwork> with the format `clientshortname-geonetworkversion`
* Create new custom repository on GitHub for the docker code, looking like, and named like <https://github.com/AstunTechnology/os-custom-geonetwork> and leave, your work is done here

*Our custom-geonetwork repository master branch on GitHub is a straight fork of the main core geonetwork one so can be brought up to date using a pull request in the normal way.*

### Are you going to need to make any changes to GeoNetwork that require building from source?

**If NO (default):**

* Set the correct GeoNetwork image in the `services\geonetwork` section of `docker-compose.yml`:
  
```
image: geonetwork:latest
```

**If YES:**

* It is **HIGHLY** recommended and preferred that you try not to make any changes and that you try to find a different way (maybe add docker volume overrides to files if possible; if it's a bug- or a more general issue with GeoNetwork- try to open a Github issue instead and hope it gets fixed by the developers in the core code). But if you absolutely have no way around and you must make core changes get yourself a big stick, loads of patience and a stress ball.

* You'll be working locally so use `docker-compose.yml` and comment out the `services\geonetwork\images` lines. Add `build` and `context` lines.

```
build:
  context: .
  dockerfile: Dockerfile.local
```

* **RECOMMENDED** build and test GeoNetwork locally so that you have a working geonetwork.war file, and copy it into the `docker-geonetwork/geonetwork` folder. Then use `Dockerfile.local` to build your image.
* If you absolutely must try to build from a war file on Bitbucket then think again, but if you absolutely have to then use Dockerfile.bitbucket for the build and follow the additional instructions below
* Note that a local build of GeoNetwork can't be deployed to EC2 so you'll need to publish it to the AWS Public ECR container registry first.

## Local Development

### Requirements

* Docker
* Docker-Compose

**How to install docker etc on an Ubuntu box:**

```
sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
wget -qO - https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
sudo apt -y install docker-ce

sudo systemctl start docker # start docker (if you get "System has not been booted with systemd as init system (PID 1). Can't operate.", then use `service docker start`)
sudo systemctl enable docker # enable it as a service
sudo usermod -aG docker $(whoami) # add your user to the docker group so commands don't have to be prefixed with sudo

sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version # check it's working
```

For instructions on installing docker on Amazon Linux see this [GitHub Gist](https://gist.github.com/archaeogeek/97bb590e4cbc75a3d63a5b4de9bb0394).

### Set Up

* Clone <https://bitbucket.org/astuntech/docker-geonetwork> locally:

```
git clone git@bitbucket.org:astuntech/docker-geonetwork.git
cd docker-geonetwork
```

* Get an app password from bitbucket with **read** access to **repositories** and save it somewhere useful. You'll need this if you're going to try to use a custom war file downloaded from bitbucket later. If you've already done this for another Astun repo, you can clone over HTTPS with `git clone https://[BitBuckerUsername]@bitbucket.org/astuntech/docker-geonetwork.git`

### Running GeoNetwork locally using a standard image

As in the Quick Start guide above, ensure you have the schema plugins and additional customisation files referenced in the `services\geonetwork\volumes` section cloned, using the correct branch, and available at the same relative location in your filesystem as `docker-geonetwork`.

Copy `.env-local.sample` to `.env-local` and fill in the credentials.

In `docker-compose.yml` modify `services\geonetwork\images` to match the image you wish to download. Keep `build` and `context` commented out then run:

```
docker-compose -f docker-compose.yml --env-file .env-local up
```

Add the `-d` parameter if you want it to run quietly.

### Building and running GeoNetwork locally using a war file

Ensure your war file is locally tested, then copy it into `docker-geonetwork/geonetwork`.

Ensure you have the schema plugins and additional customisation files referenced in the `services\geonetwork\volumes` section cloned, using the correct branch, and available at the same relative location in your filesystem as `docker-geonetwork`.

Copy `.env-local.sample` to `.env-local` and fill in the credentials.

Build from the root `docker-geonetwork` folder using:

```
docker build -f Dockerfile.local .
```

Once the image is built, ensure you're using `build` and `context` rather than `image` in your `docker-compose.yml` then run docker-compose as above.

### Deploying to AWS Container Registry

Build image and check it's present:

```
docker build --no-cache . -t [sensible-name-for-image]
docker images -a
```

Get login details from AWS ECR and temporarily authenticate your local docker. Note that the region is always us-east-1, and the profile is optional, but if included must be as configured in your aws credentials on your local computer

```
aws ecr-public get-login-password --region us-east-1 --profile [yourprofile] | docker login --username AWS --password-stdin public.ecr.aws
```

Tag your image with the correct aws ecr-public repository

```
docker tag [sensible-name-for-image] public.ecr.aws/[registryid]/[sensible-name-for-image]
```

Push the image to ecr-public:

```
docker push public.ecr.aws/[registryid]/[sensible-name-for-image]
```

Then in your docker-compose file refer to this image for the geonetwork service

## Checking everything is running correctly

The docker-compose files contain `healthcheck` sections for each service. If you run `docker ps -a` (when running locally) each service should report a healthy state. The commands being run in the healthcheck can generally be run manually to double-check the responses.


## Docker Security Tests

See <https://astuntech.atlassian.net/wiki/spaces/ITA/pages/1992097906/Docker+security+testing>

## Antivirus

SSH onto the server running the containers. Ensure the correct credentials are completed in the SMTP section of `docker-geonetwork/.env-local` (or whatever `.env` file you're using). Note that the email address will be used as both the `FROM` address and the `TO` address, and if you are using Amazon SES then it needs to be a verified email.

Edit `docker-geonetwork/clamav/run-clamav.sh` to scan the correct volume (the default is `/var/lib/docker/volumes`). If your login user is not `astun` then do a find and replace with the correct username to set the folder paths.

**Switch to the root user.**

Ensure the script is executable (`chmod a+x docker-geonetwork/clamav/run-clamav.sh`) and then run it. Test it manually first to pick up issues with things like email credentials and directory access permissions.

The shell-script can be set to run as a scheduled task. There's an example crontab file in the `clamav` folder. The folder path might need editing if the standard user is not `astun`. You can load it using the following syntax (as root):

 crontab clamav.crontab

* For a tame virus file for testing purposes go to <https://www.eicar.org/?page_id=3950>.
