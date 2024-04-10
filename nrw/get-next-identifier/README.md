# Instructions for creating get-next-identifier pages

## PostgreSQL

Check there's a read-only user with permission to connect to the database and view all tables in public and custom schema. If not:

	GRANT CONNECT ON DATABASE db TO readonly_user;
	GRANT USAGE ON SCHEMA public TO readonly_user;
	GRANT SELECT ON ALL TABLES IN SCHEMA public TO readonly_user;
	GRANT USAGE ON SCHEMA custom TO readonly_user;
	GRANT SELECT ON ALL TABLES IN SCHEMA custom TO readonly_user;
	ALTER DEFAULT PRIVILEGES IN SCHEMA public
	GRANT SELECT ON TABLES TO readonly_user;
	ALTER DEFAULT PRIVILEGES IN SCHEMA custom
	GRANT SELECT ON SEQUENCES TO readonly_user;

## Zeppelin

Enable `docker-compose-zeppelin.yml` in `.env`

* Go to zeppelin interpreter page and check that the jdbc interpreter `default.url`, `default.user` and `default.password` are filled in (they should be)
* Import the notebook ./NRW Next Identifier_2JUBZJ4VH.zpln
* Check the two paragraphs run without error and that the result is sensible

## GeoNetwork

In admin console -> settings create a static page with the following information:

* Language: English
* Page identifier: get-next-identifier
* Page label: Get Next Record Identifier
* Format: HTML content displayed embedded in the app
* Page content: *copy text from ../get-next-identifier-pagecontent.txt*
* Page section: SUBMENU
* Sttatus: Visible to logged users

