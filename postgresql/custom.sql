--
-- PostgreSQL database dump
--

-- Dumped from database version 14.9 (Debian 14.9-1.pgdg110+1)
-- Dumped by pg_dump version 16.2 (Ubuntu 16.2-1.pgdg22.04+1)

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


ALTER VIEW custom.metadata_xml OWNER TO geonetwork;

--
-- Name: all_records; Type: VIEW; Schema: custom; Owner: geonetwork
--

CREATE VIEW custom.all_records AS
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
          WHERE (metadatastatus.statusid = ANY (ARRAY[0, 1, 2, 3, 4, 5]))
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


ALTER VIEW custom.all_records OWNER TO geonetwork;

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


ALTER VIEW custom.all_records_for_harvesting OWNER TO geonetwork;

--
-- Name: VIEW all_records_for_harvesting; Type: COMMENT; Schema: custom; Owner: geonetwork
--

COMMENT ON VIEW custom.all_records_for_harvesting IS 'Records with status "approved" and "all" privileges for "all" group';


--
-- Name: constraints; Type: VIEW; Schema: custom; Owner: geonetwork
--

CREATE or REPLACE VIEW custom.constraints AS
 SELECT (foo.uuid)::text AS uuid,
    array_to_string(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString/text()'::text, foo.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), '-'::text) AS title,
    regexp_replace(array_to_string(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:accessConstraints/gmd:MD_RestrictionCode/@codeListValue'::text, foo.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), '|'::text), '[\n\r\u2028]+'::text, ' '::text, 'g'::text) AS limitationsonaccessanduse,
    regexp_replace(array_to_string(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints[gmd:accessConstraints]/gmd:otherConstraints/gmx:Anchor/text()'::text, foo.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd},{gmx,http://www.isotc211.org/2005/gmx}}'::text[]), '|'::text), '[\n\r\u2028]+'::text, ' '::text, 'g'::text) AS accessconstrainturl,
    regexp_replace(array_to_string(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints[gmd:accessConstraints]/gmd:otherConstraints/gco:CharacterString/text()'::text, foo.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), '|'::text), '[\n\r\u2028]+'::text, ' '::text, 'g'::text) AS accessrestrictions,
    regexp_replace(array_to_string(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints[gmd:useConstraints]/gmd:otherConstraints[1]/gco:CharacterString/text()'::text, foo.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), '|'::text), '[\n\r\u2028]+'::text, ' '::text, 'g'::text) AS useconstraints,
    regexp_replace(array_to_string(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints[gmd:useConstraints]/gmd:otherConstraints/gmx:Anchor/text()'::text, foo.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd},{gmx,http://www.isotc211.org/2005/gmx}}'::text[]), '|'::text), '[\n\r\u2028]+'::text, ' '::text, 'g'::text) AS license,
    regexp_replace(array_to_string(xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints[gmd:useConstraints]/gmd:otherConstraints[3]/gco:CharacterString/text()'::text, foo.data_xml, '{{gco,http://www.isotc211.org/2005/gco},{gmd,http://www.isotc211.org/2005/gmd}}'::text[]), '|'::text), '[\n\r\u2028]+'::text, ' '::text, 'g'::text) AS attributionstatement
   FROM ( SELECT metadata_xml.id,
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
          WHERE (metadata_xml.istemplate <> 'y'::bpchar)) foo;


ALTER VIEW custom.constraints OWNER TO geonetwork;




--
-- Name: get_tables; Type: VIEW; Schema: custom; Owner: geonetwork
--

CREATE VIEW custom.get_tables AS
 SELECT tables.table_schema,
    tables.table_name
   FROM information_schema.tables
  WHERE ((tables.table_schema)::text <> ALL (ARRAY[('information_schema'::character varying)::text, ('pg_catalog'::character varying)::text, ('custom'::character varying)::text]))
  ORDER BY tables.table_schema, tables.table_name;


ALTER VIEW custom.get_tables OWNER TO geonetwork;

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


ALTER VIEW custom.getcolumns OWNER TO geonetwork;


--
-- PostgreSQL database dump complete
--

