SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;
SET default_tablespace = '';
SET default_with_oids = false;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;
COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';

CREATE TABLE public.image (
    identifier uuid PRIMARY KEY DEFAULT public.uuid_generate_v4(),
    created_on timestamp with time zone NOT NULL,
    updated_on timestamp with time zone NOT NULL,
    ingestion_type character varying(80),
    provider character varying(80),
    source character varying(80),
    foreign_identifier character varying(3000),
    foreign_landing_url character varying(1000),
    url character varying(3000) NOT NULL,
    thumbnail character varying(3000),
    width integer,
    height integer,
    filesize integer,
    license character varying(50) NOT NULL,
    license_version character varying(25),
    creator character varying(2000),
    creator_url character varying(2000),
    title character varying(5000),
    meta_data jsonb,
    tags jsonb,
    watermarked boolean,
    last_synced_with_source timestamp with time zone,
    removed_from_source boolean NOT NULL,
    filetype character varying(5),
    category character varying(80),
    standardized_popularity double precision
);


ALTER TABLE public.image OWNER TO deploy;
CREATE UNIQUE INDEX image_provider_fid_idx
    ON public.image
    USING btree (provider, md5(foreign_identifier));
CREATE UNIQUE INDEX image_identifier_key
    ON public.image
    USING btree (identifier);
CREATE UNIQUE INDEX image_url_key
    ON public.image
    USING btree (url);
