/* create database <database-name>
\c <database-name>
create extension hstore
create extension postgis
restore public schema dump
run audit.sql 

psql -h geonetwork310.ccm2l2tvcpxk.eu-west-1.rds.amazonaws.com -p 5432 -U geonet_root -W -d geonetwork310
create database geonetwork423
create database geohealthcheck423
\c geonetwork423
create extension postgis
create extension hstore
alter database geonetwork423 owner to geonetwork
alter database geohealthcheck423 owner to geonetwork

pg_restore -h geonetwork310.ccm2l2tvcpxk.eu-west-1.rds.amazonaws.com -d geonetwork423 -F custom -U geonetwork -v geonetwork310.dump

psql -h geonetwork310.ccm2l2tvcpxk.eu-west-1.rds.amazonaws.com -p 5432 -U geonetwork -W -d geonetwork423*/


/* get rid of stuff relating to the dcat schema */
delete from validation where metadataid in (select id from metadata where schemaid = 'dcat-ap');
delete from metadata where schemaid = 'dcat-ap';
delete from statusvaluesdes where iddes = 63;
delete from statusvalues where id = 63;
delete from settings where name like '%passwordEnforcement%';

/* update to use new names for Gemini 2.3 schematron files */
delete from schematroncriteria where group_schematronid in (select id from schematron where schemaname = 'dcat-ap');
delete from schematroncriteriagroup where schematronid in (select id from schematron where schemaname = 'dcat-ap');
delete from schematrondes where label like '%dcat%';
delete from schematron where schemaname = 'dcat-ap';
delete from schematrondes where label = 'schematron-rules-GEMINI_2.3_Schema-v1.0';
delete from schematrondes where label = 'schematron-rules-GEMINI_2.3_supp-v1.0';
update validation set valtype = 'schematron-rules-GEMINI_23_supp_v10' where valtype = 'schematron-rules-GEMINI_2.3_supp-v1.0';
update validation set valtype = 'schematron-rules-GEMINI_23_v10' where valtype = 'schematron-rules-GEMINI_2.3_Schema-v1.0'
delete from schematroncriteria where group_schematronid in (select id from schematron where filename in ('schematron-rules-GEMINI_2.3_supp-v1.0.xsl','schematron-rules-GEMINI_2.3_Schema-v1.0.xsl'));
delete from schematroncriteriagroup where schematronid in (select id from schematron where filename in ('schematron-rules-GEMINI_2.3_supp-v1.0.xsl','schematron-rules-GEMINI_2.3_Schema-v1.0.xsl'));
delete from schematron where filename in ('schematron-rules-GEMINI_2.3_supp-v1.0.xsl','schematron-rules-GEMINI_2.3_Schema-v1.0.xsl');


/* (re)start geonetwork

select * from settings where name like '%version%';
+-------------------------+-------+----------+----------+----------+-----------+----------+
| name                    | value | datatype | position | internal | encrypted | editable |
|-------------------------+-------+----------+----------+----------+-----------+----------|
| system/platform/version | 4.0.1 | 0        | 150      | n        | n         | y        |
+-------------------------+-------+----------+----------+----------+-----------+----------+

after one failed run where it gets to 4.0.1 but then fails with an error about guf_userfeedbacks: */

UPDATE Settings SET value = 'Etc/UTC' WHERE name = 'system/server/timeZone' AND VALUE = '';
UPDATE Settings SET value='4.0.2' WHERE name='system/platform/version';
UPDATE Settings SET value='SNAPSHOT' WHERE name='system/platform/subVersion';

/* restart geonetwork

select * from settings where name like '%version%';
+-------------------------+-------+----------+----------+----------+-----------+----------+
| name                    | value | datatype | position | internal | encrypted | editable |
|-------------------------+-------+----------+----------+----------+-----------+----------|
| system/platform/version | 4.2.2 | 0        | 150      | n        | n         | y        |
+-------------------------+-------+----------+----------+----------+-----------+----------+*/