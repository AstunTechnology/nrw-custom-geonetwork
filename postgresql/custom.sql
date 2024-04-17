--
-- PostgreSQL database dump
--

-- Dumped from database version 14.2
-- Dumped by pg_dump version 14.4 (Ubuntu 14.4-1.pgdg20.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: custom; Type: SCHEMA; Schema: -; Owner: geonetwork
--

CREATE SCHEMA custom;


ALTER SCHEMA custom OWNER TO geonetwork;

--
-- Name: metadata_xml; Type: VIEW; Schema: custom; Owner: geonetwork
--

CREATE VIEW custom.metadata_xml AS
 SELECT metadata.id,
    metadata.uuid,
    metadata.schemaid,
    metadata.istemplate,
    metadata.isharvested,
    metadata.createdate,
    metadata.changedate,
    XMLPARSE(DOCUMENT metadata.data STRIP WHITESPACE) AS data_xml,
    metadata.data,
    metadata.source,
    metadata.title,
    metadata.root,
    metadata.harvestuuid,
    metadata.owner,
    metadata.doctype,
    metadata.groupowner,
    metadata.harvesturi,
    metadata.rating,
    metadata.popularity,
    metadata.displayorder
   FROM public.metadata;


ALTER TABLE custom.metadata_xml OWNER TO geonetwork;

--
-- Name: all_records; Type: VIEW; Schema: custom; Owner: geonetwork
--

CREATE OR REPLACE VIEW custom.all_records AS
 SELECT groups.name AS organisation,
    (bah.id)::text AS id,
    (bah.owner)::text AS owner,
    users.username,
    email.email,
    (bah.uuid)::text AS uuid,
    array_to_string(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), '-'::text) AS title,
    (statusvalues.name)::text AS status,
    array_to_string(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date[gmd:dateType/gmd:CI_DateTypeCode[@codeListValue="creation"]]/gmd:date/gco:Date/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), ''::text) AS creationdate,
    array_to_string(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date[gmd:dateType/gmd:CI_DateTypeCode[@codeListValue="revision"]]/gmd:date/gco:Date/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), ''::text) AS revisiondate,
    regexp_replace(array_to_string(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), '-'::text), '[\n\r\u2028]+'::text, ' '::text, 'g'::text) AS abstract,
    array_to_string(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), '|'::text) AS keywords,
    array_to_string(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/eamp:EA_Constraints/eamp:afa/eamp:EA_Afa/eamp:afaNumber/gco:Decimal/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd},{eamp,http://environment.data.gov.uk/eamp}}'::text[]), '|'::text) AS afanumber,
    array_to_string(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/eamp:EA_Constraints/eamp:afa/eamp:EA_Afa/eamp:afaStatus/eamp:EA_AfaStatus/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd},{eamp,http://environment.data.gov.uk/eamp}}'::text[]), '|'::text) AS afastatus,
    array_to_string(xpath('/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), '|'::text) AS orl,
    array_to_string(xpath('/gmd:MD_Metadata/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:statement/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), '-'::text) AS lineage,
    regexp_replace(array_to_string(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:otherConstraints/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), '|'::text), '[\n\r\u2028]+'::text, ' '::text, 'g'::text) AS otherconstraints,
    ((((((((COALESCE(((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))[1])::text, ''::text) || ' | '::text) || COALESCE(((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))[1])::text, ''::text)) || ' '::text) || COALESCE(((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:positionName/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))[1])::text, ''::text)) || ' | '::text) || COALESCE(((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))[1])::text, ''::text)) || ' | '::text) || COALESCE(((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))[1])::text, ''::text)) AS contact1,
    ((((((((COALESCE(((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))[2])::text, ''::text) || ' | '::text) || COALESCE(((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))[2])::text, ''::text)) || ' | '::text) || COALESCE(((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:positionName/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))[2])::text, ''::text)) || ' | '::text) || COALESCE(((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))[2])::text, ''::text)) || ' | '::text) || COALESCE(((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))[2])::text, ''::text)) AS contact2,
    ((((((((COALESCE(((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))[3])::text, ''::text) || ' | '::text) || COALESCE(((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))[3])::text, ''::text)) || ' | '::text) || COALESCE(((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:positionName/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))[3])::text, ''::text)) || ' | '::text) || COALESCE(((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))[3])::text, ''::text)) || ' | '::text) || COALESCE(((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))[1])::text, ''::text)) AS contact3,
    ((((((((COALESCE(((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))[4])::text, ''::text) || ' | '::text) || COALESCE(((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))[4])::text, ''::text)) || ' | '::text) || COALESCE(((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:positionName/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))[4])::text, ''::text)) || ' | '::text) || COALESCE(((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))[4])::text, ''::text)) || ' | '::text) || COALESCE(((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))[1])::text, ''::text)) AS contact4
   FROM (((((( SELECT DISTINCT ON (metadatastatus.metadataid) metadatastatus.metadataid,
            metadatastatus.statusid,
            metadatastatus.userid,
            metadatastatus.changedate,
            metadatastatus.changemessage
           FROM public.metadatastatus
           WHERE metadatastatus.statusid in (0,1,2,3,4,5)
          ORDER BY metadatastatus.metadataid, metadatastatus.changedate DESC) foo
     LEFT JOIN public.statusvalues ON ((foo.statusid = statusvalues.id)))
     RIGHT JOIN ( SELECT metadata_xml.id,
            metadata_xml.uuid,
            metadata_xml.schemaid,
            metadata_xml.istemplate,
            metadata_xml.isharvested,
            metadata_xml.createdate,
            metadata_xml.changedate,
            metadata_xml.data_xml,
            metadata_xml.data,
            metadata_xml.source,
            metadata_xml.title,
            metadata_xml.root,
            metadata_xml.harvestuuid,
            metadata_xml.owner,
            metadata_xml.doctype,
            metadata_xml.groupowner,
            metadata_xml.harvesturi,
            metadata_xml.rating,
            metadata_xml.popularity,
            metadata_xml.displayorder
           FROM custom.metadata_xml
          WHERE (metadata_xml.istemplate <> 'y'::bpchar)
          ORDER BY metadata_xml.id) bah ON ((foo.metadataid = bah.id)))
     LEFT JOIN public.groups ON ((bah.groupowner = groups.id)))
     LEFT JOIN public.email ON ((bah.owner = email.user_id)))
     LEFT JOIN public.users ON ((bah.owner = users.id)))
  ORDER BY groups.name, bah.id;


