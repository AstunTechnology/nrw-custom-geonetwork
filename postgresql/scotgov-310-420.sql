# create database geonetwork420clean
#\c geonetwork420clean
# create extension hstore
# create extension postgis
# restore dump
# run audit.sql



delete from validation where metadataid in (select id from metadata where schemaid = 'dcat-ap');
delete from metadata where schemaid = 'dcat-ap';
delete from statusvaluesdes where iddes = 63;
delete from statusvalues where id = 63;
delete from settings where name like '%passwordEnforcement%';

delete from schematrondes where label = 'schematron-rules-GEMINI_2.3_Schema-v1.0';
delete from schematrondes where label = 'schematron-rules-GEMINI_2.3_supp-v1.0';

update validation set valtype = 'schematron-rules-GEMINI_23_supp_v10' where valtype = 'schematron-rules-GEMINI_2.3_supp-v1.0';
update validation set valtype = 'schematron-rules-GEMINI_23_v10' where valtype = 'schematron-rules-GEMINI_2.3_Schema-v1.0';

delete from schematroncriteria where group_schematronid in (select id from schematron where schemaname = 'dcat-ap');
delete from schematroncriteriagroup where schematronid in (select id from schematron where schemaname = 'dcat-ap');
delete from schematrondes where label like '%dcat%';
delete from schematron where schemaname = 'dcat-ap';

/*DELETE 400
DELETE 100
DELETE 17
DELETE 1
DELETE 4
DELETE 1
DELETE 1
UPDATE 371
UPDATE 371
DELETE 3
DELETE 3
DELETE 3
DELETE 3
*/

/*select * from settings where name like '%version%';
+-------------------------+-------+----------+----------+----------+-----------+----------+
| name                    | value | datatype | position | internal | encrypted | editable |
|-------------------------+-------+----------+----------+----------+-----------+----------|
| system/platform/version | 4.0.1 | 0        | 150      | n        | n         | y        |
+-------------------------+-------+----------+----------+----------+-----------+----------+*/

# after one failed run where it gets to 4.0.1 but then fails with an error about guf_userfeedbacks

UPDATE Settings SET value = 'Etc/UTC' WHERE name = 'system/server/timeZone' AND VALUE = '';
UPDATE Settings SET value='4.0.2' WHERE name='system/platform/version';
UPDATE Settings SET value='SNAPSHOT' WHERE name='system/platform/subVersion';

# restart geonetwork

/*select * from settings where name like '%version%';
+-------------------------+-------+----------+----------+----------+-----------+----------+
| name                    | value | datatype | position | internal | encrypted | editable |
|-------------------------+-------+----------+----------+----------+-----------+----------|
| system/platform/version | 4.2.2 | 0        | 150      | n        | n         | y        |
+-------------------------+-------+----------+----------+----------+-----------+----------+*/