ALTER TABLE custom.all_records OWNER TO geonetwork;

--
-- Name: all_records_for_harvesting; Type: VIEW; Schema: custom; Owner: geonetwork
--

CREATE VIEW custom.all_records_for_harvesting AS
 SELECT a.metadataid,
    b.uuid,
    c.name,
    foo.statusid
   FROM (((public.operationallowed a
     JOIN public.metadata b ON ((a.metadataid = b.id)))
     JOIN public.groups c ON ((b.groupowner = c.id)))
     JOIN ( SELECT DISTINCT ON (a_1.metadataid) a_1.metadataid,
            a_1.statusid,
            a_1.changedate,
            b_1.groupowner,
            c_1.name
           FROM ((public.metadatastatus a_1
             JOIN public.metadata b_1 ON ((a_1.metadataid = b_1.id)))
             JOIN public.groups c_1 ON ((b_1.groupowner = c_1.id)))
          WHERE (a_1.statusid = 2)
          ORDER BY a_1.metadataid, a_1.changedate DESC) foo ON ((b.id = foo.metadataid)))
  WHERE ((a.operationid = 0) AND (a.groupid = 1) AND ((c.name)::text <> 'Environment Agency'::text))
UNION ALL
 SELECT a.metadataid,
    b.uuid,
    c.name,
    foo.statusid
   FROM (((public.operationallowed a
     JOIN ( SELECT metadata_xml.id,
            metadata_xml.uuid,
            metadata_xml.schemaid,
            metadata_xml.istemplate,
            metadata_xml.isharvested,
            metadata_xml.createdate,
            metadata_xml.changedate,
            metadata_xml.data_xml,
            metadata_xml.data,
            metadata_xml.source,
            metadata_xml.title,
            metadata_xml.root,
            metadata_xml.harvestuuid,
            metadata_xml.owner,
            metadata_xml.doctype,
            metadata_xml.groupowner,
            metadata_xml.harvesturi,
            metadata_xml.rating,
            metadata_xml.popularity,
            metadata_xml.displayorder
           FROM custom.metadata_xml
          WHERE (('OpenData'::text = ANY ((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString/text()'::text, metadata_xml.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))::text[])) OR ('NotOpen'::text = ANY ((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString/text()'::text, metadata_xml.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))::text[])))) b ON ((a.metadataid = b.id)))
     JOIN public.groups c ON ((b.groupowner = c.id)))
     JOIN ( SELECT DISTINCT ON (a_1.metadataid) a_1.metadataid,
            a_1.statusid,
            a_1.changedate,
            b_1.groupowner,
            c_1.name
           FROM ((public.metadatastatus a_1
             JOIN public.metadata b_1 ON ((a_1.metadataid = b_1.id)))
             JOIN public.groups c_1 ON ((b_1.groupowner = c_1.id)))
          WHERE (a_1.statusid = 2)
          ORDER BY a_1.metadataid, a_1.changedate DESC) foo ON ((b.id = foo.metadataid)))
  WHERE ((a.operationid = 0) AND (a.groupid = 1) AND ((c.name)::text = 'Environment Agency'::text));


ALTER TABLE custom.all_records_for_harvesting OWNER TO geonetwork;

--
-- Name: VIEW all_records_for_harvesting; Type: COMMENT; Schema: custom; Owner: geonetwork
--

COMMENT ON VIEW custom.all_records_for_harvesting IS 'Records with status "approved" and "all" privileges for "all" group';


--
-- Name: citationidentifier; Type: VIEW; Schema: custom; Owner: geonetwork
--

CREATE VIEW custom.citationidentifier AS
 SELECT m.uuid,
    foo.citationidentifier
   FROM (public.metadata m
     LEFT JOIN ( SELECT metadata_xml.uuid,
            array_to_string(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:identifier/gmd:MD_Identifier/gmd:code/gco:CharacterString/text()'::text, metadata_xml.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), '-'::text) AS citationidentifier
           FROM custom.metadata_xml) foo ON (((m.uuid)::text = (foo.uuid)::text)));


ALTER TABLE custom.citationidentifier OWNER TO geonetwork;

--
-- Name: contactemails; Type: VIEW; Schema: custom; Owner: geonetwork
--

CREATE VIEW custom.contactemails AS
 SELECT metadata_xml.id,
    metadata_xml.uuid,
    (unnest(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString/text()'::text, metadata_xml.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[])))::text AS contactemail
   FROM custom.metadata_xml
  ORDER BY metadata_xml.id;


ALTER TABLE custom.contactemails OWNER TO geonetwork;

--
-- Name: VIEW contactemails; Type: COMMENT; Schema: custom; Owner: geonetwork
--

COMMENT ON VIEW custom.contactemails IS 'All contact emails extracted from within metadata';


--
-- Name: get_tables; Type: VIEW; Schema: custom; Owner: geonetwork
--

CREATE VIEW custom.get_tables AS
 SELECT tables.table_schema,
    tables.table_name
   FROM information_schema.tables
  WHERE ((tables.table_schema)::text <> ALL (ARRAY[('information_schema'::character varying)::text, ('pg_catalog'::character varying)::text, ('custom'::character varying)::text]))
  ORDER BY tables.table_schema, tables.table_name;


ALTER TABLE custom.get_tables OWNER TO geonetwork;

--
-- Name: getcolumns; Type: VIEW; Schema: custom; Owner: geonetwork
--

CREATE VIEW custom.getcolumns AS
 SELECT columns.table_schema,
    columns.table_name,
    columns.column_name,
    columns.ordinal_position,
    columns.is_nullable,
    columns.data_type
   FROM information_schema.columns
  WHERE ((columns.table_schema)::text <> ALL (ARRAY[('information_schema'::character varying)::text, ('pg_catalog'::character varying)::text]));


ALTER TABLE custom.getcolumns OWNER TO geonetwork;

--
-- Name: intgsiemails; Type: VIEW; Schema: custom; Owner: geonetwork
--

CREATE VIEW custom.intgsiemails AS
 SELECT DISTINCT contactemails.contactemail,
    'metadata'::text AS context,
    'internal'::text AS server
   FROM custom.contactemails
  WHERE ((contactemails.contactemail ~~* '%gsi.gov.uk'::text) AND (contactemails.contactemail !~~* '%forestry.gsi.gov.uk'::text))
  GROUP BY contactemails.contactemail
UNION
 SELECT email.email AS contactemail,
    'userlogin'::text AS context,
    'internal'::text AS server
   FROM public.email
  WHERE (((email.email)::text ~~* '%gsi.gov.uk'::text) AND ((email.email)::text !~~* '%forestry.gsi.gov.uk'::text))
  ORDER BY 1;


ALTER TABLE custom.intgsiemails OWNER TO geonetwork;

--
-- Name: logincounts; Type: VIEW; Schema: custom; Owner: geonetwork
--

CREATE VIEW custom.logincounts AS
 SELECT DISTINCT ON (bah.userid, bah.logindate) bah.userid,
    bah.logindate,
    bah.logintimecount,
    bah.groupname
   FROM ( SELECT foo.userid,
            foo.logindate,
            foo.logintimecount,
                CASE
                    WHEN (g.name IS NULL) THEN 'administrators'::character varying
                    ELSE g.name
                END AS groupname
           FROM ((( SELECT DISTINCT (logged_actions.row_data OPERATOR(public.->) 'id'::text) AS userid,
                    to_date("left"((logged_actions.changed_fields OPERATOR(public.->) 'lastlogindate'::text), 10), 'YYYY-MM-DD'::text) AS logindate,
                    count("right"((logged_actions.changed_fields OPERATOR(public.->) 'lastlogindate'::text), 8)) AS logintimecount
                   FROM audit.logged_actions
                  WHERE (logged_actions.table_name = 'users'::text)
                  GROUP BY (logged_actions.row_data OPERATOR(public.->) 'id'::text), (to_date("left"((logged_actions.changed_fields OPERATOR(public.->) 'lastlogindate'::text), 10), 'YYYY-MM-DD'::text))
                  ORDER BY (to_date("left"((logged_actions.changed_fields OPERATOR(public.->) 'lastlogindate'::text), 10), 'YYYY-MM-DD'::text)), (logged_actions.row_data OPERATOR(public.->) 'id'::text)) foo
             LEFT JOIN public.usergroups u ON (((foo.userid)::integer = u.userid)))
             LEFT JOIN public.groups g ON ((u.groupid = g.id)))) bah;


ALTER TABLE custom.logincounts OWNER TO geonetwork;

--
-- Name: opendata_validation; Type: VIEW; Schema: custom; Owner: geonetwork
--

CREATE VIEW custom.opendata_validation AS
 SELECT DISTINCT foo.uuid,
    foo.title,
    foo.beenthroughvalidation,
    foo.organisation
   FROM ( SELECT metadata_xml.uuid,
            array_to_string(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString/text()'::text, metadata_xml.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), '-'::text) AS title,
            validation.valdate,
            categories.name AS organisation,
                CASE
                    WHEN ((validation.valdate)::text <> ''::text) THEN 'y'::text
                    ELSE 'n'::text
                END AS beenthroughvalidation
           FROM public.metadatastatus,
            (((custom.metadata_xml
             LEFT JOIN public.metadatacateg ON ((metadata_xml.id = metadatacateg.metadataid)))
             LEFT JOIN public.categories ON ((metadatacateg.categoryid = categories.id)))
             LEFT JOIN public.validation ON ((validation.metadataid = metadata_xml.id)))
          WHERE ((metadatastatus.metadataid = metadata_xml.id) AND (('OpenData'::text = ANY ((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString/text()'::text, metadata_xml.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))::text[])) OR ('NotOpen'::text = ANY ((xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString/text()'::text, metadata_xml.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]))::text[]))))) foo
  GROUP BY foo.organisation, foo.uuid, foo.title, foo.beenthroughvalidation
  ORDER BY foo.organisation, foo.beenthroughvalidation, foo.title;


ALTER TABLE custom.opendata_validation OWNER TO geonetwork;

--
-- Name: records_status; Type: VIEW; Schema: custom; Owner: geonetwork
--

CREATE VIEW custom.records_status AS
 SELECT metadata_xml.id,
    metadata_xml.uuid,
    array_to_string(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString/text()'::text, metadata_xml.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), '-'::text) AS title,
    statusvalues.name AS status,
    foo.userid,
    foo.changedate,
    foo.changemessage,
    categories.name AS organisation
   FROM ((((( SELECT DISTINCT ON (metadatastatus.metadataid) metadatastatus.metadataid,
            metadatastatus.statusid,
            metadatastatus.userid,
            metadatastatus.changedate,
            metadatastatus.changemessage
           FROM public.metadatastatus
          ORDER BY metadatastatus.metadataid, metadatastatus.changedate DESC) foo
     LEFT JOIN public.statusvalues ON ((foo.statusid = statusvalues.id)))
     RIGHT JOIN custom.metadata_xml ON ((foo.metadataid = metadata_xml.id)))
     LEFT JOIN public.metadatacateg ON ((metadata_xml.id = metadatacateg.metadataid)))
     LEFT JOIN public.categories ON ((metadatacateg.categoryid = categories.id)))
  ORDER BY categories.name, (array_to_string(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString/text()'::text, metadata_xml.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), '-'::text));


ALTER TABLE custom.records_status OWNER TO geonetwork;

--
-- Name: records_approved_not_published; Type: VIEW; Schema: custom; Owner: geonetwork
--

CREATE VIEW custom.records_approved_not_published AS
 SELECT records_status.uuid,
    records_status.title,
    records_status.changedate,
    records_status.userid,
    records_status.organisation
   FROM custom.records_status
  WHERE (((records_status.status)::text = 'approved'::text) AND (NOT (records_status.id IN ( SELECT a.metadataid
           FROM (public.operationallowed a
             JOIN public.operations b ON ((a.operationid = b.id)))
          WHERE ((a.groupid = 1) AND (a.operationid = 0))))))
  ORDER BY records_status.organisation;


ALTER TABLE custom.records_approved_not_published OWNER TO geonetwork;

--
-- Name: records_custodian; Type: VIEW; Schema: custom; Owner: geonetwork
--

CREATE VIEW custom.records_custodian AS
 SELECT metadata_xml.id,
    array_to_string(xpath('(/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact[gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode="custodian"]/gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString/text())[1]'::text, metadata_xml.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), '-'::text) AS custodian1,
    array_to_string(xpath('(/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact[gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode="custodian"]/gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString/text())[2]'::text, metadata_xml.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), '-'::text) AS custodian2,
    array_to_string(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString/text()'::text, metadata_xml.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), '-'::text) AS title,
    categories.name AS organisation
   FROM ((custom.metadata_xml
     LEFT JOIN public.metadatacateg ON ((metadata_xml.id = metadatacateg.metadataid)))
     LEFT JOIN public.categories ON ((metadatacateg.categoryid = categories.id)))
  ORDER BY categories.name, metadata_xml.id;


ALTER TABLE custom.records_custodian OWNER TO geonetwork;

--
-- Name: records_date_updated; Type: VIEW; Schema: custom; Owner: geonetwork
--

CREATE VIEW custom.records_date_updated AS
 SELECT metadata_xml.id,
    metadata_xml.changedate,
    array_to_string(xpath('(/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact[gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode="custodian"]/gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString/text())[1]'::text, metadata_xml.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), '-'::text) AS custodian,
    array_to_string(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString/text()'::text, metadata_xml.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), '-'::text) AS title,
    groups.name AS organisation
   FROM (custom.metadata_xml
     LEFT JOIN public.groups ON ((metadata_xml.groupowner = groups.id)))
  WHERE (to_date((metadata_xml.changedate)::text, 'YYYY-MM-DD'::text) < (('now'::text)::date - '3 mons'::interval));


ALTER TABLE custom.records_date_updated OWNER TO geonetwork;

--
-- Name: records_on_ext_not_forharvesting; Type: VIEW; Schema: custom; Owner: geonetwork
--

CREATE VIEW custom.records_on_ext_not_forharvesting AS
 SELECT a.uuid,
    a.id,
    a.istemplate,
    b.name
   FROM (public.pub_metadata a
     JOIN public.pub_groups b ON ((a.groupowner = b.id)))
  WHERE (NOT ((a.uuid)::text IN ( SELECT all_records_for_harvesting.uuid
           FROM custom.all_records_for_harvesting)));


ALTER TABLE custom.records_on_ext_not_forharvesting OWNER TO geonetwork;

--
-- Name: VIEW records_on_ext_not_forharvesting; Type: COMMENT; Schema: custom; Owner: geonetwork
--

COMMENT ON VIEW custom.records_on_ext_not_forharvesting IS 'records on external server not in custom.all_records_for_harvesting';


--
-- Name: records_orl; Type: VIEW; Schema: custom; Owner: geonetwork
--

CREATE VIEW custom.records_orl AS
 SELECT foo.uuid,
    array_to_string(xpath('//gmd:CI_OnlineResource/gmd:linkage/gmd:URL/text()'::text, foo.node, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), ''::text) AS url,
    array_to_string(xpath('//gmd:CI_OnlineResource/gmd:protocol/gco:CharacterString/text()'::text, foo.node, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), ''::text) AS url_protocol,
    array_to_string(xpath('//gmd:CI_OnlineResource/gmd:name/gco:CharacterString/text()'::text, foo.node, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), ''::text) AS url_name,
    array_to_string(xpath('//gmd:CI_OnlineResource/gmd:description/gco:CharacterString/text()'::text, foo.node, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), ''::text) AS url_description,
    categories.name AS organisation
   FROM ((( SELECT unnest(xpath('/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine'::text, metadata_xml.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[])) AS node,
            metadata_xml.uuid,
            metadata_xml.id
           FROM custom.metadata_xml) foo
     LEFT JOIN public.metadatacateg ON ((foo.id = metadatacateg.metadataid)))
     LEFT JOIN public.categories ON ((metadatacateg.categoryid = categories.id)))
  ORDER BY categories.name, foo.uuid;


ALTER TABLE custom.records_orl OWNER TO geonetwork;

--
-- Name: records_validation; Type: VIEW; Schema: custom; Owner: geonetwork
--

CREATE VIEW custom.records_validation AS
 SELECT metadata_xml.id,
    statusvalues.name,
    metadatastatus.changedate,
    metadatastatus.changemessage,
    validation.valtype,
    validation.status,
    validation.failed,
    validation.valdate,
    categories.name AS organisation,
    array_to_string(xpath('/gmd:MD_Metadata/gmd:distributionInfo/gmd:MD_Distribution/gmd:distributor/gmd:MD_Distributor/gmd:distributorTransferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL/text()'::text, metadata_xml.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), '-'::text) AS orl,
    array_to_string(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString/text()'::text, metadata_xml.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), '-'::text) AS title
   FROM public.metadatastatus,
    public.statusvalues,
    (((custom.metadata_xml
     LEFT JOIN public.validation ON ((validation.metadataid = metadata_xml.id)))
     LEFT JOIN public.metadatacateg ON ((metadata_xml.id = metadatacateg.metadataid)))
     LEFT JOIN public.categories ON ((metadatacateg.categoryid = categories.id)))
  WHERE ((metadatastatus.metadataid = metadata_xml.id) AND (metadatastatus.statusid = statusvalues.id) AND ((statusvalues.name)::text = 'approved'::text) AND ((validation.failed IS NULL) OR (validation.failed > 0)))
  ORDER BY categories.name, metadata_xml.id;


ALTER TABLE custom.records_validation OWNER TO geonetwork;

--
-- Name: uniquegsiemails; Type: VIEW; Schema: custom; Owner: geonetwork
--

CREATE VIEW custom.uniquegsiemails AS
 SELECT DISTINCT lower(foo.contactemail) AS email
   FROM ( SELECT intgsiemails.contactemail,
            intgsiemails.context,
            intgsiemails.server
           FROM custom.intgsiemails
        UNION
         SELECT pub_extgsiemails.contactemail,
            pub_extgsiemails.context,
            pub_extgsiemails.server
           FROM public.pub_extgsiemails) foo
  GROUP BY (lower(foo.contactemail))
  ORDER BY (lower(foo.contactemail));


ALTER TABLE custom.uniquegsiemails OWNER TO geonetwork;

--
-- Name: updatefrequency; Type: VIEW; Schema: custom; Owner: geonetwork
--

CREATE VIEW custom.updatefrequency AS
 SELECT bah.id,
    bah.uuid,
    array_to_string(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceMaintenance/gmd:MD_MaintenanceInformation/gmd:maintenanceAndUpdateFrequency/gmd:MD_MaintenanceFrequencyCode/text()'::text, bah.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), ''::text) AS updatefrequency
   FROM ( SELECT metadata_xml.uuid,
            metadata_xml.id,
            metadata_xml.data_xml
           FROM custom.metadata_xml
          WHERE (metadata_xml.istemplate <> 'y'::bpchar)) bah
  ORDER BY bah.id;


ALTER TABLE custom.updatefrequency OWNER TO geonetwork;

--
-- Name: SCHEMA custom; Type: ACL; Schema: -; Owner: geonetwork
--

GRANT USAGE ON SCHEMA custom TO geonetwork_ro;


--
-- Name: TABLE metadata_xml; Type: ACL; Schema: custom; Owner: geonetwork
--

GRANT SELECT ON TABLE custom.metadata_xml TO geonetwork_ro;


--
-- Name: TABLE all_records; Type: ACL; Schema: custom; Owner: geonetwork
--

GRANT SELECT ON TABLE custom.all_records TO geonetwork_ro;


--
-- Name: TABLE all_records_for_harvesting; Type: ACL; Schema: custom; Owner: geonetwork
--

GRANT SELECT ON TABLE custom.all_records_for_harvesting TO geonetwork_ro;


--
-- Name: TABLE citationidentifier; Type: ACL; Schema: custom; Owner: geonetwork
--

GRANT SELECT ON TABLE custom.citationidentifier TO geonetwork_ro;


--
-- Name: TABLE contactemails; Type: ACL; Schema: custom; Owner: geonetwork
--

GRANT SELECT ON TABLE custom.contactemails TO geonetwork_ro;


--
-- Name: TABLE get_tables; Type: ACL; Schema: custom; Owner: geonetwork
--

GRANT SELECT ON TABLE custom.get_tables TO geonetwork_ro;


--
-- Name: TABLE getcolumns; Type: ACL; Schema: custom; Owner: geonetwork
--

GRANT SELECT ON TABLE custom.getcolumns TO geonetwork_ro;


--
-- Name: TABLE intgsiemails; Type: ACL; Schema: custom; Owner: geonetwork
--

GRANT SELECT ON TABLE custom.intgsiemails TO geonetwork_ro;


--
-- Name: TABLE logincounts; Type: ACL; Schema: custom; Owner: geonetwork
--

GRANT SELECT ON TABLE custom.logincounts TO geonetwork_ro;


--
-- Name: TABLE opendata_validation; Type: ACL; Schema: custom; Owner: geonetwork
--

GRANT SELECT ON TABLE custom.opendata_validation TO geonetwork_ro;


--
-- Name: TABLE records_status; Type: ACL; Schema: custom; Owner: geonetwork
--

GRANT SELECT ON TABLE custom.records_status TO geonetwork_ro;


--
-- Name: TABLE records_approved_not_published; Type: ACL; Schema: custom; Owner: geonetwork
--

GRANT SELECT ON TABLE custom.records_approved_not_published TO geonetwork_ro;


--
-- Name: TABLE records_custodian; Type: ACL; Schema: custom; Owner: geonetwork
--

GRANT SELECT ON TABLE custom.records_custodian TO geonetwork_ro;


--
-- Name: TABLE records_date_updated; Type: ACL; Schema: custom; Owner: geonetwork
--

GRANT SELECT ON TABLE custom.records_date_updated TO geonetwork_ro;


--
-- Name: TABLE records_on_ext_not_forharvesting; Type: ACL; Schema: custom; Owner: geonetwork
--

GRANT SELECT ON TABLE custom.records_on_ext_not_forharvesting TO geonetwork_ro;


--
-- Name: TABLE records_orl; Type: ACL; Schema: custom; Owner: geonetwork
--

GRANT SELECT ON TABLE custom.records_orl TO geonetwork_ro;


--
-- Name: TABLE records_validation; Type: ACL; Schema: custom; Owner: geonetwork
--

GRANT SELECT ON TABLE custom.records_validation TO geonetwork_ro;


--
-- Name: TABLE updatefrequency; Type: ACL; Schema: custom; Owner: geonetwork
--

GRANT SELECT ON TABLE custom.updatefrequency TO geonetwork_ro;


--
-- PostgreSQL database dump complete
--

