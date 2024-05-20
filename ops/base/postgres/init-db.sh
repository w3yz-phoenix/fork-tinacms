#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<- EOSQL
    CREATE DATABASE ferretdb;
    CREATE DATABASE saleor;
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "saleor" <<- EOSQL
    --
    -- PostgreSQL database dump
    --

    -- Dumped from database version 16.3
    -- Dumped by pg_dump version 16.3

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
    -- Name: btree_gin; Type: EXTENSION; Schema: -; Owner: -
    --

    CREATE EXTENSION IF NOT EXISTS btree_gin WITH SCHEMA public;


    --
    -- Name: EXTENSION btree_gin; Type: COMMENT; Schema: -; Owner: 
    --

    COMMENT ON EXTENSION btree_gin IS 'support for indexing common datatypes in GIN';


    --
    -- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
    --

    CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


    --
    -- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: 
    --

    COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


    --
    -- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
    --

    CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


    --
    -- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
    --

    COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


    --
    -- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
    --

    CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


    --
    -- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
    --

    COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


    --
    -- Name: messages_trigger(); Type: FUNCTION; Schema: public; Owner: saleor
    --

    CREATE FUNCTION public.messages_trigger() RETURNS trigger
        LANGUAGE plpgsql
        AS $$
                begin
                  new.search_vector :=
                    setweight(
                    to_tsvector('pg_catalog.english', coalesce(new.name,'')), 'A'
                    ) ||
                    setweight(
                    to_tsvector(
                    'pg_catalog.english', coalesce(new.description_plaintext,'')),
                    'B'
                    );
                  return new;
                end
                $$;


    ALTER FUNCTION public.messages_trigger() OWNER TO saleor;

    SET default_tablespace = '';

    SET default_table_access_method = heap;

    --
    -- Name: account_address; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.account_address (
        id integer NOT NULL,
        first_name character varying(256) NOT NULL,
        last_name character varying(256) NOT NULL,
        company_name character varying(256) NOT NULL,
        street_address_1 character varying(256) NOT NULL,
        street_address_2 character varying(256) NOT NULL,
        city character varying(256) NOT NULL,
        postal_code character varying(20) NOT NULL,
        country character varying(2) NOT NULL,
        country_area character varying(128) NOT NULL,
        phone character varying(128) NOT NULL,
        city_area character varying(128) NOT NULL,
        metadata jsonb,
        private_metadata jsonb
    );


    ALTER TABLE public.account_address OWNER TO saleor;

    --
    -- Name: account_customerevent; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.account_customerevent (
        id integer NOT NULL,
        date timestamp with time zone NOT NULL,
        type character varying(255) NOT NULL,
        parameters jsonb NOT NULL,
        user_id integer,
        app_id integer,
        order_id uuid
    );


    ALTER TABLE public.account_customerevent OWNER TO saleor;

    --
    -- Name: account_customerevent_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.account_customerevent_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.account_customerevent_id_seq OWNER TO saleor;

    --
    -- Name: account_customerevent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.account_customerevent_id_seq OWNED BY public.account_customerevent.id;


    --
    -- Name: account_customernote; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.account_customernote (
        id integer NOT NULL,
        date timestamp with time zone NOT NULL,
        content text NOT NULL,
        is_public boolean NOT NULL,
        customer_id integer NOT NULL,
        user_id integer
    );


    ALTER TABLE public.account_customernote OWNER TO saleor;

    --
    -- Name: account_customernote_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.account_customernote_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.account_customernote_id_seq OWNER TO saleor;

    --
    -- Name: account_customernote_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.account_customernote_id_seq OWNED BY public.account_customernote.id;


    --
    -- Name: account_group; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.account_group (
        id integer NOT NULL,
        name character varying(150) NOT NULL,
        restricted_access_to_channels boolean DEFAULT false NOT NULL
    );


    ALTER TABLE public.account_group OWNER TO saleor;

    --
    -- Name: account_group_channels; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.account_group_channels (
        id integer NOT NULL,
        group_id integer NOT NULL,
        channel_id integer NOT NULL
    );


    ALTER TABLE public.account_group_channels OWNER TO saleor;

    --
    -- Name: account_group_channels_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.account_group_channels_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.account_group_channels_id_seq OWNER TO saleor;

    --
    -- Name: account_group_channels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.account_group_channels_id_seq OWNED BY public.account_group_channels.id;


    --
    -- Name: account_group_permissions; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.account_group_permissions (
        id integer NOT NULL,
        group_id integer NOT NULL,
        permission_id integer NOT NULL
    );


    ALTER TABLE public.account_group_permissions OWNER TO saleor;

    --
    -- Name: app_app; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.app_app (
        id integer NOT NULL,
        private_metadata jsonb,
        metadata jsonb,
        name character varying(60) NOT NULL,
        created_at timestamp with time zone NOT NULL,
        is_active boolean NOT NULL,
        about_app text,
        app_url character varying(200),
        configuration_url character varying(200),
        data_privacy text,
        data_privacy_url character varying(200),
        homepage_url character varying(200),
        identifier character varying(256) NOT NULL,
        support_url character varying(200),
        type character varying(60) NOT NULL,
        version character varying(60),
        manifest_url character varying(200),
        audience character varying(256),
        is_installed boolean DEFAULT true NOT NULL,
        author character varying(60),
        uuid uuid NOT NULL,
        brand_logo_default character varying(100),
        removed_at timestamp with time zone
    );


    ALTER TABLE public.app_app OWNER TO saleor;

    --
    -- Name: account_serviceaccount_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.account_serviceaccount_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.account_serviceaccount_id_seq OWNER TO saleor;

    --
    -- Name: account_serviceaccount_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.account_serviceaccount_id_seq OWNED BY public.app_app.id;


    --
    -- Name: app_app_permissions; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.app_app_permissions (
        id integer NOT NULL,
        app_id integer NOT NULL,
        permission_id integer NOT NULL
    );


    ALTER TABLE public.app_app_permissions OWNER TO saleor;

    --
    -- Name: account_serviceaccount_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.account_serviceaccount_permissions_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.account_serviceaccount_permissions_id_seq OWNER TO saleor;

    --
    -- Name: account_serviceaccount_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.account_serviceaccount_permissions_id_seq OWNED BY public.app_app_permissions.id;


    --
    -- Name: app_apptoken; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.app_apptoken (
        id integer NOT NULL,
        name character varying(128) NOT NULL,
        auth_token character varying(128) NOT NULL,
        app_id integer NOT NULL,
        token_last_4 character varying(4) NOT NULL
    );


    ALTER TABLE public.app_apptoken OWNER TO saleor;

    --
    -- Name: account_serviceaccounttoken_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.account_serviceaccounttoken_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.account_serviceaccounttoken_id_seq OWNER TO saleor;

    --
    -- Name: account_serviceaccounttoken_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.account_serviceaccounttoken_id_seq OWNED BY public.app_apptoken.id;


    --
    -- Name: account_staffnotificationrecipient; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.account_staffnotificationrecipient (
        id integer NOT NULL,
        staff_email character varying(254),
        active boolean NOT NULL,
        user_id integer
    );


    ALTER TABLE public.account_staffnotificationrecipient OWNER TO saleor;

    --
    -- Name: account_staffnotificationrecipient_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.account_staffnotificationrecipient_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.account_staffnotificationrecipient_id_seq OWNER TO saleor;

    --
    -- Name: account_staffnotificationrecipient_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.account_staffnotificationrecipient_id_seq OWNED BY public.account_staffnotificationrecipient.id;


    --
    -- Name: account_user; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.account_user (
        id integer NOT NULL,
        is_superuser boolean NOT NULL,
        email character varying(254) NOT NULL,
        is_staff boolean NOT NULL,
        is_active boolean NOT NULL,
        password character varying(128) NOT NULL,
        date_joined timestamp with time zone NOT NULL,
        last_login timestamp with time zone,
        default_billing_address_id integer,
        default_shipping_address_id integer,
        note text,
        first_name character varying(256) NOT NULL,
        last_name character varying(256) NOT NULL,
        avatar character varying(100),
        private_metadata jsonb,
        metadata jsonb,
        jwt_token_key character varying(12) NOT NULL,
        language_code character varying(35) NOT NULL,
        search_document text NOT NULL,
        updated_at timestamp with time zone NOT NULL,
        uuid uuid NOT NULL,
        external_reference character varying(250),
        last_password_reset_request timestamp with time zone,
        is_confirmed boolean DEFAULT true NOT NULL,
        last_confirm_email_request timestamp with time zone
    );


    ALTER TABLE public.account_user OWNER TO saleor;

    --
    -- Name: account_user_addresses; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.account_user_addresses (
        id integer NOT NULL,
        user_id integer NOT NULL,
        address_id integer NOT NULL
    );


    ALTER TABLE public.account_user_addresses OWNER TO saleor;

    --
    -- Name: account_user_groups; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.account_user_groups (
        id integer NOT NULL,
        user_id integer NOT NULL,
        group_id integer NOT NULL
    );


    ALTER TABLE public.account_user_groups OWNER TO saleor;

    --
    -- Name: account_user_user_permissions; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.account_user_user_permissions (
        id integer NOT NULL,
        user_id integer NOT NULL,
        permission_id integer NOT NULL
    );


    ALTER TABLE public.account_user_user_permissions OWNER TO saleor;

    --
    -- Name: app_appextension; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.app_appextension (
        id integer NOT NULL,
        label character varying(256) NOT NULL,
        url character varying(200) NOT NULL,
        app_id integer NOT NULL,
        mount character varying(256) NOT NULL,
        target character varying(128) NOT NULL
    );


    ALTER TABLE public.app_appextension OWNER TO saleor;

    --
    -- Name: app_appextension_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.app_appextension_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.app_appextension_id_seq OWNER TO saleor;

    --
    -- Name: app_appextension_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.app_appextension_id_seq OWNED BY public.app_appextension.id;


    --
    -- Name: app_appextension_permissions; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.app_appextension_permissions (
        id integer NOT NULL,
        appextension_id integer NOT NULL,
        permission_id integer NOT NULL
    );


    ALTER TABLE public.app_appextension_permissions OWNER TO saleor;

    --
    -- Name: app_appextension_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.app_appextension_permissions_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.app_appextension_permissions_id_seq OWNER TO saleor;

    --
    -- Name: app_appextension_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.app_appextension_permissions_id_seq OWNED BY public.app_appextension_permissions.id;


    --
    -- Name: app_appinstallation; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.app_appinstallation (
        id integer NOT NULL,
        status character varying(50) NOT NULL,
        message character varying(255),
        created_at timestamp with time zone NOT NULL,
        updated_at timestamp with time zone NOT NULL,
        app_name character varying(60) NOT NULL,
        manifest_url character varying(200) NOT NULL,
        uuid uuid NOT NULL,
        brand_logo_default character varying(100)
    );


    ALTER TABLE public.app_appinstallation OWNER TO saleor;

    --
    -- Name: app_appinstallation_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.app_appinstallation_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.app_appinstallation_id_seq OWNER TO saleor;

    --
    -- Name: app_appinstallation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.app_appinstallation_id_seq OWNED BY public.app_appinstallation.id;


    --
    -- Name: app_appinstallation_permissions; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.app_appinstallation_permissions (
        id integer NOT NULL,
        appinstallation_id integer NOT NULL,
        permission_id integer NOT NULL
    );


    ALTER TABLE public.app_appinstallation_permissions OWNER TO saleor;

    --
    -- Name: app_appinstallation_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.app_appinstallation_permissions_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.app_appinstallation_permissions_id_seq OWNER TO saleor;

    --
    -- Name: app_appinstallation_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.app_appinstallation_permissions_id_seq OWNED BY public.app_appinstallation_permissions.id;


    --
    -- Name: attribute_assignedpageattributevalue; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.attribute_assignedpageattributevalue (
        id integer NOT NULL,
        sort_order integer,
        value_id integer NOT NULL,
        page_id integer NOT NULL
    );


    ALTER TABLE public.attribute_assignedpageattributevalue OWNER TO saleor;

    --
    -- Name: attribute_assignedpageattributevalue_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.attribute_assignedpageattributevalue_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.attribute_assignedpageattributevalue_id_seq OWNER TO saleor;

    --
    -- Name: attribute_assignedpageattributevalue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.attribute_assignedpageattributevalue_id_seq OWNED BY public.attribute_assignedpageattributevalue.id;


    --
    -- Name: attribute_assignedproductattributevalue; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.attribute_assignedproductattributevalue (
        id integer NOT NULL,
        sort_order integer,
        value_id integer NOT NULL,
        product_id integer NOT NULL
    );


    ALTER TABLE public.attribute_assignedproductattributevalue OWNER TO saleor;

    --
    -- Name: attribute_assignedproductattributevalue_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.attribute_assignedproductattributevalue_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.attribute_assignedproductattributevalue_id_seq OWNER TO saleor;

    --
    -- Name: attribute_assignedproductattributevalue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.attribute_assignedproductattributevalue_id_seq OWNED BY public.attribute_assignedproductattributevalue.id;


    --
    -- Name: attribute_assignedvariantattribute; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.attribute_assignedvariantattribute (
        id integer NOT NULL,
        variant_id integer NOT NULL,
        assignment_id integer NOT NULL
    );


    ALTER TABLE public.attribute_assignedvariantattribute OWNER TO saleor;

    --
    -- Name: attribute_assignedvariantattributevalue; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.attribute_assignedvariantattributevalue (
        id integer NOT NULL,
        sort_order integer,
        assignment_id integer NOT NULL,
        value_id integer NOT NULL
    );


    ALTER TABLE public.attribute_assignedvariantattributevalue OWNER TO saleor;

    --
    -- Name: attribute_assignedvariantattributevalue_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.attribute_assignedvariantattributevalue_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.attribute_assignedvariantattributevalue_id_seq OWNER TO saleor;

    --
    -- Name: attribute_assignedvariantattributevalue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.attribute_assignedvariantattributevalue_id_seq OWNED BY public.attribute_assignedvariantattributevalue.id;


    --
    -- Name: attribute_attribute; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.attribute_attribute (
        id integer NOT NULL,
        slug character varying(250) NOT NULL,
        name character varying(255) NOT NULL,
        metadata jsonb,
        private_metadata jsonb,
        input_type character varying(50) NOT NULL,
        available_in_grid boolean NOT NULL,
        visible_in_storefront boolean NOT NULL,
        filterable_in_dashboard boolean NOT NULL,
        filterable_in_storefront boolean NOT NULL,
        value_required boolean NOT NULL,
        storefront_search_position integer NOT NULL,
        is_variant_only boolean NOT NULL,
        type character varying(50) NOT NULL,
        entity_type character varying(50),
        unit character varying(100),
        external_reference character varying(250),
        max_sort_order integer
    );


    ALTER TABLE public.attribute_attribute OWNER TO saleor;

    --
    -- Name: attribute_attributepage; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.attribute_attributepage (
        id integer NOT NULL,
        sort_order integer,
        attribute_id integer NOT NULL,
        page_type_id integer NOT NULL
    );


    ALTER TABLE public.attribute_attributepage OWNER TO saleor;

    --
    -- Name: attribute_attributeproduct; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.attribute_attributeproduct (
        id integer NOT NULL,
        attribute_id integer NOT NULL,
        product_type_id integer NOT NULL,
        sort_order integer
    );


    ALTER TABLE public.attribute_attributeproduct OWNER TO saleor;

    --
    -- Name: attribute_attributetranslation; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.attribute_attributetranslation (
        id integer NOT NULL,
        language_code character varying(35) NOT NULL,
        name character varying(255) NOT NULL,
        attribute_id integer NOT NULL
    );


    ALTER TABLE public.attribute_attributetranslation OWNER TO saleor;

    --
    -- Name: attribute_attributevalue; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.attribute_attributevalue (
        id integer NOT NULL,
        name character varying(250) NOT NULL,
        attribute_id integer NOT NULL,
        slug character varying(255) NOT NULL,
        sort_order integer,
        value character varying(255) NOT NULL,
        content_type character varying(50),
        file_url character varying(200),
        rich_text jsonb,
        "boolean" boolean,
        date_time timestamp with time zone,
        reference_page_id integer,
        reference_product_id integer,
        plain_text text,
        reference_variant_id integer,
        external_reference character varying(250)
    );


    ALTER TABLE public.attribute_attributevalue OWNER TO saleor;

    --
    -- Name: attribute_attributevaluetranslation; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.attribute_attributevaluetranslation (
        id integer NOT NULL,
        language_code character varying(35) NOT NULL,
        name character varying(250) NOT NULL,
        attribute_value_id integer NOT NULL,
        rich_text jsonb,
        plain_text text
    );


    ALTER TABLE public.attribute_attributevaluetranslation OWNER TO saleor;

    --
    -- Name: attribute_attributevariant; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.attribute_attributevariant (
        id integer NOT NULL,
        attribute_id integer NOT NULL,
        product_type_id integer NOT NULL,
        sort_order integer,
        variant_selection boolean NOT NULL
    );


    ALTER TABLE public.attribute_attributevariant OWNER TO saleor;

    --
    -- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.auth_group_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.auth_group_id_seq OWNER TO saleor;

    --
    -- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.auth_group_id_seq OWNED BY public.account_group.id;


    --
    -- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.auth_group_permissions_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.auth_group_permissions_id_seq OWNER TO saleor;

    --
    -- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.auth_group_permissions_id_seq OWNED BY public.account_group_permissions.id;


    --
    -- Name: permission_permission; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.permission_permission (
        id integer NOT NULL,
        name character varying(255) NOT NULL,
        content_type_id integer NOT NULL,
        codename character varying(100) NOT NULL
    );


    ALTER TABLE public.permission_permission OWNER TO saleor;

    --
    -- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.auth_permission_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.auth_permission_id_seq OWNER TO saleor;

    --
    -- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.permission_permission.id;


    --
    -- Name: channel_channel; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.channel_channel (
        id integer NOT NULL,
        name character varying(250) NOT NULL,
        slug character varying(255) NOT NULL,
        is_active boolean NOT NULL,
        currency_code character varying(3) NOT NULL,
        default_country character varying(2) NOT NULL,
        allocation_strategy character varying(255) NOT NULL,
        automatically_confirm_all_new_orders boolean,
        automatically_fulfill_non_shippable_gift_card boolean,
        order_mark_as_paid_strategy character varying(255) DEFAULT 'payment_flow'::character varying NOT NULL,
        default_transaction_flow_strategy character varying(255) DEFAULT 'charge'::character varying NOT NULL,
        expire_orders_after integer,
        delete_expired_orders_after interval DEFAULT '60 days'::interval NOT NULL,
        metadata jsonb,
        private_metadata jsonb,
        allow_unpaid_orders boolean DEFAULT false NOT NULL,
        use_legacy_error_flow_for_checkout boolean DEFAULT true NOT NULL,
        include_draft_order_in_voucher_usage boolean DEFAULT false NOT NULL
    );


    ALTER TABLE public.channel_channel OWNER TO saleor;

    --
    -- Name: channel_channel_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.channel_channel_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.channel_channel_id_seq OWNER TO saleor;

    --
    -- Name: channel_channel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.channel_channel_id_seq OWNED BY public.channel_channel.id;


    --
    -- Name: checkout_checkout; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.checkout_checkout (
        created_at timestamp with time zone NOT NULL,
        last_change timestamp with time zone NOT NULL,
        email character varying(254),
        token uuid NOT NULL,
        user_id integer,
        billing_address_id integer,
        discount_amount numeric(12,3) NOT NULL,
        discount_name character varying(255),
        note text NOT NULL,
        shipping_address_id integer,
        shipping_method_id integer,
        voucher_code character varying(255),
        translated_discount_name character varying(255),
        metadata jsonb,
        private_metadata jsonb,
        currency character varying(3) NOT NULL,
        country character varying(2) NOT NULL,
        redirect_url character varying(200),
        tracking_code character varying(255),
        channel_id integer NOT NULL,
        language_code character varying(35) NOT NULL,
        collection_point_id uuid,
        price_expiration timestamp with time zone NOT NULL,
        shipping_price_gross_amount numeric(12,3) NOT NULL,
        shipping_price_net_amount numeric(12,3) NOT NULL,
        shipping_tax_rate numeric(5,4) NOT NULL,
        subtotal_gross_amount numeric(12,3) NOT NULL,
        subtotal_net_amount numeric(12,3) NOT NULL,
        total_gross_amount numeric(12,3) NOT NULL,
        total_net_amount numeric(12,3) NOT NULL,
        tax_exemption boolean DEFAULT false NOT NULL,
        authorize_status character varying(32) DEFAULT 'none'::character varying NOT NULL,
        charge_status character varying(32) DEFAULT 'none'::character varying NOT NULL,
        last_transaction_modified_at timestamp with time zone,
        automatically_refundable boolean DEFAULT false NOT NULL,
        base_subtotal_amount numeric(12,3) DEFAULT 0 NOT NULL,
        base_total_amount numeric(12,3) DEFAULT 0 NOT NULL,
        tax_error character varying(255),
        is_voucher_usage_increased boolean DEFAULT false NOT NULL,
        completing_started_at timestamp with time zone
    );


    ALTER TABLE public.checkout_checkout OWNER TO saleor;

    --
    -- Name: checkout_checkout_gift_cards; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.checkout_checkout_gift_cards (
        id integer NOT NULL,
        checkout_id uuid NOT NULL,
        giftcard_id integer NOT NULL
    );


    ALTER TABLE public.checkout_checkout_gift_cards OWNER TO saleor;

    --
    -- Name: checkout_checkout_gift_cards_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.checkout_checkout_gift_cards_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.checkout_checkout_gift_cards_id_seq OWNER TO saleor;

    --
    -- Name: checkout_checkout_gift_cards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.checkout_checkout_gift_cards_id_seq OWNED BY public.checkout_checkout_gift_cards.id;


    --
    -- Name: checkout_checkoutline; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.checkout_checkoutline (
        quantity integer NOT NULL,
        checkout_id uuid NOT NULL,
        variant_id integer NOT NULL,
        price_override numeric(12,3),
        created_at timestamp with time zone NOT NULL,
        old_id integer,
        id uuid NOT NULL,
        metadata jsonb,
        private_metadata jsonb,
        currency character varying(3) NOT NULL,
        tax_rate numeric(5,4) NOT NULL,
        total_price_gross_amount numeric(12,3) NOT NULL,
        total_price_net_amount numeric(12,3) NOT NULL,
        is_gift boolean DEFAULT false NOT NULL,
        CONSTRAINT cart_cartline_quantity_check CHECK ((quantity >= 0)),
        CONSTRAINT checkout_checkoutline_old_id_check CHECK ((old_id >= 0))
    );


    ALTER TABLE public.checkout_checkoutline OWNER TO saleor;

    --
    -- Name: checkout_checkoutmetadata; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.checkout_checkoutmetadata (
        id integer NOT NULL,
        private_metadata jsonb,
        metadata jsonb,
        checkout_id uuid NOT NULL
    );


    ALTER TABLE public.checkout_checkoutmetadata OWNER TO saleor;

    --
    -- Name: checkout_checkoutmetadata_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.checkout_checkoutmetadata_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.checkout_checkoutmetadata_id_seq OWNER TO saleor;

    --
    -- Name: checkout_checkoutmetadata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.checkout_checkoutmetadata_id_seq OWNED BY public.checkout_checkoutmetadata.id;


    --
    -- Name: core_eventdelivery; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.core_eventdelivery (
        id integer NOT NULL,
        created_at timestamp with time zone NOT NULL,
        status character varying(255) NOT NULL,
        event_type character varying(255) NOT NULL,
        payload_id integer,
        webhook_id integer NOT NULL
    );


    ALTER TABLE public.core_eventdelivery OWNER TO saleor;

    --
    -- Name: core_eventdelivery_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.core_eventdelivery_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.core_eventdelivery_id_seq OWNER TO saleor;

    --
    -- Name: core_eventdelivery_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.core_eventdelivery_id_seq OWNED BY public.core_eventdelivery.id;


    --
    -- Name: core_eventdeliveryattempt; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.core_eventdeliveryattempt (
        id integer NOT NULL,
        created_at timestamp with time zone NOT NULL,
        task_id character varying(255),
        duration double precision,
        response text,
        response_headers text,
        request_headers text,
        status character varying(255) NOT NULL,
        delivery_id integer,
        response_status_code smallint,
        CONSTRAINT core_eventdeliveryattempt_response_status_code_check CHECK ((response_status_code >= 0))
    );


    ALTER TABLE public.core_eventdeliveryattempt OWNER TO saleor;

    --
    -- Name: core_eventdeliveryattempt_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.core_eventdeliveryattempt_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.core_eventdeliveryattempt_id_seq OWNER TO saleor;

    --
    -- Name: core_eventdeliveryattempt_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.core_eventdeliveryattempt_id_seq OWNED BY public.core_eventdeliveryattempt.id;


    --
    -- Name: core_eventpayload; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.core_eventpayload (
        id integer NOT NULL,
        payload text NOT NULL,
        created_at timestamp with time zone NOT NULL
    );


    ALTER TABLE public.core_eventpayload OWNER TO saleor;

    --
    -- Name: core_eventpayload_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.core_eventpayload_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.core_eventpayload_id_seq OWNER TO saleor;

    --
    -- Name: core_eventpayload_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.core_eventpayload_id_seq OWNED BY public.core_eventpayload.id;


    --
    -- Name: csv_exportevent; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.csv_exportevent (
        id integer NOT NULL,
        date timestamp with time zone NOT NULL,
        type character varying(255) NOT NULL,
        parameters jsonb NOT NULL,
        app_id integer,
        export_file_id integer NOT NULL,
        user_id integer
    );


    ALTER TABLE public.csv_exportevent OWNER TO saleor;

    --
    -- Name: csv_exportevent_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.csv_exportevent_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.csv_exportevent_id_seq OWNER TO saleor;

    --
    -- Name: csv_exportevent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.csv_exportevent_id_seq OWNED BY public.csv_exportevent.id;


    --
    -- Name: csv_exportfile; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.csv_exportfile (
        id integer NOT NULL,
        status character varying(50) NOT NULL,
        created_at timestamp with time zone NOT NULL,
        updated_at timestamp with time zone NOT NULL,
        content_file character varying(100),
        app_id integer,
        user_id integer,
        message character varying(255)
    );


    ALTER TABLE public.csv_exportfile OWNER TO saleor;

    --
    -- Name: csv_exportfile_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.csv_exportfile_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.csv_exportfile_id_seq OWNER TO saleor;

    --
    -- Name: csv_exportfile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.csv_exportfile_id_seq OWNED BY public.csv_exportfile.id;


    --
    -- Name: discount_checkoutdiscount; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.discount_checkoutdiscount (
        id uuid NOT NULL,
        created_at timestamp with time zone NOT NULL,
        type character varying(64) NOT NULL,
        value_type character varying(10) NOT NULL,
        value numeric(12,3) NOT NULL,
        amount_value numeric(12,3) NOT NULL,
        currency character varying(3) NOT NULL,
        name character varying(255),
        translated_name character varying(255),
        reason text,
        voucher_code character varying(255),
        checkout_id uuid,
        promotion_rule_id uuid,
        voucher_id integer
    );


    ALTER TABLE public.discount_checkoutdiscount OWNER TO saleor;

    --
    -- Name: discount_checkoutlinediscount; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.discount_checkoutlinediscount (
        id uuid NOT NULL,
        created_at timestamp with time zone NOT NULL,
        type character varying(64) NOT NULL,
        value_type character varying(10) NOT NULL,
        value numeric(12,3) NOT NULL,
        amount_value numeric(12,3) NOT NULL,
        currency character varying(3) NOT NULL,
        name character varying(255),
        translated_name character varying(255),
        reason text,
        line_id uuid,
        sale_id integer,
        voucher_id integer,
        promotion_rule_id uuid,
        voucher_code character varying(255),
        unique_type character varying(64)
    );


    ALTER TABLE public.discount_checkoutlinediscount OWNER TO saleor;

    --
    -- Name: discount_orderdiscount; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.discount_orderdiscount (
        type character varying(64) NOT NULL,
        value_type character varying(10) NOT NULL,
        value numeric(12,3) NOT NULL,
        amount_value numeric(12,3) NOT NULL,
        currency character varying(3) NOT NULL,
        name character varying(255),
        translated_name character varying(255),
        reason text,
        order_id uuid,
        created_at timestamp with time zone NOT NULL,
        old_id integer,
        id uuid NOT NULL,
        sale_id integer,
        voucher_id integer,
        promotion_rule_id uuid,
        voucher_code character varying(255),
        CONSTRAINT discount_orderdiscount_old_id_check CHECK ((old_id >= 0))
    );


    ALTER TABLE public.discount_orderdiscount OWNER TO saleor;

    --
    -- Name: discount_orderlinediscount; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.discount_orderlinediscount (
        id uuid NOT NULL,
        created_at timestamp with time zone NOT NULL,
        type character varying(64) NOT NULL,
        value_type character varying(10) NOT NULL,
        value numeric(12,3) NOT NULL,
        amount_value numeric(12,3) NOT NULL,
        currency character varying(3) NOT NULL,
        name character varying(255),
        translated_name character varying(255),
        reason text,
        line_id uuid,
        promotion_rule_id uuid,
        sale_id integer,
        voucher_id integer,
        voucher_code character varying(255),
        unique_type character varying(64)
    );


    ALTER TABLE public.discount_orderlinediscount OWNER TO saleor;

    --
    -- Name: discount_promotion; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.discount_promotion (
        id uuid NOT NULL,
        private_metadata jsonb,
        metadata jsonb,
        name character varying(255) NOT NULL,
        description jsonb,
        old_sale_id integer,
        start_date timestamp with time zone NOT NULL,
        end_date timestamp with time zone,
        created_at timestamp with time zone NOT NULL,
        updated_at timestamp with time zone NOT NULL,
        last_notification_scheduled_at timestamp with time zone,
        type character varying(255) DEFAULT 'catalogue'::character varying NOT NULL
    );


    ALTER TABLE public.discount_promotion OWNER TO saleor;

    --
    -- Name: discount_promotion_old_sale_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.discount_promotion_old_sale_id_seq
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.discount_promotion_old_sale_id_seq OWNER TO saleor;

    --
    -- Name: discount_promotion_old_sale_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.discount_promotion_old_sale_id_seq OWNED BY public.discount_promotion.old_sale_id;


    --
    -- Name: discount_promotionevent; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.discount_promotionevent (
        id uuid NOT NULL,
        date timestamp with time zone NOT NULL,
        type character varying(255) NOT NULL,
        parameters jsonb NOT NULL,
        app_id integer,
        promotion_id uuid NOT NULL,
        user_id integer
    );


    ALTER TABLE public.discount_promotionevent OWNER TO saleor;

    --
    -- Name: discount_promotionrule; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.discount_promotionrule (
        id uuid NOT NULL,
        name character varying(255),
        description jsonb,
        catalogue_predicate jsonb NOT NULL,
        reward_value_type character varying(255),
        reward_value numeric(12,3),
        promotion_id uuid NOT NULL,
        old_channel_listing_id integer,
        order_predicate jsonb DEFAULT '{}'::jsonb NOT NULL,
        reward_type character varying(255),
        variants_dirty boolean DEFAULT false
    );


    ALTER TABLE public.discount_promotionrule OWNER TO saleor;

    --
    -- Name: discount_promotionrule_channels; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.discount_promotionrule_channels (
        id integer NOT NULL,
        promotionrule_id uuid NOT NULL,
        channel_id integer NOT NULL
    );


    ALTER TABLE public.discount_promotionrule_channels OWNER TO saleor;

    --
    -- Name: discount_promotionrule_channels_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.discount_promotionrule_channels_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.discount_promotionrule_channels_id_seq OWNER TO saleor;

    --
    -- Name: discount_promotionrule_channels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.discount_promotionrule_channels_id_seq OWNED BY public.discount_promotionrule_channels.id;


    --
    -- Name: discount_promotionrule_gifts; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.discount_promotionrule_gifts (
        id integer NOT NULL,
        promotionrule_id uuid NOT NULL,
        productvariant_id integer NOT NULL
    );


    ALTER TABLE public.discount_promotionrule_gifts OWNER TO saleor;

    --
    -- Name: discount_promotionrule_gifts_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.discount_promotionrule_gifts_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.discount_promotionrule_gifts_id_seq OWNER TO saleor;

    --
    -- Name: discount_promotionrule_gifts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.discount_promotionrule_gifts_id_seq OWNED BY public.discount_promotionrule_gifts.id;


    --
    -- Name: discount_promotionrule_old_channel_listing_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.discount_promotionrule_old_channel_listing_id_seq
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.discount_promotionrule_old_channel_listing_id_seq OWNER TO saleor;

    --
    -- Name: discount_promotionrule_old_channel_listing_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.discount_promotionrule_old_channel_listing_id_seq OWNED BY public.discount_promotionrule.old_channel_listing_id;


    --
    -- Name: discount_promotionrule_variants; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.discount_promotionrule_variants (
        id bigint NOT NULL,
        promotionrule_id uuid NOT NULL,
        productvariant_id integer NOT NULL
    );


    ALTER TABLE public.discount_promotionrule_variants OWNER TO saleor;

    --
    -- Name: discount_promotionrule_variants_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.discount_promotionrule_variants_id_seq
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.discount_promotionrule_variants_id_seq OWNER TO saleor;

    --
    -- Name: discount_promotionrule_variants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.discount_promotionrule_variants_id_seq OWNED BY public.discount_promotionrule_variants.id;


    --
    -- Name: discount_promotionruletranslation; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.discount_promotionruletranslation (
        id integer NOT NULL,
        language_code character varying(35) NOT NULL,
        name character varying(255),
        description jsonb,
        promotion_rule_id uuid NOT NULL
    );


    ALTER TABLE public.discount_promotionruletranslation OWNER TO saleor;

    --
    -- Name: discount_promotionruletranslation_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.discount_promotionruletranslation_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.discount_promotionruletranslation_id_seq OWNER TO saleor;

    --
    -- Name: discount_promotionruletranslation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.discount_promotionruletranslation_id_seq OWNED BY public.discount_promotionruletranslation.id;


    --
    -- Name: discount_promotiontranslation; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.discount_promotiontranslation (
        id integer NOT NULL,
        language_code character varying(35) NOT NULL,
        name character varying(255),
        description jsonb,
        promotion_id uuid NOT NULL
    );


    ALTER TABLE public.discount_promotiontranslation OWNER TO saleor;

    --
    -- Name: discount_promotiontranslation_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.discount_promotiontranslation_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.discount_promotiontranslation_id_seq OWNER TO saleor;

    --
    -- Name: discount_promotiontranslation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.discount_promotiontranslation_id_seq OWNED BY public.discount_promotiontranslation.id;


    --
    -- Name: discount_voucher; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.discount_voucher (
        id integer NOT NULL,
        type character varying(20) NOT NULL,
        name character varying(255),
        usage_limit integer,
        start_date timestamp with time zone NOT NULL,
        end_date timestamp with time zone,
        discount_value_type character varying(10) NOT NULL,
        apply_once_per_order boolean NOT NULL,
        countries character varying(749) NOT NULL,
        min_checkout_items_quantity integer,
        apply_once_per_customer boolean NOT NULL,
        only_for_staff boolean NOT NULL,
        metadata jsonb,
        private_metadata jsonb,
        single_use boolean DEFAULT false NOT NULL,
        CONSTRAINT discount_voucher_min_checkout_items_quantity_check CHECK ((min_checkout_items_quantity >= 0)),
        CONSTRAINT discount_voucher_usage_limit_check CHECK ((usage_limit >= 0))
    );


    ALTER TABLE public.discount_voucher OWNER TO saleor;

    --
    -- Name: discount_voucher_categories; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.discount_voucher_categories (
        id integer NOT NULL,
        voucher_id integer NOT NULL,
        category_id integer NOT NULL
    );


    ALTER TABLE public.discount_voucher_categories OWNER TO saleor;

    --
    -- Name: discount_voucher_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.discount_voucher_categories_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.discount_voucher_categories_id_seq OWNER TO saleor;

    --
    -- Name: discount_voucher_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.discount_voucher_categories_id_seq OWNED BY public.discount_voucher_categories.id;


    --
    -- Name: discount_voucher_collections; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.discount_voucher_collections (
        id integer NOT NULL,
        voucher_id integer NOT NULL,
        collection_id integer NOT NULL
    );


    ALTER TABLE public.discount_voucher_collections OWNER TO saleor;

    --
    -- Name: discount_voucher_collections_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.discount_voucher_collections_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.discount_voucher_collections_id_seq OWNER TO saleor;

    --
    -- Name: discount_voucher_collections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.discount_voucher_collections_id_seq OWNED BY public.discount_voucher_collections.id;


    --
    -- Name: discount_voucher_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.discount_voucher_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.discount_voucher_id_seq OWNER TO saleor;

    --
    -- Name: discount_voucher_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.discount_voucher_id_seq OWNED BY public.discount_voucher.id;


    --
    -- Name: discount_voucher_products; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.discount_voucher_products (
        id integer NOT NULL,
        voucher_id integer NOT NULL,
        product_id integer NOT NULL
    );


    ALTER TABLE public.discount_voucher_products OWNER TO saleor;

    --
    -- Name: discount_voucher_products_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.discount_voucher_products_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.discount_voucher_products_id_seq OWNER TO saleor;

    --
    -- Name: discount_voucher_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.discount_voucher_products_id_seq OWNED BY public.discount_voucher_products.id;


    --
    -- Name: discount_voucher_variants; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.discount_voucher_variants (
        id integer NOT NULL,
        voucher_id integer NOT NULL,
        productvariant_id integer NOT NULL
    );


    ALTER TABLE public.discount_voucher_variants OWNER TO saleor;

    --
    -- Name: discount_voucher_variants_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.discount_voucher_variants_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.discount_voucher_variants_id_seq OWNER TO saleor;

    --
    -- Name: discount_voucher_variants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.discount_voucher_variants_id_seq OWNED BY public.discount_voucher_variants.id;


    --
    -- Name: discount_voucherchannellisting; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.discount_voucherchannellisting (
        id integer NOT NULL,
        discount_value numeric(12,3) NOT NULL,
        currency character varying(3) NOT NULL,
        min_spent_amount numeric(12,3),
        channel_id integer NOT NULL,
        voucher_id integer NOT NULL
    );


    ALTER TABLE public.discount_voucherchannellisting OWNER TO saleor;

    --
    -- Name: discount_voucherchannellisting_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.discount_voucherchannellisting_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.discount_voucherchannellisting_id_seq OWNER TO saleor;

    --
    -- Name: discount_voucherchannellisting_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.discount_voucherchannellisting_id_seq OWNED BY public.discount_voucherchannellisting.id;


    --
    -- Name: discount_vouchercode; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.discount_vouchercode (
        id uuid NOT NULL,
        code character varying(255) NOT NULL,
        used integer NOT NULL,
        is_active boolean DEFAULT true NOT NULL,
        created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
        voucher_id integer NOT NULL,
        CONSTRAINT discount_vouchercode_used_check CHECK ((used >= 0))
    );


    ALTER TABLE public.discount_vouchercode OWNER TO saleor;

    --
    -- Name: discount_vouchercustomer; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.discount_vouchercustomer (
        id integer NOT NULL,
        customer_email character varying(254) NOT NULL,
        voucher_code_id uuid NOT NULL
    );


    ALTER TABLE public.discount_vouchercustomer OWNER TO saleor;

    --
    -- Name: discount_vouchercustomer_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.discount_vouchercustomer_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.discount_vouchercustomer_id_seq OWNER TO saleor;

    --
    -- Name: discount_vouchercustomer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.discount_vouchercustomer_id_seq OWNED BY public.discount_vouchercustomer.id;


    --
    -- Name: discount_vouchertranslation; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.discount_vouchertranslation (
        id integer NOT NULL,
        language_code character varying(35) NOT NULL,
        name character varying(255),
        voucher_id integer NOT NULL
    );


    ALTER TABLE public.discount_vouchertranslation OWNER TO saleor;

    --
    -- Name: discount_vouchertranslation_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.discount_vouchertranslation_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.discount_vouchertranslation_id_seq OWNER TO saleor;

    --
    -- Name: discount_vouchertranslation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.discount_vouchertranslation_id_seq OWNED BY public.discount_vouchertranslation.id;


    --
    -- Name: django_celery_beat_clockedschedule; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.django_celery_beat_clockedschedule (
        id integer NOT NULL,
        clocked_time timestamp with time zone NOT NULL
    );


    ALTER TABLE public.django_celery_beat_clockedschedule OWNER TO saleor;

    --
    -- Name: django_celery_beat_clockedschedule_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.django_celery_beat_clockedschedule_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.django_celery_beat_clockedschedule_id_seq OWNER TO saleor;

    --
    -- Name: django_celery_beat_clockedschedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.django_celery_beat_clockedschedule_id_seq OWNED BY public.django_celery_beat_clockedschedule.id;


    --
    -- Name: django_celery_beat_crontabschedule; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.django_celery_beat_crontabschedule (
        id integer NOT NULL,
        minute character varying(240) NOT NULL,
        hour character varying(96) NOT NULL,
        day_of_week character varying(64) NOT NULL,
        day_of_month character varying(124) NOT NULL,
        month_of_year character varying(64) NOT NULL,
        timezone character varying(63) NOT NULL
    );


    ALTER TABLE public.django_celery_beat_crontabschedule OWNER TO saleor;

    --
    -- Name: django_celery_beat_crontabschedule_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.django_celery_beat_crontabschedule_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.django_celery_beat_crontabschedule_id_seq OWNER TO saleor;

    --
    -- Name: django_celery_beat_crontabschedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.django_celery_beat_crontabschedule_id_seq OWNED BY public.django_celery_beat_crontabschedule.id;


    --
    -- Name: django_celery_beat_intervalschedule; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.django_celery_beat_intervalschedule (
        id integer NOT NULL,
        every integer NOT NULL,
        period character varying(24) NOT NULL
    );


    ALTER TABLE public.django_celery_beat_intervalschedule OWNER TO saleor;

    --
    -- Name: django_celery_beat_intervalschedule_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.django_celery_beat_intervalschedule_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.django_celery_beat_intervalschedule_id_seq OWNER TO saleor;

    --
    -- Name: django_celery_beat_intervalschedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.django_celery_beat_intervalschedule_id_seq OWNED BY public.django_celery_beat_intervalschedule.id;


    --
    -- Name: django_celery_beat_periodictask; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.django_celery_beat_periodictask (
        id integer NOT NULL,
        name character varying(200) NOT NULL,
        task character varying(200) NOT NULL,
        args text NOT NULL,
        kwargs text NOT NULL,
        queue character varying(200),
        exchange character varying(200),
        routing_key character varying(200),
        expires timestamp with time zone,
        enabled boolean NOT NULL,
        last_run_at timestamp with time zone,
        total_run_count integer NOT NULL,
        date_changed timestamp with time zone NOT NULL,
        description text NOT NULL,
        crontab_id integer,
        interval_id integer,
        solar_id integer,
        one_off boolean NOT NULL,
        start_time timestamp with time zone,
        priority integer,
        headers text NOT NULL,
        clocked_id integer,
        expire_seconds integer,
        CONSTRAINT django_celery_beat_periodictask_expire_seconds_check CHECK ((expire_seconds >= 0)),
        CONSTRAINT django_celery_beat_periodictask_priority_check CHECK ((priority >= 0)),
        CONSTRAINT django_celery_beat_periodictask_total_run_count_check CHECK ((total_run_count >= 0))
    );


    ALTER TABLE public.django_celery_beat_periodictask OWNER TO saleor;

    --
    -- Name: django_celery_beat_periodictask_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.django_celery_beat_periodictask_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.django_celery_beat_periodictask_id_seq OWNER TO saleor;

    --
    -- Name: django_celery_beat_periodictask_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.django_celery_beat_periodictask_id_seq OWNED BY public.django_celery_beat_periodictask.id;


    --
    -- Name: django_celery_beat_periodictasks; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.django_celery_beat_periodictasks (
        ident smallint NOT NULL,
        last_update timestamp with time zone NOT NULL
    );


    ALTER TABLE public.django_celery_beat_periodictasks OWNER TO saleor;

    --
    -- Name: django_celery_beat_solarschedule; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.django_celery_beat_solarschedule (
        id integer NOT NULL,
        event character varying(24) NOT NULL,
        latitude numeric(9,6) NOT NULL,
        longitude numeric(9,6) NOT NULL
    );


    ALTER TABLE public.django_celery_beat_solarschedule OWNER TO saleor;

    --
    -- Name: django_celery_beat_solarschedule_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.django_celery_beat_solarschedule_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.django_celery_beat_solarschedule_id_seq OWNER TO saleor;

    --
    -- Name: django_celery_beat_solarschedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.django_celery_beat_solarschedule_id_seq OWNED BY public.django_celery_beat_solarschedule.id;


    --
    -- Name: django_content_type; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.django_content_type (
        id integer NOT NULL,
        app_label character varying(100) NOT NULL,
        model character varying(100) NOT NULL
    );


    ALTER TABLE public.django_content_type OWNER TO saleor;

    --
    -- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.django_content_type_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.django_content_type_id_seq OWNER TO saleor;

    --
    -- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.django_content_type_id_seq OWNED BY public.django_content_type.id;


    --
    -- Name: django_migrations; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.django_migrations (
        id integer NOT NULL,
        app character varying(255) NOT NULL,
        name character varying(255) NOT NULL,
        applied timestamp with time zone NOT NULL
    );


    ALTER TABLE public.django_migrations OWNER TO saleor;

    --
    -- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.django_migrations_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.django_migrations_id_seq OWNER TO saleor;

    --
    -- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.django_migrations_id_seq OWNED BY public.django_migrations.id;


    --
    -- Name: django_site; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.django_site (
        id integer NOT NULL,
        domain character varying(100) NOT NULL,
        name character varying(50) NOT NULL
    );


    ALTER TABLE public.django_site OWNER TO saleor;

    --
    -- Name: django_site_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.django_site_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.django_site_id_seq OWNER TO saleor;

    --
    -- Name: django_site_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.django_site_id_seq OWNED BY public.django_site.id;


    --
    -- Name: giftcard_giftcard; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.giftcard_giftcard (
        id integer NOT NULL,
        code character varying(16) NOT NULL,
        created_at timestamp with time zone NOT NULL,
        last_used_on timestamp with time zone,
        is_active boolean NOT NULL,
        initial_balance_amount numeric(12,3) NOT NULL,
        current_balance_amount numeric(12,3) NOT NULL,
        currency character varying(3) NOT NULL,
        app_id integer,
        created_by_id integer,
        created_by_email character varying(254),
        expiry_date date,
        metadata jsonb,
        private_metadata jsonb,
        product_id integer,
        used_by_id integer,
        used_by_email character varying(254),
        fulfillment_line_id integer,
        search_index_dirty boolean DEFAULT true NOT NULL,
        search_vector tsvector
    );


    ALTER TABLE public.giftcard_giftcard OWNER TO saleor;

    --
    -- Name: giftcard_giftcard_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.giftcard_giftcard_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.giftcard_giftcard_id_seq OWNER TO saleor;

    --
    -- Name: giftcard_giftcard_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.giftcard_giftcard_id_seq OWNED BY public.giftcard_giftcard.id;


    --
    -- Name: giftcard_giftcard_tags; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.giftcard_giftcard_tags (
        id integer NOT NULL,
        giftcard_id integer NOT NULL,
        giftcardtag_id integer NOT NULL
    );


    ALTER TABLE public.giftcard_giftcard_tags OWNER TO saleor;

    --
    -- Name: giftcard_giftcard_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.giftcard_giftcard_tags_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.giftcard_giftcard_tags_id_seq OWNER TO saleor;

    --
    -- Name: giftcard_giftcard_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.giftcard_giftcard_tags_id_seq OWNED BY public.giftcard_giftcard_tags.id;


    --
    -- Name: giftcard_giftcardevent; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.giftcard_giftcardevent (
        id integer NOT NULL,
        date timestamp with time zone NOT NULL,
        type character varying(255) NOT NULL,
        parameters jsonb NOT NULL,
        app_id integer,
        gift_card_id integer NOT NULL,
        user_id integer,
        order_id uuid
    );


    ALTER TABLE public.giftcard_giftcardevent OWNER TO saleor;

    --
    -- Name: giftcard_giftcardevent_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.giftcard_giftcardevent_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.giftcard_giftcardevent_id_seq OWNER TO saleor;

    --
    -- Name: giftcard_giftcardevent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.giftcard_giftcardevent_id_seq OWNED BY public.giftcard_giftcardevent.id;


    --
    -- Name: giftcard_giftcardtag; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.giftcard_giftcardtag (
        id integer NOT NULL,
        name character varying(255) NOT NULL
    );


    ALTER TABLE public.giftcard_giftcardtag OWNER TO saleor;

    --
    -- Name: giftcard_giftcardtag_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.giftcard_giftcardtag_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.giftcard_giftcardtag_id_seq OWNER TO saleor;

    --
    -- Name: giftcard_giftcardtag_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.giftcard_giftcardtag_id_seq OWNED BY public.giftcard_giftcardtag.id;


    --
    -- Name: invoice_invoice; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.invoice_invoice (
        id integer NOT NULL,
        private_metadata jsonb,
        metadata jsonb,
        status character varying(50) NOT NULL,
        created_at timestamp with time zone NOT NULL,
        updated_at timestamp with time zone NOT NULL,
        number character varying(255),
        created timestamp with time zone,
        external_url character varying(2048),
        invoice_file character varying(100) NOT NULL,
        message character varying(255),
        order_id uuid
    );


    ALTER TABLE public.invoice_invoice OWNER TO saleor;

    --
    -- Name: invoice_invoice_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.invoice_invoice_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.invoice_invoice_id_seq OWNER TO saleor;

    --
    -- Name: invoice_invoice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.invoice_invoice_id_seq OWNED BY public.invoice_invoice.id;


    --
    -- Name: invoice_invoiceevent; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.invoice_invoiceevent (
        id integer NOT NULL,
        date timestamp with time zone NOT NULL,
        type character varying(255) NOT NULL,
        parameters jsonb NOT NULL,
        invoice_id integer,
        user_id integer,
        app_id integer,
        order_id uuid
    );


    ALTER TABLE public.invoice_invoiceevent OWNER TO saleor;

    --
    -- Name: invoice_invoiceevent_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.invoice_invoiceevent_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.invoice_invoiceevent_id_seq OWNER TO saleor;

    --
    -- Name: invoice_invoiceevent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.invoice_invoiceevent_id_seq OWNED BY public.invoice_invoiceevent.id;


    --
    -- Name: menu_menu; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.menu_menu (
        id integer NOT NULL,
        name character varying(250) NOT NULL,
        slug character varying(255) NOT NULL,
        metadata jsonb,
        private_metadata jsonb
    );


    ALTER TABLE public.menu_menu OWNER TO saleor;

    --
    -- Name: menu_menu_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.menu_menu_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.menu_menu_id_seq OWNER TO saleor;

    --
    -- Name: menu_menu_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.menu_menu_id_seq OWNED BY public.menu_menu.id;


    --
    -- Name: menu_menuitem; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.menu_menuitem (
        id integer NOT NULL,
        name character varying(128) NOT NULL,
        sort_order integer,
        url character varying(256),
        lft integer NOT NULL,
        rght integer NOT NULL,
        tree_id integer NOT NULL,
        level integer NOT NULL,
        category_id integer,
        collection_id integer,
        menu_id integer NOT NULL,
        page_id integer,
        parent_id integer,
        metadata jsonb,
        private_metadata jsonb,
        CONSTRAINT menu_menuitem_level_check CHECK ((level >= 0)),
        CONSTRAINT menu_menuitem_lft_check CHECK ((lft >= 0)),
        CONSTRAINT menu_menuitem_rght_check CHECK ((rght >= 0)),
        CONSTRAINT menu_menuitem_tree_id_check CHECK ((tree_id >= 0))
    );


    ALTER TABLE public.menu_menuitem OWNER TO saleor;

    --
    -- Name: menu_menuitem_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.menu_menuitem_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.menu_menuitem_id_seq OWNER TO saleor;

    --
    -- Name: menu_menuitem_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.menu_menuitem_id_seq OWNED BY public.menu_menuitem.id;


    --
    -- Name: menu_menuitemtranslation; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.menu_menuitemtranslation (
        id integer NOT NULL,
        language_code character varying(35) NOT NULL,
        name character varying(128) NOT NULL,
        menu_item_id integer NOT NULL
    );


    ALTER TABLE public.menu_menuitemtranslation OWNER TO saleor;

    --
    -- Name: menu_menuitemtranslation_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.menu_menuitemtranslation_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.menu_menuitemtranslation_id_seq OWNER TO saleor;

    --
    -- Name: menu_menuitemtranslation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.menu_menuitemtranslation_id_seq OWNED BY public.menu_menuitemtranslation.id;


    --
    -- Name: order_fulfillment; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.order_fulfillment (
        id integer NOT NULL,
        tracking_number character varying(255) NOT NULL,
        created_at timestamp with time zone NOT NULL,
        fulfillment_order integer NOT NULL,
        status character varying(32) NOT NULL,
        metadata jsonb,
        private_metadata jsonb,
        shipping_refund_amount numeric(12,3),
        total_refund_amount numeric(12,3),
        order_id uuid NOT NULL,
        CONSTRAINT order_fulfillment_fulfillment_order_check CHECK ((fulfillment_order >= 0))
    );


    ALTER TABLE public.order_fulfillment OWNER TO saleor;

    --
    -- Name: order_fulfillment_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.order_fulfillment_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.order_fulfillment_id_seq OWNER TO saleor;

    --
    -- Name: order_fulfillment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.order_fulfillment_id_seq OWNED BY public.order_fulfillment.id;


    --
    -- Name: order_fulfillmentline; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.order_fulfillmentline (
        id integer NOT NULL,
        quantity integer NOT NULL,
        fulfillment_id integer NOT NULL,
        stock_id integer,
        order_line_id uuid NOT NULL,
        CONSTRAINT order_fulfillmentline_quantity_81b787d3_check CHECK ((quantity >= 0))
    );


    ALTER TABLE public.order_fulfillmentline OWNER TO saleor;

    --
    -- Name: order_fulfillmentline_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.order_fulfillmentline_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.order_fulfillmentline_id_seq OWNER TO saleor;

    --
    -- Name: order_fulfillmentline_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.order_fulfillmentline_id_seq OWNED BY public.order_fulfillmentline.id;


    --
    -- Name: order_order; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.order_order (
        created_at timestamp with time zone NOT NULL,
        tracking_client_id character varying(36) NOT NULL,
        user_email character varying(254) NOT NULL,
        id uuid NOT NULL,
        billing_address_id integer,
        shipping_address_id integer,
        user_id integer,
        total_net_amount numeric(12,3) NOT NULL,
        voucher_id integer,
        language_code character varying(35) NOT NULL,
        shipping_price_gross_amount numeric(12,3) NOT NULL,
        total_gross_amount numeric(12,3) NOT NULL,
        shipping_price_net_amount numeric(12,3) NOT NULL,
        status character varying(32) NOT NULL,
        shipping_method_name character varying(255),
        shipping_method_id integer,
        display_gross_prices boolean NOT NULL,
        customer_note text NOT NULL,
        weight double precision NOT NULL,
        checkout_token character varying(36) NOT NULL,
        currency character varying(3) NOT NULL,
        metadata jsonb,
        private_metadata jsonb,
        channel_id integer NOT NULL,
        redirect_url character varying(200),
        shipping_tax_rate numeric(5,4),
        undiscounted_total_gross_amount numeric(12,3) NOT NULL,
        undiscounted_total_net_amount numeric(12,3) NOT NULL,
        total_charged_amount numeric(12,3) NOT NULL,
        origin character varying(32) NOT NULL,
        collection_point_id uuid,
        collection_point_name character varying(255),
        search_document text NOT NULL,
        updated_at timestamp with time zone NOT NULL,
        use_old_id boolean NOT NULL,
        number integer NOT NULL,
        original_id uuid,
        total_authorized_amount numeric(12,3) NOT NULL,
        authorize_status character varying(32) NOT NULL,
        charge_status character varying(32) NOT NULL,
        search_vector tsvector,
        should_refresh_prices boolean NOT NULL,
        tax_exemption boolean DEFAULT false NOT NULL,
        base_shipping_price_amount numeric(12,3) NOT NULL,
        shipping_tax_class_id integer,
        shipping_tax_class_metadata jsonb,
        shipping_tax_class_name character varying(255),
        shipping_tax_class_private_metadata jsonb,
        external_reference character varying(250),
        expired_at timestamp with time zone,
        voucher_code character varying(255),
        subtotal_gross_amount numeric(12,3) DEFAULT 0 NOT NULL,
        subtotal_net_amount numeric(12,3) DEFAULT 0 NOT NULL,
        tax_error character varying(255)
    );


    ALTER TABLE public.order_order OWNER TO saleor;

    --
    -- Name: order_order_gift_cards; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.order_order_gift_cards (
        id integer NOT NULL,
        giftcard_id integer NOT NULL,
        order_id uuid NOT NULL
    );


    ALTER TABLE public.order_order_gift_cards OWNER TO saleor;

    --
    -- Name: order_order_gift_cards_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.order_order_gift_cards_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.order_order_gift_cards_id_seq OWNER TO saleor;

    --
    -- Name: order_order_gift_cards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.order_order_gift_cards_id_seq OWNED BY public.order_order_gift_cards.id;


    --
    -- Name: order_order_number_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.order_order_number_seq
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.order_order_number_seq OWNER TO saleor;

    --
    -- Name: order_order_number_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.order_order_number_seq OWNED BY public.order_order.number;


    --
    -- Name: order_orderevent; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.order_orderevent (
        id integer NOT NULL,
        date timestamp with time zone NOT NULL,
        type character varying(255) NOT NULL,
        user_id integer,
        parameters jsonb NOT NULL,
        app_id integer,
        order_id uuid NOT NULL,
        related_id integer
    );


    ALTER TABLE public.order_orderevent OWNER TO saleor;

    --
    -- Name: order_orderevent_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.order_orderevent_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.order_orderevent_id_seq OWNER TO saleor;

    --
    -- Name: order_orderevent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.order_orderevent_id_seq OWNED BY public.order_orderevent.id;


    --
    -- Name: order_ordergrantedrefund; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.order_ordergrantedrefund (
        id integer NOT NULL,
        created_at timestamp with time zone NOT NULL,
        updated_at timestamp with time zone NOT NULL,
        amount_value numeric(12,3) NOT NULL,
        currency character varying(3) NOT NULL,
        reason text NOT NULL,
        app_id integer,
        order_id uuid NOT NULL,
        user_id integer,
        shipping_costs_included boolean DEFAULT false NOT NULL
    );


    ALTER TABLE public.order_ordergrantedrefund OWNER TO saleor;

    --
    -- Name: order_ordergrantedrefund_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.order_ordergrantedrefund_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.order_ordergrantedrefund_id_seq OWNER TO saleor;

    --
    -- Name: order_ordergrantedrefund_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.order_ordergrantedrefund_id_seq OWNED BY public.order_ordergrantedrefund.id;


    --
    -- Name: order_ordergrantedrefundline; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.order_ordergrantedrefundline (
        id integer NOT NULL,
        quantity integer NOT NULL,
        granted_refund_id integer NOT NULL,
        order_line_id uuid NOT NULL,
        reason text,
        CONSTRAINT order_ordergrantedrefundline_quantity_check CHECK ((quantity >= 0))
    );


    ALTER TABLE public.order_ordergrantedrefundline OWNER TO saleor;

    --
    -- Name: order_ordergrantedrefundline_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.order_ordergrantedrefundline_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.order_ordergrantedrefundline_id_seq OWNER TO saleor;

    --
    -- Name: order_ordergrantedrefundline_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.order_ordergrantedrefundline_id_seq OWNED BY public.order_ordergrantedrefundline.id;


    --
    -- Name: order_orderline; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.order_orderline (
        product_name character varying(386) NOT NULL,
        product_sku character varying(255),
        quantity integer NOT NULL,
        unit_price_net_amount numeric(12,3) NOT NULL,
        unit_price_gross_amount numeric(12,3) NOT NULL,
        is_shipping_required boolean NOT NULL,
        quantity_fulfilled integer NOT NULL,
        variant_id integer,
        tax_rate numeric(5,4),
        translated_product_name character varying(386) NOT NULL,
        currency character varying(3) NOT NULL,
        translated_variant_name character varying(255) NOT NULL,
        variant_name character varying(255) NOT NULL,
        total_price_gross_amount numeric(12,3) NOT NULL,
        total_price_net_amount numeric(12,3) NOT NULL,
        unit_discount_amount numeric(12,3) NOT NULL,
        unit_discount_value numeric(12,3) NOT NULL,
        unit_discount_reason text,
        unit_discount_type character varying(10) NOT NULL,
        undiscounted_total_price_gross_amount numeric(12,3) NOT NULL,
        undiscounted_total_price_net_amount numeric(12,3) NOT NULL,
        undiscounted_unit_price_gross_amount numeric(12,3) NOT NULL,
        undiscounted_unit_price_net_amount numeric(12,3) NOT NULL,
        is_gift_card boolean NOT NULL,
        product_variant_id character varying(255),
        sale_id character varying(255),
        voucher_code character varying(255),
        order_id uuid NOT NULL,
        id uuid NOT NULL,
        old_id integer,
        created_at timestamp with time zone NOT NULL,
        base_unit_price_amount numeric(12,3) NOT NULL,
        undiscounted_base_unit_price_amount numeric(12,3) NOT NULL,
        metadata jsonb,
        private_metadata jsonb,
        tax_class_id integer,
        tax_class_metadata jsonb,
        tax_class_name character varying(255),
        tax_class_private_metadata jsonb,
        is_gift boolean DEFAULT false NOT NULL,
        CONSTRAINT order_orderline_old_id_check CHECK ((old_id >= 0))
    );


    ALTER TABLE public.order_orderline OWNER TO saleor;

    --
    -- Name: page_page; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.page_page (
        id integer NOT NULL,
        slug character varying(255) NOT NULL,
        title character varying(250) NOT NULL,
        content jsonb,
        created_at timestamp with time zone NOT NULL,
        is_published boolean NOT NULL,
        published_at timestamp with time zone,
        seo_description character varying(300),
        seo_title character varying(70),
        metadata jsonb,
        private_metadata jsonb,
        page_type_id integer NOT NULL
    );


    ALTER TABLE public.page_page OWNER TO saleor;

    --
    -- Name: page_page_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.page_page_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.page_page_id_seq OWNER TO saleor;

    --
    -- Name: page_page_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.page_page_id_seq OWNED BY public.page_page.id;


    --
    -- Name: page_pagetranslation; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.page_pagetranslation (
        id integer NOT NULL,
        seo_title character varying(70),
        seo_description character varying(300),
        language_code character varying(35) NOT NULL,
        title character varying(255),
        content jsonb,
        page_id integer NOT NULL
    );


    ALTER TABLE public.page_pagetranslation OWNER TO saleor;

    --
    -- Name: page_pagetranslation_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.page_pagetranslation_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.page_pagetranslation_id_seq OWNER TO saleor;

    --
    -- Name: page_pagetranslation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.page_pagetranslation_id_seq OWNED BY public.page_pagetranslation.id;


    --
    -- Name: page_pagetype; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.page_pagetype (
        id integer NOT NULL,
        private_metadata jsonb,
        metadata jsonb,
        name character varying(250) NOT NULL,
        slug character varying(255) NOT NULL
    );


    ALTER TABLE public.page_pagetype OWNER TO saleor;

    --
    -- Name: page_pagetype_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.page_pagetype_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.page_pagetype_id_seq OWNER TO saleor;

    --
    -- Name: page_pagetype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.page_pagetype_id_seq OWNED BY public.page_pagetype.id;


    --
    -- Name: payment_payment; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.payment_payment (
        id integer NOT NULL,
        gateway character varying(255) NOT NULL,
        is_active boolean NOT NULL,
        created_at timestamp with time zone NOT NULL,
        modified_at timestamp with time zone NOT NULL,
        charge_status character varying(20) NOT NULL,
        billing_first_name character varying(256) NOT NULL,
        billing_last_name character varying(256) NOT NULL,
        billing_company_name character varying(256) NOT NULL,
        billing_address_1 character varying(256) NOT NULL,
        billing_address_2 character varying(256) NOT NULL,
        billing_city character varying(256) NOT NULL,
        billing_city_area character varying(128) NOT NULL,
        billing_postal_code character varying(256) NOT NULL,
        billing_country_code character varying(2) NOT NULL,
        billing_country_area character varying(256) NOT NULL,
        billing_email character varying(254) NOT NULL,
        customer_ip_address inet,
        cc_brand character varying(40) NOT NULL,
        cc_exp_month integer,
        cc_exp_year integer,
        cc_first_digits character varying(6) NOT NULL,
        cc_last_digits character varying(4) NOT NULL,
        extra_data text NOT NULL,
        token character varying(512) NOT NULL,
        currency character varying(3) NOT NULL,
        total numeric(12,3) NOT NULL,
        captured_amount numeric(12,3) NOT NULL,
        checkout_id uuid,
        to_confirm boolean NOT NULL,
        payment_method_type character varying(256) NOT NULL,
        return_url character varying(200),
        psp_reference character varying(512),
        partial boolean NOT NULL,
        metadata jsonb,
        private_metadata jsonb,
        store_payment_method character varying(11) NOT NULL,
        order_id uuid,
        CONSTRAINT payment_paymentmethod_cc_exp_month_check CHECK ((cc_exp_month >= 0)),
        CONSTRAINT payment_paymentmethod_cc_exp_year_check CHECK ((cc_exp_year >= 0))
    );


    ALTER TABLE public.payment_payment OWNER TO saleor;

    --
    -- Name: payment_paymentmethod_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.payment_paymentmethod_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.payment_paymentmethod_id_seq OWNER TO saleor;

    --
    -- Name: payment_paymentmethod_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.payment_paymentmethod_id_seq OWNED BY public.payment_payment.id;


    --
    -- Name: payment_transaction; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.payment_transaction (
        id integer NOT NULL,
        created_at timestamp with time zone NOT NULL,
        token character varying(512) NOT NULL,
        kind character varying(25) NOT NULL,
        is_success boolean NOT NULL,
        error text,
        currency character varying(3) NOT NULL,
        amount numeric(12,3) NOT NULL,
        gateway_response jsonb NOT NULL,
        payment_id integer NOT NULL,
        customer_id character varying(256),
        action_required boolean NOT NULL,
        action_required_data jsonb NOT NULL,
        already_processed boolean NOT NULL
    );


    ALTER TABLE public.payment_transaction OWNER TO saleor;

    --
    -- Name: payment_transaction_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.payment_transaction_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.payment_transaction_id_seq OWNER TO saleor;

    --
    -- Name: payment_transaction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.payment_transaction_id_seq OWNED BY public.payment_transaction.id;


    --
    -- Name: payment_transactionevent; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.payment_transactionevent (
        id integer NOT NULL,
        created_at timestamp with time zone NOT NULL,
        status character varying(128),
        transaction_id integer NOT NULL,
        amount_value numeric(12,3) DEFAULT 0 NOT NULL,
        app_id integer,
        app_identifier character varying(256),
        currency character varying(3) NOT NULL,
        external_url character varying(200),
        include_in_calculations boolean DEFAULT false NOT NULL,
        message character varying(512),
        psp_reference character varying(512),
        type character varying(128) DEFAULT 'info'::character varying NOT NULL,
        user_id integer,
        idempotency_key character varying(512)
    );


    ALTER TABLE public.payment_transactionevent OWNER TO saleor;

    --
    -- Name: payment_transactionevent_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.payment_transactionevent_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.payment_transactionevent_id_seq OWNER TO saleor;

    --
    -- Name: payment_transactionevent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.payment_transactionevent_id_seq OWNED BY public.payment_transactionevent.id;


    --
    -- Name: payment_transactionitem; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.payment_transactionitem (
        id integer NOT NULL,
        private_metadata jsonb,
        metadata jsonb,
        created_at timestamp with time zone NOT NULL,
        modified_at timestamp with time zone NOT NULL,
        status character varying(512),
        available_actions character varying(128)[] NOT NULL,
        currency character varying(3) NOT NULL,
        charged_value numeric(12,3) NOT NULL,
        authorized_value numeric(12,3) NOT NULL,
        refunded_value numeric(12,3) NOT NULL,
        checkout_id uuid,
        order_id uuid,
        app_id integer,
        app_identifier character varying(256),
        authorize_pending_value numeric(12,3) DEFAULT 0 NOT NULL,
        cancel_pending_value numeric(12,3) DEFAULT 0 NOT NULL,
        canceled_value numeric(12,3) DEFAULT 0 NOT NULL,
        charge_pending_value numeric(12,3) DEFAULT 0 NOT NULL,
        external_url character varying(200),
        message character varying(512),
        name character varying(512),
        psp_reference character varying(512),
        refund_pending_value numeric(12,3) DEFAULT 0 NOT NULL,
        user_id integer,
        token uuid NOT NULL,
        use_old_id boolean DEFAULT false NOT NULL,
        last_refund_success boolean DEFAULT true NOT NULL,
        idempotency_key character varying(512)
    );


    ALTER TABLE public.payment_transactionitem OWNER TO saleor;

    --
    -- Name: payment_transactionitem_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.payment_transactionitem_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.payment_transactionitem_id_seq OWNER TO saleor;

    --
    -- Name: payment_transactionitem_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.payment_transactionitem_id_seq OWNED BY public.payment_transactionitem.id;


    --
    -- Name: plugins_emailtemplate; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.plugins_emailtemplate (
        id integer NOT NULL,
        name character varying(255) NOT NULL,
        value text NOT NULL,
        plugin_configuration_id integer NOT NULL
    );


    ALTER TABLE public.plugins_emailtemplate OWNER TO saleor;

    --
    -- Name: plugins_emailtemplate_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.plugins_emailtemplate_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.plugins_emailtemplate_id_seq OWNER TO saleor;

    --
    -- Name: plugins_emailtemplate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.plugins_emailtemplate_id_seq OWNED BY public.plugins_emailtemplate.id;


    --
    -- Name: plugins_pluginconfiguration; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.plugins_pluginconfiguration (
        id integer NOT NULL,
        name character varying(128) NOT NULL,
        description text NOT NULL,
        active boolean NOT NULL,
        configuration jsonb,
        identifier character varying(128) NOT NULL,
        channel_id integer
    );


    ALTER TABLE public.plugins_pluginconfiguration OWNER TO saleor;

    --
    -- Name: plugins_pluginconfiguration_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.plugins_pluginconfiguration_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.plugins_pluginconfiguration_id_seq OWNER TO saleor;

    --
    -- Name: plugins_pluginconfiguration_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.plugins_pluginconfiguration_id_seq OWNED BY public.plugins_pluginconfiguration.id;


    --
    -- Name: product_assignedvariantattribute_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.product_assignedvariantattribute_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.product_assignedvariantattribute_id_seq OWNER TO saleor;

    --
    -- Name: product_assignedvariantattribute_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.product_assignedvariantattribute_id_seq OWNED BY public.attribute_assignedvariantattribute.id;


    --
    -- Name: product_attributechoicevalue_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.product_attributechoicevalue_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.product_attributechoicevalue_id_seq OWNER TO saleor;

    --
    -- Name: product_attributechoicevalue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.product_attributechoicevalue_id_seq OWNED BY public.attribute_attributevalue.id;


    --
    -- Name: product_attributechoicevaluetranslation_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.product_attributechoicevaluetranslation_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.product_attributechoicevaluetranslation_id_seq OWNER TO saleor;

    --
    -- Name: product_attributechoicevaluetranslation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.product_attributechoicevaluetranslation_id_seq OWNED BY public.attribute_attributevaluetranslation.id;


    --
    -- Name: product_attributepage_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.product_attributepage_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.product_attributepage_id_seq OWNER TO saleor;

    --
    -- Name: product_attributepage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.product_attributepage_id_seq OWNED BY public.attribute_attributepage.id;


    --
    -- Name: product_attributeproduct_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.product_attributeproduct_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.product_attributeproduct_id_seq OWNER TO saleor;

    --
    -- Name: product_attributeproduct_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.product_attributeproduct_id_seq OWNED BY public.attribute_attributeproduct.id;


    --
    -- Name: product_attributevariant_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.product_attributevariant_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.product_attributevariant_id_seq OWNER TO saleor;

    --
    -- Name: product_attributevariant_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.product_attributevariant_id_seq OWNED BY public.attribute_attributevariant.id;


    --
    -- Name: product_category; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.product_category (
        id integer NOT NULL,
        name character varying(250) NOT NULL,
        slug character varying(255) NOT NULL,
        description jsonb,
        lft integer NOT NULL,
        rght integer NOT NULL,
        tree_id integer NOT NULL,
        level integer NOT NULL,
        parent_id integer,
        background_image character varying(100),
        seo_description character varying(300),
        seo_title character varying(70),
        background_image_alt character varying(128) NOT NULL,
        metadata jsonb,
        private_metadata jsonb,
        description_plaintext text NOT NULL,
        updated_at timestamp with time zone DEFAULT now(),
        CONSTRAINT product_category_level_check CHECK ((level >= 0)),
        CONSTRAINT product_category_lft_check CHECK ((lft >= 0)),
        CONSTRAINT product_category_rght_check CHECK ((rght >= 0)),
        CONSTRAINT product_category_tree_id_check CHECK ((tree_id >= 0))
    );


    ALTER TABLE public.product_category OWNER TO saleor;

    --
    -- Name: product_category_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.product_category_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.product_category_id_seq OWNER TO saleor;

    --
    -- Name: product_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.product_category_id_seq OWNED BY public.product_category.id;


    --
    -- Name: product_categorytranslation; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.product_categorytranslation (
        id integer NOT NULL,
        seo_title character varying(70),
        seo_description character varying(300),
        language_code character varying(35) NOT NULL,
        name character varying(128),
        description jsonb,
        category_id integer NOT NULL
    );


    ALTER TABLE public.product_categorytranslation OWNER TO saleor;

    --
    -- Name: product_categorytranslation_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.product_categorytranslation_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.product_categorytranslation_id_seq OWNER TO saleor;

    --
    -- Name: product_categorytranslation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.product_categorytranslation_id_seq OWNED BY public.product_categorytranslation.id;


    --
    -- Name: product_collection; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.product_collection (
        id integer NOT NULL,
        name character varying(250) NOT NULL,
        slug character varying(255) NOT NULL,
        background_image character varying(100),
        seo_description character varying(300),
        seo_title character varying(70),
        description jsonb,
        background_image_alt character varying(128) NOT NULL,
        metadata jsonb,
        private_metadata jsonb
    );


    ALTER TABLE public.product_collection OWNER TO saleor;

    --
    -- Name: product_collection_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.product_collection_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.product_collection_id_seq OWNER TO saleor;

    --
    -- Name: product_collection_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.product_collection_id_seq OWNED BY public.product_collection.id;


    --
    -- Name: product_collectionproduct; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.product_collectionproduct (
        id integer NOT NULL,
        collection_id integer NOT NULL,
        product_id integer NOT NULL,
        sort_order integer
    );


    ALTER TABLE public.product_collectionproduct OWNER TO saleor;

    --
    -- Name: product_collection_products_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.product_collection_products_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.product_collection_products_id_seq OWNER TO saleor;

    --
    -- Name: product_collection_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.product_collection_products_id_seq OWNED BY public.product_collectionproduct.id;


    --
    -- Name: product_collectionchannellisting; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.product_collectionchannellisting (
        id integer NOT NULL,
        published_at timestamp with time zone,
        is_published boolean NOT NULL,
        channel_id integer NOT NULL,
        collection_id integer NOT NULL
    );


    ALTER TABLE public.product_collectionchannellisting OWNER TO saleor;

    --
    -- Name: product_collectionchannellisting_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.product_collectionchannellisting_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.product_collectionchannellisting_id_seq OWNER TO saleor;

    --
    -- Name: product_collectionchannellisting_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.product_collectionchannellisting_id_seq OWNED BY public.product_collectionchannellisting.id;


    --
    -- Name: product_collectiontranslation; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.product_collectiontranslation (
        id integer NOT NULL,
        seo_title character varying(70),
        seo_description character varying(300),
        language_code character varying(35) NOT NULL,
        name character varying(128),
        collection_id integer NOT NULL,
        description jsonb
    );


    ALTER TABLE public.product_collectiontranslation OWNER TO saleor;

    --
    -- Name: product_collectiontranslation_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.product_collectiontranslation_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.product_collectiontranslation_id_seq OWNER TO saleor;

    --
    -- Name: product_collectiontranslation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.product_collectiontranslation_id_seq OWNED BY public.product_collectiontranslation.id;


    --
    -- Name: product_digitalcontent; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.product_digitalcontent (
        id integer NOT NULL,
        use_default_settings boolean NOT NULL,
        automatic_fulfillment boolean NOT NULL,
        content_type character varying(128) NOT NULL,
        content_file character varying(100) NOT NULL,
        max_downloads integer,
        url_valid_days integer,
        product_variant_id integer NOT NULL,
        metadata jsonb,
        private_metadata jsonb
    );


    ALTER TABLE public.product_digitalcontent OWNER TO saleor;

    --
    -- Name: product_digitalcontent_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.product_digitalcontent_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.product_digitalcontent_id_seq OWNER TO saleor;

    --
    -- Name: product_digitalcontent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.product_digitalcontent_id_seq OWNED BY public.product_digitalcontent.id;


    --
    -- Name: product_digitalcontenturl; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.product_digitalcontenturl (
        id integer NOT NULL,
        token uuid NOT NULL,
        created_at timestamp with time zone NOT NULL,
        download_num integer NOT NULL,
        content_id integer NOT NULL,
        line_id uuid
    );


    ALTER TABLE public.product_digitalcontenturl OWNER TO saleor;

    --
    -- Name: product_digitalcontenturl_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.product_digitalcontenturl_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.product_digitalcontenturl_id_seq OWNER TO saleor;

    --
    -- Name: product_digitalcontenturl_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.product_digitalcontenturl_id_seq OWNED BY public.product_digitalcontenturl.id;


    --
    -- Name: product_product; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.product_product (
        id integer NOT NULL,
        name character varying(250) NOT NULL,
        description jsonb,
        updated_at timestamp with time zone NOT NULL,
        product_type_id integer NOT NULL,
        category_id integer,
        seo_description character varying(300),
        seo_title character varying(70),
        weight double precision,
        metadata jsonb,
        private_metadata jsonb,
        slug character varying(255) NOT NULL,
        default_variant_id integer,
        description_plaintext text NOT NULL,
        rating double precision,
        search_document text NOT NULL,
        created_at timestamp with time zone NOT NULL,
        search_vector tsvector,
        search_index_dirty boolean NOT NULL,
        tax_class_id integer,
        external_reference character varying(250)
    );


    ALTER TABLE public.product_product OWNER TO saleor;

    --
    -- Name: product_product_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.product_product_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.product_product_id_seq OWNER TO saleor;

    --
    -- Name: product_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.product_product_id_seq OWNED BY public.product_product.id;


    --
    -- Name: product_productattribute_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.product_productattribute_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.product_productattribute_id_seq OWNER TO saleor;

    --
    -- Name: product_productattribute_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.product_productattribute_id_seq OWNED BY public.attribute_attribute.id;


    --
    -- Name: product_productattributetranslation_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.product_productattributetranslation_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.product_productattributetranslation_id_seq OWNER TO saleor;

    --
    -- Name: product_productattributetranslation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.product_productattributetranslation_id_seq OWNED BY public.attribute_attributetranslation.id;


    --
    -- Name: product_productchannellisting; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.product_productchannellisting (
        id integer NOT NULL,
        published_at timestamp with time zone,
        is_published boolean NOT NULL,
        channel_id integer NOT NULL,
        product_id integer NOT NULL,
        discounted_price_amount numeric(12,3),
        currency character varying(3) NOT NULL,
        visible_in_listings boolean NOT NULL,
        available_for_purchase_at timestamp with time zone,
        discounted_price_dirty boolean DEFAULT false NOT NULL
    );


    ALTER TABLE public.product_productchannellisting OWNER TO saleor;

    --
    -- Name: product_productchannellisting_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.product_productchannellisting_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.product_productchannellisting_id_seq OWNER TO saleor;

    --
    -- Name: product_productchannellisting_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.product_productchannellisting_id_seq OWNED BY public.product_productchannellisting.id;


    --
    -- Name: product_producttype; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.product_producttype (
        id integer NOT NULL,
        name character varying(250) NOT NULL,
        has_variants boolean NOT NULL,
        is_shipping_required boolean NOT NULL,
        weight double precision NOT NULL,
        is_digital boolean NOT NULL,
        metadata jsonb,
        private_metadata jsonb,
        slug character varying(255) NOT NULL,
        kind character varying(32) NOT NULL,
        tax_class_id integer
    );


    ALTER TABLE public.product_producttype OWNER TO saleor;

    --
    -- Name: product_productclass_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.product_productclass_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.product_productclass_id_seq OWNER TO saleor;

    --
    -- Name: product_productclass_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.product_productclass_id_seq OWNED BY public.product_producttype.id;


    --
    -- Name: product_productmedia; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.product_productmedia (
        id integer NOT NULL,
        sort_order integer,
        image character varying(100),
        alt character varying(250) NOT NULL,
        type character varying(32) NOT NULL,
        external_url character varying(256),
        oembed_data jsonb NOT NULL,
        product_id integer,
        to_remove boolean NOT NULL,
        metadata jsonb,
        private_metadata jsonb
    );


    ALTER TABLE public.product_productmedia OWNER TO saleor;

    --
    -- Name: product_productmedia_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.product_productmedia_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.product_productmedia_id_seq OWNER TO saleor;

    --
    -- Name: product_productmedia_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.product_productmedia_id_seq OWNED BY public.product_productmedia.id;


    --
    -- Name: product_producttranslation; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.product_producttranslation (
        id integer NOT NULL,
        seo_title character varying(70),
        seo_description character varying(300),
        language_code character varying(35) NOT NULL,
        name character varying(250),
        description jsonb,
        product_id integer NOT NULL
    );


    ALTER TABLE public.product_producttranslation OWNER TO saleor;

    --
    -- Name: product_producttranslation_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.product_producttranslation_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.product_producttranslation_id_seq OWNER TO saleor;

    --
    -- Name: product_producttranslation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.product_producttranslation_id_seq OWNED BY public.product_producttranslation.id;


    --
    -- Name: product_productvariant; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.product_productvariant (
        id integer NOT NULL,
        sku character varying(255),
        name character varying(255) NOT NULL,
        product_id integer NOT NULL,
        track_inventory boolean NOT NULL,
        weight double precision,
        metadata jsonb,
        private_metadata jsonb,
        sort_order integer,
        is_preorder boolean NOT NULL,
        preorder_end_date timestamp with time zone,
        preorder_global_threshold integer,
        quantity_limit_per_customer integer,
        created_at timestamp with time zone NOT NULL,
        updated_at timestamp with time zone NOT NULL,
        external_reference character varying(250)
    );


    ALTER TABLE public.product_productvariant OWNER TO saleor;

    --
    -- Name: product_productvariant_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.product_productvariant_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.product_productvariant_id_seq OWNER TO saleor;

    --
    -- Name: product_productvariant_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.product_productvariant_id_seq OWNED BY public.product_productvariant.id;


    --
    -- Name: product_productvariantchannellisting; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.product_productvariantchannellisting (
        id integer NOT NULL,
        currency character varying(3) NOT NULL,
        price_amount numeric(12,3),
        channel_id integer NOT NULL,
        variant_id integer NOT NULL,
        cost_price_amount numeric(12,3),
        preorder_quantity_threshold integer,
        discounted_price_amount numeric(12,3)
    );


    ALTER TABLE public.product_productvariantchannellisting OWNER TO saleor;

    --
    -- Name: product_productvariantchannellisting_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.product_productvariantchannellisting_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.product_productvariantchannellisting_id_seq OWNER TO saleor;

    --
    -- Name: product_productvariantchannellisting_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.product_productvariantchannellisting_id_seq OWNED BY public.product_productvariantchannellisting.id;


    --
    -- Name: product_productvarianttranslation; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.product_productvarianttranslation (
        id integer NOT NULL,
        language_code character varying(35) NOT NULL,
        name character varying(255) NOT NULL,
        product_variant_id integer NOT NULL
    );


    ALTER TABLE public.product_productvarianttranslation OWNER TO saleor;

    --
    -- Name: product_productvarianttranslation_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.product_productvarianttranslation_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.product_productvarianttranslation_id_seq OWNER TO saleor;

    --
    -- Name: product_productvarianttranslation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.product_productvarianttranslation_id_seq OWNED BY public.product_productvarianttranslation.id;


    --
    -- Name: product_variantchannellistingpromotionrule; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.product_variantchannellistingpromotionrule (
        id integer NOT NULL,
        discount_amount numeric(12,3) NOT NULL,
        currency character varying(3) NOT NULL,
        promotion_rule_id uuid NOT NULL,
        variant_channel_listing_id integer NOT NULL
    );


    ALTER TABLE public.product_variantchannellistingpromotionrule OWNER TO saleor;

    --
    -- Name: product_variantchannellistingpromotionrule_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.product_variantchannellistingpromotionrule_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.product_variantchannellistingpromotionrule_id_seq OWNER TO saleor;

    --
    -- Name: product_variantchannellistingpromotionrule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.product_variantchannellistingpromotionrule_id_seq OWNED BY public.product_variantchannellistingpromotionrule.id;


    --
    -- Name: product_variantmedia; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.product_variantmedia (
        id integer NOT NULL,
        media_id integer NOT NULL,
        variant_id integer NOT NULL
    );


    ALTER TABLE public.product_variantmedia OWNER TO saleor;

    --
    -- Name: product_variantmedia_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.product_variantmedia_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.product_variantmedia_id_seq OWNER TO saleor;

    --
    -- Name: product_variantmedia_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.product_variantmedia_id_seq OWNED BY public.product_variantmedia.id;


    --
    -- Name: schedulers_customperiodictask; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.schedulers_customperiodictask (
        periodictask_ptr_id integer NOT NULL,
        custom_id integer
    );


    ALTER TABLE public.schedulers_customperiodictask OWNER TO saleor;

    --
    -- Name: schedulers_customschedule; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.schedulers_customschedule (
        id integer NOT NULL,
        schedule_import_path character varying(255) NOT NULL
    );


    ALTER TABLE public.schedulers_customschedule OWNER TO saleor;

    --
    -- Name: schedulers_customschedule_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.schedulers_customschedule_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.schedulers_customschedule_id_seq OWNER TO saleor;

    --
    -- Name: schedulers_customschedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.schedulers_customschedule_id_seq OWNED BY public.schedulers_customschedule.id;


    --
    -- Name: shipping_shippingmethod; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.shipping_shippingmethod (
        id integer NOT NULL,
        name character varying(100) NOT NULL,
        maximum_order_weight double precision,
        minimum_order_weight double precision,
        type character varying(30) NOT NULL,
        shipping_zone_id integer NOT NULL,
        metadata jsonb,
        private_metadata jsonb,
        maximum_delivery_days integer,
        minimum_delivery_days integer,
        description jsonb,
        tax_class_id integer,
        CONSTRAINT shipping_shippingmethod_maximum_delivery_days_check CHECK ((maximum_delivery_days >= 0)),
        CONSTRAINT shipping_shippingmethod_minimum_delivery_days_check CHECK ((minimum_delivery_days >= 0))
    );


    ALTER TABLE public.shipping_shippingmethod OWNER TO saleor;

    --
    -- Name: shipping_shippingmethod_excluded_products; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.shipping_shippingmethod_excluded_products (
        id integer NOT NULL,
        shippingmethod_id integer NOT NULL,
        product_id integer NOT NULL
    );


    ALTER TABLE public.shipping_shippingmethod_excluded_products OWNER TO saleor;

    --
    -- Name: shipping_shippingmethod_excluded_products_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.shipping_shippingmethod_excluded_products_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.shipping_shippingmethod_excluded_products_id_seq OWNER TO saleor;

    --
    -- Name: shipping_shippingmethod_excluded_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.shipping_shippingmethod_excluded_products_id_seq OWNED BY public.shipping_shippingmethod_excluded_products.id;


    --
    -- Name: shipping_shippingmethod_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.shipping_shippingmethod_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.shipping_shippingmethod_id_seq OWNER TO saleor;

    --
    -- Name: shipping_shippingmethod_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.shipping_shippingmethod_id_seq OWNED BY public.shipping_shippingmethod.id;


    --
    -- Name: shipping_shippingmethodchannellisting; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.shipping_shippingmethodchannellisting (
        id integer NOT NULL,
        minimum_order_price_amount numeric(12,3),
        currency character varying(3) NOT NULL,
        maximum_order_price_amount numeric(12,3),
        price_amount numeric(12,3) NOT NULL,
        channel_id integer NOT NULL,
        shipping_method_id integer NOT NULL
    );


    ALTER TABLE public.shipping_shippingmethodchannellisting OWNER TO saleor;

    --
    -- Name: shipping_shippingmethodchannellisting_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.shipping_shippingmethodchannellisting_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.shipping_shippingmethodchannellisting_id_seq OWNER TO saleor;

    --
    -- Name: shipping_shippingmethodchannellisting_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.shipping_shippingmethodchannellisting_id_seq OWNED BY public.shipping_shippingmethodchannellisting.id;


    --
    -- Name: shipping_shippingmethodpostalcoderule; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.shipping_shippingmethodpostalcoderule (
        id integer NOT NULL,
        start character varying(32) NOT NULL,
        "end" character varying(32),
        shipping_method_id integer NOT NULL,
        inclusion_type character varying(32) NOT NULL
    );


    ALTER TABLE public.shipping_shippingmethodpostalcoderule OWNER TO saleor;

    --
    -- Name: shipping_shippingmethodtranslation; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.shipping_shippingmethodtranslation (
        id integer NOT NULL,
        language_code character varying(35) NOT NULL,
        name character varying(255),
        shipping_method_id integer NOT NULL,
        description jsonb
    );


    ALTER TABLE public.shipping_shippingmethodtranslation OWNER TO saleor;

    --
    -- Name: shipping_shippingmethodtranslation_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.shipping_shippingmethodtranslation_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.shipping_shippingmethodtranslation_id_seq OWNER TO saleor;

    --
    -- Name: shipping_shippingmethodtranslation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.shipping_shippingmethodtranslation_id_seq OWNED BY public.shipping_shippingmethodtranslation.id;


    --
    -- Name: shipping_shippingmethodzipcoderule_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.shipping_shippingmethodzipcoderule_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.shipping_shippingmethodzipcoderule_id_seq OWNER TO saleor;

    --
    -- Name: shipping_shippingmethodzipcoderule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.shipping_shippingmethodzipcoderule_id_seq OWNED BY public.shipping_shippingmethodpostalcoderule.id;


    --
    -- Name: shipping_shippingzone; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.shipping_shippingzone (
        id integer NOT NULL,
        name character varying(100) NOT NULL,
        countries character varying(749) NOT NULL,
        "default" boolean NOT NULL,
        metadata jsonb,
        private_metadata jsonb,
        description text NOT NULL
    );


    ALTER TABLE public.shipping_shippingzone OWNER TO saleor;

    --
    -- Name: shipping_shippingzone_channels; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.shipping_shippingzone_channels (
        id integer NOT NULL,
        shippingzone_id integer NOT NULL,
        channel_id integer NOT NULL
    );


    ALTER TABLE public.shipping_shippingzone_channels OWNER TO saleor;

    --
    -- Name: shipping_shippingzone_channels_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.shipping_shippingzone_channels_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.shipping_shippingzone_channels_id_seq OWNER TO saleor;

    --
    -- Name: shipping_shippingzone_channels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.shipping_shippingzone_channels_id_seq OWNED BY public.shipping_shippingzone_channels.id;


    --
    -- Name: shipping_shippingzone_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.shipping_shippingzone_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.shipping_shippingzone_id_seq OWNER TO saleor;

    --
    -- Name: shipping_shippingzone_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.shipping_shippingzone_id_seq OWNED BY public.shipping_shippingzone.id;


    --
    -- Name: site_sitesettings; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.site_sitesettings (
        id integer NOT NULL,
        header_text character varying(200) NOT NULL,
        description character varying(500) NOT NULL,
        site_id integer NOT NULL,
        bottom_menu_id integer,
        top_menu_id integer,
        display_gross_prices boolean NOT NULL,
        include_taxes_in_prices boolean NOT NULL,
        charge_taxes_on_shipping boolean NOT NULL,
        track_inventory_by_default boolean NOT NULL,
        default_weight_unit character varying(30) NOT NULL,
        automatic_fulfillment_digital_products boolean NOT NULL,
        default_digital_max_downloads integer,
        default_digital_url_valid_days integer,
        company_address_id integer,
        default_mail_sender_address character varying(254),
        default_mail_sender_name character varying(78) NOT NULL,
        customer_set_password_url character varying(255),
        fulfillment_allow_unpaid boolean NOT NULL,
        fulfillment_auto_approve boolean NOT NULL,
        gift_card_expiry_period integer,
        gift_card_expiry_period_type character varying(32),
        gift_card_expiry_type character varying(32) NOT NULL,
        reserve_stock_duration_anonymous_user integer,
        reserve_stock_duration_authenticated_user integer,
        limit_quantity_per_checkout integer,
        enable_account_confirmation_by_email boolean DEFAULT true NOT NULL,
        metadata jsonb,
        private_metadata jsonb,
        allow_login_without_confirmation boolean DEFAULT false NOT NULL,
        CONSTRAINT site_sitesettings_gift_card_expiry_period_check CHECK ((gift_card_expiry_period >= 0))
    );


    ALTER TABLE public.site_sitesettings OWNER TO saleor;

    --
    -- Name: site_sitesettings_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.site_sitesettings_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.site_sitesettings_id_seq OWNER TO saleor;

    --
    -- Name: site_sitesettings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.site_sitesettings_id_seq OWNED BY public.site_sitesettings.id;


    --
    -- Name: site_sitesettingstranslation; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.site_sitesettingstranslation (
        id integer NOT NULL,
        language_code character varying(35) NOT NULL,
        header_text character varying(200) NOT NULL,
        description character varying(500) NOT NULL,
        site_settings_id integer NOT NULL
    );


    ALTER TABLE public.site_sitesettingstranslation OWNER TO saleor;

    --
    -- Name: site_sitesettingstranslation_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.site_sitesettingstranslation_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.site_sitesettingstranslation_id_seq OWNER TO saleor;

    --
    -- Name: site_sitesettingstranslation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.site_sitesettingstranslation_id_seq OWNED BY public.site_sitesettingstranslation.id;


    --
    -- Name: tax_taxclass; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.tax_taxclass (
        id integer NOT NULL,
        private_metadata jsonb,
        metadata jsonb,
        name character varying(255) NOT NULL
    );


    ALTER TABLE public.tax_taxclass OWNER TO saleor;

    --
    -- Name: tax_taxclass_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.tax_taxclass_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.tax_taxclass_id_seq OWNER TO saleor;

    --
    -- Name: tax_taxclass_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.tax_taxclass_id_seq OWNED BY public.tax_taxclass.id;


    --
    -- Name: tax_taxclasscountryrate; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.tax_taxclasscountryrate (
        id integer NOT NULL,
        country character varying(2) NOT NULL,
        rate numeric(12,3) NOT NULL,
        tax_class_id integer
    );


    ALTER TABLE public.tax_taxclasscountryrate OWNER TO saleor;

    --
    -- Name: tax_taxclasscountryrate_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.tax_taxclasscountryrate_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.tax_taxclasscountryrate_id_seq OWNER TO saleor;

    --
    -- Name: tax_taxclasscountryrate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.tax_taxclasscountryrate_id_seq OWNED BY public.tax_taxclasscountryrate.id;


    --
    -- Name: tax_taxconfiguration; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.tax_taxconfiguration (
        id integer NOT NULL,
        private_metadata jsonb,
        metadata jsonb,
        charge_taxes boolean NOT NULL,
        tax_calculation_strategy character varying(20),
        display_gross_prices boolean NOT NULL,
        prices_entered_with_tax boolean NOT NULL,
        channel_id integer NOT NULL,
        tax_app_id character varying(256)
    );


    ALTER TABLE public.tax_taxconfiguration OWNER TO saleor;

    --
    -- Name: tax_taxconfiguration_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.tax_taxconfiguration_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.tax_taxconfiguration_id_seq OWNER TO saleor;

    --
    -- Name: tax_taxconfiguration_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.tax_taxconfiguration_id_seq OWNED BY public.tax_taxconfiguration.id;


    --
    -- Name: tax_taxconfigurationpercountry; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.tax_taxconfigurationpercountry (
        id integer NOT NULL,
        country character varying(2) NOT NULL,
        charge_taxes boolean NOT NULL,
        tax_calculation_strategy character varying(20),
        display_gross_prices boolean NOT NULL,
        tax_configuration_id integer NOT NULL,
        tax_app_id character varying(256)
    );


    ALTER TABLE public.tax_taxconfigurationpercountry OWNER TO saleor;

    --
    -- Name: tax_taxconfigurationpercountry_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.tax_taxconfigurationpercountry_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.tax_taxconfigurationpercountry_id_seq OWNER TO saleor;

    --
    -- Name: tax_taxconfigurationpercountry_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.tax_taxconfigurationpercountry_id_seq OWNED BY public.tax_taxconfigurationpercountry.id;


    --
    -- Name: thumbnail_thumbnail; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.thumbnail_thumbnail (
        id integer NOT NULL,
        image character varying(100) NOT NULL,
        size integer NOT NULL,
        format character varying(32),
        category_id integer,
        collection_id integer,
        product_media_id integer,
        user_id integer,
        app_id integer,
        app_installation_id integer,
        CONSTRAINT thumbnail_thumbnail_size_check CHECK ((size >= 0))
    );


    ALTER TABLE public.thumbnail_thumbnail OWNER TO saleor;

    --
    -- Name: thumbnail_thumbnail_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.thumbnail_thumbnail_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.thumbnail_thumbnail_id_seq OWNER TO saleor;

    --
    -- Name: thumbnail_thumbnail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.thumbnail_thumbnail_id_seq OWNED BY public.thumbnail_thumbnail.id;


    --
    -- Name: userprofile_address_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.userprofile_address_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.userprofile_address_id_seq OWNER TO saleor;

    --
    -- Name: userprofile_address_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.userprofile_address_id_seq OWNED BY public.account_address.id;


    --
    -- Name: userprofile_user_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.userprofile_user_addresses_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.userprofile_user_addresses_id_seq OWNER TO saleor;

    --
    -- Name: userprofile_user_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.userprofile_user_addresses_id_seq OWNED BY public.account_user_addresses.id;


    --
    -- Name: userprofile_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.userprofile_user_groups_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.userprofile_user_groups_id_seq OWNER TO saleor;

    --
    -- Name: userprofile_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.userprofile_user_groups_id_seq OWNED BY public.account_user_groups.id;


    --
    -- Name: userprofile_user_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.userprofile_user_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.userprofile_user_id_seq OWNER TO saleor;

    --
    -- Name: userprofile_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.userprofile_user_id_seq OWNED BY public.account_user.id;


    --
    -- Name: userprofile_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.userprofile_user_user_permissions_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.userprofile_user_user_permissions_id_seq OWNER TO saleor;

    --
    -- Name: userprofile_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.userprofile_user_user_permissions_id_seq OWNED BY public.account_user_user_permissions.id;


    --
    -- Name: warehouse_allocation; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.warehouse_allocation (
        id integer NOT NULL,
        quantity_allocated integer NOT NULL,
        stock_id integer NOT NULL,
        order_line_id uuid NOT NULL,
        CONSTRAINT warehouse_allocation_quantity_allocated_check CHECK ((quantity_allocated >= 0))
    );


    ALTER TABLE public.warehouse_allocation OWNER TO saleor;

    --
    -- Name: warehouse_allocation_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.warehouse_allocation_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.warehouse_allocation_id_seq OWNER TO saleor;

    --
    -- Name: warehouse_allocation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.warehouse_allocation_id_seq OWNED BY public.warehouse_allocation.id;


    --
    -- Name: warehouse_channelwarehouse; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.warehouse_channelwarehouse (
        id integer NOT NULL,
        warehouse_id uuid NOT NULL,
        channel_id integer NOT NULL,
        sort_order integer
    );


    ALTER TABLE public.warehouse_channelwarehouse OWNER TO saleor;

    --
    -- Name: warehouse_preorderallocation; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.warehouse_preorderallocation (
        id integer NOT NULL,
        quantity integer NOT NULL,
        product_variant_channel_listing_id integer NOT NULL,
        order_line_id uuid NOT NULL,
        CONSTRAINT warehouse_preorderallocation_quantity_check CHECK ((quantity >= 0))
    );


    ALTER TABLE public.warehouse_preorderallocation OWNER TO saleor;

    --
    -- Name: warehouse_preorderallocation_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.warehouse_preorderallocation_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.warehouse_preorderallocation_id_seq OWNER TO saleor;

    --
    -- Name: warehouse_preorderallocation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.warehouse_preorderallocation_id_seq OWNED BY public.warehouse_preorderallocation.id;


    --
    -- Name: warehouse_preorderreservation; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.warehouse_preorderreservation (
        id integer NOT NULL,
        quantity_reserved integer NOT NULL,
        reserved_until timestamp with time zone NOT NULL,
        product_variant_channel_listing_id integer NOT NULL,
        checkout_line_id uuid NOT NULL,
        CONSTRAINT warehouse_preorderreservation_quantity_reserved_check CHECK ((quantity_reserved >= 0))
    );


    ALTER TABLE public.warehouse_preorderreservation OWNER TO saleor;

    --
    -- Name: warehouse_preorderreservation_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.warehouse_preorderreservation_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.warehouse_preorderreservation_id_seq OWNER TO saleor;

    --
    -- Name: warehouse_preorderreservation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.warehouse_preorderreservation_id_seq OWNED BY public.warehouse_preorderreservation.id;


    --
    -- Name: warehouse_reservation; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.warehouse_reservation (
        id integer NOT NULL,
        quantity_reserved integer NOT NULL,
        reserved_until timestamp with time zone NOT NULL,
        stock_id integer NOT NULL,
        checkout_line_id uuid NOT NULL,
        CONSTRAINT warehouse_reservation_quantity_reserved_check CHECK ((quantity_reserved >= 0))
    );


    ALTER TABLE public.warehouse_reservation OWNER TO saleor;

    --
    -- Name: warehouse_reservation_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.warehouse_reservation_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.warehouse_reservation_id_seq OWNER TO saleor;

    --
    -- Name: warehouse_reservation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.warehouse_reservation_id_seq OWNED BY public.warehouse_reservation.id;


    --
    -- Name: warehouse_stock; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.warehouse_stock (
        id integer NOT NULL,
        quantity integer NOT NULL,
        product_variant_id integer NOT NULL,
        warehouse_id uuid NOT NULL,
        quantity_allocated integer NOT NULL
    );


    ALTER TABLE public.warehouse_stock OWNER TO saleor;

    --
    -- Name: warehouse_stock_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.warehouse_stock_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.warehouse_stock_id_seq OWNER TO saleor;

    --
    -- Name: warehouse_stock_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.warehouse_stock_id_seq OWNED BY public.warehouse_stock.id;


    --
    -- Name: warehouse_warehouse; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.warehouse_warehouse (
        id uuid NOT NULL,
        name character varying(250) NOT NULL,
        email character varying(254) NOT NULL,
        address_id integer NOT NULL,
        slug character varying(255) NOT NULL,
        metadata jsonb,
        private_metadata jsonb,
        click_and_collect_option character varying(30) NOT NULL,
        is_private boolean NOT NULL,
        external_reference character varying(250)
    );


    ALTER TABLE public.warehouse_warehouse OWNER TO saleor;

    --
    -- Name: warehouse_warehouse_channels_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.warehouse_warehouse_channels_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.warehouse_warehouse_channels_id_seq OWNER TO saleor;

    --
    -- Name: warehouse_warehouse_channels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.warehouse_warehouse_channels_id_seq OWNED BY public.warehouse_channelwarehouse.id;


    --
    -- Name: warehouse_warehouse_shipping_zones; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.warehouse_warehouse_shipping_zones (
        id integer NOT NULL,
        warehouse_id uuid NOT NULL,
        shippingzone_id integer NOT NULL
    );


    ALTER TABLE public.warehouse_warehouse_shipping_zones OWNER TO saleor;

    --
    -- Name: warehouse_warehouse_shipping_zones_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.warehouse_warehouse_shipping_zones_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.warehouse_warehouse_shipping_zones_id_seq OWNER TO saleor;

    --
    -- Name: warehouse_warehouse_shipping_zones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.warehouse_warehouse_shipping_zones_id_seq OWNED BY public.warehouse_warehouse_shipping_zones.id;


    --
    -- Name: webhook_webhook; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.webhook_webhook (
        id integer NOT NULL,
        target_url character varying(255) NOT NULL,
        is_active boolean NOT NULL,
        secret_key character varying(255),
        app_id integer NOT NULL,
        name character varying(255),
        subscription_query text,
        custom_headers jsonb
    );


    ALTER TABLE public.webhook_webhook OWNER TO saleor;

    --
    -- Name: webhook_webhook_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.webhook_webhook_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.webhook_webhook_id_seq OWNER TO saleor;

    --
    -- Name: webhook_webhook_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.webhook_webhook_id_seq OWNED BY public.webhook_webhook.id;


    --
    -- Name: webhook_webhookevent; Type: TABLE; Schema: public; Owner: saleor
    --

    CREATE TABLE public.webhook_webhookevent (
        id integer NOT NULL,
        event_type character varying(128) NOT NULL,
        webhook_id integer NOT NULL
    );


    ALTER TABLE public.webhook_webhookevent OWNER TO saleor;

    --
    -- Name: webhook_webhookevent_id_seq; Type: SEQUENCE; Schema: public; Owner: saleor
    --

    CREATE SEQUENCE public.webhook_webhookevent_id_seq
        AS integer
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;


    ALTER SEQUENCE public.webhook_webhookevent_id_seq OWNER TO saleor;

    --
    -- Name: webhook_webhookevent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: saleor
    --

    ALTER SEQUENCE public.webhook_webhookevent_id_seq OWNED BY public.webhook_webhookevent.id;


    --
    -- Name: account_address id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_address ALTER COLUMN id SET DEFAULT nextval('public.userprofile_address_id_seq'::regclass);


    --
    -- Name: account_customerevent id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_customerevent ALTER COLUMN id SET DEFAULT nextval('public.account_customerevent_id_seq'::regclass);


    --
    -- Name: account_customernote id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_customernote ALTER COLUMN id SET DEFAULT nextval('public.account_customernote_id_seq'::regclass);


    --
    -- Name: account_group id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_group ALTER COLUMN id SET DEFAULT nextval('public.auth_group_id_seq'::regclass);


    --
    -- Name: account_group_channels id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_group_channels ALTER COLUMN id SET DEFAULT nextval('public.account_group_channels_id_seq'::regclass);


    --
    -- Name: account_group_permissions id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_group_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_group_permissions_id_seq'::regclass);


    --
    -- Name: account_staffnotificationrecipient id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_staffnotificationrecipient ALTER COLUMN id SET DEFAULT nextval('public.account_staffnotificationrecipient_id_seq'::regclass);


    --
    -- Name: account_user id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_user ALTER COLUMN id SET DEFAULT nextval('public.userprofile_user_id_seq'::regclass);


    --
    -- Name: account_user_addresses id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_user_addresses ALTER COLUMN id SET DEFAULT nextval('public.userprofile_user_addresses_id_seq'::regclass);


    --
    -- Name: account_user_groups id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_user_groups ALTER COLUMN id SET DEFAULT nextval('public.userprofile_user_groups_id_seq'::regclass);


    --
    -- Name: account_user_user_permissions id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('public.userprofile_user_user_permissions_id_seq'::regclass);


    --
    -- Name: app_app id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.app_app ALTER COLUMN id SET DEFAULT nextval('public.account_serviceaccount_id_seq'::regclass);


    --
    -- Name: app_app_permissions id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.app_app_permissions ALTER COLUMN id SET DEFAULT nextval('public.account_serviceaccount_permissions_id_seq'::regclass);


    --
    -- Name: app_appextension id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.app_appextension ALTER COLUMN id SET DEFAULT nextval('public.app_appextension_id_seq'::regclass);


    --
    -- Name: app_appextension_permissions id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.app_appextension_permissions ALTER COLUMN id SET DEFAULT nextval('public.app_appextension_permissions_id_seq'::regclass);


    --
    -- Name: app_appinstallation id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.app_appinstallation ALTER COLUMN id SET DEFAULT nextval('public.app_appinstallation_id_seq'::regclass);


    --
    -- Name: app_appinstallation_permissions id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.app_appinstallation_permissions ALTER COLUMN id SET DEFAULT nextval('public.app_appinstallation_permissions_id_seq'::regclass);


    --
    -- Name: app_apptoken id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.app_apptoken ALTER COLUMN id SET DEFAULT nextval('public.account_serviceaccounttoken_id_seq'::regclass);


    --
    -- Name: attribute_assignedpageattributevalue id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_assignedpageattributevalue ALTER COLUMN id SET DEFAULT nextval('public.attribute_assignedpageattributevalue_id_seq'::regclass);


    --
    -- Name: attribute_assignedproductattributevalue id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_assignedproductattributevalue ALTER COLUMN id SET DEFAULT nextval('public.attribute_assignedproductattributevalue_id_seq'::regclass);


    --
    -- Name: attribute_assignedvariantattribute id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_assignedvariantattribute ALTER COLUMN id SET DEFAULT nextval('public.product_assignedvariantattribute_id_seq'::regclass);


    --
    -- Name: attribute_assignedvariantattributevalue id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_assignedvariantattributevalue ALTER COLUMN id SET DEFAULT nextval('public.attribute_assignedvariantattributevalue_id_seq'::regclass);


    --
    -- Name: attribute_attribute id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_attribute ALTER COLUMN id SET DEFAULT nextval('public.product_productattribute_id_seq'::regclass);


    --
    -- Name: attribute_attributepage id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_attributepage ALTER COLUMN id SET DEFAULT nextval('public.product_attributepage_id_seq'::regclass);


    --
    -- Name: attribute_attributeproduct id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_attributeproduct ALTER COLUMN id SET DEFAULT nextval('public.product_attributeproduct_id_seq'::regclass);


    --
    -- Name: attribute_attributetranslation id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_attributetranslation ALTER COLUMN id SET DEFAULT nextval('public.product_productattributetranslation_id_seq'::regclass);


    --
    -- Name: attribute_attributevalue id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_attributevalue ALTER COLUMN id SET DEFAULT nextval('public.product_attributechoicevalue_id_seq'::regclass);


    --
    -- Name: attribute_attributevaluetranslation id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_attributevaluetranslation ALTER COLUMN id SET DEFAULT nextval('public.product_attributechoicevaluetranslation_id_seq'::regclass);


    --
    -- Name: attribute_attributevariant id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_attributevariant ALTER COLUMN id SET DEFAULT nextval('public.product_attributevariant_id_seq'::regclass);


    --
    -- Name: channel_channel id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.channel_channel ALTER COLUMN id SET DEFAULT nextval('public.channel_channel_id_seq'::regclass);


    --
    -- Name: checkout_checkout_gift_cards id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.checkout_checkout_gift_cards ALTER COLUMN id SET DEFAULT nextval('public.checkout_checkout_gift_cards_id_seq'::regclass);


    --
    -- Name: checkout_checkoutmetadata id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.checkout_checkoutmetadata ALTER COLUMN id SET DEFAULT nextval('public.checkout_checkoutmetadata_id_seq'::regclass);


    --
    -- Name: core_eventdelivery id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.core_eventdelivery ALTER COLUMN id SET DEFAULT nextval('public.core_eventdelivery_id_seq'::regclass);


    --
    -- Name: core_eventdeliveryattempt id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.core_eventdeliveryattempt ALTER COLUMN id SET DEFAULT nextval('public.core_eventdeliveryattempt_id_seq'::regclass);


    --
    -- Name: core_eventpayload id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.core_eventpayload ALTER COLUMN id SET DEFAULT nextval('public.core_eventpayload_id_seq'::regclass);


    --
    -- Name: csv_exportevent id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.csv_exportevent ALTER COLUMN id SET DEFAULT nextval('public.csv_exportevent_id_seq'::regclass);


    --
    -- Name: csv_exportfile id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.csv_exportfile ALTER COLUMN id SET DEFAULT nextval('public.csv_exportfile_id_seq'::regclass);


    --
    -- Name: discount_promotionrule_channels id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_promotionrule_channels ALTER COLUMN id SET DEFAULT nextval('public.discount_promotionrule_channels_id_seq'::regclass);


    --
    -- Name: discount_promotionrule_gifts id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_promotionrule_gifts ALTER COLUMN id SET DEFAULT nextval('public.discount_promotionrule_gifts_id_seq'::regclass);


    --
    -- Name: discount_promotionrule_variants id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_promotionrule_variants ALTER COLUMN id SET DEFAULT nextval('public.discount_promotionrule_variants_id_seq'::regclass);


    --
    -- Name: discount_promotionruletranslation id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_promotionruletranslation ALTER COLUMN id SET DEFAULT nextval('public.discount_promotionruletranslation_id_seq'::regclass);


    --
    -- Name: discount_promotiontranslation id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_promotiontranslation ALTER COLUMN id SET DEFAULT nextval('public.discount_promotiontranslation_id_seq'::regclass);


    --
    -- Name: discount_voucher id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_voucher ALTER COLUMN id SET DEFAULT nextval('public.discount_voucher_id_seq'::regclass);


    --
    -- Name: discount_voucher_categories id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_voucher_categories ALTER COLUMN id SET DEFAULT nextval('public.discount_voucher_categories_id_seq'::regclass);


    --
    -- Name: discount_voucher_collections id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_voucher_collections ALTER COLUMN id SET DEFAULT nextval('public.discount_voucher_collections_id_seq'::regclass);


    --
    -- Name: discount_voucher_products id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_voucher_products ALTER COLUMN id SET DEFAULT nextval('public.discount_voucher_products_id_seq'::regclass);


    --
    -- Name: discount_voucher_variants id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_voucher_variants ALTER COLUMN id SET DEFAULT nextval('public.discount_voucher_variants_id_seq'::regclass);


    --
    -- Name: discount_voucherchannellisting id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_voucherchannellisting ALTER COLUMN id SET DEFAULT nextval('public.discount_voucherchannellisting_id_seq'::regclass);


    --
    -- Name: discount_vouchercustomer id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_vouchercustomer ALTER COLUMN id SET DEFAULT nextval('public.discount_vouchercustomer_id_seq'::regclass);


    --
    -- Name: discount_vouchertranslation id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_vouchertranslation ALTER COLUMN id SET DEFAULT nextval('public.discount_vouchertranslation_id_seq'::regclass);


    --
    -- Name: django_celery_beat_clockedschedule id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.django_celery_beat_clockedschedule ALTER COLUMN id SET DEFAULT nextval('public.django_celery_beat_clockedschedule_id_seq'::regclass);


    --
    -- Name: django_celery_beat_crontabschedule id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.django_celery_beat_crontabschedule ALTER COLUMN id SET DEFAULT nextval('public.django_celery_beat_crontabschedule_id_seq'::regclass);


    --
    -- Name: django_celery_beat_intervalschedule id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.django_celery_beat_intervalschedule ALTER COLUMN id SET DEFAULT nextval('public.django_celery_beat_intervalschedule_id_seq'::regclass);


    --
    -- Name: django_celery_beat_periodictask id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.django_celery_beat_periodictask ALTER COLUMN id SET DEFAULT nextval('public.django_celery_beat_periodictask_id_seq'::regclass);


    --
    -- Name: django_celery_beat_solarschedule id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.django_celery_beat_solarschedule ALTER COLUMN id SET DEFAULT nextval('public.django_celery_beat_solarschedule_id_seq'::regclass);


    --
    -- Name: django_content_type id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.django_content_type ALTER COLUMN id SET DEFAULT nextval('public.django_content_type_id_seq'::regclass);


    --
    -- Name: django_migrations id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.django_migrations ALTER COLUMN id SET DEFAULT nextval('public.django_migrations_id_seq'::regclass);


    --
    -- Name: django_site id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.django_site ALTER COLUMN id SET DEFAULT nextval('public.django_site_id_seq'::regclass);


    --
    -- Name: giftcard_giftcard id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.giftcard_giftcard ALTER COLUMN id SET DEFAULT nextval('public.giftcard_giftcard_id_seq'::regclass);


    --
    -- Name: giftcard_giftcard_tags id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.giftcard_giftcard_tags ALTER COLUMN id SET DEFAULT nextval('public.giftcard_giftcard_tags_id_seq'::regclass);


    --
    -- Name: giftcard_giftcardevent id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.giftcard_giftcardevent ALTER COLUMN id SET DEFAULT nextval('public.giftcard_giftcardevent_id_seq'::regclass);


    --
    -- Name: giftcard_giftcardtag id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.giftcard_giftcardtag ALTER COLUMN id SET DEFAULT nextval('public.giftcard_giftcardtag_id_seq'::regclass);


    --
    -- Name: invoice_invoice id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.invoice_invoice ALTER COLUMN id SET DEFAULT nextval('public.invoice_invoice_id_seq'::regclass);


    --
    -- Name: invoice_invoiceevent id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.invoice_invoiceevent ALTER COLUMN id SET DEFAULT nextval('public.invoice_invoiceevent_id_seq'::regclass);


    --
    -- Name: menu_menu id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.menu_menu ALTER COLUMN id SET DEFAULT nextval('public.menu_menu_id_seq'::regclass);


    --
    -- Name: menu_menuitem id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.menu_menuitem ALTER COLUMN id SET DEFAULT nextval('public.menu_menuitem_id_seq'::regclass);


    --
    -- Name: menu_menuitemtranslation id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.menu_menuitemtranslation ALTER COLUMN id SET DEFAULT nextval('public.menu_menuitemtranslation_id_seq'::regclass);


    --
    -- Name: order_fulfillment id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_fulfillment ALTER COLUMN id SET DEFAULT nextval('public.order_fulfillment_id_seq'::regclass);


    --
    -- Name: order_fulfillmentline id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_fulfillmentline ALTER COLUMN id SET DEFAULT nextval('public.order_fulfillmentline_id_seq'::regclass);


    --
    -- Name: order_order_gift_cards id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_order_gift_cards ALTER COLUMN id SET DEFAULT nextval('public.order_order_gift_cards_id_seq'::regclass);


    --
    -- Name: order_orderevent id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_orderevent ALTER COLUMN id SET DEFAULT nextval('public.order_orderevent_id_seq'::regclass);


    --
    -- Name: order_ordergrantedrefund id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_ordergrantedrefund ALTER COLUMN id SET DEFAULT nextval('public.order_ordergrantedrefund_id_seq'::regclass);


    --
    -- Name: order_ordergrantedrefundline id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_ordergrantedrefundline ALTER COLUMN id SET DEFAULT nextval('public.order_ordergrantedrefundline_id_seq'::regclass);


    --
    -- Name: page_page id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.page_page ALTER COLUMN id SET DEFAULT nextval('public.page_page_id_seq'::regclass);


    --
    -- Name: page_pagetranslation id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.page_pagetranslation ALTER COLUMN id SET DEFAULT nextval('public.page_pagetranslation_id_seq'::regclass);


    --
    -- Name: page_pagetype id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.page_pagetype ALTER COLUMN id SET DEFAULT nextval('public.page_pagetype_id_seq'::regclass);


    --
    -- Name: payment_payment id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.payment_payment ALTER COLUMN id SET DEFAULT nextval('public.payment_paymentmethod_id_seq'::regclass);


    --
    -- Name: payment_transaction id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.payment_transaction ALTER COLUMN id SET DEFAULT nextval('public.payment_transaction_id_seq'::regclass);


    --
    -- Name: payment_transactionevent id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.payment_transactionevent ALTER COLUMN id SET DEFAULT nextval('public.payment_transactionevent_id_seq'::regclass);


    --
    -- Name: payment_transactionitem id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.payment_transactionitem ALTER COLUMN id SET DEFAULT nextval('public.payment_transactionitem_id_seq'::regclass);


    --
    -- Name: permission_permission id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.permission_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);


    --
    -- Name: plugins_emailtemplate id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.plugins_emailtemplate ALTER COLUMN id SET DEFAULT nextval('public.plugins_emailtemplate_id_seq'::regclass);


    --
    -- Name: plugins_pluginconfiguration id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.plugins_pluginconfiguration ALTER COLUMN id SET DEFAULT nextval('public.plugins_pluginconfiguration_id_seq'::regclass);


    --
    -- Name: product_category id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_category ALTER COLUMN id SET DEFAULT nextval('public.product_category_id_seq'::regclass);


    --
    -- Name: product_categorytranslation id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_categorytranslation ALTER COLUMN id SET DEFAULT nextval('public.product_categorytranslation_id_seq'::regclass);


    --
    -- Name: product_collection id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_collection ALTER COLUMN id SET DEFAULT nextval('public.product_collection_id_seq'::regclass);


    --
    -- Name: product_collectionchannellisting id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_collectionchannellisting ALTER COLUMN id SET DEFAULT nextval('public.product_collectionchannellisting_id_seq'::regclass);


    --
    -- Name: product_collectionproduct id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_collectionproduct ALTER COLUMN id SET DEFAULT nextval('public.product_collection_products_id_seq'::regclass);


    --
    -- Name: product_collectiontranslation id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_collectiontranslation ALTER COLUMN id SET DEFAULT nextval('public.product_collectiontranslation_id_seq'::regclass);


    --
    -- Name: product_digitalcontent id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_digitalcontent ALTER COLUMN id SET DEFAULT nextval('public.product_digitalcontent_id_seq'::regclass);


    --
    -- Name: product_digitalcontenturl id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_digitalcontenturl ALTER COLUMN id SET DEFAULT nextval('public.product_digitalcontenturl_id_seq'::regclass);


    --
    -- Name: product_product id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_product ALTER COLUMN id SET DEFAULT nextval('public.product_product_id_seq'::regclass);


    --
    -- Name: product_productchannellisting id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_productchannellisting ALTER COLUMN id SET DEFAULT nextval('public.product_productchannellisting_id_seq'::regclass);


    --
    -- Name: product_productmedia id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_productmedia ALTER COLUMN id SET DEFAULT nextval('public.product_productmedia_id_seq'::regclass);


    --
    -- Name: product_producttranslation id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_producttranslation ALTER COLUMN id SET DEFAULT nextval('public.product_producttranslation_id_seq'::regclass);


    --
    -- Name: product_producttype id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_producttype ALTER COLUMN id SET DEFAULT nextval('public.product_productclass_id_seq'::regclass);


    --
    -- Name: product_productvariant id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_productvariant ALTER COLUMN id SET DEFAULT nextval('public.product_productvariant_id_seq'::regclass);


    --
    -- Name: product_productvariantchannellisting id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_productvariantchannellisting ALTER COLUMN id SET DEFAULT nextval('public.product_productvariantchannellisting_id_seq'::regclass);


    --
    -- Name: product_productvarianttranslation id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_productvarianttranslation ALTER COLUMN id SET DEFAULT nextval('public.product_productvarianttranslation_id_seq'::regclass);


    --
    -- Name: product_variantchannellistingpromotionrule id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_variantchannellistingpromotionrule ALTER COLUMN id SET DEFAULT nextval('public.product_variantchannellistingpromotionrule_id_seq'::regclass);


    --
    -- Name: product_variantmedia id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_variantmedia ALTER COLUMN id SET DEFAULT nextval('public.product_variantmedia_id_seq'::regclass);


    --
    -- Name: schedulers_customschedule id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.schedulers_customschedule ALTER COLUMN id SET DEFAULT nextval('public.schedulers_customschedule_id_seq'::regclass);


    --
    -- Name: shipping_shippingmethod id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.shipping_shippingmethod ALTER COLUMN id SET DEFAULT nextval('public.shipping_shippingmethod_id_seq'::regclass);


    --
    -- Name: shipping_shippingmethod_excluded_products id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.shipping_shippingmethod_excluded_products ALTER COLUMN id SET DEFAULT nextval('public.shipping_shippingmethod_excluded_products_id_seq'::regclass);


    --
    -- Name: shipping_shippingmethodchannellisting id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.shipping_shippingmethodchannellisting ALTER COLUMN id SET DEFAULT nextval('public.shipping_shippingmethodchannellisting_id_seq'::regclass);


    --
    -- Name: shipping_shippingmethodpostalcoderule id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.shipping_shippingmethodpostalcoderule ALTER COLUMN id SET DEFAULT nextval('public.shipping_shippingmethodzipcoderule_id_seq'::regclass);


    --
    -- Name: shipping_shippingmethodtranslation id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.shipping_shippingmethodtranslation ALTER COLUMN id SET DEFAULT nextval('public.shipping_shippingmethodtranslation_id_seq'::regclass);


    --
    -- Name: shipping_shippingzone id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.shipping_shippingzone ALTER COLUMN id SET DEFAULT nextval('public.shipping_shippingzone_id_seq'::regclass);


    --
    -- Name: shipping_shippingzone_channels id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.shipping_shippingzone_channels ALTER COLUMN id SET DEFAULT nextval('public.shipping_shippingzone_channels_id_seq'::regclass);


    --
    -- Name: site_sitesettings id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.site_sitesettings ALTER COLUMN id SET DEFAULT nextval('public.site_sitesettings_id_seq'::regclass);


    --
    -- Name: site_sitesettingstranslation id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.site_sitesettingstranslation ALTER COLUMN id SET DEFAULT nextval('public.site_sitesettingstranslation_id_seq'::regclass);


    --
    -- Name: tax_taxclass id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.tax_taxclass ALTER COLUMN id SET DEFAULT nextval('public.tax_taxclass_id_seq'::regclass);


    --
    -- Name: tax_taxclasscountryrate id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.tax_taxclasscountryrate ALTER COLUMN id SET DEFAULT nextval('public.tax_taxclasscountryrate_id_seq'::regclass);


    --
    -- Name: tax_taxconfiguration id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.tax_taxconfiguration ALTER COLUMN id SET DEFAULT nextval('public.tax_taxconfiguration_id_seq'::regclass);


    --
    -- Name: tax_taxconfigurationpercountry id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.tax_taxconfigurationpercountry ALTER COLUMN id SET DEFAULT nextval('public.tax_taxconfigurationpercountry_id_seq'::regclass);


    --
    -- Name: thumbnail_thumbnail id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.thumbnail_thumbnail ALTER COLUMN id SET DEFAULT nextval('public.thumbnail_thumbnail_id_seq'::regclass);


    --
    -- Name: warehouse_allocation id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.warehouse_allocation ALTER COLUMN id SET DEFAULT nextval('public.warehouse_allocation_id_seq'::regclass);


    --
    -- Name: warehouse_channelwarehouse id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.warehouse_channelwarehouse ALTER COLUMN id SET DEFAULT nextval('public.warehouse_warehouse_channels_id_seq'::regclass);


    --
    -- Name: warehouse_preorderallocation id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.warehouse_preorderallocation ALTER COLUMN id SET DEFAULT nextval('public.warehouse_preorderallocation_id_seq'::regclass);


    --
    -- Name: warehouse_preorderreservation id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.warehouse_preorderreservation ALTER COLUMN id SET DEFAULT nextval('public.warehouse_preorderreservation_id_seq'::regclass);


    --
    -- Name: warehouse_reservation id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.warehouse_reservation ALTER COLUMN id SET DEFAULT nextval('public.warehouse_reservation_id_seq'::regclass);


    --
    -- Name: warehouse_stock id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.warehouse_stock ALTER COLUMN id SET DEFAULT nextval('public.warehouse_stock_id_seq'::regclass);


    --
    -- Name: warehouse_warehouse_shipping_zones id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.warehouse_warehouse_shipping_zones ALTER COLUMN id SET DEFAULT nextval('public.warehouse_warehouse_shipping_zones_id_seq'::regclass);


    --
    -- Name: webhook_webhook id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.webhook_webhook ALTER COLUMN id SET DEFAULT nextval('public.webhook_webhook_id_seq'::regclass);


    --
    -- Name: webhook_webhookevent id; Type: DEFAULT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.webhook_webhookevent ALTER COLUMN id SET DEFAULT nextval('public.webhook_webhookevent_id_seq'::regclass);


    --
    -- Data for Name: account_address; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.account_address (id, first_name, last_name, company_name, street_address_1, street_address_2, city, postal_code, country, country_area, phone, city_area, metadata, private_metadata) FROM stdin;
    1								US				{}	{}
    2	Nicholas	Hutchinson	Cook, Allen and Walsh	69602 Brown Squares Apt. 787		North Troyport	61697	TR				{}	{}
    3	Jacob	Key	Lamb Group	206 Stewart Forest		Lake Karenhaven	80725	TR				{}	{}
    4	Debra	Russo	Lee PLC	217 Burton Brooks Suite 714		Lake Abigail	85800	TR				{}	{}
    5	Andrew	Williams	Reed, Wiggins and Ramirez	559 Meghan Squares Suite 765		East Nicholas	38647	TR				{}	{}
    6	Mathew	Clarke	Taylor LLC	9004 Edward Prairie		Michaelside	17493	TR				{}	{}
    7	Sarah	Parker	Wilson-Cross	6546 Cory Orchard		Rogersmouth	16796	TR				{}	{}
    8	Timothy	Lyons		45229 Drake Route Apt. 113		North Paul	13356	TR				{}	{}
    9	Shane	Burns		1534 Ryan Knolls		North Lynntown	69420	TR				{}	{}
    10	Natalie	Simpson		7389 Alec Squares Suite 508		Port Jonathan	20935	TR				{}	{}
    11	Vicki	Burgess		8967 Lawson Fort		Lake Nicoleburgh	40142	TR				{}	{}
    12	Edward	Hatfield		97670 Thomas Drive Apt. 099		Lake Mario	92261	TR				{}	{}
    13	Jaime	Casey		3751 Rachel Canyon Suite 408		East Clayton	82739	TR				{}	{}
    14	Anthony	Bailey		51923 Jamie Spring		Lake Adrianstad	90870	TR				{}	{}
    15	Susan	Phillips		91189 Moore Drive Apt. 358		East Kari	38650	TR				{}	{}
    16	Alan	Hayden		3547 Stephanie Underpass Apt. 418		Port Jacqueline	52769	TR				{}	{}
    17	Alan	Evans		926 Davis Parks Apt. 864		North Josephton	00534	TR				{}	{}
    18	John	Mora		64482 Amanda Loop		Figueroaview	38807	TR				{}	{}
    19	Michael	Myers		116 Michael Crescent		West Morganport	95803	TR				{}	{}
    20	Leslie	Clark		5667 Blair Underpass		South Shelby	77378	TR				{}	{}
    21	Kenneth	Miller		6708 Carpenter Overpass Suite 735		Bobbyton	21847	TR				{}	{}
    22	Jonathan	Boyd		1385 Mary Glen		Larryfurt	33877	TR				{}	{}
    23	Lisa	Hansen		23732 Michael Island Suite 184		Lake Kenneth	58406	TR				{}	{}
    24	Michael	Leonard		31845 Nathaniel Neck Suite 922		New Williamstad	77234	TR				{}	{}
    25	Jamie	Herman		332 Kathleen Knoll Apt. 719		New Caitlinfort	60217	TR				{}	{}
    26	Leslie	Carter		05357 Jordan Skyway		West Andre	75682	TR				{}	{}
    27	Michael	Thompson		660 Macdonald Place Suite 091		Finleyburgh	00908	TR				{}	{}
    28	Anna	Robbins		197 Christina Canyon Suite 560		South Christopherport	88534	TR				{}	{}
    29	Stephen	Griffith		7004 Jonathan Springs Suite 388		Paulview	27891	TR				{}	{}
    30	Brenda	Williams		5445 Patton Rapid		Archertown	18950	TR				{}	{}
    31	David	Noble		493 Ana Manors Suite 282		Lake Danielleshire	14925	TR				{}	{}
    32	Larry	Smith		8885 Lee Tunnel Suite 208		Port Donna	74331	TR				{}	{}
    33	Stefanie	Hoffman		930 Rice Estate Apt. 570		New Patricia	36476	TR				{}	{}
    34	Christian	West		132 Mclean Meadow Suite 446		Chelsealand	40742	TR				{}	{}
    35	Ryan	Reid		097 Gallegos Crossroad Suite 506		Mccallberg	05951	TR				{}	{}
    36	Tracey	Hubbard		2926 Dixon Estates Apt. 270		Port Angelafurt	24122	TR				{}	{}
    37	Tracey	Hubbard		2926 Dixon Estates Apt. 270		Port Angelafurt	24122	TR				{}	{}
    38	Melvin	Willis		82434 Graves Glen		Zacharymouth	20843	TR				{}	{}
    39	Nicholas	Hutchinson	Cook, Allen and Walsh	69602 Brown Squares Apt. 787		North Troyport	61697	TR				{}	{}
    40	Jacob	Key	Lamb Group	206 Stewart Forest		Lake Karenhaven	80725	TR				{}	{}
    41	Debra	Russo	Lee PLC	217 Burton Brooks Suite 714		Lake Abigail	85800	TR				{}	{}
    42	Andrew	Williams	Reed, Wiggins and Ramirez	559 Meghan Squares Suite 765		East Nicholas	38647	TR				{}	{}
    43	Mathew	Clarke	Taylor LLC	9004 Edward Prairie		Michaelside	17493	TR				{}	{}
    44	Katherine	Cole		92805 James Turnpike		Carrmouth	68955	TR				{}	{}
    45	Sarah	Parker	Wilson-Cross	6546 Cory Orchard		Rogersmouth	16796	TR				{}	{}
    46	Timothy	Lyons		45229 Drake Route Apt. 113		North Paul	13356	TR				{}	{}
    47	Erik	Cook		8081 Smith Trail		North Ronaldstad	75247	TR				{}	{}
    48	Shannon	Bass		125 Ian Crossroad Apt. 593		South Deannaport	51555	TR				{}	{}
    49	Rhonda	Burke		1607 Munoz River		Emilyshire	59960	TR				{}	{}
    50	Robert	Johnson		61511 Michael Fall Suite 905		Gibbsfort	62961	TR				{}	{}
    51	Christopher	Williams		0811 Howard Courts Suite 028		Susantown	49874	TR				{}	{}
    52	Matthew	Blackburn		22395 Timothy Road		Williamsbury	83819	TR				{}	{}
    53	Juan	Jackson		3267 Walter Dam		Cunninghamtown	21753	TR				{}	{}
    54	Sarah	Smith		220 Madison Pass Apt. 001		Port Eric	50291	TR				{}	{}
    55	Kristin	Barnes		325 Amanda Cliffs Apt. 695		South Paulabury	62253	TR				{}	{}
    56	Patrick	Hendricks		769 Mary Harbor		Amyfort	31567	TR				{}	{}
    57	Joshua	Carr		180 Jennifer Burg Suite 661		Munozburgh	22731	TR				{}	{}
    58	Matthew	Jenkins		155 Courtney Trafficway Suite 803		Gregoryshire	43056	TR				{}	{}
    59	Kenneth	Walters		606 Brooks Fords Suite 221		Gabrielchester	76089	TR				{}	{}
    60	Raymond	Jones		8822 Jared Forks		New Derekfort	47290	TR				{}	{}
    61	Rachel	Hanson		516 Nolan Junctions Suite 826		Jimmyfurt	45920	TR				{}	{}
    62	Peter	Ruiz		6122 Brandy Roads Apt. 399		West Haleyburgh	49765	TR				{}	{}
    63	Christopher	Johnson		7517 Silva Glen		Burnettbury	21347	TR				{}	{}
    64	Anna	Wilcox		202 Franklin Fords		Ericksonfurt	35120	TR				{}	{}
    65	Andrew	Taylor		79061 Cook Parkways Suite 079		West Marissafort	72694	TR				{}	{}
    66	Deanna	Kennedy		85249 Stephen Cliff		Longchester	73395	TR				{}	{}
    67	Christopher	Olson		2512 Mackenzie Dam		North Antonio	53500	TR				{}	{}
    68	Angela	Campos		178 Baxter Junctions Apt. 033		Robersonport	36474	TR				{}	{}
    69	Jeffrey	Simpson		14963 Stuart Wall Apt. 343		Kellerstad	37581	TR				{}	{}
    70	Patrick	Anderson		5873 Chen Knolls		Ramirezfurt	94134	TR				{}	{}
    71	Shane	Burns		1534 Ryan Knolls		North Lynntown	69420	TR				{}	{}
    72	Shannon	Rhodes		6430 Cindy Cove		South Nicholas	72117	TR				{}	{}
    73	James	Lynch		55508 Nancy Rapids		Port Nicholas	39086	TR				{}	{}
    74	Alyssa	Johnson		891 Bullock Ford		Amandachester	63705	TR				{}	{}
    75	Barry	Butler		125 Johnson Mountain Suite 701		Osbornetown	04756	TR				{}	{}
    76	Jaime	Casey		3751 Rachel Canyon Suite 408		East Clayton	82739	TR				{}	{}
    77	Kimberly	Hale		412 Snow Manors Apt. 161		South Kimtown	59053	TR				{}	{}
    78	Cassidy	Villarreal		1754 Anthony Fords		Matthewport	39343	TR				{}	{}
    79	David	Evans		296 Walsh Corner Apt. 758		South Rickychester	95945	TR				{}	{}
    80	Shane	Murray		1489 Roger Terrace		Davisfort	30957	TR				{}	{}
    81	John	Mora		64482 Amanda Loop		Figueroaview	38807	TR				{}	{}
    82	Scott	Carroll		11669 Taylor Skyway		Michaelfort	97801	TR				{}	{}
    83	Elizabeth	Smith		90443 Karen Heights		North Ryan	94393	TR				{}	{}
    84	Cynthia	Pitts		23949 Janet Passage Suite 567		Lake Heatherside	96762	TR				{}	{}
    85	Mark	Johnson		51385 Mary Glen		Larryfurt	33877	TR				{}	{}
    86	Lisa	Hansen		23732 Michael Island Suite 184		Lake Kenneth	58406	TR				{}	{}
    87	Willie	Murray		3019 Gerald Mall Apt. 340		Trevinoville	50923	TR				{}	{}
    88	Justin	Jackson		855 Lisa Wells		Mooreburgh	67409	TR				{}	{}
    89	Vernon	Hardin		957 Parker Forges		Lake Natasha	97149	TR				{}	{}
    90	Edward	Johnson		30035 Lori Key		Taylorborough	59347	TR				{}	{}
    91	Mary	Lyons		3230 Julia Villages		Lake Christian	78866	TR				{}	{}
    92	Jennifer	Mendez		5600 Davis Highway		South Joel	47137	TR				{}	{}
    93	Matthew	Pratt		48487 Kendra Ports Suite 076		South Michaelton	03212	TR				{}	{}
    94	Paul	Flowers		19539 Martin Ways Apt. 509		New Ericstad	48105	TR				{}	{}
    95	Marcus	Patton		02907 Matthew Branch Suite 493		New Sharonview	23285	TR				{}	{}
    96	Donna	Moore		896 Baker Haven		South Kimberlyview	34342	TR				{}	{}
    97	Veronica	Lee		08296 Marshall Camp Suite 930		Allisonburgh	89663	TR				{}	{}
    98	Courtney	Crawford		342 Miller Mission		Lake Jennifer	67203	TR				{}	{}
    99	Sarah	Walters		6595 Kurt Park Apt. 436		Grahamfurt	91871	TR				{}	{}
    100	Raymond	Mccall		19550 James Creek		Williamstown	41762	TR				{}	{}
    101	Tracey	Hubbard		2926 Dixon Estates Apt. 270		Port Angelafurt	24122	TR				{}	{}
    102	Christopher	Thompson		45448 Lutz Drives Suite 820		Lake William	99813	TR				{}	{}
    103	Christopher	Thompson		45448 Lutz Drives Suite 820		Lake William	99813	TR				{}	{}
    104	Leslie	Arroyo		793 Boyd Station		Robertaberg	62954	TR				{}	{}
    105	Kelsey	Brown		501 Ronald Knoll		Rogersfurt	67662	TR				{}	{}
    106	Michael	Skinner		50220 Blackwell Fields		South Deannaport	51555	TR				{}	{}
    107	Rhonda	Burke		1607 Munoz River		Emilyshire	59960	TR				{}	{}
    108	Robert	Johnson		61511 Michael Fall Suite 905		Gibbsfort	62961	TR				{}	{}
    109	Christopher	Williams		0811 Howard Courts Suite 028		Susantown	49874	TR				{}	{}
    110	Matthew	Blackburn		22395 Timothy Road		Williamsbury	83819	TR				{}	{}
    111	Juan	Jackson		3267 Walter Dam		Cunninghamtown	21753	TR				{}	{}
    112	Sarah	Smith		220 Madison Pass Apt. 001		Port Eric	50291	TR				{}	{}
    113	Kristin	Barnes		325 Amanda Cliffs Apt. 695		South Paulabury	62253	TR				{}	{}
    114	Patrick	Hendricks		769 Mary Harbor		Amyfort	31567	TR				{}	{}
    115	Joshua	Carr		180 Jennifer Burg Suite 661		Munozburgh	22731	TR				{}	{}
    116	Matthew	Jenkins		155 Courtney Trafficway Suite 803		Gregoryshire	43056	TR				{}	{}
    117	Kenneth	Walters		606 Brooks Fords Suite 221		Gabrielchester	76089	TR				{}	{}
    118	Raymond	Jones		8822 Jared Forks		New Derekfort	47290	TR				{}	{}
    119	Rachel	Hanson		516 Nolan Junctions Suite 826		Jimmyfurt	45920	TR				{}	{}
    120	Peter	Ruiz		6122 Brandy Roads Apt. 399		West Haleyburgh	49765	TR				{}	{}
    121	Christopher	Johnson		7517 Silva Glen		Burnettbury	21347	TR				{}	{}
    122	Anna	Wilcox		202 Franklin Fords		Ericksonfurt	35120	TR				{}	{}
    123	Andrew	Taylor		79061 Cook Parkways Suite 079		West Marissafort	72694	TR				{}	{}
    124	Deanna	Kennedy		85249 Stephen Cliff		Longchester	73395	TR				{}	{}
    125	Christopher	Olson		2512 Mackenzie Dam		North Antonio	53500	TR				{}	{}
    126	Angela	Campos		178 Baxter Junctions Apt. 033		Robersonport	36474	TR				{}	{}
    127	Jeffrey	Simpson		14963 Stuart Wall Apt. 343		Kellerstad	37581	TR				{}	{}
    128	Patrick	Anderson		5873 Chen Knolls		Ramirezfurt	94134	TR				{}	{}
    129	Victoria	Delacruz		1725 Julia Junction Suite 316		Marshallmouth	74673	TR				{}	{}
    137	Nicholas	Hutchinson	Cook, Allen and Walsh	69602 Brown Squares Apt. 787		North Troyport	61697	TR				{}	{}
    138	Jacob	Key	Lamb Group	206 Stewart Forest		Lake Karenhaven	80725	TR				{}	{}
    139	Debra	Russo	Lee PLC	217 Burton Brooks Suite 714		Lake Abigail	85800	TR				{}	{}
    140	Andrew	Williams	Reed, Wiggins and Ramirez	559 Meghan Squares Suite 765		East Nicholas	38647	TR				{}	{}
    141	Mathew	Clarke	Taylor LLC	9004 Edward Prairie		Michaelside	17493	TR				{}	{}
    142	Sarah	Parker	Wilson-Cross	6546 Cory Orchard		Rogersmouth	16796	TR				{}	{}
    143	Timothy	Lyons		45229 Drake Route Apt. 113		North Paul	13356	TR				{}	{}
    144	Shane	Burns		1534 Ryan Knolls		North Lynntown	69420	TR				{}	{}
    145	Shannon	Rhodes		6430 Cindy Cove		South Nicholas	72117	TR				{}	{}
    146	Margaret	Garcia		96687 Bass Parks Apt. 893		West Janicemouth	42683	TR				{}	{}
    147	Christopher	Melton		32040 Rivera Estates		Port Diana	49170	TR				{}	{}
    148	Joy	Turner		1744 Cruz Lights Apt. 223		Jessicamouth	07779	TR				{}	{}
    149	Cheryl	Hughes		72009 Crystal Cove		Jamesfort	15049	TR				{}	{}
    150	Jaime	Casey		3751 Rachel Canyon Suite 408		East Clayton	82739	TR				{}	{}
    151	Kimberly	Hale		412 Snow Manors Apt. 161		South Kimtown	59053	TR				{}	{}
    152	Ryan	Butler		4151 Michael Burgs Suite 520		Port Michael	78697	TR				{}	{}
    153	Maxwell	Haley		35574 Giles Plaza		Jackland	13946	TR				{}	{}
    154	Cynthia	Walsh		6065 Harris Hill		Davisburgh	14737	TR				{}	{}
    155	Crystal	Miller		0797 Jeffery Crescent		Amyberg	56102	TR				{}	{}
    156	Regina	Larson		44851 Pamela Track		North Robert	38471	TR				{}	{}
    157	Brittany	Taylor		7637 Neal Island Suite 074		Lake Tyler	81915	TR				{}	{}
    158	Adam	Nelson		329 Lee Mews Suite 562		Robertchester	19902	TR				{}	{}
    159	Michael	Paul		94918 Wise Knoll		Ellishaven	87746	TR				{}	{}
    160	Nicole	Norton		754 Alejandra Field Suite 138		Jacobborough	33436	TR				{}	{}
    161	Tiffany	Stevens		13126 Scott Club		Hansenfurt	05658	TR				{}	{}
    162	Steven	Walters		01912 Wright Haven Apt. 886		North Paulview	15999	TR				{}	{}
    163	Lisa	Mcdowell		81237 Joe Curve		Port Patrick	80258	TR				{}	{}
    164	Kevin	Kelly		250 Burton Burg		North Alexander	86205	TR				{}	{}
    165	Michael	Beck		76254 Debra Stream		Reyeschester	35070	TR				{}	{}
    166	Katherine	Cunningham		6208 Christy Shore		North Mark	23605	TR				{}	{}
    167	Sue	Kemp		169 Christine Mount		New Carolyn	33593	TR				{}	{}
    168	Anthony	Randolph		1542 Young Knolls		Lake Karen	44756	TR				{}	{}
    169	Lance	Lester		89840 Foster Crest Suite 570		West Jodyton	33782	TR				{}	{}
    170	Kathryn	Black		3195 Brenda Stravenue Suite 225		New Lisashire	20970	TR				{}	{}
    171	Kelly	Carter		9620 Ashley Mills Apt. 507		Julieborough	09708	TR				{}	{}
    172	Joshua	Greer		29188 Fischer Grove		Justinchester	94599	TR				{}	{}
    173	Amanda	Spencer		62082 Ward Camp Suite 930		Allisonburgh	89663	TR				{}	{}
    174	Christian	West		132 Mclean Meadow Suite 446		Chelsealand	40742	TR				{}	{}
    175	Kathryn	Hughes		097 Gallegos Crossroad Suite 506		Mccallberg	05951	TR				{}	{}
    176	Kathryn	Hughes		097 Gallegos Crossroad Suite 506		Mccallberg	05951	TR				{}	{}
    177	Christopher	Hancock		13187 Leonard Ville Apt. 562		Richardberg	78575	TR				{}	{}
    178	Dylan	Delacruz		22708 Madison Spurs		Herringstad	77293	TR				{}	{}
    179	Lisa	Miller		3454 Holmes Motorway		Port Rachel	72947	TR				{}	{}
    180	Eric	Chen		805 James Turnpike		Carrmouth	68955	TR				{}	{}
    181	Erik	Cook		8081 Smith Trail		North Ronaldstad	75247	TR				{}	{}
    182	Shannon	Bass		125 Ian Crossroad Apt. 593		South Deannaport	51555	TR				{}	{}
    183	Rhonda	Burke		1607 Munoz River		Emilyshire	59960	TR				{}	{}
    184	Robert	Johnson		61511 Michael Fall Suite 905		Gibbsfort	62961	TR				{}	{}
    185	Christopher	Williams		0811 Howard Courts Suite 028		Susantown	49874	TR				{}	{}
    186	Matthew	Blackburn		22395 Timothy Road		Williamsbury	83819	TR				{}	{}
    187	Juan	Jackson		3267 Walter Dam		Cunninghamtown	21753	TR				{}	{}
    188	Sarah	Smith		220 Madison Pass Apt. 001		Port Eric	50291	TR				{}	{}
    189	Kristin	Barnes		325 Amanda Cliffs Apt. 695		South Paulabury	62253	TR				{}	{}
    190	Patrick	Hendricks		769 Mary Harbor		Amyfort	31567	TR				{}	{}
    191	Joshua	Carr		180 Jennifer Burg Suite 661		Munozburgh	22731	TR				{}	{}
    192	Matthew	Jenkins		155 Courtney Trafficway Suite 803		Gregoryshire	43056	TR				{}	{}
    193	Kenneth	Walters		606 Brooks Fords Suite 221		Gabrielchester	76089	TR				{}	{}
    194	Raymond	Jones		8822 Jared Forks		New Derekfort	47290	TR				{}	{}
    195	Rachel	Hanson		516 Nolan Junctions Suite 826		Jimmyfurt	45920	TR				{}	{}
    196	Peter	Ruiz		6122 Brandy Roads Apt. 399		West Haleyburgh	49765	TR				{}	{}
    197	Christopher	Johnson		7517 Silva Glen		Burnettbury	21347	TR				{}	{}
    198	Anna	Wilcox		202 Franklin Fords		Ericksonfurt	35120	TR				{}	{}
    199	Andrew	Taylor		79061 Cook Parkways Suite 079		West Marissafort	72694	TR				{}	{}
    200	Deanna	Kennedy		85249 Stephen Cliff		Longchester	73395	TR				{}	{}
    201	Christopher	Olson		2512 Mackenzie Dam		North Antonio	53500	TR				{}	{}
    202	Angela	Campos		178 Baxter Junctions Apt. 033		Robersonport	36474	TR				{}	{}
    \.


    --
    -- Data for Name: account_customerevent; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.account_customerevent (id, date, type, parameters, user_id, app_id, order_id) FROM stdin;
    \.


    --
    -- Data for Name: account_customernote; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.account_customernote (id, date, content, is_public, customer_id, user_id) FROM stdin;
    \.


    --
    -- Data for Name: account_group; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.account_group (id, name, restricted_access_to_channels) FROM stdin;
    1	Full Access	f
    2	Customer Support	f
    3	Checkouts management	f
    4	Payments management	f
    5	Taxes management	f
    6	User management	f
    7	Apps management	f
    8	Channels management	f
    9	Discounts management	f
    10	Gift card management	f
    11	Menus management	f
    12	Observability management	f
    13	Orders management	f
    14	Orders import management	f
    15	Page types and attributes management	f
    16	Pages management	f
    17	Plugins management	f
    18	Product types and attributes management	f
    19	Products management	f
    20	Settings management	f
    21	Shipping management	f
    22	Staff management	f
    23	Translations management	f
    24	Users management	f
    \.


    --
    -- Data for Name: account_group_channels; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.account_group_channels (id, group_id, channel_id) FROM stdin;
    \.


    --
    -- Data for Name: account_group_permissions; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.account_group_permissions (id, group_id, permission_id) FROM stdin;
    1	1	515
    2	1	516
    3	1	5
    4	1	139
    5	1	140
    6	1	141
    7	1	409
    8	1	38
    9	1	422
    10	1	423
    11	1	432
    12	1	178
    13	1	309
    14	1	441
    15	1	314
    16	1	315
    17	1	316
    18	1	317
    19	1	450
    20	1	195
    21	1	204
    22	1	350
    23	1	363
    24	1	364
    25	2	139
    26	2	363
    27	2	364
    28	2	178
    29	2	314
    30	2	315
    31	2	316
    32	2	317
    33	3	315
    34	4	450
    35	5	316
    36	6	141
    37	7	515
    38	8	309
    39	3	314
    40	9	38
    41	10	178
    42	11	350
    43	12	516
    44	13	363
    45	14	364
    46	15	441
    47	16	432
    48	17	5
    49	18	204
    50	19	195
    51	20	422
    52	21	409
    53	22	140
    54	5	317
    55	23	423
    56	24	139
    \.


    --
    -- Data for Name: account_staffnotificationrecipient; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.account_staffnotificationrecipient (id, staff_email, active, user_id) FROM stdin;
    \.


    --
    -- Data for Name: account_user; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.account_user (id, is_superuser, email, is_staff, is_active, password, date_joined, last_login, default_billing_address_id, default_shipping_address_id, note, first_name, last_name, avatar, private_metadata, metadata, jwt_token_key, language_code, search_document, updated_at, uuid, external_reference, last_password_reset_request, is_confirmed, last_confirm_email_request) FROM stdin;
    1	f	shane.burns@example.com	f	t	pbkdf2_sha256$260000$VQPDGn8jBrCUjt3CgfQXaI$oiBy50ycqN+0+xZq851tkq0FDc8hbvTtw6V/PIbyu6k=	2006-12-23 18:13:15.961966+00	\N	9	9	Budget huge debate among way. Perhaps bit learn gun still. Writer work chance image.	Shane	Burns		{}	{}	sRKVz4nDrpYu	en	shane.burns@example.com\nshane\nburns\nshane\nburns\n1534 ryan knolls\n\nnorth lynntown\n69420\ntürkiye\ntr\n\n	2024-05-20 11:17:30.006854+00	39d88f58-0fa5-42c3-8935-3af139c4a3a2	\N	\N	t	\N
    2	f	natalie.simpson@example.com	f	t	pbkdf2_sha256$260000$oCgX885zxYwkbeWnP3KOoq$q471YMSetxVUY4AoTR59zF58d4UIXsURNoYBlUKEYz4=	2011-03-20 11:01:18.945556+00	\N	10	10	Family relationship like son might trip at candidate. Address such former claim chance. Why measure too maybe off question source.	Natalie	Simpson		{}	{}	S9V70RHcoH2C	en	natalie.simpson@example.com\nnatalie\nsimpson\nnatalie\nsimpson\n7389 alec squares suite 508\n\nport jonathan\n20935\ntürkiye\ntr\n\n	2024-05-20 11:17:30.262699+00	0f2338ec-9977-4bb2-aca4-034defd5e02b	\N	\N	t	\N
    3	f	vicki.burgess@example.com	f	t	pbkdf2_sha256$260000$gmO78FPDLsxIQZzxkzwGFO$qmhIg9Uit+WX3bVwRfc7Tv5fRx5B0i5pVVOmfu2sfnM=	2006-08-18 22:01:17.462184+00	\N	11	11	Effort assume teacher wall field impact special. Clearly very dream role. Area along individual man tell response.	Vicki	Burgess		{}	{}	fCQ88YX5G7Ua	en	vicki.burgess@example.com\nvicki\nburgess\nvicki\nburgess\n8967 lawson fort\n\nlake nicoleburgh\n40142\ntürkiye\ntr\n\n	2024-05-20 11:17:30.519441+00	b21779a1-51a2-4622-8add-eca1d32c5e69	\N	\N	t	\N
    4	f	edward.hatfield@example.com	f	t	pbkdf2_sha256$260000$dHMArdzT2E1Gwtjufol2MV$YLtHw9sGRqeeM2YXd1rd2DgrCnAtc4M0b2ROhXF/MmI=	2012-09-19 12:58:22.265999+00	\N	12	12	Crime situation since book art red. Place full buy radio perform small camera treatment. True their race special million.	Edward	Hatfield		{}	{}	G8fJHuFvJCbN	en	edward.hatfield@example.com\nedward\nhatfield\nedward\nhatfield\n97670 thomas drive apt. 099\n\nlake mario\n92261\ntürkiye\ntr\n\n	2024-05-20 11:17:30.824276+00	6729f3dd-5e24-41fa-884c-ca1484cd4c4a	\N	\N	t	\N
    5	f	jaime.casey@example.com	f	t	pbkdf2_sha256$260000$DGTEzLjvbdJIdOGM9tRS3a$EBV4U5gitSveFDN0rETncmaSlyIAJyjQzMaFhYjVIKU=	1989-07-16 00:25:22.021469+00	\N	13	13	Information figure box international not type very. As indeed choose west social issue. Air try while reveal bad audience.	Jaime	Casey		{}	{}	LzBMUaLbqOt5	en	jaime.casey@example.com\njaime\ncasey\njaime\ncasey\n3751 rachel canyon suite 408\n\neast clayton\n82739\ntürkiye\ntr\n\n	2024-05-20 11:17:31.12356+00	431619ad-7040-4f9d-bf6f-a8f972f4fe19	\N	\N	t	\N
    6	f	anthony.bailey@example.com	f	t	pbkdf2_sha256$260000$9cmOcviNB2xrjfgYISnlAR$52x+R1Nwfm5DHiUQhyxRZCPPxHY79R6ubo92wWcP2bE=	1988-03-21 12:34:39.011147+00	\N	14	14	Do center law live religious election agreement decade.	Anthony	Bailey		{}	{}	DGxIHDAMsZSu	en	anthony.bailey@example.com\nanthony\nbailey\nanthony\nbailey\n51923 jamie spring\n\nlake adrianstad\n90870\ntürkiye\ntr\n\n	2024-05-20 11:17:31.367859+00	8965cc87-5fc6-446c-9632-2984f46f5da5	\N	\N	t	\N
    7	f	susan.phillips@example.com	f	t	pbkdf2_sha256$260000$8AizofrVtrOIs96uTfqaHn$y7doCO2UrUty5KVNzUPjvtnFTH5paQvzHAftUNHso3g=	1990-06-22 05:47:01.24632+00	\N	15	15	Production technology over hour reduce car. Nearly scientist central instead PM. Easy plan PM more.	Susan	Phillips		{}	{}	5bTVas7na4qk	en	susan.phillips@example.com\nsusan\nphillips\nsusan\nphillips\n91189 moore drive apt. 358\n\neast kari\n38650\ntürkiye\ntr\n\n	2024-05-20 11:17:31.611128+00	bcefe398-c5c5-42a1-a9d4-1746526bf8cd	\N	\N	t	\N
    8	f	alan.hayden@example.com	f	t	pbkdf2_sha256$260000$xiN2fMJl4GGC9ldsuOBOFf$YDhpKcgeT3MCWai8349RL62sTQs5PyOdQOVO5mUva8s=	2003-08-26 05:37:58.782329+00	\N	16	16	It easy law view central leg. Low data ability recognize.	Alan	Hayden		{}	{}	G3l7j8SzIe6u	en	alan.hayden@example.com\nalan\nhayden\nalan\nhayden\n3547 stephanie underpass apt. 418\n\nport jacqueline\n52769\ntürkiye\ntr\n\n	2024-05-20 11:17:32.001333+00	1b980d4a-a59e-4b2e-9c85-7a588da2f66a	\N	\N	t	\N
    9	f	alan.evans@example.com	f	t	pbkdf2_sha256$260000$Spe9364iajEddhaavJO9Yf$qT7k6X0aYcK7PZvUlKzPAPWqyWUerljbeFMb9AY5ZlA=	1998-11-01 07:44:50.361367+00	\N	17	17	Moment ok how bill education exist. Other along society figure future.	Alan	Evans		{}	{}	exhFWCfWvWyw	en	alan.evans@example.com\nalan\nevans\nalan\nevans\n926 davis parks apt. 864\n\nnorth josephton\n00534\ntürkiye\ntr\n\n	2024-05-20 11:17:32.262463+00	8337fefa-5237-43db-904e-0cd63ee100f4	\N	\N	t	\N
    10	f	john.mora@example.com	f	t	pbkdf2_sha256$260000$Vy3dpUuHRWKNP1MfI0NFOL$EuG1lsY7tCxj/ursdg04bRJAOAqgDBLgc5H1bVj/WTc=	1981-09-24 19:51:36.047234+00	\N	18	18	Nothing case but building husband life. Property government line indeed live reason five. Know central many thought.	John	Mora		{}	{}	25FH6rBgzmK0	en	john.mora@example.com\njohn\nmora\njohn\nmora\n64482 amanda loop\n\nfigueroaview\n38807\ntürkiye\ntr\n\n	2024-05-20 11:17:32.502621+00	bcbf9d9d-8086-4934-b5da-23c29bf6fc69	\N	\N	t	\N
    11	f	michael.myers@example.com	f	t	pbkdf2_sha256$260000$0LbRnttrXvEcqs90ZZXpFK$dfwGSu9OSJDOPtLE6Rebu5Hb+VyMiIaxEwE2vldPi88=	1978-01-08 21:01:43.931366+00	\N	19	19	Seem explain black leave. Himself former possible reach challenge value.	Michael	Myers		{}	{}	kUU4OsgJpaKZ	en	michael.myers@example.com\nmichael\nmyers\nmichael\nmyers\n116 michael crescent\n\nwest morganport\n95803\ntürkiye\ntr\n\n	2024-05-20 11:17:32.769301+00	cf98d6df-da50-49f1-93c8-b3abff266446	\N	\N	t	\N
    12	f	leslie.clark@example.com	f	t	pbkdf2_sha256$260000$9VdPiImgW8qXUd6bnwYX38$279DUj09iNtZ/7G7ciU7mkof6R6x0TitQDbrHUYuabA=	1982-09-04 11:07:09.324287+00	\N	20	20	Almost plan that hair sea quality.	Leslie	Clark		{}	{}	3CkmNaeIKoYd	en	leslie.clark@example.com\nleslie\nclark\nleslie\nclark\n5667 blair underpass\n\nsouth shelby\n77378\ntürkiye\ntr\n\n	2024-05-20 11:17:33.000491+00	2f3befc3-6913-4cb4-9921-fd56c95cc0f2	\N	\N	t	\N
    13	f	kenneth.miller@example.com	f	t	pbkdf2_sha256$260000$ztiU5GT7BN6XATrim7zoAV$HCJ2MqduIQhu9BL44WEw0inlFTnoGXgScxTgZ6Pb3pQ=	2018-08-04 12:31:27.128695+00	\N	21	21	Face according as. Quite wife however TV law fund. Paper beat five movie.	Kenneth	Miller		{}	{}	e2CSd7Cc6wi7	en	kenneth.miller@example.com\nkenneth\nmiller\nkenneth\nmiller\n6708 carpenter overpass suite 735\n\nbobbyton\n21847\ntürkiye\ntr\n\n	2024-05-20 11:17:33.372626+00	a52787c2-3332-41d1-be24-b080b89ec749	\N	\N	t	\N
    14	f	jonathan.boyd@example.com	f	t	pbkdf2_sha256$260000$Uxva3Xb4kjw32Au3rbPrWp$8x1S+ZiV/lNOb2ObGPpkYW4NG/6rmiHNitx9zZCspfg=	2003-04-29 11:23:16.530512+00	\N	22	22	The drive figure necessary across manager. Answer speak without leave brother bank. Step child this degree.	Jonathan	Boyd		{}	{}	TZF0iz8VGP64	en	jonathan.boyd@example.com\njonathan\nboyd\njonathan\nboyd\n1385 mary glen\n\nlarryfurt\n33877\ntürkiye\ntr\n\n	2024-05-20 11:17:33.744372+00	0e8c28ae-e05f-48cb-ade2-84a5ab3134f0	\N	\N	t	\N
    15	f	lisa.hansen@example.com	f	t	pbkdf2_sha256$260000$sLb0tSavAVj2QPWo421ePx$V+y0b0Sly5gepxzw72Nx1bxduSQGFLCcdG2HIwvCIBY=	2010-02-05 00:09:17.164001+00	\N	23	23	Left plant evening admit past Republican common increase. Expect save process score middle. Business population brother.	Lisa	Hansen		{}	{}	wnJv0TojcXfb	en	lisa.hansen@example.com\nlisa\nhansen\nlisa\nhansen\n23732 michael island suite 184\n\nlake kenneth\n58406\ntürkiye\ntr\n\n	2024-05-20 11:17:34.125867+00	b46ac8a9-8c77-4682-b954-9030d6ea4ea7	\N	\N	t	\N
    16	f	michael.leonard@example.com	f	t	pbkdf2_sha256$260000$uviTbqI1MPEabSp6iKWsp7$GOrOcWpYTYKCVAKmofaQ3VV1AeoprOTrjunjuUOs6Gk=	1977-05-17 02:30:50.936848+00	\N	24	24	Theory choice computer yard.	Michael	Leonard		{}	{}	rar6dymeHK20	en	michael.leonard@example.com\nmichael\nleonard\nmichael\nleonard\n31845 nathaniel neck suite 922\n\nnew williamstad\n77234\ntürkiye\ntr\n\n	2024-05-20 11:17:34.506321+00	b97c6853-b66d-417d-8299-20951b5bbb70	\N	\N	t	\N
    17	f	jamie.herman@example.com	f	t	pbkdf2_sha256$260000$HzI9kfYcH1dlxj3aDgc0k3$b3Fjicg6RC218a6vML7pehiZRV4B6Pa0zHXiJP2Ux7g=	1980-05-23 05:54:44.813771+00	\N	25	25	When new clear. Speak say national region bad case I.	Jamie	Herman		{}	{}	lUtChNgRq37K	en	jamie.herman@example.com\njamie\nherman\njamie\nherman\n332 kathleen knoll apt. 719\n\nnew caitlinfort\n60217\ntürkiye\ntr\n\n	2024-05-20 11:17:34.752426+00	e0a51246-ddf7-40a6-8d27-a91a1d9a8af7	\N	\N	t	\N
    18	f	leslie.carter@example.com	f	t	pbkdf2_sha256$260000$77Bao8Xp2HLI3xEoSvb5vo$1kSoBx5gYz364jG8FXoMX2sx7HzTE2/bs7uFfBWWvhI=	1993-09-01 20:15:35.891607+00	\N	26	26	Run character against physical. Drop actually watch. At artist will institution throughout describe.	Leslie	Carter		{}	{}	JNkjmqcHN9yy	en	leslie.carter@example.com\nleslie\ncarter\nleslie\ncarter\n05357 jordan skyway\n\nwest andre\n75682\ntürkiye\ntr\n\n	2024-05-20 11:17:34.991189+00	65ca9fe9-3f6c-40fc-bfc5-e12a81e24450	\N	\N	t	\N
    19	f	michael.thompson@example.com	f	t	pbkdf2_sha256$260000$Da5KW2oy0WMMm76ZhWAYd2$E1VaqrMGqYWq0Yg66xOU2ApRvL0+YiSsfRbk6Ham/dM=	2015-08-05 09:57:56.796211+00	\N	27	27	Perform product style record. Form style star east. What to sea.	Michael	Thompson		{}	{}	R9zXEk6Hhhyd	en	michael.thompson@example.com\nmichael\nthompson\nmichael\nthompson\n660 macdonald place suite 091\n\nfinleyburgh\n00908\ntürkiye\ntr\n\n	2024-05-20 11:17:35.23001+00	6fdcc2f2-52ae-4185-8991-d8a813fb0266	\N	\N	t	\N
    20	f	anna.robbins@example.com	f	t	pbkdf2_sha256$260000$JqdDsZdG4Zh1R0vukqdB3Z$Z8MLufVbj9oQLLoFb/BO2a9l4K8j8Agvtwie7LXUcWE=	2000-01-10 12:45:18.191376+00	\N	28	28	Door green save identify establish manage hotel. Morning explain light alone mother.	Anna	Robbins		{}	{}	QglpLTZa7RqR	en	anna.robbins@example.com\nanna\nrobbins\nanna\nrobbins\n197 christina canyon suite 560\n\nsouth christopherport\n88534\ntürkiye\ntr\n\n	2024-05-20 11:17:35.508162+00	f12489ed-12d8-4bfd-8d25-5bcbe6a2a70b	\N	\N	t	\N
    21	t	admin@example.com	t	t	pbkdf2_sha256$260000$kjDxOx0NhEbMqMuziBAGFp$ARjYYNmQ+LGcPKJqKozz2DuLYcwyztkwOA3bcNc98MU=	2024-05-20 11:17:43.44626+00	\N	37	37	\N				{}	{}	maonz3DCPdlj	en		2024-05-20 11:17:43.81441+00	6fee2cb3-d83b-4fea-916f-f671edac508f	\N	\N	t	\N
    22	f	melvin.willis@example.com	t	t	pbkdf2_sha256$260000$YWESziDiQ2RHo36ECvgS7l$lCKwYO8OF9n2lTdzogHsZD6BQW6LrYTStfLvK44t9Bo=	2024-05-20 11:17:44.108802+00	\N	38	38	\N	Melvin	Willis		{}	{}	FDhpv1gBvrGk	en	melvin.willis@example.com\nmelvin\nwillis\nmelvin\nwillis\n82434 graves glen\n\nzacharymouth\n20843\ntürkiye\ntr\n\n	2024-05-20 11:17:44.348717+00	d048692d-3d95-409b-85b6-101986a09a7d	\N	\N	t	\N
    23	f	katherine.cole@example.com	t	t	pbkdf2_sha256$260000$rGP5aSZdVsO5UGiYNvpRlk$e/tPSPMHUchCOXjsqIK8PQa7IEdOnOiyplhp4QNoqJA=	2024-05-20 11:17:44.36785+00	\N	44	44	\N	Katherine	Cole		{}	{}	BlIwR2QNhLbd	en	katherine.cole@example.com\nkatherine\ncole\nkatherine\ncole\n92805 james turnpike\n\ncarrmouth\n68955\ntürkiye\ntr\n\n	2024-05-20 11:17:44.621568+00	e842d42e-6f25-4530-96f4-1dd7c193fe86	\N	\N	t	\N
    24	f	checkout.manager@example.com	t	t	pbkdf2_sha256$260000$NkXBPFa7dTywzWEuDU74iA$FuK0rVKCSkGaPFXXwqBqFmmPQ1RXDHGN9voVhx7/0uA=	2024-05-20 11:17:44.674526+00	\N	47	47	\N	Erik	Cook		{}	{}	ZQVlT7XVsMP9	en	checkout.manager@example.com\nerik\ncook\nerik\ncook\n8081 smith trail\n\nnorth ronaldstad\n75247\ntürkiye\ntr\n\n	2024-05-20 11:17:44.900072+00	aff38c16-d466-42e4-82c6-8cd8efcb3391	\N	\N	t	\N
    25	f	payment.manager@example.com	t	t	pbkdf2_sha256$260000$ZOg0vMHZOOMXnGSFOevlzh$ZU4UBlVUitUAMwy9z7ogVQ1DJ7MgbAAjs3dM5iMhT/k=	2024-05-20 11:17:44.937148+00	\N	48	48	\N	Shannon	Bass		{}	{}	Pfx1mRjCCdTR	en	payment.manager@example.com\nshannon\nbass\nshannon\nbass\n125 ian crossroad apt. 593\n\nsouth deannaport\n51555\ntürkiye\ntr\n\n	2024-05-20 11:17:45.167975+00	e5a4c9a4-b4ac-4480-956f-6b6de4f35868	\N	\N	t	\N
    26	f	taxe.manager@example.com	t	t	pbkdf2_sha256$260000$RcPYMesiqC3JTTq79bpig7$/VOyH2mjxDdy/OVkZXvKajWwimqfWM7hbtP5IftIlN4=	2024-05-20 11:17:45.206214+00	\N	49	49	\N	Rhonda	Burke		{}	{}	WYpUud2mkULG	en	taxe.manager@example.com\nrhonda\nburke\nrhonda\nburke\n1607 munoz river\n\nemilyshire\n59960\ntürkiye\ntr\n\n	2024-05-20 11:17:45.470931+00	ee6d9a80-83fe-4831-b0a4-d89852ac2e54	\N	\N	t	\N
    27	f	user.manager@example.com	t	t	pbkdf2_sha256$260000$kcLF4vSLuSAp1r9n7AVwH9$HdeapMp9kLCaknZEOfUmyAFh3cskAHLMQA3XOIzQ06U=	2024-05-20 11:17:45.505366+00	\N	50	50	\N	Robert	Johnson		{}	{}	MufVmLUADBag	en	user.manager@example.com\nrobert\njohnson\nrobert\njohnson\n61511 michael fall suite 905\n\ngibbsfort\n62961\ntürkiye\ntr\n\n	2024-05-20 11:17:45.736987+00	6b20bfee-4672-4e93-b97a-a3875db2938f	\N	\N	t	\N
    28	f	app.manager@example.com	t	t	pbkdf2_sha256$260000$WsF1w8OstvFFQHrSjuIryt$5n1VpDnsKWG+z/uGOhcYfzC4fNnDqrnTS9y8xpErS/k=	2024-05-20 11:17:45.773341+00	\N	51	51	\N	Christopher	Williams		{}	{}	EXgPkgXtYQoa	en	app.manager@example.com\nchristopher\nwilliams\nchristopher\nwilliams\n0811 howard courts suite 028\n\nsusantown\n49874\ntürkiye\ntr\n\n	2024-05-20 11:17:46.031668+00	392a255c-1df4-42a4-b604-1cfb5037320a	\N	\N	t	\N
    29	f	channel.manager@example.com	t	t	pbkdf2_sha256$260000$ZiblLLgvcYRVOJHdw7l9uU$aqF3G/wiznGrHfvAUXYxaDXUGGzk5QFyA1SHGXddj7I=	2024-05-20 11:17:46.057564+00	\N	52	52	\N	Matthew	Blackburn		{}	{}	xMdq0wVBXw32	en	channel.manager@example.com\nmatthew\nblackburn\nmatthew\nblackburn\n22395 timothy road\n\nwilliamsbury\n83819\ntürkiye\ntr\n\n	2024-05-20 11:17:46.461624+00	6f24917d-30a0-44a1-b492-8eda3dd691e4	\N	\N	t	\N
    30	f	discount.manager@example.com	t	t	pbkdf2_sha256$260000$Mscm7bZ1XdTXUk4eYni8ve$LPCDDE3TmPvOAdS+4+ElGiwStb97Y/y55ADczZnkan8=	2024-05-20 11:17:46.520106+00	\N	54	54	\N	Sarah	Smith		{}	{}	JY0TOARj6kIU	en	discount.manager@example.com\nsarah\nsmith\nsarah\nsmith\n220 madison pass apt. 001\n\nport eric\n50291\ntürkiye\ntr\n\n	2024-05-20 11:17:46.770816+00	7967c6e2-329c-4524-ac1d-53861bd1ec45	\N	\N	t	\N
    31	f	gift.card.manager@example.com	t	t	pbkdf2_sha256$260000$Nhkt1by8DWsF4CXT7LFOqc$mPO5VKtxhvdZyfAU0BaXeRnhF6Yw6IVEZe+fQ/Si/Mo=	2024-05-20 11:17:46.802298+00	\N	55	55	\N	Kristin	Barnes		{}	{}	QpJ7ajqbT4Pc	en	gift.card.manager@example.com\nkristin\nbarnes\nkristin\nbarnes\n325 amanda cliffs apt. 695\n\nsouth paulabury\n62253\ntürkiye\ntr\n\n	2024-05-20 11:17:47.067453+00	7b1fe40e-2a9b-404e-b971-a500be7048b4	\N	\N	t	\N
    32	f	menu.manager@example.com	t	t	pbkdf2_sha256$260000$kl6yqVDEg9o80DFEtcsgtP$4A0dBxPGNsgNELQCTMdF7ByVh9SdE1LaY5jgKaEbq7U=	2024-05-20 11:17:47.090633+00	\N	56	56	\N	Patrick	Hendricks		{}	{}	nDo5oMDbQcMG	en	menu.manager@example.com\npatrick\nhendricks\npatrick\nhendricks\n769 mary harbor\n\namyfort\n31567\ntürkiye\ntr\n\n	2024-05-20 11:17:47.340754+00	1db9d6b7-c443-43ad-8d3b-807c9117ba98	\N	\N	t	\N
    33	f	observability.manager@example.com	t	t	pbkdf2_sha256$260000$51E2CQNL8Y1C6vMebbatkl$OAGEUZSKGqA9o297VnqOrVdJEi2x3SoU3KL8w4uHwKk=	2024-05-20 11:17:47.376635+00	\N	57	57	\N	Joshua	Carr		{}	{}	TGREatJ8jYXD	en	observability.manager@example.com\njoshua\ncarr\njoshua\ncarr\n180 jennifer burg suite 661\n\nmunozburgh\n22731\ntürkiye\ntr\n\n	2024-05-20 11:17:47.635627+00	30a3b203-f31e-4057-8679-19119713377a	\N	\N	t	\N
    34	f	order.manager@example.com	t	t	pbkdf2_sha256$260000$IGgJnFYccdiNNBb4RnKwJp$m+lY/lbfEa/c5Jq8uHMgeGiN2ucWuLVOeY6aUiNSirg=	2024-05-20 11:17:47.663827+00	\N	58	58	\N	Matthew	Jenkins		{}	{}	aGt6jYwS5b2T	en	order.manager@example.com\nmatthew\njenkins\nmatthew\njenkins\n155 courtney trafficway suite 803\n\ngregoryshire\n43056\ntürkiye\ntr\n\n	2024-05-20 11:17:47.97095+00	837b0b92-27b4-4457-949b-602033e8c24f	\N	\N	t	\N
    35	f	order.import.manager@example.com	t	t	pbkdf2_sha256$260000$c38ibDVjmvFF7kSzW5Gdue$O8/JJda7VtIhWPVo0MGOwm9ZhRlTTGLQsuVCn7ZtyVA=	2024-05-20 11:17:48.020568+00	\N	59	59	\N	Kenneth	Walters		{}	{}	tY3Swq9mQSPL	en	order.import.manager@example.com\nkenneth\nwalters\nkenneth\nwalters\n606 brooks fords suite 221\n\ngabrielchester\n76089\ntürkiye\ntr\n\n	2024-05-20 11:17:48.378639+00	fe4377c2-c0a7-4b07-9d37-e1907c854c76	\N	\N	t	\N
    36	f	page.type.and.attribute.manager@example.com	t	t	pbkdf2_sha256$260000$JBoIQTu0ZQNIasUL90oBqF$ZYKVM+/BBfy1f1Yo1cfpRrtec1RhoNzyQvxzig3R6mY=	2024-05-20 11:17:48.41142+00	\N	60	60	\N	Raymond	Jones		{}	{}	aNyJuPXcIqDh	en	page.type.and.attribute.manager@example.com\nraymond\njones\nraymond\njones\n8822 jared forks\n\nnew derekfort\n47290\ntürkiye\ntr\n\n	2024-05-20 11:17:48.68136+00	4be6e0f6-28e3-476c-a889-702e836dabed	\N	\N	t	\N
    37	f	page.manager@example.com	t	t	pbkdf2_sha256$260000$hMOHAu0ijrxjPal85lxHpM$UwtoxVnEVJ3ev9hk2JygsEcdNhNlY+RdKHjcurwzu/Y=	2024-05-20 11:17:48.711904+00	\N	61	61	\N	Rachel	Hanson		{}	{}	kz0ij3FbMB7z	en	page.manager@example.com\nrachel\nhanson\nrachel\nhanson\n516 nolan junctions suite 826\n\njimmyfurt\n45920\ntürkiye\ntr\n\n	2024-05-20 11:17:48.946912+00	c8b4e4b4-7cb2-4a16-8583-b15640ec7810	\N	\N	t	\N
    38	f	plugin.manager@example.com	t	t	pbkdf2_sha256$260000$6jYnNAVhwjmbKBfyZShzOU$qlRacQm4tHUThoe+4HDe1FuWVSyga95MFdWUxmlNfO4=	2024-05-20 11:17:48.973972+00	\N	62	62	\N	Peter	Ruiz		{}	{}	4tT85spiOPgu	en	plugin.manager@example.com\npeter\nruiz\npeter\nruiz\n6122 brandy roads apt. 399\n\nwest haleyburgh\n49765\ntürkiye\ntr\n\n	2024-05-20 11:17:49.267686+00	3144a6fd-2310-4c43-9edd-538959b961af	\N	\N	t	\N
    39	f	product.type.and.attribute.manager@example.com	t	t	pbkdf2_sha256$260000$fRTNh2g76HLBUKvp6THVZ4$r5MJ4Qyn7lu+3UcUOChF5PVjEs6tpxFhisbStdEaMk0=	2024-05-20 11:17:49.296762+00	\N	63	63	\N	Christopher	Johnson		{}	{}	IDi4nmoWX9C1	en	product.type.and.attribute.manager@example.com\nchristopher\njohnson\nchristopher\njohnson\n7517 silva glen\n\nburnettbury\n21347\ntürkiye\ntr\n\n	2024-05-20 11:17:49.551211+00	6b358a40-1b60-4423-8206-1212f822ff0a	\N	\N	t	\N
    40	f	product.manager@example.com	t	t	pbkdf2_sha256$260000$c3kQHw8jpG0p3kKVlENxpa$FvI7YOiY2HhFCtK5G+V8GDYd8piKn5oFwIz1MDC+xAc=	2024-05-20 11:17:49.580851+00	\N	64	64	\N	Anna	Wilcox		{}	{}	veBKo4fu4MNp	en	product.manager@example.com\nanna\nwilcox\nanna\nwilcox\n202 franklin fords\n\nericksonfurt\n35120\ntürkiye\ntr\n\n	2024-05-20 11:17:49.810296+00	7e4b51ca-935a-42a9-b04b-0b8951d9b779	\N	\N	t	\N
    41	f	setting.manager@example.com	t	t	pbkdf2_sha256$260000$MjXFp2epuj9Ojq6LsJCZaw$0cQDlmkIXLejhuIdlwxGkoSd6zR3bXLW+Mk5jdmASdw=	2024-05-20 11:17:49.845936+00	\N	65	65	\N	Andrew	Taylor		{}	{}	SW2OjfeiZX1Z	en	setting.manager@example.com\nandrew\ntaylor\nandrew\ntaylor\n79061 cook parkways suite 079\n\nwest marissafort\n72694\ntürkiye\ntr\n\n	2024-05-20 11:17:50.171835+00	a24b52c6-ebf8-4c5d-a16e-80c6c0531a47	\N	\N	t	\N
    42	f	shipping.manager@example.com	t	t	pbkdf2_sha256$260000$FjZwHwrnFYoYaKrlMgQ31b$2+Ml/pCYb3wP2l9P2fo0o/aEm852P6KTugBBEc7yeNI=	2024-05-20 11:17:50.210278+00	\N	66	66	\N	Deanna	Kennedy		{}	{}	O7E6mR1sRh0d	en	shipping.manager@example.com\ndeanna\nkennedy\ndeanna\nkennedy\n85249 stephen cliff\n\nlongchester\n73395\ntürkiye\ntr\n\n	2024-05-20 11:17:50.50177+00	6129549c-b7d0-40f9-a553-e451f5014be4	\N	\N	t	\N
    43	f	staff.manager@example.com	t	t	pbkdf2_sha256$260000$e1hBbvoxC8E2DOxvkD36xH$64hH+/9D/4AfUgw2ypIroJNP+jksQuIkd5vk3lvnfWU=	2024-05-20 11:17:50.536728+00	\N	67	67	\N	Christopher	Olson		{}	{}	DvYvhzYvVzc2	en	staff.manager@example.com\nchristopher\nolson\nchristopher\nolson\n2512 mackenzie dam\n\nnorth antonio\n53500\ntürkiye\ntr\n\n	2024-05-20 11:17:50.762083+00	01f9d07f-e6bd-4b36-96dd-864b2cb87a5c	\N	\N	t	\N
    44	f	translation.manager@example.com	t	t	pbkdf2_sha256$260000$Qz2Rzv813Ry9lQrP8stqKd$NxrkZGGsvkkL2dakou5nZXrqvsCVvVPKkEq18e54jHE=	2024-05-20 11:17:50.821326+00	\N	69	69	\N	Jeffrey	Simpson		{}	{}	6LPW83ybqkqn	en	translation.manager@example.com\njeffrey\nsimpson\njeffrey\nsimpson\n14963 stuart wall apt. 343\n\nkellerstad\n37581\ntürkiye\ntr\n\n	2024-05-20 11:17:51.078858+00	9e2f5b42-33ee-4ca4-9e7d-22edf358686d	\N	\N	t	\N
    45	f	shannon.rhodes@example.com	f	t	pbkdf2_sha256$260000$bIjwmdLN2UeHIKSkK3dVWH$EA4CP4kI1CG5kyBuwwY943jAiihvlo694XqCKG/GoWU=	2006-06-10 21:05:57.801394+00	\N	72	72	Writer work chance image. There many true follow marriage material.	Shannon	Rhodes		{}	{}	br3w1V7j7O2u	en	shannon.rhodes@example.com\nshannon\nrhodes\nshannon\nrhodes\n6430 cindy cove\n\nsouth nicholas\n72117\ntürkiye\ntr\n\n	2024-05-20 11:17:55.858556+00	e4a345f9-a0aa-444f-b0b0-cb4b5e3bf4e5	\N	\N	t	\N
    46	f	james.lynch@example.com	f	t	pbkdf2_sha256$260000$SQCPgtFRBhH7Vp0dG1i3tV$Im0J7EzWQEsQCQj5DpFJn/yhmqugkNHQ5BhEscNjiIQ=	1990-10-15 11:10:02.288854+00	\N	73	73	Son might trip at. American address such former. Song than leave he.	James	Lynch		{}	{}	Ma7JT2QFCldN	en	james.lynch@example.com\njames\nlynch\njames\nlynch\n55508 nancy rapids\n\nport nicholas\n39086\ntürkiye\ntr\n\n	2024-05-20 11:17:56.255778+00	86a16290-8ad7-4f7b-b6e9-512085b75169	\N	\N	t	\N
    47	f	alyssa.johnson@example.com	f	t	pbkdf2_sha256$260000$IX4LIdIukq0GdrG9SGCNZG$q69qvD/7VWuVAJMaocNnBGBF5C3NbsfIe6R32P6aQaw=	1973-01-07 23:02:11.378667+00	\N	74	74	Only surface something prevent a consider medical effort. Management energy stay significant. Special artist political camera expert stop.	Alyssa	Johnson		{}	{}	HXsHoEGihehH	en	alyssa.johnson@example.com\nalyssa\njohnson\nalyssa\njohnson\n891 bullock ford\n\namandachester\n63705\ntürkiye\ntr\n\n	2024-05-20 11:17:56.50409+00	7fd6d280-14fd-4840-911b-430b04053119	\N	\N	t	\N
    48	f	barry.butler@example.com	f	t	pbkdf2_sha256$260000$E1fDr6OaJHJkwRHaH9Jw2H$sJg3y0yRPeeeuzl8/rd47k2qXijyIQnve2jTdIrVk1w=	2012-09-19 12:58:42.688716+00	\N	75	75	Car food record power crime situation since book. Particular level place full. Wide require fast support. Son true their race special million.	Barry	Butler		{}	{}	OGZKyWZwvhOp	en	barry.butler@example.com\nbarry\nbutler\nbarry\nbutler\n125 johnson mountain suite 701\n\nosbornetown\n04756\ntürkiye\ntr\n\n	2024-05-20 11:17:56.782551+00	8b0804ba-6a06-4273-a84e-7806b2632378	\N	\N	t	\N
    49	f	kimberly.hale@example.com	f	t	pbkdf2_sha256$260000$EgAoYOovHECvnYVBgER0Iu$PecdZ+0wXEaXJLy5MPuAydDw82qPx+qlrSIel8IaFys=	1971-05-05 15:14:10.318786+00	\N	77	77	Air try while reveal bad audience. Reality generation concern store discover hand. Throw debate daughter purpose voice but according hard.	Kimberly	Hale		{}	{}	WboZxNCOmFpT	en	kimberly.hale@example.com\nkimberly\nhale\nkimberly\nhale\n412 snow manors apt. 161\n\nsouth kimtown\n59053\ntürkiye\ntr\n\n	2024-05-20 11:17:57.112615+00	9a2257f7-af4a-45e0-ae52-30d699958de0	\N	\N	t	\N
    50	f	cassidy.villarreal@example.com	f	t	pbkdf2_sha256$260000$DzwrACTWsp4bQXCDQ45Usw$R50dZ/9qJgv00XqFnAhkaZXPFAl6cYsDmDIVCQKlP+A=	2008-03-09 12:34:18.007439+00	\N	78	78	Contain year bill ok choose today. Source firm drug senior. Head production technology over hour.	Cassidy	Villarreal		{}	{}	otw3SRIfRMQd	en	cassidy.villarreal@example.com\ncassidy\nvillarreal\ncassidy\nvillarreal\n1754 anthony fords\n\nmatthewport\n39343\ntürkiye\ntr\n\n	2024-05-20 11:17:57.366879+00	276d4733-c385-4776-9554-15931046c50e	\N	\N	t	\N
    51	f	david.evans@example.com	f	t	pbkdf2_sha256$260000$TGZGf5TcMaOsCGQRwIGEht$umCDBdMlKDmilqp8edyzZHEVCbUuWMc/D0G0Xp2DoTs=	2015-02-24 03:10:35.553371+00	\N	79	79	Daughter fall likely wear someone everybody. Painting child reflect up control instead company. Future model green place beat sense far.	David	Evans		{}	{}	46CWVR1DsOug	en	david.evans@example.com\ndavid\nevans\ndavid\nevans\n296 walsh corner apt. 758\n\nsouth rickychester\n95945\ntürkiye\ntr\n\n	2024-05-20 11:17:57.6834+00	b290e154-eb29-4034-962f-e863cf0888b1	\N	\N	t	\N
    52	f	shane.murray@example.com	f	t	pbkdf2_sha256$260000$tXL9n82yi3PqFYC2QWElOK$SATmca9pbYhqMrKhUkKBgSJDNXif4GG8lJw9BulfGQ0=	1998-11-01 07:45:03.616002+00	\N	80	80	Evidence worker building this American either. Three report know second government the pull. Other along society figure future.	Shane	Murray		{}	{}	j3Eh3mcBctUn	en	shane.murray@example.com\nshane\nmurray\nshane\nmurray\n1489 roger terrace\n\ndavisfort\n30957\ntürkiye\ntr\n\n	2024-05-20 11:17:57.986552+00	b3b2417f-8213-4515-ab74-079081e49e24	\N	\N	t	\N
    53	f	scott.carroll@example.com	f	t	pbkdf2_sha256$260000$CxWqMcRTFY9pgpb8D8EltO$e1y6svvyts93iUqYFDFhu3bvdVzaOnumhEQNQlPw4k0=	2010-05-08 18:41:26.133725+00	\N	82	82	Live reason five present art. Central many thought democratic green. Thousand act money at term rather.	Scott	Carroll		{}	{}	yKIiwgSpdkPW	en	scott.carroll@example.com\nscott\ncarroll\nscott\ncarroll\n11669 taylor skyway\n\nmichaelfort\n97801\ntürkiye\ntr\n\n	2024-05-20 11:17:58.317557+00	4a976e61-64a9-412d-9c79-e6ce19d0f549	\N	\N	t	\N
    54	f	elizabeth.smith@example.com	f	t	pbkdf2_sha256$260000$VNtadljEimG8qopwFoEXds$NRSnr0qcMqfyRTB74lVuPsxKr6FK7PC2jwCUoBFAi3M=	1971-10-24 00:59:23.96283+00	\N	83	83	Collection instead today itself language remember. Firm decade cost glass work interview man. Somebody keep daughter report town.	Elizabeth	Smith		{}	{}	CACk5Vls9dbo	en	elizabeth.smith@example.com\nelizabeth\nsmith\nelizabeth\nsmith\n90443 karen heights\n\nnorth ryan\n94393\ntürkiye\ntr\n\n	2024-05-20 11:17:58.604471+00	f6e95395-1203-4ecb-8a94-d62ade77cf01	\N	\N	t	\N
    55	f	cynthia.pitts@example.com	f	t	pbkdf2_sha256$260000$ove4sidCGJvLjGGYPrt2Lc$4IDbK0Vq+r21wyqsAJgcZ12dpyYhWN1CQGZAzhOr7Yo=	1994-10-14 15:58:00.786089+00	\N	84	84	Lawyer effort little front amount apply glass face. Cell skill quite. However TV law fund bill third some follow.	Cynthia	Pitts		{}	{}	YmuhaQTxWj76	en	cynthia.pitts@example.com\ncynthia\npitts\ncynthia\npitts\n23949 janet passage suite 567\n\nlake heatherside\n96762\ntürkiye\ntr\n\n	2024-05-20 11:17:58.921846+00	7e41d25d-93a6-4c09-b714-5d748ec79fa0	\N	\N	t	\N
    56	f	mark.johnson@example.com	f	t	pbkdf2_sha256$260000$T5aiLNMydulH2Hqc0U4cCE$Ycj9RsfaALliP7LKAsR26FmO4MqkRNN/Jqw7ldKNt3Q=	2003-04-29 11:23:31.849429+00	\N	85	85	The drive figure necessary across manager. Answer speak without leave brother bank. Step child this degree.	Mark	Johnson		{}	{}	PzHX2FHEd5rn	en	mark.johnson@example.com\nmark\njohnson\nmark\njohnson\n51385 mary glen\n\nlarryfurt\n33877\ntürkiye\ntr\n\n	2024-05-20 11:17:59.181358+00	b536f70a-571a-4d0e-a833-fb105f0198f8	\N	\N	t	\N
    57	f	willie.murray@example.com	f	t	pbkdf2_sha256$260000$FYlI5r22pTXfF9nZUf8Xye$/C7M5KCvzKbPPcgEsocjstq6x6b9MLgq3kN2rbHF9s0=	2004-03-07 10:10:56.98201+00	\N	87	87	Wife north director respond. Produce develop story drive million push do.	Willie	Murray		{}	{}	OboIb0np1cdb	en	willie.murray@example.com\nwillie\nmurray\nwillie\nmurray\n3019 gerald mall apt. 340\n\ntrevinoville\n50923\ntürkiye\ntr\n\n	2024-05-20 11:17:59.465781+00	91b55619-9569-4284-9c7b-b4342da27c9f	\N	\N	t	\N
    58	f	justin.jackson@example.com	f	t	pbkdf2_sha256$260000$l88oonWjW1YDQGwcgiUfh0$TcC5rDuYOnOstENulIaqMOJAfn3B+gzbm5s+anheaVE=	1977-03-17 17:14:49.134192+00	\N	88	88	Share sit simple notice. Dog car do his part.	Justin	Jackson		{}	{}	Ak9tMyOKXWe2	en	justin.jackson@example.com\njustin\njackson\njustin\njackson\n855 lisa wells\n\nmooreburgh\n67409\ntürkiye\ntr\n\n	2024-05-20 11:17:59.714511+00	012c1dbe-6c9c-43a9-b146-f0fca139bcd0	\N	\N	t	\N
    59	f	vernon.hardin@example.com	f	t	pbkdf2_sha256$260000$FlkY6lv99sxgzsU7lvbIKL$IiW9RWHy76UuaHo6aSdgnFTcHodV7SWfyzy9p2uPLSg=	2009-10-29 07:03:45.268378+00	\N	89	89	Finish summer else page region start size. Want decade firm section economic television. Employee public figure ground much.	Vernon	Hardin		{}	{}	djn9cy070fn2	en	vernon.hardin@example.com\nvernon\nhardin\nvernon\nhardin\n957 parker forges\n\nlake natasha\n97149\ntürkiye\ntr\n\n	2024-05-20 11:17:59.975744+00	013fe2f0-2a9b-469f-8fe9-88ef349a3739	\N	\N	t	\N
    60	f	edward.johnson@example.com	f	t	pbkdf2_sha256$260000$gYhBqeBEk47TYzYXbZhuUC$Nr88Rgvpox1jR+VTFaN+2eEsaKluBN/g3MIo6JDtcDQ=	2006-01-01 03:38:29.921338+00	\N	90	90	Group computer forget would. Him important enough most save rather. Service north but west commercial may perform.	Edward	Johnson		{}	{}	TJoPoxpkNLoa	en	edward.johnson@example.com\nedward\njohnson\nedward\njohnson\n30035 lori key\n\ntaylorborough\n59347\ntürkiye\ntr\n\n	2024-05-20 11:18:00.254909+00	ba903f24-ee7d-4808-87a4-8a99dddc9169	\N	\N	t	\N
    61	f	leslie.arroyo@example.com	t	t	pbkdf2_sha256$260000$hrJHM0W7PWQd5qYYxrPeA1$EWhdKQNzniJi87HpNsNWhWZ04mGLx57RuSs+0FKtn3g=	2024-05-20 11:18:08.12573+00	\N	104	104	\N	Leslie	Arroyo		{}	{}	iyqMGj8T6ByD	en	leslie.arroyo@example.com\nleslie\narroyo\nleslie\narroyo\n793 boyd station\n\nrobertaberg\n62954\ntürkiye\ntr\n\n	2024-05-20 11:18:08.376047+00	a74e94ad-ee26-41c4-afa6-2d01a6478f28	\N	\N	t	\N
    62	f	kelsey.brown@example.com	t	t	pbkdf2_sha256$260000$UtxcwWOJEwF5ckiRa4UM3k$ZwNSdjmW/yuLOyovKdjvkS/kkS5iEgip2QrKTdbwQTg=	2024-05-20 11:18:08.390468+00	\N	105	105	\N	Kelsey	Brown		{}	{}	cWNo5pez7a6w	en	kelsey.brown@example.com\nkelsey\nbrown\nkelsey\nbrown\n501 ronald knoll\n\nrogersfurt\n67662\ntürkiye\ntr\n\n	2024-05-20 11:18:08.673838+00	6f0d22f7-3b3c-4c9e-ab3c-b4f3f6746f2c	\N	\N	t	\N
    94	f	margaret.garcia@example.com	f	t	pbkdf2_sha256$260000$3jpRfeQdiW9ZwZns3xrZRi$G0JWczxJqypzW+S0z0aLKkGmYpqN4UOKrvWv21adD9Y=	1973-08-11 02:56:45.061825+00	\N	146	146	Chance either six success on responsibility southern.	Margaret	Garcia		{}	{}	7NxxOpGswbkz	en	margaret.garcia@example.com\nmargaret\ngarcia\nmargaret\ngarcia\n96687 bass parks apt. 893\n\nwest janicemouth\n42683\ntürkiye\ntr\n\n	2024-05-20 11:19:44.623715+00	bcbe81fe-609e-4caf-83e4-bbf4486e4987	\N	\N	t	\N
    95	f	christopher.melton@example.com	f	t	pbkdf2_sha256$260000$uBIfFsDfqrPPnPBecyMDDk$GHZdUdnqpfvYqr90/UK2CzTsT98rJescsrpJ1JfE4m0=	2018-02-22 05:43:57.128454+00	\N	147	147	Too maybe off question source serious. Section town deal movement. Individual win suddenly win parent do ten after.	Christopher	Melton		{}	{}	ILS64tD9NqeH	en	christopher.melton@example.com\nchristopher\nmelton\nchristopher\nmelton\n32040 rivera estates\n\nport diana\n49170\ntürkiye\ntr\n\n	2024-05-20 11:19:44.893361+00	8754d96d-6815-4028-ae9e-6da29f7fa09f	\N	\N	t	\N
    96	f	joy.turner@example.com	f	t	pbkdf2_sha256$260000$xZN770tpURuTGA859ehb41$cG4GBb6PDefbWug1lq9bwENqaHOYPIUILzjW/0eW3aQ=	1992-05-11 16:07:22.851117+00	\N	148	148	Individual man tell response purpose character would.	Joy	Turner		{}	{}	PJgRWE35CTHV	en	joy.turner@example.com\njoy\nturner\njoy\nturner\n1744 cruz lights apt. 223\n\njessicamouth\n07779\ntürkiye\ntr\n\n	2024-05-20 11:19:45.141561+00	a599ad69-949a-4a68-adc1-cc9aa7ecaa97	\N	\N	t	\N
    97	f	cheryl.hughes@example.com	f	t	pbkdf2_sha256$260000$13jG7j0hZ3zm54EosatuS4$cnvmQQRooc8eKU8piOlWvXygmQZ7YaGcxWk7qCftmMg=	2012-09-19 13:00:08.307034+00	\N	149	149	Red pass value practice wide require fast support. Son true their race special million.	Cheryl	Hughes		{}	{}	mPvibmfAaXfe	en	cheryl.hughes@example.com\ncheryl\nhughes\ncheryl\nhughes\n72009 crystal cove\n\njamesfort\n15049\ntürkiye\ntr\n\n	2024-05-20 11:19:45.368923+00	45aad839-0613-4f8c-802d-0cbc48753e37	\N	\N	t	\N
    98	f	ryan.butler@example.com	f	t	pbkdf2_sha256$260000$E1IlvHyyjiJtOL4afDKHRA$NxmmB5coJYWxWS2/9LxqQ8rZ0BuxKK24D5OPCqWJ2Uw=	1976-02-11 11:25:43.57004+00	\N	152	152	About probably rule too security. Hard agency painting teacher cost.	Ryan	Butler		{}	{}	lSaLLszzhTUl	en	ryan.butler@example.com\nryan\nbutler\nryan\nbutler\n4151 michael burgs suite 520\n\nport michael\n78697\ntürkiye\ntr\n\n	2024-05-20 11:19:45.629953+00	a5be7211-02b3-4d6a-98dd-f020464bd9d7	\N	\N	t	\N
    99	f	maxwell.haley@example.com	f	t	pbkdf2_sha256$260000$0sf4VKySE1IHH34TMAtg4H$tMwvd2F6iDt2zdSj+3S7rJ/e98CijWacFP1JIRwNBA0=	1983-06-29 07:16:28.306604+00	\N	153	153	Film heavy chair by development meet door contain. Information animal car after back available. Federal indicate unit opportunity fear great.	Maxwell	Haley		{}	{}	1RLmZaa16kX7	en	maxwell.haley@example.com\nmaxwell\nhaley\nmaxwell\nhaley\n35574 giles plaza\n\njackland\n13946\ntürkiye\ntr\n\n	2024-05-20 11:19:45.940441+00	684cda4d-3b57-47be-a78b-925b19a72afb	\N	\N	t	\N
    100	f	cynthia.walsh@example.com	f	t	pbkdf2_sha256$260000$kRyi0yIUhVqvGPh9hwCpff$yycnWuRvm5LMwNHv2vqcVvYDpSwM7X6RFlDHn06DDWo=	1989-04-29 19:57:10.227037+00	\N	154	154	Newspaper read somebody land. Control instead company where future model.	Cynthia	Walsh		{}	{}	goL9WQooaK7U	en	cynthia.walsh@example.com\ncynthia\nwalsh\ncynthia\nwalsh\n6065 harris hill\n\ndavisburgh\n14737\ntürkiye\ntr\n\n	2024-05-20 11:19:46.206427+00	0a3847d9-4a0c-4aa2-8082-102b7edcba7e	\N	\N	t	\N
    101	f	crystal.miller@example.com	f	t	pbkdf2_sha256$260000$ZQV6nGtbd1wKpTWaRCdeoz$hNGG1kxG70mpgkjKGcgk+1knMMFcNWvRcofuf2EtB/I=	2011-01-27 08:21:13.311993+00	\N	155	155	Question set discussion seven. Place again establish protect a. Moment ok how bill education exist.	Crystal	Miller		{}	{}	qlwoLyMoSvLU	en	crystal.miller@example.com\ncrystal\nmiller\ncrystal\nmiller\n0797 jeffery crescent\n\namyberg\n56102\ntürkiye\ntr\n\n	2024-05-20 11:19:46.464711+00	a09b3873-1d76-436d-bdbd-464c023db613	\N	\N	t	\N
    102	f	regina.larson@example.com	f	t	pbkdf2_sha256$260000$YgpHiQ1KIKQD9L1O4UnBkz$lIM0e4J3Hkom0X4i0ksSjEH5o7diowjT3cMTCDAkUlw=	1990-09-29 11:30:30.036523+00	\N	156	156	Care mission decision black western myself scientist. Factor head pick church recent.	Regina	Larson		{}	{}	nk6qZFx50SiC	en	regina.larson@example.com\nregina\nlarson\nregina\nlarson\n44851 pamela track\n\nnorth robert\n38471\ntürkiye\ntr\n\n	2024-05-20 11:19:46.715096+00	a638bfea-6592-4475-a88f-2ca02c88d637	\N	\N	t	\N
    103	f	brittany.taylor@example.com	f	t	pbkdf2_sha256$260000$Hu9wg6IHUXeZ8UTTcTQgOM$vK0GGyjgh4lhDzfOh6QkdkORA4HjmliWawPuvSho5k8=	1976-04-26 04:25:05.396085+00	\N	157	157	Green hospital year. Without rather bank we under house guess.	Brittany	Taylor		{}	{}	F4TbN07qRJCL	en	brittany.taylor@example.com\nbrittany\ntaylor\nbrittany\ntaylor\n7637 neal island suite 074\n\nlake tyler\n81915\ntürkiye\ntr\n\n	2024-05-20 11:19:47.003627+00	9fdd66b7-674b-4eb0-a9ce-0aaa5fbed03a	\N	\N	t	\N
    104	f	adam.nelson@example.com	f	t	pbkdf2_sha256$260000$qcixLuGgYo9jTAOnJdjepb$YhdDeUZnyjBE0Vo29BS7adcMMeMprzsjCc8rflEKxPg=	2017-05-15 06:29:19.62865+00	\N	158	158	Model can travel know. Interview man role somebody keep daughter. Town almost plan.	Adam	Nelson		{}	{}	9a2lJAr2n4eR	en	adam.nelson@example.com\nadam\nnelson\nadam\nnelson\n329 lee mews suite 562\n\nrobertchester\n19902\ntürkiye\ntr\n\n	2024-05-20 11:19:47.262758+00	db9b726a-3533-4fec-8be7-7d3af031d186	\N	\N	t	\N
    105	f	michael.paul@example.com	f	t	pbkdf2_sha256$260000$jeAdJFksTcExx9jRNgGuPt$bRD0AM9hwh6a4IZ9EEkbEC7vwXAVRQyLhUw2s31Cw7w=	1975-07-26 19:19:36.576722+00	\N	159	159	Ok majority region democratic entire analysis. Glass face according as. Quite wife however TV law fund.	Michael	Paul		{}	{}	YCdLi8VYchws	en	michael.paul@example.com\nmichael\npaul\nmichael\npaul\n94918 wise knoll\n\nellishaven\n87746\ntürkiye\ntr\n\n	2024-05-20 11:19:47.587145+00	84a98ccb-b8bc-47b1-bd82-115db13a41ad	\N	\N	t	\N
    106	f	nicole.norton@example.com	f	t	pbkdf2_sha256$260000$yqREiBW4e1P7yYH9DeWiHw$2AZhFxgmHsn26eTTg3y4BVL6b/x8B/C3/xPEl9y+Oxw=	2013-12-30 14:27:14.584231+00	\N	160	160	Might his lot the drive. Various authority leave right answer.	Nicole	Norton		{}	{}	CeCMjPLcJbz4	en	nicole.norton@example.com\nnicole\nnorton\nnicole\nnorton\n754 alejandra field suite 138\n\njacobborough\n33436\ntürkiye\ntr\n\n	2024-05-20 11:19:47.832692+00	495078c7-3a75-4683-8c60-c90e68f3f0a1	\N	\N	t	\N
    107	f	tiffany.stevens@example.com	f	t	pbkdf2_sha256$260000$8BgHJ6Tvaa3FULZ1XIvipQ$Jc3bauxch48fGqGr18Uq6x37ato3c7VZ3FUTKEhMFqI=	1997-12-15 12:41:59.363452+00	\N	161	161	Majority campaign that various floor. Blue tonight particular smile represent since.	Tiffany	Stevens		{}	{}	Ltwx23m5Ww2X	en	tiffany.stevens@example.com\ntiffany\nstevens\ntiffany\nstevens\n13126 scott club\n\nhansenfurt\n05658\ntürkiye\ntr\n\n	2024-05-20 11:19:48.112121+00	ce711767-b8e8-4d81-ad6e-e3ff56d116d3	\N	\N	t	\N
    108	f	steven.walters@example.com	f	t	pbkdf2_sha256$260000$nidMv3UoQQbprgC8uKqHxf$j4Oo9OFYFRkv8TnBukup/HU5uSLSbccWrUS68N1olgQ=	2004-07-10 15:22:10.031588+00	\N	162	162	Director respond national example science top. Million push do pick. Old case administration measure happen.	Steven	Walters		{}	{}	P0JM4fYTFl4O	en	steven.walters@example.com\nsteven\nwalters\nsteven\nwalters\n01912 wright haven apt. 886\n\nnorth paulview\n15999\ntürkiye\ntr\n\n	2024-05-20 11:19:48.357287+00	5ee7abe2-d850-4b3e-b67b-b0436fd8d4ae	\N	\N	t	\N
    109	f	lisa.mcdowell@example.com	f	t	pbkdf2_sha256$260000$ZpNyFpiwSXkQGpXLZNCznF$8/4WfgC3bazRUS9FjHTJg+DL3vQToNnO8uX2q2clmRs=	1988-08-30 10:56:23.867907+00	\N	163	163	Pick too blue street. Other majority final when new clear these. National region bad case I course first. Himself arrive although risk which.	Lisa	Mcdowell		{}	{}	krO3QzyXe41f	en	lisa.mcdowell@example.com\nlisa\nmcdowell\nlisa\nmcdowell\n81237 joe curve\n\nport patrick\n80258\ntürkiye\ntr\n\n	2024-05-20 11:19:48.649214+00	564a5798-cc07-4cba-9c38-68a2cf12d434	\N	\N	t	\N
    110	f	christopher.hancock@example.com	t	t	pbkdf2_sha256$260000$yYI8QTvxjEbnknC7EMycbS$akhAx7q7rBNpMbMls+SEt+ci9jiyE8Qas83lQ6YGZu4=	2024-05-20 11:19:56.363562+00	\N	177	177	\N	Christopher	Hancock		{}	{}	kjGXThpFHeVR	en	christopher.hancock@example.com\nchristopher\nhancock\nchristopher\nhancock\n13187 leonard ville apt. 562\n\nrichardberg\n78575\ntürkiye\ntr\n\n	2024-05-20 11:19:56.609871+00	1ae093c5-edc9-4b33-9fbc-cd81eeea23b8	\N	\N	t	\N
    111	f	dylan.delacruz@example.com	t	t	pbkdf2_sha256$260000$ofKDL3WMk3RGHNfw59U9uY$chA8QLxyTIRcO2oa+JjTGBDYeue5VdBwLUNTtXQpVjI=	2024-05-20 11:19:56.626417+00	\N	178	178	\N	Dylan	Delacruz		{}	{}	R7ZnndZxxTZJ	en	dylan.delacruz@example.com\ndylan\ndelacruz\ndylan\ndelacruz\n22708 madison spurs\n\nherringstad\n77293\ntürkiye\ntr\n\n	2024-05-20 11:19:56.850378+00	9642a7a1-f9ec-4c97-95a5-6e0e1b6c8451	\N	\N	t	\N
    \.


    --
    -- Data for Name: account_user_addresses; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.account_user_addresses (id, user_id, address_id) FROM stdin;
    1	1	9
    2	2	10
    3	3	11
    4	4	12
    5	5	13
    6	6	14
    7	7	15
    8	8	16
    9	9	17
    10	10	18
    11	11	19
    12	12	20
    13	13	21
    14	14	22
    15	15	23
    16	16	24
    17	17	25
    18	18	26
    19	19	27
    20	20	28
    21	21	37
    22	22	38
    23	23	44
    24	24	47
    25	25	48
    26	26	49
    27	27	50
    28	28	51
    29	29	52
    30	30	54
    31	31	55
    32	32	56
    33	33	57
    34	34	58
    35	35	59
    36	36	60
    37	37	61
    38	38	62
    39	39	63
    40	40	64
    41	41	65
    42	42	66
    43	43	67
    44	44	69
    45	45	72
    46	46	73
    47	47	74
    48	48	75
    49	49	77
    50	50	78
    51	51	79
    52	52	80
    53	53	82
    54	54	83
    55	55	84
    56	56	85
    57	57	87
    58	58	88
    59	59	89
    60	60	90
    61	21	103
    62	61	104
    63	62	105
    95	94	146
    96	95	147
    97	96	148
    98	97	149
    99	98	152
    100	99	153
    101	100	154
    102	101	155
    103	102	156
    104	103	157
    105	104	158
    106	105	159
    107	106	160
    108	107	161
    109	108	162
    110	109	163
    111	21	176
    112	110	177
    113	111	178
    \.


    --
    -- Data for Name: account_user_groups; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.account_user_groups (id, user_id, group_id) FROM stdin;
    1	21	1
    2	22	2
    3	23	2
    4	24	3
    5	25	4
    6	26	5
    7	27	6
    8	28	7
    9	29	8
    11	30	9
    12	31	10
    13	32	11
    14	33	12
    15	34	13
    16	35	14
    17	36	15
    18	37	16
    19	38	17
    20	39	18
    21	40	19
    22	41	20
    23	42	21
    24	43	22
    26	44	23
    27	27	24
    29	61	2
    30	62	2
    32	110	2
    33	111	2
    \.


    --
    -- Data for Name: account_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.account_user_user_permissions (id, user_id, permission_id) FROM stdin;
    \.


    --
    -- Data for Name: app_app; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.app_app (id, private_metadata, metadata, name, created_at, is_active, about_app, app_url, configuration_url, data_privacy, data_privacy_url, homepage_url, identifier, support_url, type, version, manifest_url, audience, is_installed, author, uuid, brand_logo_default, removed_at) FROM stdin;
    \.


    --
    -- Data for Name: app_app_permissions; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.app_app_permissions (id, app_id, permission_id) FROM stdin;
    \.


    --
    -- Data for Name: app_appextension; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.app_appextension (id, label, url, app_id, mount, target) FROM stdin;
    \.


    --
    -- Data for Name: app_appextension_permissions; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.app_appextension_permissions (id, appextension_id, permission_id) FROM stdin;
    \.


    --
    -- Data for Name: app_appinstallation; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.app_appinstallation (id, status, message, created_at, updated_at, app_name, manifest_url, uuid, brand_logo_default) FROM stdin;
    \.


    --
    -- Data for Name: app_appinstallation_permissions; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.app_appinstallation_permissions (id, appinstallation_id, permission_id) FROM stdin;
    \.


    --
    -- Data for Name: app_apptoken; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.app_apptoken (id, name, auth_token, app_id, token_last_4) FROM stdin;
    \.


    --
    -- Data for Name: attribute_assignedpageattributevalue; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.attribute_assignedpageattributevalue (id, sort_order, value_id, page_id) FROM stdin;
    \.


    --
    -- Data for Name: attribute_assignedproductattributevalue; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.attribute_assignedproductattributevalue (id, sort_order, value_id, product_id) FROM stdin;
    193	0	138	126
    194	0	105	131
    195	0	107	132
    196	0	105	133
    197	0	105	134
    198	0	106	135
    199	0	105	136
    200	0	105	137
    201	0	105	138
    204	0	105	141
    206	0	140	143
    207	0	141	146
    208	0	141	147
    210	0	129	152
    211	0	123	153
    212	0	122	154
    213	0	124	155
    214	0	105	161
    \.


    --
    -- Data for Name: attribute_assignedvariantattribute; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.attribute_assignedvariantattribute (id, variant_id, assignment_id) FROM stdin;
    136	324	13
    137	325	14
    138	326	14
    139	327	14
    140	328	14
    141	329	14
    142	330	14
    143	331	14
    144	332	14
    145	333	14
    146	334	14
    147	335	14
    148	336	14
    149	337	14
    150	338	14
    151	339	14
    152	340	14
    153	341	14
    154	342	14
    155	343	14
    156	344	14
    157	348	15
    158	349	15
    159	350	15
    160	351	15
    161	352	15
    162	353	15
    163	354	15
    164	355	15
    165	356	15
    166	357	15
    167	358	15
    168	359	15
    169	360	15
    170	361	15
    171	362	15
    172	363	15
    173	364	15
    174	365	15
    175	366	15
    176	372	13
    177	373	13
    178	374	13
    179	375	13
    180	376	13
    181	377	13
    182	378	13
    183	379	13
    184	380	13
    185	389	15
    186	390	15
    187	394	15
    188	395	15
    189	396	15
    190	397	15
    191	398	15
    \.


    --
    -- Data for Name: attribute_assignedvariantattributevalue; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.attribute_assignedvariantattributevalue (id, sort_order, assignment_id, value_id) FROM stdin;
    676	0	136	137
    677	0	137	108
    678	0	138	109
    679	0	139	110
    680	0	140	111
    681	0	141	112
    682	0	142	113
    683	0	143	114
    684	0	144	110
    685	0	145	109
    686	0	146	111
    687	0	147	108
    688	0	148	109
    689	0	149	110
    690	0	150	111
    691	0	151	112
    692	0	152	108
    693	0	153	109
    694	0	154	110
    695	0	155	111
    696	0	156	114
    697	0	157	115
    698	0	158	116
    699	0	159	117
    700	0	160	118
    701	0	161	119
    702	0	162	115
    703	0	163	116
    704	0	164	117
    705	0	165	118
    706	0	166	119
    707	0	167	115
    708	0	168	116
    709	0	169	119
    710	0	170	116
    711	0	171	117
    712	0	172	118
    713	0	173	115
    714	0	174	116
    715	0	175	117
    716	0	176	133
    717	0	177	135
    718	0	178	137
    719	0	179	132
    720	0	180	133
    721	0	181	135
    722	0	182	136
    723	0	183	135
    724	0	184	137
    725	0	185	118
    726	0	186	119
    727	0	187	115
    728	0	188	116
    729	0	189	117
    730	0	190	118
    731	0	191	119
    \.


    --
    -- Data for Name: attribute_attribute; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.attribute_attribute (id, slug, name, metadata, private_metadata, input_type, available_in_grid, visible_in_storefront, filterable_in_dashboard, filterable_in_storefront, value_required, storefront_search_position, is_variant_only, type, entity_type, unit, external_reference, max_sort_order) FROM stdin;
    36	material	Material	{}	{}	dropdown	t	t	t	t	t	0	f	product-type	\N	\N	\N	\N
    37	shoe-size	Shoe size	{}	{}	dropdown	t	t	t	t	f	0	f	product-type	\N	\N	\N	\N
    38	size	Size	{}	{}	dropdown	t	t	t	t	f	0	f	product-type	\N	\N	\N	\N
    39	volume	Volume	{}	{}	dropdown	t	t	t	t	f	0	f	product-type	\N	\N	\N	\N
    40	flavor	Flavor	{}	{}	dropdown	t	t	t	t	f	0	f	product-type	\N	\N	\N	\N
    41	ebook-format	EBook Format	{}	{}	dropdown	t	t	t	t	t	0	f	product-type	\N	\N	\N	\N
    42	medium	Medium	{}	{}	dropdown	t	t	t	t	t	0	f	product-type	\N	\N	\N	\N
    43	publisher	Publisher	{}	{}	dropdown	t	t	t	t	t	0	f	product-type	\N	\N	\N	\N
    \.


    --
    -- Data for Name: attribute_attributepage; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.attribute_attributepage (id, sort_order, attribute_id, page_type_id) FROM stdin;
    \.


    --
    -- Data for Name: attribute_attributeproduct; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.attribute_attributeproduct (id, attribute_id, product_type_id, sort_order) FROM stdin;
    10	43	17	0
    11	36	19	0
    12	36	20	0
    13	36	21	0
    14	40	23	0
    \.


    --
    -- Data for Name: attribute_attributetranslation; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.attribute_attributetranslation (id, language_code, name, attribute_id) FROM stdin;
    \.


    --
    -- Data for Name: attribute_attributevalue; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.attribute_attributevalue (id, name, attribute_id, slug, sort_order, value, content_type, file_url, rich_text, "boolean", date_time, reference_page_id, reference_product_id, plain_text, reference_variant_id, external_reference) FROM stdin;
    131	MOBI	41	mobi	1		\N	\N	null	\N	\N	\N	\N	\N	\N	\N
    132	Vinyl	42	vinyl	0		\N	\N	null	\N	\N	\N	\N	\N	\N	\N
    133	DVD	42	dvd	1		\N	\N	null	\N	\N	\N	\N	\N	\N	\N
    134	VHS	42	vhs	2		\N	\N	null	\N	\N	\N	\N	\N	\N	\N
    135	iTunes	42	itunes	3		\N	\N	null	\N	\N	\N	\N	\N	\N	\N
    136	CD	42	cd	4		\N	\N	null	\N	\N	\N	\N	\N	\N	\N
    137	MP3	42	mp3	5		\N	\N	null	\N	\N	\N	\N	\N	\N	\N
    138	Digital Audio	43	digital-audio	0		\N	\N	null	\N	\N	\N	\N	\N	\N	\N
    140	Wool	36	wool	3		\N	\N	null	\N	\N	\N	\N	\N	\N	\N
    141	Saleor Publishing	43	saleor-publishing	1		\N	\N	null	\N	\N	\N	\N	\N	\N	\N
    105	Cotton	36	cotton	0		\N	\N	null	\N	\N	\N	\N	\N	\N	\N
    106	Elastane	36	elastane	1		\N	\N	null	\N	\N	\N	\N	\N	\N	\N
    107	Polyester	36	polyester	2		\N	\N	null	\N	\N	\N	\N	\N	\N	\N
    108	39	37	39	0		\N	\N	null	\N	\N	\N	\N	\N	\N	\N
    109	40	37	40	1		\N	\N	null	\N	\N	\N	\N	\N	\N	\N
    110	41	37	41	2		\N	\N	null	\N	\N	\N	\N	\N	\N	\N
    111	42	37	42	3		\N	\N	null	\N	\N	\N	\N	\N	\N	\N
    112	43	37	43	4		\N	\N	null	\N	\N	\N	\N	\N	\N	\N
    113	44	37	44	5		\N	\N	null	\N	\N	\N	\N	\N	\N	\N
    114	45	37	45	6		\N	\N	null	\N	\N	\N	\N	\N	\N	\N
    115	S	38	s	0		\N	\N	null	\N	\N	\N	\N	\N	\N	\N
    116	M	38	m	1		\N	\N	null	\N	\N	\N	\N	\N	\N	\N
    117	L	38	l	2		\N	\N	null	\N	\N	\N	\N	\N	\N	\N
    118	XL	38	xl	3		\N	\N	null	\N	\N	\N	\N	\N	\N	\N
    119	XXL	38	xxl	4		\N	\N	null	\N	\N	\N	\N	\N	\N	\N
    120	700ml	39	700ml	0		\N	\N	null	\N	\N	\N	\N	\N	\N	\N
    121	Orange	40	orange	0		\N	\N	null	\N	\N	\N	\N	\N	\N	\N
    122	Banana	40	banana	1		\N	\N	null	\N	\N	\N	\N	\N	\N	\N
    123	Bean	40	bean	2		\N	\N	null	\N	\N	\N	\N	\N	\N	\N
    124	Carrot	40	carrot	3		\N	\N	null	\N	\N	\N	\N	\N	\N	\N
    125	Sprouty	40	sprouty	4		\N	\N	null	\N	\N	\N	\N	\N	\N	\N
    126	Salty, like the tears of your enemy	40	salty-like-the-tears-of-your-enemy	5		\N	\N	null	\N	\N	\N	\N	\N	\N	\N
    127	Pineapple	40	pineapple	6		\N	\N	null	\N	\N	\N	\N	\N	\N	\N
    128	Coconut	40	coconut	7		\N	\N	null	\N	\N	\N	\N	\N	\N	\N
    129	Apple	40	apple	8		\N	\N	null	\N	\N	\N	\N	\N	\N	\N
    130	EPUB	41	epub	0		\N	\N	null	\N	\N	\N	\N	\N	\N	\N
    \.


    --
    -- Data for Name: attribute_attributevaluetranslation; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.attribute_attributevaluetranslation (id, language_code, name, attribute_value_id, rich_text, plain_text) FROM stdin;
    \.


    --
    -- Data for Name: attribute_attributevariant; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.attribute_attributevariant (id, attribute_id, product_type_id, sort_order, variant_selection) FROM stdin;
    13	42	17	0	t
    14	37	18	0	t
    15	38	20	0	t
    \.


    --
    -- Data for Name: channel_channel; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.channel_channel (id, name, slug, is_active, currency_code, default_country, allocation_strategy, automatically_confirm_all_new_orders, automatically_fulfill_non_shippable_gift_card, order_mark_as_paid_strategy, default_transaction_flow_strategy, expire_orders_after, delete_expired_orders_after, metadata, private_metadata, allow_unpaid_orders, use_legacy_error_flow_for_checkout, include_draft_order_in_voucher_usage) FROM stdin;
    1	Default Channel	default-channel	t	USD	US	prioritize-high-stock	t	t	payment_flow	charge	\N	60 days	{}	{}	f	t	f
    34	Channel-USD	tr	t	USD	TR	prioritize-sorting-order	t	t	payment_flow	charge	\N	60 days	{}	{}	f	t	f
    35	Channel-PLN	channel-pln	t	PLN	PL	prioritize-sorting-order	t	t	payment_flow	charge	\N	60 days	{}	{}	f	t	f
    \.


    --
    -- Data for Name: checkout_checkout; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.checkout_checkout (created_at, last_change, email, token, user_id, billing_address_id, discount_amount, discount_name, note, shipping_address_id, shipping_method_id, voucher_code, translated_discount_name, metadata, private_metadata, currency, country, redirect_url, tracking_code, channel_id, language_code, collection_point_id, price_expiration, shipping_price_gross_amount, shipping_price_net_amount, shipping_tax_rate, subtotal_gross_amount, subtotal_net_amount, total_gross_amount, total_net_amount, tax_exemption, authorize_status, charge_status, last_transaction_modified_at, automatically_refundable, base_subtotal_amount, base_total_amount, tax_error, is_voucher_usage_increased, completing_started_at) FROM stdin;
    2024-05-20 11:17:43.178511+00	2024-05-20 11:17:43.17859+00	\N	7fc5aeb5-c63f-45a2-ad4b-cab68471b02f	\N	\N	0.000	\N		\N	\N	\N	\N	\N	\N	USD	TR	\N	\N	34	en	\N	2024-05-20 11:17:43.177565+00	0.000	0.000	0.0000	0.000	0.000	0.000	0.000	f	none	none	\N	f	0.000	0.000	\N	f	\N
    2024-05-20 11:17:43.290809+00	2024-05-20 11:17:43.29084+00	\N	cd44a260-e340-4b86-b019-55afdb998f47	\N	\N	0.000	\N		\N	\N	\N	\N	\N	\N	USD	TR	\N	\N	34	en	\N	2024-05-20 11:17:43.290427+00	0.000	0.000	0.0000	0.000	0.000	0.000	0.000	f	none	none	\N	f	0.000	0.000	\N	f	\N
    2024-05-20 11:17:43.358127+00	2024-05-20 11:17:43.358167+00	\N	c7a8827c-0eca-4347-b6a2-b427f6b4473b	\N	\N	0.000	\N		\N	\N	\N	\N	\N	\N	USD	TR	\N	\N	34	en	\N	2024-05-20 11:17:43.357702+00	0.000	0.000	0.0000	0.000	0.000	0.000	0.000	f	none	none	\N	f	0.000	0.000	\N	f	\N
    2024-05-20 11:18:07.531314+00	2024-05-20 11:18:07.53135+00	\N	8e6eb82e-576e-46cf-8b8f-28637769c786	\N	\N	0.000	\N		\N	\N	\N	\N	\N	\N	USD	TR	\N	\N	34	en	\N	2024-05-20 11:18:07.530597+00	0.000	0.000	0.0000	0.000	0.000	0.000	0.000	f	none	none	\N	f	0.000	0.000	\N	f	\N
    2024-05-20 11:18:07.622023+00	2024-05-20 11:18:07.622081+00	\N	8d04d0e9-54f8-4c77-a26f-803d5c3b3ed6	\N	\N	0.000	\N		\N	\N	\N	\N	\N	\N	USD	TR	\N	\N	34	en	\N	2024-05-20 11:18:07.621623+00	0.000	0.000	0.0000	0.000	0.000	0.000	0.000	f	none	none	\N	f	0.000	0.000	\N	f	\N
    2024-05-20 11:18:07.689399+00	2024-05-20 11:18:07.689451+00	\N	17062015-d043-42b9-b3dd-54380fa98009	\N	\N	0.000	\N		\N	\N	\N	\N	\N	\N	USD	TR	\N	\N	34	en	\N	2024-05-20 11:18:07.68877+00	0.000	0.000	0.0000	0.000	0.000	0.000	0.000	f	none	none	\N	f	0.000	0.000	\N	f	\N
    2024-05-20 11:19:55.688558+00	2024-05-20 11:19:55.688588+00	\N	9d82fb9a-4643-4543-8dff-ef327c92e1fd	\N	\N	0.000	\N		\N	\N	\N	\N	\N	\N	USD	TR	\N	\N	34	en	\N	2024-05-20 11:19:55.68799+00	0.000	0.000	0.0000	0.000	0.000	0.000	0.000	f	none	none	\N	f	0.000	0.000	\N	f	\N
    2024-05-20 11:19:55.790843+00	2024-05-20 11:19:55.790881+00	\N	f5a13669-1ed0-4c95-b6fb-c3851c0ae5a2	\N	\N	0.000	\N		\N	\N	\N	\N	\N	\N	USD	TR	\N	\N	34	en	\N	2024-05-20 11:19:55.790335+00	0.000	0.000	0.0000	0.000	0.000	0.000	0.000	f	none	none	\N	f	0.000	0.000	\N	f	\N
    2024-05-20 11:19:55.87006+00	2024-05-20 11:19:55.870132+00	\N	9b7a278e-a941-451a-9525-94054c1fd152	\N	\N	0.000	\N		\N	\N	\N	\N	\N	\N	USD	TR	\N	\N	34	en	\N	2024-05-20 11:19:55.869236+00	0.000	0.000	0.0000	0.000	0.000	0.000	0.000	f	none	none	\N	f	0.000	0.000	\N	f	\N
    \.


    --
    -- Data for Name: checkout_checkout_gift_cards; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.checkout_checkout_gift_cards (id, checkout_id, giftcard_id) FROM stdin;
    \.


    --
    -- Data for Name: checkout_checkoutline; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.checkout_checkoutline (quantity, checkout_id, variant_id, price_override, created_at, old_id, id, metadata, private_metadata, currency, tax_rate, total_price_gross_amount, total_price_net_amount, is_gift) FROM stdin;
    2	7fc5aeb5-c63f-45a2-ad4b-cab68471b02f	358	\N	2024-05-20 11:17:43.255898+00	\N	cbfdbc31-e607-4bbf-9955-c5e681e5ef2c	{}	{}	USD	0.0000	0.000	0.000	f
    2	7fc5aeb5-c63f-45a2-ad4b-cab68471b02f	364	\N	2024-05-20 11:17:43.283699+00	\N	32dbeb62-26da-4de6-b3ad-e4a329596f6a	{}	{}	USD	0.0000	0.000	0.000	f
    2	cd44a260-e340-4b86-b019-55afdb998f47	358	20.000	2024-05-20 11:17:43.323478+00	\N	ec004fd5-028d-4e52-b7b4-370c0e2c1da9	{}	{}	USD	0.0000	0.000	0.000	f
    2	cd44a260-e340-4b86-b019-55afdb998f47	364	20.000	2024-05-20 11:17:43.347684+00	\N	24a16d37-b348-45db-a525-0224bc01ec70	{}	{}	USD	0.0000	0.000	0.000	f
    2	c7a8827c-0eca-4347-b6a2-b427f6b4473b	358	\N	2024-05-20 11:17:43.393024+00	\N	d91f9332-10fe-4d04-8b2b-8a8f1186d0ee	{}	{}	USD	0.0000	0.000	0.000	f
    2	c7a8827c-0eca-4347-b6a2-b427f6b4473b	358	\N	2024-05-20 11:17:43.405872+00	\N	546e2d35-5616-4a9d-b0fe-35fb1e436ef0	{}	{}		0.0000	0.000	0.000	f
    2	c7a8827c-0eca-4347-b6a2-b427f6b4473b	364	\N	2024-05-20 11:17:43.421494+00	\N	af4ab7d1-401d-473d-96a9-3cd1bb634e52	{}	{}	USD	0.0000	0.000	0.000	f
    2	c7a8827c-0eca-4347-b6a2-b427f6b4473b	364	\N	2024-05-20 11:17:43.440882+00	\N	1367de78-dd45-49c2-b394-c5ceb1d3280b	{}	{}		0.0000	0.000	0.000	f
    2	8e6eb82e-576e-46cf-8b8f-28637769c786	358	\N	2024-05-20 11:18:07.591415+00	\N	b38a1e0f-d3df-4606-beba-6baae23d2519	{}	{}	USD	0.0000	0.000	0.000	f
    2	8e6eb82e-576e-46cf-8b8f-28637769c786	364	\N	2024-05-20 11:18:07.614936+00	\N	4ca6d3ce-8537-4a52-9783-442ffe518a1e	{}	{}	USD	0.0000	0.000	0.000	f
    2	8d04d0e9-54f8-4c77-a26f-803d5c3b3ed6	358	20.000	2024-05-20 11:18:07.65528+00	\N	0b4bcab8-60ca-49bf-b4e8-b1eff2846906	{}	{}	USD	0.0000	0.000	0.000	f
    2	8d04d0e9-54f8-4c77-a26f-803d5c3b3ed6	364	20.000	2024-05-20 11:18:07.675049+00	\N	5c6e28f4-c0fe-4dbd-84ee-f0c93bde6b70	{}	{}	USD	0.0000	0.000	0.000	f
    2	17062015-d043-42b9-b3dd-54380fa98009	358	\N	2024-05-20 11:18:07.727667+00	\N	5c10317d-6259-49c5-90ec-3f17767e8b77	{}	{}	USD	0.0000	0.000	0.000	f
    2	17062015-d043-42b9-b3dd-54380fa98009	358	\N	2024-05-20 11:18:07.745116+00	\N	047fbac5-83bc-43fe-8beb-cf572e66db12	{}	{}		0.0000	0.000	0.000	f
    2	17062015-d043-42b9-b3dd-54380fa98009	364	\N	2024-05-20 11:18:07.7683+00	\N	a1b34fd3-5fed-4179-bf45-1fc504f8634d	{}	{}	USD	0.0000	0.000	0.000	f
    2	17062015-d043-42b9-b3dd-54380fa98009	364	\N	2024-05-20 11:18:07.785926+00	\N	3f1456f0-381e-4dcc-a787-e8fbec76a827	{}	{}		0.0000	0.000	0.000	f
    2	9d82fb9a-4643-4543-8dff-ef327c92e1fd	358	\N	2024-05-20 11:19:55.751672+00	\N	74357701-ebe7-436e-bd9f-fe29af2df06a	{}	{}	USD	0.0000	0.000	0.000	f
    2	9d82fb9a-4643-4543-8dff-ef327c92e1fd	364	\N	2024-05-20 11:19:55.782991+00	\N	7784f2c8-438d-4c97-b5d1-bf84203258b3	{}	{}	USD	0.0000	0.000	0.000	f
    2	f5a13669-1ed0-4c95-b6fb-c3851c0ae5a2	358	20.000	2024-05-20 11:19:55.830315+00	\N	784401db-18e6-494c-bc19-fa0e3169036e	{}	{}	USD	0.0000	0.000	0.000	f
    2	f5a13669-1ed0-4c95-b6fb-c3851c0ae5a2	364	20.000	2024-05-20 11:19:55.854131+00	\N	ccd5ec05-c44e-4ba4-aa9c-dee7fb3b77b9	{}	{}	USD	0.0000	0.000	0.000	f
    2	9b7a278e-a941-451a-9525-94054c1fd152	358	\N	2024-05-20 11:19:55.918953+00	\N	221fb45d-ca57-4496-8721-ce82b9df274a	{}	{}	USD	0.0000	0.000	0.000	f
    2	9b7a278e-a941-451a-9525-94054c1fd152	358	\N	2024-05-20 11:19:55.939074+00	\N	750d82ce-ddeb-4391-9bac-e132c3734b26	{}	{}		0.0000	0.000	0.000	f
    2	9b7a278e-a941-451a-9525-94054c1fd152	364	\N	2024-05-20 11:19:55.960364+00	\N	6615344b-757f-4b2e-a9c4-97cac7b0fdb6	{}	{}	USD	0.0000	0.000	0.000	f
    2	9b7a278e-a941-451a-9525-94054c1fd152	364	\N	2024-05-20 11:19:55.984323+00	\N	6e476161-f8c0-43b3-bb4b-a842b5e01e48	{}	{}		0.0000	0.000	0.000	f
    \.


    --
    -- Data for Name: checkout_checkoutmetadata; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.checkout_checkoutmetadata (id, private_metadata, metadata, checkout_id) FROM stdin;
    \.


    --
    -- Data for Name: core_eventdelivery; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.core_eventdelivery (id, created_at, status, event_type, payload_id, webhook_id) FROM stdin;
    \.


    --
    -- Data for Name: core_eventdeliveryattempt; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.core_eventdeliveryattempt (id, created_at, task_id, duration, response, response_headers, request_headers, status, delivery_id, response_status_code) FROM stdin;
    \.


    --
    -- Data for Name: core_eventpayload; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.core_eventpayload (id, payload, created_at) FROM stdin;
    \.


    --
    -- Data for Name: csv_exportevent; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.csv_exportevent (id, date, type, parameters, app_id, export_file_id, user_id) FROM stdin;
    \.


    --
    -- Data for Name: csv_exportfile; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.csv_exportfile (id, status, created_at, updated_at, content_file, app_id, user_id, message) FROM stdin;
    \.


    --
    -- Data for Name: discount_checkoutdiscount; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.discount_checkoutdiscount (id, created_at, type, value_type, value, amount_value, currency, name, translated_name, reason, voucher_code, checkout_id, promotion_rule_id, voucher_id) FROM stdin;
    \.


    --
    -- Data for Name: discount_checkoutlinediscount; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.discount_checkoutlinediscount (id, created_at, type, value_type, value, amount_value, currency, name, translated_name, reason, line_id, sale_id, voucher_id, promotion_rule_id, voucher_code, unique_type) FROM stdin;
    \.


    --
    -- Data for Name: discount_orderdiscount; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.discount_orderdiscount (type, value_type, value, amount_value, currency, name, translated_name, reason, order_id, created_at, old_id, id, sale_id, voucher_id, promotion_rule_id, voucher_code) FROM stdin;
    \.


    --
    -- Data for Name: discount_orderlinediscount; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.discount_orderlinediscount (id, created_at, type, value_type, value, amount_value, currency, name, translated_name, reason, line_id, promotion_rule_id, sale_id, voucher_id, voucher_code, unique_type) FROM stdin;
    \.


    --
    -- Data for Name: discount_promotion; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.discount_promotion (id, private_metadata, metadata, name, description, old_sale_id, start_date, end_date, created_at, updated_at, last_notification_scheduled_at, type) FROM stdin;
    19b446cd-8182-4f57-a99a-499372ed05e1	{}	{}	Happy indeed day!	null	\N	2024-05-20 11:17:28.991158+00	\N	2024-05-20 11:17:28.992172+00	2024-05-20 11:17:28.992204+00	\N	catalogue
    c025c12c-3f68-4707-af5e-eb34a1ea48da	{}	{}	Happy only day!	null	\N	2024-05-20 11:17:29.039019+00	\N	2024-05-20 11:17:29.040162+00	2024-05-20 11:17:29.040194+00	\N	catalogue
    496d17ff-85b1-451c-8185-c95082f33662	{}	{}	Happy natural day!	null	\N	2024-05-20 11:17:29.564248+00	\N	2024-05-20 11:17:29.564681+00	2024-05-20 11:17:29.564701+00	\N	catalogue
    67162425-043b-4d70-af30-640e1269f875	{}	{}	Happy figure day!	null	\N	2024-05-20 11:17:29.583642+00	\N	2024-05-20 11:17:29.584396+00	2024-05-20 11:17:29.584426+00	\N	catalogue
    549c7032-dcf8-41c1-8510-5cc592a22382	{}	{}	Happy indeed day!	null	\N	2024-05-20 11:17:54.837981+00	\N	2024-05-20 11:17:54.839114+00	2024-05-20 11:17:54.839145+00	\N	catalogue
    5fdfd7c0-cf7f-4a4d-946b-dba173497ebb	{}	{}	Happy only day!	null	\N	2024-05-20 11:17:54.875859+00	\N	2024-05-20 11:17:54.876617+00	2024-05-20 11:17:54.876649+00	\N	catalogue
    a0780243-dedd-4421-bb75-4755ef9c9d4b	{}	{}	Happy natural day!	null	\N	2024-05-20 11:17:55.432819+00	\N	2024-05-20 11:17:55.433292+00	2024-05-20 11:17:55.433306+00	\N	catalogue
    df51e77b-eaf9-471c-bff9-e383b06a12eb	{}	{}	Happy figure day!	null	\N	2024-05-20 11:17:55.456825+00	\N	2024-05-20 11:17:55.457678+00	2024-05-20 11:17:55.457724+00	\N	catalogue
    351015cb-eba6-4f46-9a34-4798bfa74f70	{}	{}	Happy indeed day!	null	\N	2024-05-20 11:19:43.547085+00	\N	2024-05-20 11:19:43.547678+00	2024-05-20 11:19:43.547694+00	\N	catalogue
    5a0243d4-8708-431f-aa90-1e4524a8e473	{}	{}	Happy only day!	null	\N	2024-05-20 11:19:43.584109+00	\N	2024-05-20 11:19:43.584614+00	2024-05-20 11:19:43.584632+00	\N	catalogue
    1578f2b4-f171-4b28-8293-8f27003ce7aa	{}	{}	Happy natural day!	null	\N	2024-05-20 11:19:44.186583+00	\N	2024-05-20 11:19:44.187409+00	2024-05-20 11:19:44.187437+00	\N	catalogue
    7db72cca-b058-478d-aa61-4751c9615ce9	{}	{}	Happy figure day!	null	\N	2024-05-20 11:19:44.212716+00	\N	2024-05-20 11:19:44.21355+00	2024-05-20 11:19:44.213581+00	\N	catalogue
    \.


    --
    -- Data for Name: discount_promotionevent; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.discount_promotionevent (id, date, type, parameters, app_id, promotion_id, user_id) FROM stdin;
    \.


    --
    -- Data for Name: discount_promotionrule; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.discount_promotionrule (id, name, description, catalogue_predicate, reward_value_type, reward_value, promotion_id, old_channel_listing_id, order_predicate, reward_type, variants_dirty) FROM stdin;
    f1ef4f5c-a8f5-4689-8079-137cfd2a356e	\N	null	{"productPredicate": {"ids": ["UHJvZHVjdDoxNDU=", "UHJvZHVjdDoxMzQ="]}}	percentage	50.000	19b446cd-8182-4f57-a99a-499372ed05e1	\N	{}	\N	f
    a7f7e186-6f93-48ed-a6bd-244740020041	\N	null	{"variantPredicate": {"ids": ["UHJvZHVjdFZhcmlhbnQ6MzQy", "UHJvZHVjdFZhcmlhbnQ6Mzk4"]}}	percentage	50.000	19b446cd-8182-4f57-a99a-499372ed05e1	\N	{}	\N	f
    0114c879-f9ef-4edc-bd69-2438cef5e28a	\N	null	{"productPredicate": {"ids": ["UHJvZHVjdDoxMzY=", "UHJvZHVjdDoxNDc="]}}	percentage	50.000	c025c12c-3f68-4707-af5e-eb34a1ea48da	\N	{}	\N	f
    52f87276-5e4b-4b93-9ce6-5cd8a12bab4a	\N	null	{"variantPredicate": {"ids": ["UHJvZHVjdFZhcmlhbnQ6MzU2", "UHJvZHVjdFZhcmlhbnQ6Mzg2"]}}	percentage	50.000	c025c12c-3f68-4707-af5e-eb34a1ea48da	\N	{}	\N	f
    04ea9801-9c80-4c76-b811-0ce6872a2df6	\N	null	{}	percentage	10.000	496d17ff-85b1-451c-8185-c95082f33662	\N	{"discountedObjectPredicate": {"baseSubtotalPrice": {"range": {"gte": "200"}}}}	SUBTOTAL_DISCOUNT	f
    91feb7d6-177c-446f-a07d-5fbb948afe89	\N	null	{}	fixed	30.000	496d17ff-85b1-451c-8185-c95082f33662	\N	{"discountedObjectPredicate": {"baseSubtotalPrice": {"range": {"gte": "100"}}}}	SUBTOTAL_DISCOUNT	f
    5cd874ac-b3ef-4152-8e1f-f3ccf2085d68	\N	null	{}	percentage	20.000	67162425-043b-4d70-af30-640e1269f875	\N	{"discountedObjectPredicate": {"baseSubtotalPrice": {"range": {"gte": "200"}}}}	SUBTOTAL_DISCOUNT	f
    46dd357a-bc8a-4670-8f9b-993281b2d9c5	\N	null	{}	fixed	30.000	67162425-043b-4d70-af30-640e1269f875	\N	{"discountedObjectPredicate": {"baseSubtotalPrice": {"range": {"gte": "100"}}}}	SUBTOTAL_DISCOUNT	f
    251d79da-15aa-4c84-9d71-677dbe2f23cf	\N	null	{"productPredicate": {"ids": ["UHJvZHVjdDoxMjg=", "UHJvZHVjdDoxMzQ="]}}	percentage	20.000	549c7032-dcf8-41c1-8510-5cc592a22382	\N	{}	\N	f
    0316f829-f47c-4e1f-97d8-12c0a527d2fd	\N	null	{"variantPredicate": {"ids": ["UHJvZHVjdFZhcmlhbnQ6MzU2", "UHJvZHVjdFZhcmlhbnQ6NDAx"]}}	percentage	40.000	549c7032-dcf8-41c1-8510-5cc592a22382	\N	{}	\N	f
    d44e9ccd-f7a4-4e3f-bf91-a90d6cad33ef	\N	null	{"productPredicate": {"ids": ["UHJvZHVjdDoxNTY=", "UHJvZHVjdDoxMzA="]}}	percentage	30.000	5fdfd7c0-cf7f-4a4d-946b-dba173497ebb	\N	{}	\N	f
    199c3e2d-33e1-45b1-ae88-5c926f644d10	\N	null	{"variantPredicate": {"ids": ["UHJvZHVjdFZhcmlhbnQ6Mzc4", "UHJvZHVjdFZhcmlhbnQ6MzU2"]}}	percentage	10.000	5fdfd7c0-cf7f-4a4d-946b-dba173497ebb	\N	{}	\N	f
    71b6ba9c-fe1b-44ac-81ed-8c88992a12d5	\N	null	{}	percentage	40.000	a0780243-dedd-4421-bb75-4755ef9c9d4b	\N	{"discountedObjectPredicate": {"baseSubtotalPrice": {"range": {"gte": "200"}}}}	SUBTOTAL_DISCOUNT	f
    d76c875e-1e79-4b2f-b6ce-05c64a164e67	\N	null	{}	fixed	10.000	a0780243-dedd-4421-bb75-4755ef9c9d4b	\N	{"discountedObjectPredicate": {"baseSubtotalPrice": {"range": {"gte": "100"}}}}	SUBTOTAL_DISCOUNT	f
    3c67b9fe-f2f0-43a3-a017-9c2710f4ee7c	\N	null	{}	percentage	50.000	df51e77b-eaf9-471c-bff9-e383b06a12eb	\N	{"discountedObjectPredicate": {"baseSubtotalPrice": {"range": {"gte": "200"}}}}	SUBTOTAL_DISCOUNT	f
    214c4dd5-b420-4e8e-a6c5-fc831214625c	\N	null	{}	fixed	30.000	df51e77b-eaf9-471c-bff9-e383b06a12eb	\N	{"discountedObjectPredicate": {"baseSubtotalPrice": {"range": {"gte": "100"}}}}	SUBTOTAL_DISCOUNT	f
    117b4a28-a7d0-4bac-9b4c-b225fdb76b90	\N	null	{"productPredicate": {"ids": ["UHJvZHVjdDoxNjA=", "UHJvZHVjdDoxNDc="]}}	percentage	50.000	351015cb-eba6-4f46-9a34-4798bfa74f70	\N	{}	\N	f
    b0fae341-5c5c-40d2-9a01-42db044f1352	\N	null	{"variantPredicate": {"ids": ["UHJvZHVjdFZhcmlhbnQ6Mzk5", "UHJvZHVjdFZhcmlhbnQ6MzMy"]}}	percentage	10.000	351015cb-eba6-4f46-9a34-4798bfa74f70	\N	{}	\N	f
    fd285e70-54cb-47e3-a051-5c344947d6c2	\N	null	{"productPredicate": {"ids": ["UHJvZHVjdDoxMjc=", "UHJvZHVjdDoxNjI="]}}	percentage	40.000	5a0243d4-8708-431f-aa90-1e4524a8e473	\N	{}	\N	f
    75bd54a5-dec0-44b2-b7f4-cf271d2d7954	\N	null	{"variantPredicate": {"ids": ["UHJvZHVjdFZhcmlhbnQ6MzMy", "UHJvZHVjdFZhcmlhbnQ6MzM2"]}}	percentage	30.000	5a0243d4-8708-431f-aa90-1e4524a8e473	\N	{}	\N	f
    97163f4d-dcba-4497-9b02-0d862d692e1f	\N	null	{}	percentage	30.000	1578f2b4-f171-4b28-8293-8f27003ce7aa	\N	{"discountedObjectPredicate": {"baseSubtotalPrice": {"range": {"gte": "200"}}}}	SUBTOTAL_DISCOUNT	f
    cbaf9eda-ff19-47b3-9b0e-edeed8774a0c	\N	null	{}	fixed	20.000	1578f2b4-f171-4b28-8293-8f27003ce7aa	\N	{"discountedObjectPredicate": {"baseSubtotalPrice": {"range": {"gte": "100"}}}}	SUBTOTAL_DISCOUNT	f
    833f36be-8320-4cd1-9c5e-3581c433f542	\N	null	{}	percentage	30.000	7db72cca-b058-478d-aa61-4751c9615ce9	\N	{"discountedObjectPredicate": {"baseSubtotalPrice": {"range": {"gte": "200"}}}}	SUBTOTAL_DISCOUNT	f
    05eb1161-e46f-49e8-880a-b4d5ee35a7dd	\N	null	{}	fixed	50.000	7db72cca-b058-478d-aa61-4751c9615ce9	\N	{"discountedObjectPredicate": {"baseSubtotalPrice": {"range": {"gte": "100"}}}}	SUBTOTAL_DISCOUNT	f
    \.


    --
    -- Data for Name: discount_promotionrule_channels; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.discount_promotionrule_channels (id, promotionrule_id, channel_id) FROM stdin;
    1	f1ef4f5c-a8f5-4689-8079-137cfd2a356e	1
    2	f1ef4f5c-a8f5-4689-8079-137cfd2a356e	34
    3	f1ef4f5c-a8f5-4689-8079-137cfd2a356e	35
    4	a7f7e186-6f93-48ed-a6bd-244740020041	1
    5	a7f7e186-6f93-48ed-a6bd-244740020041	34
    6	a7f7e186-6f93-48ed-a6bd-244740020041	35
    7	0114c879-f9ef-4edc-bd69-2438cef5e28a	1
    8	0114c879-f9ef-4edc-bd69-2438cef5e28a	34
    9	0114c879-f9ef-4edc-bd69-2438cef5e28a	35
    10	52f87276-5e4b-4b93-9ce6-5cd8a12bab4a	1
    11	52f87276-5e4b-4b93-9ce6-5cd8a12bab4a	34
    12	52f87276-5e4b-4b93-9ce6-5cd8a12bab4a	35
    13	04ea9801-9c80-4c76-b811-0ce6872a2df6	1
    14	04ea9801-9c80-4c76-b811-0ce6872a2df6	34
    15	04ea9801-9c80-4c76-b811-0ce6872a2df6	35
    16	91feb7d6-177c-446f-a07d-5fbb948afe89	1
    17	91feb7d6-177c-446f-a07d-5fbb948afe89	34
    18	91feb7d6-177c-446f-a07d-5fbb948afe89	35
    19	5cd874ac-b3ef-4152-8e1f-f3ccf2085d68	1
    20	5cd874ac-b3ef-4152-8e1f-f3ccf2085d68	34
    21	5cd874ac-b3ef-4152-8e1f-f3ccf2085d68	35
    22	46dd357a-bc8a-4670-8f9b-993281b2d9c5	1
    23	46dd357a-bc8a-4670-8f9b-993281b2d9c5	34
    24	46dd357a-bc8a-4670-8f9b-993281b2d9c5	35
    25	251d79da-15aa-4c84-9d71-677dbe2f23cf	1
    26	251d79da-15aa-4c84-9d71-677dbe2f23cf	34
    27	251d79da-15aa-4c84-9d71-677dbe2f23cf	35
    28	0316f829-f47c-4e1f-97d8-12c0a527d2fd	1
    29	0316f829-f47c-4e1f-97d8-12c0a527d2fd	34
    30	0316f829-f47c-4e1f-97d8-12c0a527d2fd	35
    31	d44e9ccd-f7a4-4e3f-bf91-a90d6cad33ef	1
    32	d44e9ccd-f7a4-4e3f-bf91-a90d6cad33ef	34
    33	d44e9ccd-f7a4-4e3f-bf91-a90d6cad33ef	35
    34	199c3e2d-33e1-45b1-ae88-5c926f644d10	1
    35	199c3e2d-33e1-45b1-ae88-5c926f644d10	34
    36	199c3e2d-33e1-45b1-ae88-5c926f644d10	35
    37	71b6ba9c-fe1b-44ac-81ed-8c88992a12d5	1
    38	71b6ba9c-fe1b-44ac-81ed-8c88992a12d5	34
    39	71b6ba9c-fe1b-44ac-81ed-8c88992a12d5	35
    40	d76c875e-1e79-4b2f-b6ce-05c64a164e67	1
    41	d76c875e-1e79-4b2f-b6ce-05c64a164e67	34
    42	d76c875e-1e79-4b2f-b6ce-05c64a164e67	35
    43	3c67b9fe-f2f0-43a3-a017-9c2710f4ee7c	1
    44	3c67b9fe-f2f0-43a3-a017-9c2710f4ee7c	34
    45	3c67b9fe-f2f0-43a3-a017-9c2710f4ee7c	35
    46	214c4dd5-b420-4e8e-a6c5-fc831214625c	1
    47	214c4dd5-b420-4e8e-a6c5-fc831214625c	34
    48	214c4dd5-b420-4e8e-a6c5-fc831214625c	35
    49	117b4a28-a7d0-4bac-9b4c-b225fdb76b90	1
    50	117b4a28-a7d0-4bac-9b4c-b225fdb76b90	34
    51	117b4a28-a7d0-4bac-9b4c-b225fdb76b90	35
    52	b0fae341-5c5c-40d2-9a01-42db044f1352	1
    53	b0fae341-5c5c-40d2-9a01-42db044f1352	34
    54	b0fae341-5c5c-40d2-9a01-42db044f1352	35
    55	fd285e70-54cb-47e3-a051-5c344947d6c2	1
    56	fd285e70-54cb-47e3-a051-5c344947d6c2	34
    57	fd285e70-54cb-47e3-a051-5c344947d6c2	35
    58	75bd54a5-dec0-44b2-b7f4-cf271d2d7954	1
    59	75bd54a5-dec0-44b2-b7f4-cf271d2d7954	34
    60	75bd54a5-dec0-44b2-b7f4-cf271d2d7954	35
    61	97163f4d-dcba-4497-9b02-0d862d692e1f	1
    62	97163f4d-dcba-4497-9b02-0d862d692e1f	34
    63	97163f4d-dcba-4497-9b02-0d862d692e1f	35
    64	cbaf9eda-ff19-47b3-9b0e-edeed8774a0c	1
    65	cbaf9eda-ff19-47b3-9b0e-edeed8774a0c	34
    66	cbaf9eda-ff19-47b3-9b0e-edeed8774a0c	35
    67	833f36be-8320-4cd1-9c5e-3581c433f542	1
    68	833f36be-8320-4cd1-9c5e-3581c433f542	34
    69	833f36be-8320-4cd1-9c5e-3581c433f542	35
    70	05eb1161-e46f-49e8-880a-b4d5ee35a7dd	1
    71	05eb1161-e46f-49e8-880a-b4d5ee35a7dd	34
    72	05eb1161-e46f-49e8-880a-b4d5ee35a7dd	35
    \.


    --
    -- Data for Name: discount_promotionrule_gifts; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.discount_promotionrule_gifts (id, promotionrule_id, productvariant_id) FROM stdin;
    \.


    --
    -- Data for Name: discount_promotionrule_variants; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.discount_promotionrule_variants (id, promotionrule_id, productvariant_id) FROM stdin;
    1	0114c879-f9ef-4edc-bd69-2438cef5e28a	358
    2	0114c879-f9ef-4edc-bd69-2438cef5e28a	359
    3	0114c879-f9ef-4edc-bd69-2438cef5e28a	360
    4	0114c879-f9ef-4edc-bd69-2438cef5e28a	379
    5	0114c879-f9ef-4edc-bd69-2438cef5e28a	380
    6	52f87276-5e4b-4b93-9ce6-5cd8a12bab4a	386
    7	52f87276-5e4b-4b93-9ce6-5cd8a12bab4a	356
    8	a7f7e186-6f93-48ed-a6bd-244740020041	398
    9	a7f7e186-6f93-48ed-a6bd-244740020041	342
    10	f1ef4f5c-a8f5-4689-8079-137cfd2a356e	352
    11	f1ef4f5c-a8f5-4689-8079-137cfd2a356e	372
    12	f1ef4f5c-a8f5-4689-8079-137cfd2a356e	373
    13	f1ef4f5c-a8f5-4689-8079-137cfd2a356e	374
    14	f1ef4f5c-a8f5-4689-8079-137cfd2a356e	348
    15	f1ef4f5c-a8f5-4689-8079-137cfd2a356e	349
    16	f1ef4f5c-a8f5-4689-8079-137cfd2a356e	350
    17	f1ef4f5c-a8f5-4689-8079-137cfd2a356e	351
    18	0316f829-f47c-4e1f-97d8-12c0a527d2fd	401
    19	0316f829-f47c-4e1f-97d8-12c0a527d2fd	356
    20	199c3e2d-33e1-45b1-ae88-5c926f644d10	378
    21	199c3e2d-33e1-45b1-ae88-5c926f644d10	356
    22	251d79da-15aa-4c84-9d71-677dbe2f23cf	352
    23	251d79da-15aa-4c84-9d71-677dbe2f23cf	332
    24	251d79da-15aa-4c84-9d71-677dbe2f23cf	333
    25	251d79da-15aa-4c84-9d71-677dbe2f23cf	334
    26	251d79da-15aa-4c84-9d71-677dbe2f23cf	348
    27	251d79da-15aa-4c84-9d71-677dbe2f23cf	349
    28	251d79da-15aa-4c84-9d71-677dbe2f23cf	350
    29	251d79da-15aa-4c84-9d71-677dbe2f23cf	351
    30	d44e9ccd-f7a4-4e3f-bf91-a90d6cad33ef	388
    31	d44e9ccd-f7a4-4e3f-bf91-a90d6cad33ef	340
    32	d44e9ccd-f7a4-4e3f-bf91-a90d6cad33ef	341
    33	d44e9ccd-f7a4-4e3f-bf91-a90d6cad33ef	342
    34	d44e9ccd-f7a4-4e3f-bf91-a90d6cad33ef	343
    35	d44e9ccd-f7a4-4e3f-bf91-a90d6cad33ef	344
    36	117b4a28-a7d0-4bac-9b4c-b225fdb76b90	393
    37	117b4a28-a7d0-4bac-9b4c-b225fdb76b90	379
    38	117b4a28-a7d0-4bac-9b4c-b225fdb76b90	380
    39	75bd54a5-dec0-44b2-b7f4-cf271d2d7954	336
    40	75bd54a5-dec0-44b2-b7f4-cf271d2d7954	332
    41	b0fae341-5c5c-40d2-9a01-42db044f1352	332
    42	b0fae341-5c5c-40d2-9a01-42db044f1352	399
    43	fd285e70-54cb-47e3-a051-5c344947d6c2	325
    44	fd285e70-54cb-47e3-a051-5c344947d6c2	326
    45	fd285e70-54cb-47e3-a051-5c344947d6c2	327
    46	fd285e70-54cb-47e3-a051-5c344947d6c2	328
    47	fd285e70-54cb-47e3-a051-5c344947d6c2	329
    48	fd285e70-54cb-47e3-a051-5c344947d6c2	330
    49	fd285e70-54cb-47e3-a051-5c344947d6c2	331
    50	fd285e70-54cb-47e3-a051-5c344947d6c2	399
    \.


    --
    -- Data for Name: discount_promotionruletranslation; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.discount_promotionruletranslation (id, language_code, name, description, promotion_rule_id) FROM stdin;
    \.


    --
    -- Data for Name: discount_promotiontranslation; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.discount_promotiontranslation (id, language_code, name, description, promotion_id) FROM stdin;
    \.


    --
    -- Data for Name: discount_voucher; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.discount_voucher (id, type, name, usage_limit, start_date, end_date, discount_value_type, apply_once_per_order, countries, min_checkout_items_quantity, apply_once_per_customer, only_for_staff, metadata, private_metadata, single_use) FROM stdin;
    1	shipping	Free shipping	\N	2024-05-20 11:17:29.612836+00	\N	percentage	f		\N	f	f	{}	{}	f
    2	entire_order	Big order discount	\N	2024-05-20 11:17:29.660132+00	\N	fixed	f		\N	f	f	{}	{}	f
    3	entire_order	Percentage order discount	\N	2024-05-20 11:17:29.705912+00	\N	percentage	f		\N	f	f	{}	{}	f
    \.


    --
    -- Data for Name: discount_voucher_categories; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.discount_voucher_categories (id, voucher_id, category_id) FROM stdin;
    \.


    --
    -- Data for Name: discount_voucher_collections; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.discount_voucher_collections (id, voucher_id, collection_id) FROM stdin;
    \.


    --
    -- Data for Name: discount_voucher_products; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.discount_voucher_products (id, voucher_id, product_id) FROM stdin;
    \.


    --
    -- Data for Name: discount_voucher_variants; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.discount_voucher_variants (id, voucher_id, productvariant_id) FROM stdin;
    \.


    --
    -- Data for Name: discount_voucherchannellisting; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.discount_voucherchannellisting (id, discount_value, currency, min_spent_amount, channel_id, voucher_id) FROM stdin;
    1	100.000	PLN	\N	35	1
    2	100.000	USD	\N	1	1
    3	100.000	USD	\N	34	1
    4	100.000	PLN	200.000	35	2
    5	25.000	USD	200.000	1	2
    6	25.000	USD	200.000	34	2
    7	5.000	PLN	\N	35	3
    8	5.000	USD	\N	1	3
    9	5.000	USD	\N	34	3
    \.


    --
    -- Data for Name: discount_vouchercode; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.discount_vouchercode (id, code, used, is_active, created_at, voucher_id) FROM stdin;
    06fbb334-7539-4318-8b76-ce9ff6fc76fb	FREESHIPPING	0	t	2024-05-20 11:17:29.626715+00	1
    e7312c2d-93c7-4ce7-99df-2d07a06c4111	DISCOUNT	0	t	2024-05-20 11:17:29.673745+00	2
    b914e80b-7db3-486f-9ea8-70f38846e9a2	VCO9KV98LC	0	t	2024-05-20 11:17:29.713546+00	3
    \.


    --
    -- Data for Name: discount_vouchercustomer; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.discount_vouchercustomer (id, customer_email, voucher_code_id) FROM stdin;
    \.


    --
    -- Data for Name: discount_vouchertranslation; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.discount_vouchertranslation (id, language_code, name, voucher_id) FROM stdin;
    \.


    --
    -- Data for Name: django_celery_beat_clockedschedule; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.django_celery_beat_clockedschedule (id, clocked_time) FROM stdin;
    \.


    --
    -- Data for Name: django_celery_beat_crontabschedule; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.django_celery_beat_crontabschedule (id, minute, hour, day_of_week, day_of_month, month_of_year, timezone) FROM stdin;
    \.


    --
    -- Data for Name: django_celery_beat_intervalschedule; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.django_celery_beat_intervalschedule (id, every, period) FROM stdin;
    \.


    --
    -- Data for Name: django_celery_beat_periodictask; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.django_celery_beat_periodictask (id, name, task, args, kwargs, queue, exchange, routing_key, expires, enabled, last_run_at, total_run_count, date_changed, description, crontab_id, interval_id, solar_id, one_off, start_time, priority, headers, clocked_id, expire_seconds) FROM stdin;
    \.


    --
    -- Data for Name: django_celery_beat_periodictasks; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.django_celery_beat_periodictasks (ident, last_update) FROM stdin;
    \.


    --
    -- Data for Name: django_celery_beat_solarschedule; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.django_celery_beat_solarschedule (id, event, latitude, longitude) FROM stdin;
    \.


    --
    -- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.django_content_type (id, app_label, model) FROM stdin;
    1	plugins	pluginconfiguration
    34	discount	sale
    35	discount	voucher
    36	discount	vouchertranslation
    37	discount	saletranslation
    38	discount	vouchercustomer
    39	discount	salechannellisting
    40	discount	voucherchannellisting
    41	discount	orderdiscount
    42	discount	checkoutlinediscount
    43	discount	promotion
    44	discount	promotionrule
    45	discount	orderlinediscount
    46	discount	promotiontranslation
    47	discount	promotionruletranslation
    48	discount	promotionevent
    49	contenttypes	contenttype
    50	sites	site
    51	django_celery_beat	crontabschedule
    52	django_celery_beat	intervalschedule
    53	django_celery_beat	periodictask
    54	django_celery_beat	periodictasks
    55	django_celery_beat	solarschedule
    56	django_celery_beat	clockedschedule
    57	permission	permission
    58	plugins	emailtemplate
    59	account	user
    60	account	address
    61	account	customernote
    62	account	customerevent
    63	account	staffnotificationrecipient
    64	account	group
    65	discount	vouchercode
    66	discount	checkoutdiscount
    67	discount	promotionrule_variants
    68	giftcard	giftcard
    69	giftcard	giftcardevent
    70	giftcard	giftcardtag
    71	product	category
    72	product	product
    73	product	productvariant
    74	product	producttype
    75	product	collectionproduct
    76	product	collection
    77	product	categorytranslation
    78	product	collectiontranslation
    79	product	producttranslation
    80	product	productvarianttranslation
    81	product	digitalcontent
    82	product	digitalcontenturl
    83	product	productvariantchannellisting
    84	product	productchannellisting
    85	product	collectionchannellisting
    86	product	productmedia
    87	product	variantmedia
    88	product	variantchannellistingpromotionrule
    89	attribute	assignedvariantattribute
    90	attribute	attribute
    91	attribute	attributevalue
    92	attribute	attributevariant
    93	attribute	attributeproduct
    94	attribute	attributepage
    95	attribute	attributevaluetranslation
    96	attribute	attributetranslation
    97	attribute	assignedproductattributevalue
    98	attribute	assignedvariantattributevalue
    99	attribute	assignedpageattributevalue
    100	channel	channel
    101	checkout	checkout
    102	checkout	checkoutline
    103	checkout	checkoutmetadata
    104	core	eventdelivery
    105	core	eventpayload
    106	core	eventdeliveryattempt
    107	csv	exportfile
    108	csv	exportevent
    109	menu	menu
    110	menu	menuitem
    111	menu	menuitemtranslation
    112	order	order
    113	order	orderline
    114	order	fulfillment
    115	order	fulfillmentline
    116	order	orderevent
    117	order	ordergrantedrefund
    118	order	ordergrantedrefundline
    119	invoice	invoice
    120	invoice	invoiceevent
    121	shipping	shippingmethod
    122	shipping	shippingmethodtranslation
    123	shipping	shippingzone
    124	shipping	shippingmethodchannellisting
    125	shipping	shippingmethodpostalcoderule
    126	site	sitesettings
    127	site	sitesettingstranslation
    128	page	page
    129	page	pagetranslation
    130	page	pagetype
    131	payment	transaction
    132	payment	payment
    133	payment	transactionitem
    134	payment	transactionevent
    135	tax	taxclass
    136	tax	taxconfiguration
    137	tax	taxclasscountryrate
    138	tax	taxconfigurationpercountry
    139	warehouse	warehouse
    140	warehouse	stock
    141	warehouse	allocation
    142	warehouse	preorderallocation
    143	warehouse	reservation
    144	warehouse	preorderreservation
    145	warehouse	channelwarehouse
    146	webhook	webhook
    147	webhook	webhookevent
    148	app	app
    149	app	apptoken
    150	app	appinstallation
    151	app	appextension
    152	thumbnail	thumbnail
    153	schedulers	customschedule
    154	schedulers	customperiodictask
    \.


    --
    -- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.django_migrations (id, app, name, applied) FROM stdin;
    1	sites	0001_initial	2024-05-20 11:12:07.216217+00
    2	sites	0002_alter_domain_unique	2024-05-20 11:12:07.293125+00
    3	site	0001_initial	2024-05-20 11:12:07.351244+00
    4	site	0002_add_default_data	2024-05-20 11:12:07.382282+00
    5	site	0003_sitesettings_description	2024-05-20 11:12:07.403021+00
    6	site	0004_auto_20170221_0426	2024-05-20 11:12:07.452466+00
    7	site	0005_auto_20170906_0556	2024-05-20 11:12:07.460611+00
    8	site	0006_auto_20171025_0454	2024-05-20 11:12:07.479854+00
    9	site	0007_auto_20171027_0856	2024-05-20 11:12:07.507968+00
    10	site	0008_auto_20171027_0856	2024-05-20 11:12:07.571863+00
    11	site	0009_auto_20171109_0849	2024-05-20 11:12:07.591599+00
    12	site	0010_auto_20171113_0958	2024-05-20 11:12:07.601801+00
    13	site	0011_auto_20180108_0814	2024-05-20 11:12:07.640173+00
    14	product	0001_initial	2024-05-20 11:12:08.181812+00
    15	product	0002_auto_20150722_0545	2024-05-20 11:12:08.203443+00
    16	product	0003_auto_20150820_2016	2024-05-20 11:12:08.226165+00
    17	product	0003_auto_20150820_1955	2024-05-20 11:12:08.248335+00
    18	product	0004_merge	2024-05-20 11:12:08.254648+00
    19	product	0005_auto_20150825_1433	2024-05-20 11:12:08.326767+00
    20	product	0006_product_updated_at	2024-05-20 11:12:08.351206+00
    21	product	0007_auto_20160112_1025	2024-05-20 11:12:08.401504+00
    22	product	0008_auto_20160114_0733	2024-05-20 11:12:08.46149+00
    23	product	0009_discount_categories	2024-05-20 11:12:08.52217+00
    24	product	0010_auto_20160129_0826	2024-05-20 11:12:08.603394+00
    25	product	0011_stock_quantity_allocated	2024-05-20 11:12:08.61969+00
    26	product	0012_auto_20160218_0812	2024-05-20 11:12:08.699198+00
    27	product	0013_auto_20161207_0555	2024-05-20 11:12:08.769148+00
    28	product	0014_auto_20161207_0840	2024-05-20 11:12:08.784328+00
    29	product	0015_transfer_locations	2024-05-20 11:12:08.801722+00
    30	product	0016_auto_20161207_0843	2024-05-20 11:12:08.844245+00
    31	product	0017_remove_stock_location	2024-05-20 11:12:08.865363+00
    32	product	0018_auto_20161207_0844	2024-05-20 11:12:08.91234+00
    33	product	0019_auto_20161212_0230	2024-05-20 11:12:09.06619+00
    34	product	0020_attribute_data_to_class	2024-05-20 11:12:09.09718+00
    35	product	0021_add_hstore_extension	2024-05-20 11:12:09.15517+00
    36	product	0022_auto_20161212_0301	2024-05-20 11:12:09.255503+00
    37	product	0023_auto_20161211_1912	2024-05-20 11:12:09.284455+00
    38	product	0024_migrate_json_data	2024-05-20 11:12:09.349109+00
    39	product	0025_auto_20161219_0517	2024-05-20 11:12:09.361842+00
    40	product	0026_auto_20161230_0347	2024-05-20 11:12:09.378465+00
    41	product	0027_auto_20170113_0435	2024-05-20 11:12:09.460934+00
    42	product	0013_auto_20161130_0608	2024-05-20 11:12:09.470318+00
    43	product	0014_remove_productvariant_attributes	2024-05-20 11:12:09.496146+00
    44	product	0015_productvariant_attributes	2024-05-20 11:12:09.536563+00
    45	product	0016_auto_20161204_0311	2024-05-20 11:12:09.553435+00
    46	product	0017_attributechoicevalue_slug	2024-05-20 11:12:09.584295+00
    47	product	0018_auto_20161212_0725	2024-05-20 11:12:09.605166+00
    48	product	0026_merge_20161221_0845	2024-05-20 11:12:09.615093+00
    49	product	0028_merge_20170116_1016	2024-05-20 11:12:09.628407+00
    50	product	0029_product_is_featured	2024-05-20 11:12:09.650605+00
    51	product	0030_auto_20170206_0407	2024-05-20 11:12:09.836646+00
    52	product	0031_auto_20170206_0601	2024-05-20 11:12:09.867813+00
    53	product	0032_auto_20170216_0438	2024-05-20 11:12:09.896687+00
    54	product	0033_auto_20170227_0757	2024-05-20 11:12:09.966707+00
    55	product	0034_product_is_published	2024-05-20 11:12:09.987824+00
    56	product	0035_auto_20170919_0846	2024-05-20 11:12:10.018597+00
    57	product	0036_auto_20171115_0608	2024-05-20 11:12:10.042488+00
    58	product	0037_auto_20171124_0847	2024-05-20 11:12:10.073711+00
    59	product	0038_auto_20171129_0616	2024-05-20 11:12:10.145139+00
    60	product	0037_auto_20171129_1004	2024-05-20 11:12:10.237493+00
    61	product	0039_merge_20171130_0727	2024-05-20 11:12:10.244012+00
    62	product	0040_auto_20171205_0428	2024-05-20 11:12:10.271783+00
    63	product	0041_auto_20171205_0546	2024-05-20 11:12:10.317293+00
    64	product	0042_auto_20171206_0501	2024-05-20 11:12:10.346103+00
    65	product	0043_auto_20171207_0839	2024-05-20 11:12:10.369762+00
    66	product	0044_auto_20180108_0814	2024-05-20 11:12:10.866088+00
    67	product	0045_md_to_html	2024-05-20 11:12:10.894248+00
    68	product	0046_product_category	2024-05-20 11:12:10.967162+00
    69	product	0047_auto_20180117_0359	2024-05-20 11:12:11.080406+00
    70	product	0048_product_class_to_type	2024-05-20 11:12:11.231835+00
    71	product	0049_collection	2024-05-20 11:12:11.378656+00
    72	product	0050_auto_20180131_0746	2024-05-20 11:12:11.401708+00
    73	product	0051_auto_20180202_1106	2024-05-20 11:12:11.423788+00
    74	product	0052_slug_field_length	2024-05-20 11:12:11.51468+00
    75	page	0001_initial	2024-05-20 11:12:11.56743+00
    76	menu	0001_initial	2024-05-20 11:12:11.767202+00
    77	menu	0002_auto_20180319_0412	2024-05-20 11:12:11.808884+00
    78	site	0012_auto_20180405_0757	2024-05-20 11:12:11.902412+00
    79	menu	0003_auto_20180405_0854	2024-05-20 11:12:11.983438+00
    80	site	0013_assign_default_menus	2024-05-20 11:12:12.044078+00
    81	site	0014_handle_taxes	2024-05-20 11:12:12.089225+00
    82	site	0015_sitesettings_handle_stock_by_default	2024-05-20 11:12:12.112898+00
    83	site	0016_auto_20180719_0520	2024-05-20 11:12:12.129661+00
    84	site	0017_auto_20180803_0528	2024-05-20 11:12:12.211066+00
    85	product	0053_product_seo_description	2024-05-20 11:12:12.239298+00
    86	product	0053_auto_20180305_1002	2024-05-20 11:12:12.266146+00
    87	product	0054_merge_20180320_1108	2024-05-20 11:12:12.27302+00
    88	product	0055_auto_20180321_0417	2024-05-20 11:12:12.380275+00
    89	product	0056_auto_20180330_0321	2024-05-20 11:12:12.421739+00
    90	product	0057_auto_20180403_0852	2024-05-20 11:12:12.458114+00
    91	shipping	0001_initial	2024-05-20 11:12:12.550378+00
    92	shipping	0002_auto_20160906_0741	2024-05-20 11:12:12.576432+00
    93	shipping	0003_auto_20170116_0700	2024-05-20 11:12:12.585781+00
    94	shipping	0004_auto_20170206_0407	2024-05-20 11:12:12.626189+00
    95	shipping	0005_auto_20170906_0556	2024-05-20 11:12:12.635833+00
    96	shipping	0006_auto_20171109_0908	2024-05-20 11:12:12.645069+00
    97	shipping	0007_auto_20171129_1004	2024-05-20 11:12:12.659231+00
    98	shipping	0008_auto_20180108_0814	2024-05-20 11:12:12.689184+00
    99	contenttypes	0001_initial	2024-05-20 11:12:12.737671+00
    100	contenttypes	0002_remove_content_type_name	2024-05-20 11:12:12.784335+00
    101	auth	0001_initial	2024-05-20 11:12:12.946828+00
    102	auth	0002_alter_permission_name_max_length	2024-05-20 11:12:12.966491+00
    103	auth	0003_alter_user_email_max_length	2024-05-20 11:12:12.984212+00
    104	auth	0004_alter_user_username_opts	2024-05-20 11:12:13.012883+00
    105	auth	0005_alter_user_last_login_null	2024-05-20 11:12:13.027111+00
    106	auth	0006_require_contenttypes_0002	2024-05-20 11:12:13.033796+00
    107	userprofile	0001_initial	2024-05-20 11:12:13.344046+00
    108	order	0001_initial	2024-05-20 11:12:13.774396+00
    109	order	0002_auto_20150820_1955	2024-05-20 11:12:13.806349+00
    110	order	0003_auto_20150825_1433	2024-05-20 11:12:13.844944+00
    111	order	0004_order_total	2024-05-20 11:12:13.869726+00
    112	order	0005_deliverygroup_last_updated	2024-05-20 11:12:13.896908+00
    113	order	0006_deliverygroup_shipping_method	2024-05-20 11:12:13.937213+00
    114	order	0007_deliverygroup_tracking_number	2024-05-20 11:12:13.985149+00
    115	order	0008_auto_20151026_0820	2024-05-20 11:12:14.596617+00
    116	order	0009_auto_20151201_0820	2024-05-20 11:12:14.680748+00
    117	order	0010_auto_20160119_0541	2024-05-20 11:12:14.781893+00
    118	discount	0001_initial	2024-05-20 11:12:14.928534+00
    119	discount	0002_voucher	2024-05-20 11:12:15.050898+00
    120	discount	0003_auto_20160207_0534	2024-05-20 11:12:15.219284+00
    121	order	0011_auto_20160207_0534	2024-05-20 11:12:15.351257+00
    122	order	0012_auto_20160216_1032	2024-05-20 11:12:15.432906+00
    123	order	0013_auto_20160906_0741	2024-05-20 11:12:15.566291+00
    124	order	0014_auto_20161028_0955	2024-05-20 11:12:15.606366+00
    125	order	0015_auto_20170206_0407	2024-05-20 11:12:16.326456+00
    126	order	0016_order_language_code	2024-05-20 11:12:16.356552+00
    127	order	0017_auto_20170906_0556	2024-05-20 11:12:16.391549+00
    128	order	0018_auto_20170919_0839	2024-05-20 11:12:16.416985+00
    129	order	0019_auto_20171109_1423	2024-05-20 11:12:16.639989+00
    130	order	0020_auto_20171123_0609	2024-05-20 11:12:17.14367+00
    131	order	0021_auto_20171129_1004	2024-05-20 11:12:17.27178+00
    132	order	0022_auto_20171205_0428	2024-05-20 11:12:17.338155+00
    133	order	0023_auto_20171206_0506	2024-05-20 11:12:17.412602+00
    134	order	0024_remove_order_status	2024-05-20 11:12:17.439139+00
    135	order	0025_auto_20171214_1015	2024-05-20 11:12:17.49251+00
    136	order	0026_auto_20171218_0428	2024-05-20 11:12:17.606779+00
    137	order	0027_auto_20180108_0814	2024-05-20 11:12:18.566478+00
    138	order	0028_status_fsm	2024-05-20 11:12:18.596831+00
    139	order	0029_auto_20180111_0845	2024-05-20 11:12:18.699019+00
    140	order	0030_auto_20180118_0605	2024-05-20 11:12:18.800141+00
    141	order	0031_auto_20180119_0405	2024-05-20 11:12:18.929876+00
    142	order	0032_orderline_is_shipping_required	2024-05-20 11:12:19.011761+00
    143	order	0033_auto_20180123_0832	2024-05-20 11:12:19.501464+00
    144	order	0034_auto_20180221_1056	2024-05-20 11:12:19.568642+00
    145	order	0035_auto_20180221_1057	2024-05-20 11:12:19.637962+00
    146	order	0036_remove_order_total_tax	2024-05-20 11:12:19.679136+00
    147	order	0037_auto_20180228_0450	2024-05-20 11:12:19.81875+00
    148	order	0038_auto_20180228_0451	2024-05-20 11:12:19.881254+00
    149	order	0039_auto_20180312_1203	2024-05-20 11:12:19.959621+00
    150	order	0040_auto_20180210_0422	2024-05-20 11:12:20.454754+00
    151	order	0041_auto_20180222_0458	2024-05-20 11:12:20.525638+00
    152	order	0042_auto_20180227_0436	2024-05-20 11:12:20.789677+00
    153	order	0043_auto_20180322_0655	2024-05-20 11:12:20.848525+00
    154	order	0044_auto_20180326_1055	2024-05-20 11:12:21.138844+00
    155	order	0045_auto_20180329_0142	2024-05-20 11:12:21.510991+00
    156	product	0058_auto_20180329_0142	2024-05-20 11:12:21.756975+00
    157	product	0059_generate_variant_name_from_attrs	2024-05-20 11:12:21.812535+00
    158	product	0060_collection_is_published	2024-05-20 11:12:21.840149+00
    159	product	0061_product_taxes	2024-05-20 11:12:21.926746+00
    160	product	0062_sortable_models	2024-05-20 11:12:22.680598+00
    161	product	0063_required_attr_value_order	2024-05-20 11:12:22.695075+00
    162	product	0064_productvariant_handle_stock	2024-05-20 11:12:22.732119+00
    163	product	0065_auto_20180719_0520	2024-05-20 11:12:22.784504+00
    164	product	0066_auto_20180803_0528	2024-05-20 11:12:23.410102+00
    165	site	0018_sitesettings_homepage_collection	2024-05-20 11:12:23.549636+00
    166	site	0019_sitesettings_default_weight_unit	2024-05-20 11:12:23.585622+00
    167	site	0020_auto_20190301_0336	2024-05-20 11:12:23.612077+00
    168	site	0021_auto_20190326_0521	2024-05-20 11:12:23.67018+00
    169	order	0046_order_line_taxes	2024-05-20 11:12:23.744105+00
    170	order	0047_order_line_name_length	2024-05-20 11:12:23.776284+00
    171	order	0048_auto_20180629_1055	2024-05-20 11:12:23.871696+00
    172	order	0049_auto_20180719_0520	2024-05-20 11:12:23.900535+00
    173	order	0050_auto_20180803_0528	2024-05-20 11:12:23.983188+00
    174	order	0050_auto_20180803_0337	2024-05-20 11:12:24.054369+00
    175	order	0051_merge_20180807_0704	2024-05-20 11:12:24.071311+00
    176	order	0052_auto_20180822_0720	2024-05-20 11:12:24.192416+00
    177	order	0053_orderevent	2024-05-20 11:12:24.310131+00
    178	order	0054_move_data_to_order_events	2024-05-20 11:12:24.429911+00
    179	order	0055_remove_order_note_order_history_entry	2024-05-20 11:12:24.763173+00
    180	order	0056_auto_20180911_1541	2024-05-20 11:12:24.794947+00
    181	order	0057_orderevent_parameters_new	2024-05-20 11:12:24.875166+00
    182	order	0058_remove_orderevent_parameters	2024-05-20 11:12:24.909125+00
    183	order	0059_auto_20180913_0841	2024-05-20 11:12:24.938305+00
    184	order	0060_auto_20180919_0731	2024-05-20 11:12:24.972707+00
    185	order	0061_auto_20180920_0859	2024-05-20 11:12:25.008164+00
    186	order	0062_auto_20180921_0949	2024-05-20 11:12:25.574738+00
    187	order	0063_auto_20180926_0446	2024-05-20 11:12:25.609987+00
    188	order	0064_auto_20181016_0819	2024-05-20 11:12:25.66914+00
    189	cart	0001_initial	2024-05-20 11:12:25.937732+00
    190	cart	0002_auto_20161014_1221	2024-05-20 11:12:26.012904+00
    191	cart	fix_empty_data_in_lines	2024-05-20 11:12:26.090424+00
    192	cart	0001_auto_20170113_0435	2024-05-20 11:12:26.247201+00
    193	cart	0002_auto_20170206_0407	2024-05-20 11:12:26.591064+00
    194	cart	0003_auto_20170906_0556	2024-05-20 11:12:26.624282+00
    195	cart	0004_auto_20171129_1004	2024-05-20 11:12:26.682517+00
    196	cart	0005_auto_20180108_0814	2024-05-20 11:12:27.120009+00
    197	cart	0006_auto_20180221_0825	2024-05-20 11:12:27.145997+00
    198	userprofile	0002_auto_20150907_0602	2024-05-20 11:12:27.197372+00
    199	userprofile	0003_auto_20151104_1102	2024-05-20 11:12:27.298513+00
    200	userprofile	0004_auto_20160114_0419	2024-05-20 11:12:27.372295+00
    201	userprofile	0005_auto_20160205_0651	2024-05-20 11:12:27.484948+00
    202	userprofile	0006_auto_20160829_0819	2024-05-20 11:12:27.538385+00
    203	userprofile	0007_auto_20161115_0940	2024-05-20 11:12:27.657444+00
    204	userprofile	0008_auto_20161115_1011	2024-05-20 11:12:27.70134+00
    205	userprofile	0009_auto_20170206_0407	2024-05-20 11:12:28.320969+00
    206	userprofile	0010_auto_20170919_0839	2024-05-20 11:12:28.350973+00
    207	userprofile	0011_auto_20171110_0552	2024-05-20 11:12:28.388689+00
    208	userprofile	0012_auto_20171117_0846	2024-05-20 11:12:28.414816+00
    209	userprofile	0013_auto_20171120_0521	2024-05-20 11:12:28.527133+00
    210	userprofile	0014_auto_20171129_1004	2024-05-20 11:12:28.597129+00
    211	userprofile	0015_auto_20171213_0734	2024-05-20 11:12:28.671619+00
    212	userprofile	0016_auto_20180108_0814	2024-05-20 11:12:29.675605+00
    213	account	0017_auto_20180206_0957	2024-05-20 11:12:29.747585+00
    214	account	0018_auto_20180426_0641	2024-05-20 11:12:30.029623+00
    215	account	0019_auto_20180528_1205	2024-05-20 11:12:30.123722+00
    216	checkout	0007_merge_cart_with_checkout	2024-05-20 11:12:31.409499+00
    217	checkout	0008_rename_tables	2024-05-20 11:12:31.488736+00
    218	checkout	0009_cart_translated_discount_name	2024-05-20 11:12:31.530784+00
    219	checkout	0010_auto_20180822_0720	2024-05-20 11:12:31.614009+00
    220	checkout	0011_auto_20180913_0817	2024-05-20 11:12:31.793698+00
    221	checkout	0012_remove_cartline_data	2024-05-20 11:12:31.825349+00
    222	checkout	0013_auto_20180913_0841	2024-05-20 11:12:31.896515+00
    223	checkout	0014_auto_20180921_0751	2024-05-20 11:12:31.94114+00
    224	checkout	0015_auto_20181017_1346	2024-05-20 11:12:31.971176+00
    225	payment	0001_initial	2024-05-20 11:12:32.262774+00
    226	payment	0002_transfer_payment_to_payment_method	2024-05-20 11:12:32.341839+00
    227	order	0065_auto_20181017_1346	2024-05-20 11:12:32.649899+00
    228	order	0066_auto_20181023_0319	2024-05-20 11:12:32.718205+00
    229	order	0067_auto_20181102_1054	2024-05-20 11:12:32.767544+00
    230	order	0068_order_checkout_token	2024-05-20 11:12:32.810696+00
    231	order	0069_auto_20190225_2305	2024-05-20 11:12:32.833604+00
    232	order	0070_drop_update_event_and_rename_events	2024-05-20 11:12:33.043877+00
    233	account	0020_user_token	2024-05-20 11:12:33.07634+00
    234	account	0021_unique_token	2024-05-20 11:12:33.19613+00
    235	account	0022_auto_20180718_0956	2024-05-20 11:12:33.229179+00
    236	account	0023_auto_20180719_0520	2024-05-20 11:12:33.261747+00
    237	account	0024_auto_20181011_0737	2024-05-20 11:12:33.328605+00
    238	account	0025_auto_20190314_0550	2024-05-20 11:12:33.382332+00
    239	account	0026_user_avatar	2024-05-20 11:12:33.433973+00
    240	account	0027_customerevent	2024-05-20 11:12:33.585209+00
    241	site	0022_sitesettings_company_address	2024-05-20 11:12:33.670743+00
    242	site	0023_auto_20191007_0835	2024-05-20 11:12:33.77743+00
    243	site	0024_sitesettings_customer_set_password_url	2024-05-20 11:12:33.818873+00
    244	site	0025_auto_20191024_0552	2024-05-20 11:12:33.89154+00
    245	site	0026_remove_sitesettings_homepage_collection	2024-05-20 11:12:34.879872+00
    246	site	0027_sitesettings_automatically_confirm_all_new_orders	2024-05-20 11:12:34.934417+00
    247	site	0028_delete_authorizationkey	2024-05-20 11:12:34.951257+00
    248	site	0029_auto_20210120_0934	2024-05-20 11:12:34.998388+00
    249	site	0030_auto_20210722_1141	2024-05-20 11:12:35.113522+00
    250	site	0030_alter_sitesettingstranslation_language_code	2024-05-20 11:12:35.145075+00
    251	site	0031_merge_20210820_1454	2024-05-20 11:12:35.150939+00
    252	site	0032_gift_card_settings	2024-05-20 11:12:35.297456+00
    253	site	0033_sitesettings_reserve_stock_duration_minutes	2024-05-20 11:12:35.37756+00
    254	site	0034_sitesettings_limit_quantity_per_checkout	2024-05-20 11:12:35.422665+00
    255	shipping	0009_auto_20180629_1055	2024-05-20 11:12:35.437921+00
    256	shipping	0010_auto_20180719_0520	2024-05-20 11:12:35.459549+00
    257	shipping	0011_auto_20180802_1238	2024-05-20 11:12:35.481322+00
    258	shipping	0012_remove_legacy_shipping_methods	2024-05-20 11:12:35.771672+00
    265	shipping	0013_auto_20180822_0721	2024-05-20 11:12:48.578396+00
    266	shipping	0014_auto_20180920_0956	2024-05-20 11:12:48.630162+00
    267	shipping	0015_auto_20190305_0640	2024-05-20 11:12:48.660454+00
    268	shipping	0016_shippingmethod_meta	2024-05-20 11:12:48.690234+00
    269	shipping	0017_django_price_2	2024-05-20 11:12:48.811158+00
    270	shipping	0018_default_zones_countries	2024-05-20 11:12:48.914082+00
    271	shipping	0019_remove_shippingmethod_meta	2024-05-20 11:12:48.948422+00
    272	shipping	0020_auto_20200902_1249	2024-05-20 11:12:49.100049+00
    273	shipping	0021_auto_20201021_2158	2024-05-20 11:12:49.225737+00
    274	product	0067_remove_product_is_featured	2024-05-20 11:12:49.26085+00
    275	product	0068_auto_20180822_0720	2024-05-20 11:12:49.350606+00
    276	product	0069_auto_20180912_0326	2024-05-20 11:12:49.376699+00
    277	product	0070_auto_20180912_0329	2024-05-20 11:12:49.509495+00
    278	product	0071_attributechoicevalue_value	2024-05-20 11:12:49.539163+00
    279	product	0072_auto_20180925_1048	2024-05-20 11:12:50.103717+00
    280	product	0073_auto_20181010_0729	2024-05-20 11:12:50.570406+00
    281	product	0074_auto_20181010_0730	2024-05-20 11:12:51.213749+00
    282	product	0075_auto_20181010_0842	2024-05-20 11:12:51.647787+00
    283	product	0076_auto_20181012_1146	2024-05-20 11:12:51.667727+00
    284	product	0077_generate_versatile_background_images	2024-05-20 11:12:51.673459+00
    285	product	0078_auto_20181120_0437	2024-05-20 11:12:51.712766+00
    286	product	0079_default_tax_rate_instead_of_empty_field	2024-05-20 11:12:51.794358+00
    287	product	0080_collection_published_date	2024-05-20 11:12:51.832541+00
    288	product	0080_auto_20181214_0440	2024-05-20 11:12:51.909801+00
    289	product	0081_merge_20181215_1659	2024-05-20 11:12:51.915658+00
    290	product	0081_auto_20181218_0024	2024-05-20 11:12:52.015438+00
    291	product	0082_merge_20181219_1440	2024-05-20 11:12:52.021989+00
    292	product	0083_auto_20190104_0443	2024-05-20 11:12:52.082832+00
    293	product	0084_auto_20190122_0113	2024-05-20 11:12:52.161552+00
    294	product	0085_auto_20190125_0025	2024-05-20 11:12:52.176618+00
    295	product	0086_product_publication_date	2024-05-20 11:12:52.263411+00
    296	product	0087_auto_20190208_0326	2024-05-20 11:12:52.292713+00
    297	product	0088_auto_20190220_1928	2024-05-20 11:12:52.319006+00
    298	product	0089_auto_20190225_0252	2024-05-20 11:12:52.54915+00
    299	product	0090_auto_20190328_0608	2024-05-20 11:12:52.625603+00
    300	product	0091_auto_20190402_0853	2024-05-20 11:12:52.915474+00
    301	product	0092_auto_20190507_0309	2024-05-20 11:12:53.189638+00
    302	product	0093_auto_20190521_0124	2024-05-20 11:12:53.509346+00
    303	product	0094_auto_20190618_0430	2024-05-20 11:12:53.55632+00
    304	product	0095_auto_20190618_0842	2024-05-20 11:12:54.116559+00
    305	product	0096_auto_20190719_0339	2024-05-20 11:12:54.14726+00
    306	product	0097_auto_20190719_0458	2024-05-20 11:12:54.249723+00
    307	product	0098_auto_20190719_0733	2024-05-20 11:12:54.362458+00
    308	product	0099_auto_20190719_0745	2024-05-20 11:12:54.455008+00
    309	product	0096_raw_html_to_json	2024-05-20 11:12:54.68909+00
    310	product	0100_merge_20190719_0803	2024-05-20 11:12:54.695872+00
    311	product	0101_auto_20190719_0839	2024-05-20 11:12:54.962495+00
    312	product	0102_migrate_data_enterprise_grade_attributes	2024-05-20 11:12:55.353369+00
    313	product	0103_schema_data_enterprise_grade_attributes	2024-05-20 11:12:57.619416+00
    314	product	0104_fix_invalid_attributes_map	2024-05-20 11:12:57.819176+00
    315	product	0105_product_minimal_variant_price	2024-05-20 11:12:58.034131+00
    316	product	0106_django_prices_2	2024-05-20 11:12:58.200728+00
    317	product	0107_attributes_map_to_m2m	2024-05-20 11:12:59.05651+00
    318	product	0108_auto_20191003_0422	2024-05-20 11:12:59.223221+00
    319	product	0109_auto_20191006_1433	2024-05-20 11:12:59.775583+00
    320	product	0110_auto_20191108_0340	2024-05-20 11:12:59.998515+00
    321	auth	0007_alter_validators_add_error_messages	2024-05-20 11:13:00.02228+00
    322	auth	0008_alter_user_username_max_length	2024-05-20 11:13:00.058216+00
    323	auth	0009_alter_user_last_name_max_length	2024-05-20 11:13:00.078522+00
    324	auth	0010_alter_group_name_max_length	2024-05-20 11:13:00.200682+00
    325	auth	0011_update_proxy_permissions	2024-05-20 11:13:00.293501+00
    326	account	0028_user_private_meta	2024-05-20 11:13:00.332582+00
    327	account	0029_user_meta	2024-05-20 11:13:00.396124+00
    328	account	0030_auto_20190719_0733	2024-05-20 11:13:00.435987+00
    329	account	0031_auto_20190719_0745	2024-05-20 11:13:00.491624+00
    330	account	0032_remove_user_token	2024-05-20 11:13:00.525461+00
    331	account	0033_serviceaccount	2024-05-20 11:13:00.736722+00
    332	account	0034_service_account_token	2024-05-20 11:13:01.003688+00
    333	account	0035_staffnotificationrecipient	2024-05-20 11:13:01.14281+00
    334	account	0036_auto_20191209_0407	2024-05-20 11:13:01.197261+00
    335	account	0037_auto_20191219_0944	2024-05-20 11:13:01.250805+00
    336	warehouse	0001_initial	2024-05-20 11:13:01.695219+00
    337	product	0111_auto_20191209_0437	2024-05-20 11:13:01.759576+00
    338	product	0112_auto_20200129_0050	2024-05-20 11:13:02.249009+00
    339	product	0113_auto_20200129_0717	2024-05-20 11:13:03.360171+00
    340	product	0114_auto_20200129_0815	2024-05-20 11:13:03.67899+00
    341	product	0115_auto_20200221_0257	2024-05-20 11:13:04.456356+00
    342	product	0116_auto_20200225_0237	2024-05-20 11:13:04.514417+00
    343	product	0117_auto_20200423_0737	2024-05-20 11:13:04.543357+00
    344	product	0118_populate_product_variant_price	2024-05-20 11:13:05.450373+00
    345	warehouse	0002_auto_20200123_0036	2024-05-20 11:13:05.591999+00
    346	warehouse	0003_warehouse_slug	2024-05-20 11:13:05.833156+00
    347	warehouse	0004_auto_20200129_0717	2024-05-20 11:13:05.936987+00
    348	warehouse	0005_auto_20200204_0722	2024-05-20 11:13:06.040519+00
    349	warehouse	0006_auto_20200228_0519	2024-05-20 11:13:06.165312+00
    350	giftcard	0001_initial	2024-05-20 11:13:06.328235+00
    351	order	0071_order_gift_cards	2024-05-20 11:13:06.480767+00
    352	order	0072_django_price_2	2024-05-20 11:13:06.957175+00
    353	order	0073_auto_20190829_0249	2024-05-20 11:13:07.150891+00
    354	order	0074_auto_20190930_0731	2024-05-20 11:13:07.322091+00
    355	order	0075_auto_20191006_1433	2024-05-20 11:13:07.400451+00
    356	order	0076_auto_20191018_0554	2024-05-20 11:13:07.519749+00
    357	order	0077_auto_20191118_0606	2024-05-20 11:13:07.619207+00
    358	order	0078_auto_20200221_0257	2024-05-20 11:13:08.220188+00
    359	order	0079_auto_20200304_0752	2024-05-20 11:13:08.3284+00
    360	order	0080_invoice	2024-05-20 11:13:08.450423+00
    361	order	0081_auto_20200406_0456	2024-05-20 11:13:08.558751+00
    362	warehouse	0007_auto_20200406_0341	2024-05-20 11:13:08.889198+00
    363	order	0082_fulfillmentline_stock	2024-05-20 11:13:09.040814+00
    364	order	0079_auto_20200225_0237	2024-05-20 11:13:09.091064+00
    365	order	0081_merge_20200309_0952	2024-05-20 11:13:09.09641+00
    366	order	0083_merge_20200421_0529	2024-05-20 11:13:09.101368+00
    367	order	0084_auto_20200522_0522	2024-05-20 11:13:09.153699+00
    368	discount	0004_auto_20170206_0407	2024-05-20 11:13:09.795131+00
    369	discount	0005_auto_20170919_0839	2024-05-20 11:13:09.857715+00
    370	discount	0006_auto_20171129_1004	2024-05-20 11:13:09.909729+00
    371	discount	0007_auto_20180108_0814	2024-05-20 11:13:11.235338+00
    372	discount	0008_sale_collections	2024-05-20 11:13:11.389864+00
    373	discount	0009_auto_20180719_0520	2024-05-20 11:13:11.46749+00
    374	discount	0010_auto_20180724_1251	2024-05-20 11:13:12.427955+00
    375	discount	0011_auto_20180803_0528	2024-05-20 11:13:12.606256+00
    376	discount	0012_auto_20190329_0836	2024-05-20 11:13:12.765455+00
    377	discount	0013_auto_20190618_0733	2024-05-20 11:13:13.087459+00
    378	discount	0014_auto_20190701_0402	2024-05-20 11:13:13.305323+00
    379	discount	0015_voucher_min_quantity_of_products	2024-05-20 11:13:13.788877+00
    380	discount	0016_auto_20190716_0330	2024-05-20 11:13:13.967873+00
    381	discount	0017_django_price_2	2024-05-20 11:13:14.092556+00
    382	discount	0018_auto_20190827_0315	2024-05-20 11:13:14.221752+00
    383	discount	0019_auto_20200217_0350	2024-05-20 11:13:14.356956+00
    384	payment	0003_rename_payment_method_to_payment	2024-05-20 11:13:14.860432+00
    385	payment	0004_auto_20181206_0031	2024-05-20 11:13:14.933458+00
    386	payment	0005_auto_20190104_0443	2024-05-20 11:13:14.992182+00
    387	payment	0006_auto_20190109_0358	2024-05-20 11:13:15.013774+00
    388	payment	0007_auto_20190206_0938	2024-05-20 11:13:15.042258+00
    389	payment	0007_auto_20190125_0242	2024-05-20 11:13:15.098349+00
    390	payment	0008_merge_20190214_0447	2024-05-20 11:13:15.10958+00
    391	payment	0009_convert_to_partially_charged_and_partially_refunded	2024-05-20 11:13:15.229187+00
    392	payment	0010_auto_20190220_2001	2024-05-20 11:13:15.285617+00
    393	checkout	0016_auto_20190112_0506	2024-05-20 11:13:15.338357+00
    394	checkout	0017_auto_20190130_0207	2024-05-20 11:13:15.391396+00
    395	checkout	0018_auto_20190410_0132	2024-05-20 11:13:16.653585+00
    396	checkout	0019_checkout_gift_cards	2024-05-20 11:13:16.852374+00
    397	checkout	0020_auto_20190723_0722	2024-05-20 11:13:16.959271+00
    398	checkout	0021_django_price_2	2024-05-20 11:13:17.017972+00
    399	checkout	0022_auto_20191219_1137	2024-05-20 11:13:17.071984+00
    400	checkout	0023_checkout_country	2024-05-20 11:13:17.149143+00
    401	checkout	0024_auto_20200120_0154	2024-05-20 11:13:17.208397+00
    402	checkout	0025_auto_20200221_0257	2024-05-20 11:13:17.336637+00
    403	channel	0001_initial	2024-05-20 11:13:17.609803+00
    404	shipping	0022_shipping_method_channel_listing	2024-05-20 11:13:18.010938+00
    405	product	0119_auto_20200709_1102	2024-05-20 11:13:18.161066+00
    406	product	0120_auto_20200714_0539	2024-05-20 11:13:18.700058+00
    407	product	0121_auto_20200810_1415	2024-05-20 11:13:20.625835+00
    408	product	0122_auto_20200828_1135	2024-05-20 11:13:20.821366+00
    409	product	0123_auto_20200904_1251	2024-05-20 11:13:20.98175+00
    410	product	0124_auto_20200909_0904	2024-05-20 11:13:22.009336+00
    411	product	0125_auto_20200916_1511	2024-05-20 11:13:22.116161+00
    412	product	0126_product_default_variant	2024-05-20 11:13:22.359184+00
    413	product	0127_auto_20201001_0933	2024-05-20 11:13:22.491575+00
    414	product	0128_update_publication_date	2024-05-20 11:13:22.703444+00
    415	product	0129_add_product_types_and_attributes_perm	2024-05-20 11:13:22.83417+00
    416	product	0130_create_product_description_search_vector	2024-05-20 11:13:23.092679+00
    417	product	0131_update_ts_vector_existing_product_name	2024-05-20 11:13:23.106476+00
    418	product	0130_migrate_from_draftjs_to_editorjs_format	2024-05-20 11:13:23.278316+00
    419	product	0131_auto_20201112_0904	2024-05-20 11:13:23.855539+00
    420	product	0132_product_rating	2024-05-20 11:13:23.910517+00
    421	checkout	0026_auto_20200709_1102	2024-05-20 11:13:24.560844+00
    422	checkout	0027_auto_20200810_1415	2024-05-20 11:13:24.789751+00
    423	checkout	0028_auto_20200824_1019	2024-05-20 11:13:24.924642+00
    424	checkout	0029_auto_20200904_0529	2024-05-20 11:13:25.048229+00
    425	checkout	0030_checkout_channel_listing	2024-05-20 11:13:25.514888+00
    426	product	0133_product_variant_channel_listing	2024-05-20 11:13:25.944808+00
    427	product	0134_product_channel_listing	2024-05-20 11:13:26.581721+00
    428	product	0135_collection_channel_listing	2024-05-20 11:13:27.582164+00
    429	shipping	0023_shippingmethod_excluded_products	2024-05-20 11:13:27.740691+00
    430	shipping	0024_shippingmethodzipcoderule	2024-05-20 11:13:27.922888+00
    431	shipping	0025_auto_20201130_1122	2024-05-20 11:13:28.077634+00
    432	shipping	0026_shippingzone_description	2024-05-20 11:13:28.108349+00
    433	shipping	0027_auto_20210120_2201	2024-05-20 11:13:28.4772+00
    434	shipping	0028_auto_20210308_1135	2024-05-20 11:13:28.68185+00
    435	shipping	0029_shippingzone_channels	2024-05-20 11:13:28.980483+00
    436	channel	0002_channel_default_country	2024-05-20 11:13:29.036324+00
    437	channel	0003_alter_channel_default_country	2024-05-20 11:13:29.369083+00
    438	channel	0004_create_default_channel	2024-05-20 11:13:29.564127+00
    439	channel	0005_channel_allocation_strategy	2024-05-20 11:13:29.806058+00
    440	channel	0006_order_settings_fields	2024-05-20 11:13:29.92651+00
    441	channel	0007_order_settings_per_channel	2024-05-20 11:13:30.119552+00
    442	channel	0008_update_null_order_settings	2024-05-20 11:13:30.309813+00
    443	site	0035_sitesettings_separate_state_remove_order_settings	2024-05-20 11:13:31.090003+00
    444	site	0036_remove_order_settings	2024-05-20 11:13:31.1081+00
    445	site	0037_sitesettings_enable_account_confirmation_by_email	2024-05-20 11:13:31.162466+00
    446	site	0038_auto_20230510_1107	2024-05-20 11:13:31.288932+00
    447	auth	0012_alter_user_first_name_max_length	2024-05-20 11:13:31.323578+00
    448	webhook	0001_initial	2024-05-20 11:13:31.700108+00
    449	webhook	0002_webhook_name	2024-05-20 11:13:31.73066+00
    450	account	0038_auto_20200123_0034	2024-05-20 11:13:31.86631+00
    451	account	0039_auto_20200221_0257	2024-05-20 11:13:32.042399+00
    452	core	0001_migrate_metadata	2024-05-20 11:13:34.192059+00
    453	plugins	0001_initial	2024-05-20 11:13:34.23975+00
    454	account	0040_auto_20200415_0443	2024-05-20 11:13:34.440664+00
    455	account	0041_permissions_to_groups	2024-05-20 11:13:34.604765+00
    456	account	0040_auto_20200225_0237	2024-05-20 11:13:34.702006+00
    457	account	0041_merge_20200421_0529	2024-05-20 11:13:34.709358+00
    458	account	0042_merge_20200422_0555	2024-05-20 11:13:34.716153+00
    459	account	0043_rename_service_account_to_app	2024-05-20 11:13:35.318959+00
    460	webhook	0003_unmount_service_account	2024-05-20 11:13:35.501319+00
    461	account	0044_unmount_app_and_app_token	2024-05-20 11:13:35.638673+00
    462	app	0001_initial	2024-05-20 11:13:36.730634+00
    463	app	0002_auto_20200702_0945	2024-05-20 11:14:02.850704+00
    464	app	0003_auto_20200810_1415	2024-05-20 11:14:02.904357+00
    465	app	0004_auto_20210308_1135	2024-05-20 11:14:02.950881+00
    466	app	0005_appextension	2024-05-20 11:14:03.243996+00
    467	app	0006_convert_extension_enums_into_one	2024-05-20 11:14:03.423715+00
    468	app	0007_auto_20220127_0942	2024-05-20 11:14:03.552637+00
    469	app	0008_appextension_target	2024-05-20 11:14:03.590424+00
    470	app	0009_apptoken_token_last_4	2024-05-20 11:14:03.658088+00
    471	app	0010_update_app_tokens	2024-05-20 11:14:03.858706+00
    472	app	0011_alter_apptoken_token_last_4	2024-05-20 11:14:03.882809+00
    473	app	0012_rename_created_app_created_at	2024-05-20 11:14:03.925679+00
    474	app	0013_alter_appextension_mount	2024-05-20 11:14:03.964312+00
    475	app	0014_alter_app_options	2024-05-20 11:14:04.118193+00
    476	app	0015_app_manifest_url	2024-05-20 11:14:04.153424+00
    477	app	0016_alter_appextension_mount	2024-05-20 11:14:04.180603+00
    478	app	0017_app_audience	2024-05-20 11:14:04.209434+00
    479	webhook	0004_mount_app	2024-05-20 11:14:04.417611+00
    480	plugins	0002_auto_20200417_0335	2024-05-20 11:14:04.636957+00
    481	account	0045_auto_20200427_0425	2024-05-20 11:14:05.286418+00
    482	webhook	0005_drop_manage_webhooks_permission	2024-05-20 11:14:05.43585+00
    483	payment	0011_auto_20190516_0901	2024-05-20 11:14:05.468822+00
    484	payment	0012_transaction_customer_id	2024-05-20 11:14:05.504891+00
    485	payment	0013_auto_20190813_0735	2024-05-20 11:14:05.534716+00
    486	payment	0014_django_price_2	2024-05-20 11:14:05.713599+00
    487	payment	0015_auto_20200203_1116	2024-05-20 11:14:05.857227+00
    488	payment	0016_auto_20200423_0314	2024-05-20 11:14:05.994358+00
    489	payment	0017_payment_payment_method_type	2024-05-20 11:14:06.064255+00
    490	payment	0018_auto_20200810_1415	2024-05-20 11:14:06.101677+00
    491	payment	0019_auto_20200812_1101	2024-05-20 11:14:06.337992+00
    492	payment	0020_auto_20200902_1249	2024-05-20 11:14:06.634648+00
    493	payment	0021_transaction_searchable_key	2024-05-20 11:14:06.676519+00
    494	payment	0022_auto_20201104_1458	2024-05-20 11:14:06.810297+00
    495	payment	0023_auto_20201110_0834	2024-05-20 11:14:06.836876+00
    496	payment	0024_auto_20210326_0837	2024-05-20 11:14:06.884676+00
    497	payment	0025_auto_20210506_0750	2024-05-20 11:14:07.030105+00
    498	payment	0026_payment_psp_reference	2024-05-20 11:14:07.135836+00
    499	payment	0027_assign_psp_reference_values	2024-05-20 11:14:07.286947+00
    500	payment	0028_drop_searchable_key	2024-05-20 11:14:07.326711+00
    501	payment	0029_alter_payment_options	2024-05-20 11:14:07.591951+00
    502	payment	0030_payment_partial	2024-05-20 11:14:07.694898+00
    503	payment	0030_auto_20210908_1346	2024-05-20 11:14:08.170286+00
    504	payment	0031_merge_0030_auto_20210908_1346_0030_payment_partial	2024-05-20 11:14:08.176239+00
    505	page	0002_auto_20180321_0417	2024-05-20 11:14:08.202454+00
    506	page	0003_auto_20180719_0520	2024-05-20 11:14:08.218259+00
    507	page	0004_auto_20180803_0528	2024-05-20 11:14:08.420926+00
    508	page	0005_auto_20190208_0456	2024-05-20 11:14:08.463263+00
    509	page	0006_auto_20190220_1928	2024-05-20 11:14:08.483879+00
    510	page	0007_auto_20190225_0252	2024-05-20 11:14:08.551844+00
    511	page	0008_raw_html_to_json	2024-05-20 11:14:09.302649+00
    512	page	0009_auto_20191108_0402	2024-05-20 11:14:09.321755+00
    513	page	0010_auto_20200129_0717	2024-05-20 11:14:09.35977+00
    514	page	0011_auto_20200217_0350	2024-05-20 11:14:09.375468+00
    515	page	0012_auto_20200709_1102	2024-05-20 11:14:09.396281+00
    516	page	0013_update_publication_date	2024-05-20 11:14:09.565133+00
    517	page	0014_add_metadata	2024-05-20 11:14:09.607003+00
    518	page	0015_migrate_from_draftjs_to_editorjs_format	2024-05-20 11:14:09.790096+00
    519	page	0016_auto_20201112_0904	2024-05-20 11:14:09.823699+00
    520	page	0017_pagetype	2024-05-20 11:14:10.492245+00
    521	product	0136_add_attribute_type_and_page_to_attribute_relation	2024-05-20 11:14:12.078517+00
    522	attribute	0001_initial	2024-05-20 11:14:15.05069+00
    523	product	0137_drop_attribute_models	2024-05-20 11:14:19.853803+00
    524	product	0138_migrate_description_json_into_description	2024-05-20 11:14:20.980913+00
    525	product	0139_description_vector_search	2024-05-20 11:14:20.998506+00
    526	product	0140_auto_20210125_0905	2024-05-20 11:14:21.263+00
    527	product	0141_update_descritpion_fields	2024-05-20 11:14:22.368132+00
    528	product	0142_auto_20210308_1135	2024-05-20 11:14:22.818483+00
    529	product	0143_rename_product_images_to_product_media	2024-05-20 11:14:24.616715+00
    530	product	0144_auto_20210318_1155	2024-05-20 11:14:24.683757+00
    531	product	0145_auto_20210511_1043	2024-05-20 11:14:24.770526+00
    532	product	0146_auto_20210518_0945	2024-05-20 11:14:24.883363+00
    533	product	0147_auto_20210817_1015	2024-05-20 11:14:25.065736+00
    534	product	0148_producttype_type	2024-05-20 11:14:25.095053+00
    535	order	0085_delete_invoice	2024-05-20 11:14:25.114525+00
    536	order	0086_auto_20200716_1226	2024-05-20 11:14:25.192644+00
    537	order	0087_auto_20200810_1415	2024-05-20 11:14:25.523135+00
    538	order	0088_auto_20200812_1101	2024-05-20 11:14:25.600297+00
    539	order	0089_auto_20200902_1249	2024-05-20 11:14:26.647224+00
    540	order	0090_order_channel_listing	2024-05-20 11:14:27.433354+00
    541	order	0091_order_redirect_url	2024-05-20 11:14:27.553835+00
    542	order	0092_order_unconfirmed	2024-05-20 11:14:27.752606+00
    543	order	0093_auto_20201130_1406	2024-05-20 11:14:28.556801+00
    544	order	0094_auto_20201221_1128	2024-05-20 11:14:29.025266+00
    545	order	0095_auto_20201229_1014	2024-05-20 11:14:29.166503+00
    546	order	0096_order_shipping_tax_rate	2024-05-20 11:14:29.313123+00
    547	order	0097_auto_20210107_1148	2024-05-20 11:14:29.561598+00
    548	discount	0020_auto_20200709_1102	2024-05-20 11:14:29.633012+00
    549	order	0095_auto_20201229_1014	2024-05-20 11:14:29.742446+00
    550	discount	0021_auto_20200902_1249	2024-05-20 11:14:29.896417+00
    551	discount	0022_sale_channel_listing	2024-05-20 11:14:30.36017+00
    552	discount	0023_voucher_channel_listing	2024-05-20 11:14:31.072481+00
    553	discount	0024_orderdiscount	2024-05-20 11:14:31.881694+00
    554	order	0098_discounts_relation	2024-05-20 11:14:32.737142+00
    555	order	0099_auto_20210209_0856	2024-05-20 11:14:33.023199+00
    556	order	0100_auto_20210216_0914	2024-05-20 11:14:33.102229+00
    557	order	0101_auto_20210308_1213	2024-05-20 11:14:33.463688+00
    558	order	0102_auto_20210310_1552	2024-05-20 11:14:33.578709+00
    559	order	0103_auto_20210401_1105	2024-05-20 11:14:33.824636+00
    560	order	0104_auto_20210506_0835	2024-05-20 11:14:33.93188+00
    561	order	0105_order_total_paid_amount	2024-05-20 11:14:34.667837+00
    562	order	0106_origin_and_original	2024-05-20 11:14:34.954901+00
    563	order	0107_set_origin_and_original_values	2024-05-20 11:14:35.124188+00
    564	order	0108_origin_not_null	2024-05-20 11:14:35.222526+00
    565	order	0109_undiscounted_prices	2024-05-20 11:14:35.649327+00
    566	order	0110_auto_20210518_0918	2024-05-20 11:14:35.794576+00
    567	order	0111_auto_20210518_1357	2024-05-20 11:14:35.937913+00
    568	order	0112_auto_20210616_0548	2024-05-20 11:14:36.026638+00
    569	order	0113_orderevent_app	2024-05-20 11:14:36.214626+00
    570	order	0114_auto_20210722_1146	2024-05-20 11:14:36.352603+00
    571	order	0114_alter_order_language_code	2024-05-20 11:14:36.451715+00
    572	order	0115_merge_20210820_1454	2024-05-20 11:14:36.457666+00
    573	warehouse	0008_auto_20200430_0239	2024-05-20 11:14:36.609053+00
    574	warehouse	0009_remove_invalid_allocation	2024-05-20 11:14:36.757814+00
    575	warehouse	0010_auto_20200709_1102	2024-05-20 11:14:36.847611+00
    576	warehouse	0011_auto_20200714_0539	2024-05-20 11:14:36.952581+00
    577	warehouse	0012_auto_20210115_1307	2024-05-20 11:14:37.585896+00
    578	warehouse	0013_auto_20210308_1135	2024-05-20 11:14:37.721238+00
    579	warehouse	0014_remove_warehouse_company_name	2024-05-20 11:14:38.045668+00
    580	warehouse	0015_auto_20210713_0904	2024-05-20 11:14:38.177174+00
    581	order	0114_auto_20210726_1116	2024-05-20 11:14:38.425171+00
    582	order	0116_merge_20210824_1103	2024-05-20 11:14:38.431748+00
    583	order	0115_alter_order_language_code	2024-05-20 11:14:38.525638+00
    584	order	0117_merge_20210903_1013	2024-05-20 11:14:38.533744+00
    585	order	0118_auto_20210913_0731	2024-05-20 11:14:38.687502+00
    586	order	0119_orderline_is_gift_card	2024-05-20 11:14:38.997384+00
    587	order	0120_orderline_optional_sku	2024-05-20 11:14:39.145467+00
    588	order	0121_order_search_document	2024-05-20 11:14:39.535369+00
    589	order	0116_auto_20211207_0705	2024-05-20 11:14:39.682105+00
    590	order	0122_merge_20211220_1641	2024-05-20 11:14:39.692102+00
    591	order	0123_update_order_search_document	2024-05-20 11:14:39.883474+00
    592	order	0124_order_updated_at	2024-05-20 11:14:40.469631+00
    593	order	0125_populate_order_updated_at	2024-05-20 11:14:40.493652+00
    594	order	0126_alter_order_updated_at	2024-05-20 11:14:40.60537+00
    595	order	0127_add_order_number_and_alter_order_token	2024-05-20 11:14:41.077909+00
    596	order	0128_set_order_number	2024-05-20 11:14:41.273594+00
    597	order	0129_alter_order_number	2024-05-20 11:14:41.521629+00
    598	payment	0032_save_payment_order_token	2024-05-20 11:14:41.757116+00
    599	order	0130_save_order_token_in_relation_models	2024-05-20 11:14:42.816831+00
    600	invoice	0001_initial	2024-05-20 11:14:43.816906+00
    601	invoice	0002_invoice_message	2024-05-20 11:14:43.920505+00
    602	invoice	0003_auto_20200713_1311	2024-05-20 11:14:43.997542+00
    603	invoice	0004_auto_20200810_1415	2024-05-20 11:14:44.281646+00
    604	invoice	0005_auto_20210308_1135	2024-05-20 11:14:44.405108+00
    605	invoice	0006_invoiceevent_app	2024-05-20 11:14:44.588524+00
    606	invoice	0007_save_invoice_order_token	2024-05-20 11:14:45.102847+00
    607	product	0148_producttype_product_type_search_gin	2024-05-20 11:14:45.130726+00
    608	product	0149_auto_20211004_1636	2024-05-20 11:14:45.34728+00
    609	product	0150_collection_collection_search_gin	2024-05-20 11:14:45.403135+00
    610	discount	0025_auto_20210506_0831	2024-05-20 11:14:45.470305+00
    611	discount	0026_voucher_only_for_staff	2024-05-20 11:14:45.532157+00
    612	discount	0027_auto_20210719_2155	2024-05-20 11:14:45.757548+00
    613	discount	0028_auto_20210817_1015	2024-05-20 11:14:45.841293+00
    614	discount	0030_discount_variants	2024-05-20 11:14:46.756462+00
    615	discount	0028_alter_voucher_code	2024-05-20 11:14:46.763542+00
    616	discount	0029_merge_0028_alter_voucher_code_0028_auto_20210817_1015	2024-05-20 11:14:46.773807+00
    617	discount	0031_merge_20211020_1019	2024-05-20 11:14:46.784853+00
    618	discount	0029_alter_voucher_code	2024-05-20 11:14:46.868938+00
    619	discount	0031_merge_0029_alter_voucher_code_0030_discount_variants	2024-05-20 11:14:46.876597+00
    620	discount	0032_merge_20211109_1210	2024-05-20 11:14:46.883892+00
    621	discount	0033_auto_20220209_1543	2024-05-20 11:14:47.030819+00
    622	discount	0034_populate_sales_datetimes	2024-05-20 11:14:47.203349+00
    623	discount	0035_auto_20220209_1544	2024-05-20 11:14:47.334336+00
    624	discount	0036_save_discocunt_order_token	2024-05-20 11:14:47.583964+00
    625	account	0046_user_jwt_token_key	2024-05-20 11:14:47.650421+00
    626	account	0047_auto_20200810_1415	2024-05-20 11:14:47.870517+00
    627	account	0048_auto_20210308_1135	2024-05-20 11:14:48.019556+00
    628	account	0049_user_language_code	2024-05-20 11:14:48.095998+00
    629	account	0050_auto_20210506_1058	2024-05-20 11:14:48.156499+00
    630	account	0051_alter_customerevent_user	2024-05-20 11:14:48.336816+00
    631	account	0052_customerevent_app	2024-05-20 11:14:48.518073+00
    632	account	0053_auto_20210719_1048	2024-05-20 11:14:48.922384+00
    633	account	0054_alter_user_language_code	2024-05-20 11:14:49.008956+00
    634	account	0055_alter_user_options	2024-05-20 11:14:49.762501+00
    635	account	0055_alter_user_language_code	2024-05-20 11:14:49.82248+00
    636	account	0056_merge_20210903_0640	2024-05-20 11:14:49.829098+00
    637	account	0057_user_search_document	2024-05-20 11:14:50.08686+00
    638	account	0058_update_user_search_document	2024-05-20 11:14:50.231012+00
    639	account	0057_clear_user_addresses	2024-05-20 11:14:50.421162+00
    640	account	0059_merge_20220221_1025	2024-05-20 11:14:50.429406+00
    641	account	0060_user_updated_at	2024-05-20 11:14:50.512714+00
    642	account	0061_populate_user_updated_at	2024-05-20 11:14:50.673967+00
    643	account	0062_alter_user_updated_at	2024-05-20 11:14:50.745982+00
    644	account	0063_save_customerevent_order_token	2024-05-20 11:14:51.006101+00
    645	order	0131_change_pk_to_uuid	2024-05-20 11:14:51.284975+00
    646	account	0064_rewrite_customerevent_order_relation	2024-05-20 11:14:52.448375+00
    647	account	0065_address_warehouse_address_search_gin	2024-05-20 11:14:52.506685+00
    648	account	0066_alter_user_avatar	2024-05-20 11:14:52.602616+00
    649	account	0066_alter_customerevent_type	2024-05-20 11:14:52.702752+00
    650	account	0067_merge_20220715_1400	2024-05-20 11:14:52.709306+00
    651	account	0068_user_uuid	2024-05-20 11:14:52.786318+00
    652	account	0069_auto_20220823_0748	2024-05-20 11:14:52.93296+00
    653	account	0070_alter_user_uuid	2024-05-20 11:14:53.013335+00
    654	account	0071_user_external_reference	2024-05-20 11:14:53.101239+00
    655	account	0072_group	2024-05-20 11:14:53.491401+00
    656	permission	0001_initial	2024-05-20 11:14:53.835379+00
    657	app	0018_auto_20221122_1148	2024-05-20 11:14:54.345333+00
    658	account	0073_alter_group_permissions	2024-05-20 11:14:55.313318+00
    659	account	0063_user_user_p_meta_jsonb_path_idx	2024-05-20 11:14:55.374829+00
    660	account	0065_merge_20221227_1254	2024-05-20 11:14:55.383999+00
    661	account	0066_merge_20221227_1315	2024-05-20 11:14:55.392841+00
    662	account	0071_merge_0066_merge_20221227_1315_0070_alter_user_uuid	2024-05-20 11:14:55.402562+00
    663	account	0072_merge_20221227_1353	2024-05-20 11:14:55.410383+00
    664	account	0074_merge_20230102_0914	2024-05-20 11:14:55.417451+00
    665	account	0075_add_address_metadata	2024-05-20 11:14:55.60669+00
    666	account	0064_user_last_password_reset_request	2024-05-20 11:14:55.663966+00
    667	account	0072_merge_20230221_0956	2024-05-20 11:14:55.670838+00
    668	account	0076_merge_20230221_1002	2024-05-20 11:14:55.676766+00
    669	account	0076_fill_empty_passwords	2024-05-20 11:14:55.834535+00
    670	account	0077_merge_20230310_1107	2024-05-20 11:14:55.841415+00
    671	account	0078_add_group_channels_conf	2024-05-20 11:14:56.113775+00
    672	account	0079_full_channel_access_group_for_openid	2024-05-20 11:14:56.272257+00
    673	account	0080_user_is_confirmed	2024-05-20 11:14:56.350089+00
    674	account	0081_update_user_is_confirmed	2024-05-20 11:14:56.510729+00
    675	account	0082_user_last_confirm_email_request	2024-05-20 11:14:56.573822+00
    676	account	0082_auto_20231204_1419	2024-05-20 11:14:56.610397+00
    677	account	0083_merge_20231205_1315	2024-05-20 11:14:56.617125+00
    678	account	0083_confirm_active_user	2024-05-20 11:14:56.781265+00
    679	account	0084_merge_20240229_1435	2024-05-20 11:14:56.787558+00
    680	payment	0033_rewrite_payment_order_relations	2024-05-20 11:14:57.928975+00
    681	payment	0034_auto_20220414_1051	2024-05-20 11:14:58.10718+00
    682	order	0132_rewrite_order_relations	2024-05-20 11:15:01.156623+00
    683	order	0133_rename_order_token_id	2024-05-20 11:15:01.458971+00
    684	order	0134_rewrite_order_gift_cards_relation	2024-05-20 11:15:01.475281+00
    685	order	0135_alter_order_options	2024-05-20 11:15:01.583731+00
    686	order	0136_auto_20220414_1025	2024-05-20 11:15:01.765273+00
    687	order	0137_alter_orderevent_type	2024-05-20 11:15:01.856604+00
    688	product	0149_alter_productvariant_sku	2024-05-20 11:15:02.047798+00
    689	product	0150_auto_20211001_1004	2024-05-20 11:15:02.317702+00
    690	product	0151_merge_20211004_1344	2024-05-20 11:15:02.325594+00
    691	product	0152_merge_20211005_1324	2024-05-20 11:15:02.330949+00
    692	product	0153_merge_20211006_0910	2024-05-20 11:15:02.336291+00
    693	product	0154_productvariant_quantity_limit_per_customer	2024-05-20 11:15:02.39949+00
    694	product	0151_productchannellisting_product_pro_discoun_3145f3_btree	2024-05-20 11:15:02.487244+00
    695	product	0155_merge_20211208_1108	2024-05-20 11:15:02.493139+00
    696	product	0156_product_search_document	2024-05-20 11:15:03.208717+00
    697	product	0157_update_product_search_document	2024-05-20 11:15:03.216123+00
    698	product	0158_auto_20220120_1633	2024-05-20 11:15:03.376962+00
    699	product	0159_auto_20220209_1501	2024-05-20 11:15:03.696275+00
    700	checkout	0031_auto_20210303_1045	2024-05-20 11:15:03.90257+00
    701	checkout	0032_auto_20210308_1135	2024-05-20 11:15:04.16112+00
    702	checkout	0033_checkout_language_code	2024-05-20 11:15:04.297305+00
    703	checkout	0034_remove_checkout_quantity	2024-05-20 11:15:04.430891+00
    704	checkout	0035_alter_checkout_language_code	2024-05-20 11:15:04.559264+00
    705	checkout	0036_alter_checkout_language_code	2024-05-20 11:15:04.652716+00
    706	checkout	0037_remove_empty_lines	2024-05-20 11:15:04.808358+00
    707	checkout	0035_checkout_collection_point	2024-05-20 11:15:05.004625+00
    708	checkout	0036_merge_20210824_1103	2024-05-20 11:15:05.011996+00
    709	checkout	0037_merge_20210903_1013	2024-05-20 11:15:05.025458+00
    710	checkout	0038_merge_20210903_1048	2024-05-20 11:15:05.033364+00
    711	checkout	0039_alter_checkout_email	2024-05-20 11:15:05.135622+00
    712	checkout	0040_add_handle_checkouts_permission	2024-05-20 11:15:05.364321+00
    713	checkout	0041_checkoutline_price_override	2024-05-20 11:15:05.466204+00
    714	checkout	0042_rename_created_checkout_created_at	2024-05-20 11:15:05.554761+00
    715	payment	0035_auto_20220421_0615	2024-05-20 11:15:06.770789+00
    716	payment	0036_auto_20220518_0732	2024-05-20 11:15:07.228738+00
    717	payment	0037_alter_transaction_error	2024-05-20 11:15:07.266599+00
    718	app	0019_fix_constraint_names_in_app_app_permisons	2024-05-20 11:15:07.291272+00
    719	payment	0038_auto_20230223_0926	2024-05-20 11:15:09.874748+00
    720	payment	0039_transactionevent_currency	2024-05-20 11:15:10.030916+00
    721	payment	0040_migrate_renamed_fields	2024-05-20 11:15:10.190239+00
    722	payment	0041_add_calculation_transaction_events	2024-05-20 11:15:10.405151+00
    723	payment	0042_alter_transactionitem_available_actions	2024-05-20 11:15:10.505775+00
    724	payment	0043_drop_from_state_renamed_fields	2024-05-20 11:15:11.654869+00
    725	payment	0044_transactionevent_currency	2024-05-20 11:15:11.843806+00
    726	payment	0045_alter_transactionevent_currency	2024-05-20 11:15:11.913151+00
    727	payment	0046_alter_transactionevent_type	2024-05-20 11:15:11.982326+00
    728	payment	0042_auto_20230320_1252	2024-05-20 11:15:12.207233+00
    729	payment	0043_populate_transaction_item_token	2024-05-20 11:15:12.385157+00
    730	payment	0047_merge_20230321_1456	2024-05-20 11:15:12.391299+00
    731	payment	0048_populate_transaction_item_token	2024-05-20 11:15:12.554566+00
    732	payment	0049_auto_20230322_0634	2024-05-20 11:15:12.754326+00
    733	payment	0050_drop_unused_transaction_fields	2024-05-20 11:15:12.790567+00
    734	payment	0051_alter_transactionitem_available_actions	2024-05-20 11:15:13.0776+00
    735	payment	0052_transactionitem_last_refund_success	2024-05-20 11:15:13.185988+00
    736	payment	0053_auto_20231211_0850	2024-05-20 11:15:13.327583+00
    737	payment	0054_add_idempotency_key_indexes	2024-05-20 11:15:13.380075+00
    738	payment	0055_add_constraints_from_indexes	2024-05-20 11:15:13.545689+00
    739	app	0020_app_is_installed	2024-05-20 11:15:13.583175+00
    740	app	0021_app_author	2024-05-20 11:15:13.620827+00
    741	app	0022_auto_20230410_0859	2024-05-20 11:15:13.708819+00
    742	app	0023_populate_app_and_app_installation_uuid	2024-05-20 11:15:13.889734+00
    743	app	0024_auto_20230412_1343	2024-05-20 11:15:14.453458+00
    744	app	0025_auto_20230420_1544	2024-05-20 11:15:14.530464+00
    745	app	0026_app_removed_at	2024-05-20 11:15:14.570938+00
    746	app	0027_set_identifier_when_missing	2024-05-20 11:15:15.029343+00
    747	app	0028_set_identifier	2024-05-20 11:15:15.51976+00
    748	app	0029_alter_app_identifier	2024-05-20 11:15:15.566872+00
    749	page	0018_migrate_content_json_into_content	2024-05-20 11:15:16.173998+00
    750	page	0019_auto_20210125_0905	2024-05-20 11:15:16.221209+00
    751	page	0020_update_content_fields	2024-05-20 11:15:17.057069+00
    752	page	0021_auto_20210308_1135	2024-05-20 11:15:17.113796+00
    753	page	0022_alter_pagetranslation_title	2024-05-20 11:15:17.139231+00
    754	page	0023_auto_20210526_0835	2024-05-20 11:15:17.184304+00
    755	page	0024_alter_pagetranslation_language_code	2024-05-20 11:15:17.224023+00
    756	page	0025_rename_created_page_created_at	2024-05-20 11:15:17.441008+00
    757	page	0026_alter_page_publication_date	2024-05-20 11:15:17.843496+00
    758	page	0027_alter_page_created_at	2024-05-20 11:15:18.040494+00
    759	page	0028_add_default_page_type	2024-05-20 11:15:18.211558+00
    760	webhook	0006_auto_20200731_1440	2024-05-20 11:15:18.248443+00
    761	webhook	0007_auto_20210319_0945	2024-05-20 11:15:18.286138+00
    762	webhook	0008_webhook_subscription_query	2024-05-20 11:15:18.321837+00
    763	tax	0001_initial	2024-05-20 11:15:18.881498+00
    764	plugins	0003_auto_20200429_0142	2024-05-20 11:15:19.072662+00
    765	plugins	0004_drop_support_for_env_vatlayer_access_key	2024-05-20 11:15:19.267495+00
    766	plugins	0005_auto_20200810_1415	2024-05-20 11:15:19.295858+00
    767	plugins	0006_auto_20200909_1253	2024-05-20 11:15:19.32301+00
    768	plugins	0007_add_user_emails_configuration	2024-05-20 11:15:20.088113+00
    769	plugins	0008_pluginconfiguration_channel	2024-05-20 11:15:20.838429+00
    770	plugins	0009_emailtemplate	2024-05-20 11:15:21.045546+00
    771	plugins	0010_auto_20220104_1239	2024-05-20 11:15:21.280369+00
    772	tax	0002_add_default_tax_configs	2024-05-20 11:15:21.718842+00
    773	tax	0003_add_manage_taxes_permission	2024-05-20 11:15:21.90741+00
    774	product	0160_populate_product_datetimes	2024-05-20 11:15:22.088618+00
    775	product	0161_auto_20220209_1511	2024-05-20 11:15:23.356092+00
    776	product	0162_auto_20220228_1233	2024-05-20 11:15:23.72383+00
    777	product	0163_auto_20220414_1025	2024-05-20 11:15:24.087377+00
    778	product	0164_auto_20220311_1430	2024-05-20 11:15:24.208492+00
    779	product	0165_update_product_search_document	2024-05-20 11:15:24.215472+00
    780	product	0166_update_publication_date_and_available_for_purchase	2024-05-20 11:15:25.067298+00
    781	product	0167_digitalcontenturl_order_line_token	2024-05-20 11:15:25.099426+00
    782	order	0138_add_orderline_token_old_id_created_at	2024-05-20 11:15:25.86399+00
    783	order	0139_fulfil_orderline_token_old_id_created_at	2024-05-20 11:15:26.078865+00
    784	order	0140_alter_orderline_old_id_and_created_at	2024-05-20 11:15:26.270771+00
    785	product	0168_fulfil_digitalcontenturl_orderline_token	2024-05-20 11:15:26.283356+00
    786	product	0169_alter_digitalcontenturl_line	2024-05-20 11:15:26.50551+00
    787	warehouse	0015_alter_stock_quantity	2024-05-20 11:15:26.610392+00
    788	warehouse	0016_merge_20210921_1036	2024-05-20 11:15:26.616499+00
    789	warehouse	0017_preorderallocation	2024-05-20 11:15:26.883013+00
    790	warehouse	0018_auto_20210323_2116	2024-05-20 11:15:27.219023+00
    791	warehouse	0019_auto_20211019_1438	2024-05-20 11:15:27.547461+00
    792	warehouse	0016_stock_quantity_allocated	2024-05-20 11:15:27.827741+00
    793	warehouse	0020_merge_20220217_1316	2024-05-20 11:15:27.835339+00
    794	warehouse	0021_allocation_order_line_token	2024-05-20 11:15:27.892439+00
    795	warehouse	0022_fulfil_allocation_order_line_token	2024-05-20 11:15:27.910452+00
    796	warehouse	0023_alter_orderline_relations	2024-05-20 11:15:28.854348+00
    797	order	0141_fulfil_fulfillmentline_orderline_token	2024-05-20 11:15:28.871821+00
    798	order	0142_alter_fulfillmentline_line	2024-05-20 11:15:29.109936+00
    799	order	0143_update_orderline_pk	2024-05-20 11:15:29.561542+00
    800	product	0170_rewrite_digitalcontenturl_orderline_relation	2024-05-20 11:15:30.182655+00
    801	thumbnail	0001_initial	2024-05-20 11:15:30.459315+00
    802	warehouse	0024_rewrite_order_line_relations	2024-05-20 11:15:32.36174+00
    803	warehouse	0025_add_checkout_line_token	2024-05-20 11:15:32.430759+00
    804	checkout	0043_add_token_old_id_created_at_to_checkout_line	2024-05-20 11:15:32.735963+00
    805	checkout	0044_fulfill_checkout_line_new_fields	2024-05-20 11:15:32.978695+00
    806	warehouse	0026_fulfill_checkout_line_token_fields	2024-05-20 11:15:32.999811+00
    807	warehouse	0027_alter_reservation_models_checkout_line	2024-05-20 11:15:33.40981+00
    808	checkout	0045_alter_checkoutline_created_at	2024-05-20 11:15:33.522167+00
    809	checkout	0046_alter_checkout_line_pk	2024-05-20 11:15:33.957218+00
    810	warehouse	0028_rewrite_checkouline_relations	2024-05-20 11:15:35.688788+00
    811	warehouse	0029_warehouse_channels	2024-05-20 11:15:35.937342+00
    812	warehouse	0030_add_channels_to_warehouses	2024-05-20 11:15:36.21556+00
    813	warehouse	0031_create_default_warehouse	2024-05-20 11:15:36.440912+00
    814	product	0171_product_search_index_dirty	2024-05-20 11:15:37.234431+00
    815	product	0171_alter_versatile_images	2024-05-20 11:15:37.885682+00
    816	product	0172_merge_20220802_0817	2024-05-20 11:15:37.895965+00
    817	product	0173_create_default_category_and_product_type	2024-05-20 11:15:38.332701+00
    818	product	0174_drop_media_to_remove	2024-05-20 11:15:38.52773+00
    819	product	0175_alter_productmedia_product	2024-05-20 11:15:38.745689+00
    820	product	0172_alter_product_search_index_dirty	2024-05-20 11:15:38.951844+00
    821	product	0174_merge_20221007_1322	2024-05-20 11:15:38.958843+00
    822	product	0176_merge_20221007_1324	2024-05-20 11:15:38.965104+00
    823	product	0177_product_tax_class_producttype_tax_class	2024-05-20 11:15:39.984245+00
    824	tax	0004_migrate_tax_classes	2024-05-20 11:15:40.358461+00
    825	product	0178_product_external_reference	2024-05-20 11:15:40.455772+00
    826	product	0179_productvariant_external_reference	2024-05-20 11:15:40.54353+00
    827	product	0180_productmedia_metadata	2024-05-20 11:15:40.764862+00
    828	product	0178_fix_description_plaintext_field	2024-05-20 11:15:40.948739+00
    829	product	0180_merge_20230417_1143	2024-05-20 11:15:40.95627+00
    830	product	0181_merge_20230417_1323	2024-05-20 11:15:40.964381+00
    831	product	0182_productvariantchannellisting_discounted_price_amount	2024-05-20 11:15:41.064463+00
    832	product	0183_calculate_discounted_prices	2024-05-20 11:15:41.275779+00
    833	product	0184_product_product_gin	2024-05-20 11:15:41.382831+00
    834	product	0185_unmount_product_charge_taxes	2024-05-20 11:15:41.744623+00
    835	product	0186_remove_product_charge_taxes	2024-05-20 11:15:41.762975+00
    836	attribute	0002_auto_20201030_1141	2024-05-20 11:15:42.185585+00
    837	attribute	0003_auto_20201113_1149	2024-05-20 11:15:42.320895+00
    838	attribute	0004_auto_20201204_1325	2024-05-20 11:15:42.367947+00
    839	attribute	0005_add_assignedattributevalues	2024-05-20 11:15:45.735792+00
    840	attribute	0006_auto_20210105_1031	2024-05-20 11:15:45.775763+00
    841	attribute	0007_auto_20210308_1135	2024-05-20 11:15:45.826381+00
    842	attribute	0008_auto_20210407_0632	2024-05-20 11:15:45.930092+00
    843	attribute	0009_auto_20210421_0552	2024-05-20 11:15:46.112752+00
    844	attribute	0010_auto_20210412_0736	2024-05-20 11:15:46.174994+00
    845	attribute	0011_update_values_file_urls	2024-05-20 11:15:46.386838+00
    846	attribute	0011_attributevalue_attribute_a_name_9f3448_gin	2024-05-20 11:15:46.426017+00
    847	attribute	0012_merge_20210608_1034	2024-05-20 11:15:46.432125+00
    848	attribute	0013_auto_20210609_2245	2024-05-20 11:15:46.497732+00
    849	attribute	0014_auto_20210619_1836	2024-05-20 11:15:46.546785+00
    850	attribute	0015_auto_20210817_1015	2024-05-20 11:15:46.6109+00
    851	attribute	0016_auto_20210827_0938	2024-05-20 11:15:46.682616+00
    852	attribute	0017_auto_20210811_0701	2024-05-20 11:15:46.901739+00
    853	attribute	0018_attributevariant_variant_selection	2024-05-20 11:15:47.177287+00
    854	attribute	0019_auto_20220214_1025	2024-05-20 11:15:47.568115+00
    855	attribute	0020_auto_20220214_1027	2024-05-20 11:15:48.210002+00
    856	attribute	0021_auto_20220406_1713	2024-05-20 11:15:48.397596+00
    857	attribute	0022_plain_text_attribute	2024-05-20 11:15:48.505425+00
    858	attribute	0023_lstrip_slash_from_value_file_url	2024-05-20 11:15:48.751204+00
    859	attribute	0022_attribute_value_translations_propagate_names	2024-05-20 11:15:48.965918+00
    860	attribute	0024_merge_20221018_1100	2024-05-20 11:15:48.973128+00
    861	attribute	0025_attribute_value_translations_propagate_names	2024-05-20 11:15:49.215458+00
    862	attribute	0023_extend_reference_attr_with_variant	2024-05-20 11:15:49.465307+00
    863	attribute	0024_merge_20221018_0714	2024-05-20 11:15:49.481533+00
    864	attribute	0026_merge_20221019_0937	2024-05-20 11:15:49.501649+00
    865	attribute	0027_auto_20221205_1650	2024-05-20 11:15:49.645809+00
    866	attribute	0028_attribute_attribute_gin	2024-05-20 11:15:49.688968+00
    867	attribute	0029_alter_attribute_unit	2024-05-20 11:15:49.726902+00
    868	attribute	0030_assignedproductattributevalue_product	2024-05-20 11:15:49.919409+00
    869	attribute	0031_extend_attributr_value_fields_length	2024-05-20 11:15:50.166621+00
    870	attribute	0032_assignedpageattributevalue_page_add_field	2024-05-20 11:15:50.794646+00
    871	attribute	0033_assignedpageattributevalue_page_add_index	2024-05-20 11:15:50.851133+00
    872	attribute	0034_assignedpageattributevalue_page_data_migration	2024-05-20 11:15:51.061107+00
    873	attribute	0035_assignedproductattributevalue_product_add_index	2024-05-20 11:15:51.151516+00
    874	attribute	0036_assignedproductattributevalue_product_data_migration	2024-05-20 11:15:51.339524+00
    875	attribute	0037_remove_assignedpageattribute	2024-05-20 11:15:52.571431+00
    876	attribute	0038_remove_assignedproductattribute	2024-05-20 11:15:54.337111+00
    877	attribute	0029_attribute_max_sort_order	2024-05-20 11:15:54.36821+00
    878	attribute	0030_merge_20231110_1243	2024-05-20 11:15:54.379013+00
    879	attribute	0037_merge_20231113_1050	2024-05-20 11:15:54.38776+00
    880	attribute	0039_merge_20231113_1132	2024-05-20 11:15:54.398362+00
    881	attribute	0040_clear_assignedattributes	2024-05-20 11:15:54.46638+00
    882	auth	0013_auto_20221214_1224	2024-05-20 11:15:54.512531+00
    883	channel	0009_channel_order_mark_as_paid_strategy	2024-05-20 11:15:54.577566+00
    884	channel	0010_channel_default_transaction_flow_strategy	2024-05-20 11:15:54.650217+00
    885	channel	0011_channel_expire_orders_after	2024-05-20 11:15:54.70279+00
    886	channel	0012_channel_delete_expired_orders_after	2024-05-20 11:15:54.773076+00
    887	channel	0013_auto_20230630_1039	2024-05-20 11:15:54.893771+00
    888	channel	0014_channel_allow_to_create_order_without_payment	2024-05-20 11:15:54.956292+00
    889	channel	0015_channel_use_legacy_error_flow_for_checkout	2024-05-20 11:15:55.030383+00
    890	channel	0016_auto_20230816_1209	2024-05-20 11:15:55.169187+00
    891	channel	0017_channel_include_draft_order_in_voucher_usage	2024-05-20 11:15:55.252233+00
    892	checkout	0043_alter_checkout_voucher_code	2024-05-20 11:15:55.377273+00
    893	checkout	0047_merge_20220519_1029	2024-05-20 11:15:55.384107+00
    894	checkout	0048_alter_checkoutline_options	2024-05-20 11:15:55.493437+00
    895	checkout	0049_auto_20220621_0850	2024-05-20 11:15:56.431652+00
    896	checkout	0050_auto_20220713_1057	2024-05-20 11:15:57.803046+00
    897	checkout	0051_auto_20220713_1103	2024-05-20 11:15:58.288331+00
    898	checkout	0052_alter_checkoutline_currency	2024-05-20 11:15:58.394235+00
    899	checkout	0053_checkout_tax_exemption	2024-05-20 11:15:58.553437+00
    900	checkout	0054_alter_checkout_options	2024-05-20 11:15:58.915232+00
    901	checkout	0055_create_checkout_metadata_model	2024-05-20 11:15:59.84028+00
    902	checkout	0056_move_checkout_metadata_to_separate_model	2024-05-20 11:16:00.020328+00
    903	checkout	0057_remove_metadata_from_checkout_model_state	2024-05-20 11:16:00.417127+00
    904	checkout	0055_add_last_change_idx	2024-05-20 11:16:00.534327+00
    905	checkout	0058_merge_0055_add_last_change_idx	2024-05-20 11:16:00.539812+00
    906	checkout	0058_auto_20230313_1602	2024-05-20 11:16:00.786097+00
    907	checkout	0059_merge_0058	2024-05-20 11:16:00.794497+00
    908	checkout	0060_fix_charge_and_authorize_status_for_empty_checkouts	2024-05-20 11:16:01.100357+00
    909	checkout	0061_checkout_last_transaction_modified_at_and_refundable	2024-05-20 11:16:01.301834+00
    910	checkout	0062_update_checkout_last_transaction_modified_at_and_refundable	2024-05-20 11:16:01.716206+00
    911	checkout	0063_checkout_base_total_and_subtotal	2024-05-20 11:16:01.986922+00
    912	checkout	0064_checkoutline_is_gift	2024-05-20 11:16:02.615203+00
    913	checkout	0065_checkout_tax_error	2024-05-20 11:16:02.722505+00
    914	checkout	0063_auto_20240402_1114	2024-05-20 11:16:02.731819+00
    915	checkout	0066_merge_0063_auto_20240402_1114_0065_checkout_tax_error	2024-05-20 11:16:02.739492+00
    916	checkout	0067_auto_20240405_0756	2024-05-20 11:16:02.949848+00
    917	checkout	0064_checkout_is_voucher_usage_increased	2024-05-20 11:16:03.052664+00
    918	checkout	0068_merge_20240424_1209	2024-05-20 11:16:03.061329+00
    919	checkout	0065_checkout_completing_started_at	2024-05-20 11:16:03.15855+00
    920	checkout	0069_merge_20240514_1008	2024-05-20 11:16:03.166405+00
    921	tax	0005_migrate_vatlayer	2024-05-20 11:16:03.345906+00
    922	tax	0006_alter_taxconfiguration_tax_calculation_strategy	2024-05-20 11:16:03.413086+00
    923	tax	0007_auto_20230217_0837	2024-05-20 11:16:03.596992+00
    924	core	0002_initial	2024-05-20 11:16:03.970109+00
    925	core	0003_eventdeliveryattempt_response_status_code	2024-05-20 11:16:03.989703+00
    926	core	0004_delete_delivery_without_webhook	2024-05-20 11:16:04.174649+00
    927	core	0005_alter_eventdelivery_webhook	2024-05-20 11:16:04.372156+00
    928	core	0006_celerytask	2024-05-20 11:16:04.422499+00
    929	core	0007_delete_celerytask	2024-05-20 11:16:04.453179+00
    930	core	0008_drop_openexchangerates_table	2024-05-20 11:16:04.471011+00
    931	core	0009_add_temporary_vatlayer_tables	2024-05-20 11:16:04.553407+00
    932	core	0010_drop_vatlayer_tables	2024-05-20 11:16:04.581873+00
    933	csv	0001_initial	2024-05-20 11:16:05.110715+00
    934	csv	0002_exportfile_message	2024-05-20 11:16:05.178821+00
    935	csv	0003_auto_20200810_1415	2024-05-20 11:16:05.243003+00
    936	csv	0004_auto_20210709_1043	2024-05-20 11:16:06.200643+00
    937	product	0187_category_updated_at	2024-05-20 11:16:06.250539+00
    938	product	0188_category_updated_at_idx	2024-05-20 11:16:06.306591+00
    939	order	0144_rewrite_fulfillmentline_orderline_relation	2024-05-20 11:16:06.999987+00
    940	order	0145_rewrite_order_events	2024-05-20 11:16:07.235845+00
    941	order	0137_auto_20220427_0822	2024-05-20 11:16:07.472705+00
    942	order	0138_orderline_base_price	2024-05-20 11:16:07.692629+00
    943	order	0146_merge_20220512_1005	2024-05-20 11:16:07.700907+00
    944	order	0147_alter_orderline_options	2024-05-20 11:16:07.793544+00
    945	order	0148_auto_20220519_1118	2024-05-20 11:16:08.844204+00
    946	order	0149_add_fields_for_authorize_and_charge	2024-05-20 11:16:09.068807+00
    947	order	0150_update_authorize_and_charge_status	2024-05-20 11:16:09.272006+00
    948	order	0151_auto_20220606_1431	2024-05-20 11:16:09.526661+00
    949	order	0152_update_order_search_vector	2024-05-20 11:16:09.761635+00
    950	order	0139_fix_undiscounted_total_on_lines	2024-05-20 11:16:10.002098+00
    951	order	0151_merge_20220615_1224	2024-05-20 11:16:10.013641+00
    952	order	0153_merge_20220615_1232	2024-05-20 11:16:10.020843+00
    953	order	0154_auto_20220621_0850	2024-05-20 11:16:10.49102+00
    954	order	0155_order_should_refresh_prices	2024-05-20 11:16:10.652883+00
    955	order	0156_order_tax_exemption	2024-05-20 11:16:10.797392+00
    956	order	0157_order_base_shipping_price_amount	2024-05-20 11:16:10.923867+00
    957	order	0158_migrate_base_shipping_price_amount	2024-05-20 11:16:11.108208+00
    958	order	0159_order_shipping_tax_class_and_more	2024-05-20 11:16:12.989603+00
    959	order	0160_order_external_reference	2024-05-20 11:16:13.141621+00
    960	order	0140_fix_order_undiscounted_total	2024-05-20 11:16:13.361399+00
    961	order	0152_merge_20221215_1217	2024-05-20 11:16:13.36911+00
    962	order	0155_merge_20221215_1223	2024-05-20 11:16:13.375228+00
    963	order	0156_merge_20221215_1235	2024-05-20 11:16:13.382846+00
    964	order	0159_merge_20221215_1244	2024-05-20 11:16:13.410229+00
    965	order	0160_merge_20221215_1253	2024-05-20 11:16:13.416772+00
    966	order	0161_merge_20221219_1838	2024-05-20 11:16:13.423741+00
    967	order	0162_order_granted_refund	2024-05-20 11:16:14.163145+00
    968	order	0163_order_events_rename_transaction_events	2024-05-20 11:16:15.021825+00
    969	order	0164_auto_20230329_1200	2024-05-20 11:16:15.271519+00
    970	order	0165_order_expired_at	2024-05-20 11:16:15.422619+00
    971	order	0166_order_propagate_expired_at	2024-05-20 11:16:15.66297+00
    972	order	0167_bulk_order_create_20230315_1312	2024-05-20 11:16:15.952171+00
    973	order	0168_order_bulk_permission	2024-05-20 11:16:16.136302+00
    974	order	0169_alter_order_options	2024-05-20 11:16:16.277773+00
    975	order	0170_auto_20230529_1314	2024-05-20 11:16:16.598358+00
    976	discount	0037_rewrite_discount_order_relations	2024-05-20 11:16:17.882748+00
    977	discount	0038_alter_orderdiscount_options	2024-05-20 11:16:17.976915+00
    978	discount	0039_rename_created_sale_created_at	2024-05-20 11:16:18.040649+00
    979	discount	0040_orderdiscount_token_old_id_created_at	2024-05-20 11:16:18.318207+00
    980	discount	0041_fulfill_orderdiscount_token_created_at_old_id	2024-05-20 11:16:18.913881+00
    981	discount	0042_migrate_orderdiscount_id_to_uuid	2024-05-20 11:16:19.498978+00
    982	discount	0043_sale_notification_sent_datetime	2024-05-20 11:16:19.592085+00
    983	discount	0044_auto_20230421_1018	2024-05-20 11:16:20.527623+00
    984	discount	0045_promotions	2024-05-20 11:16:22.744373+00
    985	product	0187_auto_20230614_0838	2024-05-20 11:16:23.181135+00
    986	product	0189_merge_20230929_0857	2024-05-20 11:16:23.189783+00
    987	product	0186_alter_productmedia_alt	2024-05-20 11:16:23.390045+00
    988	product	0190_merge_20231221_1356	2024-05-20 11:16:23.399491+00
    989	payment	0052_auto_20230816_1214	2024-05-20 11:16:24.057522+00
    990	payment	0053_auto_20230601_0818	2024-05-20 11:16:24.21551+00
    991	order	0171_auto_20230518_0854	2024-05-20 11:16:24.634545+00
    992	order	0172_auto_20230627_0816	2024-05-20 11:16:24.9631+00
    993	order	0173_auto_20230816_1245	2024-05-20 11:16:25.098859+00
    994	order	0174_order_idx_order_created_at	2024-05-20 11:16:25.277555+00
    995	order	0175_order_voucher_code	2024-05-20 11:16:25.428277+00
    996	order	0176_order_voucher_code_add_index	2024-05-20 11:16:25.629717+00
    997	discount	0046_promotion_discount_indexes	2024-05-20 11:16:25.944689+00
    998	discount	0047_migrate_sales_to_promotions	2024-05-20 11:16:26.411862+00
    999	discount	0048_old_sale_ids_sequence	2024-05-20 11:16:26.436117+00
    1000	discount	0049_promotionevent	2024-05-20 11:16:27.243482+00
    1001	discount	0048_remigrate_sales_to_promotions	2024-05-20 11:16:27.249757+00
    1002	discount	0050_merge_20231004_1306	2024-05-20 11:16:27.255227+00
    1003	discount	0051_detach_sale_from_permission	2024-05-20 11:16:27.549723+00
    1004	discount	0052_drop_sales_constraints	2024-05-20 11:16:27.651019+00
    1005	discount	0053_drop_sales_indexes	2024-05-20 11:16:27.945591+00
    1006	discount	0054_drop_sales_models	2024-05-20 11:16:30.698939+00
    1007	discount	0055_vouchercode	2024-05-20 11:16:30.976194+00
    1008	discount	0056_voucher_code_indexes	2024-05-20 11:16:31.044953+00
    1009	order	0177_set_order_voucher_code	2024-05-20 11:16:31.22919+00
    1010	discount	0057_move_codes_to_new_model	2024-05-20 11:16:31.418375+00
    1011	discount	0058_vouchercustomer_vouchercode	2024-05-20 11:16:31.629107+00
    1012	discount	0059_vouchercustomer_voucher_code_index	2024-05-20 11:16:31.692372+00
    1013	discount	0060_set_vouchercustomer_codes	2024-05-20 11:16:31.902199+00
    1014	discount	0061_basediscount_add_voucher_code	2024-05-20 11:16:32.189124+00
    1015	discount	0062_basediscount_voucher_code_add_index	2024-05-20 11:16:32.444265+00
    1016	discount	0063_basediscount_voucher_code	2024-05-20 11:16:33.864575+00
    1017	discount	0055_drop_sales_from_db	2024-05-20 11:16:33.893984+00
    1018	discount	0064_merge_20231020_1334	2024-05-20 11:16:33.90245+00
    1019	discount	0065_remove_voucher_code_index	2024-05-20 11:16:33.924279+00
    1020	discount	0066_clear_voucher_and_vouchercustomer	2024-05-20 11:16:35.089358+00
    1021	discount	0067_voucher_single_use	2024-05-20 11:16:35.212704+00
    1022	discount	0064_alter_promotionrule_catalogue_predicate	2024-05-20 11:16:35.540459+00
    1023	discount	0068_merge_20231106_1013	2024-05-20 11:16:35.550799+00
    1024	discount	0065_vouchercode_created_at_check	2024-05-20 11:16:35.573807+00
    1025	discount	0069_merge_20231117_0959	2024-05-20 11:16:35.582026+00
    1026	discount	0066_promotionrule_variants	2024-05-20 11:16:35.853506+00
    1027	discount	0067_fulfill_promotionrule_variants	2024-05-20 11:16:36.695272+00
    1028	discount	0068_promotion_start_end_date_indexes	2024-05-20 11:16:36.788438+00
    1029	discount	0070_merge_20231215_0911	2024-05-20 11:16:36.797718+00
    1030	discount	0070_alter_promotion_options	2024-05-20 11:16:37.016786+00
    1031	discount	0071_merge_20231215_0943	2024-05-20 11:16:37.023106+00
    1032	discount	0072_auto_20231213_1413	2024-05-20 11:16:37.041641+00
    1033	discount	0073_auto_20231213_1535	2024-05-20 11:16:37.062816+00
    1034	discount	0074_auto_20240119_1029	2024-05-20 11:16:38.204882+00
    1035	discount	0075_promotionrule_gifts	2024-05-20 11:16:38.737306+00
    1036	discount	0076_promotionrule_variants_dirty	2024-05-20 11:16:38.743159+00
    1037	discount	0069_promotionrule_variants	2024-05-20 11:16:39.661889+00
    1038	discount	0070_alter_promotionrule_variants_id	2024-05-20 11:16:39.943402+00
    1039	discount	0071_merge_20240307_1156	2024-05-20 11:16:39.954161+00
    1040	discount	0077_merge_20240307_1217	2024-05-20 11:16:39.964993+00
    1041	discount	0078_add_unique_type	2024-05-20 11:16:39.974396+00
    1042	discount	0079_add_index_for_unique_type	2024-05-20 11:16:39.982213+00
    1043	discount	0080_add_unique_type_constraint	2024-05-20 11:16:39.989283+00
    1044	discount	0072_promotionrule_variants_dirty	2024-05-20 11:16:40.111214+00
    1045	discount	0081_merge_20240422_1207	2024-05-20 11:16:40.120304+00
    1046	discount	0073_add_unique_type	2024-05-20 11:16:40.254171+00
    1047	discount	0074_add_index_for_unique_type	2024-05-20 11:16:40.332516+00
    1048	discount	0075_add_unique_type_constraint	2024-05-20 11:16:40.486244+00
    1049	discount	0082_merge_20240509_1550	2024-05-20 11:16:40.496319+00
    1050	discount	0083_auto_20240510_0838	2024-05-20 11:16:40.64837+00
    1051	django_celery_beat	0001_initial	2024-05-20 11:16:40.828276+00
    1052	django_celery_beat	0002_auto_20161118_0346	2024-05-20 11:16:40.913271+00
    1053	django_celery_beat	0003_auto_20161209_0049	2024-05-20 11:16:40.963457+00
    1054	django_celery_beat	0004_auto_20170221_0000	2024-05-20 11:16:40.989584+00
    1055	django_celery_beat	0005_add_solarschedule_events_choices	2024-05-20 11:16:41.009197+00
    1056	django_celery_beat	0006_auto_20180322_0932	2024-05-20 11:16:41.125068+00
    1057	django_celery_beat	0007_auto_20180521_0826	2024-05-20 11:16:41.165401+00
    1058	django_celery_beat	0008_auto_20180914_1922	2024-05-20 11:16:41.268603+00
    1059	django_celery_beat	0006_auto_20180210_1226	2024-05-20 11:16:41.324581+00
    1060	django_celery_beat	0006_periodictask_priority	2024-05-20 11:16:41.357714+00
    1061	django_celery_beat	0009_periodictask_headers	2024-05-20 11:16:41.383639+00
    1062	django_celery_beat	0010_auto_20190429_0326	2024-05-20 11:16:41.842823+00
    1063	django_celery_beat	0011_auto_20190508_0153	2024-05-20 11:16:41.901827+00
    1064	django_celery_beat	0012_periodictask_expire_seconds	2024-05-20 11:16:41.931551+00
    1065	django_celery_beat	0013_auto_20200609_0727	2024-05-20 11:16:41.960932+00
    1066	django_celery_beat	0014_remove_clockedschedule_enabled	2024-05-20 11:16:41.98252+00
    1067	django_celery_beat	0015_edit_solarschedule_events_choices	2024-05-20 11:16:42.003501+00
    1068	django_celery_beat	0016_alter_crontabschedule_timezone	2024-05-20 11:16:42.039788+00
    1069	django_celery_beat	0017_alter_crontabschedule_month_of_year	2024-05-20 11:16:42.072717+00
    1070	django_celery_beat	0018_improve_crontab_helptext	2024-05-20 11:16:42.098354+00
    1071	giftcard	0002_auto_20190814_0413	2024-05-20 11:16:42.583455+00
    1072	giftcard	0003_auto_20200217_0350	2024-05-20 11:16:42.657904+00
    1073	giftcard	0004_auto_20200902_1249	2024-05-20 11:16:43.665508+00
    1074	giftcard	0005_auto_20210719_1116	2024-05-20 11:16:46.744137+00
    1075	giftcard	0006_auto_20210719_1117	2024-05-20 11:16:46.969001+00
    1076	giftcard	0007_auto_20210719_1311	2024-05-20 11:16:47.278852+00
    1077	giftcard	0008_auto_20210818_0633	2024-05-20 11:16:47.911783+00
    1078	giftcard	0009_giftcard_fulfillment_line	2024-05-20 11:16:48.179841+00
    1079	giftcard	0010_auto_20211007_0546	2024-05-20 11:16:49.472953+00
    1080	giftcard	0011_auto_20211007_0547	2024-05-20 11:16:49.763414+00
    1081	giftcard	0012_auto_20211007_0655	2024-05-20 11:16:49.955376+00
    1082	giftcard	0013_giftcardevent_order	2024-05-20 11:16:50.266884+00
    1083	giftcard	0014_set_giftcardevent_order_values	2024-05-20 11:16:50.486149+00
    1084	giftcard	0015_rename_created_giftcard_created_at	2024-05-20 11:16:50.744667+00
    1085	giftcard	0016_alter_giftcard_created_at	2024-05-20 11:16:51.001452+00
    1086	giftcard	0017_alter_giftcard_code	2024-05-20 11:16:51.209536+00
    1087	giftcard	0018_metadata_index	2024-05-20 11:16:51.439105+00
    1088	giftcard	0019_auto_20230626_1315	2024-05-20 11:16:52.325107+00
    1089	giftcard	0020_search_vector_index	2024-05-20 11:16:52.453789+00
    1090	invoice	0008_rewrite_invoice_order_relations	2024-05-20 11:16:54.002012+00
    1091	invoice	0009_alter_invoice_options	2024-05-20 11:16:54.084367+00
    1092	menu	0004_sort_order_index	2024-05-20 11:16:54.14172+00
    1093	menu	0005_auto_20180719_0520	2024-05-20 11:16:54.165789+00
    1094	menu	0006_auto_20180803_0528	2024-05-20 11:16:54.999666+00
    1095	menu	0007_auto_20180807_0547	2024-05-20 11:16:55.307333+00
    1096	menu	0008_menu_json_content_new	2024-05-20 11:16:55.561972+00
    1097	menu	0009_remove_menu_json_content	2024-05-20 11:16:55.586312+00
    1098	menu	0010_auto_20180913_0841	2024-05-20 11:16:55.622821+00
    1099	menu	0011_auto_20181204_0004	2024-05-20 11:16:55.641487+00
    1100	menu	0012_auto_20190104_0443	2024-05-20 11:16:55.661971+00
    1101	menu	0013_auto_20190507_0309	2024-05-20 11:16:55.846275+00
    1102	menu	0014_auto_20190523_0759	2024-05-20 11:16:55.917258+00
    1103	menu	0015_auto_20190725_0811	2024-05-20 11:16:55.980353+00
    1104	menu	0016_auto_20200217_0350	2024-05-20 11:16:56.004904+00
    1105	menu	0017_remove_menu_json_content	2024-05-20 11:16:56.027329+00
    1106	menu	0018_auto_20200709_1102	2024-05-20 11:16:56.098259+00
    1107	menu	0019_menu_slug	2024-05-20 11:16:56.396336+00
    1108	menu	0020_auto_20201223_0845	2024-05-20 11:16:56.548288+00
    1109	menu	0021_auto_20210308_1135	2024-05-20 11:16:56.682863+00
    1110	menu	0022_alter_menuitemtranslation_language_code	2024-05-20 11:16:56.73662+00
    1111	order	0165_fix_order_charge_status_with_transactions	2024-05-20 11:16:57.008063+00
    1112	order	0170_merge_20231030_0857	2024-05-20 11:16:57.014779+00
    1113	order	0174_merge_20231030_1033	2024-05-20 11:16:57.021057+00
    1114	order	0175_merge_20231030_1040	2024-05-20 11:16:57.026538+00
    1115	order	0178_merge_20231030_1055	2024-05-20 11:16:57.034504+00
    1116	order	0171_order_order_user_email_user_id_idx	2024-05-20 11:16:57.205722+00
    1117	order	0175_merge_20231122_1040	2024-05-20 11:16:57.21237+00
    1118	order	0176_merge_20231122_1346	2024-05-20 11:16:57.219987+00
    1119	order	0179_merge_20231122_1348	2024-05-20 11:16:57.22652+00
    1120	order	0180_auto_20231108_0908	2024-05-20 11:16:57.651661+00
    1121	order	0181_order_subtotal_as_a_field	2024-05-20 11:16:58.623542+00
    1122	order	0182_orderline_is_gift	2024-05-20 11:16:58.76405+00
    1123	order	0183_order_tax_error	2024-05-20 11:16:58.935356+00
    1124	order	0172_update_order_cc_addresses	2024-05-20 11:16:59.159077+00
    1125	order	0176_merge_20240325_1315	2024-05-20 11:16:59.168244+00
    1126	order	0177_merge_20240325_1329	2024-05-20 11:16:59.178+00
    1127	order	0180_merge_20240325_1333	2024-05-20 11:16:59.186486+00
    1128	order	0182_merge_20240325_1338	2024-05-20 11:16:59.195094+00
    1129	order	0184_merge_0182_merge_20240325_1338_0183_order_tax_error	2024-05-20 11:16:59.203686+00
    1130	payment	0054_merge_20231122_0828	2024-05-20 11:16:59.21199+00
    1131	payment	0055_merge_20231212_1610	2024-05-20 11:16:59.22123+00
    1132	payment	0056_merge_20231213_0755	2024-05-20 11:16:59.23266+00
    1133	payment	0056_fix_invalid_atobarai_payments	2024-05-20 11:16:59.444047+00
    1134	payment	0057_merge_20240514_0825	2024-05-20 11:16:59.453847+00
    1135	permission	0002_alter_permission_content_type	2024-05-20 11:16:59.677333+00
    1136	product	0188_merge_20231221_1119	2024-05-20 11:16:59.68333+00
    1137	product	0187_merge_20231221_1030	2024-05-20 11:16:59.689688+00
    1138	product	0189_merge_20240405_1121	2024-05-20 11:16:59.697764+00
    1139	product	0191_merge_20240405_1125	2024-05-20 11:16:59.706666+00
    1140	product	0187_productvariantchannellisting_product_pro_price_a_fb6bd3_gin	2024-05-20 11:16:59.823331+00
    1141	product	0188_merge_20240513_1023	2024-05-20 11:16:59.831344+00
    1142	product	0190_merge_20240513_1042	2024-05-20 11:16:59.838897+00
    1143	product	0192_merge_20240513_1055	2024-05-20 11:16:59.845517+00
    1144	product	0191_productchannellisting_discounted_price_dirty	2024-05-20 11:16:59.963624+00
    1145	product	0192_merge_20240405_1154	2024-05-20 11:16:59.971862+00
    1146	product	0193_merge_20240513_1105	2024-05-20 11:16:59.979269+00
    1147	schedulers	0001_initial	2024-05-20 11:17:00.346867+00
    1148	shipping	0030_auto_20210415_1001	2024-05-20 11:17:00.540117+00
    1149	shipping	0031_alter_shippingmethodtranslation_language_code	2024-05-20 11:17:00.618098+00
    1150	shipping	0032_shippingmethod_tax_class	2024-05-20 11:17:00.900191+00
    1151	shipping	0033_add_default_shipping	2024-05-20 11:17:01.183091+00
    1152	shipping	0034_shippingzone_countries_idx	2024-05-20 11:17:01.271955+00
    1153	site	0039_auto_20230615_1754	2024-05-20 11:17:01.993324+00
    1154	site	0040_sitesettings_allow_login_without_confirmation	2024-05-20 11:17:02.06678+00
    1155	tax	0008_auto_20240122_1353	2024-05-20 11:17:02.187372+00
    1156	thumbnail	0002_alter_thumbnail_format	2024-05-20 11:17:02.284187+00
    1157	thumbnail	0003_auto_20230412_1943	2024-05-20 11:17:02.840365+00
    1158	warehouse	0032_alter_channel_warehouse	2024-05-20 11:17:03.765687+00
    1159	warehouse	0033_warehouse_external_reference	2024-05-20 11:17:03.903451+00
    1160	webhook	0009_webhook_custom_headers	2024-05-20 11:17:03.957709+00
    1161	webhook	0010_drop_transaction_request_action_event	2024-05-20 11:17:04.182774+00
    1162	account	0007_auto_20161115_0940	2024-05-20 11:17:04.223269+00
    1163	account	0016_auto_20180108_0814	2024-05-20 11:17:04.23238+00
    1164	account	0011_auto_20171110_0552	2024-05-20 11:17:04.240608+00
    1165	account	0006_auto_20160829_0819	2024-05-20 11:17:04.246752+00
    1166	account	0002_auto_20150907_0602	2024-05-20 11:17:04.253845+00
    1167	account	0005_auto_20160205_0651	2024-05-20 11:17:04.262299+00
    1168	account	0013_auto_20171120_0521	2024-05-20 11:17:04.269867+00
    1169	account	0003_auto_20151104_1102	2024-05-20 11:17:04.279971+00
    1170	account	0008_auto_20161115_1011	2024-05-20 11:17:04.286052+00
    1171	account	0001_initial	2024-05-20 11:17:04.291591+00
    1172	account	0010_auto_20170919_0839	2024-05-20 11:17:04.297917+00
    1173	account	0014_auto_20171129_1004	2024-05-20 11:17:04.304099+00
    1174	account	0009_auto_20170206_0407	2024-05-20 11:17:04.309984+00
    1175	account	0004_auto_20160114_0419	2024-05-20 11:17:04.315563+00
    1176	account	0015_auto_20171213_0734	2024-05-20 11:17:04.320953+00
    1177	account	0012_auto_20171117_0846	2024-05-20 11:17:04.326494+00
    1178	checkout	0003_auto_20170906_0556	2024-05-20 11:17:04.332199+00
    1179	checkout	0004_auto_20171129_1004	2024-05-20 11:17:04.337374+00
    1180	checkout	0001_auto_20170113_0435	2024-05-20 11:17:04.342734+00
    1181	checkout	0005_auto_20180108_0814	2024-05-20 11:17:04.348493+00
    1182	checkout	fix_empty_data_in_lines	2024-05-20 11:17:04.354465+00
    1183	checkout	0001_initial	2024-05-20 11:17:04.360453+00
    1184	checkout	0002_auto_20170206_0407	2024-05-20 11:17:04.366626+00
    1185	checkout	0002_auto_20161014_1221	2024-05-20 11:17:04.372613+00
    1186	checkout	0006_auto_20180221_0825	2024-05-20 11:17:04.379328+00
    \.


    --
    -- Data for Name: django_site; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.django_site (id, domain, name) FROM stdin;
    1	${API_FQDN}	W3YZ
    \.


    --
    -- Data for Name: giftcard_giftcard; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.giftcard_giftcard (id, code, created_at, last_used_on, is_active, initial_balance_amount, current_balance_amount, currency, app_id, created_by_id, created_by_email, expiry_date, metadata, private_metadata, product_id, used_by_id, used_by_email, fulfillment_line_id, search_index_dirty, search_vector) FROM stdin;
    1	Gift_card_1	2024-05-20 11:17:42.578432+00	\N	t	50.000	50.000	TRY	\N	\N	\N	\N	{}	{}	\N	\N	\N	\N	f	'1':3 'card':2 'gift':1
    2	Gift_card_11	2024-05-20 11:17:42.60937+00	\N	t	20.000	20.000	TRY	\N	20	\N	\N	{}	{}	160	\N	\N	\N	f	'11':3 'anna':5 'anna.robbins@example.com':4 'card':2 'gift':1 'robbins':6
    3	Gift_card_2	2024-05-20 11:17:42.639912+00	\N	t	50.000	50.000	TRY	\N	\N	\N	\N	{}	{}	\N	\N	\N	\N	f	'2':3 'card':2 'gift':1
    4	Gift_card_12	2024-05-20 11:17:42.664947+00	\N	t	20.000	20.000	TRY	\N	8	\N	\N	{}	{}	160	\N	\N	\N	f	'12':3 'alan':5 'alan.hayden@example.com':4 'card':2 'gift':1 'hayden':6
    5	Gift_card_3	2024-05-20 11:17:42.692303+00	\N	t	50.000	50.000	TRY	\N	\N	\N	\N	{}	{}	\N	\N	\N	\N	f	'3':3 'card':2 'gift':1
    6	Gift_card_13	2024-05-20 11:17:42.711637+00	\N	t	20.000	20.000	TRY	\N	10	\N	\N	{}	{}	160	\N	\N	\N	f	'13':3 'card':2 'gift':1 'john':5 'john.mora@example.com':4 'mora':6
    7	Gift_card_4	2024-05-20 11:17:42.733526+00	\N	t	50.000	50.000	TRY	\N	\N	\N	\N	{}	{}	\N	\N	\N	\N	f	'4':3 'card':2 'gift':1
    8	Gift_card_14	2024-05-20 11:17:42.755567+00	\N	t	20.000	20.000	TRY	\N	17	\N	\N	{}	{}	160	\N	\N	\N	f	'14':3 'card':2 'gift':1 'herman':6 'jamie':5 'jamie.herman@example.com':4
    9	Gift_card_5	2024-05-20 11:17:42.772366+00	\N	t	50.000	50.000	TRY	\N	\N	\N	\N	{}	{}	\N	\N	\N	\N	f	'5':3 'card':2 'gift':1
    10	Gift_card_15	2024-05-20 11:17:42.793783+00	\N	t	20.000	20.000	TRY	\N	7	\N	\N	{}	{}	160	\N	\N	\N	f	'15':3 'card':2 'gift':1 'phillips':6 'susan':5 'susan.phillips@example.com':4
    \.


    --
    -- Data for Name: giftcard_giftcard_tags; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.giftcard_giftcard_tags (id, giftcard_id, giftcardtag_id) FROM stdin;
    1	1	1
    2	3	1
    3	5	1
    4	7	1
    5	9	1
    \.


    --
    -- Data for Name: giftcard_giftcardevent; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.giftcard_giftcardevent (id, date, type, parameters, app_id, gift_card_id, user_id, order_id) FROM stdin;
    1	2024-05-20 11:17:42.593447+00	issued	{"balance": {"currency": "TRY", "current_balance": "50", "initial_balance": "50"}, "expiry_date": null}	\N	1	\N	\N
    2	2024-05-20 11:17:42.622864+00	bought	{"expiry_date": null}	\N	2	20	41083c1e-d013-4366-a11b-29843ab3deb8
    3	2024-05-20 11:17:42.651858+00	issued	{"balance": {"currency": "TRY", "current_balance": "50", "initial_balance": "50"}, "expiry_date": null}	\N	3	\N	\N
    4	2024-05-20 11:17:42.67613+00	bought	{"expiry_date": null}	\N	4	8	3ec90525-e3c0-429f-9520-5ac9bced7715
    5	2024-05-20 11:17:42.701328+00	issued	{"balance": {"currency": "TRY", "current_balance": "50", "initial_balance": "50"}, "expiry_date": null}	\N	5	\N	\N
    6	2024-05-20 11:17:42.720732+00	bought	{"expiry_date": null}	\N	6	10	b2be7ed4-faa6-4cbd-98d0-d0a7a9ad57c9
    7	2024-05-20 11:17:42.745254+00	issued	{"balance": {"currency": "TRY", "current_balance": "50", "initial_balance": "50"}, "expiry_date": null}	\N	7	\N	\N
    8	2024-05-20 11:17:42.763102+00	bought	{"expiry_date": null}	\N	8	17	7ed59560-a1bf-4137-8118-471da8d72fa1
    9	2024-05-20 11:17:42.780158+00	issued	{"balance": {"currency": "TRY", "current_balance": "50", "initial_balance": "50"}, "expiry_date": null}	\N	9	\N	\N
    10	2024-05-20 11:17:42.803579+00	bought	{"expiry_date": null}	\N	10	7	855ae710-20e2-486a-8ab4-f25216585284
    11	2024-05-20 11:18:07.096426+00	issued	{"balance": {"currency": "TRY", "current_balance": "50.000", "initial_balance": "50.000"}, "expiry_date": null}	\N	1	43	\N
    12	2024-05-20 11:18:07.122484+00	bought	{"expiry_date": null}	\N	2	37	d82f243a-1b5c-4581-a33d-9a28f4dc3c6f
    13	2024-05-20 11:18:07.154957+00	issued	{"balance": {"currency": "TRY", "current_balance": "50.000", "initial_balance": "50.000"}, "expiry_date": null}	\N	3	25	\N
    14	2024-05-20 11:18:07.173619+00	bought	{"expiry_date": null}	\N	4	32	e98191e3-b3f5-4f8b-a956-e3c194782fe5
    15	2024-05-20 11:18:07.19417+00	issued	{"balance": {"currency": "TRY", "current_balance": "50.000", "initial_balance": "50.000"}, "expiry_date": null}	\N	5	30	\N
    16	2024-05-20 11:18:07.211138+00	bought	{"expiry_date": null}	\N	6	38	999999c3-f70a-430a-a4a4-24c91ce64916
    17	2024-05-20 11:18:07.226143+00	issued	{"balance": {"currency": "TRY", "current_balance": "50.000", "initial_balance": "50.000"}, "expiry_date": null}	\N	7	31	\N
    18	2024-05-20 11:18:07.242289+00	bought	{"expiry_date": null}	\N	8	51	3ec90525-e3c0-429f-9520-5ac9bced7715
    19	2024-05-20 11:18:07.257905+00	issued	{"balance": {"currency": "TRY", "current_balance": "50.000", "initial_balance": "50.000"}, "expiry_date": null}	\N	9	30	\N
    20	2024-05-20 11:18:07.271728+00	bought	{"expiry_date": null}	\N	10	16	3ec90525-e3c0-429f-9520-5ac9bced7715
    21	2024-05-20 11:19:55.254132+00	issued	{"balance": {"currency": "TRY", "current_balance": "50.000", "initial_balance": "50.000"}, "expiry_date": null}	\N	1	21	\N
    22	2024-05-20 11:19:55.27171+00	bought	{"expiry_date": null}	\N	2	108	60dc6631-9a39-4746-963b-76d9ee0e8084
    23	2024-05-20 11:19:55.289426+00	issued	{"balance": {"currency": "TRY", "current_balance": "50.000", "initial_balance": "50.000"}, "expiry_date": null}	\N	3	23	\N
    24	2024-05-20 11:19:55.307231+00	bought	{"expiry_date": null}	\N	4	36	d82f243a-1b5c-4581-a33d-9a28f4dc3c6f
    25	2024-05-20 11:19:55.322222+00	issued	{"balance": {"currency": "TRY", "current_balance": "50.000", "initial_balance": "50.000"}, "expiry_date": null}	\N	5	61	\N
    26	2024-05-20 11:19:55.335458+00	bought	{"expiry_date": null}	\N	6	105	5e0958b4-f7d9-4309-9f5d-1d9cfc11db8a
    27	2024-05-20 11:19:55.345414+00	issued	{"balance": {"currency": "TRY", "current_balance": "50.000", "initial_balance": "50.000"}, "expiry_date": null}	\N	7	39	\N
    28	2024-05-20 11:19:55.354806+00	bought	{"expiry_date": null}	\N	8	41	8b90a8ae-754a-4355-9dc1-a431dcbdabc8
    29	2024-05-20 11:19:55.365595+00	issued	{"balance": {"currency": "TRY", "current_balance": "50.000", "initial_balance": "50.000"}, "expiry_date": null}	\N	9	23	\N
    30	2024-05-20 11:19:55.377325+00	bought	{"expiry_date": null}	\N	10	97	d82f243a-1b5c-4581-a33d-9a28f4dc3c6f
    \.


    --
    -- Data for Name: giftcard_giftcardtag; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.giftcard_giftcardtag (id, name) FROM stdin;
    1	issued-gift-cards
    \.


    --
    -- Data for Name: invoice_invoice; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.invoice_invoice (id, private_metadata, metadata, status, created_at, updated_at, number, created, external_url, invoice_file, message, order_id) FROM stdin;
    \.


    --
    -- Data for Name: invoice_invoiceevent; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.invoice_invoiceevent (id, date, type, parameters, invoice_id, user_id, app_id, order_id) FROM stdin;
    \.


    --
    -- Data for Name: menu_menu; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.menu_menu (id, name, slug, metadata, private_metadata) FROM stdin;
    1	navbar	navbar	{}	{}
    2	footer	footer	{}	{}
    \.


    --
    -- Data for Name: menu_menuitem; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.menu_menuitem (id, name, sort_order, url, lft, rght, tree_id, level, category_id, collection_id, menu_id, page_id, parent_id, metadata, private_metadata) FROM stdin;
    243	Collections	2	\N	1	6	59	0	\N	4	2	\N	\N	{}	{}
    244	Featured Products	1	\N	2	3	59	1	\N	4	2	\N	243	{}	{}
    245	Summer Picks	2	\N	4	5	59	1	\N	5	2	\N	243	{}	{}
    246	Gift cards	3	\N	6	7	56	1	44	\N	1	\N	223	{}	{}
    220	Saleor	1	/	1	8	55	0	\N	\N	2	\N	\N	{}	{}
    222	GraphQL API	2	https://${API_FQDN}/graphql/	4	5	55	1	\N	\N	2	\N	220	{}	{}
    223	Accessories	1	\N	1	8	56	0	25	\N	1	\N	\N	{}	{}
    224	Audiobooks	2	\N	2	3	56	1	26	\N	1	\N	223	{}	{}
    225	Apparel	0	\N	1	28	57	0	27	\N	1	\N	\N	{}	{}
    226	Sneakers	3	\N	2	3	57	1	28	\N	1	\N	225	{}	{}
    227	Sweatshirts	4	\N	4	5	57	1	29	\N	1	\N	225	{}	{}
    232	Headware	2	\N	14	21	57	1	33	\N	1	\N	225	{}	{}
    233	Beanies	1	\N	19	20	57	2	35	\N	1	\N	232	{}	{}
    234	Scarfs	2	\N	17	18	57	2	36	\N	1	\N	232	{}	{}
    235	Sunglasses	3	\N	15	16	57	2	37	\N	1	\N	232	{}	{}
    236	T-shirts	1	\N	25	26	57	2	39	\N	1	\N	238	{}	{}
    237	Polo shirts	2	\N	23	24	57	2	40	\N	1	\N	238	{}	{}
    238	Shirts	1	\N	22	27	57	1	38	\N	1	\N	225	{}	{}
    239	About	1	\N	6	7	55	1	\N	\N	2	3	220	{}	{}
    240	Homewares	1	\N	4	5	56	1	41	\N	1	\N	223	{}	{}
    241	Groceries	2	\N	1	4	58	0	42	\N	1	\N	\N	{}	{}
    242	Juices	\N	\N	2	3	58	1	43	\N	1	\N	241	{}	{}
    \.


    --
    -- Data for Name: menu_menuitemtranslation; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.menu_menuitemtranslation (id, language_code, name, menu_item_id) FROM stdin;
    \.


    --
    -- Data for Name: order_fulfillment; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.order_fulfillment (id, tracking_number, created_at, fulfillment_order, status, metadata, private_metadata, shipping_refund_amount, total_refund_amount, order_id) FROM stdin;
    1		2024-05-20 11:17:36.567848+00	1	fulfilled	{}	{}	\N	\N	7ed59560-a1bf-4137-8118-471da8d72fa1
    2		2024-05-20 11:17:36.997945+00	1	fulfilled	{}	{}	\N	\N	c72dd0cd-d258-42f0-96bc-592be0f08c15
    3		2024-05-20 11:17:37.276233+00	1	fulfilled	{}	{}	\N	\N	18149d27-f019-4abb-9c0f-987dff8a7dd2
    4		2024-05-20 11:17:38.059335+00	1	fulfilled	{}	{}	\N	\N	3ec90525-e3c0-429f-9520-5ac9bced7715
    5		2024-05-20 11:17:38.403476+00	1	fulfilled	{}	{}	\N	\N	2be62bb0-8316-4135-b2ec-77b76337e814
    6		2024-05-20 11:17:38.992435+00	1	fulfilled	{}	{}	\N	\N	60dc6631-9a39-4746-963b-76d9ee0e8084
    7		2024-05-20 11:17:39.393082+00	1	fulfilled	{}	{}	\N	\N	e98191e3-b3f5-4f8b-a956-e3c194782fe5
    8		2024-05-20 11:17:39.656222+00	1	fulfilled	{}	{}	\N	\N	41083c1e-d013-4366-a11b-29843ab3deb8
    9		2024-05-20 11:17:40.004346+00	1	fulfilled	{}	{}	\N	\N	467a5b3a-9795-485c-8ac7-275867b302f7
    10		2024-05-20 11:17:40.361393+00	1	fulfilled	{}	{}	\N	\N	999999c3-f70a-430a-a4a4-24c91ce64916
    11		2024-05-20 11:17:40.793538+00	1	fulfilled	{}	{}	\N	\N	7d320a24-ec67-4b93-9211-76f5bbca9c30
    12		2024-05-20 11:17:41.097518+00	1	fulfilled	{}	{}	\N	\N	ffda684a-ece1-4c21-9027-01c6bb7a9347
    13		2024-05-20 11:17:41.512284+00	1	fulfilled	{}	{}	\N	\N	c3582d23-2cf4-4dd6-b502-a63de106ee28
    14		2024-05-20 11:17:42.142641+00	1	fulfilled	{}	{}	\N	\N	f925fcfe-aeea-48b8-bada-37d349cbc485
    15		2024-05-20 11:17:42.525644+00	1	fulfilled	{}	{}	\N	\N	4abcac1e-c1ac-45b4-bbd2-bb04ec61ed2b
    16		2024-05-20 11:18:01.45885+00	1	fulfilled	{}	{}	\N	\N	b715c50a-bc26-4726-a6ce-175e4361ce26
    17		2024-05-20 11:18:02.088055+00	1	fulfilled	{}	{}	\N	\N	40f2a9fc-c24c-4d97-a756-9cec06c5620a
    18		2024-05-20 11:18:02.412565+00	1	fulfilled	{}	{}	\N	\N	273b2205-ebf5-427a-bcf2-8d2476ef74a4
    19		2024-05-20 11:18:03.419369+00	1	fulfilled	{}	{}	\N	\N	dfa31232-7eef-4bac-b390-de66b8cced9d
    20		2024-05-20 11:18:03.806424+00	1	fulfilled	{}	{}	\N	\N	46a3674f-1d4f-44c2-b059-1939c41489e7
    21		2024-05-20 11:18:04.243884+00	1	fulfilled	{}	{}	\N	\N	5e0958b4-f7d9-4309-9f5d-1d9cfc11db8a
    22		2024-05-20 11:18:04.665574+00	1	fulfilled	{}	{}	\N	\N	8b90a8ae-754a-4355-9dc1-a431dcbdabc8
    23		2024-05-20 11:18:05.03633+00	1	fulfilled	{}	{}	\N	\N	75f316e4-b6bb-420b-98fb-9ede3d474e23
    24		2024-05-20 11:18:06.214601+00	1	fulfilled	{}	{}	\N	\N	a30862b4-64f6-42ee-ba0e-b81771076c21
    25		2024-05-20 11:18:06.580609+00	1	fulfilled	{}	{}	\N	\N	19dadc8a-3dad-4161-b2c0-c2feacbc252e
    26		2024-05-20 11:19:49.059292+00	1	fulfilled	{}	{}	\N	\N	92942735-68ad-4777-8a75-a8500ab04191
    27		2024-05-20 11:19:49.387161+00	1	fulfilled	{}	{}	\N	\N	fbe88788-a5b7-4892-a6fe-bd82cbdea47b
    28		2024-05-20 11:19:49.717679+00	1	fulfilled	{}	{}	\N	\N	8f4eb78f-e9e3-4e70-9110-72973e0e83d1
    29		2024-05-20 11:19:50.986205+00	1	fulfilled	{}	{}	\N	\N	f51baf78-a4eb-4393-947c-fe096cc10e9d
    30		2024-05-20 11:19:51.533021+00	1	fulfilled	{}	{}	\N	\N	225ab765-e8c1-4c08-832a-4558ed064509
    31		2024-05-20 11:19:51.977198+00	1	fulfilled	{}	{}	\N	\N	d55cb189-c636-4adc-8709-d43cddae9e02
    32		2024-05-20 11:19:52.331766+00	1	fulfilled	{}	{}	\N	\N	40fd51b7-e177-45e6-a439-60134b95c707
    33		2024-05-20 11:19:54.766097+00	1	fulfilled	{}	{}	\N	\N	2b1ce541-0f20-4af6-9288-48e7dae71fd1
    34		2024-05-20 11:19:55.163948+00	1	fulfilled	{}	{}	\N	\N	03d6e4ae-bbd5-4e9d-abd5-0872423f197f
    \.


    --
    -- Data for Name: order_fulfillmentline; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.order_fulfillmentline (id, quantity, fulfillment_id, stock_id, order_line_id) FROM stdin;
    1	1	1	31	990f138d-29dd-4fd7-8223-584e7241816c
    2	2	2	382	e93d8c4c-5ce7-4e21-afaf-e8f5c00115fc
    3	2	3	457	8b57af35-78a6-4adf-bae6-84bfe7d32496
    4	1	3	17	aee8e01e-d55c-45cf-a6a8-3db0281c270d
    5	3	4	514	e7b9dd56-fc82-4635-af9f-dde2d9acdedf
    6	1	4	50	5ff62c68-32ac-4945-a343-3ce2831b42c2
    7	1	4	242	fb934334-0233-4985-9683-d98532b93fb4
    8	1	5	24	5dca3aa6-0329-4b2d-8dfe-24fe96bfe04c
    9	4	6	193	efd52fa3-de71-488d-9d13-b90df0e1c178
    10	1	7	320	f226cde7-2282-4116-b5ec-86b6e86436fd
    11	2	8	114	82083514-264e-482f-b23b-c57353e7c9eb
    12	2	9	82	15763d4f-2ab1-43ed-9115-20c1ddce671c
    13	1	10	367	bd5f2ef1-8a5d-4411-b4ff-25f26e508f09
    14	3	10	471	b7e3c798-1a02-4f2f-915b-229df579cdc6
    15	4	11	74	ae897f6e-fd3b-41ae-9a7a-2cc75e19ad2b
    16	1	12	358	180ebd31-5c0d-48ba-9df0-abca082a61df
    17	1	13	450	b042a4b8-5fcd-4d30-9957-528272402620
    18	4	13	26	5961243b-0717-4a79-954c-dccb9b69f880
    19	1	14	302	07696772-b3a5-44d4-8446-70cb33d22380
    20	1	14	14	711efb56-10fe-487c-8391-05bcc87cf523
    21	4	15	422	3e546566-c376-4de9-9684-df8b1360ce6e
    22	1	16	167	4f2e79e4-606d-431a-8b2a-5cdd500e83e3
    23	3	16	31	4ec749e8-2b87-43ab-97ba-73fb75361a71
    24	1	17	48	f8502f3f-5ff1-412d-99f8-fb6352d5aafd
    25	4	17	344	c4def8b7-405d-4123-8b6b-034fe7e02a83
    26	1	17	328	87b60f97-8820-446f-9938-f72077a8f534
    27	1	18	167	3dd24bf6-b18c-4d5f-b4d2-649d5d65f8db
    28	2	19	208	331ebca3-ceeb-45dc-a437-0bedd53c623c
    29	2	19	424	dc73e900-aef0-4497-b0ad-2c615a3dfc00
    30	2	19	88	12c4dccb-f7a1-4ddb-9218-39df5cb2449d
    31	1	20	208	5d182b9a-0412-4e82-a47b-815ee99618c4
    32	2	21	310	35a8c8e6-cafd-4e64-a7b4-ec147746552c
    33	2	22	289	7939fef0-6813-4f32-8b65-1b1c4d8701c2
    34	1	23	479	40cb3ae2-d5ea-4e14-a69f-d7519df1380f
    35	1	24	222	0d41a8ac-f4d8-4375-994f-116d087637dc
    36	1	25	233	3cc19c3e-25ad-4e23-ab99-b615aab6121e
    37	1	25	505	6131f5df-1e2c-4f50-9eac-72be1d818b8e
    38	4	26	54	b5471b08-3568-4538-bb82-dd6c5df6c2f5
    39	1	26	14	1e123fb0-db20-4664-a082-baf63870df9a
    40	1	26	142	f79836e7-872c-4ee0-b2e5-bf4f95037872
    41	2	27	424	4f433cde-1a2e-45b9-ba16-391e53d6e8d3
    42	2	28	320	9ec76d7c-7b82-4b01-9112-d511a09baaec
    43	2	29	402	7679b648-f311-4b9b-b1a9-0a3fa9d01573
    44	2	30	111	7c570801-94e4-4c00-9a32-1cf9527c9b07
    45	1	31	114	f1f829f1-322a-4072-89bd-73b6680e5af5
    46	1	32	206	c915b964-3e1e-470c-ba82-585e7df6cdcd
    47	1	32	518	ab053067-4fd9-4ddc-be94-f28c5fe56165
    48	1	33	354	c19afcd5-45a3-4857-bc4d-ef9c8192b635
    49	1	34	414	9e741d3b-017e-4316-9641-acb165d9072a
    \.


    --
    -- Data for Name: order_order; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.order_order (created_at, tracking_client_id, user_email, id, billing_address_id, shipping_address_id, user_id, total_net_amount, voucher_id, language_code, shipping_price_gross_amount, total_gross_amount, shipping_price_net_amount, status, shipping_method_name, shipping_method_id, display_gross_prices, customer_note, weight, checkout_token, currency, metadata, private_metadata, channel_id, redirect_url, shipping_tax_rate, undiscounted_total_gross_amount, undiscounted_total_net_amount, total_charged_amount, origin, collection_point_id, collection_point_name, search_document, updated_at, use_old_id, number, original_id, total_authorized_amount, authorize_status, charge_status, search_vector, should_refresh_prices, tax_exemption, base_shipping_price_amount, shipping_tax_class_id, shipping_tax_class_metadata, shipping_tax_class_name, shipping_tax_class_private_metadata, external_reference, expired_at, voucher_code, subtotal_gross_amount, subtotal_net_amount, tax_error) FROM stdin;
    2024-05-20 11:17:35.537742+00		anthony.bailey@example.com	77908546-f356-4e27-9d96-bc40a694716e	14	14	\N	323.940	\N	en	98.940	323.940	98.940	unfulfilled	FBA	6	t		2000		USD	{}	{}	34	\N	\N	0.000	0.000	0.000		\N	\N		2024-05-20 11:17:35.86087+00	f	1	\N	323.940	full	none	'1':1A '218223580':23C '49182235820':28C '51923':5B,15B '90870':12B,22B 'adrianstad':11B,21B 'anthoni':3B,13B 'anthony.bailey@example.com':2A 'bailey':4B,14B 'blue':24C 'cubes':29C 'fountain':30C 'jami':6B,16B 'lake':10B,20B 'm':27C 'polygon':25C 's':32C 'shirt':26C 'spring':7B,17B 'tee':31C 'tr':9B,19B 'türkiy':8B,18B	t	f	98.940	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:17:35.896656+00		stephen.griffith@example.com	b2be7ed4-faa6-4cbd-98d0-d0a7a9ad57c9	29	29	\N	1200.090	\N	en	10.130	1200.090	10.130	unconfirmed	UPS	14	t		3000		PLN	{}	{}	35	\N	\N	0.000	0.000	1200.090		\N	\N		2024-05-20 11:17:36.22533+00	f	2	\N	0.000	full	full	'118223581':34C '2':1A '27891':13B,24B '388':9B,20B '39':39C '41':28C '420':38C '49182235823':29C '7004':5B,16B '918223584':25C 'balance':37C 'cubes':30C 'fountain':31C 'griffith':4B,15B 'jonathan':6B,17B 'paul':35C 'paulview':12B,23B 'plimsolls':27C 's':36C 'spring':7B,18B 'stephen':3B,14B 'stephen.griffith@example.com':2A 'suit':8B,19B 'tee':32C 'tr':11B,22B 'türkiy':10B,21B 'white':26C 'xl':33C	t	f	10.130	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:17:36.252795+00		michael.thompson@example.com	7ed59560-a1bf-4137-8118-471da8d72fa1	27	27	\N	1299.160	\N	en	99.160	1299.160	99.160	partially fulfilled	FedEx	15	t		1000		PLN	{}	{}	35	\N	\N	0.000	0.000	1299.160		\N	\N		2024-05-20 11:17:36.600759+00	f	3	\N	0.000	full	full	'00908':13B,24B '091':9B,20B '3':1A '41':28C '660':5B,16B '918223584':25C 'dry':29C 'finleyburgh':12B,23B 'macdonald':6B,17B 'michael':3B,14B 'michael.thompson@example.com':2A 'place':7B,18B 'plimsolls':27C 'suit':8B,19B 'sunglasses':30C 'thompson':4B,15B 'tr':11B,22B 'türkiy':10B,21B 'uhjvzhvjdfzhcmlhbnq6mzcx':31C 'white':26C	t	f	99.160	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:17:36.62163+00		kenneth.miller@example.com	c72dd0cd-d258-42f0-96bc-592be0f08c15	21	21	\N	163.060	\N	en	52.560	163.060	52.560	partially fulfilled	Aramex	11	t		1000		USD	{}	{}	34	\N	\N	0.000	0.000	0.000		\N	\N		2024-05-20 11:17:37.030094+00	f	4	\N	0.000	none	none	'111223581':38C '21847':13B,24B '4':1A '6708':5B,16B '735':9B,20B '9018223583':29C 'at':33C 'battle':31C 'battle-tested':30C 'bobbyton':12B,23B 'brands':34C 'carpent':6B,17B 'darko':39C 'dimmed':26C 'itunes':37C 'kenneth':3B,14B 'kenneth.miller@example.com':2A 'like':35C 'lush':36C 'm':41C 'miller':4B,15B 'monokai':25C 'overpass':7B,18B 'polo':40C 'suit':8B,19B 'sunnies':27C 'tested':32C 'tr':11B,22B 'türkiy':10B,21B 'uhjvzhvjdfzhcmlhbnq6mzg4':28C	t	f	52.560	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:17:37.056349+00		vicki.burgess@example.com	18149d27-f019-4abb-9c0f-987dff8a7dd2	11	11	\N	184.910	\N	en	98.940	184.910	98.940	partially fulfilled	FBA	6	t		1100		USD	{}	{}	34	\N	\N	0.000	0.000	0.000		\N	\N		2024-05-20 11:17:37.328996+00	f	5	\N	184.910	full	none	'40':29C '40142':12B,22B '5':1A '8967':5B,15B '918223583':26C 'apple':23C 'burgess':4B,14B 'fort':7B,17B 'juice':24C 'lake':10B,20B 'lawson':6B,16B 'nicoleburgh':11B,21B 'plimsolls':28C 'tr':9B,19B 'türkiy':8B,18B 'uhjvzhvjdfzhcmlhbnq6mzg0':25C 'vicki':3B,13B 'vicki.burgess@example.com':2A 'white':27C	t	f	98.940	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:17:37.362445+00		michael.myers@example.com	395b103b-65f0-40cc-a55a-83ecf436b635	19	19	\N	675.130	\N	en	35.130	675.130	35.130	unfulfilled	FBA	6	t		2000		PLN	{}	{}	35	\N	\N	0.000	0.000	0.000		\N	\N		2024-05-20 11:17:37.699249+00	f	6	\N	0.000	none	none	'116':5B,15B '6':1A '9182235821':26C '95803':12B,22B 'crescent':7B,17B 'grey':23C 'hoodie':24C 'michael':3B,6B,13B,16B 'michael.myers@example.com':2A 'monotype':28C 'morganport':11B,21B 'myer':4B,14B 'reversed':27C 'tee':29C 'tr':9B,19B 'türkiy':8B,18B 'uhjvzhvjdfzhcmlhbnq6mzq1':25C 'west':10B,20B 'xxl':30C	t	f	35.130	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:17:37.724961+00		brenda.williams@example.com	3ec90525-e3c0-429f-9520-5ac9bced7715	30	30	\N	4277.640	\N	en	87.640	4277.640	87.640	partially fulfilled	UPS	3	t		3000		PLN	{}	{}	35	\N	\N	0.000	0.000	4277.640		\N	\N		2024-05-20 11:17:38.12349+00	f	7	\N	0.000	full	full	'100':23C '128223581':33C '18950':11B,20B '40':32C '44':28C '5445':5B,14B '618223582':29C '7':1A '918223587':25C 'archertown':10B,19B 'brenda':3B,12B 'brenda.williams@example.com':2A 'card':22C 'dash':30C 'force':31C 'gift':21C 'm':36C 'patton':6B,15B 'plimsolls':27C 'rapid':7B,16B 'shirt':35C 'team':34C 'tr':9B,18B 'türkiy':8B,17B 'uhjvzhvjdfzhcmlhbnq6mzkz':24C 'white':26C 'william':4B,13B	t	f	87.640	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:17:38.145859+00		david.noble@example.com	2be62bb0-8316-4135-b2ec-77b76337e814	31	31	\N	2351.970	\N	en	41.970	2351.970	41.970	partially fulfilled	fastway couriers	19	t		1000		PLN	{}	{}	35	\N	\N	0.000	0.000	2351.970		\N	\N		2024-05-20 11:17:38.43154+00	f	8	\N	0.000	full	full	'100':33C '14925':14B,26B '282':9B,21B '40':30C '493':5B,17B '8':1A '918223583':27C 'ana':6B,18B 'card':32C 'danielleshir':13B,25B 'david':3B,15B 'david.noble@example.com':2A 'gift':31C 'lake':12B,24B 'manor':7B,19B 'nobl':4B,16B 'plimsolls':29C 'suit':8B,20B 'tr':11B,23B 'türkiy':10B,22B 'uhjvzhvjdfzhcmlhbnq6mzkz':34C 'white':28C	t	f	41.970	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:17:38.454979+00		leslie.clark@example.com	855ae710-20e2-486a-8ab4-f25216585284	20	20	\N	350.760	\N	en	20.760	350.760	20.760	unfulfilled	Post Office	20	t		2000		PLN	{}	{}	35	\N	\N	0.000	0.000	350.760		\N	\N		2024-05-20 11:17:38.734808+00	f	9	\N	0.000	full	full	'128223583':23C '41':30C '5667':5B,15B '77378':12B,22B '818223583':27C '9':1A 'blair':6B,16B 'blue':28C 'clark':4B,14B 'lesli':3B,13B 'leslie.clark@example.com':2A 'plimsolls':29C 'shelbi':11B,21B 'shirt':25C 'south':10B,20B 'team':24C 'tr':9B,19B 'türkiy':8B,18B 'underpass':7B,17B 'xl':26C	t	f	20.760	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:17:38.76233+00		larry.smith@example.com	60dc6631-9a39-4746-963b-76d9ee0e8084	32	32	\N	471.960	\N	en	71.960	471.960	71.960	partially fulfilled	FedEx Express	7	t		2000		USD	{}	{}	34	\N	\N	0.000	0.000	0.000		\N	\N		2024-05-20 11:17:39.017456+00	f	10	\N	471.960	full	none	'10':1A '208':9B,21B '328223580':31C '43':30C '618223585':27C '74331':14B,26B '8885':5B,17B 'dash':28C 'donna':13B,25B 'force':29C 'larri':3B,15B 'larry.smith@example.com':2A 'lee':6B,18B 'monospace':32C 'port':12B,24B 's':34C 'smith':4B,16B 'suit':8B,20B 'tee':33C 'tr':11B,23B 'tunnel':7B,19B 'türkiy':10B,22B	t	f	71.960	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:17:39.041084+00		stefanie.hoffman@example.com	e98191e3-b3f5-4f8b-a956-e3c194782fe5	33	33	\N	2171.890	\N	en	41.970	2171.890	41.970	partially fulfilled	fastway couriers	19	t		3000		PLN	{}	{}	35	\N	\N	0.000	0.000	2171.890		\N	\N		2024-05-20 11:17:39.423289+00	f	11	\N	0.000	full	full	'11':1A '118223583':31C '218223582':37C '36476':14B,26B '41':36C '42':30C '420':35C '570':9B,21B '618223584':27C '930':5B,17B 'apt':8B,20B 'balance':34C 'blue':38C 'dash':28C 'estat':7B,19B 'force':29C 'hoffman':4B,16B 'new':12B,24B 'patricia':13B,25B 'paul':32C 'polygon':39C 'rice':6B,18B 's':33C 'shirt':40C 'stefani':3B,15B 'stefanie.hoffman@example.com':2A 'tr':11B,23B 'türkiy':10B,22B 'xl':41C	t	f	41.970	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:17:39.445673+00		christian.west@example.com	41083c1e-d013-4366-a11b-29843ab3deb8	34	34	\N	1342.420	\N	en	82.420	1342.420	82.420	partially fulfilled	DB Schenker	5	t		1000		PLN	{}	{}	35	\N	\N	0.000	0.000	0.000		\N	\N		2024-05-20 11:17:39.6844+00	f	12	\N	1342.420	full	none	'12':1A '132':5B,16B '40742':13B,24B '42':28C '446':9B,20B '618223584':25C 'chelsealand':12B,23B 'christian':3B,14B 'christian.west@example.com':2A 'dash':26C 'force':27C 'mclean':6B,17B 'meadow':7B,18B 'suit':8B,19B 'tr':11B,22B 'türkiy':10B,21B 'west':4B,15B	t	f	82.420	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:17:39.705466+00		natalie.simpson@example.com	467a5b3a-9795-485c-8ac7-275867b302f7	10	10	\N	258.400	\N	en	78.400	258.400	78.400	partially fulfilled	UPS	3	t		2000		USD	{}	{}	34	\N	\N	0.000	0.000	258.400		\N	\N		2024-05-20 11:17:40.037782+00	f	13	\N	0.000	full	full	'13':1A '20935':14B,26B '42':33C '508':9B,21B '7389':5B,17B '818223584':30C 'alec':6B,18B 'blue':31C 'grey':27C 'hoodie':28C 'jonathan':13B,25B 'natali':3B,15B 'natalie.simpson@example.com':2A 'plimsolls':32C 'port':12B,24B 'simpson':4B,16B 'squar':7B,19B 'suit':8B,20B 'tr':11B,23B 'türkiy':10B,22B 'uhjvzhvjdfzhcmlhbnq6mzq1':29C	t	f	78.400	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:17:40.058159+00		lisa.hansen@example.com	999999c3-f70a-430a-a4a4-24c91ce64916	23	23	\N	57.530	\N	en	34.570	57.530	34.570	partially fulfilled	EMS	16	t		100		USD	{}	{}	34	\N	\N	0.000	0.000	57.530		\N	\N		2024-05-20 11:17:40.409288+00	f	14	\N	0.000	full	full	'14':1A '184':9B,21B '23732':5B,17B '58406':14B,26B 'bean':30C 'dry':27C 'hansen':4B,16B 'island':7B,19B 'juice':31C 'kenneth':13B,25B 'lake':12B,24B 'lisa':3B,15B 'lisa.hansen@example.com':2A 'michael':6B,18B 'suit':8B,20B 'sunglasses':28C 'tr':11B,23B 'türkiy':10B,22B 'uhjvzhvjdfzhcmlhbnq6mzcx':29C 'uhjvzhvjdfzhcmlhbnq6mzg1':32C	t	f	34.570	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:17:40.43588+00		ryan.reid@example.com	7d320a24-ec67-4b93-9211-76f5bbca9c30	35	35	\N	1656.000	\N	en	66.040	1656.000	66.040	partially fulfilled	DHL	2	t		4000		PLN	{}	{}	35	\N	\N	0.000	0.000	0.000		\N	\N		2024-05-20 11:17:40.81971+00	f	15	\N	1656.000	full	none	'05951':13B,24B '097':5B,16B '118223585':34C '128223581':40C '15':1A '40':28C '420':38C '45':39C '49182235821':29C '506':9B,20B '818223582':25C 'balance':37C 'blue':26C 'crossroad':7B,18B 'cubes':30C 'fountain':31C 'gallego':6B,17B 'm':33C,43C 'mccallberg':12B,23B 'paul':35C 'plimsolls':27C 'reid':4B,15B 'ryan':3B,14B 'ryan.reid@example.com':2A 's':36C 'shirt':42C 'suit':8B,19B 'team':41C 'tee':32C 'tr':11B,22B 'türkiy':10B,21B	t	f	66.040	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:17:40.848726+00		michael.leonard@example.com	ffda684a-ece1-4c21-9027-01c6bb7a9347	24	24	\N	203.200	\N	en	23.200	203.200	23.200	partially fulfilled	China Post	9	t		1000		PLN	{}	{}	35	\N	\N	0.000	0.000	0.000		\N	\N		2024-05-20 11:17:41.128439+00	f	16	\N	203.200	full	none	'16':1A '31845':5B,17B '77234':14B,26B '922':9B,21B 'leonard':4B,16B 'michael':3B,15B 'michael.leonard@example.com':2A 'nathaniel':6B,18B 'neck':7B,19B,27C 'new':12B,24B 'suit':8B,20B 'tr':11B,23B 'türkiy':10B,22B 'uhjvzhvjdfzhcmlhbnq6mzcw':29C 'warmer':28C 'williamstad':13B,25B	t	f	23.200	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:17:41.150778+00		jamie.herman@example.com	c3582d23-2cf4-4dd6-b502-a63de106ee28	25	25	\N	1397.400	\N	en	82.420	1397.400	82.420	partially fulfilled	DB Schenker	5	t		2000		PLN	{}	{}	35	\N	\N	0.000	0.000	0.000		\N	\N		2024-05-20 11:17:41.554841+00	f	17	\N	0.000	none	none	'118223583':39C '17':1A '332':5B,17B '41':34C,44C '420':43C '60217':14B,26B '719':9B,21B '918223584':31C 'apt':8B,20B 'balance':42C 'caitlinfort':13B,25B 'cushion':29C 'dash':28C 'dimmed':36C 'herman':4B,16B 'jami':3B,15B 'jamie.herman@example.com':2A 'kathleen':6B,18B 'knoll':7B,19B 'monokai':35C 'new':12B,24B 'paul':40C 'plimsolls':33C 's':41C 'sunnies':37C 'the':27C 'tr':11B,23B 'türkiy':10B,22B 'uhjvzhvjdfzhcmlhbnq6mzg4':38C 'uhjvzhvjdfzhcmlhbnq6mzgz':30C 'white':32C	t	f	82.420	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:17:41.58189+00		susan.phillips@example.com	b24288be-8b7f-470b-a35b-cb7347c7658e	15	15	\N	126.020	\N	en	66.040	126.020	66.040	unfulfilled	DHL	2	t		0		PLN	{}	{}	35	\N	\N	0.000	0.000	126.020		\N	\N		2024-05-20 11:17:41.808775+00	f	18	\N	0.000	full	full	'113223582':27C '18':1A '358':9B,21B '38650':14B,26B '91189':5B,17B 'apt':8B,20B 'cloud':29C 'drive':7B,19B 'east':12B,24B 'enterprise':28C 'kari':13B,25B 'moor':6B,18B 'on':31C 'on-premises':30C 'phillip':4B,16B 'premises':32C 'susan':3B,15B 'susan.phillips@example.com':2A 'tr':11B,23B 'türkiy':10B,22B 'vinyl':33C	t	f	66.040	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:17:41.835496+00		lisa.hansen@example.com	f925fcfe-aeea-48b8-bada-37d349cbc485	23	23	\N	591.230	\N	en	1.230	591.230	1.230	partially fulfilled	EMS	12	t		3000		USD	{}	{}	34	\N	\N	0.000	0.000	591.230		\N	\N		2024-05-20 11:17:42.195829+00	f	19	\N	0.000	full	full	'184':9B,21B '19':1A '218223580':27C '23732':5B,17B '39':38C '58406':14B,26B '918223582':35C 'blue':28C 'grey':32C 'hansen':4B,16B 'hoodie':33C 'island':7B,19B 'kenneth':13B,25B 'lake':12B,24B 'lisa':3B,15B 'lisa.hansen@example.com':2A 'm':31C 'michael':6B,18B 'plimsolls':37C 'polygon':29C 'shirt':30C 'suit':8B,20B 'tr':11B,23B 'türkiy':10B,22B 'uhjvzhvjdfzhcmlhbnq6mzq1':34C 'white':36C	t	f	1.230	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:17:42.220722+00		natalie.simpson@example.com	4abcac1e-c1ac-45b4-bbd2-bb04ec61ed2b	10	10	\N	127.190	\N	en	1.230	127.190	1.230	partially fulfilled	EMS	12	t		1000		USD	{}	{}	34	\N	\N	0.000	0.000	0.000		\N	\N		2024-05-20 11:17:42.548712+00	f	20	\N	127.190	full	none	'113223585':33C '118223584':27C '20':1A '20935':14B,26B '42':32C '420':31C '508':9B,21B '7389':5B,17B 'a':47C 'alec':6B,18B 'balance':30C 'cd':39C 'cloud':35C 'enterprise':34C 'headless':41C,44C 'headless-omnichannel-mp3':40C 'in':46C 'jonathan':13B,25B 'mp3':43C,49C 'natali':3B,15B 'natalie.simpson@example.com':2A 'omnichannel':42C,45C 'on':37C 'on-premises':36C 'paul':28C 'pill':48C 'port':12B,24B 'premises':38C 's':29C 'simpson':4B,16B 'squar':7B,19B 'suit':8B,20B 'tr':11B,23B 'türkiy':10B,22B	t	f	1.230	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:18:00.28815+00		mary.lyons@example.com	ef646742-2b8f-4410-98da-faeb31d130a9	91	91	\N	50.930	\N	en	10.930	50.930	10.930	unfulfilled	Post Office	20	t		2000		USD	{}	{}	34	\N	\N	0.000	0.000	0.000		\N	\N		2024-05-20 11:18:00.590735+00	f	21	\N	50.930	full	none	'21':1A '3230':5B,15B '328223582':23C '78866':12B,22B 'beanie':29C 'christian':11B,21B 'julia':6B,16B 'l':26C 'lake':10B,20B 'lyon':4B,14B 'mari':3B,13B 'mary.lyons@example.com':2A 'monospace':24C 'pirate':27C 's':28C 'tee':25C 'tr':9B,19B 'türkiy':8B,18B 'uhjvzhvjdfzhcmlhbnq6mzy4':30C 'villag':7B,17B	t	f	10.930	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:18:00.667901+00		jennifer.mendez@example.com	67218714-3be3-4309-8b91-cb793d79af24	92	92	\N	89.160	\N	en	9.160	89.160	9.160	unconfirmed	FedEx	34	t		1000		USD	{}	{}	34	\N	\N	0.000	0.000	89.160		\N	\N		2024-05-20 11:18:00.915122+00	f	22	\N	0.000	full	full	'128223581':23C '22':1A '47137':12B,22B '5600':5B,15B 'davi':6B,16B 'highway':7B,17B 'jennif':3B,13B 'jennifer.mendez@example.com':2A 'joel':11B,21B 'm':26C 'mendez':4B,14B 'shirt':25C 'south':10B,20B 'team':24C 'tr':9B,19B 'türkiy':8B,18B	t	f	9.160	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:18:00.939589+00		matthew.pratt@example.com	d82f243a-1b5c-4581-a33d-9a28f4dc3c6f	93	93	\N	26.750	\N	en	20.760	26.750	20.760	unconfirmed	Post Office	20	t		100		PLN	{}	{}	35	\N	\N	0.000	0.000	26.750		\N	\N		2024-05-20 11:18:01.168864+00	f	23	\N	0.000	full	full	'03212':14B,26B '076':9B,21B '23':1A '48487':5B,17B 'carrot':27C 'juice':28C 'kendra':6B,18B 'matthew':3B,15B 'matthew.pratt@example.com':2A 'michaelton':13B,25B 'port':7B,19B 'pratt':4B,16B 'south':12B,24B 'suit':8B,20B 'tr':11B,23B 'türkiy':10B,22B 'uhjvzhvjdfzhcmlhbnq6mzg3':29C	t	f	20.760	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:18:01.190565+00		shannon.rhodes@example.com	b715c50a-bc26-4726-a6ce-175e4361ce26	72	72	\N	1056.860	\N	en	9.890	1056.860	9.890	partially fulfilled	DHL	13	t		3000		PLN	{}	{}	35	\N	\N	0.000	0.000	0.000		\N	\N		2024-05-20 11:18:01.499449+00	f	24	\N	1056.860	full	none	'118223585':23C '24':1A '41':32C '420':27C '45':28C '6430':5B,15B '72117':12B,22B '918223584':29C 'balance':26C 'cindi':6B,16B 'cove':7B,17B 'neck':33C 'nichola':11B,21B 'paul':24C 'plimsolls':31C 'rhode':4B,14B 's':25C 'shannon':3B,13B 'shannon.rhodes@example.com':2A 'south':10B,20B 'tr':9B,19B 'türkiy':8B,18B 'uhjvzhvjdfzhcmlhbnq6mzcw':35C 'warmer':34C 'white':30C	t	f	9.890	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:18:01.513967+00		joshua.carr@example.com	1c468654-68d6-4b80-a937-bbcdc75135db	57	57	\N	411.040	\N	en	66.040	411.040	66.040	unconfirmed	DHL	2	t		2000		PLN	{}	{}	35	\N	\N	0.000	0.000	0.000		\N	\N		2024-05-20 11:18:01.732906+00	f	25	\N	411.040	full	none	'128223583':29C '180':5B,16B '22731':13B,24B '25':1A '328223584':25C '661':9B,20B 'burg':7B,18B 'carr':4B,15B 'jennif':6B,17B 'joshua':3B,14B 'joshua.carr@example.com':2A 'monospace':26C 'munozburgh':12B,23B 'shirt':31C 'suit':8B,19B 'team':30C 'tee':27C 'tr':11B,22B 'türkiy':10B,21B 'xl':32C 'xxl':28C	t	f	66.040	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:18:01.780446+00		matthew.blackburn@example.com	40f2a9fc-c24c-4d97-a756-9cec06c5620a	52	52	\N	440.930	\N	en	10.930	440.930	10.930	partially fulfilled	Post Office	20	t		3000		USD	{}	{}	34	\N	\N	0.000	0.000	0.000		\N	\N		2024-05-20 11:18:02.157293+00	f	26	\N	0.000	none	none	'112223580':30C '112223582':25C '22395':5B,14B '26':1A '43':24C '83819':11B,20B '918223586':21C 'blackburn':4B,13B 'dark':26C,31C 'l':29C 'matthew':3B,12B 'matthew.blackburn@example.com':2A 'plimsolls':23C 'polygon':27C,32C 'road':7B,16B 's':34C 'tee':28C,33C 'timothi':6B,15B 'tr':9B,18B 'türkiy':8B,17B 'white':22C 'williamsburi':10B,19B	t	f	10.930	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:18:02.176048+00		paul.flowers@example.com	273b2205-ebf5-427a-bcf2-8d2476ef74a4	94	94	\N	161.060	\N	en	9.160	161.060	9.160	partially fulfilled	FedEx	34	t		1000		USD	{}	{}	34	\N	\N	0.000	0.000	0.000		\N	\N		2024-05-20 11:18:02.435641+00	f	27	\N	161.060	full	none	'118223585':27C '19539':5B,17B '27':1A '420':31C '45':32C '48105':14B,26B '509':9B,21B 'apt':8B,20B 'balance':30C 'dimmed':34C 'ericstad':13B,25B 'flower':4B,16B 'martin':6B,18B 'monokai':33C 'new':12B,24B 'paul':3B,15B,28C 'paul.flowers@example.com':2A 's':29C 'sunnies':35C 'tr':11B,23B 'türkiy':10B,22B 'uhjvzhvjdfzhcmlhbnq6mzg4':36C 'way':7B,19B	t	f	9.160	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:18:02.457876+00		marcus.patton@example.com	a34786b7-9bda-4afd-b112-2a08c3ea1674	95	95	\N	200.870	\N	en	20.870	200.870	20.870	unconfirmed	UPS	14	t		2000		USD	{}	{}	34	\N	\N	0.000	0.000	200.870		\N	\N		2024-05-20 11:18:02.730102+00	f	28	\N	0.000	full	full	'02907':5B,17B '23285':14B,26B '28':1A '493':9B,21B 'blue':30C 'branch':7B,19B 'hoodie':31C 'marcus':3B,15B 'marcus.patton@example.com':2A 'matthew':6B,18B 'neck':27C 'new':12B,24B 'patton':4B,16B 'sharonview':13B,25B 'suit':8B,20B 'tr':11B,23B 'türkiy':10B,22B 'uhjvzhvjdfzhcmlhbnq6mzcw':29C 'uhjvzhvjdfzhcmlhbnq6mzq2':32C 'warmer':28C	t	f	20.870	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:18:02.759382+00		donna.moore@example.com	3b8345c5-9520-4881-900d-196ccbf1ca8b	96	96	\N	224.130	\N	en	4.130	224.130	4.130	unconfirmed	TNT	29	t		3000		USD	{}	{}	34	\N	\N	0.000	0.000	0.000		\N	\N		2024-05-20 11:18:03.06192+00	f	29	\N	224.130	full	none	'128223582':32C '29':1A '34342':12B,22B '44':31C '49182235820':23C '896':5B,15B '918223587':28C 'baker':6B,16B 'cubes':24C 'donna':3B,13B 'donna.moore@example.com':2A 'fountain':25C 'haven':7B,17B 'kimberlyview':11B,21B 'l':35C 'moor':4B,14B 'plimsolls':30C 's':27C 'shirt':34C 'south':10B,20B 'team':33C 'tee':26C 'tr':9B,19B 'türkiy':8B,18B 'white':29C	t	f	4.130	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:18:03.105136+00		veronica.lee@example.com	dfa31232-7eef-4bac-b390-de66b8cced9d	97	97	\N	598.950	\N	en	41.970	598.950	41.970	partially fulfilled	fastway couriers	38	t		2000		PLN	{}	{}	35	\N	\N	0.000	0.000	0.000		\N	\N		2024-05-20 11:18:03.482145+00	f	30	\N	598.950	full	none	'08296':5B,16B '113223585':29C '30':1A '328223581':25C '42':39C '818223584':36C '89663':13B,24B '930':9B,20B 'allisonburgh':12B,23B 'blue':37C 'camp':7B,18B 'cd':35C 'cloud':31C 'enterprise':30C 'lee':4B,15B 'm':28C 'marshal':6B,17B 'monospace':26C 'on':33C 'on-premises':32C 'plimsolls':38C 'premises':34C 'suit':8B,19B 'tee':27C 'tr':11B,22B 'türkiy':10B,21B 'veronica':3B,14B 'veronica.lee@example.com':2A	t	f	41.970	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:18:03.504483+00		courtney.crawford@example.com	46a3674f-1d4f-44c2-b059-1939c41489e7	98	98	\N	537.590	\N	en	37.590	537.590	37.590	partially fulfilled	Royale International	36	t		2000		USD	{}	{}	34	\N	\N	0.000	0.000	537.590		\N	\N		2024-05-20 11:18:03.831422+00	f	31	\N	0.000	full	full	'100':25C '31':1A '328223581':27C '342':5B,15B '67203':12B,22B 'blue':31C 'card':24C 'courtney':3B,13B 'courtney.crawford@example.com':2A 'crawford':4B,14B 'gift':23C 'hoodie':32C 'jennif':11B,21B 'lake':10B,20B 'm':30C 'miller':6B,16B 'mission':7B,17B 'monospace':28C 'tee':29C 'tr':9B,19B 'türkiy':8B,18B 'uhjvzhvjdfzhcmlhbnq6mzkz':26C 'uhjvzhvjdfzhcmlhbnq6mzq2':33C	t	f	37.590	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:18:03.857662+00		deanna.kennedy@example.com	5e0958b4-f7d9-4309-9f5d-1d9cfc11db8a	66	66	\N	307.130	\N	en	4.130	307.130	4.130	partially fulfilled	TNT	29	t		2000		USD	{}	{}	34	\N	\N	0.000	0.000	0.000		\N	\N		2024-05-20 11:18:04.276665+00	f	32	\N	0.000	none	none	'124223581':21C '128223581':33C '218223581':28C '32':1A '73395':11B,20B '85249':5B,14B 'and':25C 'blue':29C 'cliff':7B,16B 'data':26C 'deanna':3B,12B 'deanna.kennedy@example.com':2A 'itunes':27C 'kennedi':4B,13B 'l':32C 'longchest':10B,19B 'm':36C 'own':22C 'polygon':30C 'shirt':31C,35C 'stack':24C 'stephen':6B,15B 'team':34C 'tr':9B,18B 'türkiy':8B,17B 'your':23C	t	f	4.130	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:18:04.30108+00		patrick.hendricks@example.com	8b90a8ae-754a-4355-9dc1-a431dcbdabc8	56	56	\N	398.940	\N	en	98.940	398.940	98.940	partially fulfilled	FBA	6	t		4000		USD	{}	{}	34	\N	\N	0.000	0.000	398.940		\N	\N		2024-05-20 11:18:04.687105+00	f	33	\N	0.000	full	full	'111223582':25C '118223583':32C '128223581':21C '31567':11B,20B '33':1A '41':37C '420':36C '769':5B,14B 'amyfort':10B,19B 'balance':35C 'darko':26C 'harbor':7B,16B 'hendrick':4B,13B 'm':24C 'mari':6B,15B 'neck':29C 'patrick':3B,12B 'patrick.hendricks@example.com':2A 'paul':33C 'polo':27C 's':34C 'shirt':23C 'team':22C 'tr':9B,18B 'türkiy':8B,17B 'uhjvzhvjdfzhcmlhbnq6mzcw':31C 'warmer':30C 'xxl':28C	t	f	98.940	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:19:48.68333+00		rachel.hanson@example.com	92942735-68ad-4777-8a75-a8500ab04191	61	61	\N	344.130	\N	en	4.130	344.130	4.130	partially fulfilled	TNT	10	t		3000		USD	{}	{}	34	\N	\N	0.000	0.000	0.000		\N	\N		2024-05-20 11:19:49.125209+00	f	67	\N	344.130	full	none	'118223582':33C '39':32C '40':38C '420':37C '44':28C '45920':13B,24B '516':5B,16B '67':1A '826':9B,20B '918223582':29C '918223587':25C 'balance':36C 'hanson':4B,15B 'jimmyfurt':12B,23B 'junction':7B,18B 'nolan':6B,17B 'paul':34C 'plimsolls':27C,31C 'rachel':3B,14B 'rachel.hanson@example.com':2A 's':35C 'suit':8B,19B 'tr':11B,22B 'türkiy':10B,21B 'white':26C,30C	t	f	4.130	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:18:04.716672+00		sarah.walters@example.com	75f316e4-b6bb-420b-98fb-9ede3d474e23	99	99	\N	587.950	\N	en	15.100	587.950	15.100	partially fulfilled	EMS	35	t		1100		PLN	{}	{}	35	\N	\N	0.000	0.000	0.000		\N	\N		2024-05-20 11:18:05.05842+00	f	34	\N	0.000	none	none	'113223582':28C '118223582':35C '34':1A '40':40C '420':39C '436':9B,20B '6595':5B,16B '91871':13B,24B 'apt':8B,19B 'balance':38C 'banana':25C 'cloud':30C 'enterprise':29C 'grahamfurt':12B,23B 'juice':26C 'kurt':6B,17B 'on':32C 'on-premises':31C 'park':7B,18B 'paul':36C 'premises':33C 's':37C 'sarah':3B,14B 'sarah.walters@example.com':2A 'tr':11B,22B 'türkiy':10B,21B 'uhjvzhvjdfzhcmlhbnq6mzg2':27C 'vinyl':34C 'walter':4B,15B	t	f	15.100	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:19:49.148685+00		regina.larson@example.com	fbe88788-a5b7-4892-a6fe-bd82cbdea47b	156	156	\N	598.540	\N	en	22.580	598.540	22.580	partially fulfilled	ACE	18	t		1100		PLN	{}	{}	35	\N	\N	0.000	0.000	0.000		\N	\N		2024-05-20 11:19:49.411899+00	f	68	\N	598.540	full	none	'113223585':23C '38471':12B,22B '44851':5B,15B '68':1A '9182235821':33C 'carrot':30C 'cd':29C 'cloud':25C 'enterprise':24C 'juice':31C 'larson':4B,14B 'monotype':35C 'north':10B,20B 'on':27C 'on-premises':26C 'pamela':6B,16B 'premises':28C 'regina':3B,13B 'regina.larson@example.com':2A 'reversed':34C 'robert':11B,21B 'tee':36C 'tr':9B,19B 'track':7B,17B 'türkiy':8B,18B 'uhjvzhvjdfzhcmlhbnq6mzg3':32C 'xxl':37C	t	f	22.580	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:18:05.087066+00		shannon.rhodes@example.com	551fabef-9899-4a41-9a6b-fc756e61a4fb	72	72	\N	327.300	\N	en	92.300	327.300	92.300	unconfirmed	Royale International	17	t		2000		PLN	{}	{}	35	\N	\N	0.000	0.000	327.300		\N	\N		2024-05-20 11:18:05.323298+00	f	35	\N	0.000	full	full	'328223580':26C '35':1A '6430':5B,15B '72117':12B,22B 'cindi':6B,16B 'cove':7B,17B 'grey':23C 'hoodie':24C 'monospace':27C 'nichola':11B,21B 'rhode':4B,14B 's':29C 'shannon':3B,13B 'shannon.rhodes@example.com':2A 'south':10B,20B 'tee':28C 'tr':9B,19B 'türkiy':8B,18B 'uhjvzhvjdfzhcmlhbnq6mzq1':25C	t	f	92.300	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:19:49.438304+00		kevin.kelly@example.com	8f4eb78f-e9e3-4e70-9110-72973e0e83d1	164	164	\N	620.760	\N	en	20.760	620.760	20.760	partially fulfilled	Post Office	39	t		2000		PLN	{}	{}	35	\N	\N	0.000	0.000	620.760		\N	\N		2024-05-20 11:19:49.747635+00	f	69	\N	0.000	full	full	'112223581':23C '218223582':28C '250':5B,15B '69':1A '86205':12B,22B 'alexand':11B,21B 'blue':29C 'burg':7B,17B 'burton':6B,16B 'dark':24C 'kelli':4B,14B 'kevin':3B,13B 'kevin.kelly@example.com':2A 'm':27C 'north':10B,20B 'polygon':25C,30C 'shirt':31C 'tee':26C 'tr':9B,19B 'türkiy':8B,18B 'xl':32C	t	f	20.760	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:18:05.34896+00		elizabeth.smith@example.com	fde48e98-dc8c-4d8c-b1f0-605ba9da1f87	83	83	\N	128.400	\N	en	78.400	128.400	78.400	unfulfilled	UPS	22	t		1000		USD	{}	{}	34	\N	\N	0.000	0.000	0.000		\N	\N		2024-05-20 11:18:05.613235+00	f	36	\N	0.000	none	none	'36':1A '90443':5B,15B '9182235820':23C '94393':12B,22B 'elizabeth':3B,13B 'elizabeth.smith@example.com':2A 'height':7B,17B 'karen':6B,16B 'monotype':25C 'north':10B,20B 'reversed':24C 'ryan':11B,21B 'smith':4B,14B 'tee':26C 'tr':9B,19B 'türkiy':8B,18B 'xl':27C	t	f	78.400	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:18:05.634984+00		melvin.willis@example.com	fbc2f983-baab-436e-bddf-330707e3bfd5	38	38	\N	203.590	\N	en	45.990	203.590	45.990	unconfirmed	ACE	37	t		2000		USD	{}	{}	34	\N	\N	0.000	0.000	203.590		\N	\N		2024-05-20 11:18:05.933518+00	f	37	\N	0.000	full	full	'20843':11B,20B '328223583':21C '37':1A '49182235822':25C '82434':5B,14B 'cubes':26C 'dimmed':31C 'fountain':27C 'glen':7B,16B 'grave':6B,15B 'l':29C 'melvin':3B,12B 'melvin.willis@example.com':2A 'monokai':30C 'monospace':22C 'sunnies':32C 'tee':23C,28C 'tr':9B,18B 'türkiy':8B,17B 'uhjvzhvjdfzhcmlhbnq6mzg4':33C 'willi':4B,13B 'xl':24C 'zacharymouth':10B,19B	t	f	45.990	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:19:51.039654+00		matthew.jenkins@example.com	d40722d7-59be-423b-a091-7f3b37bee0e1	58	58	\N	214.130	\N	en	4.130	214.130	4.130	unconfirmed	TNT	10	t		1000		USD	{}	{}	34	\N	\N	0.000	0.000	214.130		\N	\N		2024-05-20 11:19:51.299874+00	f	74	\N	0.000	full	full	'155':5B,16B '218223581':25C '43056':13B,24B '74':1A '803':9B,20B 'blue':26C 'courtney':6B,17B 'cushion':32C 'gregoryshir':12B,23B 'jenkin':4B,15B 'l':29C 'matthew':3B,14B 'matthew.jenkins@example.com':2A 'parrot':31C 'polygon':27C 'shirt':28C 'suit':8B,19B 'tr':11B,22B 'trafficway':7B,18B 'türkiy':10B,21B 'uhjvzhvjdfzhcmlhbnq6mzk5':33C 'white':30C	t	f	4.130	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:18:05.958815+00		lisa.hansen@example.com	a30862b4-64f6-42ee-ba0e-b81771076c21	23	23	\N	62.560	\N	en	52.560	62.560	52.560	fulfilled	Aramex	11	t		1000		USD	{}	{}	34	\N	\N	0.000	0.000	62.560		\N	\N		2024-05-20 11:18:06.250649+00	f	38	\N	0.000	full	full	'184':9B,21B '23732':5B,17B '328223583':27C '38':1A '58406':14B,26B 'hansen':4B,16B 'island':7B,19B 'kenneth':13B,25B 'lake':12B,24B 'lisa':3B,15B 'lisa.hansen@example.com':2A 'michael':6B,18B 'monospace':28C 'suit':8B,20B 'tee':29C 'tr':11B,23B 'türkiy':10B,22B 'xl':30C	t	f	52.560	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:18:06.269676+00		raymond.mccall@example.com	19dadc8a-3dad-4161-b2c0-c2feacbc252e	100	100	\N	326.960	\N	en	71.960	326.960	71.960	partially fulfilled	FedEx Express	26	t		4000		USD	{}	{}	34	\N	\N	0.000	0.000	0.000		\N	\N		2024-05-20 11:18:06.613202+00	f	39	\N	326.960	full	none	'118223582':25C '128223580':21C '19550':5B,14B '39':1A '40':30C '41762':11B,20B '420':29C '9182235821':34C 'balance':28C 'creek':7B,16B 'jame':6B,15B 'mccall':4B,13B 'monotype':36C 'neck':31C 'paul':26C 'raymond':3B,12B 'raymond.mccall@example.com':2A 'reversed':35C 's':24C,27C 'shirt':23C 'team':22C 'tee':37C 'tr':9B,18B 'türkiy':8B,17B 'uhjvzhvjdfzhcmlhbnq6mzcw':33C 'warmer':32C 'williamstown':10B,19B 'xxl':38C	t	f	71.960	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:18:06.640577+00		tracey.hubbard@example.com	806e024e-cf80-4860-8e3a-0998863844c8	101	101	\N	1285.940	\N	en	93.870	1285.940	93.870	unconfirmed	DHL	21	t		1100		USD	{}	{}	34	\N	\N	0.000	0.000	0.000		\N	\N		2024-05-20 11:18:07.062634+00	f	40	\N	0.000	none	none	'113223585':34C '24122':14B,26B '270':9B,21B '2926':5B,17B '40':1A '42':44C '500':29C '618223584':41C 'angelafurt':13B,25B 'apt':8B,20B 'banana':31C 'card':28C 'cd':40C 'cloud':36C 'dash':42C 'dixon':6B,18B 'enterprise':35C 'estat':7B,19B 'force':43C 'gift':27C 'hubbard':4B,16B 'juice':32C 'on':38C 'on-premises':37C 'port':12B,24B 'premises':39C 'tr':11B,23B 'tracey':3B,15B 'tracey.hubbard@example.com':2A 'türkiy':10B,22B 'uhjvzhvjdfzhcmlhbnq6mzg2':33C 'uhjvzhvjdfzhcmlhbnq6ndaw':30C	t	f	93.870	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:19:49.774958+00		michael.beck@example.com	3a5e7571-ce32-4f93-9309-a10b27922bda	165	165	\N	563.280	\N	en	93.320	563.280	93.320	unconfirmed	FedEx Express	7	t		0		PLN	{}	{}	35	\N	\N	0.000	0.000	0.000		\N	\N		2024-05-20 11:19:50.008877+00	f	70	\N	563.280	full	none	'124223582':25C '35070':11B,20B '70':1A '76254':5B,14B '9018223582':32C 'and':29C 'at':36C 'battle':34C 'battle-tested':33C 'beck':4B,13B 'brands':37C 'data':30C 'debra':6B,15B 'dimmed':22C 'dvd':40C 'like':38C 'lush':39C 'michael':3B,12B 'michael.beck@example.com':2A 'monokai':21C 'mp3':31C 'own':26C 'reyeschest':10B,19B 'stack':28C 'stream':7B,16B 'sunnies':23C 'tested':35C 'tr':9B,18B 'türkiy':8B,17B 'uhjvzhvjdfzhcmlhbnq6mzg4':24C 'your':27C	t	f	93.320	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:19:50.035565+00		katherine.cunningham@example.com	a5cf238a-a9e0-49bb-9eb6-c70926c5480f	166	166	\N	35.160	\N	en	12.200	35.160	12.200	unconfirmed	Aramex	49	t		100		PLN	{}	{}	35	\N	\N	0.000	0.000	35.160		\N	\N		2024-05-20 11:19:50.295007+00	f	71	\N	0.000	full	full	'124223581':23C '23605':12B,22B '6208':5B,15B '71':1A 'and':27C 'apple':30C 'christi':6B,16B 'cunningham':4B,14B 'data':28C 'itunes':29C 'juice':31C 'katherin':3B,13B 'katherine.cunningham@example.com':2A 'mark':11B,21B 'north':10B,20B 'own':24C 'shore':7B,17B 'stack':26C 'tr':9B,19B 'türkiy':8B,18B 'uhjvzhvjdfzhcmlhbnq6mzg0':32C 'your':25C	t	f	12.200	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:19:50.317814+00		sue.kemp@example.com	04a35c73-4ef1-4975-bb56-6e00f11ad33e	167	167	\N	371.960	\N	en	71.960	371.960	71.960	unfulfilled	FedEx Express	45	t		3000		USD	{}	{}	34	\N	\N	0.000	0.000	371.960		\N	\N		2024-05-20 11:19:50.630642+00	f	72	\N	0.000	full	full	'111223582':38C '118223584':32C '169':5B,15B '33593':12B,22B '42':37C '420':36C '72':1A '9182235821':23C 'balance':35C 'carolyn':11B,21B 'christin':6B,16B 'cushion':30C 'darko':39C 'kemp':4B,14B 'monotype':25C 'mount':7B,17B 'new':10B,20B 'parrot':29C 'paul':33C 'polo':40C 'reversed':24C 's':34C 'sue':3B,13B 'sue.kemp@example.com':2A 'tee':26C 'tr':9B,19B 'türkiy':8B,18B 'uhjvzhvjdfzhcmlhbnq6mzk5':31C 'white':28C 'xxl':27C,41C	t	f	71.960	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:19:50.663145+00		anthony.randolph@example.com	f51baf78-a4eb-4393-947c-fe096cc10e9d	168	168	\N	892.400	\N	en	82.420	892.400	82.420	partially fulfilled	DB Schenker	43	t		2000		PLN	{}	{}	35	\N	\N	0.000	0.000	0.000		\N	\N		2024-05-20 11:19:51.014883+00	f	73	\N	892.400	full	none	'113223583':35C '128223582':27C '1542':5B,15B '328223581':23C '44756':12B,22B '73':1A 'anthoni':3B,13B 'anthony.randolph@example.com':2A 'cloud':37C 'cushion':33C 'dash':32C 'dvd':41C 'enterprise':36C 'karen':11B,21B 'knoll':7B,17B 'l':30C 'lake':10B,20B 'm':26C 'monospace':24C 'on':39C 'on-premises':38C 'premises':40C 'randolph':4B,14B 'shirt':29C 'team':28C 'tee':25C 'the':31C 'tr':9B,19B 'türkiy':8B,18B 'uhjvzhvjdfzhcmlhbnq6mzgz':34C 'young':6B,16B	t	f	82.420	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:19:51.327561+00		lance.lester@example.com	225ab765-e8c1-4c08-832a-4558ed064509	169	169	\N	855.100	\N	en	15.100	855.100	15.100	fulfilled	EMS	16	t		1000		PLN	{}	{}	35	\N	\N	0.000	0.000	0.000		\N	\N		2024-05-20 11:19:51.558771+00	f	75	\N	855.100	full	none	'33782':14B,26B '41':30C '570':9B,21B '618223583':27C '75':1A '89840':5B,17B 'crest':7B,19B 'dash':28C 'force':29C 'foster':6B,18B 'jodyton':13B,25B 'lanc':3B,15B 'lance.lester@example.com':2A 'lester':4B,16B 'suit':8B,20B 'tr':11B,23B 'türkiy':10B,22B 'west':12B,24B	t	f	15.100	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:19:51.580202+00		andrew.taylor@example.com	d55cb189-c636-4adc-8709-d43cddae9e02	65	65	\N	411.720	\N	en	9.750	411.720	9.750	partially fulfilled	DB Schenker	5	t		2000		USD	{}	{}	34	\N	\N	0.000	0.000	0.000		\N	\N		2024-05-20 11:19:52.00444+00	f	76	\N	0.000	none	none	'079':9B,21B '113223585':31C '42':30C '618223584':27C '72694':14B,26B '76':1A '79061':5B,17B 'andrew':3B,15B 'andrew.taylor@example.com':2A 'blue':38C 'cd':37C 'cloud':33C 'cook':6B,18B 'dash':28C 'enterprise':32C 'force':29C 'hoodie':39C 'marissafort':13B,25B 'on':35C 'on-premises':34C 'parkway':7B,19B 'premises':36C 'suit':8B,20B 'taylor':4B,16B 'tr':11B,23B 'türkiy':10B,22B 'uhjvzhvjdfzhcmlhbnq6mzq2':40C 'west':12B,24B	t	f	9.750	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:19:52.036025+00		kathryn.black@example.com	40fd51b7-e177-45e6-a439-60134b95c707	170	170	\N	804.700	\N	en	94.710	804.700	94.710	partially fulfilled	TNT	29	t		2000		PLN	{}	{}	35	\N	\N	0.000	0.000	0.000		\N	\N		2024-05-20 11:19:52.372512+00	f	77	\N	804.700	full	none	'100':40C '124223581':27C '20970':14B,26B '225':9B,21B '3195':5B,17B '328223581':34C '49182235820':42C '77':1A 'and':31C 'black':4B,16B 'brenda':6B,18B 'card':39C 'cubes':43C 'data':32C 'fountain':44C 'gift':38C 'itunes':33C 'kathryn':3B,15B 'kathryn.black@example.com':2A 'lisashir':13B,25B 'm':37C 'monospace':35C 'new':12B,24B 'own':28C 's':46C 'stack':30C 'stravenu':7B,19B 'suit':8B,20B 'tee':36C,45C 'tr':11B,23B 'türkiy':10B,22B 'uhjvzhvjdfzhcmlhbnq6mzkz':41C 'your':29C	t	f	94.710	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:19:52.397571+00		kelly.carter@example.com	6796b775-e1c5-46cf-949a-769dff727f49	171	171	\N	398.940	\N	en	98.940	398.940	98.940	unfulfilled	FBA	25	t		2000		USD	{}	{}	34	\N	\N	0.000	0.000	0.000		\N	\N		2024-05-20 11:19:52.635003+00	f	78	\N	398.940	full	none	'09708':13B,24B '43':33C '49182235820':25C '507':9B,20B '618223585':30C '78':1A '9620':5B,16B 'apt':8B,19B 'ashley':6B,17B 'carter':4B,15B 'cubes':26C 'dash':31C 'force':32C 'fountain':27C 'julieborough':12B,23B 'kelli':3B,14B 'kelly.carter@example.com':2A 'mill':7B,18B 's':29C 'tee':28C 'tr':11B,22B 'türkiy':10B,21B	t	f	98.940	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:19:52.700682+00		joshua.greer@example.com	301b3825-9fea-411e-8500-51a9e126e150	172	172	\N	2146.120	\N	en	10.130	2146.120	10.130	unconfirmed	UPS	14	t		2100		PLN	{}	{}	35	\N	\N	0.000	0.000	2146.120		\N	\N		2024-05-20 11:19:53.017389+00	f	79	\N	0.000	full	full	'112223581':28C '29188':5B,14B '41':24C '618223583':21C '79':1A '94599':11B,20B 'banana':25C 'dark':29C 'dash':22C 'fischer':6B,15B 'force':23C 'greer':4B,13B 'grove':7B,16B 'joshua':3B,12B 'joshua.greer@example.com':2A 'juice':26C 'justinchest':10B,19B 'm':32C 'polygon':30C 'tee':31C 'tr':9B,18B 'türkiy':8B,17B 'uhjvzhvjdfzhcmlhbnq6mzg2':27C	t	f	10.130	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:19:53.048968+00		amanda.spencer@example.com	bde60da5-c90b-449c-aa2d-805c2e596087	173	173	\N	44.160	\N	en	9.160	44.160	9.160	unfulfilled	FedEx	15	t		1000		USD	{}	{}	34	\N	\N	0.000	0.000	44.160		\N	\N		2024-05-20 11:19:53.28305+00	f	80	\N	0.000	full	full	'62082':5B,16B '80':1A '89663':13B,24B '930':9B,20B 'allisonburgh':12B,23B 'amanda':3B,14B 'amanda.spencer@example.com':2A 'blue':25C 'camp':7B,18B 'hoodie':26C 'spencer':4B,15B 'suit':8B,19B 'tr':11B,22B 'türkiy':10B,21B 'uhjvzhvjdfzhcmlhbnq6mzq2':27C 'ward':6B,17B	t	f	9.160	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:19:53.309149+00		christopher.williams@example.com	9c5a0a36-65db-43c5-905f-cab7fc47851a	51	51	\N	412.580	\N	en	22.580	412.580	22.580	unfulfilled	ACE	37	t		1000		PLN	{}	{}	35	\N	\N	0.000	0.000	0.000		\N	\N		2024-05-20 11:19:53.481116+00	f	81	\N	412.580	full	none	'028':9B,20B '0811':5B,16B '49182235824':25C '49874':13B,24B '81':1A 'christoph':3B,14B 'christopher.williams@example.com':2A 'court':7B,18B 'cubes':26C 'fountain':27C 'howard':6B,17B 'suit':8B,19B 'susantown':12B,23B 'tee':28C 'tr':11B,22B 'türkiy':10B,21B 'william':4B,15B 'xxl':29C	t	f	22.580	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:19:53.541247+00		susan.phillips@example.com	57df811b-fa44-40dc-b658-265599f66e55	15	15	\N	549.160	\N	en	99.160	549.160	99.160	unfulfilled	FedEx	34	t		1000		PLN	{}	{}	35	\N	\N	0.000	0.000	0.000		\N	\N		2024-05-20 11:19:53.735452+00	f	82	\N	549.160	full	none	'111223582':27C '358':9B,21B '38650':14B,26B '82':1A '91189':5B,17B 'apt':8B,20B 'darko':28C 'drive':7B,19B 'east':12B,24B 'kari':13B,25B 'moor':6B,18B 'phillip':4B,16B 'polo':29C 'susan':3B,15B 'susan.phillips@example.com':2A 'tr':11B,23B 'türkiy':10B,22B 'xxl':30C	t	f	99.160	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:19:53.761611+00		willie.murray@example.com	d6c815a4-69c5-456d-aaab-46ae66e9b767	87	87	\N	493.950	\N	en	71.960	493.950	71.960	unfulfilled	FedEx Express	7	t		2100		USD	{}	{}	34	\N	\N	0.000	0.000	493.950		\N	\N		2024-05-20 11:19:54.111776+00	f	83	\N	0.000	full	full	'118223585':28C '3019':5B,16B '340':9B,20B '39':37C '420':32C '45':33C '50923':13B,24B '618223581':34C '83':1A 'apple':25C 'apt':8B,19B 'balance':31C 'dash':35C 'force':36C 'gerald':6B,17B 'juice':26C 'mall':7B,18B 'murray':4B,15B 'paul':29C 's':30C 'tr':11B,22B 'trevinovill':12B,23B 'türkiy':10B,21B 'uhjvzhvjdfzhcmlhbnq6mzg0':27C 'willi':3B,14B 'willie.murray@example.com':2A	t	f	71.960	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:19:54.152897+00		sarah.smith@example.com	34fb389c-2252-4a47-bbbf-929dab109c89	54	54	\N	287.910	\N	en	75.930	287.910	75.930	unconfirmed	Registered priority	42	t		1100		PLN	{}	{}	35	\N	\N	0.000	0.000	287.910		\N	\N		2024-05-20 11:19:54.410831+00	f	84	\N	0.000	full	full	'001':9B,21B '128223580':30C '220':5B,17B '50291':14B,26B '84':1A 'apt':8B,20B 'bean':27C 'eric':13B,25B 'juice':28C 'madison':6B,18B 'pass':7B,19B 'port':12B,24B 's':33C 'sarah':3B,15B 'sarah.smith@example.com':2A 'shirt':32C 'smith':4B,16B 'team':31C 'tr':11B,23B 'türkiy':10B,22B 'uhjvzhvjdfzhcmlhbnq6mzg1':29C	t	f	75.930	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:19:54.436314+00		christian.west@example.com	2b1ce541-0f20-4af6-9288-48e7dae71fd1	174	174	\N	676.040	\N	en	66.040	676.040	66.040	partially fulfilled	DHL	2	t		2000		PLN	{}	{}	35	\N	\N	0.000	0.000	0.000		\N	\N		2024-05-20 11:19:54.792821+00	f	85	\N	0.000	none	none	'132':5B,16B '40742':13B,24B '446':9B,20B '49182235824':28C '85':1A 'chelsealand':12B,23B 'christian':3B,14B 'christian.west@example.com':2A 'cubes':29C 'fountain':30C 'mclean':6B,17B 'meadow':7B,18B 'neck':25C 'suit':8B,19B 'tee':31C 'tr':11B,22B 'türkiy':10B,21B 'uhjvzhvjdfzhcmlhbnq6mzcw':27C 'warmer':26C 'west':4B,15B 'xxl':32C	t	f	66.040	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    2024-05-20 11:19:54.814696+00		cynthia.walsh@example.com	03d6e4ae-bbd5-4e9d-abd5-0872423f197f	154	154	\N	565.690	\N	en	94.710	565.690	94.710	partially fulfilled	TNT	10	t		0		PLN	{}	{}	35	\N	\N	0.000	0.000	565.690		\N	\N		2024-05-20 11:19:55.196262+00	f	86	\N	0.000	full	full	'113223584':34C '14737':11B,20B '6065':5B,14B '86':1A '9018223584':21C 'at':25C 'battle':23C 'battle-tested':22C 'brands':26C 'cloud':36C 'cushion':32C 'cynthia':3B,12B 'cynthia.walsh@example.com':2A 'davisburgh':10B,19B 'enterprise':35C 'harri':6B,15B 'hill':7B,16B 'itunes':40C 'like':27C 'lush':28C 'mp3':29C 'on':38C 'on-premises':37C 'parrot':31C 'premises':39C 'tested':24C 'tr':9B,18B 'türkiy':8B,17B 'uhjvzhvjdfzhcmlhbnq6mzk5':33C 'walsh':4B,13B 'white':30C	t	f	94.710	\N	{}	\N	{}	\N	\N	\N	0.000	0.000	\N
    \.


    --
    -- Data for Name: order_order_gift_cards; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.order_order_gift_cards (id, giftcard_id, order_id) FROM stdin;
    \.


    --
    -- Data for Name: order_orderevent; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.order_orderevent (id, date, type, user_id, parameters, app_id, order_id, related_id) FROM stdin;
    \.


    --
    -- Data for Name: order_ordergrantedrefund; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.order_ordergrantedrefund (id, created_at, updated_at, amount_value, currency, reason, app_id, order_id, user_id, shipping_costs_included) FROM stdin;
    \.


    --
    -- Data for Name: order_ordergrantedrefundline; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.order_ordergrantedrefundline (id, quantity, granted_refund_id, order_line_id, reason) FROM stdin;
    \.


    --
    -- Data for Name: order_orderline; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.order_orderline (product_name, product_sku, quantity, unit_price_net_amount, unit_price_gross_amount, is_shipping_required, quantity_fulfilled, variant_id, tax_rate, translated_product_name, currency, translated_variant_name, variant_name, total_price_gross_amount, total_price_net_amount, unit_discount_amount, unit_discount_value, unit_discount_reason, unit_discount_type, undiscounted_total_price_gross_amount, undiscounted_total_price_net_amount, undiscounted_unit_price_gross_amount, undiscounted_unit_price_net_amount, is_gift_card, product_variant_id, sale_id, voucher_code, order_id, id, old_id, created_at, base_unit_price_amount, undiscounted_base_unit_price_amount, metadata, private_metadata, tax_class_id, tax_class_metadata, tax_class_name, tax_class_private_metadata, is_gift) FROM stdin;
    Blue Polygon Shirt	218223580	3	45.000	45.000	t	0	361	0.0000		USD		M	135.000	135.000	0.000	0.000	\N	fixed	135.000	135.000	45.000	45.000	f	UHJvZHVjdFZhcmlhbnQ6MzYx	\N	\N	77908546-f356-4e27-9d96-bc40a694716e	31b4aa82-dc3a-4ae4-af04-bb784529d995	\N	2024-05-20 11:17:35.58756+00	45.000	45.000	{}	{}	\N	{}	\N	{}	f
    Cubes Fountain Tee	49182235820	3	30.000	30.000	t	0	394	0.0000		USD		S	90.000	90.000	0.000	0.000	\N	fixed	90.000	90.000	30.000	30.000	f	UHJvZHVjdFZhcmlhbnQ6Mzk0	\N	\N	77908546-f356-4e27-9d96-bc40a694716e	702f9190-8ffe-4d39-a386-1e52bf758aca	\N	2024-05-20 11:17:35.587886+00	30.000	30.000	{}	{}	\N	{}	\N	{}	f
    White Plimsolls	918223584	3	240.000	240.000	t	0	327	0.0000		PLN		41	720.000	720.000	0.000	0.000	\N	fixed	720.000	720.000	240.000	240.000	f	UHJvZHVjdFZhcmlhbnQ6MzI3	\N	\N	b2be7ed4-faa6-4cbd-98d0-d0a7a9ad57c9	06a9199a-1aae-4bb4-9b42-32e18ff2b309	\N	2024-05-20 11:17:35.926886+00	240.000	240.000	{}	{}	\N	{}	\N	{}	f
    Cubes Fountain Tee	49182235823	2	130.000	130.000	t	0	397	0.0000		PLN		XL	260.000	260.000	0.000	0.000	\N	fixed	260.000	260.000	130.000	130.000	f	UHJvZHVjdFZhcmlhbnQ6Mzk3	\N	\N	b2be7ed4-faa6-4cbd-98d0-d0a7a9ad57c9	47d361bc-ebdd-4a72-b832-c09d2e183f31	\N	2024-05-20 11:17:35.927152+00	130.000	130.000	{}	{}	\N	{}	\N	{}	f
    Paul's Balance 420	118223581	1	209.960	209.960	t	0	340	0.0000		PLN		39	209.960	209.960	0.000	0.000	\N	fixed	209.960	209.960	209.960	209.960	f	UHJvZHVjdFZhcmlhbnQ6MzQw	\N	\N	b2be7ed4-faa6-4cbd-98d0-d0a7a9ad57c9	e8f4646d-7c78-4fe5-99d9-ee0fadeb058c	\N	2024-05-20 11:17:35.927323+00	209.960	209.960	{}	{}	\N	{}	\N	{}	f
    Grey Hoodie	\N	4	100.000	100.000	t	0	345	0.0000		PLN		UHJvZHVjdFZhcmlhbnQ6MzQ1	400.000	400.000	0.000	0.000	\N	fixed	400.000	400.000	100.000	100.000	f	UHJvZHVjdFZhcmlhbnQ6MzQ1	\N	\N	395b103b-65f0-40cc-a55a-83ecf436b635	d6df38bc-12db-4679-9a2a-3e278800dacf	\N	2024-05-20 11:17:37.386658+00	100.000	100.000	{}	{}	\N	{}	\N	{}	f
    DRY Sunglasses	\N	4	60.000	60.000	f	0	371	0.0000		PLN		UHJvZHVjdFZhcmlhbnQ6Mzcx	240.000	240.000	0.000	0.000	\N	fixed	240.000	240.000	60.000	60.000	f	UHJvZHVjdFZhcmlhbnQ6Mzcx	\N	\N	7ed59560-a1bf-4137-8118-471da8d72fa1	48791609-c1dc-4ed5-b3f5-50e954e9c649	\N	2024-05-20 11:17:36.288407+00	60.000	60.000	{}	{}	\N	{}	\N	{}	f
    White Plimsolls	918223584	4	240.000	240.000	t	1	327	0.0000		PLN		41	960.000	960.000	0.000	0.000	\N	fixed	960.000	960.000	240.000	240.000	f	UHJvZHVjdFZhcmlhbnQ6MzI3	\N	\N	7ed59560-a1bf-4137-8118-471da8d72fa1	990f138d-29dd-4fd7-8223-584e7241816c	\N	2024-05-20 11:17:36.288126+00	240.000	240.000	{}	{}	\N	{}	\N	{}	f
    Monokai Dimmed Sunnies	\N	4	17.000	17.000	f	0	388	0.0000		USD		UHJvZHVjdFZhcmlhbnQ6Mzg4	68.000	68.000	0.000	0.000	\N	fixed	68.000	68.000	17.000	17.000	f	UHJvZHVjdFZhcmlhbnQ6Mzg4	\N	\N	c72dd0cd-d258-42f0-96bc-592be0f08c15	8ddbf2d9-df1e-4426-b9ce-d143e2cc530d	\N	2024-05-20 11:17:36.649272+00	17.000	17.000	{}	{}	\N	{}	\N	{}	f
    Reversed Monotype Tee	9182235821	2	120.000	120.000	t	0	390	0.0000		PLN		XXL	240.000	240.000	0.000	0.000	\N	fixed	240.000	240.000	120.000	120.000	f	UHJvZHVjdFZhcmlhbnQ6Mzkw	\N	\N	395b103b-65f0-40cc-a55a-83ecf436b635	d48623f4-1cde-4a83-b4d1-e566901fb96f	\N	2024-05-20 11:17:37.386919+00	120.000	120.000	{}	{}	\N	{}	\N	{}	f
    Darko Polo	111223581	1	22.500	22.500	t	0	359	0.0000		USD		M	22.500	22.500	0.000	0.000	\N	fixed	22.500	22.500	22.500	22.500	f	UHJvZHVjdFZhcmlhbnQ6MzU5	\N	\N	c72dd0cd-d258-42f0-96bc-592be0f08c15	6d1ac94b-122f-40d3-acb9-22f780a97407	\N	2024-05-20 11:17:36.649567+00	22.500	22.500	{}	{}	\N	{}	\N	{}	f
    Battle-tested at brands like Lush	9018223583	4	5.000	5.000	f	2	373	0.0000		USD		iTunes	20.000	20.000	0.000	0.000	\N	fixed	20.000	20.000	5.000	5.000	f	UHJvZHVjdFZhcmlhbnQ6Mzcz	\N	\N	c72dd0cd-d258-42f0-96bc-592be0f08c15	e93d8c4c-5ce7-4e21-afaf-e8f5c00115fc	\N	2024-05-20 11:17:36.649426+00	5.000	5.000	{}	{}	\N	{}	\N	{}	f
    Apple Juice	\N	3	1.990	1.990	t	2	384	0.0000		USD		UHJvZHVjdFZhcmlhbnQ6Mzg0	5.970	5.970	0.000	0.000	\N	fixed	5.970	5.970	1.990	1.990	f	UHJvZHVjdFZhcmlhbnQ6Mzg0	\N	\N	18149d27-f019-4abb-9c0f-987dff8a7dd2	8b57af35-78a6-4adf-bae6-84bfe7d32496	\N	2024-05-20 11:17:37.078391+00	1.990	1.990	{}	{}	\N	{}	\N	{}	f
    White Plimsolls	918223583	1	80.000	80.000	t	1	326	0.0000		USD		40	80.000	80.000	0.000	0.000	\N	fixed	80.000	80.000	80.000	80.000	f	UHJvZHVjdFZhcmlhbnQ6MzI2	\N	\N	18149d27-f019-4abb-9c0f-987dff8a7dd2	aee8e01e-d55c-45cf-a6a8-3db0281c270d	\N	2024-05-20 11:17:37.078685+00	80.000	80.000	{}	{}	\N	{}	\N	{}	f
    White Plimsolls	918223583	4	240.000	240.000	t	1	326	0.0000		PLN		40	960.000	960.000	0.000	0.000	\N	fixed	960.000	960.000	240.000	240.000	f	UHJvZHVjdFZhcmlhbnQ6MzI2	\N	\N	2be62bb0-8316-4135-b2ec-77b76337e814	5dca3aa6-0329-4b2d-8dfe-24fe96bfe04c	\N	2024-05-20 11:17:38.173674+00	240.000	240.000	{}	{}	\N	{}	\N	{}	f
    Dash Force	618223582	4	420.000	420.000	t	0	336	0.0000		PLN		40	1680.000	1680.000	0.000	0.000	\N	fixed	1680.000	1680.000	420.000	420.000	f	UHJvZHVjdFZhcmlhbnQ6MzM2	\N	\N	3ec90525-e3c0-429f-9520-5ac9bced7715	490f83ad-c496-4561-a9b3-43aecaa2821c	\N	2024-05-20 11:17:37.765589+00	420.000	420.000	{}	{}	\N	{}	\N	{}	f
    Gift card 100	\N	3	450.000	450.000	f	3	393	0.0000		PLN		UHJvZHVjdFZhcmlhbnQ6Mzkz	1350.000	1350.000	0.000	0.000	\N	fixed	1350.000	1350.000	450.000	450.000	t	UHJvZHVjdFZhcmlhbnQ6Mzkz	\N	\N	3ec90525-e3c0-429f-9520-5ac9bced7715	e7b9dd56-fc82-4635-af9f-dde2d9acdedf	\N	2024-05-20 11:17:37.765236+00	450.000	450.000	{}	{}	\N	{}	\N	{}	f
    White Plimsolls	918223587	4	240.000	240.000	t	1	330	0.0000		PLN		44	960.000	960.000	0.000	0.000	\N	fixed	960.000	960.000	240.000	240.000	f	UHJvZHVjdFZhcmlhbnQ6MzMw	\N	\N	3ec90525-e3c0-429f-9520-5ac9bced7715	5ff62c68-32ac-4945-a343-3ce2831b42c2	\N	2024-05-20 11:17:37.765439+00	240.000	240.000	{}	{}	\N	{}	\N	{}	f
    Team Shirt	128223581	1	200.000	200.000	t	1	354	0.0000		PLN		M	200.000	200.000	0.000	0.000	\N	fixed	200.000	200.000	200.000	200.000	f	UHJvZHVjdFZhcmlhbnQ6MzU0	\N	\N	3ec90525-e3c0-429f-9520-5ac9bced7715	fb934334-0233-4985-9683-d98532b93fb4	\N	2024-05-20 11:17:37.765735+00	200.000	200.000	{}	{}	\N	{}	\N	{}	f
    Dash Force	618223584	3	420.000	420.000	t	0	338	0.0000		PLN		42	1260.000	1260.000	0.000	0.000	\N	fixed	1260.000	1260.000	420.000	420.000	f	UHJvZHVjdFZhcmlhbnQ6MzM4	\N	\N	e98191e3-b3f5-4f8b-a956-e3c194782fe5	95e338e0-767f-4771-bd07-88db3eaf802f	\N	2024-05-20 11:17:39.073753+00	420.000	420.000	{}	{}	\N	{}	\N	{}	f
    Gift card 100	\N	3	450.000	450.000	f	0	393	0.0000		PLN		UHJvZHVjdFZhcmlhbnQ6Mzkz	1350.000	1350.000	0.000	0.000	\N	fixed	1350.000	1350.000	450.000	450.000	t	UHJvZHVjdFZhcmlhbnQ6Mzkz	\N	\N	2be62bb0-8316-4135-b2ec-77b76337e814	05b19556-28b5-4fa7-a31a-ba3f48261e00	\N	2024-05-20 11:17:38.174134+00	450.000	450.000	{}	{}	\N	{}	\N	{}	f
    Team Shirt	128223583	1	100.000	100.000	t	0	356	0.0000		PLN		XL	100.000	100.000	0.000	0.000	\N	fixed	100.000	100.000	100.000	100.000	f	UHJvZHVjdFZhcmlhbnQ6MzU2	\N	\N	855ae710-20e2-486a-8ab4-f25216585284	2ab60a0d-2ab8-45fc-8da5-6e49cd717d4a	\N	2024-05-20 11:17:38.481237+00	100.000	100.000	{}	{}	\N	{}	\N	{}	f
    Blue Plimsolls	818223583	1	230.000	230.000	t	0	332	0.0000		PLN		41	230.000	230.000	0.000	0.000	\N	fixed	230.000	230.000	230.000	230.000	f	UHJvZHVjdFZhcmlhbnQ6MzMy	\N	\N	855ae710-20e2-486a-8ab4-f25216585284	ee8cb3de-3a7b-434c-be8d-d997405df988	\N	2024-05-20 11:17:38.481387+00	230.000	230.000	{}	{}	\N	{}	\N	{}	f
    Dash Force	618223585	4	90.000	90.000	t	0	339	0.0000		USD		43	360.000	360.000	0.000	0.000	\N	fixed	360.000	360.000	90.000	90.000	f	UHJvZHVjdFZhcmlhbnQ6MzM5	\N	\N	60dc6631-9a39-4746-963b-76d9ee0e8084	9896c388-e2a7-4999-8539-eb82555666a9	\N	2024-05-20 11:17:38.784834+00	90.000	90.000	{}	{}	\N	{}	\N	{}	f
    Paul's Balance 420	118223583	4	104.980	104.980	t	0	342	0.0000		PLN		41	419.920	419.920	0.000	0.000	\N	fixed	419.920	419.920	104.980	104.980	f	UHJvZHVjdFZhcmlhbnQ6MzQy	\N	\N	e98191e3-b3f5-4f8b-a956-e3c194782fe5	8823582c-4bbb-4843-9069-edfd9a50884e	\N	2024-05-20 11:17:39.074085+00	104.980	104.980	{}	{}	\N	{}	\N	{}	f
    Monospace Tee	328223580	4	10.000	10.000	t	4	348	0.0000		USD		S	40.000	40.000	0.000	0.000	\N	fixed	40.000	40.000	10.000	10.000	f	UHJvZHVjdFZhcmlhbnQ6MzQ4	\N	\N	60dc6631-9a39-4746-963b-76d9ee0e8084	efd52fa3-de71-488d-9d13-b90df0e1c178	\N	2024-05-20 11:17:38.785484+00	10.000	10.000	{}	{}	\N	{}	\N	{}	f
    Blue Hoodie	\N	3	35.000	35.000	t	0	346	0.0000		USD		UHJvZHVjdFZhcmlhbnQ6MzQ2	105.000	105.000	0.000	0.000	\N	fixed	105.000	105.000	35.000	35.000	f	UHJvZHVjdFZhcmlhbnQ6MzQ2	\N	\N	d55cb189-c636-4adc-8709-d43cddae9e02	5dd07e96-86b3-414c-a19b-066d5e5ab8e4	\N	2024-05-20 11:19:51.614792+00	35.000	35.000	{}	{}	\N	{}	\N	{}	f
    Own your stack and data	124223581	1	4.990	4.990	f	0	379	0.0000		PLN		iTunes	4.990	4.990	0.000	0.000	\N	fixed	4.990	4.990	4.990	4.990	f	UHJvZHVjdFZhcmlhbnQ6Mzc5	\N	\N	40fd51b7-e177-45e6-a439-60134b95c707	3cb98b9a-ed40-4cfe-b3e7-6c18a1560536	\N	2024-05-20 11:19:52.076186+00	4.990	4.990	{}	{}	\N	{}	\N	{}	f
    Dash Force	618223583	4	420.000	420.000	t	0	337	0.0000		PLN		41	1680.000	1680.000	0.000	0.000	\N	fixed	1680.000	1680.000	420.000	420.000	f	UHJvZHVjdFZhcmlhbnQ6MzM3	\N	\N	301b3825-9fea-411e-8500-51a9e126e150	5fc8e00b-d19a-41ad-8ebb-145e41235fde	\N	2024-05-20 11:19:52.719829+00	420.000	420.000	{}	{}	\N	{}	\N	{}	f
    Blue Polygon Shirt	218223582	3	150.000	150.000	t	1	363	0.0000		PLN		XL	450.000	450.000	0.000	0.000	\N	fixed	450.000	450.000	150.000	150.000	f	UHJvZHVjdFZhcmlhbnQ6MzYz	\N	\N	e98191e3-b3f5-4f8b-a956-e3c194782fe5	f226cde7-2282-4116-b5ec-86b6e86436fd	\N	2024-05-20 11:17:39.074311+00	150.000	150.000	{}	{}	\N	{}	\N	{}	f
    Banana Juice	\N	1	5.990	5.990	t	0	386	0.0000		PLN		UHJvZHVjdFZhcmlhbnQ6Mzg2	5.990	5.990	0.000	0.000	\N	fixed	5.990	5.990	5.990	5.990	f	UHJvZHVjdFZhcmlhbnQ6Mzg2	\N	\N	301b3825-9fea-411e-8500-51a9e126e150	8946324c-114c-416e-ba0a-d02b2cf7668f	\N	2024-05-20 11:19:52.719976+00	5.990	5.990	{}	{}	\N	{}	\N	{}	f
    Dash Force	618223584	3	420.000	420.000	t	2	338	0.0000		PLN		42	1260.000	1260.000	0.000	0.000	\N	fixed	1260.000	1260.000	420.000	420.000	f	UHJvZHVjdFZhcmlhbnQ6MzM4	\N	\N	41083c1e-d013-4366-a11b-29843ab3deb8	82083514-264e-482f-b23b-c57353e7c9eb	\N	2024-05-20 11:17:39.464819+00	420.000	420.000	{}	{}	\N	{}	\N	{}	f
    Grey Hoodie	\N	1	30.000	30.000	t	0	345	0.0000		USD		UHJvZHVjdFZhcmlhbnQ6MzQ1	30.000	30.000	0.000	0.000	\N	fixed	30.000	30.000	30.000	30.000	f	UHJvZHVjdFZhcmlhbnQ6MzQ1	\N	\N	467a5b3a-9795-485c-8ac7-275867b302f7	68f03306-3c03-4753-ab5b-afd8fa664c93	\N	2024-05-20 11:17:39.729627+00	30.000	30.000	{}	{}	\N	{}	\N	{}	f
    Monokai Dimmed Sunnies	\N	2	90.000	90.000	f	0	388	0.0000		PLN		UHJvZHVjdFZhcmlhbnQ6Mzg4	180.000	180.000	0.000	0.000	\N	fixed	180.000	180.000	90.000	90.000	f	UHJvZHVjdFZhcmlhbnQ6Mzg4	\N	\N	c3582d23-2cf4-4dd6-b502-a63de106ee28	ea147ee9-04c4-4d77-952a-ea0da0c6e13e	\N	2024-05-20 11:17:41.179367+00	90.000	90.000	{}	{}	\N	{}	\N	{}	f
    Blue Plimsolls	818223584	2	75.000	75.000	t	2	334	0.0000		USD		42	150.000	150.000	0.000	0.000	\N	fixed	150.000	150.000	75.000	75.000	f	UHJvZHVjdFZhcmlhbnQ6MzM0	\N	\N	467a5b3a-9795-485c-8ac7-275867b302f7	15763d4f-2ab1-43ed-9115-20c1ddce671c	\N	2024-05-20 11:17:39.729867+00	75.000	75.000	{}	{}	\N	{}	\N	{}	f
    The Dash Cushion	\N	1	70.000	70.000	f	1	383	0.0000		PLN		UHJvZHVjdFZhcmlhbnQ6Mzgz	70.000	70.000	0.000	0.000	\N	fixed	70.000	70.000	70.000	70.000	f	UHJvZHVjdFZhcmlhbnQ6Mzgz	\N	\N	c3582d23-2cf4-4dd6-b502-a63de106ee28	b042a4b8-5fcd-4d30-9957-528272402620	\N	2024-05-20 11:17:41.179023+00	70.000	70.000	{}	{}	\N	{}	\N	{}	f
    White Plimsolls	918223584	4	240.000	240.000	t	4	327	0.0000		PLN		41	960.000	960.000	0.000	0.000	\N	fixed	960.000	960.000	240.000	240.000	f	UHJvZHVjdFZhcmlhbnQ6MzI3	\N	\N	c3582d23-2cf4-4dd6-b502-a63de106ee28	5961243b-0717-4a79-954c-dccb9b69f880	\N	2024-05-20 11:17:41.179225+00	240.000	240.000	{}	{}	\N	{}	\N	{}	f
    DRY Sunglasses	\N	1	15.000	15.000	f	1	371	0.0000		USD		UHJvZHVjdFZhcmlhbnQ6Mzcx	15.000	15.000	0.000	0.000	\N	fixed	15.000	15.000	15.000	15.000	f	UHJvZHVjdFZhcmlhbnQ6Mzcx	\N	\N	999999c3-f70a-430a-a4a4-24c91ce64916	bd5f2ef1-8a5d-4411-b4ff-25f26e508f09	\N	2024-05-20 11:17:40.0824+00	15.000	15.000	{}	{}	\N	{}	\N	{}	f
    Bean Juice	\N	4	1.990	1.990	t	3	385	0.0000		USD		UHJvZHVjdFZhcmlhbnQ6Mzg1	7.960	7.960	0.000	0.000	\N	fixed	7.960	7.960	1.990	1.990	f	UHJvZHVjdFZhcmlhbnQ6Mzg1	\N	\N	999999c3-f70a-430a-a4a4-24c91ce64916	b7e3c798-1a02-4f2f-915b-229df579cdc6	\N	2024-05-20 11:17:40.082683+00	1.990	1.990	{}	{}	\N	{}	\N	{}	f
    Cubes Fountain Tee	49182235821	2	130.000	130.000	t	0	395	0.0000		PLN		M	260.000	260.000	0.000	0.000	\N	fixed	260.000	260.000	130.000	130.000	f	UHJvZHVjdFZhcmlhbnQ6Mzk1	\N	\N	7d320a24-ec67-4b93-9211-76f5bbca9c30	8e619bd3-39f5-42db-8fe5-a268781db2bf	\N	2024-05-20 11:17:40.477496+00	130.000	130.000	{}	{}	\N	{}	\N	{}	f
    Paul's Balance 420	118223585	1	209.960	209.960	t	0	344	0.0000		PLN		45	209.960	209.960	0.000	0.000	\N	fixed	209.960	209.960	209.960	209.960	f	UHJvZHVjdFZhcmlhbnQ6MzQ0	\N	\N	7d320a24-ec67-4b93-9211-76f5bbca9c30	bdc9df7f-5df4-49c6-88c0-134fa1df08c1	\N	2024-05-20 11:17:40.477753+00	209.960	209.960	{}	{}	\N	{}	\N	{}	f
    Team Shirt	128223581	1	200.000	200.000	t	0	354	0.0000		PLN		M	200.000	200.000	0.000	0.000	\N	fixed	200.000	200.000	200.000	200.000	f	UHJvZHVjdFZhcmlhbnQ6MzU0	\N	\N	7d320a24-ec67-4b93-9211-76f5bbca9c30	861341d1-309c-41de-afdc-2675a5f29e78	\N	2024-05-20 11:17:40.478004+00	200.000	200.000	{}	{}	\N	{}	\N	{}	f
    Blue Plimsolls	818223582	4	230.000	230.000	t	4	333	0.0000		PLN		40	920.000	920.000	0.000	0.000	\N	fixed	920.000	920.000	230.000	230.000	f	UHJvZHVjdFZhcmlhbnQ6MzMz	\N	\N	7d320a24-ec67-4b93-9211-76f5bbca9c30	ae897f6e-fd3b-41ae-9a7a-2cc75e19ad2b	\N	2024-05-20 11:17:40.477168+00	230.000	230.000	{}	{}	\N	{}	\N	{}	f
    Neck Warmer	\N	2	90.000	90.000	t	1	370	0.0000		PLN		UHJvZHVjdFZhcmlhbnQ6Mzcw	180.000	180.000	0.000	0.000	\N	fixed	180.000	180.000	90.000	90.000	f	UHJvZHVjdFZhcmlhbnQ6Mzcw	\N	\N	ffda684a-ece1-4c21-9027-01c6bb7a9347	180ebd31-5c0d-48ba-9df0-abca082a61df	\N	2024-05-20 11:17:40.872559+00	90.000	90.000	{}	{}	\N	{}	\N	{}	f
    Cubes Fountain Tee	49182235820	3	130.000	130.000	t	0	394	0.0000		PLN		S	390.000	390.000	0.000	0.000	\N	fixed	390.000	390.000	130.000	130.000	f	UHJvZHVjdFZhcmlhbnQ6Mzk0	\N	\N	40fd51b7-e177-45e6-a439-60134b95c707	43098a62-f9df-40ba-9001-37ab2572339d	\N	2024-05-20 11:19:52.076933+00	130.000	130.000	{}	{}	\N	{}	\N	{}	f
    Monospace Tee	328223581	1	90.000	90.000	t	1	349	0.0000		PLN		M	90.000	90.000	0.000	0.000	\N	fixed	90.000	90.000	90.000	90.000	f	UHJvZHVjdFZhcmlhbnQ6MzQ5	\N	\N	40fd51b7-e177-45e6-a439-60134b95c707	c915b964-3e1e-470c-ba82-585e7df6cdcd	\N	2024-05-20 11:19:52.076492+00	90.000	90.000	{}	{}	\N	{}	\N	{}	f
    Gift card 100	\N	1	225.000	225.000	f	1	393	0.0000		PLN		UHJvZHVjdFZhcmlhbnQ6Mzkz	225.000	225.000	0.000	0.000	\N	fixed	225.000	225.000	225.000	225.000	t	UHJvZHVjdFZhcmlhbnQ6Mzkz	\N	\N	40fd51b7-e177-45e6-a439-60134b95c707	ab053067-4fd9-4ddc-be94-f28c5fe56165	\N	2024-05-20 11:19:52.076715+00	225.000	225.000	{}	{}	\N	{}	\N	{}	f
    Cubes Fountain Tee	49182235820	4	30.000	30.000	t	0	394	0.0000		USD		S	120.000	120.000	0.000	0.000	\N	fixed	120.000	120.000	30.000	30.000	f	UHJvZHVjdFZhcmlhbnQ6Mzk0	\N	\N	6796b775-e1c5-46cf-949a-769dff727f49	35a525af-658c-4f08-89c0-022862a27890	\N	2024-05-20 11:19:52.427606+00	30.000	30.000	{}	{}	\N	{}	\N	{}	f
    Dash Force	618223585	2	90.000	90.000	t	0	339	0.0000		USD		43	180.000	180.000	0.000	0.000	\N	fixed	180.000	180.000	90.000	90.000	f	UHJvZHVjdFZhcmlhbnQ6MzM5	\N	\N	6796b775-e1c5-46cf-949a-769dff727f49	65acbba0-d051-42c5-a6a9-09b0cedf25ab	\N	2024-05-20 11:19:52.427854+00	90.000	90.000	{}	{}	\N	{}	\N	{}	f
    Dark Polygon Tee	112223581	3	150.000	150.000	t	0	365	0.0000		PLN		M	450.000	450.000	0.000	0.000	\N	fixed	450.000	450.000	150.000	150.000	f	UHJvZHVjdFZhcmlhbnQ6MzY1	\N	\N	301b3825-9fea-411e-8500-51a9e126e150	76c6a933-6849-4cc7-817a-4449370ff49c	\N	2024-05-20 11:19:52.720121+00	150.000	150.000	{}	{}	\N	{}	\N	{}	f
    Blue Hoodie	\N	1	35.000	35.000	t	0	346	0.0000		USD		UHJvZHVjdFZhcmlhbnQ6MzQ2	35.000	35.000	0.000	0.000	\N	fixed	35.000	35.000	35.000	35.000	f	UHJvZHVjdFZhcmlhbnQ6MzQ2	\N	\N	bde60da5-c90b-449c-aa2d-805c2e596087	6437ebc1-f23f-41a5-8083-c74fddfdccf7	\N	2024-05-20 11:19:53.074982+00	35.000	35.000	{}	{}	\N	{}	\N	{}	f
    Cubes Fountain Tee	49182235824	3	130.000	130.000	t	0	398	0.0000		PLN		XXL	390.000	390.000	0.000	0.000	\N	fixed	390.000	390.000	130.000	130.000	f	UHJvZHVjdFZhcmlhbnQ6Mzk4	\N	\N	9c5a0a36-65db-43c5-905f-cab7fc47851a	ca86b014-cc20-4832-adc3-91ffbe620210	\N	2024-05-20 11:19:53.328091+00	130.000	130.000	{}	{}	\N	{}	\N	{}	f
    Darko Polo	111223582	3	150.000	150.000	t	0	360	0.0000		PLN		XXL	450.000	450.000	0.000	0.000	\N	fixed	450.000	450.000	150.000	150.000	f	UHJvZHVjdFZhcmlhbnQ6MzYw	\N	\N	57df811b-fa44-40dc-b658-265599f66e55	1e8db371-5d80-4997-8761-165a7ae02d26	\N	2024-05-20 11:19:53.566083+00	150.000	150.000	{}	{}	\N	{}	\N	{}	f
    Apple Juice	\N	1	1.990	1.990	t	0	384	0.0000		USD		UHJvZHVjdFZhcmlhbnQ6Mzg0	1.990	1.990	0.000	0.000	\N	fixed	1.990	1.990	1.990	1.990	f	UHJvZHVjdFZhcmlhbnQ6Mzg0	\N	\N	d6c815a4-69c5-456d-aaab-46ae66e9b767	6fd4a0d8-e7dc-4647-a8e0-a0cf3b07af0d	\N	2024-05-20 11:19:53.802756+00	1.990	1.990	{}	{}	\N	{}	\N	{}	f
    Paul's Balance 420	118223585	3	50.000	50.000	t	0	344	0.0000		USD		45	150.000	150.000	0.000	0.000	\N	fixed	150.000	150.000	50.000	50.000	f	UHJvZHVjdFZhcmlhbnQ6MzQ0	\N	\N	d6c815a4-69c5-456d-aaab-46ae66e9b767	eb9ad2d2-029a-43de-920d-42685e0e6932	\N	2024-05-20 11:19:53.803024+00	50.000	50.000	{}	{}	\N	{}	\N	{}	f
    Dash Force	618223581	3	90.000	90.000	t	0	335	0.0000		USD		39	270.000	270.000	0.000	0.000	\N	fixed	270.000	270.000	90.000	90.000	f	UHJvZHVjdFZhcmlhbnQ6MzM1	\N	\N	d6c815a4-69c5-456d-aaab-46ae66e9b767	e1af6c33-0570-418c-aa66-41fa12cb4cc1	\N	2024-05-20 11:19:53.803248+00	90.000	90.000	{}	{}	\N	{}	\N	{}	f
    Bean Juice	\N	2	5.990	5.990	t	0	385	0.0000		PLN		UHJvZHVjdFZhcmlhbnQ6Mzg1	11.980	11.980	0.000	0.000	\N	fixed	11.980	11.980	5.990	5.990	f	UHJvZHVjdFZhcmlhbnQ6Mzg1	\N	\N	34fb389c-2252-4a47-bbbf-929dab109c89	7d26f947-96bd-425b-9242-9119368ac253	\N	2024-05-20 11:19:54.173241+00	5.990	5.990	{}	{}	\N	{}	\N	{}	f
    Team Shirt	128223580	1	200.000	200.000	t	0	353	0.0000		PLN		S	200.000	200.000	0.000	0.000	\N	fixed	200.000	200.000	200.000	200.000	f	UHJvZHVjdFZhcmlhbnQ6MzUz	\N	\N	34fb389c-2252-4a47-bbbf-929dab109c89	6afd9dcb-be57-4219-89af-318f8ecef0e6	\N	2024-05-20 11:19:54.17339+00	200.000	200.000	{}	{}	\N	{}	\N	{}	f
    Paul's Balance 420	118223583	1	104.980	104.980	t	0	342	0.0000		PLN		41	104.980	104.980	0.000	0.000	\N	fixed	104.980	104.980	104.980	104.980	f	UHJvZHVjdFZhcmlhbnQ6MzQy	\N	\N	c3582d23-2cf4-4dd6-b502-a63de106ee28	e60b7820-93cc-4625-9d52-a810f29a7ac8	\N	2024-05-20 11:17:41.17949+00	104.980	104.980	{}	{}	\N	{}	\N	{}	f
    Enterprise Cloud + On-premises	113223582	2	29.990	29.990	f	0	375	0.0000		PLN		Vinyl	59.980	59.980	0.000	0.000	\N	fixed	59.980	59.980	29.990	29.990	f	UHJvZHVjdFZhcmlhbnQ6Mzc1	\N	\N	b24288be-8b7f-470b-a35b-cb7347c7658e	f8eabe27-f94a-4142-a1bd-c927b557040c	\N	2024-05-20 11:17:41.603653+00	29.990	29.990	{}	{}	\N	{}	\N	{}	f
    White Plimsolls	918223586	2	80.000	80.000	t	1	329	0.0000		USD		43	160.000	160.000	0.000	0.000	\N	fixed	160.000	160.000	80.000	80.000	f	UHJvZHVjdFZhcmlhbnQ6MzI5	\N	\N	40f2a9fc-c24c-4d97-a756-9cec06c5620a	f8502f3f-5ff1-412d-99f8-fb6352d5aafd	\N	2024-05-20 11:18:01.804085+00	80.000	80.000	{}	{}	\N	{}	\N	{}	f
    Grey Hoodie	\N	3	30.000	30.000	t	0	345	0.0000		USD		UHJvZHVjdFZhcmlhbnQ6MzQ1	90.000	90.000	0.000	0.000	\N	fixed	90.000	90.000	30.000	30.000	f	UHJvZHVjdFZhcmlhbnQ6MzQ1	\N	\N	f925fcfe-aeea-48b8-bada-37d349cbc485	30be4c75-f85a-416e-822d-dd3570badd0b	\N	2024-05-20 11:17:41.860901+00	30.000	30.000	{}	{}	\N	{}	\N	{}	f
    Dark Polygon Tee	112223582	4	45.000	45.000	t	4	366	0.0000		USD		L	180.000	180.000	0.000	0.000	\N	fixed	180.000	180.000	45.000	45.000	f	UHJvZHVjdFZhcmlhbnQ6MzY2	\N	\N	40f2a9fc-c24c-4d97-a756-9cec06c5620a	c4def8b7-405d-4123-8b6b-034fe7e02a83	\N	2024-05-20 11:18:01.804332+00	45.000	45.000	{}	{}	\N	{}	\N	{}	f
    Blue Polygon Shirt	218223580	4	45.000	45.000	t	1	361	0.0000		USD		M	180.000	180.000	0.000	0.000	\N	fixed	180.000	180.000	45.000	45.000	f	UHJvZHVjdFZhcmlhbnQ6MzYx	\N	\N	f925fcfe-aeea-48b8-bada-37d349cbc485	07696772-b3a5-44d4-8446-70cb33d22380	\N	2024-05-20 11:17:41.860683+00	45.000	45.000	{}	{}	\N	{}	\N	{}	f
    White Plimsolls	918223582	4	80.000	80.000	t	1	325	0.0000		USD		39	320.000	320.000	0.000	0.000	\N	fixed	320.000	320.000	80.000	80.000	f	UHJvZHVjdFZhcmlhbnQ6MzI1	\N	\N	f925fcfe-aeea-48b8-bada-37d349cbc485	711efb56-10fe-487c-8391-05bcc87cf523	\N	2024-05-20 11:17:41.861084+00	80.000	80.000	{}	{}	\N	{}	\N	{}	f
    Paul's Balance 420	118223584	1	50.000	50.000	t	0	343	0.0000		USD		42	50.000	50.000	0.000	0.000	\N	fixed	50.000	50.000	50.000	50.000	f	UHJvZHVjdFZhcmlhbnQ6MzQz	\N	\N	4abcac1e-c1ac-45b4-bbd2-bb04ec61ed2b	dbfadeff-eb1c-440c-951c-16ca67601ebe	\N	2024-05-20 11:17:42.249568+00	50.000	50.000	{}	{}	\N	{}	\N	{}	f
    Neck Warmer	\N	2	90.000	90.000	t	0	370	0.0000		PLN		UHJvZHVjdFZhcmlhbnQ6Mzcw	180.000	180.000	0.000	0.000	\N	fixed	180.000	180.000	90.000	90.000	f	UHJvZHVjdFZhcmlhbnQ6Mzcw	\N	\N	b715c50a-bc26-4726-a6ce-175e4361ce26	9aa4978d-491b-4447-ba1a-e8b345f72b80	\N	2024-05-20 11:18:01.213364+00	90.000	90.000	{}	{}	\N	{}	\N	{}	f
    Headless + Omnichannel in a pill	headless-omnichannel-mp3	4	10.000	10.000	f	0	324	0.0000		USD		MP3	40.000	40.000	0.000	0.000	\N	fixed	40.000	40.000	10.000	10.000	f	UHJvZHVjdFZhcmlhbnQ6MzI0	\N	\N	4abcac1e-c1ac-45b4-bbd2-bb04ec61ed2b	48c9e4fb-7c21-4c6c-85d8-0238f5ea7851	\N	2024-05-20 11:17:42.249832+00	10.000	10.000	{}	{}	\N	{}	\N	{}	f
    Enterprise Cloud + On-premises	113223585	4	8.990	8.990	f	4	378	0.0000		USD		CD	35.960	35.960	0.000	0.000	\N	fixed	35.960	35.960	8.990	8.990	f	UHJvZHVjdFZhcmlhbnQ6Mzc4	\N	\N	4abcac1e-c1ac-45b4-bbd2-bb04ec61ed2b	3e546566-c376-4de9-9684-df8b1360ce6e	\N	2024-05-20 11:17:42.249724+00	8.990	8.990	{}	{}	\N	{}	\N	{}	f
    Monospace Tee	328223582	1	10.000	10.000	t	0	350	0.0000		USD		L	10.000	10.000	0.000	0.000	\N	fixed	10.000	10.000	10.000	10.000	f	UHJvZHVjdFZhcmlhbnQ6MzUw	\N	\N	ef646742-2b8f-4410-98da-faeb31d130a9	930794ac-f5ca-4663-90c1-49e65109455d	\N	2024-05-20 11:18:00.327415+00	10.000	10.000	{}	{}	\N	{}	\N	{}	f
    Pirate's Beanie	\N	3	10.000	10.000	t	0	368	0.0000		USD		UHJvZHVjdFZhcmlhbnQ6MzY4	30.000	30.000	0.000	0.000	\N	fixed	30.000	30.000	10.000	10.000	f	UHJvZHVjdFZhcmlhbnQ6MzY4	\N	\N	ef646742-2b8f-4410-98da-faeb31d130a9	6dd5d081-9748-49f8-9a2b-ff7510e6fb84	\N	2024-05-20 11:18:00.327594+00	10.000	10.000	{}	{}	\N	{}	\N	{}	f
    Team Shirt	128223581	2	40.000	40.000	t	0	354	0.0000		USD		M	80.000	80.000	0.000	0.000	\N	fixed	80.000	80.000	40.000	40.000	f	UHJvZHVjdFZhcmlhbnQ6MzU0	\N	\N	67218714-3be3-4309-8b91-cb793d79af24	0aa13e7d-a057-476b-ad66-3e8435935000	\N	2024-05-20 11:18:00.688295+00	40.000	40.000	{}	{}	\N	{}	\N	{}	f
    Carrot Juice	\N	1	5.990	5.990	t	0	387	0.0000		PLN		UHJvZHVjdFZhcmlhbnQ6Mzg3	5.990	5.990	0.000	0.000	\N	fixed	5.990	5.990	5.990	5.990	f	UHJvZHVjdFZhcmlhbnQ6Mzg3	\N	\N	d82f243a-1b5c-4581-a33d-9a28f4dc3c6f	08d0f894-c06d-471c-adea-ba06f5523653	\N	2024-05-20 11:18:00.959753+00	5.990	5.990	{}	{}	\N	{}	\N	{}	f
    Paul's Balance 420	118223585	1	146.970	146.970	t	1	344	0.0000		PLN		45	146.970	146.970	0.000	0.000	\N	fixed	146.970	146.970	146.970	146.970	f	UHJvZHVjdFZhcmlhbnQ6MzQ0	\N	\N	b715c50a-bc26-4726-a6ce-175e4361ce26	4f2e79e4-606d-431a-8b2a-5cdd500e83e3	\N	2024-05-20 11:18:01.213106+00	146.970	146.970	{}	{}	\N	{}	\N	{}	f
    White Plimsolls	918223584	3	240.000	240.000	t	3	327	0.0000		PLN		41	720.000	720.000	0.000	0.000	\N	fixed	720.000	720.000	240.000	240.000	f	UHJvZHVjdFZhcmlhbnQ6MzI3	\N	\N	b715c50a-bc26-4726-a6ce-175e4361ce26	4ec749e8-2b87-43ab-97ba-73fb75361a71	\N	2024-05-20 11:18:01.213257+00	240.000	240.000	{}	{}	\N	{}	\N	{}	f
    Monospace Tee	328223584	1	45.000	45.000	t	0	352	0.0000		PLN		XXL	45.000	45.000	0.000	0.000	\N	fixed	45.000	45.000	45.000	45.000	f	UHJvZHVjdFZhcmlhbnQ6MzUy	\N	\N	1c468654-68d6-4b80-a937-bbcdc75135db	895ee9f4-8191-466a-b210-8612119a55fb	\N	2024-05-20 11:18:01.53737+00	45.000	45.000	{}	{}	\N	{}	\N	{}	f
    Team Shirt	128223583	3	100.000	100.000	t	0	356	0.0000		PLN		XL	300.000	300.000	0.000	0.000	\N	fixed	300.000	300.000	100.000	100.000	f	UHJvZHVjdFZhcmlhbnQ6MzU2	\N	\N	1c468654-68d6-4b80-a937-bbcdc75135db	d3409b75-94e4-43d9-8a7d-2a23039a0a04	\N	2024-05-20 11:18:01.537521+00	100.000	100.000	{}	{}	\N	{}	\N	{}	f
    Neck Warmer	\N	2	20.000	20.000	t	0	370	0.0000		USD		UHJvZHVjdFZhcmlhbnQ6Mzcw	40.000	40.000	0.000	0.000	\N	fixed	40.000	40.000	20.000	20.000	f	UHJvZHVjdFZhcmlhbnQ6Mzcw	\N	\N	a34786b7-9bda-4afd-b112-2a08c3ea1674	6a81b7ff-3b46-4cd3-933d-b489985d5086	\N	2024-05-20 11:18:02.484798+00	20.000	20.000	{}	{}	\N	{}	\N	{}	f
    Blue Hoodie	\N	4	35.000	35.000	t	0	346	0.0000		USD		UHJvZHVjdFZhcmlhbnQ6MzQ2	140.000	140.000	0.000	0.000	\N	fixed	140.000	140.000	35.000	35.000	f	UHJvZHVjdFZhcmlhbnQ6MzQ2	\N	\N	a34786b7-9bda-4afd-b112-2a08c3ea1674	36d6ac23-77d5-4f5b-9966-ae3e99ff2c4f	\N	2024-05-20 11:18:02.484958+00	35.000	35.000	{}	{}	\N	{}	\N	{}	f
    Dark Polygon Tee	112223580	2	45.000	45.000	t	1	364	0.0000		USD		S	90.000	90.000	0.000	0.000	\N	fixed	90.000	90.000	45.000	45.000	f	UHJvZHVjdFZhcmlhbnQ6MzY0	\N	\N	40f2a9fc-c24c-4d97-a756-9cec06c5620a	87b60f97-8820-446f-9938-f72077a8f534	\N	2024-05-20 11:18:01.80451+00	45.000	45.000	{}	{}	\N	{}	\N	{}	f
    Monokai Dimmed Sunnies	\N	1	11.900	11.900	f	0	388	0.0000		USD		UHJvZHVjdFZhcmlhbnQ6Mzg4	11.900	11.900	0.000	0.000	\N	fixed	11.900	11.900	11.900	11.900	f	UHJvZHVjdFZhcmlhbnQ6Mzg4	\N	\N	273b2205-ebf5-427a-bcf2-8d2476ef74a4	d414072b-d518-4011-8cda-eb7e5d967867	\N	2024-05-20 11:18:02.200816+00	11.900	11.900	{}	{}	\N	{}	\N	{}	f
    Paul's Balance 420	118223585	4	35.000	35.000	t	1	344	0.0000		USD		45	140.000	140.000	0.000	0.000	\N	fixed	140.000	140.000	35.000	35.000	f	UHJvZHVjdFZhcmlhbnQ6MzQ0	\N	\N	273b2205-ebf5-427a-bcf2-8d2476ef74a4	3dd24bf6-b18c-4d5f-b4d2-649d5d65f8db	\N	2024-05-20 11:18:02.200547+00	35.000	35.000	{}	{}	\N	{}	\N	{}	f
    Cubes Fountain Tee	49182235820	2	30.000	30.000	t	0	394	0.0000		USD		S	60.000	60.000	0.000	0.000	\N	fixed	60.000	60.000	30.000	30.000	f	UHJvZHVjdFZhcmlhbnQ6Mzk0	\N	\N	3b8345c5-9520-4881-900d-196ccbf1ca8b	24203d4d-cbf3-4d29-8016-b6616fd66f32	\N	2024-05-20 11:18:02.791725+00	30.000	30.000	{}	{}	\N	{}	\N	{}	f
    White Plimsolls	918223587	1	80.000	80.000	t	0	330	0.0000		USD		44	80.000	80.000	0.000	0.000	\N	fixed	80.000	80.000	80.000	80.000	f	UHJvZHVjdFZhcmlhbnQ6MzMw	\N	\N	3b8345c5-9520-4881-900d-196ccbf1ca8b	6d890352-2b10-4660-a8af-cbc7281bba44	\N	2024-05-20 11:18:02.791933+00	80.000	80.000	{}	{}	\N	{}	\N	{}	f
    Team Shirt	128223582	2	40.000	40.000	t	0	355	0.0000		USD		L	80.000	80.000	0.000	0.000	\N	fixed	80.000	80.000	40.000	40.000	f	UHJvZHVjdFZhcmlhbnQ6MzU1	\N	\N	3b8345c5-9520-4881-900d-196ccbf1ca8b	e2dc3a67-fb4b-4149-8716-7a39ee881285	\N	2024-05-20 11:18:02.792106+00	40.000	40.000	{}	{}	\N	{}	\N	{}	f
    Monospace Tee	328223581	3	45.000	45.000	t	2	349	0.0000		PLN		M	135.000	135.000	0.000	0.000	\N	fixed	135.000	135.000	45.000	45.000	f	UHJvZHVjdFZhcmlhbnQ6MzQ5	\N	\N	dfa31232-7eef-4bac-b390-de66b8cced9d	331ebca3-ceeb-45dc-a437-0bedd53c623c	\N	2024-05-20 11:18:03.141984+00	45.000	45.000	{}	{}	\N	{}	\N	{}	f
    Cubes Fountain Tee	49182235824	4	130.000	130.000	t	0	398	0.0000		PLN		XXL	520.000	520.000	0.000	0.000	\N	fixed	520.000	520.000	130.000	130.000	f	UHJvZHVjdFZhcmlhbnQ6Mzk4	\N	\N	2b1ce541-0f20-4af6-9288-48e7dae71fd1	f7cfff4b-3463-4687-aa8d-2fe33d191b23	\N	2024-05-20 11:19:54.463889+00	130.000	130.000	{}	{}	\N	{}	\N	{}	f
    Neck Warmer	\N	1	90.000	90.000	t	1	370	0.0000		PLN		UHJvZHVjdFZhcmlhbnQ6Mzcw	90.000	90.000	0.000	0.000	\N	fixed	90.000	90.000	90.000	90.000	f	UHJvZHVjdFZhcmlhbnQ6Mzcw	\N	\N	2b1ce541-0f20-4af6-9288-48e7dae71fd1	c19afcd5-45a3-4857-bc4d-ef9c8192b635	\N	2024-05-20 11:19:54.463684+00	90.000	90.000	{}	{}	\N	{}	\N	{}	f
    Enterprise Cloud + On-premises	113223585	2	26.990	26.990	f	2	378	0.0000		PLN		CD	53.980	53.980	0.000	0.000	\N	fixed	53.980	53.980	26.990	26.990	f	UHJvZHVjdFZhcmlhbnQ6Mzc4	\N	\N	dfa31232-7eef-4bac-b390-de66b8cced9d	dc73e900-aef0-4497-b0ad-2c615a3dfc00	\N	2024-05-20 11:18:03.142347+00	26.990	26.990	{}	{}	\N	{}	\N	{}	f
    Blue Plimsolls	818223584	2	184.000	184.000	t	2	334	0.0000		PLN		42	368.000	368.000	0.000	0.000	\N	fixed	368.000	368.000	184.000	184.000	f	UHJvZHVjdFZhcmlhbnQ6MzM0	\N	\N	dfa31232-7eef-4bac-b390-de66b8cced9d	12c4dccb-f7a1-4ddb-9218-39df5cb2449d	\N	2024-05-20 11:18:03.142653+00	184.000	184.000	{}	{}	\N	{}	\N	{}	f
    Gift card 100	\N	4	100.000	100.000	f	0	393	0.0000		USD		UHJvZHVjdFZhcmlhbnQ6Mzkz	400.000	400.000	0.000	0.000	\N	fixed	400.000	400.000	100.000	100.000	t	UHJvZHVjdFZhcmlhbnQ6Mzkz	\N	\N	46a3674f-1d4f-44c2-b059-1939c41489e7	8f0c995a-0dc1-4462-a061-2239313873e7	\N	2024-05-20 11:18:03.532615+00	100.000	100.000	{}	{}	\N	{}	\N	{}	f
    Blue Hoodie	\N	2	35.000	35.000	t	0	346	0.0000		USD		UHJvZHVjdFZhcmlhbnQ6MzQ2	70.000	70.000	0.000	0.000	\N	fixed	70.000	70.000	35.000	35.000	f	UHJvZHVjdFZhcmlhbnQ6MzQ2	\N	\N	46a3674f-1d4f-44c2-b059-1939c41489e7	1ca3af18-9acb-4841-b4f0-9da125af61b4	\N	2024-05-20 11:18:03.53308+00	35.000	35.000	{}	{}	\N	{}	\N	{}	f
    Monospace Tee	328223581	3	10.000	10.000	t	1	349	0.0000		USD		M	30.000	30.000	0.000	0.000	\N	fixed	30.000	30.000	10.000	10.000	f	UHJvZHVjdFZhcmlhbnQ6MzQ5	\N	\N	46a3674f-1d4f-44c2-b059-1939c41489e7	5d182b9a-0412-4e82-a47b-815ee99618c4	\N	2024-05-20 11:18:03.532861+00	10.000	10.000	{}	{}	\N	{}	\N	{}	f
    Own your stack and data	124223581	4	2.000	2.000	f	0	379	0.0000		USD		iTunes	8.000	8.000	0.000	0.000	\N	fixed	8.000	8.000	2.000	2.000	f	UHJvZHVjdFZhcmlhbnQ6Mzc5	\N	\N	5e0958b4-f7d9-4309-9f5d-1d9cfc11db8a	a5bee344-56c4-4447-9532-f018bdf17fdc	\N	2024-05-20 11:18:03.890859+00	2.000	2.000	{}	{}	\N	{}	\N	{}	f
    Enterprise Cloud + On-premises	113223582	4	29.990	29.990	f	0	375	0.0000		PLN		Vinyl	119.960	119.960	0.000	0.000	\N	fixed	119.960	119.960	29.990	29.990	f	UHJvZHVjdFZhcmlhbnQ6Mzc1	\N	\N	75f316e4-b6bb-420b-98fb-9ede3d474e23	33b70df2-3fdb-49e5-a7bb-b32c06a92ca4	\N	2024-05-20 11:18:04.742519+00	29.990	29.990	{}	{}	\N	{}	\N	{}	f
    Team Shirt	128223581	4	40.000	40.000	t	0	354	0.0000		USD		M	160.000	160.000	0.000	0.000	\N	fixed	160.000	160.000	40.000	40.000	f	UHJvZHVjdFZhcmlhbnQ6MzU0	\N	\N	5e0958b4-f7d9-4309-9f5d-1d9cfc11db8a	6865eca1-73df-4fa8-af90-6f3d02c50773	\N	2024-05-20 11:18:03.892149+00	40.000	40.000	{}	{}	\N	{}	\N	{}	f
    Blue Polygon Shirt	218223581	3	45.000	45.000	t	2	362	0.0000		USD		L	135.000	135.000	0.000	0.000	\N	fixed	135.000	135.000	45.000	45.000	f	UHJvZHVjdFZhcmlhbnQ6MzYy	\N	\N	5e0958b4-f7d9-4309-9f5d-1d9cfc11db8a	35a8c8e6-cafd-4e64-a7b4-ec147746552c	\N	2024-05-20 11:18:03.891526+00	45.000	45.000	{}	{}	\N	{}	\N	{}	f
    Team Shirt	128223581	3	40.000	40.000	t	0	354	0.0000		USD		M	120.000	120.000	0.000	0.000	\N	fixed	120.000	120.000	40.000	40.000	f	UHJvZHVjdFZhcmlhbnQ6MzU0	\N	\N	8b90a8ae-754a-4355-9dc1-a431dcbdabc8	398d5bca-25d0-427f-b578-80dbb10c10a6	\N	2024-05-20 11:18:04.342846+00	40.000	40.000	{}	{}	\N	{}	\N	{}	f
    Paul's Balance 420	118223582	3	146.970	146.970	t	0	341	0.0000		PLN		40	440.910	440.910	0.000	0.000	\N	fixed	440.910	440.910	146.970	146.970	f	UHJvZHVjdFZhcmlhbnQ6MzQx	\N	\N	75f316e4-b6bb-420b-98fb-9ede3d474e23	99a96826-c2e1-4ec1-a09e-2cdc748cac71	\N	2024-05-20 11:18:04.742758+00	146.970	146.970	{}	{}	\N	{}	\N	{}	f
    Neck Warmer	\N	1	20.000	20.000	t	0	370	0.0000		USD		UHJvZHVjdFZhcmlhbnQ6Mzcw	20.000	20.000	0.000	0.000	\N	fixed	20.000	20.000	20.000	20.000	f	UHJvZHVjdFZhcmlhbnQ6Mzcw	\N	\N	8b90a8ae-754a-4355-9dc1-a431dcbdabc8	2691306f-ce69-4409-80cb-edbb93bb8c38	\N	2024-05-20 11:18:04.343953+00	20.000	20.000	{}	{}	\N	{}	\N	{}	f
    Paul's Balance 420	118223583	1	25.000	25.000	t	0	342	0.0000		USD		41	25.000	25.000	0.000	0.000	\N	fixed	25.000	25.000	25.000	25.000	f	UHJvZHVjdFZhcmlhbnQ6MzQy	\N	\N	8b90a8ae-754a-4355-9dc1-a431dcbdabc8	db9704b1-f03a-45a9-9397-852f143dd066	\N	2024-05-20 11:18:04.344462+00	25.000	25.000	{}	{}	\N	{}	\N	{}	f
    Darko Polo	111223582	3	45.000	45.000	t	2	360	0.0000		USD		XXL	135.000	135.000	0.000	0.000	\N	fixed	135.000	135.000	45.000	45.000	f	UHJvZHVjdFZhcmlhbnQ6MzYw	\N	\N	8b90a8ae-754a-4355-9dc1-a431dcbdabc8	7939fef0-6813-4f32-8b65-1b1c4d8701c2	\N	2024-05-20 11:18:04.343464+00	45.000	45.000	{}	{}	\N	{}	\N	{}	f
    Banana Juice	\N	2	5.990	5.990	t	1	386	0.0000		PLN		UHJvZHVjdFZhcmlhbnQ6Mzg2	11.980	11.980	0.000	0.000	\N	fixed	11.980	11.980	5.990	5.990	f	UHJvZHVjdFZhcmlhbnQ6Mzg2	\N	\N	75f316e4-b6bb-420b-98fb-9ede3d474e23	40cb3ae2-d5ea-4e14-a69f-d7519df1380f	\N	2024-05-20 11:18:04.742245+00	5.990	5.990	{}	{}	\N	{}	\N	{}	f
    Grey Hoodie	\N	1	100.000	100.000	t	0	345	0.0000		PLN		UHJvZHVjdFZhcmlhbnQ6MzQ1	100.000	100.000	0.000	0.000	\N	fixed	100.000	100.000	100.000	100.000	f	UHJvZHVjdFZhcmlhbnQ6MzQ1	\N	\N	551fabef-9899-4a41-9a6b-fc756e61a4fb	62547330-dec1-4ce6-b728-cd0dcbf3428d	\N	2024-05-20 11:18:05.120326+00	100.000	100.000	{}	{}	\N	{}	\N	{}	f
    Monospace Tee	328223580	3	45.000	45.000	t	0	348	0.0000		PLN		S	135.000	135.000	0.000	0.000	\N	fixed	135.000	135.000	45.000	45.000	f	UHJvZHVjdFZhcmlhbnQ6MzQ4	\N	\N	551fabef-9899-4a41-9a6b-fc756e61a4fb	f7d5775a-b512-4940-a679-7f546715f507	\N	2024-05-20 11:18:05.1206+00	45.000	45.000	{}	{}	\N	{}	\N	{}	f
    Reversed Monotype Tee	9182235820	2	25.000	25.000	t	0	389	0.0000		USD		XL	50.000	50.000	0.000	0.000	\N	fixed	50.000	50.000	25.000	25.000	f	UHJvZHVjdFZhcmlhbnQ6Mzg5	\N	\N	fde48e98-dc8c-4d8c-b1f0-605ba9da1f87	212a9690-4be4-4aff-a346-be7a73c11ccf	\N	2024-05-20 11:18:05.364484+00	25.000	25.000	{}	{}	\N	{}	\N	{}	f
    Monospace Tee	328223583	2	10.000	10.000	t	0	351	0.0000		USD		XL	20.000	20.000	0.000	0.000	\N	fixed	20.000	20.000	10.000	10.000	f	UHJvZHVjdFZhcmlhbnQ6MzUx	\N	\N	fbc2f983-baab-436e-bddf-330707e3bfd5	b3b3125f-9a50-400b-872c-976e0301982f	\N	2024-05-20 11:18:05.661899+00	10.000	10.000	{}	{}	\N	{}	\N	{}	f
    Cubes Fountain Tee	49182235822	3	30.000	30.000	t	0	396	0.0000		USD		L	90.000	90.000	0.000	0.000	\N	fixed	90.000	90.000	30.000	30.000	f	UHJvZHVjdFZhcmlhbnQ6Mzk2	\N	\N	fbc2f983-baab-436e-bddf-330707e3bfd5	fe1f3c04-09cb-45bc-80c7-aebdc843caef	\N	2024-05-20 11:18:05.662114+00	30.000	30.000	{}	{}	\N	{}	\N	{}	f
    Monokai Dimmed Sunnies	\N	4	11.900	11.900	f	0	388	0.0000		USD		UHJvZHVjdFZhcmlhbnQ6Mzg4	47.600	47.600	0.000	0.000	\N	fixed	47.600	47.600	11.900	11.900	f	UHJvZHVjdFZhcmlhbnQ6Mzg4	\N	\N	fbc2f983-baab-436e-bddf-330707e3bfd5	94ce3590-ab75-4a8f-98a1-95e5bd8b061b	\N	2024-05-20 11:18:05.662238+00	11.900	11.900	{}	{}	\N	{}	\N	{}	f
    Team Shirt	128223580	1	40.000	40.000	t	1	353	0.0000		USD		S	40.000	40.000	0.000	0.000	\N	fixed	40.000	40.000	40.000	40.000	f	UHJvZHVjdFZhcmlhbnQ6MzUz	\N	\N	19dadc8a-3dad-4161-b2c0-c2feacbc252e	3cc19c3e-25ad-4e23-ab99-b615aab6121e	\N	2024-05-20 11:18:06.298013+00	40.000	40.000	{}	{}	\N	{}	\N	{}	f
    Monospace Tee	328223583	1	10.000	10.000	t	1	351	0.0000		USD		XL	10.000	10.000	0.000	0.000	\N	fixed	10.000	10.000	10.000	10.000	f	UHJvZHVjdFZhcmlhbnQ6MzUx	\N	\N	a30862b4-64f6-42ee-ba0e-b81771076c21	0d41a8ac-f4d8-4375-994f-116d087637dc	\N	2024-05-20 11:18:05.981708+00	10.000	10.000	{}	{}	\N	{}	\N	{}	f
    Gift card 500	\N	2	500.000	500.000	f	0	400	0.0000		USD		UHJvZHVjdFZhcmlhbnQ6NDAw	1000.000	1000.000	0.000	0.000	\N	fixed	1000.000	1000.000	500.000	500.000	t	UHJvZHVjdFZhcmlhbnQ6NDAw	\N	\N	806e024e-cf80-4860-8e3a-0998863844c8	04b832d1-d2d1-48a5-ba97-e310f9b09e6b	\N	2024-05-20 11:18:06.677624+00	500.000	500.000	{}	{}	\N	{}	\N	{}	f
    Paul's Balance 420	118223582	1	35.000	35.000	t	0	341	0.0000		USD		40	35.000	35.000	0.000	0.000	\N	fixed	35.000	35.000	35.000	35.000	f	UHJvZHVjdFZhcmlhbnQ6MzQx	\N	\N	19dadc8a-3dad-4161-b2c0-c2feacbc252e	97b5869a-0d57-4460-a40f-ec2adffcae16	\N	2024-05-20 11:18:06.298289+00	35.000	35.000	{}	{}	\N	{}	\N	{}	f
    Neck Warmer	\N	4	20.000	20.000	t	0	370	0.0000		USD		UHJvZHVjdFZhcmlhbnQ6Mzcw	80.000	80.000	0.000	0.000	\N	fixed	80.000	80.000	20.000	20.000	f	UHJvZHVjdFZhcmlhbnQ6Mzcw	\N	\N	19dadc8a-3dad-4161-b2c0-c2feacbc252e	cf31a836-b59e-4405-9912-633de75ccc2e	\N	2024-05-20 11:18:06.298466+00	20.000	20.000	{}	{}	\N	{}	\N	{}	f
    Reversed Monotype Tee	9182235821	4	25.000	25.000	t	1	390	0.0000		USD		XXL	100.000	100.000	0.000	0.000	\N	fixed	100.000	100.000	25.000	25.000	f	UHJvZHVjdFZhcmlhbnQ6Mzkw	\N	\N	19dadc8a-3dad-4161-b2c0-c2feacbc252e	6131f5df-1e2c-4f50-9eac-72be1d818b8e	\N	2024-05-20 11:18:06.298686+00	25.000	25.000	{}	{}	\N	{}	\N	{}	f
    Battle-tested at brands like Lush	9018223584	3	45.000	45.000	f	0	374	0.0000		PLN		MP3	135.000	135.000	0.000	0.000	\N	fixed	135.000	135.000	45.000	45.000	f	UHJvZHVjdFZhcmlhbnQ6Mzc0	\N	\N	03d6e4ae-bbd5-4e9d-abd5-0872423f197f	6ff6cd7a-cad5-438d-b268-2d25de4f1183	\N	2024-05-20 11:19:54.856533+00	45.000	45.000	{}	{}	\N	{}	\N	{}	f
    Banana Juice	\N	2	1.990	1.990	t	0	386	0.0000		USD		UHJvZHVjdFZhcmlhbnQ6Mzg2	3.980	3.980	0.000	0.000	\N	fixed	3.980	3.980	1.990	1.990	f	UHJvZHVjdFZhcmlhbnQ6Mzg2	\N	\N	806e024e-cf80-4860-8e3a-0998863844c8	8f753dcd-bc5c-4894-abf4-254033276a2d	\N	2024-05-20 11:18:06.677869+00	1.990	1.990	{}	{}	\N	{}	\N	{}	f
    Enterprise Cloud + On-premises	113223585	1	8.090	8.090	f	0	378	0.0000		USD		CD	8.090	8.090	0.000	0.000	\N	fixed	8.090	8.090	8.090	8.090	f	UHJvZHVjdFZhcmlhbnQ6Mzc4	\N	\N	806e024e-cf80-4860-8e3a-0998863844c8	124ca8bc-cc5e-4403-a6e9-906609c06291	\N	2024-05-20 11:18:06.678079+00	8.090	8.090	{}	{}	\N	{}	\N	{}	f
    Dash Force	618223584	2	90.000	90.000	t	0	338	0.0000		USD		42	180.000	180.000	0.000	0.000	\N	fixed	180.000	180.000	90.000	90.000	f	UHJvZHVjdFZhcmlhbnQ6MzM4	\N	\N	806e024e-cf80-4860-8e3a-0998863844c8	6b3f7d2c-e56e-42d4-bfe8-59cb19ee400e	\N	2024-05-20 11:18:06.67827+00	90.000	90.000	{}	{}	\N	{}	\N	{}	f
    Own your stack and data	124223581	1	4.990	4.990	f	0	379	0.0000		PLN		iTunes	4.990	4.990	0.000	0.000	\N	fixed	4.990	4.990	4.990	4.990	f	UHJvZHVjdFZhcmlhbnQ6Mzc5	\N	\N	a5cf238a-a9e0-49bb-9eb6-c70926c5480f	f35507d8-eae1-4cde-9a71-91f2e4701fa4	\N	2024-05-20 11:19:50.065152+00	4.990	4.990	{}	{}	\N	{}	\N	{}	f
    White Plimsolls	918223587	4	48.000	48.000	t	4	330	0.0000		USD		44	192.000	192.000	0.000	0.000	\N	fixed	192.000	192.000	48.000	48.000	f	UHJvZHVjdFZhcmlhbnQ6MzMw	\N	\N	92942735-68ad-4777-8a75-a8500ab04191	b5471b08-3568-4538-bb82-dd6c5df6c2f5	\N	2024-05-20 11:19:48.717445+00	48.000	48.000	{}	{}	\N	{}	\N	{}	f
    White Plimsolls	918223582	1	48.000	48.000	t	1	325	0.0000		USD		39	48.000	48.000	0.000	0.000	\N	fixed	48.000	48.000	48.000	48.000	f	UHJvZHVjdFZhcmlhbnQ6MzI1	\N	\N	92942735-68ad-4777-8a75-a8500ab04191	1e123fb0-db20-4664-a082-baf63870df9a	\N	2024-05-20 11:19:48.717692+00	48.000	48.000	{}	{}	\N	{}	\N	{}	f
    Paul's Balance 420	118223582	2	50.000	50.000	t	1	341	0.0000		USD		40	100.000	100.000	0.000	0.000	\N	fixed	100.000	100.000	50.000	50.000	f	UHJvZHVjdFZhcmlhbnQ6MzQx	\N	\N	92942735-68ad-4777-8a75-a8500ab04191	f79836e7-872c-4ee0-b2e5-bf4f95037872	\N	2024-05-20 11:19:48.717883+00	50.000	50.000	{}	{}	\N	{}	\N	{}	f
    Apple Juice	\N	3	5.990	5.990	t	0	384	0.0000		PLN		UHJvZHVjdFZhcmlhbnQ6Mzg0	17.970	17.970	0.000	0.000	\N	fixed	17.970	17.970	5.990	5.990	f	UHJvZHVjdFZhcmlhbnQ6Mzg0	\N	\N	a5cf238a-a9e0-49bb-9eb6-c70926c5480f	a388d338-f373-46de-98e9-45b9149ce8f6	\N	2024-05-20 11:19:50.065461+00	5.990	5.990	{}	{}	\N	{}	\N	{}	f
    Carrot Juice	\N	1	5.990	5.990	t	0	387	0.0000		PLN		UHJvZHVjdFZhcmlhbnQ6Mzg3	5.990	5.990	0.000	0.000	\N	fixed	5.990	5.990	5.990	5.990	f	UHJvZHVjdFZhcmlhbnQ6Mzg3	\N	\N	fbe88788-a5b7-4892-a6fe-bd82cbdea47b	caac37e0-8a9d-4c5f-a372-34de20686a33	\N	2024-05-20 11:19:49.171655+00	5.990	5.990	{}	{}	\N	{}	\N	{}	f
    Reversed Monotype Tee	9182235821	4	120.000	120.000	t	0	390	0.0000		PLN		XXL	480.000	480.000	0.000	0.000	\N	fixed	480.000	480.000	120.000	120.000	f	UHJvZHVjdFZhcmlhbnQ6Mzkw	\N	\N	fbe88788-a5b7-4892-a6fe-bd82cbdea47b	80e2d409-0549-476d-8352-bffa219de18c	\N	2024-05-20 11:19:49.17177+00	120.000	120.000	{}	{}	\N	{}	\N	{}	f
    Enterprise Cloud + On-premises	113223585	3	29.990	29.990	f	2	378	0.0000		PLN		CD	89.970	89.970	0.000	0.000	\N	fixed	89.970	89.970	29.990	29.990	f	UHJvZHVjdFZhcmlhbnQ6Mzc4	\N	\N	fbe88788-a5b7-4892-a6fe-bd82cbdea47b	4f433cde-1a2e-45b9-ba16-391e53d6e8d3	\N	2024-05-20 11:19:49.171467+00	29.990	29.990	{}	{}	\N	{}	\N	{}	f
    Dark Polygon Tee	112223581	2	150.000	150.000	t	0	365	0.0000		PLN		M	300.000	300.000	0.000	0.000	\N	fixed	300.000	300.000	150.000	150.000	f	UHJvZHVjdFZhcmlhbnQ6MzY1	\N	\N	8f4eb78f-e9e3-4e70-9110-72973e0e83d1	557f84d9-c283-4af6-b42f-3c9060735ce2	\N	2024-05-20 11:19:49.473026+00	150.000	150.000	{}	{}	\N	{}	\N	{}	f
    Blue Polygon Shirt	218223582	2	150.000	150.000	t	2	363	0.0000		PLN		XL	300.000	300.000	0.000	0.000	\N	fixed	300.000	300.000	150.000	150.000	f	UHJvZHVjdFZhcmlhbnQ6MzYz	\N	\N	8f4eb78f-e9e3-4e70-9110-72973e0e83d1	9ec76d7c-7b82-4b01-9112-d511a09baaec	\N	2024-05-20 11:19:49.47347+00	150.000	150.000	{}	{}	\N	{}	\N	{}	f
    Monokai Dimmed Sunnies	\N	4	90.000	90.000	f	0	388	0.0000		PLN		UHJvZHVjdFZhcmlhbnQ6Mzg4	360.000	360.000	0.000	0.000	\N	fixed	360.000	360.000	90.000	90.000	f	UHJvZHVjdFZhcmlhbnQ6Mzg4	\N	\N	3a5e7571-ce32-4f93-9309-a10b27922bda	f7d10db2-207c-46c2-9788-3067f983c099	\N	2024-05-20 11:19:49.800308+00	90.000	90.000	{}	{}	\N	{}	\N	{}	f
    Own your stack and data	124223582	4	4.990	4.990	f	0	380	0.0000		PLN		MP3	19.960	19.960	0.000	0.000	\N	fixed	19.960	19.960	4.990	4.990	f	UHJvZHVjdFZhcmlhbnQ6Mzgw	\N	\N	3a5e7571-ce32-4f93-9309-a10b27922bda	a4419162-587e-49b8-a361-f33d80509241	\N	2024-05-20 11:19:49.800556+00	4.990	4.990	{}	{}	\N	{}	\N	{}	f
    Battle-tested at brands like Lush	9018223582	2	45.000	45.000	f	0	372	0.0000		PLN		DVD	90.000	90.000	0.000	0.000	\N	fixed	90.000	90.000	45.000	45.000	f	UHJvZHVjdFZhcmlhbnQ6Mzcy	\N	\N	3a5e7571-ce32-4f93-9309-a10b27922bda	fcad68ad-4bdb-4dd9-ace4-d65a6814bc8d	\N	2024-05-20 11:19:49.800741+00	45.000	45.000	{}	{}	\N	{}	\N	{}	f
    Reversed Monotype Tee	9182235821	4	25.000	25.000	t	0	390	0.0000		USD		XXL	100.000	100.000	0.000	0.000	\N	fixed	100.000	100.000	25.000	25.000	f	UHJvZHVjdFZhcmlhbnQ6Mzkw	\N	\N	04a35c73-4ef1-4975-bb56-6e00f11ad33e	9632e41f-4f00-4cc1-9920-ed4fca8f2646	\N	2024-05-20 11:19:50.354334+00	25.000	25.000	{}	{}	\N	{}	\N	{}	f
    White Parrot Cushion	\N	2	30.000	30.000	f	0	399	0.0000		USD		UHJvZHVjdFZhcmlhbnQ6Mzk5	60.000	60.000	0.000	0.000	\N	fixed	60.000	60.000	30.000	30.000	f	UHJvZHVjdFZhcmlhbnQ6Mzk5	\N	\N	04a35c73-4ef1-4975-bb56-6e00f11ad33e	b43a2241-6dc6-49f7-a46d-4245fcfd6a43	\N	2024-05-20 11:19:50.354581+00	30.000	30.000	{}	{}	\N	{}	\N	{}	f
    Paul's Balance 420	118223584	1	50.000	50.000	t	0	343	0.0000		USD		42	50.000	50.000	0.000	0.000	\N	fixed	50.000	50.000	50.000	50.000	f	UHJvZHVjdFZhcmlhbnQ6MzQz	\N	\N	04a35c73-4ef1-4975-bb56-6e00f11ad33e	507c2363-90f9-4689-a89c-815590532d3e	\N	2024-05-20 11:19:50.354737+00	50.000	50.000	{}	{}	\N	{}	\N	{}	f
    Darko Polo	111223582	2	45.000	45.000	t	0	360	0.0000		USD		XXL	90.000	90.000	0.000	0.000	\N	fixed	90.000	90.000	45.000	45.000	f	UHJvZHVjdFZhcmlhbnQ6MzYw	\N	\N	04a35c73-4ef1-4975-bb56-6e00f11ad33e	0f40d16d-cbf3-45ca-be5f-8187d0647975	\N	2024-05-20 11:19:50.354885+00	45.000	45.000	{}	{}	\N	{}	\N	{}	f
    Monospace Tee	328223581	3	90.000	90.000	t	0	349	0.0000		PLN		M	270.000	270.000	0.000	0.000	\N	fixed	270.000	270.000	90.000	90.000	f	UHJvZHVjdFZhcmlhbnQ6MzQ5	\N	\N	f51baf78-a4eb-4393-947c-fe096cc10e9d	eda40b48-df6d-4193-a88f-e147dd9f4ff5	\N	2024-05-20 11:19:50.706785+00	90.000	90.000	{}	{}	\N	{}	\N	{}	f
    Team Shirt	128223582	1	200.000	200.000	t	0	355	0.0000		PLN		L	200.000	200.000	0.000	0.000	\N	fixed	200.000	200.000	200.000	200.000	f	UHJvZHVjdFZhcmlhbnQ6MzU1	\N	\N	f51baf78-a4eb-4393-947c-fe096cc10e9d	fba072a0-5087-4dc2-800e-4c4658217fb7	\N	2024-05-20 11:19:50.70702+00	200.000	200.000	{}	{}	\N	{}	\N	{}	f
    The Dash Cushion	\N	4	70.000	70.000	f	0	383	0.0000		PLN		UHJvZHVjdFZhcmlhbnQ6Mzgz	280.000	280.000	0.000	0.000	\N	fixed	280.000	280.000	70.000	70.000	f	UHJvZHVjdFZhcmlhbnQ6Mzgz	\N	\N	f51baf78-a4eb-4393-947c-fe096cc10e9d	6b2a6ebf-99c4-49e0-9e11-b6cd0856e135	\N	2024-05-20 11:19:50.707314+00	70.000	70.000	{}	{}	\N	{}	\N	{}	f
    Blue Polygon Shirt	218223581	4	45.000	45.000	t	0	362	0.0000		USD		L	180.000	180.000	0.000	0.000	\N	fixed	180.000	180.000	45.000	45.000	f	UHJvZHVjdFZhcmlhbnQ6MzYy	\N	\N	d40722d7-59be-423b-a091-7f3b37bee0e1	c60c21c0-c0d5-4c6e-aed7-411cbf3dd3b8	\N	2024-05-20 11:19:51.065822+00	45.000	45.000	{}	{}	\N	{}	\N	{}	f
    Enterprise Cloud + On-premises	113223583	2	29.990	29.990	f	2	376	0.0000		PLN		DVD	59.980	59.980	0.000	0.000	\N	fixed	59.980	59.980	29.990	29.990	f	UHJvZHVjdFZhcmlhbnQ6Mzc2	\N	\N	f51baf78-a4eb-4393-947c-fe096cc10e9d	7679b648-f311-4b9b-b1a9-0a3fa9d01573	\N	2024-05-20 11:19:50.707494+00	29.990	29.990	{}	{}	\N	{}	\N	{}	f
    White Parrot Cushion	\N	1	30.000	30.000	f	0	399	0.0000		USD		UHJvZHVjdFZhcmlhbnQ6Mzk5	30.000	30.000	0.000	0.000	\N	fixed	30.000	30.000	30.000	30.000	f	UHJvZHVjdFZhcmlhbnQ6Mzk5	\N	\N	d40722d7-59be-423b-a091-7f3b37bee0e1	0ce52efd-2335-49fd-bbef-e596e2c9a636	\N	2024-05-20 11:19:51.065973+00	30.000	30.000	{}	{}	\N	{}	\N	{}	f
    Dash Force	618223583	2	420.000	420.000	t	2	337	0.0000		PLN		41	840.000	840.000	0.000	0.000	\N	fixed	840.000	840.000	420.000	420.000	f	UHJvZHVjdFZhcmlhbnQ6MzM3	\N	\N	225ab765-e8c1-4c08-832a-4558ed064509	7c570801-94e4-4c00-9a32-1cf9527c9b07	\N	2024-05-20 11:19:51.353116+00	420.000	420.000	{}	{}	\N	{}	\N	{}	f
    Enterprise Cloud + On-premises	113223585	3	8.990	8.990	f	0	378	0.0000		USD		CD	26.970	26.970	0.000	0.000	\N	fixed	26.970	26.970	8.990	8.990	f	UHJvZHVjdFZhcmlhbnQ6Mzc4	\N	\N	d55cb189-c636-4adc-8709-d43cddae9e02	fd2b6b74-8331-4c59-acc4-b373422a82ed	\N	2024-05-20 11:19:51.61459+00	8.990	8.990	{}	{}	\N	{}	\N	{}	f
    Dash Force	618223584	3	90.000	90.000	t	1	338	0.0000		USD		42	270.000	270.000	0.000	0.000	\N	fixed	270.000	270.000	90.000	90.000	f	UHJvZHVjdFZhcmlhbnQ6MzM4	\N	\N	d55cb189-c636-4adc-8709-d43cddae9e02	f1f829f1-322a-4072-89bd-73b6680e5af5	\N	2024-05-20 11:19:51.614353+00	90.000	90.000	{}	{}	\N	{}	\N	{}	f
    White Parrot Cushion	\N	2	138.000	138.000	f	0	399	0.0000		PLN		UHJvZHVjdFZhcmlhbnQ6Mzk5	276.000	276.000	0.000	0.000	\N	fixed	276.000	276.000	138.000	138.000	f	UHJvZHVjdFZhcmlhbnQ6Mzk5	\N	\N	03d6e4ae-bbd5-4e9d-abd5-0872423f197f	ff282e82-5599-409c-901c-17085ceb391a	\N	2024-05-20 11:19:54.856754+00	138.000	138.000	{}	{}	\N	{}	\N	{}	f
    Enterprise Cloud + On-premises	113223584	2	29.990	29.990	f	1	377	0.0000		PLN		iTunes	59.980	59.980	0.000	0.000	\N	fixed	59.980	59.980	29.990	29.990	f	UHJvZHVjdFZhcmlhbnQ6Mzc3	\N	\N	03d6e4ae-bbd5-4e9d-abd5-0872423f197f	9e741d3b-017e-4316-9641-acb165d9072a	\N	2024-05-20 11:19:54.856915+00	29.990	29.990	{}	{}	\N	{}	\N	{}	f
    \.


    --
    -- Data for Name: page_page; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.page_page (id, slug, title, content, created_at, is_published, published_at, seo_description, seo_title, metadata, private_metadata, page_type_id) FROM stdin;
    3	about	About	{"time": 1652791943847, "blocks": [{"id": "1rqw8KEYBR", "data": {"text": "1 Saleor is a rapidly growing all-out commerce API. Saleor is <b>fully open-source, and 100% focused on the GraphQL</b>&nbsp;interface. Our mission is to provide unparalleled extensibility."}, "type": "paragraph"}, {"id": "Is0DQGyb93", "data": {"text": "2 We make it easy for front-end teams to <b>prototype fast, experiment, and build wonderful, unrestricted storefront experiences</b>."}, "type": "paragraph"}, {"id": "IwwtFzGF2A", "data": {"text": "3 We enable developers to <a href=\\"https://docs.saleor.io/docs/3.x/developer/extending/apps/key-concepts\\">extend Saleor</a> easily via [Saleor Apps](https://github.com/saleor/saleor-app-template), a robust tally of async/sync webhooks, and a composable Dashboard. "}, "type": "paragraph"}, {"id": "lJNRLN33D3", "data": {"text": "4 We allow brands to own their data and go fast while staying fully flexible with <a href=\\"https://cloud.saleor.io\\">Saleor Cloud</a>."}, "type": "paragraph"}], "version": "2.22.2"}	2022-05-13 16:45:57.101+00	t	2022-05-13 00:00:00+00			{}	{}	4
    \.


    --
    -- Data for Name: page_pagetranslation; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.page_pagetranslation (id, seo_title, seo_description, language_code, title, content, page_id) FROM stdin;
    \.


    --
    -- Data for Name: page_pagetype; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.page_pagetype (id, private_metadata, metadata, name, slug) FROM stdin;
    1	{}	{}	Default Type	default-type
    4	{}	{}	Simple	default-page
    \.


    --
    -- Data for Name: payment_payment; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.payment_payment (id, gateway, is_active, created_at, modified_at, charge_status, billing_first_name, billing_last_name, billing_company_name, billing_address_1, billing_address_2, billing_city, billing_city_area, billing_postal_code, billing_country_code, billing_country_area, billing_email, customer_ip_address, cc_brand, cc_exp_month, cc_exp_year, cc_first_digits, cc_last_digits, extra_data, token, currency, total, captured_amount, checkout_id, to_confirm, payment_method_type, return_url, psp_reference, partial, metadata, private_metadata, store_payment_method, order_id) FROM stdin;
    1	mirumee.payments.dummy	t	2024-05-20 11:17:35.78381+00	2024-05-20 11:17:35.78389+00	not-charged	Anthony	Bailey		51923 Jamie Spring		Lake Adrianstad		90870	TR		anthony.bailey@example.com	204.78.112.173	dummy_visa	12	2222		1234	{}	fd07307f-939b-41a0-84ec-7cea48d30fe6	USD	323.940	0.000	\N	f	card	\N		f	{}	{}	none	77908546-f356-4e27-9d96-bc40a694716e
    7	mirumee.payments.dummy	t	2024-05-20 11:17:37.943097+00	2024-05-20 11:17:38.036723+00	fully-charged	Brenda	Williams		5445 Patton Rapid		Archertown		18950	TR		brenda.williams@example.com	156.71.232.66	dummy_visa	12	2222		1234	{}	55a74427-8dcc-4e5d-9edc-c13729d8c137	PLN	4277.640	4277.640	\N	f	card	\N		f	{}	{}	none	3ec90525-e3c0-429f-9520-5ac9bced7715
    2	mirumee.payments.dummy	t	2024-05-20 11:17:36.107784+00	2024-05-20 11:17:36.206575+00	fully-charged	Stephen	Griffith		7004 Jonathan Springs Suite 388		Paulview		27891	TR		stephen.griffith@example.com	85.21.150.196	dummy_visa	12	2222		1234	{}	134c0aae-0363-4627-b4b1-a1b0ff194ec1	PLN	1200.090	1200.090	\N	f	card	\N		f	{}	{}	none	b2be7ed4-faa6-4cbd-98d0-d0a7a9ad57c9
    14	mirumee.payments.dummy	t	2024-05-20 11:17:40.207963+00	2024-05-20 11:17:40.332081+00	fully-charged	Lisa	Hansen		23732 Michael Island Suite 184		Lake Kenneth		58406	TR		lisa.hansen@example.com	188.95.59.118	dummy_visa	12	2222		1234	{}	dc43cb32-a3d2-4e6c-aad1-b18a940ebfef	USD	57.530	57.530	\N	f	card	\N		f	{}	{}	none	999999c3-f70a-430a-a4a4-24c91ce64916
    3	mirumee.payments.dummy	t	2024-05-20 11:17:36.436614+00	2024-05-20 11:17:36.538877+00	fully-charged	Michael	Thompson		660 Macdonald Place Suite 091		Finleyburgh		00908	TR		michael.thompson@example.com	163.225.225.101	dummy_visa	12	2222		1234	{}	c4aceb67-46dd-485f-8399-2ccf74243bde	PLN	1299.160	1299.160	\N	f	card	\N		f	{}	{}	none	7ed59560-a1bf-4137-8118-471da8d72fa1
    12	mirumee.payments.dummy	f	2024-05-20 11:17:39.562378+00	2024-05-20 11:17:39.642885+00	not-charged	Christian	West		132 Mclean Meadow Suite 446		Chelsealand		40742	TR		christian.west@example.com	64.179.185.96	dummy_visa	12	2222		1234	{}	7bee91f8-bbb8-4272-854c-fa38e5221629	PLN	1342.420	0.000	\N	f	card	\N		f	{}	{}	none	41083c1e-d013-4366-a11b-29843ab3deb8
    8	mirumee.payments.dummy	t	2024-05-20 11:17:38.287747+00	2024-05-20 11:17:38.380857+00	fully-charged	David	Noble		493 Ana Manors Suite 282		Lake Danielleshire		14925	TR		david.noble@example.com	207.19.220.239	dummy_visa	12	2222		1234	{}	83e1a1da-8375-4904-a9f0-47464fe405c8	PLN	2351.970	2351.970	\N	f	card	\N		f	{}	{}	none	2be62bb0-8316-4135-b2ec-77b76337e814
    4	mirumee.payments.dummy	f	2024-05-20 11:17:36.811978+00	2024-05-20 11:17:36.973411+00	fully-refunded	Kenneth	Miller		6708 Carpenter Overpass Suite 735		Bobbyton		21847	TR		kenneth.miller@example.com	150.157.96.240	dummy_visa	12	2222		1234	{}	bdc73ee0-9657-425f-9f40-8dde99d05e81	USD	163.060	0.000	\N	f	card	\N		f	{}	{}	none	c72dd0cd-d258-42f0-96bc-592be0f08c15
    5	mirumee.payments.dummy	t	2024-05-20 11:17:37.20539+00	2024-05-20 11:17:37.20543+00	not-charged	Vicki	Burgess		8967 Lawson Fort		Lake Nicoleburgh		40142	TR		vicki.burgess@example.com	106.114.234.163	dummy_visa	12	2222		1234	{}	d2678c2e-7a47-4c9b-877d-7d9a79666b79	USD	184.910	0.000	\N	f	card	\N		f	{}	{}	none	18149d27-f019-4abb-9c0f-987dff8a7dd2
    9	mirumee.payments.dummy	t	2024-05-20 11:17:38.638666+00	2024-05-20 11:17:38.722776+00	fully-charged	Leslie	Clark		5667 Blair Underpass		South Shelby		77378	TR		leslie.clark@example.com	184.129.24.9	dummy_visa	12	2222		1234	{}	abc88b48-f735-4f68-aa8e-ba5a21e42ce2	PLN	350.760	350.760	\N	f	card	\N		f	{}	{}	none	855ae710-20e2-486a-8ab4-f25216585284
    6	mirumee.payments.dummy	f	2024-05-20 11:17:37.522906+00	2024-05-20 11:17:37.676278+00	fully-refunded	Michael	Myers		116 Michael Crescent		West Morganport		95803	TR		michael.myers@example.com	32.148.247.35	dummy_visa	12	2222		1234	{}	733a3122-0ec2-4fb8-b01b-37cead595d92	PLN	675.130	0.000	\N	f	card	\N		f	{}	{}	none	395b103b-65f0-40cc-a55a-83ecf436b635
    10	mirumee.payments.dummy	t	2024-05-20 11:17:38.941352+00	2024-05-20 11:17:38.941387+00	not-charged	Larry	Smith		8885 Lee Tunnel Suite 208		Port Donna		74331	TR		larry.smith@example.com	61.180.80.180	dummy_visa	12	2222		1234	{}	c05a2133-3a5b-4a9d-82fb-37353613653e	USD	471.960	0.000	\N	f	card	\N		f	{}	{}	none	60dc6631-9a39-4746-963b-76d9ee0e8084
    15	mirumee.payments.dummy	f	2024-05-20 11:17:40.682826+00	2024-05-20 11:17:40.777387+00	not-charged	Ryan	Reid		097 Gallegos Crossroad Suite 506		Mccallberg		05951	TR		ryan.reid@example.com	86.60.91.36	dummy_visa	12	2222		1234	{}	8813000c-0fbe-440d-8a64-72293146da45	PLN	1656.000	0.000	\N	f	card	\N		f	{}	{}	none	7d320a24-ec67-4b93-9211-76f5bbca9c30
    11	mirumee.payments.dummy	t	2024-05-20 11:17:39.251594+00	2024-05-20 11:17:39.347631+00	fully-charged	Stefanie	Hoffman		930 Rice Estate Apt. 570		New Patricia		36476	TR		stefanie.hoffman@example.com	99.92.31.128	dummy_visa	12	2222		1234	{}	2bb8c584-be39-420e-ad50-d8bc8d0bcde7	PLN	2171.890	2171.890	\N	f	card	\N		f	{}	{}	none	e98191e3-b3f5-4f8b-a956-e3c194782fe5
    13	mirumee.payments.dummy	t	2024-05-20 11:17:39.895516+00	2024-05-20 11:17:39.978142+00	fully-charged	Natalie	Simpson		7389 Alec Squares Suite 508		Port Jonathan		20935	TR		natalie.simpson@example.com	182.125.60.171	dummy_visa	12	2222		1234	{}	ed09b0b5-395f-46b9-a51f-a42e4cda4ee5	USD	258.400	258.400	\N	f	card	\N		f	{}	{}	none	467a5b3a-9795-485c-8ac7-275867b302f7
    18	mirumee.payments.dummy	t	2024-05-20 11:17:41.701898+00	2024-05-20 11:17:41.798389+00	fully-charged	Susan	Phillips		91189 Moore Drive Apt. 358		East Kari		38650	TR		susan.phillips@example.com	158.38.138.10	dummy_visa	12	2222		1234	{}	6de429b8-e69a-4b75-8672-b05abfd7fa35	PLN	126.020	126.020	\N	f	card	\N		f	{}	{}	none	b24288be-8b7f-470b-a35b-cb7347c7658e
    17	mirumee.payments.dummy	f	2024-05-20 11:17:41.382177+00	2024-05-20 11:17:41.496875+00	fully-refunded	Jamie	Herman		332 Kathleen Knoll Apt. 719		New Caitlinfort		60217	TR		jamie.herman@example.com	96.226.240.180	dummy_visa	12	2222		1234	{}	b8daab47-47e9-4d96-89cd-d61285091f3c	PLN	1397.400	0.000	\N	f	card	\N		f	{}	{}	none	c3582d23-2cf4-4dd6-b502-a63de106ee28
    16	mirumee.payments.dummy	f	2024-05-20 11:17:41.005074+00	2024-05-20 11:17:41.086323+00	not-charged	Michael	Leonard		31845 Nathaniel Neck Suite 922		New Williamstad		77234	TR		michael.leonard@example.com	36.112.156.182	dummy_visa	12	2222		1234	{}	a3a14815-b1e9-4e93-8c83-3bbb4c66a371	PLN	203.200	0.000	\N	f	card	\N		f	{}	{}	none	ffda684a-ece1-4c21-9027-01c6bb7a9347
    19	mirumee.payments.dummy	t	2024-05-20 11:17:42.009167+00	2024-05-20 11:17:42.109339+00	fully-charged	Lisa	Hansen		23732 Michael Island Suite 184		Lake Kenneth		58406	TR		lisa.hansen@example.com	65.159.251.57	dummy_visa	12	2222		1234	{}	9fadc166-f482-4797-b306-3121e6babb40	USD	591.230	591.230	\N	f	card	\N		f	{}	{}	none	f925fcfe-aeea-48b8-bada-37d349cbc485
    20	mirumee.payments.dummy	f	2024-05-20 11:17:42.417975+00	2024-05-20 11:17:42.507472+00	not-charged	Natalie	Simpson		7389 Alec Squares Suite 508		Port Jonathan		20935	TR		natalie.simpson@example.com	40.4.111.34	dummy_visa	12	2222		1234	{}	2c876bb5-ae69-4f40-a3db-3122ed18e817	USD	127.190	0.000	\N	f	card	\N		f	{}	{}	none	4abcac1e-c1ac-45b4-bbd2-bb04ec61ed2b
    21	mirumee.payments.dummy	f	2024-05-20 11:18:00.510262+00	2024-05-20 11:18:00.631847+00	not-charged	Mary	Lyons		3230 Julia Villages		Lake Christian		78866	TR		mary.lyons@example.com	93.71.223.149	dummy_visa	12	2222		1234	{}	c5a3b150-d835-4905-8908-3aa97ec860c1	USD	50.930	0.000	\N	f	card	\N		f	{}	{}	none	ef646742-2b8f-4410-98da-faeb31d130a9
    22	mirumee.payments.dummy	t	2024-05-20 11:18:00.808115+00	2024-05-20 11:18:00.899389+00	fully-charged	Jennifer	Mendez		5600 Davis Highway		South Joel		47137	TR		jennifer.mendez@example.com	110.121.178.158	dummy_visa	12	2222		1234	{}	2abbe198-52d6-49bd-95a4-af7bb1db23f6	USD	89.160	89.160	\N	f	card	\N		f	{}	{}	none	67218714-3be3-4309-8b91-cb793d79af24
    23	mirumee.payments.dummy	t	2024-05-20 11:18:01.056841+00	2024-05-20 11:18:01.154986+00	fully-charged	Matthew	Pratt		48487 Kendra Ports Suite 076		South Michaelton		03212	TR		matthew.pratt@example.com	124.35.24.154	dummy_visa	12	2222		1234	{}	3d29d0d1-802e-4796-ae3c-a858f526d094	PLN	26.750	26.750	\N	f	card	\N		f	{}	{}	none	d82f243a-1b5c-4581-a33d-9a28f4dc3c6f
    24	mirumee.payments.dummy	t	2024-05-20 11:18:01.396995+00	2024-05-20 11:18:01.39705+00	not-charged	Shannon	Rhodes		6430 Cindy Cove		South Nicholas		72117	TR		shannon.rhodes@example.com	122.81.118.234	dummy_visa	12	2222		1234	{}	3dc92da1-ac33-4384-8ab3-a8d1befd230c	PLN	1056.860	0.000	\N	f	card	\N		f	{}	{}	none	b715c50a-bc26-4726-a6ce-175e4361ce26
    34	mirumee.payments.dummy	f	2024-05-20 11:18:04.906625+00	2024-05-20 11:18:05.016648+00	fully-refunded	Sarah	Walters		6595 Kurt Park Apt. 436		Grahamfurt		91871	TR		sarah.walters@example.com	209.58.182.201	dummy_visa	12	2222		1234	{}	fe545365-5d89-414a-a1fc-c6c288683618	PLN	587.950	0.000	\N	f	card	\N		f	{}	{}	none	75f316e4-b6bb-420b-98fb-9ede3d474e23
    25	mirumee.payments.dummy	f	2024-05-20 11:18:01.663103+00	2024-05-20 11:18:01.759257+00	not-charged	Joshua	Carr		180 Jennifer Burg Suite 661		Munozburgh		22731	TR		joshua.carr@example.com	199.106.8.190	dummy_visa	12	2222		1234	{}	2fac2a1c-308a-4c88-bfc3-000f54cec53a	PLN	411.040	0.000	\N	f	card	\N		f	{}	{}	none	1c468654-68d6-4b80-a937-bbcdc75135db
    31	mirumee.payments.dummy	t	2024-05-20 11:18:03.711249+00	2024-05-20 11:18:03.781232+00	fully-charged	Courtney	Crawford		342 Miller Mission		Lake Jennifer		67203	TR		courtney.crawford@example.com	211.54.167.111	dummy_visa	12	2222		1234	{}	6e24459b-243e-4d38-8d63-2fbb525e8d18	USD	537.590	537.590	\N	f	card	\N		f	{}	{}	none	46a3674f-1d4f-44c2-b059-1939c41489e7
    26	mirumee.payments.dummy	f	2024-05-20 11:18:01.971069+00	2024-05-20 11:18:02.068739+00	fully-refunded	Matthew	Blackburn		22395 Timothy Road		Williamsbury		83819	TR		matthew.blackburn@example.com	186.227.147.175	dummy_visa	12	2222		1234	{}	f9fc11d2-e487-4532-9bc9-d6def2b57d91	USD	440.930	0.000	\N	f	card	\N		f	{}	{}	none	40f2a9fc-c24c-4d97-a756-9cec06c5620a
    27	mirumee.payments.dummy	f	2024-05-20 11:18:02.319904+00	2024-05-20 11:18:02.396709+00	not-charged	Paul	Flowers		19539 Martin Ways Apt. 509		New Ericstad		48105	TR		paul.flowers@example.com	50.199.118.127	dummy_visa	12	2222		1234	{}	ce9f4039-ab92-4611-84b4-9119b409d819	USD	161.060	0.000	\N	f	card	\N		f	{}	{}	none	273b2205-ebf5-427a-bcf2-8d2476ef74a4
    35	mirumee.payments.dummy	t	2024-05-20 11:18:05.226514+00	2024-05-20 11:18:05.312944+00	fully-charged	Shannon	Rhodes		6430 Cindy Cove		South Nicholas		72117	TR		shannon.rhodes@example.com	150.177.125.60	dummy_visa	12	2222		1234	{}	7e10db48-24e9-40dc-b21a-e3a08d290b5f	PLN	327.300	327.300	\N	f	card	\N		f	{}	{}	none	551fabef-9899-4a41-9a6b-fc756e61a4fb
    28	mirumee.payments.dummy	t	2024-05-20 11:18:02.618957+00	2024-05-20 11:18:02.718478+00	fully-charged	Marcus	Patton		02907 Matthew Branch Suite 493		New Sharonview		23285	TR		marcus.patton@example.com	9.3.57.49	dummy_visa	12	2222		1234	{}	4642acfc-1dcb-4f2c-90fe-aa14ef274e4f	USD	200.870	200.870	\N	f	card	\N		f	{}	{}	none	a34786b7-9bda-4afd-b112-2a08c3ea1674
    32	mirumee.payments.dummy	f	2024-05-20 11:18:04.080282+00	2024-05-20 11:18:04.216979+00	fully-refunded	Deanna	Kennedy		85249 Stephen Cliff		Longchester		73395	TR		deanna.kennedy@example.com	202.84.55.130	dummy_visa	12	2222		1234	{}	87a966c7-162c-4882-a1df-fe792af9d4d5	USD	307.130	0.000	\N	f	card	\N		f	{}	{}	none	5e0958b4-f7d9-4309-9f5d-1d9cfc11db8a
    29	mirumee.payments.dummy	f	2024-05-20 11:18:03.009286+00	2024-05-20 11:18:03.083124+00	not-charged	Donna	Moore		896 Baker Haven		South Kimberlyview		34342	TR		donna.moore@example.com	6.139.30.240	dummy_visa	12	2222		1234	{}	ae7b9a56-8591-4640-837f-3a291352adac	USD	224.130	0.000	\N	f	card	\N		f	{}	{}	none	3b8345c5-9520-4881-900d-196ccbf1ca8b
    30	mirumee.payments.dummy	f	2024-05-20 11:18:03.304313+00	2024-05-20 11:18:03.403292+00	not-charged	Veronica	Lee		08296 Marshall Camp Suite 930		Allisonburgh		89663	TR		veronica.lee@example.com	98.213.246.8	dummy_visa	12	2222		1234	{}	0cdee9d6-c709-4312-919c-ea4308411d59	PLN	598.950	0.000	\N	f	card	\N		f	{}	{}	none	dfa31232-7eef-4bac-b390-de66b8cced9d
    37	mirumee.payments.dummy	t	2024-05-20 11:18:05.847763+00	2024-05-20 11:18:05.921643+00	fully-charged	Melvin	Willis		82434 Graves Glen		Zacharymouth		20843	TR		melvin.willis@example.com	1.142.131.220	dummy_visa	12	2222		1234	{}	de9c2e51-68d4-4d84-ad98-8360ae4cc42b	USD	203.590	203.590	\N	f	card	\N		f	{}	{}	none	fbc2f983-baab-436e-bddf-330707e3bfd5
    33	mirumee.payments.dummy	t	2024-05-20 11:18:04.552863+00	2024-05-20 11:18:04.639326+00	fully-charged	Patrick	Hendricks		769 Mary Harbor		Amyfort		31567	TR		patrick.hendricks@example.com	18.22.92.220	dummy_visa	12	2222		1234	{}	a5a903b0-50b2-4b5b-bde7-70a98ab9cd63	USD	398.940	398.940	\N	f	card	\N		f	{}	{}	none	8b90a8ae-754a-4355-9dc1-a431dcbdabc8
    42	mirumee.payments.dummy	t	2024-05-20 11:19:49.318759+00	2024-05-20 11:19:49.318797+00	not-charged	Regina	Larson		44851 Pamela Track		North Robert		38471	TR		regina.larson@example.com	121.76.116.211	dummy_visa	12	2222		1234	{}	9df86082-cf0c-42cb-9733-08d3b69ef312	PLN	598.540	0.000	\N	f	card	\N		f	{}	{}	none	fbe88788-a5b7-4892-a6fe-bd82cbdea47b
    38	mirumee.payments.dummy	t	2024-05-20 11:18:06.085271+00	2024-05-20 11:18:06.178384+00	fully-charged	Lisa	Hansen		23732 Michael Island Suite 184		Lake Kenneth		58406	TR		lisa.hansen@example.com	33.142.38.244	dummy_visa	12	2222		1234	{}	01018e4c-693e-492f-ba4d-5ea69084e4ef	USD	62.560	62.560	\N	f	card	\N		f	{}	{}	none	a30862b4-64f6-42ee-ba0e-b81771076c21
    36	mirumee.payments.dummy	f	2024-05-20 11:18:05.451869+00	2024-05-20 11:18:05.59902+00	fully-refunded	Elizabeth	Smith		90443 Karen Heights		North Ryan		94393	TR		elizabeth.smith@example.com	173.3.182.201	dummy_visa	12	2222		1234	{}	f168bdea-2d30-4b13-8f89-73c5e2733863	USD	128.400	0.000	\N	f	card	\N		f	{}	{}	none	fde48e98-dc8c-4d8c-b1f0-605ba9da1f87
    39	mirumee.payments.dummy	f	2024-05-20 11:18:06.47793+00	2024-05-20 11:18:06.569103+00	not-charged	Raymond	Mccall		19550 James Creek		Williamstown		41762	TR		raymond.mccall@example.com	40.4.111.34	dummy_visa	12	2222		1234	{}	d57efb86-9fd2-46f4-a475-3bd6825d0238	USD	326.960	0.000	\N	f	card	\N		f	{}	{}	none	19dadc8a-3dad-4161-b2c0-c2feacbc252e
    40	mirumee.payments.dummy	f	2024-05-20 11:18:06.922565+00	2024-05-20 11:18:07.054358+00	fully-refunded	Tracey	Hubbard		2926 Dixon Estates Apt. 270		Port Angelafurt		24122	TR		tracey.hubbard@example.com	37.76.148.114	dummy_visa	12	2222		1234	{}	43cbaf84-7342-488b-ad90-b381b4b013a4	USD	1285.940	0.000	\N	f	card	\N		f	{}	{}	none	806e024e-cf80-4860-8e3a-0998863844c8
    41	mirumee.payments.dummy	t	2024-05-20 11:19:48.9839+00	2024-05-20 11:19:48.983929+00	not-charged	Rachel	Hanson		516 Nolan Junctions Suite 826		Jimmyfurt		45920	TR		rachel.hanson@example.com	23.58.182.170	dummy_visa	12	2222		1234	{}	b982343c-cd45-43b4-b931-d12d8e0afe68	USD	344.130	0.000	\N	f	card	\N		f	{}	{}	none	92942735-68ad-4777-8a75-a8500ab04191
    43	mirumee.payments.dummy	t	2024-05-20 11:19:49.611742+00	2024-05-20 11:19:49.697741+00	fully-charged	Kevin	Kelly		250 Burton Burg		North Alexander		86205	TR		kevin.kelly@example.com	35.254.116.198	dummy_visa	12	2222		1234	{}	fa8a2f9c-488d-471d-ad59-662db1909501	PLN	620.760	620.760	\N	f	card	\N		f	{}	{}	none	8f4eb78f-e9e3-4e70-9110-72973e0e83d1
    44	mirumee.payments.dummy	t	2024-05-20 11:19:49.964706+00	2024-05-20 11:19:49.964734+00	not-charged	Michael	Beck		76254 Debra Stream		Reyeschester		35070	TR		michael.beck@example.com	15.103.3.131	dummy_visa	12	2222		1234	{}	be184745-c23f-4e6a-b960-a6404b1c4a86	PLN	563.280	0.000	\N	f	card	\N		f	{}	{}	none	3a5e7571-ce32-4f93-9309-a10b27922bda
    45	mirumee.payments.dummy	t	2024-05-20 11:19:50.184791+00	2024-05-20 11:19:50.274926+00	fully-charged	Katherine	Cunningham		6208 Christy Shore		North Mark		23605	TR		katherine.cunningham@example.com	112.90.2.199	dummy_visa	12	2222		1234	{}	cd3ceb4c-e160-4d43-af0c-cd70858893f3	PLN	35.160	35.160	\N	f	card	\N		f	{}	{}	none	a5cf238a-a9e0-49bb-9eb6-c70926c5480f
    47	mirumee.payments.dummy	t	2024-05-20 11:19:50.910303+00	2024-05-20 11:19:50.910356+00	not-charged	Anthony	Randolph		1542 Young Knolls		Lake Karen		44756	TR		anthony.randolph@example.com	125.248.32.240	dummy_visa	12	2222		1234	{}	2469a873-b233-4a0e-82eb-4b4619df117b	PLN	892.400	0.000	\N	f	card	\N		f	{}	{}	none	f51baf78-a4eb-4393-947c-fe096cc10e9d
    46	mirumee.payments.dummy	t	2024-05-20 11:19:50.54299+00	2024-05-20 11:19:50.618235+00	fully-charged	Sue	Kemp		169 Christine Mount		New Carolyn		33593	TR		sue.kemp@example.com	56.24.221.110	dummy_visa	12	2222		1234	{}	4395f156-6580-4d08-a530-8dd4dbb42bc1	USD	371.960	371.960	\N	f	card	\N		f	{}	{}	none	04a35c73-4ef1-4975-bb56-6e00f11ad33e
    48	mirumee.payments.dummy	t	2024-05-20 11:19:51.193577+00	2024-05-20 11:19:51.28084+00	fully-charged	Matthew	Jenkins		155 Courtney Trafficway Suite 803		Gregoryshire		43056	TR		matthew.jenkins@example.com	204.30.71.8	dummy_visa	12	2222		1234	{}	1d844700-24d1-4ed6-ac35-3e05cdcbedf6	USD	214.130	214.130	\N	f	card	\N		f	{}	{}	none	d40722d7-59be-423b-a091-7f3b37bee0e1
    49	mirumee.payments.dummy	t	2024-05-20 11:19:51.468006+00	2024-05-20 11:19:51.468073+00	not-charged	Lance	Lester		89840 Foster Crest Suite 570		West Jodyton		33782	TR		lance.lester@example.com	146.139.183.80	dummy_visa	12	2222		1234	{}	f5edd681-7dcb-4032-919e-59e44f5e4633	PLN	855.100	0.000	\N	f	card	\N		f	{}	{}	none	225ab765-e8c1-4c08-832a-4558ed064509
    55	mirumee.payments.dummy	f	2024-05-20 11:19:53.427794+00	2024-05-20 11:19:53.510278+00	not-charged	Christopher	Williams		0811 Howard Courts Suite 028		Susantown		49874	TR		christopher.williams@example.com	159.206.173.247	dummy_visa	12	2222		1234	{}	f672fd81-d0df-4b1c-a353-9660c77e890f	PLN	412.580	0.000	\N	f	card	\N		f	{}	{}	none	9c5a0a36-65db-43c5-905f-cab7fc47851a
    56	mirumee.payments.dummy	t	2024-05-20 11:19:53.682841+00	2024-05-20 11:19:53.68288+00	not-charged	Susan	Phillips		91189 Moore Drive Apt. 358		East Kari		38650	TR		susan.phillips@example.com	79.242.205.62	dummy_visa	12	2222		1234	{}	46c62f17-dd7b-4ea0-a5bf-831b081496af	PLN	549.160	0.000	\N	f	card	\N		f	{}	{}	none	57df811b-fa44-40dc-b658-265599f66e55
    50	mirumee.payments.dummy	f	2024-05-20 11:19:51.797145+00	2024-05-20 11:19:51.948197+00	fully-refunded	Andrew	Taylor		79061 Cook Parkways Suite 079		West Marissafort		72694	TR		andrew.taylor@example.com	199.106.8.190	dummy_visa	12	2222		1234	{}	6862aa44-cd95-4939-bb4f-6b6c83ba8c39	USD	411.720	0.000	\N	f	card	\N		f	{}	{}	none	d55cb189-c636-4adc-8709-d43cddae9e02
    51	mirumee.payments.dummy	t	2024-05-20 11:19:52.263327+00	2024-05-20 11:19:52.263366+00	not-charged	Kathryn	Black		3195 Brenda Stravenue Suite 225		New Lisashire		20970	TR		kathryn.black@example.com	201.115.232.226	dummy_visa	12	2222		1234	{}	233c0247-ab75-4765-b5d4-265225965b17	PLN	804.700	0.000	\N	f	card	\N		f	{}	{}	none	40fd51b7-e177-45e6-a439-60134b95c707
    52	mirumee.payments.dummy	f	2024-05-20 11:19:52.577939+00	2024-05-20 11:19:52.674867+00	not-charged	Kelly	Carter		9620 Ashley Mills Apt. 507		Julieborough		09708	TR		kelly.carter@example.com	7.100.26.203	dummy_visa	12	2222		1234	{}	2ca6f314-d203-4e87-9f60-84c55e4b9a2b	USD	398.940	0.000	\N	f	card	\N		f	{}	{}	none	6796b775-e1c5-46cf-949a-769dff727f49
    59	mirumee.payments.dummy	f	2024-05-20 11:19:54.608836+00	2024-05-20 11:19:54.73849+00	fully-refunded	Christian	West		132 Mclean Meadow Suite 446		Chelsealand		40742	TR		christian.west@example.com	64.179.185.96	dummy_visa	12	2222		1234	{}	bd40f178-c7c0-4d49-a9a4-3c9506a205d3	PLN	676.040	0.000	\N	f	card	\N		f	{}	{}	none	2b1ce541-0f20-4af6-9288-48e7dae71fd1
    53	mirumee.payments.dummy	t	2024-05-20 11:19:52.898355+00	2024-05-20 11:19:53.005606+00	fully-charged	Joshua	Greer		29188 Fischer Grove		Justinchester		94599	TR		joshua.greer@example.com	126.132.49.148	dummy_visa	12	2222		1234	{}	5a78b3e5-62b7-4392-8d38-0dab8426c44e	PLN	2146.120	2146.120	\N	f	card	\N		f	{}	{}	none	301b3825-9fea-411e-8500-51a9e126e150
    57	mirumee.payments.dummy	t	2024-05-20 11:19:53.991444+00	2024-05-20 11:19:54.09305+00	fully-charged	Willie	Murray		3019 Gerald Mall Apt. 340		Trevinoville		50923	TR		willie.murray@example.com	143.126.59.187	dummy_visa	12	2222		1234	{}	92ebeebb-03f5-4037-9171-16fb01131ad8	USD	493.950	493.950	\N	f	card	\N		f	{}	{}	none	d6c815a4-69c5-456d-aaab-46ae66e9b767
    54	mirumee.payments.dummy	t	2024-05-20 11:19:53.187134+00	2024-05-20 11:19:53.270302+00	fully-charged	Amanda	Spencer		62082 Ward Camp Suite 930		Allisonburgh		89663	TR		amanda.spencer@example.com	98.213.246.8	dummy_visa	12	2222		1234	{}	7e2d22c2-7f51-4b24-8904-90ce9db3f416	USD	44.160	44.160	\N	f	card	\N		f	{}	{}	none	bde60da5-c90b-449c-aa2d-805c2e596087
    60	mirumee.payments.dummy	t	2024-05-20 11:19:55.052655+00	2024-05-20 11:19:55.13483+00	fully-charged	Cynthia	Walsh		6065 Harris Hill		Davisburgh		14737	TR		cynthia.walsh@example.com	182.125.60.171	dummy_visa	12	2222		1234	{}	5df13049-485a-4a95-bb12-1c2400e8d5e3	PLN	565.690	565.690	\N	f	card	\N		f	{}	{}	none	03d6e4ae-bbd5-4e9d-abd5-0872423f197f
    58	mirumee.payments.dummy	t	2024-05-20 11:19:54.302379+00	2024-05-20 11:19:54.396582+00	fully-charged	Sarah	Smith		220 Madison Pass Apt. 001		Port Eric		50291	TR		sarah.smith@example.com	125.174.15.192	dummy_visa	12	2222		1234	{}	d73dfbba-93eb-4cb0-9cf3-b5fe48ba0e83	PLN	287.910	287.910	\N	f	card	\N		f	{}	{}	none	34fb389c-2252-4a47-bbbf-929dab109c89
    \.


    --
    -- Data for Name: payment_transaction; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.payment_transaction (id, created_at, token, kind, is_success, error, currency, amount, gateway_response, payment_id, customer_id, action_required, action_required_data, already_processed) FROM stdin;
    1	2024-05-20 11:17:35.839846+00	fd07307f-939b-41a0-84ec-7cea48d30fe6	auth	t	\N	USD	323.940	{}	1	\N	f	{}	t
    2	2024-05-20 11:17:36.14142+00	134c0aae-0363-4627-b4b1-a1b0ff194ec1	auth	t	\N	PLN	1200.090	{}	2	\N	f	{}	t
    3	2024-05-20 11:17:36.204248+00	134c0aae-0363-4627-b4b1-a1b0ff194ec1	capture	t	\N	PLN	1200.090	{}	2	\N	f	{}	t
    4	2024-05-20 11:17:36.478148+00	c4aceb67-46dd-485f-8399-2ccf74243bde	auth	t	\N	PLN	1299.160	{}	3	\N	f	{}	t
    5	2024-05-20 11:17:36.536542+00	c4aceb67-46dd-485f-8399-2ccf74243bde	capture	t	\N	PLN	1299.160	{}	3	\N	f	{}	t
    6	2024-05-20 11:17:36.85144+00	bdc73ee0-9657-425f-9f40-8dde99d05e81	auth	t	\N	USD	163.060	{}	4	\N	f	{}	t
    7	2024-05-20 11:17:36.915524+00	bdc73ee0-9657-425f-9f40-8dde99d05e81	capture	t	\N	USD	163.060	{}	4	\N	f	{}	t
    8	2024-05-20 11:17:36.971478+00	bdc73ee0-9657-425f-9f40-8dde99d05e81	refund	t	\N	USD	163.060	{}	4	\N	f	{}	t
    9	2024-05-20 11:17:37.254114+00	d2678c2e-7a47-4c9b-877d-7d9a79666b79	auth	t	\N	USD	184.910	{}	5	\N	f	{}	t
    10	2024-05-20 11:17:37.569435+00	733a3122-0ec2-4fb8-b01b-37cead595d92	auth	t	\N	PLN	675.130	{}	6	\N	f	{}	t
    11	2024-05-20 11:17:37.620169+00	733a3122-0ec2-4fb8-b01b-37cead595d92	capture	t	\N	PLN	675.130	{}	6	\N	f	{}	t
    12	2024-05-20 11:17:37.674474+00	733a3122-0ec2-4fb8-b01b-37cead595d92	refund	t	\N	PLN	675.130	{}	6	\N	f	{}	t
    13	2024-05-20 11:17:37.975503+00	55a74427-8dcc-4e5d-9edc-c13729d8c137	auth	t	\N	PLN	4277.640	{}	7	\N	f	{}	t
    14	2024-05-20 11:17:38.035166+00	55a74427-8dcc-4e5d-9edc-c13729d8c137	capture	t	\N	PLN	4277.640	{}	7	\N	f	{}	t
    15	2024-05-20 11:17:38.321124+00	83e1a1da-8375-4904-a9f0-47464fe405c8	auth	t	\N	PLN	2351.970	{}	8	\N	f	{}	t
    16	2024-05-20 11:17:38.378857+00	83e1a1da-8375-4904-a9f0-47464fe405c8	capture	t	\N	PLN	2351.970	{}	8	\N	f	{}	t
    17	2024-05-20 11:17:38.671926+00	abc88b48-f735-4f68-aa8e-ba5a21e42ce2	auth	t	\N	PLN	350.760	{}	9	\N	f	{}	t
    18	2024-05-20 11:17:38.720647+00	abc88b48-f735-4f68-aa8e-ba5a21e42ce2	capture	t	\N	PLN	350.760	{}	9	\N	f	{}	t
    19	2024-05-20 11:17:38.972808+00	c05a2133-3a5b-4a9d-82fb-37353613653e	auth	t	\N	USD	471.960	{}	10	\N	f	{}	t
    20	2024-05-20 11:17:39.285979+00	2bb8c584-be39-420e-ad50-d8bc8d0bcde7	auth	t	\N	PLN	2171.890	{}	11	\N	f	{}	t
    21	2024-05-20 11:17:39.345528+00	2bb8c584-be39-420e-ad50-d8bc8d0bcde7	capture	t	\N	PLN	2171.890	{}	11	\N	f	{}	t
    22	2024-05-20 11:17:39.596772+00	7bee91f8-bbb8-4272-854c-fa38e5221629	auth	t	\N	PLN	1342.420	{}	12	\N	f	{}	t
    23	2024-05-20 11:17:39.640921+00	7bee91f8-bbb8-4272-854c-fa38e5221629	void	t	\N	PLN	1342.420	{}	12	\N	f	{}	t
    24	2024-05-20 11:17:39.924103+00	ed09b0b5-395f-46b9-a51f-a42e4cda4ee5	auth	t	\N	USD	258.400	{}	13	\N	f	{}	t
    25	2024-05-20 11:17:39.9762+00	ed09b0b5-395f-46b9-a51f-a42e4cda4ee5	capture	t	\N	USD	258.400	{}	13	\N	f	{}	t
    26	2024-05-20 11:17:40.284696+00	dc43cb32-a3d2-4e6c-aad1-b18a940ebfef	auth	t	\N	USD	57.530	{}	14	\N	f	{}	t
    27	2024-05-20 11:17:40.330518+00	dc43cb32-a3d2-4e6c-aad1-b18a940ebfef	capture	t	\N	USD	57.530	{}	14	\N	f	{}	t
    28	2024-05-20 11:17:40.718065+00	8813000c-0fbe-440d-8a64-72293146da45	auth	t	\N	PLN	1656.000	{}	15	\N	f	{}	t
    29	2024-05-20 11:17:40.773926+00	8813000c-0fbe-440d-8a64-72293146da45	void	t	\N	PLN	1656.000	{}	15	\N	f	{}	t
    30	2024-05-20 11:17:41.037415+00	a3a14815-b1e9-4e93-8c83-3bbb4c66a371	auth	t	\N	PLN	203.200	{}	16	\N	f	{}	t
    31	2024-05-20 11:17:41.084285+00	a3a14815-b1e9-4e93-8c83-3bbb4c66a371	void	t	\N	PLN	203.200	{}	16	\N	f	{}	t
    32	2024-05-20 11:17:41.414768+00	b8daab47-47e9-4d96-89cd-d61285091f3c	auth	t	\N	PLN	1397.400	{}	17	\N	f	{}	t
    33	2024-05-20 11:17:41.454661+00	b8daab47-47e9-4d96-89cd-d61285091f3c	capture	t	\N	PLN	1397.400	{}	17	\N	f	{}	t
    34	2024-05-20 11:17:41.494887+00	b8daab47-47e9-4d96-89cd-d61285091f3c	refund	t	\N	PLN	1397.400	{}	17	\N	f	{}	t
    35	2024-05-20 11:17:41.74925+00	6de429b8-e69a-4b75-8672-b05abfd7fa35	auth	t	\N	PLN	126.020	{}	18	\N	f	{}	t
    36	2024-05-20 11:17:41.79676+00	6de429b8-e69a-4b75-8672-b05abfd7fa35	capture	t	\N	PLN	126.020	{}	18	\N	f	{}	t
    37	2024-05-20 11:17:42.05096+00	9fadc166-f482-4797-b306-3121e6babb40	auth	t	\N	USD	591.230	{}	19	\N	f	{}	t
    38	2024-05-20 11:17:42.10701+00	9fadc166-f482-4797-b306-3121e6babb40	capture	t	\N	USD	591.230	{}	19	\N	f	{}	t
    39	2024-05-20 11:17:42.449415+00	2c876bb5-ae69-4f40-a3db-3122ed18e817	auth	t	\N	USD	127.190	{}	20	\N	f	{}	t
    40	2024-05-20 11:17:42.505024+00	2c876bb5-ae69-4f40-a3db-3122ed18e817	void	t	\N	USD	127.190	{}	20	\N	f	{}	t
    41	2024-05-20 11:18:00.564529+00	c5a3b150-d835-4905-8908-3aa97ec860c1	auth	t	\N	USD	50.930	{}	21	\N	f	{}	t
    42	2024-05-20 11:18:00.629691+00	c5a3b150-d835-4905-8908-3aa97ec860c1	void	t	\N	USD	50.930	{}	21	\N	f	{}	t
    43	2024-05-20 11:18:00.849677+00	2abbe198-52d6-49bd-95a4-af7bb1db23f6	auth	t	\N	USD	89.160	{}	22	\N	f	{}	t
    44	2024-05-20 11:18:00.897589+00	2abbe198-52d6-49bd-95a4-af7bb1db23f6	capture	t	\N	USD	89.160	{}	22	\N	f	{}	t
    45	2024-05-20 11:18:01.102+00	3d29d0d1-802e-4796-ae3c-a858f526d094	auth	t	\N	PLN	26.750	{}	23	\N	f	{}	t
    46	2024-05-20 11:18:01.153011+00	3d29d0d1-802e-4796-ae3c-a858f526d094	capture	t	\N	PLN	26.750	{}	23	\N	f	{}	t
    47	2024-05-20 11:18:01.427826+00	3dc92da1-ac33-4384-8ab3-a8d1befd230c	auth	t	\N	PLN	1056.860	{}	24	\N	f	{}	t
    48	2024-05-20 11:18:01.708514+00	2fac2a1c-308a-4c88-bfc3-000f54cec53a	auth	t	\N	PLN	411.040	{}	25	\N	f	{}	t
    49	2024-05-20 11:18:01.75773+00	2fac2a1c-308a-4c88-bfc3-000f54cec53a	void	t	\N	PLN	411.040	{}	25	\N	f	{}	t
    50	2024-05-20 11:18:01.999159+00	f9fc11d2-e487-4532-9bc9-d6def2b57d91	auth	t	\N	USD	440.930	{}	26	\N	f	{}	t
    51	2024-05-20 11:18:02.028329+00	f9fc11d2-e487-4532-9bc9-d6def2b57d91	capture	t	\N	USD	440.930	{}	26	\N	f	{}	t
    52	2024-05-20 11:18:02.06668+00	f9fc11d2-e487-4532-9bc9-d6def2b57d91	refund	t	\N	USD	440.930	{}	26	\N	f	{}	t
    53	2024-05-20 11:18:02.353699+00	ce9f4039-ab92-4611-84b4-9119b409d819	auth	t	\N	USD	161.060	{}	27	\N	f	{}	t
    54	2024-05-20 11:18:02.394599+00	ce9f4039-ab92-4611-84b4-9119b409d819	void	t	\N	USD	161.060	{}	27	\N	f	{}	t
    55	2024-05-20 11:18:02.668181+00	4642acfc-1dcb-4f2c-90fe-aa14ef274e4f	auth	t	\N	USD	200.870	{}	28	\N	f	{}	t
    56	2024-05-20 11:18:02.717194+00	4642acfc-1dcb-4f2c-90fe-aa14ef274e4f	capture	t	\N	USD	200.870	{}	28	\N	f	{}	t
    57	2024-05-20 11:18:03.052296+00	ae7b9a56-8591-4640-837f-3a291352adac	auth	t	\N	USD	224.130	{}	29	\N	f	{}	t
    58	2024-05-20 11:18:03.081648+00	ae7b9a56-8591-4640-837f-3a291352adac	void	t	\N	USD	224.130	{}	29	\N	f	{}	t
    59	2024-05-20 11:18:03.338004+00	0cdee9d6-c709-4312-919c-ea4308411d59	auth	t	\N	PLN	598.950	{}	30	\N	f	{}	t
    60	2024-05-20 11:18:03.401215+00	0cdee9d6-c709-4312-919c-ea4308411d59	void	t	\N	PLN	598.950	{}	30	\N	f	{}	t
    61	2024-05-20 11:18:03.745326+00	6e24459b-243e-4d38-8d63-2fbb525e8d18	auth	t	\N	USD	537.590	{}	31	\N	f	{}	t
    62	2024-05-20 11:18:03.779732+00	6e24459b-243e-4d38-8d63-2fbb525e8d18	capture	t	\N	USD	537.590	{}	31	\N	f	{}	t
    63	2024-05-20 11:18:04.118096+00	87a966c7-162c-4882-a1df-fe792af9d4d5	auth	t	\N	USD	307.130	{}	32	\N	f	{}	t
    64	2024-05-20 11:18:04.175873+00	87a966c7-162c-4882-a1df-fe792af9d4d5	capture	t	\N	USD	307.130	{}	32	\N	f	{}	t
    65	2024-05-20 11:18:04.215412+00	87a966c7-162c-4882-a1df-fe792af9d4d5	refund	t	\N	USD	307.130	{}	32	\N	f	{}	t
    66	2024-05-20 11:18:04.593115+00	a5a903b0-50b2-4b5b-bde7-70a98ab9cd63	auth	t	\N	USD	398.940	{}	33	\N	f	{}	t
    67	2024-05-20 11:18:04.637592+00	a5a903b0-50b2-4b5b-bde7-70a98ab9cd63	capture	t	\N	USD	398.940	{}	33	\N	f	{}	t
    68	2024-05-20 11:18:04.941216+00	fe545365-5d89-414a-a1fc-c6c288683618	auth	t	\N	PLN	587.950	{}	34	\N	f	{}	t
    69	2024-05-20 11:18:04.977192+00	fe545365-5d89-414a-a1fc-c6c288683618	capture	t	\N	PLN	587.950	{}	34	\N	f	{}	t
    70	2024-05-20 11:18:05.014794+00	fe545365-5d89-414a-a1fc-c6c288683618	refund	t	\N	PLN	587.950	{}	34	\N	f	{}	t
    71	2024-05-20 11:18:05.264423+00	7e10db48-24e9-40dc-b21a-e3a08d290b5f	auth	t	\N	PLN	327.300	{}	35	\N	f	{}	t
    72	2024-05-20 11:18:05.311355+00	7e10db48-24e9-40dc-b21a-e3a08d290b5f	capture	t	\N	PLN	327.300	{}	35	\N	f	{}	t
    73	2024-05-20 11:18:05.488083+00	f168bdea-2d30-4b13-8f89-73c5e2733863	auth	t	\N	USD	128.400	{}	36	\N	f	{}	t
    74	2024-05-20 11:18:05.534214+00	f168bdea-2d30-4b13-8f89-73c5e2733863	capture	t	\N	USD	128.400	{}	36	\N	f	{}	t
    75	2024-05-20 11:18:05.596505+00	f168bdea-2d30-4b13-8f89-73c5e2733863	refund	t	\N	USD	128.400	{}	36	\N	f	{}	t
    76	2024-05-20 11:18:05.889263+00	de9c2e51-68d4-4d84-ad98-8360ae4cc42b	auth	t	\N	USD	203.590	{}	37	\N	f	{}	t
    77	2024-05-20 11:18:05.920368+00	de9c2e51-68d4-4d84-ad98-8360ae4cc42b	capture	t	\N	USD	203.590	{}	37	\N	f	{}	t
    78	2024-05-20 11:18:06.133233+00	01018e4c-693e-492f-ba4d-5ea69084e4ef	auth	t	\N	USD	62.560	{}	38	\N	f	{}	t
    79	2024-05-20 11:18:06.176736+00	01018e4c-693e-492f-ba4d-5ea69084e4ef	capture	t	\N	USD	62.560	{}	38	\N	f	{}	t
    80	2024-05-20 11:18:06.519959+00	d57efb86-9fd2-46f4-a475-3bd6825d0238	auth	t	\N	USD	326.960	{}	39	\N	f	{}	t
    81	2024-05-20 11:18:06.567394+00	d57efb86-9fd2-46f4-a475-3bd6825d0238	void	t	\N	USD	326.960	{}	39	\N	f	{}	t
    82	2024-05-20 11:18:06.959283+00	43cbaf84-7342-488b-ad90-b381b4b013a4	auth	t	\N	USD	1285.940	{}	40	\N	f	{}	t
    83	2024-05-20 11:18:07.008688+00	43cbaf84-7342-488b-ad90-b381b4b013a4	capture	t	\N	USD	1285.940	{}	40	\N	f	{}	t
    84	2024-05-20 11:18:07.052734+00	43cbaf84-7342-488b-ad90-b381b4b013a4	refund	t	\N	USD	1285.940	{}	40	\N	f	{}	t
    85	2024-05-20 11:19:49.028974+00	b982343c-cd45-43b4-b931-d12d8e0afe68	auth	t	\N	USD	344.130	{}	41	\N	f	{}	t
    86	2024-05-20 11:19:49.35524+00	9df86082-cf0c-42cb-9733-08d3b69ef312	auth	t	\N	PLN	598.540	{}	42	\N	f	{}	t
    87	2024-05-20 11:19:49.66043+00	fa8a2f9c-488d-471d-ad59-662db1909501	auth	t	\N	PLN	620.760	{}	43	\N	f	{}	t
    88	2024-05-20 11:19:49.696287+00	fa8a2f9c-488d-471d-ad59-662db1909501	capture	t	\N	PLN	620.760	{}	43	\N	f	{}	t
    89	2024-05-20 11:19:49.994472+00	be184745-c23f-4e6a-b960-a6404b1c4a86	auth	t	\N	PLN	563.280	{}	44	\N	f	{}	t
    90	2024-05-20 11:19:50.221388+00	cd3ceb4c-e160-4d43-af0c-cd70858893f3	auth	t	\N	PLN	35.160	{}	45	\N	f	{}	t
    91	2024-05-20 11:19:50.271507+00	cd3ceb4c-e160-4d43-af0c-cd70858893f3	capture	t	\N	PLN	35.160	{}	45	\N	f	{}	t
    92	2024-05-20 11:19:50.573681+00	4395f156-6580-4d08-a530-8dd4dbb42bc1	auth	t	\N	USD	371.960	{}	46	\N	f	{}	t
    93	2024-05-20 11:19:50.616154+00	4395f156-6580-4d08-a530-8dd4dbb42bc1	capture	t	\N	USD	371.960	{}	46	\N	f	{}	t
    94	2024-05-20 11:19:50.950278+00	2469a873-b233-4a0e-82eb-4b4619df117b	auth	t	\N	PLN	892.400	{}	47	\N	f	{}	t
    95	2024-05-20 11:19:51.226494+00	1d844700-24d1-4ed6-ac35-3e05cdcbedf6	auth	t	\N	USD	214.130	{}	48	\N	f	{}	t
    96	2024-05-20 11:19:51.27764+00	1d844700-24d1-4ed6-ac35-3e05cdcbedf6	capture	t	\N	USD	214.130	{}	48	\N	f	{}	t
    97	2024-05-20 11:19:51.503099+00	f5edd681-7dcb-4032-919e-59e44f5e4633	auth	t	\N	PLN	855.100	{}	49	\N	f	{}	t
    98	2024-05-20 11:19:51.85136+00	6862aa44-cd95-4939-bb4f-6b6c83ba8c39	auth	t	\N	USD	411.720	{}	50	\N	f	{}	t
    99	2024-05-20 11:19:51.899+00	6862aa44-cd95-4939-bb4f-6b6c83ba8c39	capture	t	\N	USD	411.720	{}	50	\N	f	{}	t
    100	2024-05-20 11:19:51.945413+00	6862aa44-cd95-4939-bb4f-6b6c83ba8c39	refund	t	\N	USD	411.720	{}	50	\N	f	{}	t
    101	2024-05-20 11:19:52.305467+00	233c0247-ab75-4765-b5d4-265225965b17	auth	t	\N	PLN	804.700	{}	51	\N	f	{}	t
    102	2024-05-20 11:19:52.613716+00	2ca6f314-d203-4e87-9f60-84c55e4b9a2b	auth	t	\N	USD	398.940	{}	52	\N	f	{}	t
    103	2024-05-20 11:19:52.671986+00	2ca6f314-d203-4e87-9f60-84c55e4b9a2b	void	t	\N	USD	398.940	{}	52	\N	f	{}	t
    104	2024-05-20 11:19:52.94554+00	5a78b3e5-62b7-4392-8d38-0dab8426c44e	auth	t	\N	PLN	2146.120	{}	53	\N	f	{}	t
    105	2024-05-20 11:19:53.003211+00	5a78b3e5-62b7-4392-8d38-0dab8426c44e	capture	t	\N	PLN	2146.120	{}	53	\N	f	{}	t
    106	2024-05-20 11:19:53.218214+00	7e2d22c2-7f51-4b24-8904-90ce9db3f416	auth	t	\N	USD	44.160	{}	54	\N	f	{}	t
    107	2024-05-20 11:19:53.268203+00	7e2d22c2-7f51-4b24-8904-90ce9db3f416	capture	t	\N	USD	44.160	{}	54	\N	f	{}	t
    108	2024-05-20 11:19:53.461485+00	f672fd81-d0df-4b1c-a353-9660c77e890f	auth	t	\N	PLN	412.580	{}	55	\N	f	{}	t
    109	2024-05-20 11:19:53.508837+00	f672fd81-d0df-4b1c-a353-9660c77e890f	void	t	\N	PLN	412.580	{}	55	\N	f	{}	t
    110	2024-05-20 11:19:53.719808+00	46c62f17-dd7b-4ea0-a5bf-831b081496af	auth	t	\N	PLN	549.160	{}	56	\N	f	{}	t
    111	2024-05-20 11:19:54.039425+00	92ebeebb-03f5-4037-9171-16fb01131ad8	auth	t	\N	USD	493.950	{}	57	\N	f	{}	t
    112	2024-05-20 11:19:54.091218+00	92ebeebb-03f5-4037-9171-16fb01131ad8	capture	t	\N	USD	493.950	{}	57	\N	f	{}	t
    113	2024-05-20 11:19:54.340583+00	d73dfbba-93eb-4cb0-9cf3-b5fe48ba0e83	auth	t	\N	PLN	287.910	{}	58	\N	f	{}	t
    114	2024-05-20 11:19:54.393867+00	d73dfbba-93eb-4cb0-9cf3-b5fe48ba0e83	capture	t	\N	PLN	287.910	{}	58	\N	f	{}	t
    115	2024-05-20 11:19:54.641829+00	bd40f178-c7c0-4d49-a9a4-3c9506a205d3	auth	t	\N	PLN	676.040	{}	59	\N	f	{}	t
    116	2024-05-20 11:19:54.686525+00	bd40f178-c7c0-4d49-a9a4-3c9506a205d3	capture	t	\N	PLN	676.040	{}	59	\N	f	{}	t
    117	2024-05-20 11:19:54.73632+00	bd40f178-c7c0-4d49-a9a4-3c9506a205d3	refund	t	\N	PLN	676.040	{}	59	\N	f	{}	t
    118	2024-05-20 11:19:55.093057+00	5df13049-485a-4a95-bb12-1c2400e8d5e3	auth	t	\N	PLN	565.690	{}	60	\N	f	{}	t
    119	2024-05-20 11:19:55.132939+00	5df13049-485a-4a95-bb12-1c2400e8d5e3	capture	t	\N	PLN	565.690	{}	60	\N	f	{}	t
    \.


    --
    -- Data for Name: payment_transactionevent; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.payment_transactionevent (id, created_at, status, transaction_id, amount_value, app_id, app_identifier, currency, external_url, include_in_calculations, message, psp_reference, type, user_id, idempotency_key) FROM stdin;
    \.


    --
    -- Data for Name: payment_transactionitem; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.payment_transactionitem (id, private_metadata, metadata, created_at, modified_at, status, available_actions, currency, charged_value, authorized_value, refunded_value, checkout_id, order_id, app_id, app_identifier, authorize_pending_value, cancel_pending_value, canceled_value, charge_pending_value, external_url, message, name, psp_reference, refund_pending_value, user_id, token, use_old_id, last_refund_success, idempotency_key) FROM stdin;
    \.


    --
    -- Data for Name: permission_permission; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.permission_permission (id, name, content_type_id, codename) FROM stdin;
    1	Can add plugin configuration	1	add_pluginconfiguration
    2	Can change plugin configuration	1	change_pluginconfiguration
    3	Can delete plugin configuration	1	delete_pluginconfiguration
    4	Can view plugin configuration	1	view_pluginconfiguration
    5	Manage plugins	1	manage_plugins
    34	Can add sale	34	add_sale
    35	Can change sale	34	change_sale
    36	Can delete sale	34	delete_sale
    37	Can view sale	34	view_sale
    39	Can add voucher	35	add_voucher
    40	Can change voucher	35	change_voucher
    41	Can delete voucher	35	delete_voucher
    42	Can view voucher	35	view_voucher
    43	Can add voucher translation	36	add_vouchertranslation
    44	Can change voucher translation	36	change_vouchertranslation
    45	Can delete voucher translation	36	delete_vouchertranslation
    46	Can view voucher translation	36	view_vouchertranslation
    47	Can add sale translation	37	add_saletranslation
    48	Can change sale translation	37	change_saletranslation
    49	Can delete sale translation	37	delete_saletranslation
    50	Can view sale translation	37	view_saletranslation
    51	Can add voucher customer	38	add_vouchercustomer
    52	Can change voucher customer	38	change_vouchercustomer
    53	Can delete voucher customer	38	delete_vouchercustomer
    54	Can view voucher customer	38	view_vouchercustomer
    55	Can add sale channel listing	39	add_salechannellisting
    56	Can change sale channel listing	39	change_salechannellisting
    57	Can delete sale channel listing	39	delete_salechannellisting
    58	Can view sale channel listing	39	view_salechannellisting
    59	Can add voucher channel listing	40	add_voucherchannellisting
    60	Can change voucher channel listing	40	change_voucherchannellisting
    61	Can delete voucher channel listing	40	delete_voucherchannellisting
    62	Can view voucher channel listing	40	view_voucherchannellisting
    63	Can add order discount	41	add_orderdiscount
    64	Can change order discount	41	change_orderdiscount
    65	Can delete order discount	41	delete_orderdiscount
    66	Can view order discount	41	view_orderdiscount
    67	Can add checkout line discount	42	add_checkoutlinediscount
    68	Can change checkout line discount	42	change_checkoutlinediscount
    69	Can delete checkout line discount	42	delete_checkoutlinediscount
    70	Can view checkout line discount	42	view_checkoutlinediscount
    71	Can add promotion	43	add_promotion
    72	Can change promotion	43	change_promotion
    73	Can delete promotion	43	delete_promotion
    74	Can view promotion	43	view_promotion
    75	Can add promotion rule	44	add_promotionrule
    76	Can change promotion rule	44	change_promotionrule
    77	Can delete promotion rule	44	delete_promotionrule
    78	Can view promotion rule	44	view_promotionrule
    79	Can add order line discount	45	add_orderlinediscount
    80	Can change order line discount	45	change_orderlinediscount
    81	Can delete order line discount	45	delete_orderlinediscount
    82	Can view order line discount	45	view_orderlinediscount
    83	Can add promotion translation	46	add_promotiontranslation
    84	Can change promotion translation	46	change_promotiontranslation
    85	Can delete promotion translation	46	delete_promotiontranslation
    86	Can view promotion translation	46	view_promotiontranslation
    87	Can add promotion rule translation	47	add_promotionruletranslation
    88	Can change promotion rule translation	47	change_promotionruletranslation
    89	Can delete promotion rule translation	47	delete_promotionruletranslation
    90	Can view promotion rule translation	47	view_promotionruletranslation
    91	Can add promotion event	48	add_promotionevent
    92	Can change promotion event	48	change_promotionevent
    93	Can delete promotion event	48	delete_promotionevent
    94	Can view promotion event	48	view_promotionevent
    38	Manage promotions and vouchers.	43	manage_discounts
    95	Can add content type	49	add_contenttype
    96	Can change content type	49	change_contenttype
    97	Can delete content type	49	delete_contenttype
    98	Can view content type	49	view_contenttype
    99	Can add site	50	add_site
    100	Can change site	50	change_site
    101	Can delete site	50	delete_site
    102	Can view site	50	view_site
    103	Can add crontab	51	add_crontabschedule
    104	Can change crontab	51	change_crontabschedule
    105	Can delete crontab	51	delete_crontabschedule
    106	Can view crontab	51	view_crontabschedule
    107	Can add interval	52	add_intervalschedule
    108	Can change interval	52	change_intervalschedule
    109	Can delete interval	52	delete_intervalschedule
    110	Can view interval	52	view_intervalschedule
    111	Can add periodic task	53	add_periodictask
    112	Can change periodic task	53	change_periodictask
    113	Can delete periodic task	53	delete_periodictask
    114	Can view periodic task	53	view_periodictask
    115	Can add periodic tasks	54	add_periodictasks
    116	Can change periodic tasks	54	change_periodictasks
    117	Can delete periodic tasks	54	delete_periodictasks
    118	Can view periodic tasks	54	view_periodictasks
    119	Can add solar event	55	add_solarschedule
    120	Can change solar event	55	change_solarschedule
    121	Can delete solar event	55	delete_solarschedule
    122	Can view solar event	55	view_solarschedule
    123	Can add clocked	56	add_clockedschedule
    124	Can change clocked	56	change_clockedschedule
    125	Can delete clocked	56	delete_clockedschedule
    126	Can view clocked	56	view_clockedschedule
    127	Can add permission	57	add_permission
    128	Can change permission	57	change_permission
    129	Can delete permission	57	delete_permission
    130	Can view permission	57	view_permission
    131	Can add email template	58	add_emailtemplate
    132	Can change email template	58	change_emailtemplate
    133	Can delete email template	58	delete_emailtemplate
    134	Can view email template	58	view_emailtemplate
    135	Can add user	59	add_user
    136	Can change user	59	change_user
    137	Can delete user	59	delete_user
    138	Can view user	59	view_user
    139	Manage customers.	59	manage_users
    140	Manage staff.	59	manage_staff
    141	Impersonate user.	59	impersonate_user
    142	Can add address	60	add_address
    143	Can change address	60	change_address
    144	Can delete address	60	delete_address
    145	Can view address	60	view_address
    146	Can add customer note	61	add_customernote
    147	Can change customer note	61	change_customernote
    148	Can delete customer note	61	delete_customernote
    149	Can view customer note	61	view_customernote
    150	Can add customer event	62	add_customerevent
    151	Can change customer event	62	change_customerevent
    152	Can delete customer event	62	delete_customerevent
    153	Can view customer event	62	view_customerevent
    154	Can add staff notification recipient	63	add_staffnotificationrecipient
    155	Can change staff notification recipient	63	change_staffnotificationrecipient
    156	Can delete staff notification recipient	63	delete_staffnotificationrecipient
    157	Can view staff notification recipient	63	view_staffnotificationrecipient
    158	Can add group	64	add_group
    159	Can change group	64	change_group
    160	Can delete group	64	delete_group
    161	Can view group	64	view_group
    162	Can add voucher code	65	add_vouchercode
    163	Can change voucher code	65	change_vouchercode
    164	Can delete voucher code	65	delete_vouchercode
    165	Can view voucher code	65	view_vouchercode
    166	Can add checkout discount	66	add_checkoutdiscount
    167	Can change checkout discount	66	change_checkoutdiscount
    168	Can delete checkout discount	66	delete_checkoutdiscount
    169	Can view checkout discount	66	view_checkoutdiscount
    170	Can add promotion rule_ variants	67	add_promotionrule_variants
    171	Can change promotion rule_ variants	67	change_promotionrule_variants
    172	Can delete promotion rule_ variants	67	delete_promotionrule_variants
    173	Can view promotion rule_ variants	67	view_promotionrule_variants
    174	Can add gift card	68	add_giftcard
    175	Can change gift card	68	change_giftcard
    176	Can delete gift card	68	delete_giftcard
    177	Can view gift card	68	view_giftcard
    178	Manage gift cards.	68	manage_gift_card
    179	Can add gift card event	69	add_giftcardevent
    180	Can change gift card event	69	change_giftcardevent
    181	Can delete gift card event	69	delete_giftcardevent
    182	Can view gift card event	69	view_giftcardevent
    183	Can add gift card tag	70	add_giftcardtag
    184	Can change gift card tag	70	change_giftcardtag
    185	Can delete gift card tag	70	delete_giftcardtag
    186	Can view gift card tag	70	view_giftcardtag
    187	Can add category	71	add_category
    188	Can change category	71	change_category
    189	Can delete category	71	delete_category
    190	Can view category	71	view_category
    191	Can add product	72	add_product
    192	Can change product	72	change_product
    193	Can delete product	72	delete_product
    194	Can view product	72	view_product
    195	Manage products.	72	manage_products
    196	Can add product variant	73	add_productvariant
    197	Can change product variant	73	change_productvariant
    198	Can delete product variant	73	delete_productvariant
    199	Can view product variant	73	view_productvariant
    200	Can add product type	74	add_producttype
    201	Can change product type	74	change_producttype
    202	Can delete product type	74	delete_producttype
    203	Can view product type	74	view_producttype
    204	Manage product types and attributes.	74	manage_product_types_and_attributes
    205	Can add collection product	75	add_collectionproduct
    206	Can change collection product	75	change_collectionproduct
    207	Can delete collection product	75	delete_collectionproduct
    208	Can view collection product	75	view_collectionproduct
    209	Can add collection	76	add_collection
    210	Can change collection	76	change_collection
    211	Can delete collection	76	delete_collection
    212	Can view collection	76	view_collection
    213	Can add category translation	77	add_categorytranslation
    214	Can change category translation	77	change_categorytranslation
    215	Can delete category translation	77	delete_categorytranslation
    216	Can view category translation	77	view_categorytranslation
    217	Can add collection translation	78	add_collectiontranslation
    218	Can change collection translation	78	change_collectiontranslation
    219	Can delete collection translation	78	delete_collectiontranslation
    220	Can view collection translation	78	view_collectiontranslation
    221	Can add product translation	79	add_producttranslation
    222	Can change product translation	79	change_producttranslation
    223	Can delete product translation	79	delete_producttranslation
    224	Can view product translation	79	view_producttranslation
    225	Can add product variant translation	80	add_productvarianttranslation
    226	Can change product variant translation	80	change_productvarianttranslation
    227	Can delete product variant translation	80	delete_productvarianttranslation
    228	Can view product variant translation	80	view_productvarianttranslation
    229	Can add digital content	81	add_digitalcontent
    230	Can change digital content	81	change_digitalcontent
    231	Can delete digital content	81	delete_digitalcontent
    232	Can view digital content	81	view_digitalcontent
    233	Can add digital content url	82	add_digitalcontenturl
    234	Can change digital content url	82	change_digitalcontenturl
    235	Can delete digital content url	82	delete_digitalcontenturl
    236	Can view digital content url	82	view_digitalcontenturl
    237	Can add product variant channel listing	83	add_productvariantchannellisting
    238	Can change product variant channel listing	83	change_productvariantchannellisting
    239	Can delete product variant channel listing	83	delete_productvariantchannellisting
    240	Can view product variant channel listing	83	view_productvariantchannellisting
    241	Can add product channel listing	84	add_productchannellisting
    242	Can change product channel listing	84	change_productchannellisting
    243	Can delete product channel listing	84	delete_productchannellisting
    244	Can view product channel listing	84	view_productchannellisting
    245	Can add collection channel listing	85	add_collectionchannellisting
    246	Can change collection channel listing	85	change_collectionchannellisting
    247	Can delete collection channel listing	85	delete_collectionchannellisting
    248	Can view collection channel listing	85	view_collectionchannellisting
    249	Can add product media	86	add_productmedia
    250	Can change product media	86	change_productmedia
    251	Can delete product media	86	delete_productmedia
    252	Can view product media	86	view_productmedia
    253	Can add variant media	87	add_variantmedia
    254	Can change variant media	87	change_variantmedia
    255	Can delete variant media	87	delete_variantmedia
    256	Can view variant media	87	view_variantmedia
    257	Can add variant channel listing promotion rule	88	add_variantchannellistingpromotionrule
    258	Can change variant channel listing promotion rule	88	change_variantchannellistingpromotionrule
    259	Can delete variant channel listing promotion rule	88	delete_variantchannellistingpromotionrule
    260	Can view variant channel listing promotion rule	88	view_variantchannellistingpromotionrule
    261	Can add assigned variant attribute	89	add_assignedvariantattribute
    262	Can change assigned variant attribute	89	change_assignedvariantattribute
    263	Can delete assigned variant attribute	89	delete_assignedvariantattribute
    264	Can view assigned variant attribute	89	view_assignedvariantattribute
    265	Can add attribute	90	add_attribute
    266	Can change attribute	90	change_attribute
    267	Can delete attribute	90	delete_attribute
    268	Can view attribute	90	view_attribute
    269	Can add attribute value	91	add_attributevalue
    270	Can change attribute value	91	change_attributevalue
    271	Can delete attribute value	91	delete_attributevalue
    272	Can view attribute value	91	view_attributevalue
    273	Can add attribute variant	92	add_attributevariant
    274	Can change attribute variant	92	change_attributevariant
    275	Can delete attribute variant	92	delete_attributevariant
    276	Can view attribute variant	92	view_attributevariant
    277	Can add attribute product	93	add_attributeproduct
    278	Can change attribute product	93	change_attributeproduct
    279	Can delete attribute product	93	delete_attributeproduct
    280	Can view attribute product	93	view_attributeproduct
    281	Can add attribute page	94	add_attributepage
    282	Can change attribute page	94	change_attributepage
    283	Can delete attribute page	94	delete_attributepage
    284	Can view attribute page	94	view_attributepage
    285	Can add attribute value translation	95	add_attributevaluetranslation
    286	Can change attribute value translation	95	change_attributevaluetranslation
    287	Can delete attribute value translation	95	delete_attributevaluetranslation
    288	Can view attribute value translation	95	view_attributevaluetranslation
    289	Can add attribute translation	96	add_attributetranslation
    290	Can change attribute translation	96	change_attributetranslation
    291	Can delete attribute translation	96	delete_attributetranslation
    292	Can view attribute translation	96	view_attributetranslation
    293	Can add assigned product attribute value	97	add_assignedproductattributevalue
    294	Can change assigned product attribute value	97	change_assignedproductattributevalue
    295	Can delete assigned product attribute value	97	delete_assignedproductattributevalue
    296	Can view assigned product attribute value	97	view_assignedproductattributevalue
    297	Can add assigned variant attribute value	98	add_assignedvariantattributevalue
    298	Can change assigned variant attribute value	98	change_assignedvariantattributevalue
    299	Can delete assigned variant attribute value	98	delete_assignedvariantattributevalue
    300	Can view assigned variant attribute value	98	view_assignedvariantattributevalue
    301	Can add assigned page attribute value	99	add_assignedpageattributevalue
    302	Can change assigned page attribute value	99	change_assignedpageattributevalue
    303	Can delete assigned page attribute value	99	delete_assignedpageattributevalue
    304	Can view assigned page attribute value	99	view_assignedpageattributevalue
    305	Can add channel	100	add_channel
    306	Can change channel	100	change_channel
    307	Can delete channel	100	delete_channel
    308	Can view channel	100	view_channel
    309	Manage channels.	100	manage_channels
    310	Can add checkout	101	add_checkout
    311	Can change checkout	101	change_checkout
    312	Can delete checkout	101	delete_checkout
    313	Can view checkout	101	view_checkout
    314	Manage checkouts	101	manage_checkouts
    315	Handle checkouts	101	handle_checkouts
    316	Handle taxes	101	handle_taxes
    317	Manage taxes	101	manage_taxes
    318	Can add checkout line	102	add_checkoutline
    319	Can change checkout line	102	change_checkoutline
    320	Can delete checkout line	102	delete_checkoutline
    321	Can view checkout line	102	view_checkoutline
    322	Can add checkout metadata	103	add_checkoutmetadata
    323	Can change checkout metadata	103	change_checkoutmetadata
    324	Can delete checkout metadata	103	delete_checkoutmetadata
    325	Can view checkout metadata	103	view_checkoutmetadata
    326	Can add event delivery	104	add_eventdelivery
    327	Can change event delivery	104	change_eventdelivery
    328	Can delete event delivery	104	delete_eventdelivery
    329	Can view event delivery	104	view_eventdelivery
    330	Can add event payload	105	add_eventpayload
    331	Can change event payload	105	change_eventpayload
    332	Can delete event payload	105	delete_eventpayload
    333	Can view event payload	105	view_eventpayload
    334	Can add event delivery attempt	106	add_eventdeliveryattempt
    335	Can change event delivery attempt	106	change_eventdeliveryattempt
    336	Can delete event delivery attempt	106	delete_eventdeliveryattempt
    337	Can view event delivery attempt	106	view_eventdeliveryattempt
    338	Can add export file	107	add_exportfile
    339	Can change export file	107	change_exportfile
    340	Can delete export file	107	delete_exportfile
    341	Can view export file	107	view_exportfile
    342	Can add export event	108	add_exportevent
    343	Can change export event	108	change_exportevent
    344	Can delete export event	108	delete_exportevent
    345	Can view export event	108	view_exportevent
    346	Can add menu	109	add_menu
    347	Can change menu	109	change_menu
    348	Can delete menu	109	delete_menu
    349	Can view menu	109	view_menu
    350	Manage navigation.	109	manage_menus
    351	Can add menu item	110	add_menuitem
    352	Can change menu item	110	change_menuitem
    353	Can delete menu item	110	delete_menuitem
    354	Can view menu item	110	view_menuitem
    355	Can add menu item translation	111	add_menuitemtranslation
    356	Can change menu item translation	111	change_menuitemtranslation
    357	Can delete menu item translation	111	delete_menuitemtranslation
    358	Can view menu item translation	111	view_menuitemtranslation
    359	Can add order	112	add_order
    360	Can change order	112	change_order
    361	Can delete order	112	delete_order
    362	Can view order	112	view_order
    363	Manage orders.	112	manage_orders
    364	Manage orders import.	112	manage_orders_import
    365	Can add order line	113	add_orderline
    366	Can change order line	113	change_orderline
    367	Can delete order line	113	delete_orderline
    368	Can view order line	113	view_orderline
    369	Can add fulfillment	114	add_fulfillment
    370	Can change fulfillment	114	change_fulfillment
    371	Can delete fulfillment	114	delete_fulfillment
    372	Can view fulfillment	114	view_fulfillment
    373	Can add fulfillment line	115	add_fulfillmentline
    374	Can change fulfillment line	115	change_fulfillmentline
    375	Can delete fulfillment line	115	delete_fulfillmentline
    376	Can view fulfillment line	115	view_fulfillmentline
    377	Can add order event	116	add_orderevent
    378	Can change order event	116	change_orderevent
    379	Can delete order event	116	delete_orderevent
    380	Can view order event	116	view_orderevent
    381	Can add order granted refund	117	add_ordergrantedrefund
    382	Can change order granted refund	117	change_ordergrantedrefund
    383	Can delete order granted refund	117	delete_ordergrantedrefund
    384	Can view order granted refund	117	view_ordergrantedrefund
    385	Can add order granted refund line	118	add_ordergrantedrefundline
    386	Can change order granted refund line	118	change_ordergrantedrefundline
    387	Can delete order granted refund line	118	delete_ordergrantedrefundline
    388	Can view order granted refund line	118	view_ordergrantedrefundline
    389	Can add invoice	119	add_invoice
    390	Can change invoice	119	change_invoice
    391	Can delete invoice	119	delete_invoice
    392	Can view invoice	119	view_invoice
    393	Can add invoice event	120	add_invoiceevent
    394	Can change invoice event	120	change_invoiceevent
    395	Can delete invoice event	120	delete_invoiceevent
    396	Can view invoice event	120	view_invoiceevent
    397	Can add shipping method	121	add_shippingmethod
    398	Can change shipping method	121	change_shippingmethod
    399	Can delete shipping method	121	delete_shippingmethod
    400	Can view shipping method	121	view_shippingmethod
    401	Can add shipping method translation	122	add_shippingmethodtranslation
    402	Can change shipping method translation	122	change_shippingmethodtranslation
    403	Can delete shipping method translation	122	delete_shippingmethodtranslation
    404	Can view shipping method translation	122	view_shippingmethodtranslation
    405	Can add shipping zone	123	add_shippingzone
    406	Can change shipping zone	123	change_shippingzone
    407	Can delete shipping zone	123	delete_shippingzone
    408	Can view shipping zone	123	view_shippingzone
    409	Manage shipping.	123	manage_shipping
    410	Can add shipping method channel listing	124	add_shippingmethodchannellisting
    411	Can change shipping method channel listing	124	change_shippingmethodchannellisting
    412	Can delete shipping method channel listing	124	delete_shippingmethodchannellisting
    413	Can view shipping method channel listing	124	view_shippingmethodchannellisting
    414	Can add shipping method postal code rule	125	add_shippingmethodpostalcoderule
    415	Can change shipping method postal code rule	125	change_shippingmethodpostalcoderule
    416	Can delete shipping method postal code rule	125	delete_shippingmethodpostalcoderule
    417	Can view shipping method postal code rule	125	view_shippingmethodpostalcoderule
    418	Can add site settings	126	add_sitesettings
    419	Can change site settings	126	change_sitesettings
    420	Can delete site settings	126	delete_sitesettings
    421	Can view site settings	126	view_sitesettings
    422	Manage settings.	126	manage_settings
    423	Manage translations.	126	manage_translations
    424	Can add site settings translation	127	add_sitesettingstranslation
    425	Can change site settings translation	127	change_sitesettingstranslation
    426	Can delete site settings translation	127	delete_sitesettingstranslation
    427	Can view site settings translation	127	view_sitesettingstranslation
    428	Can add page	128	add_page
    429	Can change page	128	change_page
    430	Can delete page	128	delete_page
    431	Can view page	128	view_page
    432	Manage pages.	128	manage_pages
    433	Can add page translation	129	add_pagetranslation
    434	Can change page translation	129	change_pagetranslation
    435	Can delete page translation	129	delete_pagetranslation
    436	Can view page translation	129	view_pagetranslation
    437	Can add page type	130	add_pagetype
    438	Can change page type	130	change_pagetype
    439	Can delete page type	130	delete_pagetype
    440	Can view page type	130	view_pagetype
    441	Manage page types and attributes.	130	manage_page_types_and_attributes
    442	Can add transaction	131	add_transaction
    443	Can change transaction	131	change_transaction
    444	Can delete transaction	131	delete_transaction
    445	Can view transaction	131	view_transaction
    446	Can add payment	132	add_payment
    447	Can change payment	132	change_payment
    448	Can delete payment	132	delete_payment
    449	Can view payment	132	view_payment
    450	Handle payments	132	handle_payments
    451	Can add transaction item	133	add_transactionitem
    452	Can change transaction item	133	change_transactionitem
    453	Can delete transaction item	133	delete_transactionitem
    454	Can view transaction item	133	view_transactionitem
    455	Can add transaction event	134	add_transactionevent
    456	Can change transaction event	134	change_transactionevent
    457	Can delete transaction event	134	delete_transactionevent
    458	Can view transaction event	134	view_transactionevent
    459	Can add tax class	135	add_taxclass
    460	Can change tax class	135	change_taxclass
    461	Can delete tax class	135	delete_taxclass
    462	Can view tax class	135	view_taxclass
    463	Can add tax configuration	136	add_taxconfiguration
    464	Can change tax configuration	136	change_taxconfiguration
    465	Can delete tax configuration	136	delete_taxconfiguration
    466	Can view tax configuration	136	view_taxconfiguration
    467	Can add tax class country rate	137	add_taxclasscountryrate
    468	Can change tax class country rate	137	change_taxclasscountryrate
    469	Can delete tax class country rate	137	delete_taxclasscountryrate
    470	Can view tax class country rate	137	view_taxclasscountryrate
    471	Can add tax configuration per country	138	add_taxconfigurationpercountry
    472	Can change tax configuration per country	138	change_taxconfigurationpercountry
    473	Can delete tax configuration per country	138	delete_taxconfigurationpercountry
    474	Can view tax configuration per country	138	view_taxconfigurationpercountry
    475	Can add warehouse	139	add_warehouse
    476	Can change warehouse	139	change_warehouse
    477	Can delete warehouse	139	delete_warehouse
    478	Can view warehouse	139	view_warehouse
    479	Can add stock	140	add_stock
    480	Can change stock	140	change_stock
    481	Can delete stock	140	delete_stock
    482	Can view stock	140	view_stock
    483	Can add allocation	141	add_allocation
    484	Can change allocation	141	change_allocation
    485	Can delete allocation	141	delete_allocation
    486	Can view allocation	141	view_allocation
    487	Can add preorder allocation	142	add_preorderallocation
    488	Can change preorder allocation	142	change_preorderallocation
    489	Can delete preorder allocation	142	delete_preorderallocation
    490	Can view preorder allocation	142	view_preorderallocation
    491	Can add reservation	143	add_reservation
    492	Can change reservation	143	change_reservation
    493	Can delete reservation	143	delete_reservation
    494	Can view reservation	143	view_reservation
    495	Can add preorder reservation	144	add_preorderreservation
    496	Can change preorder reservation	144	change_preorderreservation
    497	Can delete preorder reservation	144	delete_preorderreservation
    498	Can view preorder reservation	144	view_preorderreservation
    499	Can add channel warehouse	145	add_channelwarehouse
    500	Can change channel warehouse	145	change_channelwarehouse
    501	Can delete channel warehouse	145	delete_channelwarehouse
    502	Can view channel warehouse	145	view_channelwarehouse
    503	Can add webhook	146	add_webhook
    504	Can change webhook	146	change_webhook
    505	Can delete webhook	146	delete_webhook
    506	Can view webhook	146	view_webhook
    507	Can add webhook event	147	add_webhookevent
    508	Can change webhook event	147	change_webhookevent
    509	Can delete webhook event	147	delete_webhookevent
    510	Can view webhook event	147	view_webhookevent
    511	Can add app	148	add_app
    512	Can change app	148	change_app
    513	Can delete app	148	delete_app
    514	Can view app	148	view_app
    515	Manage apps	148	manage_apps
    516	Manage observability	148	manage_observability
    517	Can add app token	149	add_apptoken
    518	Can change app token	149	change_apptoken
    519	Can delete app token	149	delete_apptoken
    520	Can view app token	149	view_apptoken
    521	Can add app installation	150	add_appinstallation
    522	Can change app installation	150	change_appinstallation
    523	Can delete app installation	150	delete_appinstallation
    524	Can view app installation	150	view_appinstallation
    525	Can add app extension	151	add_appextension
    526	Can change app extension	151	change_appextension
    527	Can delete app extension	151	delete_appextension
    528	Can view app extension	151	view_appextension
    529	Can add thumbnail	152	add_thumbnail
    530	Can change thumbnail	152	change_thumbnail
    531	Can delete thumbnail	152	delete_thumbnail
    532	Can view thumbnail	152	view_thumbnail
    533	Can add custom schedule	153	add_customschedule
    534	Can change custom schedule	153	change_customschedule
    535	Can delete custom schedule	153	delete_customschedule
    536	Can view custom schedule	153	view_customschedule
    537	Can add custom periodic task	154	add_customperiodictask
    538	Can change custom periodic task	154	change_customperiodictask
    539	Can delete custom periodic task	154	delete_customperiodictask
    540	Can view custom periodic task	154	view_customperiodictask
    \.


    --
    -- Data for Name: plugins_emailtemplate; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.plugins_emailtemplate (id, name, value, plugin_configuration_id) FROM stdin;
    \.


    --
    -- Data for Name: plugins_pluginconfiguration; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.plugins_pluginconfiguration (id, name, description, active, configuration, identifier, channel_id) FROM stdin;
    \.


    --
    -- Data for Name: product_category; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.product_category (id, name, slug, description, lft, rght, tree_id, level, parent_id, background_image, seo_description, seo_title, background_image_alt, metadata, private_metadata, description_plaintext, updated_at) FROM stdin;
    1	Default Category	default-category	null	0	0	0	0	\N		\N	\N		{}	{}		2024-05-20 11:16:06.234475+00
    25	Accessories	accessories	null	1	8	1	0	\N					{}	{}		2024-05-20 11:19:33.582799+00
    26	Audiobooks	audiobooks	null	2	3	1	1	25					{}	{}		2024-05-20 11:19:33.59667+00
    27	Apparel	apparel	null	1	28	2	0	\N					{}	{}		2024-05-20 11:19:33.606977+00
    28	Sneakers	sneakers	null	2	3	2	1	27					{}	{}		2024-05-20 11:19:33.621541+00
    29	Sweatshirts	sweatshirts	null	4	5	2	1	27					{}	{}		2024-05-20 11:19:33.635999+00
    33	Headware	headware	null	14	21	2	1	27					{}	{}		2024-05-20 11:19:33.648181+00
    35	Beanies	beanies	null	15	16	2	2	33					{}	{}		2024-05-20 11:19:33.661608+00
    36	Scarfs	scarfs	null	17	18	2	2	33					{}	{}		2024-05-20 11:19:33.675323+00
    37	Sunglasses	sunglasses	null	19	20	2	2	33					{}	{}		2024-05-20 11:19:33.689573+00
    38	Shirts	shirts	null	22	27	2	1	27					{}	{}		2024-05-20 11:19:33.703149+00
    39	T-shirts	t-shirts	null	23	24	2	2	38					{}	{}		2024-05-20 11:19:33.716541+00
    40	Polo shirts	polo-shirts-2	null	25	26	2	2	38					{}	{}		2024-05-20 11:19:33.728199+00
    41	Homewares	homewares	{"time": 1652606793760, "blocks": [{"id": "ckre1-oB3I", "data": {"text": "Everything a programmer's comfort requires&nbsp;"}, "type": "paragraph"}], "version": "2.22.2"}	4	5	1	1	25					{}	{}	Everything a programmer's comfort requires&nbsp;	2024-05-20 11:19:33.738412+00
    42	Groceries	groceries	null	1	4	3	0	\N					{}	{}		2024-05-20 11:19:33.748867+00
    43	Juices	juices	null	2	3	3	1	42					{}	{}		2024-05-20 11:19:33.764345+00
    44	Gift cards	gift-cards	null	6	7	1	1	25					{}	{}		2024-05-20 11:19:33.777233+00
    \.


    --
    -- Data for Name: product_categorytranslation; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.product_categorytranslation (id, seo_title, seo_description, language_code, name, description, category_id) FROM stdin;
    \.


    --
    -- Data for Name: product_collection; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.product_collection (id, name, slug, background_image, seo_description, seo_title, description, background_image_alt, metadata, private_metadata) FROM stdin;
    4	Featured Products	featured-products				{"time": 1652704228241, "blocks": [{"id": "vSuHF7x1Ph", "data": {"text": "Team's favourites"}, "type": "paragraph"}], "version": "2.24.3"}		{}	{}
    5	Summer Picks	summer-picks				{"time": 1652704367895, "blocks": [{"id": "U2Pv1bCoAr", "data": {"text": "Get ready for the summer"}, "type": "paragraph"}], "version": "2.24.3"}		{}	{}
    \.


    --
    -- Data for Name: product_collectionchannellisting; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.product_collectionchannellisting (id, published_at, is_published, channel_id, collection_id) FROM stdin;
    7	2022-05-16 00:00:00+00	t	35	4
    8	2022-05-16 00:00:00+00	t	34	4
    9	2022-05-16 00:00:00+00	t	35	5
    10	2022-05-16 00:00:00+00	t	34	5
    \.


    --
    -- Data for Name: product_collectionproduct; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.product_collectionproduct (id, collection_id, product_id, sort_order) FROM stdin;
    9	4	150	\N
    10	4	134	\N
    11	4	127	\N
    12	5	128	\N
    13	5	136	\N
    14	5	144	\N
    15	4	161	\N
    17	5	161	\N
    \.


    --
    -- Data for Name: product_collectiontranslation; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.product_collectiontranslation (id, seo_title, seo_description, language_code, name, collection_id, description) FROM stdin;
    \.


    --
    -- Data for Name: product_digitalcontent; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.product_digitalcontent (id, use_default_settings, automatic_fulfillment, content_type, content_file, max_downloads, url_valid_days, product_variant_id, metadata, private_metadata) FROM stdin;
    \.


    --
    -- Data for Name: product_digitalcontenturl; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.product_digitalcontenturl (id, token, created_at, download_num, content_id, line_id) FROM stdin;
    \.


    --
    -- Data for Name: product_product; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.product_product (id, name, description, updated_at, product_type_id, category_id, seo_description, seo_title, weight, metadata, private_metadata, slug, default_variant_id, description_plaintext, rating, search_document, created_at, search_vector, search_index_dirty, tax_class_id, external_reference) FROM stdin;
    128	Blue Plimsolls	{"time": 1653426057314, "blocks": [{"id": "b8HYevCTpU", "data": {"text": "<b>Step into summer with Saleor.</b> Every time your head goes down, you see these beauties, and your mood bounces right back up."}, "type": "paragraph"}], "version": "2.22.2"}	2024-05-20 11:19:35.814529+00	18	28			0	{}	{}	blue-plimsolls	332	Step into summer with Saleor. Every time your head goes down, you see these beauties, and your mood bounces right back up.	0		2022-05-13 20:14:01.299+00	'40':26A,31B '41':28A,32B '42':30A,33B '818223582':25A '818223583':27A '818223584':29A 'and':18C 'back':23C 'beauties':17C 'blue':1A 'bounces':21C 'down':13C 'every':8C 'goes':12C 'head':11C 'into':4C 'mood':20C 'plimsolls':2A 'right':22C 'saleor':7C 'see':15C 'step':3C 'summer':5C 'these':16C 'time':9C 'up':24C 'with':6C 'you':14C 'your':10C,19C	f	\N	\N
    129	Dash Force	{"time": 1653426379418, "blocks": [{"id": "N0VISDl8_2", "data": {"text": "<b>Step into summer with the right balance.</b>&nbsp;Every time your head goes down, you see these beauties, and your mood bounces right back up."}, "type": "paragraph"}], "version": "2.22.2"}	2024-05-20 11:19:36.076665+00	18	28			0	{}	{}	dash-force	335	Step into summer with the right balance.&nbsp;Every time your head goes down, you see these beauties, and your mood bounces right back up.	0		2022-05-13 20:44:05.403+00	'39':28A,37B '40':30A,38B '41':32A,39B '42':34A,40B '43':36A,41B '618223581':27A '618223582':29A '618223583':31A '618223584':33A '618223585':35A 'and':20C 'back':25C 'balance':9C 'beauties':19C 'bounces':23C 'dash':1A 'down':15C 'every':10C 'force':2A 'goes':14C 'head':13C 'into':4C 'mood':22C 'right':8C,24C 'see':17C 'step':3C 'summer':5C 'the':7C 'these':18C 'time':11C 'up':26C 'with':6C 'you':16C 'your':12C,21C	f	\N	\N
    131	Grey Hoodie	null	2024-05-20 11:19:36.900402+00	19	29			0	{}	{}	grey-hoodie	345		0		2022-05-13 21:07:45.009+00	'cotton':3B 'grey':1A 'hoodie':2A 'uhjvzhvjdfzhcmlhbnq6mzq1':4A	f	\N	\N
    132	Blue Hoodie	null	2024-05-20 11:19:37.006197+00	19	29			0	{}	{}	blue-hoodie	346		0		2022-05-13 21:11:28.525+00	'blue':1A 'hoodie':2A 'polyester':3B 'uhjvzhvjdfzhcmlhbnq6mzq2':4A	f	\N	\N
    133	White Hoodie	null	2024-05-20 11:19:37.076167+00	19	29			0	{}	{}	white-hoodie	347		0		2022-05-13 21:13:28.944+00	'cotton':3B 'hoodie':2A 'uhjvzhvjdfzhcmlhbnq6mzq3':4A 'white':1A	f	\N	\N
    137	Blue Polygon Shirt	{"time": 1653425319677, "blocks": [{"id": "sMEIn2NR8s", "data": {"text": "<b>Ever have those days where you feel a bit geometric?</b> Can't quite shape yourself up right? Show your different sides with a Saleor styles."}, "type": "paragraph"}], "version": "2.22.2"}	2024-05-20 11:19:38.268735+00	20	39			0	{}	{}	blue-polygon-shirt	361	Ever have those days where you feel a bit geometric? Can't quite shape yourself up right? Show your different sides with a Saleor styles.	0		2022-05-13 21:41:46.295+00	'218223580':30A '218223581':32A '218223582':34A 'a':11C,26C 'bit':12C 'blue':1A 'can':14C 'cotton':29B 'days':7C 'different':23C 'ever':4C 'feel':10C 'geometric':13C 'have':5C 'l':33A,37B 'm':31A,36B 'polygon':2A 'quite':16C 'right':20C 'saleor':27C 'shape':17C 'shirt':3A 'show':21C 'sides':24C 'styles':28C 't':15C 'those':6C 'up':19C 'where':8C 'with':25C 'xl':35A,38B 'you':9C 'your':22C 'yourself':18C	f	\N	\N
    157	Reversed Monotype Tee	{"time": 1653425264795, "blocks": [{"id": "CMRIgvbpUG", "data": {"text": "Wondering if this will look as good on you as it does on the screen? The answer is yes. A quality Monospace Tee variant art with smart styling."}, "type": "paragraph"}], "version": "2.22.2"}	2024-05-20 11:19:40.432868+00	20	39			0	{}	{}	reversed-monotype-tee	389	Wondering if this will look as good on you as it does on the screen? The answer is yes. A quality Monospace Tee variant art with smart styling.	0		2022-05-17 11:48:18.537+00	'9182235820':32A '9182235821':34A 'a':23C 'answer':20C 'art':28C 'as':9C,13C 'does':15C 'good':10C 'if':5C 'is':21C 'it':14C 'look':8C 'monospace':25C 'monotype':2A 'on':11C,16C 'quality':24C 'reversed':1A 'screen':18C 'smart':30C 'styling':31C 'tee':3A,26C 'the':17C,19C 'this':6C 'variant':27C 'will':7C 'with':29C 'wondering':4C 'xl':33A,36B 'xxl':35A,37B 'yes':22C 'you':12C	f	\N	\N
    138	Dark Polygon Tee	{"time": 1653425300293, "blocks": [{"id": "DBlOMRDzk_", "data": {"text": "<b>Ever have those days where you feel a bit geometric?</b> Can't quite shape yourself up right? Show your different sides with a Saleor styles."}, "type": "paragraph"}], "version": "2.22.2"}	2024-05-20 11:19:38.533781+00	20	39			0	{}	{}	dark-polygon-tee	364	Ever have those days where you feel a bit geometric? Can't quite shape yourself up right? Show your different sides with a Saleor styles.	0		2022-05-13 21:44:02.972+00	'112223580':30A '112223581':32A '112223582':34A 'a':11C,26C 'bit':12C 'can':14C 'cotton':29B 'dark':1A 'days':7C 'different':23C 'ever':4C 'feel':10C 'geometric':13C 'have':5C 'l':35A,38B 'm':33A,37B 'polygon':2A 'quite':16C 'right':20C 's':31A,36B 'saleor':27C 'shape':17C 'show':21C 'sides':24C 'styles':28C 't':15C 'tee':3A 'those':6C 'up':19C 'where':8C 'with':25C 'you':9C 'your':22C 'yourself':18C	f	\N	\N
    160	Gift card 100	{"time": 1652788779629, "blocks": [{"id": "x5bGwCbYOX", "data": {"text": "Gift card to use in the shop."}, "type": "paragraph"}], "version": "2.24.3"}	2024-05-20 11:19:40.602373+00	24	44			0	{}	{}	gift-card	393	Gift card to use in the shop.	0		2022-05-17 11:57:19.204+00	'100':3A 'card':2A,5C 'gift':1A,4C 'in':8C 'shop':10C 'the':9C 'to':6C 'uhjvzhvjdfzhcmlhbnq6mzkz':11A 'use':7C	f	\N	\N
    135	Team Shirt	{"time": 1653425391562, "blocks": [{"id": "fMdfe0Bfpe", "data": {"text": "<b>One style fits all.</b> Get a look that works even when you are taking it easy. Relaxed wear for the fans."}, "type": "paragraph"}], "version": "2.22.2"}	2024-05-20 11:19:37.55882+00	20	39			0	{}	{}	team-shirt	353	One style fits all. Get a look that works even when you are taking it easy. Relaxed wear for the fans.	0		2022-05-13 21:29:38.009+00	'128223580':25A '128223581':27A '128223582':29A '128223583':31A '128223584':33A 'a':8C 'all':6C 'are':15C 'easy':18C 'elastane':24B 'even':12C 'fans':23C 'fits':5C 'for':21C 'get':7C 'it':17C 'l':30A,37B 'look':9C 'm':28A,36B 'one':3C 'relaxed':19C 's':26A,35B 'shirt':2A 'style':4C 'taking':16C 'team':1A 'that':10C 'the':22C 'wear':20C 'when':13C 'works':11C 'xl':32A,38B 'xxl':34A,39B 'you':14C	f	\N	\N
    126	Headless + Omnichannel in a pill	{"time": 1652952009724, "blocks": [{"id": "32SKrcyWwb", "data": {"text": "Launch <b>new markets fast</b>"}, "type": "paragraph"}], "version": "2.22.2"}	2024-05-20 11:19:35.156805+00	17	26	Launch new markets fast	Headless + Omnichannel	0	{}	{}	headless-omnichannel-commerce	324	Launch new markets fast	0		2022-05-12 22:07:58.327+00	'a':4A 'audio':11B 'digital':10B 'fast':9C 'headless':1A,13A 'headless-omnichannel-mp3':12A 'in':3A 'launch':6C 'markets':8C 'mp3':15A,16A,17B 'new':7C 'omnichannel':2A,14A 'pill':5A	f	\N	\N
    145	Battle-tested at brands like Lush	{"time": 1652811542659, "blocks": [{"id": "g2sLxZcLZa", "data": {"text": "Scale <b>effortlessly</b>"}, "type": "paragraph"}], "version": "2.22.2"}	2024-05-20 11:19:39.055245+00	17	26			0	{}	{}	battle-tested-at-brands-like-lush	372	Scale effortlessly	0		2022-05-14 21:53:34.556+00	'9018223582':10A '9018223583':12A '9018223584':14A 'at':4A 'battle':2A 'battle-tested':1A 'brands':5A 'dvd':11A,16B 'effortlessly':9C 'itunes':13A,17B 'like':6A 'lush':7A 'mp3':15A,18B 'scale':8C 'tested':3A	f	\N	\N
    164	Gift card 50	null	2024-05-20 11:19:41.304907+00	24	44			0	{}	{}	gift-card-50	401		0		2022-05-18 19:31:14.463+00	'50':3A 'card':2A 'gift':1A 'uhjvzhvjdfzhcmlhbnq6ndax':4A	f	\N	\N
    136	Darko Polo	{"time": 1653425959030, "blocks": [{"id": "Bw6qwwACo6", "data": {"text": "<b>Ever have those days where you feel a bit geometric?</b>&nbsp;Can't quite shape yourself up right? Show your different sides with a Saleor styles."}, "type": "paragraph"}], "version": "2.22.2"}	2024-05-20 11:19:38.02659+00	20	40			0	{}	{}	darko-polo	358	Ever have those days where you feel a bit geometric?&nbsp;Can't quite shape yourself up right? Show your different sides with a Saleor styles.	0		2022-05-13 21:37:35.753+00	'111223580':29A '111223581':31A '111223582':33A 'a':10C,25C 'bit':11C 'can':13C 'cotton':28B 'darko':1A 'days':6C 'different':22C 'ever':3C 'feel':9C 'geometric':12C 'have':4C 'm':32A,36B 'polo':2A 'quite':15C 'right':19C 's':30A,35B 'saleor':26C 'shape':16C 'show':20C 'sides':23C 'styles':27C 't':14C 'those':5C 'up':18C 'where':7C 'with':24C 'xxl':34A,37B 'you':8C 'your':21C 'yourself':17C	f	\N	\N
    150	Mighty Mug	{"time": 1653425905079, "blocks": [{"id": "2sjPP8KzGf", "data": {"text": "<b>Tonight, my love, let us take fat brushes</b> and paint the skies with the shades of nebula tides. Best for the darkest, moody shades of the coffee you can brew."}, "type": "paragraph"}], "version": "2.22.2"}	2024-05-20 11:19:39.818551+00	22	41			0	{}	{}	mighty-mug	382	Tonight, my love, let us take fat brushes and paint the skies with the shades of nebula tides. Best for the darkest, moody shades of the coffee you can brew.	0		2022-05-15 09:28:13.067+00	'and':11C 'best':21C 'brew':32C 'brushes':10C 'can':31C 'coffee':29C 'darkest':24C 'fat':9C 'for':22C 'let':6C 'love':5C 'mighty':1A 'moody':25C 'mug':2A 'my':4C 'nebula':19C 'of':18C,27C 'paint':12C 'shades':17C,26C 'skies':14C 'take':8C 'the':13C,16C,23C,28C 'tides':20C 'tonight':3C 'uhjvzhvjdfzhcmlhbnq6mzgy':33A 'us':7C 'with':15C 'you':30C	f	\N	\N
    130	Paul's Balance 420	{"time": 1653426379418, "blocks": [{"id": "N0VISDl8_2", "data": {"text": "<b>Step into summer with the right balance.</b>&nbsp;Every time your head goes down, you see these beauties, and your mood bounces right back up."}, "type": "paragraph"}], "version": "2.22.2"}	2024-05-20 11:19:36.528712+00	18	28			0	{}	{}	balance-trail-720	340	Step into summer with the right balance.&nbsp;Every time your head goes down, you see these beauties, and your mood bounces right back up.	0		2022-05-13 20:50:54.123+00	'118223581':29A '118223582':31A '118223583':33A '118223584':35A '118223585':37A '39':30A,39B '40':32A,40B '41':34A,41B '42':36A,42B '420':4A '45':38A,43B 'and':22C 'back':27C 'balance':3A,11C 'beauties':21C 'bounces':25C 'down':17C 'every':12C 'goes':16C 'head':15C 'into':6C 'mood':24C 'paul':1A 'right':10C,26C 's':2A 'see':19C 'step':5C 'summer':7C 'the':9C 'these':20C 'time':13C 'up':28C 'with':8C 'you':18C 'your':14C,23C	f	\N	\N
    141	Pirate's Beanie	null	2024-05-20 11:19:38.801917+00	21	35			0	{}	{}	pirates-beanie	368		0		2022-05-13 23:50:16.297+00	'beanie':3A 'cotton':4B 'pirate':1A 's':2A 'uhjvzhvjdfzhcmlhbnq6mzy4':5A	f	\N	\N
    143	Neck Warmer	null	2024-05-20 11:19:38.885779+00	21	36			0	{}	{}	tactical-neck-warmer	370		0		2022-05-14 21:10:01.383+00	'neck':1A 'uhjvzhvjdfzhcmlhbnq6mzcw':4A 'warmer':2A 'wool':3B	f	\N	\N
    144	DRY Sunglasses	null	2024-05-20 11:19:38.969061+00	22	37			0	{}	{}	dry-sunglasses	371		0		2022-05-14 21:24:57.725+00	'dry':1A 'sunglasses':2A 'uhjvzhvjdfzhcmlhbnq6mzcx':3A	f	\N	\N
    151	The Dash Cushion	{"time": 1653425717989, "blocks": [{"id": "KL2jdkdLiu", "data": {"text": "Minimalist interiors need simple, sleek soft furnishings. Set your own trends with Saleor designs."}, "type": "paragraph"}], "version": "2.22.2"}	2024-05-20 11:19:39.897705+00	22	41			0	{}	{}	the-dash-cushion	383	Minimalist interiors need simple, sleek soft furnishings. Set your own trends with Saleor designs.	0		2022-05-15 09:32:27.163+00	'cushion':3A 'dash':2A 'designs':17C 'furnishings':10C 'interiors':5C 'minimalist':4C 'need':6C 'own':13C 'saleor':16C 'set':11C 'simple':7C 'sleek':8C 'soft':9C 'the':1A 'trends':14C 'uhjvzhvjdfzhcmlhbnq6mzgz':18A 'with':15C 'your':12C	f	\N	\N
    146	Enterprise Cloud + On-premises	{"time": 1652727780700, "blocks": [{"id": "w3x66nix3o", "data": {"text": "Open Source <b>without the DevOps</b>"}, "type": "paragraph"}], "version": "2.24.3"}	2024-05-20 11:19:39.313557+00	17	26			0	{}	{}	enterprise-cloud-on-premises-tales	375	Open Source without the DevOps	0		2022-05-15 09:03:06.009+00	'113223582':13A '113223583':15A '113223584':17A '113223585':19A 'cd':20A,24B 'cloud':2A 'devops':10C 'dvd':16A,22B 'enterprise':1A 'itunes':18A,23B 'on':4A 'on-premises':3A 'open':6C 'premises':5A 'publishing':12B 'saleor':11B 'source':7C 'the':9C 'vinyl':14A,21B 'without':8C	f	\N	\N
    147	Own your stack and data	{"time": 1652952066167, "blocks": [{"id": "KQt85UC1t1", "data": {"text": "Own your investment, <b>ditch vendor lock-in</b>"}, "type": "paragraph"}], "version": "2.22.2"}	2024-05-20 11:19:39.66241+00	17	26			0	{}	{}	own-your-stack-and-data	379	Own your investment, ditch vendor lock-in	0		2022-05-15 09:10:17.077+00	'124223581':16A '124223582':18A 'and':4A 'data':5A 'ditch':9C 'in':13C 'investment':8C 'itunes':17A,20B 'lock':12C 'lock-in':11C 'mp3':19A,21B 'own':1A,6C 'publishing':15B 'saleor':14B 'stack':3A 'vendor':10C 'your':2A,7C	f	\N	\N
    156	Monokai Dimmed Sunnies	null	2024-05-20 11:19:40.327562+00	22	37			0	{}	{}	monokai-dimmed-sunnies	388		0		2022-05-17 11:44:16.884+00	'dimmed':2A 'monokai':1A 'sunnies':3A 'uhjvzhvjdfzhcmlhbnq6mzg4':4A	f	\N	\N
    152	Apple Juice	{"time": 1653425438149, "blocks": [{"id": "rGR983yNVl", "data": {"text": "<b>Fell straight from the tree</b>, on to Newton’s head, then into the bottle. The autumn taste of English apples. Brought to you by gravity."}, "type": "paragraph"}], "version": "2.22.2"}	2024-05-20 11:19:39.974636+00	23	43			0	{}	{}	apple-juice	384	Fell straight from the tree, on to Newton’s head, then into the bottle. The autumn taste of English apples. Brought to you by gravity.	0		2022-05-16 16:19:50.88+00	'apple':1A,28B 'apples':22C 'autumn':18C 'bottle':16C 'brought':23C 'by':26C 'english':21C 'fell':3C 'from':5C 'gravity':27C 'head':12C 'into':14C 'juice':2A 'newton':10C 'of':20C 'on':8C 's':11C 'straight':4C 'taste':19C 'the':6C,15C,17C 'then':13C 'to':9C,24C 'tree':7C 'uhjvzhvjdfzhcmlhbnq6mzg0':29A 'you':25C	f	\N	\N
    127	White Plimsolls	{"time": 1653425999878, "blocks": [{"id": "zUV4oz05zN", "data": {"text": "<b>PE at school wouldn’t have been such a drag</b> with these on your feet. Slip on the style and stride tall with Saleor branded plimsolls. PE now stands for pretty elegant."}, "type": "paragraph"}], "version": "2.22.2"}	2024-05-20 11:19:35.261358+00	18	28	PE at school wouldn’t have been such a drag with these on your feet. Slip on the style and stride tall with Saleor branded plimsolls. PE now stands for pretty elegant shoes.	White Plimsolls	0	{}	{}	white-plimsolls	325	PE at school wouldn’t have been such a drag with these on your feet. Slip on the style and stride tall with Saleor branded plimsolls. PE now stands for pretty elegant.	0		2022-05-13 14:34:39.934+00	'39':36A,49B '40':38A,50B '41':40A,51B '42':42A,52B '43':44A,53B '44':46A,54B '45':48A,55B '918223582':35A '918223583':37A '918223584':39A '918223585':41A '918223586':43A '918223587':45A '918223588':47A 'a':11C 'and':22C 'at':4C 'been':9C 'branded':27C 'drag':12C 'elegant':34C 'feet':17C 'for':32C 'have':8C 'now':30C 'on':15C,19C 'pe':3C,29C 'plimsolls':2A,28C 'pretty':33C 'saleor':26C 'school':5C 'slip':18C 'stands':31C 'stride':23C 'style':21C 'such':10C 't':7C 'tall':24C 'the':20C 'these':14C 'white':1A 'with':13C,25C 'wouldn':6C 'your':16C	f	\N	\N
    163	Gift card 500	null	2024-05-20 11:19:41.183199+00	24	44			0	{}	{}	gift-card-500	400		0		2022-05-18 19:29:35.052+00	'500':3A 'card':2A 'gift':1A 'uhjvzhvjdfzhcmlhbnq6ndaw':4A	f	\N	\N
    134	Monospace Tee	{"time": 1653425587889, "blocks": [{"id": "HVJ8gMNIXY", "data": {"text": "<b>Your t-shirt is your second skin.</b> It’s the version of you that you show to the world. Wear the Monospace one that flows with your command line kung-fu moves!&nbsp;"}, "type": "paragraph"}], "version": "2.22.2"}	2024-05-20 11:19:37.152067+00	20	39			0	{}	{}	ascii-tee	348	Your t-shirt is your second skin. It’s the version of you that you show to the world. Wear the Monospace one that flows with your command line kung-fu moves!&nbsp;	0		2022-05-13 21:20:59.727+00	'328223580':38A '328223581':40A '328223582':42A '328223583':44A '328223584':46A 'command':31C 'cotton':37B 'flows':28C 'fu':35C 'is':7C 'it':11C 'kung':34C 'kung-fu':33C 'l':43A,50B 'line':32C 'm':41A,49B 'monospace':1A,25C 'moves':36C 'of':15C 'one':26C 's':12C,39A,48B 'second':9C 'shirt':6C 'show':19C 'skin':10C 't':5C 't-shirt':4C 'tee':2A 'that':17C,27C 'the':13C,21C,24C 'to':20C 'version':14C 'wear':23C 'with':29C 'world':22C 'xl':45A,51B 'xxl':47A,52B 'you':16C,18C 'your':3C,8C,30C	f	\N	\N
    153	Bean Juice	{"time": 1653425488999, "blocks": [{"id": "QHFEWEGvaq", "data": {"text": "<b>Bean there, drunk that!</b> The energy drink for the health-conscious. Brand new bean juice; from allotment to bottle in under 8 hours."}, "type": "paragraph"}], "version": "2.22.2"}	2024-05-20 11:19:40.039213+00	23	43			0	{}	{}	bean-juice	385	Bean there, drunk that! The energy drink for the health-conscious. Brand new bean juice; from allotment to bottle in under 8 hours.	0		2022-05-16 16:25:11.442+00	'8':25C 'allotment':20C 'bean':1A,3C,17C,27B 'bottle':22C 'brand':15C 'conscious':14C 'drink':9C 'drunk':5C 'energy':8C 'for':10C 'from':19C 'health':13C 'health-conscious':12C 'hours':26C 'in':23C 'juice':2A,18C 'new':16C 'that':6C 'the':7C,11C 'there':4C 'to':21C 'uhjvzhvjdfzhcmlhbnq6mzg1':28A 'under':24C	f	\N	\N
    154	Banana Juice	{"time": 1653425465674, "blocks": [{"id": "94R0GvrOck", "data": {"text": "<b>Build your protein the natural way</b>, with exotic banana juice made from ripe fruit and packed with all the goodness of the tropical sun."}, "type": "paragraph"}], "version": "2.22.2"}	2024-05-20 11:19:40.148185+00	23	43			0	{}	{}	banana-juice	386	Build your protein the natural way, with exotic banana juice made from ripe fruit and packed with all the goodness of the tropical sun.	0		2022-05-16 16:27:16.648+00	'all':20C 'and':17C 'banana':1A,11C,27B 'build':3C 'exotic':10C 'from':14C 'fruit':16C 'goodness':22C 'juice':2A,12C 'made':13C 'natural':7C 'of':23C 'packed':18C 'protein':5C 'ripe':15C 'sun':26C 'the':6C,21C,24C 'tropical':25C 'uhjvzhvjdfzhcmlhbnq6mzg2':28A 'way':8C 'with':9C,19C 'your':4C	f	\N	\N
    155	Carrot Juice	{"time": 1652790989820, "blocks": [{"id": "VWVrSI_Cza", "data": {"text": "Improve your eyesight the natural way with <b>100% pure, squeezed carrot juice</b>. The sweet, orange nectar of <i>Mother Earth</i>."}, "type": "paragraph"}], "version": "2.22.2"}	2024-05-20 11:19:40.232396+00	23	43			0	{}	{}	carrot-juice	387	Improve your eyesight the natural way with 100% pure, squeezed carrot juice. The sweet, orange nectar of Mother Earth.	0		2022-05-16 16:28:14.885+00	'100':10C 'carrot':1A,13C,22B 'earth':21C 'eyesight':5C 'improve':3C 'juice':2A,14C 'mother':20C 'natural':7C 'nectar':18C 'of':19C 'orange':17C 'pure':11C 'squeezed':12C 'sweet':16C 'the':6C,15C 'uhjvzhvjdfzhcmlhbnq6mzg3':23A 'way':8C 'with':9C 'your':4C	f	\N	\N
    161	Cubes Fountain Tee	{"time": 1653424009054, "blocks": [{"id": "0n5N0DE7BU", "data": {"text": "<b>There is life in outer space.</b> This vibrant light speed cubes brings life to any surface. Goes on easy and dries at light speed."}, "type": "paragraph"}], "version": "2.22.2"}	2024-05-20 11:19:40.686661+00	20	39			0	{}	{}	cubes-fountain-tee	394	There is life in outer space. This vibrant light speed cubes brings life to any surface. Goes on easy and dries at light speed.	0		2022-05-17 12:02:44.85+00	'49182235820':29A '49182235821':31A '49182235822':33A '49182235823':35A '49182235824':37A 'and':23C 'any':18C 'at':25C 'brings':15C 'cotton':28B 'cubes':1A,14C 'dries':24C 'easy':22C 'fountain':2A 'goes':20C 'in':7C 'is':5C 'l':34A,41B 'life':6C,16C 'light':12C,26C 'm':32A,40B 'on':21C 'outer':8C 's':30A,39B 'space':9C 'speed':13C,27C 'surface':19C 'tee':3A 'there':4C 'this':10C 'to':17C 'vibrant':11C 'xl':36A,42B 'xxl':38A,43B	f	\N	\N
    162	White Parrot Cushion	{"time": 1652875592737, "blocks": [{"id": "46o78ZqlJ8", "data": {"text": "Minimalist interiors need simple, sleek soft furnishings. Don’t parrot what others do, set your own monochrome trends with Saleor designs."}, "type": "paragraph"}], "version": "2.22.2"}	2024-05-20 11:19:41.097761+00	22	41			0	{}	{}	white-parrot-cusion	399	Minimalist interiors need simple, sleek soft furnishings. Don’t parrot what others do, set your own monochrome trends with Saleor designs.	0		2022-05-18 12:06:53.986+00	'cushion':3A 'designs':24C 'do':16C 'don':11C 'furnishings':10C 'interiors':5C 'minimalist':4C 'monochrome':20C 'need':6C 'others':15C 'own':19C 'parrot':2A,13C 'saleor':23C 'set':17C 'simple':7C 'sleek':8C 'soft':9C 't':12C 'trends':21C 'uhjvzhvjdfzhcmlhbnq6mzk5':25A 'what':14C 'white':1A 'with':22C 'your':18C	f	\N	\N
    \.


    --
    -- Data for Name: product_productchannellisting; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.product_productchannellisting (id, published_at, is_published, channel_id, product_id, discounted_price_amount, currency, visible_in_listings, available_for_purchase_at, discounted_price_dirty) FROM stdin;
    120	2022-05-15 00:00:00+00	t	35	150	29.990	PLN	t	2022-05-15 09:28:13.277+00	f
    121	2022-05-15 00:00:00+00	t	34	150	11.990	USD	t	2022-05-15 09:28:13.293+00	f
    122	2022-05-15 00:00:00+00	t	35	151	70.000	PLN	t	2022-05-16 16:38:36.08+00	f
    139	2022-05-17 00:00:00+00	t	34	161	30.000	USD	t	2022-05-17 12:04:24.101+00	f
    142	2022-05-18 00:00:00+00	t	35	163	2300.000	PLN	t	2022-05-18 19:29:47.375+00	f
    93	2022-05-13 00:00:00+00	t	34	135	40.000	USD	t	2022-05-13 21:31:26.426+00	f
    94	2022-05-13 00:00:00+00	t	35	136	150.000	PLN	t	2022-05-13 21:39:11.647+00	f
    95	2022-05-13 00:00:00+00	t	34	136	45.000	USD	t	2022-05-13 21:39:11.656+00	f
    96	2022-05-13 00:00:00+00	t	35	137	135.000	PLN	t	2022-05-13 21:42:58.688+00	f
    97	2022-05-13 00:00:00+00	t	34	137	40.500	USD	t	2022-05-13 21:42:58.694+00	f
    98	2022-05-13 00:00:00+00	t	35	138	150.000	PLN	t	2022-05-13 21:45:11.183+00	f
    99	2022-05-13 00:00:00+00	t	34	138	45.000	USD	t	2022-05-13 21:45:11.191+00	f
    104	2022-05-14 00:00:00+00	t	35	141	45.000	PLN	t	2022-05-14 21:33:36.864+00	f
    105	2022-05-14 00:00:00+00	t	34	141	9.000	USD	t	2022-05-14 21:33:36.876+00	f
    108	2022-05-14 00:00:00+00	t	35	143	81.000	PLN	t	2022-05-14 21:33:04.609+00	f
    109	2022-05-14 00:00:00+00	t	34	143	18.000	USD	t	2022-05-14 21:33:04.615+00	f
    110	2022-05-14 00:00:00+00	t	35	144	60.000	PLN	t	2022-05-14 21:25:09.403+00	f
    123	2022-05-15 00:00:00+00	t	34	151	18.000	USD	t	2022-05-16 16:38:36.086+00	f
    124	2022-05-16 00:00:00+00	t	35	152	5.990	PLN	t	2022-05-18 12:21:41.061+00	f
    125	2022-05-16 00:00:00+00	t	34	152	1.990	USD	t	2022-05-18 12:21:41.066+00	f
    126	2022-05-16 00:00:00+00	t	35	153	5.990	PLN	t	2022-05-16 16:25:11.675+00	f
    127	2022-05-16 00:00:00+00	t	34	153	1.990	USD	t	2022-05-16 16:25:11.691+00	f
    128	2022-05-16 00:00:00+00	t	35	154	5.990	PLN	t	2022-05-16 16:27:16.884+00	f
    129	2022-05-16 00:00:00+00	t	34	154	1.990	USD	t	2022-05-16 16:27:16.897+00	f
    143	2022-05-18 00:00:00+00	t	34	163	500.000	USD	t	2022-05-18 19:29:47.387+00	f
    144	2022-05-18 00:00:00+00	t	35	164	230.000	PLN	t	2022-05-18 19:31:14.637+00	f
    145	2022-05-18 00:00:00+00	t	34	164	50.000	USD	t	2022-05-18 19:31:14.662+00	f
    74	2022-05-13 00:00:00+00	t	35	126	36.000	PLN	f	2022-05-12 22:28:54.347+00	f
    75	2022-05-13 00:00:00+00	t	34	126	9.000	USD	t	2022-05-12 00:00:00+00	f
    82	2022-05-13 00:00:00+00	t	35	130	209.960	PLN	t	2022-05-13 20:58:06.889+00	f
    83	2022-05-13 00:00:00+00	t	34	130	50.000	USD	t	2022-05-13 20:58:06.895+00	f
    84	2022-05-13 00:00:00+00	t	35	131	100.000	PLN	t	2022-05-13 21:10:34.318+00	f
    85	2022-05-13 00:00:00+00	t	34	131	30.000	USD	t	2022-05-13 21:10:34.327+00	f
    86	2022-05-13 00:00:00+00	t	35	132	120.000	PLN	t	2022-05-16 16:40:43.4+00	f
    87	2022-05-13 00:00:00+00	t	34	132	35.000	USD	t	2022-05-16 16:40:43.412+00	f
    111	2022-05-14 00:00:00+00	t	34	144	15.000	USD	t	2022-05-14 21:25:09.408+00	f
    112	2022-05-14 00:00:00+00	t	35	145	45.000	PLN	f	2022-05-14 21:56:09.039+00	f
    130	2022-05-16 00:00:00+00	t	35	155	5.990	PLN	t	2022-05-17 12:36:31.769+00	f
    131	2022-05-16 00:00:00+00	t	34	155	1.990	USD	t	2022-05-17 12:36:31.775+00	f
    113	2022-05-14 00:00:00+00	t	34	145	10.000	USD	t	2022-05-14 21:56:09.046+00	f
    114	2022-05-15 00:00:00+00	t	35	146	29.990	PLN	t	2022-05-15 09:07:27.049+00	f
    115	2022-05-15 00:00:00+00	t	34	146	8.990	USD	t	2022-05-18 12:09:56.745+00	f
    140	2022-05-18 00:00:00+00	t	35	162	138.000	PLN	t	2022-05-18 12:07:50.177+00	f
    141	2022-05-18 00:00:00+00	t	34	162	30.000	USD	t	2022-05-18 12:07:50.182+00	f
    132	2022-05-17 00:00:00+00	t	35	156	90.000	PLN	t	2022-05-17 11:44:17.092+00	f
    88	2022-05-13 00:00:00+00	t	35	133	120.000	PLN	t	2022-05-13 21:14:28.706+00	f
    89	2022-05-13 00:00:00+00	t	34	133	35.000	USD	t	2022-05-13 21:14:28.718+00	f
    90	2022-05-13 00:00:00+00	t	35	134	90.000	PLN	t	2022-05-13 21:22:42.287+00	f
    91	2022-05-13 00:00:00+00	t	34	134	20.000	USD	t	2022-05-13 21:22:42.298+00	f
    92	2022-05-13 00:00:00+00	t	35	135	200.000	PLN	t	2022-05-13 21:31:26.409+00	f
    133	2022-05-17 00:00:00+00	t	34	156	17.000	USD	t	2022-05-17 11:44:17.105+00	f
    134	2022-05-17 00:00:00+00	t	35	157	120.000	PLN	t	2022-05-17 11:50:42.404+00	f
    135	2022-05-17 00:00:00+00	t	34	157	25.000	USD	t	2022-05-17 11:50:42.416+00	f
    76	2022-05-13 00:00:00+00	t	35	127	144.000	PLN	t	2022-05-13 00:00:00+00	f
    77	2022-05-13 00:00:00+00	t	34	127	48.000	USD	t	2022-05-13 00:00:00+00	f
    138	2022-05-17 00:00:00+00	t	35	161	130.000	PLN	t	2022-05-17 12:04:24.093+00	f
    78	2022-05-13 00:00:00+00	t	35	128	161.000	PLN	t	2022-05-13 20:39:54.804+00	f
    79	2022-05-13 00:00:00+00	t	34	128	52.500	USD	t	2022-05-13 20:39:54.813+00	f
    80	2022-05-13 00:00:00+00	t	35	129	294.000	PLN	t	2022-05-13 20:47:19.212+00	f
    81	2022-05-13 00:00:00+00	t	34	129	63.000	USD	t	2022-05-13 20:47:19.242+00	f
    116	2022-05-15 00:00:00+00	t	35	147	4.990	PLN	t	2022-05-15 09:21:45.107+00	f
    117	2022-05-15 00:00:00+00	t	34	147	1.000	USD	t	2022-05-15 09:21:45.111+00	f
    136	2022-05-17 00:00:00+00	t	35	160	225.000	PLN	t	2022-05-18 19:30:32.863+00	f
    137	2022-05-17 00:00:00+00	t	34	160	50.000	USD	t	2022-05-18 19:30:32.87+00	f
    \.


    --
    -- Data for Name: product_productmedia; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.product_productmedia (id, sort_order, image, alt, type, external_url, oembed_data, product_id, to_remove, metadata, private_metadata) FROM stdin;
    1	0	products/saleor-headless-omnichannel-book.png		IMAGE	\N	{}	126	f	{}	{}
    2	0	products/saleor-white-plimsolls-1.png		IMAGE	\N	{}	127	f	{}	{}
    3	1	products/saleor-white-plimsolls-2.png		IMAGE	\N	{}	127	f	{}	{}
    4	2	products/saleor-white-plimsolls-3.png		IMAGE	\N	{}	127	f	{}	{}
    5	3	products/saleor-white-plimsolls-4.png		IMAGE	\N	{}	127	f	{}	{}
    6	0	products/saleor-blue-plimsolls-1.png		IMAGE	\N	{}	128	f	{}	{}
    7	1	products/saleor-blue-plimsolls-2.png		IMAGE	\N	{}	128	f	{}	{}
    8	2	products/saleor-blue-plimsolls-3.png		IMAGE	\N	{}	128	f	{}	{}
    9	3	products/saleor-blue-plimsolls-4.png		IMAGE	\N	{}	128	f	{}	{}
    10	0	products/saleor-dash-force-1.png		IMAGE	\N	{}	129	f	{}	{}
    11	1	products/saleor-dash-force-2.png		IMAGE	\N	{}	129	f	{}	{}
    12	0	products/saleor-pauls-blanace-420-1.png		IMAGE	\N	{}	130	f	{}	{}
    13	1	products/saleor-pauls-blanace-420-2.png		IMAGE	\N	{}	130	f	{}	{}
    14	0	products/saleor-grey-hoodie.png		IMAGE	\N	{}	131	f	{}	{}
    15	0	products/saleor-blue-hoodie.png		IMAGE	\N	{}	132	f	{}	{}
    16	0	products/saleor-white-hoodie.png		IMAGE	\N	{}	133	f	{}	{}
    17	0	products/saleor-ascii-shirt-front.png		IMAGE	\N	{}	134	f	{}	{}
    18	1	products/saleor-ascii-shirt-back.png		IMAGE	\N	{}	134	f	{}	{}
    19	0	products/saleor-team-tee-front.png		IMAGE	\N	{}	135	f	{}	{}
    20	1	products/saleor-team-tee-front_sSFhwed.png		IMAGE	\N	{}	135	f	{}	{}
    21	0	products/saleor-polo-shirt-front.png		IMAGE	\N	{}	136	f	{}	{}
    22	1	products/saleor-polo-shirt-back.png		IMAGE	\N	{}	136	f	{}	{}
    23	0	products/saleor-blue-polygon-tee-front.png		IMAGE	\N	{}	137	f	{}	{}
    24	1	products/saleor-blue-polygon-tee-back.png		IMAGE	\N	{}	137	f	{}	{}
    25	0	products/saleor-dark-polygon-tee-front.png		IMAGE	\N	{}	138	f	{}	{}
    26	1	products/saleor-dark-polygon-tee-back.png		IMAGE	\N	{}	138	f	{}	{}
    27	0	products/saleor-beanie-1.png		IMAGE	\N	{}	141	f	{}	{}
    28	1	products/saleor-beanie-2.png		IMAGE	\N	{}	141	f	{}	{}
    29	0	products/saleor-neck-warmer.png		IMAGE	\N	{}	143	f	{}	{}
    30	0	products/saleor-sunnies.png		IMAGE	\N	{}	144	f	{}	{}
    31	0	products/saleor-battle-tested-book.png		IMAGE	\N	{}	145	f	{}	{}
    32	0	products/saleor-enterprise-cloud-book.png		IMAGE	\N	{}	146	f	{}	{}
    33	0	products/saleor-own-your-stack-and-data-book.png		IMAGE	\N	{}	147	f	{}	{}
    34	0	products/saleor-mighty-mug.png		IMAGE	\N	{}	150	f	{}	{}
    35	0	products/saleor-cushion-blue.png		IMAGE	\N	{}	151	f	{}	{}
    36	0	products/saleor-apple-drink.png		IMAGE	\N	{}	152	f	{}	{}
    37	0	products/saleor-bean-drink.png		IMAGE	\N	{}	153	f	{}	{}
    38	0	products/saleor-banana-drink.png		IMAGE	\N	{}	154	f	{}	{}
    39	0	products/saleor-carrot-drink.png		IMAGE	\N	{}	155	f	{}	{}
    40	0	products/saleor-sunnies-dark.png		IMAGE	\N	{}	156	f	{}	{}
    41	0	products/saleor-monospace-white-tee-front.png		IMAGE	\N	{}	157	f	{}	{}
    42	1	products/saleor-monospace-white-tee-back.png		IMAGE	\N	{}	157	f	{}	{}
    43	0	products/saleor-gift-100.png		IMAGE	\N	{}	160	f	{}	{}
    44	0	products/saleor-white-cubes-tee-front.png		IMAGE	\N	{}	161	f	{}	{}
    45	1	products/saleor-white-cubes-tee-back.png		IMAGE	\N	{}	161	f	{}	{}
    46	0	products/saleor-white-parrot-cushion.png		IMAGE	\N	{}	162	f	{}	{}
    47	0	products/saleor-gift-500.png		IMAGE	\N	{}	163	f	{}	{}
    48	0	products/saleor-gift-50.png		IMAGE	\N	{}	164	f	{}	{}
    \.


    --
    -- Data for Name: product_producttranslation; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.product_producttranslation (id, seo_title, seo_description, language_code, name, description, product_id) FROM stdin;
    \.


    --
    -- Data for Name: product_producttype; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.product_producttype (id, name, has_variants, is_shipping_required, weight, is_digital, metadata, private_metadata, slug, kind, tax_class_id) FROM stdin;
    1	Default Type	f	t	0	f	{}	{}	default-type	normal	\N
    17	Audiobook	t	f	0	f	{}	{}	audiobook	normal	\N
    18	Shoe	t	t	1000	f	{}	{}	shoe	normal	\N
    19	Sweatshirt	f	t	1000	f	{}	{}	sweatshirt	normal	\N
    20	Top	t	t	1000	f	{}	{}	shirt	normal	\N
    21	Beanies & Scarfs	f	t	1000	f	{}	{}	beanie	normal	\N
    22	Simple	f	f	0	f	{}	{}	simple	normal	\N
    23	Juice	f	t	100	f	{}	{}	juice	normal	\N
    24	Simple Gift Card	f	f	0	f	{}	{}	gift-card	gift_card	\N
    \.


    --
    -- Data for Name: product_productvariant; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.product_productvariant (id, sku, name, product_id, track_inventory, weight, metadata, private_metadata, sort_order, is_preorder, preorder_end_date, preorder_global_threshold, quantity_limit_per_customer, created_at, updated_at, external_reference) FROM stdin;
    325	918223582	39	127	t	0	{}	{}	0	f	\N	\N	\N	2022-05-13 15:01:07.152+00	2024-05-20 11:19:35.247848+00	\N
    326	918223583	40	127	t	1000	{}	{}	1	f	\N	\N	\N	2022-05-13 19:52:24.369+00	2024-05-20 11:19:35.330449+00	\N
    327	918223584	41	127	t	0	{}	{}	2	f	\N	\N	\N	2022-05-13 19:53:03.367+00	2024-05-20 11:19:35.427928+00	\N
    328	918223585	42	127	t	0	{}	{}	3	f	\N	\N	\N	2022-05-13 19:53:28.144+00	2024-05-20 11:19:35.510862+00	\N
    329	918223586	43	127	t	0	{}	{}	4	f	\N	\N	\N	2022-05-13 19:53:52.354+00	2024-05-20 11:19:35.582834+00	\N
    330	918223587	44	127	t	0	{}	{}	5	f	\N	\N	\N	2022-05-13 19:55:25.701+00	2024-05-20 11:19:35.66436+00	\N
    331	918223588	45	127	t	0	{}	{}	6	f	\N	\N	\N	2022-05-13 20:06:43.538+00	2024-05-20 11:19:35.727433+00	\N
    332	818223583	41	128	t	0	{}	{}	1	f	\N	\N	\N	2022-05-13 20:39:26.112+00	2024-05-20 11:19:35.803357+00	\N
    333	818223582	40	128	t	0	{}	{}	0	f	\N	\N	\N	2022-05-13 20:39:26.216+00	2024-05-20 11:19:35.891424+00	\N
    334	818223584	42	128	t	0	{}	{}	2	f	\N	\N	\N	2022-05-13 20:39:26.254+00	2024-05-20 11:19:35.975251+00	\N
    335	618223581	39	129	t	0	{}	{}	0	f	\N	\N	\N	2022-05-13 20:47:03.499+00	2024-05-20 11:19:36.065777+00	\N
    336	618223582	40	129	t	0	{}	{}	1	f	\N	\N	\N	2022-05-13 20:47:03.655+00	2024-05-20 11:19:36.165158+00	\N
    337	618223583	41	129	t	0	{}	{}	2	f	\N	\N	\N	2022-05-13 20:47:03.705+00	2024-05-20 11:19:36.255947+00	\N
    338	618223584	42	129	t	0	{}	{}	3	f	\N	\N	\N	2022-05-13 20:47:03.738+00	2024-05-20 11:19:36.341891+00	\N
    339	618223585	43	129	t	0	{}	{}	4	f	\N	\N	\N	2022-05-13 20:47:03.809+00	2024-05-20 11:19:36.439977+00	\N
    340	118223581	39	130	t	0	{}	{}	0	f	\N	\N	\N	2022-05-13 20:57:45.685+00	2024-05-20 11:19:36.52032+00	\N
    341	118223582	40	130	t	0	{}	{}	1	f	\N	\N	\N	2022-05-13 20:57:45.785+00	2024-05-20 11:19:36.602428+00	\N
    342	118223583	41	130	t	0	{}	{}	2	f	\N	\N	\N	2022-05-13 20:57:45.826+00	2024-05-20 11:19:36.675713+00	\N
    343	118223584	42	130	t	0	{}	{}	3	f	\N	\N	\N	2022-05-13 20:57:45.861+00	2024-05-20 11:19:36.755621+00	\N
    344	118223585	45	130	t	0	{}	{}	4	f	\N	\N	\N	2022-05-13 20:57:45.887+00	2024-05-20 11:19:36.826959+00	\N
    345	\N	UHJvZHVjdFZhcmlhbnQ6MzQ1	131	f	0	{}	{}	0	f	\N	\N	\N	2022-05-13 21:07:45.439+00	2024-05-20 11:19:36.891366+00	\N
    346	\N	UHJvZHVjdFZhcmlhbnQ6MzQ2	132	f	0	{}	{}	0	f	\N	\N	\N	2022-05-13 21:11:28.927+00	2024-05-20 11:19:36.996749+00	\N
    347	\N	UHJvZHVjdFZhcmlhbnQ6MzQ3	133	f	0	{}	{}	0	f	\N	\N	\N	2022-05-13 21:13:29.305+00	2024-05-20 11:19:37.069436+00	\N
    348	328223580	S	134	t	0	{}	{}	0	f	\N	\N	\N	2022-05-13 21:22:25.536+00	2024-05-20 11:19:37.144226+00	\N
    349	328223581	M	134	t	0	{}	{}	1	f	\N	\N	\N	2022-05-13 21:22:25.647+00	2024-05-20 11:19:37.245497+00	\N
    350	328223582	L	134	t	0	{}	{}	2	f	\N	\N	\N	2022-05-13 21:22:25.7+00	2024-05-20 11:19:37.309797+00	\N
    351	328223583	XL	134	t	0	{}	{}	3	f	\N	\N	\N	2022-05-13 21:22:25.736+00	2024-05-20 11:19:37.402821+00	\N
    352	328223584	XXL	134	t	0	{}	{}	4	f	\N	\N	\N	2022-05-13 21:22:25.789+00	2024-05-20 11:19:37.464231+00	\N
    353	128223580	S	135	t	0	{}	{}	0	f	\N	\N	\N	2022-05-13 21:30:50.614+00	2024-05-20 11:19:37.550681+00	\N
    354	128223581	M	135	t	0	{}	{}	1	f	\N	\N	\N	2022-05-13 21:30:50.694+00	2024-05-20 11:19:37.626242+00	\N
    355	128223582	L	135	t	0	{}	{}	2	f	\N	\N	\N	2022-05-13 21:30:50.756+00	2024-05-20 11:19:37.720466+00	\N
    357	128223584	XXL	135	t	0	{}	{}	4	f	\N	\N	\N	2022-05-13 21:30:50.889+00	2024-05-20 11:19:37.919513+00	\N
    359	111223581	M	136	t	0	{}	{}	1	f	\N	\N	\N	2022-05-13 21:38:56.373+00	2024-05-20 11:19:38.111+00	\N
    360	111223582	XXL	136	t	0	{}	{}	2	f	\N	\N	\N	2022-05-13 21:38:56.422+00	2024-05-20 11:19:38.175519+00	\N
    361	218223580	M	137	t	0	{}	{}	0	f	\N	\N	\N	2022-05-13 21:42:43.229+00	2024-05-20 11:19:38.258202+00	\N
    362	218223581	L	137	t	0	{}	{}	1	f	\N	\N	\N	2022-05-13 21:42:43.314+00	2024-05-20 11:19:38.346104+00	\N
    363	218223582	XL	137	t	0	{}	{}	2	f	\N	\N	\N	2022-05-13 21:42:43.351+00	2024-05-20 11:19:38.418569+00	\N
    365	112223581	M	138	t	0	{}	{}	1	f	\N	\N	\N	2022-05-13 21:44:58.258+00	2024-05-20 11:19:38.593541+00	\N
    366	112223582	L	138	t	0	{}	{}	2	f	\N	\N	\N	2022-05-13 21:44:58.304+00	2024-05-20 11:19:38.684264+00	\N
    368	\N	UHJvZHVjdFZhcmlhbnQ6MzY4	141	f	0	{}	{}	0	f	\N	\N	\N	2022-05-13 23:50:16.869+00	2024-05-20 11:19:38.791061+00	\N
    370	\N	UHJvZHVjdFZhcmlhbnQ6Mzcw	143	f	0	{}	{}	0	f	\N	\N	\N	2022-05-14 21:10:01.587+00	2024-05-20 11:19:38.877629+00	\N
    371	\N	UHJvZHVjdFZhcmlhbnQ6Mzcx	144	f	0	{}	{}	0	f	\N	\N	\N	2022-05-14 21:24:57.904+00	2024-05-20 11:19:38.960843+00	\N
    372	9018223582	DVD	145	t	0	{}	{}	0	f	\N	\N	\N	2022-05-14 21:55:45.91+00	2024-05-20 11:19:39.046023+00	\N
    373	9018223583	iTunes	145	t	0	{}	{}	1	f	\N	\N	\N	2022-05-14 21:55:45.95+00	2024-05-20 11:19:39.129855+00	\N
    374	9018223584	MP3	145	t	0	{}	{}	2	f	\N	\N	\N	2022-05-14 21:55:45.983+00	2024-05-20 11:19:39.21743+00	\N
    375	113223582	Vinyl	146	t	0	{}	{}	0	f	\N	\N	\N	2022-05-15 09:05:27.383+00	2024-05-20 11:19:39.306055+00	\N
    376	113223583	DVD	146	t	0	{}	{}	1	f	\N	\N	\N	2022-05-15 09:05:27.43+00	2024-05-20 11:19:39.401572+00	\N
    377	113223584	iTunes	146	t	0	{}	{}	2	f	\N	\N	\N	2022-05-15 09:05:27.476+00	2024-05-20 11:19:39.482273+00	\N
    378	113223585	CD	146	t	0	{}	{}	3	f	\N	\N	\N	2022-05-15 09:05:27.531+00	2024-05-20 11:19:39.565449+00	\N
    379	124223581	iTunes	147	t	0	{}	{}	0	f	\N	\N	\N	2022-05-15 09:21:06.168+00	2024-05-20 11:19:39.650743+00	\N
    380	124223582	MP3	147	t	0	{}	{}	1	f	\N	\N	\N	2022-05-15 09:21:06.197+00	2024-05-20 11:19:39.730552+00	\N
    382	\N	UHJvZHVjdFZhcmlhbnQ6Mzgy	150	f	0	{}	{}	0	f	\N	\N	\N	2022-05-15 09:28:13.324+00	2024-05-20 11:19:39.810673+00	\N
    383	\N	UHJvZHVjdFZhcmlhbnQ6Mzgz	151	f	0	{}	{}	0	f	\N	\N	\N	2022-05-15 09:32:27.397+00	2024-05-20 11:19:39.888814+00	\N
    384	\N	UHJvZHVjdFZhcmlhbnQ6Mzg0	152	f	0	{}	{}	0	f	\N	\N	\N	2022-05-16 16:19:51.191+00	2024-05-20 11:19:39.967207+00	\N
    385	\N	UHJvZHVjdFZhcmlhbnQ6Mzg1	153	f	0	{}	{}	0	f	\N	\N	\N	2022-05-16 16:25:11.701+00	2024-05-20 11:19:40.031486+00	\N
    386	\N	UHJvZHVjdFZhcmlhbnQ6Mzg2	154	f	0	{}	{}	0	f	\N	\N	\N	2022-05-16 16:27:16.9+00	2024-05-20 11:19:40.108377+00	\N
    387	\N	UHJvZHVjdFZhcmlhbnQ6Mzg3	155	f	0	{}	{}	0	f	\N	\N	\N	2022-05-16 16:28:15.149+00	2024-05-20 11:19:40.223618+00	\N
    388	\N	UHJvZHVjdFZhcmlhbnQ6Mzg4	156	f	0	{}	{}	0	f	\N	\N	\N	2022-05-17 11:44:17.115+00	2024-05-20 11:19:40.318763+00	\N
    389	9182235820	XL	157	t	0	{}	{}	0	f	\N	\N	\N	2022-05-17 11:50:09.662+00	2024-05-20 11:19:40.420315+00	\N
    390	9182235821	XXL	157	t	0	{}	{}	1	f	\N	\N	\N	2022-05-17 11:50:09.704+00	2024-05-20 11:19:40.512768+00	\N
    394	49182235820	S	161	t	0	{}	{}	0	f	\N	\N	\N	2022-05-17 12:03:59.123+00	2024-05-20 11:19:40.677169+00	\N
    395	49182235821	M	161	t	0	{}	{}	1	f	\N	\N	\N	2022-05-17 12:03:59.193+00	2024-05-20 11:19:40.781986+00	\N
    396	49182235822	L	161	t	0	{}	{}	2	f	\N	\N	\N	2022-05-17 12:03:59.262+00	2024-05-20 11:19:40.867683+00	\N
    397	49182235823	XL	161	t	0	{}	{}	3	f	\N	\N	\N	2022-05-17 12:03:59.329+00	2024-05-20 11:19:40.948675+00	\N
    398	49182235824	XXL	161	t	0	{}	{}	4	f	\N	\N	\N	2022-05-17 12:03:59.4+00	2024-05-20 11:19:41.016358+00	\N
    364	112223580	S	138	t	0	{}	{}	0	t	2024-05-30 11:19:55.755935+00	10	\N	2022-05-13 21:44:58.194+00	2024-05-20 11:19:55.756182+00	\N
    324	headless-omnichannel-mp3	MP3	126	t	0	{}	{}	0	f	\N	\N	\N	2022-05-12 22:09:40.752+00	2024-05-20 11:19:35.144177+00	\N
    356	128223583	XL	135	t	0	{}	{}	3	f	\N	\N	\N	2022-05-13 21:30:50.795+00	2024-05-20 11:19:37.825758+00	\N
    393	\N	UHJvZHVjdFZhcmlhbnQ6Mzkz	160	f	0	{}	{}	0	f	\N	\N	\N	2022-05-17 11:57:19.386+00	2024-05-20 11:19:40.596228+00	\N
    399	\N	UHJvZHVjdFZhcmlhbnQ6Mzk5	162	f	0	{}	{}	0	f	\N	\N	\N	2022-05-18 12:06:54.246+00	2024-05-20 11:19:41.091249+00	\N
    400	\N	UHJvZHVjdFZhcmlhbnQ6NDAw	163	f	0	{}	{}	0	f	\N	\N	\N	2022-05-18 19:29:35.277+00	2024-05-20 11:19:41.172607+00	\N
    401	\N	UHJvZHVjdFZhcmlhbnQ6NDAx	164	f	0	{}	{}	0	f	\N	\N	\N	2022-05-18 19:31:14.677+00	2024-05-20 11:19:41.265999+00	\N
    358	111223580	S	136	t	0	{}	{}	0	t	2024-05-30 11:19:55.715663+00	10	\N	2022-05-13 21:38:56.282+00	2024-05-20 11:19:55.715915+00	\N
    \.


    --
    -- Data for Name: product_productvariantchannellisting; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.product_productvariantchannellisting (id, currency, price_amount, channel_id, variant_id, cost_price_amount, preorder_quantity_threshold, discounted_price_amount) FROM stdin;
    224	PLN	40.000	35	324	\N	\N	40.000
    225	USD	10.000	34	324	\N	\N	10.000
    246	PLN	420.000	35	335	\N	\N	420.000
    247	USD	90.000	34	335	\N	\N	90.000
    250	PLN	420.000	35	337	\N	\N	420.000
    251	USD	90.000	34	337	\N	\N	90.000
    252	PLN	420.000	35	338	\N	\N	420.000
    253	USD	90.000	34	338	\N	\N	90.000
    254	PLN	420.000	35	339	\N	\N	420.000
    255	USD	90.000	34	339	\N	\N	90.000
    256	PLN	209.960	35	340	\N	\N	209.960
    257	USD	50.000	34	340	\N	\N	50.000
    258	PLN	209.960	35	341	\N	\N	209.960
    259	USD	50.000	34	341	\N	\N	50.000
    262	PLN	209.960	35	343	\N	\N	209.960
    263	USD	50.000	34	343	\N	\N	50.000
    264	PLN	209.960	35	344	\N	\N	209.960
    265	USD	50.000	34	344	\N	\N	50.000
    266	PLN	100.000	35	345	\N	\N	100.000
    267	USD	30.000	34	345	\N	\N	30.000
    268	PLN	120.000	35	346	\N	\N	120.000
    269	USD	35.000	34	346	\N	\N	35.000
    270	PLN	120.000	35	347	\N	\N	120.000
    271	USD	35.000	34	347	\N	\N	35.000
    282	PLN	200.000	35	353	\N	\N	200.000
    283	USD	40.000	34	353	\N	\N	40.000
    284	PLN	200.000	35	354	\N	\N	200.000
    285	USD	40.000	34	354	\N	\N	40.000
    286	PLN	200.000	35	355	\N	\N	200.000
    287	USD	40.000	34	355	\N	\N	40.000
    290	PLN	200.000	35	357	\N	\N	200.000
    291	USD	40.000	34	357	\N	\N	40.000
    298	PLN	150.000	35	361	\N	\N	150.000
    299	USD	45.000	34	361	\N	\N	45.000
    300	PLN	150.000	35	362	\N	\N	150.000
    301	USD	45.000	34	362	\N	\N	45.000
    302	PLN	150.000	35	363	\N	\N	150.000
    303	USD	45.000	34	363	\N	\N	45.000
    304	PLN	150.000	35	364	\N	\N	150.000
    305	USD	45.000	34	364	\N	\N	45.000
    306	PLN	150.000	35	365	\N	\N	150.000
    307	USD	45.000	34	365	\N	\N	45.000
    308	PLN	150.000	35	366	\N	\N	150.000
    309	USD	45.000	34	366	\N	\N	45.000
    312	PLN	50.000	35	368	\N	\N	50.000
    313	USD	10.000	34	368	\N	\N	10.000
    316	PLN	90.000	35	370	\N	\N	90.000
    317	USD	20.000	34	370	\N	\N	20.000
    318	PLN	60.000	35	371	\N	\N	60.000
    319	USD	15.000	34	371	\N	\N	15.000
    326	PLN	29.990	35	375	\N	\N	29.990
    327	USD	8.990	34	375	\N	\N	8.990
    328	PLN	29.990	35	376	\N	\N	29.990
    329	USD	8.990	34	376	\N	\N	8.990
    330	PLN	29.990	35	377	\N	\N	29.990
    331	USD	8.990	34	377	\N	\N	8.990
    332	PLN	29.990	35	378	\N	\N	29.990
    333	USD	8.990	34	378	\N	\N	8.990
    338	PLN	29.990	35	382	\N	\N	29.990
    339	USD	11.990	34	382	\N	\N	11.990
    340	PLN	70.000	35	383	\N	\N	70.000
    341	USD	18.000	34	383	\N	\N	18.000
    342	PLN	5.990	35	384	\N	\N	5.990
    343	USD	1.990	34	384	\N	\N	1.990
    344	PLN	5.990	35	385	\N	\N	5.990
    345	USD	1.990	34	385	\N	\N	1.990
    348	PLN	5.990	35	387	\N	\N	5.990
    349	USD	1.990	34	387	\N	\N	1.990
    350	PLN	90.000	35	388	\N	\N	90.000
    352	PLN	120.000	35	389	\N	\N	120.000
    353	USD	25.000	34	389	\N	\N	25.000
    354	PLN	120.000	35	390	\N	\N	120.000
    355	USD	25.000	34	390	\N	\N	25.000
    358	PLN	130.000	35	394	\N	\N	130.000
    359	USD	30.000	34	394	\N	\N	30.000
    360	PLN	130.000	35	395	\N	\N	130.000
    361	USD	30.000	34	395	\N	\N	30.000
    362	PLN	130.000	35	396	\N	\N	130.000
    363	USD	30.000	34	396	\N	\N	30.000
    226	PLN	240.000	35	325	\N	\N	144.000
    227	USD	80.000	34	325	\N	\N	48.000
    228	PLN	240.000	35	326	\N	\N	144.000
    229	PLN	240.000	35	327	\N	\N	144.000
    230	PLN	240.000	35	328	\N	\N	144.000
    231	PLN	240.000	35	329	\N	\N	144.000
    232	PLN	240.000	35	330	\N	\N	144.000
    233	PLN	240.000	35	331	\N	\N	144.000
    234	USD	80.000	34	326	\N	\N	48.000
    235	USD	80.000	34	327	\N	\N	48.000
    236	USD	80.000	34	328	\N	\N	48.000
    237	USD	80.000	34	329	\N	\N	48.000
    238	USD	80.000	34	330	\N	\N	48.000
    239	USD	80.000	34	331	\N	\N	48.000
    240	PLN	230.000	35	332	\N	\N	161.000
    241	USD	75.000	34	332	\N	\N	52.500
    242	PLN	230.000	35	333	\N	\N	184.000
    243	USD	75.000	34	333	\N	\N	60.000
    244	PLN	230.000	35	334	\N	\N	184.000
    245	USD	75.000	34	334	\N	\N	60.000
    248	PLN	420.000	35	336	\N	\N	294.000
    249	USD	90.000	34	336	\N	\N	63.000
    260	PLN	209.960	35	342	\N	\N	209.960
    261	USD	50.000	34	342	\N	\N	50.000
    272	PLN	90.000	35	348	\N	\N	90.000
    273	USD	20.000	34	348	\N	\N	20.000
    274	PLN	90.000	35	349	\N	\N	90.000
    275	USD	20.000	34	349	\N	\N	20.000
    276	PLN	90.000	35	350	\N	\N	90.000
    277	USD	20.000	34	350	\N	\N	20.000
    278	PLN	90.000	35	351	\N	\N	90.000
    279	USD	20.000	34	351	\N	\N	20.000
    280	PLN	90.000	35	352	\N	\N	90.000
    281	USD	20.000	34	352	\N	\N	20.000
    288	PLN	200.000	35	356	\N	\N	200.000
    289	USD	40.000	34	356	\N	\N	40.000
    292	PLN	150.000	35	358	\N	\N	150.000
    293	USD	45.000	34	358	\N	\N	45.000
    294	PLN	150.000	35	359	\N	\N	150.000
    295	USD	45.000	34	359	\N	\N	45.000
    296	PLN	150.000	35	360	\N	\N	150.000
    297	USD	45.000	34	360	\N	\N	45.000
    320	PLN	45.000	35	372	\N	\N	45.000
    321	USD	10.000	34	372	\N	\N	10.000
    322	PLN	45.000	35	373	\N	\N	45.000
    323	USD	10.000	34	373	\N	\N	10.000
    324	PLN	45.000	35	374	\N	\N	45.000
    325	USD	10.000	34	374	\N	\N	10.000
    346	PLN	5.990	35	386	\N	\N	5.990
    347	USD	1.990	34	386	\N	\N	1.990
    351	USD	17.000	34	388	\N	\N	17.000
    364	PLN	130.000	35	397	\N	\N	130.000
    365	USD	30.000	34	397	\N	\N	30.000
    366	PLN	130.000	35	398	\N	\N	130.000
    367	USD	30.000	34	398	\N	\N	30.000
    370	PLN	2300.000	35	400	\N	\N	2300.000
    371	USD	500.000	34	400	\N	\N	500.000
    372	PLN	230.000	35	401	\N	\N	230.000
    373	USD	50.000	34	401	\N	\N	50.000
    356	PLN	450.000	35	393	\N	\N	225.000
    357	USD	100.000	34	393	\N	\N	50.000
    334	PLN	9.990	35	379	\N	\N	4.990
    335	USD	2.000	34	379	\N	\N	1.000
    336	PLN	9.990	35	380	\N	\N	4.990
    337	USD	2.000	34	380	\N	\N	1.000
    368	PLN	230.000	35	399	\N	\N	138.000
    369	USD	50.000	34	399	\N	\N	30.000
    \.


    --
    -- Data for Name: product_productvarianttranslation; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.product_productvarianttranslation (id, language_code, name, product_variant_id) FROM stdin;
    \.


    --
    -- Data for Name: product_variantchannellistingpromotionrule; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.product_variantchannellistingpromotionrule (id, discount_amount, currency, promotion_rule_id, variant_channel_listing_id) FROM stdin;
    15	75.000	PLN	0114c879-f9ef-4edc-bd69-2438cef5e28a	292
    16	75.000	PLN	0114c879-f9ef-4edc-bd69-2438cef5e28a	294
    17	75.000	PLN	0114c879-f9ef-4edc-bd69-2438cef5e28a	296
    18	22.500	USD	0114c879-f9ef-4edc-bd69-2438cef5e28a	293
    19	22.500	USD	0114c879-f9ef-4edc-bd69-2438cef5e28a	295
    20	22.500	USD	0114c879-f9ef-4edc-bd69-2438cef5e28a	297
    21	22.500	PLN	f1ef4f5c-a8f5-4689-8079-137cfd2a356e	320
    22	22.500	PLN	f1ef4f5c-a8f5-4689-8079-137cfd2a356e	322
    23	22.500	PLN	f1ef4f5c-a8f5-4689-8079-137cfd2a356e	324
    24	5.000	USD	f1ef4f5c-a8f5-4689-8079-137cfd2a356e	321
    25	5.000	USD	f1ef4f5c-a8f5-4689-8079-137cfd2a356e	323
    26	5.000	USD	f1ef4f5c-a8f5-4689-8079-137cfd2a356e	325
    31	3.000	PLN	52f87276-5e4b-4b93-9ce6-5cd8a12bab4a	346
    32	1.000	USD	52f87276-5e4b-4b93-9ce6-5cd8a12bab4a	347
    33	65.000	PLN	a7f7e186-6f93-48ed-a6bd-244740020041	366
    34	15.000	USD	a7f7e186-6f93-48ed-a6bd-244740020041	367
    41	62.990	PLN	d44e9ccd-f7a4-4e3f-bf91-a90d6cad33ef	256
    42	62.990	PLN	d44e9ccd-f7a4-4e3f-bf91-a90d6cad33ef	258
    43	62.990	PLN	d44e9ccd-f7a4-4e3f-bf91-a90d6cad33ef	262
    44	62.990	PLN	d44e9ccd-f7a4-4e3f-bf91-a90d6cad33ef	264
    45	15.000	USD	d44e9ccd-f7a4-4e3f-bf91-a90d6cad33ef	257
    46	15.000	USD	d44e9ccd-f7a4-4e3f-bf91-a90d6cad33ef	259
    47	15.000	USD	d44e9ccd-f7a4-4e3f-bf91-a90d6cad33ef	263
    48	15.000	USD	d44e9ccd-f7a4-4e3f-bf91-a90d6cad33ef	265
    49	3.000	PLN	199c3e2d-33e1-45b1-ae88-5c926f644d10	332
    50	0.900	USD	199c3e2d-33e1-45b1-ae88-5c926f644d10	333
    51	27.000	PLN	d44e9ccd-f7a4-4e3f-bf91-a90d6cad33ef	350
    52	5.100	USD	d44e9ccd-f7a4-4e3f-bf91-a90d6cad33ef	351
    53	92.000	PLN	0316f829-f47c-4e1f-97d8-12c0a527d2fd	372
    54	20.000	USD	0316f829-f47c-4e1f-97d8-12c0a527d2fd	373
    1	104.980	PLN	a7f7e186-6f93-48ed-a6bd-244740020041	260
    2	25.000	USD	a7f7e186-6f93-48ed-a6bd-244740020041	261
    3	45.000	PLN	f1ef4f5c-a8f5-4689-8079-137cfd2a356e	272
    4	45.000	PLN	f1ef4f5c-a8f5-4689-8079-137cfd2a356e	274
    5	45.000	PLN	f1ef4f5c-a8f5-4689-8079-137cfd2a356e	276
    6	45.000	PLN	f1ef4f5c-a8f5-4689-8079-137cfd2a356e	278
    7	45.000	PLN	f1ef4f5c-a8f5-4689-8079-137cfd2a356e	280
    8	10.000	USD	f1ef4f5c-a8f5-4689-8079-137cfd2a356e	273
    9	10.000	USD	f1ef4f5c-a8f5-4689-8079-137cfd2a356e	275
    10	10.000	USD	f1ef4f5c-a8f5-4689-8079-137cfd2a356e	277
    11	10.000	USD	f1ef4f5c-a8f5-4689-8079-137cfd2a356e	279
    12	10.000	USD	f1ef4f5c-a8f5-4689-8079-137cfd2a356e	281
    13	100.000	PLN	52f87276-5e4b-4b93-9ce6-5cd8a12bab4a	288
    14	20.000	USD	52f87276-5e4b-4b93-9ce6-5cd8a12bab4a	289
    55	96.000	PLN	fd285e70-54cb-47e3-a051-5c344947d6c2	226
    56	96.000	PLN	fd285e70-54cb-47e3-a051-5c344947d6c2	228
    57	96.000	PLN	fd285e70-54cb-47e3-a051-5c344947d6c2	229
    58	96.000	PLN	fd285e70-54cb-47e3-a051-5c344947d6c2	230
    59	96.000	PLN	fd285e70-54cb-47e3-a051-5c344947d6c2	231
    60	96.000	PLN	fd285e70-54cb-47e3-a051-5c344947d6c2	232
    61	96.000	PLN	fd285e70-54cb-47e3-a051-5c344947d6c2	233
    62	32.000	USD	fd285e70-54cb-47e3-a051-5c344947d6c2	227
    63	32.000	USD	fd285e70-54cb-47e3-a051-5c344947d6c2	234
    64	32.000	USD	fd285e70-54cb-47e3-a051-5c344947d6c2	235
    65	32.000	USD	fd285e70-54cb-47e3-a051-5c344947d6c2	236
    66	32.000	USD	fd285e70-54cb-47e3-a051-5c344947d6c2	237
    67	32.000	USD	fd285e70-54cb-47e3-a051-5c344947d6c2	238
    68	32.000	USD	fd285e70-54cb-47e3-a051-5c344947d6c2	239
    69	69.000	PLN	75bd54a5-dec0-44b2-b7f4-cf271d2d7954	240
    70	22.500	USD	75bd54a5-dec0-44b2-b7f4-cf271d2d7954	241
    71	126.000	PLN	75bd54a5-dec0-44b2-b7f4-cf271d2d7954	248
    72	27.000	USD	75bd54a5-dec0-44b2-b7f4-cf271d2d7954	249
    73	225.000	PLN	117b4a28-a7d0-4bac-9b4c-b225fdb76b90	356
    74	50.000	USD	117b4a28-a7d0-4bac-9b4c-b225fdb76b90	357
    75	92.000	PLN	fd285e70-54cb-47e3-a051-5c344947d6c2	368
    76	20.000	USD	fd285e70-54cb-47e3-a051-5c344947d6c2	369
    27	5.000	PLN	0114c879-f9ef-4edc-bd69-2438cef5e28a	334
    28	5.000	PLN	0114c879-f9ef-4edc-bd69-2438cef5e28a	336
    29	1.000	USD	0114c879-f9ef-4edc-bd69-2438cef5e28a	335
    30	1.000	USD	0114c879-f9ef-4edc-bd69-2438cef5e28a	337
    36	46.000	PLN	251d79da-15aa-4c84-9d71-677dbe2f23cf	242
    37	46.000	PLN	251d79da-15aa-4c84-9d71-677dbe2f23cf	244
    39	15.000	USD	251d79da-15aa-4c84-9d71-677dbe2f23cf	243
    40	15.000	USD	251d79da-15aa-4c84-9d71-677dbe2f23cf	245
    \.


    --
    -- Data for Name: product_variantmedia; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.product_variantmedia (id, media_id, variant_id) FROM stdin;
    1	1	324
    2	2	325
    3	2	326
    4	2	327
    5	2	328
    6	2	329
    7	2	330
    8	2	331
    9	6	332
    10	6	333
    11	6	334
    12	10	335
    13	10	336
    14	10	337
    15	10	338
    16	10	339
    17	12	340
    18	12	341
    19	12	342
    20	12	343
    21	12	344
    22	14	345
    23	15	346
    24	16	347
    25	17	348
    26	17	349
    27	17	350
    28	17	351
    29	17	352
    30	19	353
    31	19	354
    32	19	355
    33	19	356
    34	19	357
    35	21	358
    36	21	359
    37	21	360
    38	23	361
    39	23	362
    40	23	363
    41	25	364
    42	25	365
    43	25	366
    44	27	368
    45	29	370
    46	30	371
    47	31	372
    48	31	373
    49	31	374
    50	32	375
    51	32	376
    52	32	377
    53	32	378
    54	33	379
    55	33	380
    56	34	382
    57	35	383
    58	36	384
    59	37	385
    60	38	386
    61	39	387
    62	40	388
    63	41	389
    64	41	390
    65	43	393
    66	44	394
    67	44	395
    68	44	396
    69	44	397
    70	44	398
    71	46	399
    72	47	400
    73	48	401
    \.


    --
    -- Data for Name: schedulers_customperiodictask; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.schedulers_customperiodictask (periodictask_ptr_id, custom_id) FROM stdin;
    \.


    --
    -- Data for Name: schedulers_customschedule; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.schedulers_customschedule (id, schedule_import_path) FROM stdin;
    \.


    --
    -- Data for Name: shipping_shippingmethod; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.shipping_shippingmethod (id, name, maximum_order_weight, minimum_order_weight, type, shipping_zone_id, metadata, private_metadata, maximum_delivery_days, minimum_delivery_days, description, tax_class_id) FROM stdin;
    1	Default	\N	0	price	1	{}	{}	\N	\N	null	\N
    2	DHL	\N	0	weight	2	{}	{}	\N	\N	null	\N
    3	UPS	\N	0	price	2	{}	{}	\N	\N	null	\N
    4	Registered priority	\N	0	weight	2	{}	{}	\N	\N	null	\N
    5	DB Schenker	\N	0	weight	2	{}	{}	\N	\N	null	\N
    6	FBA	\N	0	price	3	{}	{}	\N	\N	null	\N
    7	FedEx Express	\N	0	weight	3	{}	{}	\N	\N	null	\N
    8	Oceania Air Mail	\N	0	weight	3	{}	{}	\N	\N	null	\N
    9	China Post	\N	0	price	4	{}	{}	\N	\N	null	\N
    10	TNT	\N	0	price	4	{}	{}	\N	\N	null	\N
    11	Aramex	\N	0	price	4	{}	{}	\N	\N	null	\N
    12	EMS	\N	0	weight	4	{}	{}	\N	\N	null	\N
    13	DHL	\N	0	price	5	{}	{}	\N	\N	null	\N
    14	UPS	\N	0	price	5	{}	{}	\N	\N	null	\N
    15	FedEx	\N	0	weight	5	{}	{}	\N	\N	null	\N
    16	EMS	\N	0	price	5	{}	{}	\N	\N	null	\N
    17	Royale International	\N	0	price	6	{}	{}	\N	\N	null	\N
    18	ACE	\N	0	price	6	{}	{}	\N	\N	null	\N
    19	fastway couriers	\N	0	weight	6	{}	{}	\N	\N	null	\N
    20	Post Office	\N	0	price	6	{}	{}	\N	\N	null	\N
    21	DHL	\N	0	price	2	{}	{}	\N	\N	null	\N
    22	UPS	\N	0	weight	2	{}	{}	\N	\N	null	\N
    23	Registered priority	\N	0	weight	2	{}	{}	\N	\N	null	\N
    24	DB Schenker	\N	0	weight	2	{}	{}	\N	\N	null	\N
    25	FBA	\N	0	weight	3	{}	{}	\N	\N	null	\N
    26	FedEx Express	\N	0	weight	3	{}	{}	\N	\N	null	\N
    27	Oceania Air Mail	\N	0	weight	3	{}	{}	\N	\N	null	\N
    28	China Post	\N	0	weight	4	{}	{}	\N	\N	null	\N
    29	TNT	\N	0	price	4	{}	{}	\N	\N	null	\N
    30	Aramex	\N	0	weight	4	{}	{}	\N	\N	null	\N
    31	EMS	\N	0	price	4	{}	{}	\N	\N	null	\N
    32	DHL	\N	0	weight	5	{}	{}	\N	\N	null	\N
    33	UPS	\N	0	price	5	{}	{}	\N	\N	null	\N
    34	FedEx	\N	0	price	5	{}	{}	\N	\N	null	\N
    35	EMS	\N	0	price	5	{}	{}	\N	\N	null	\N
    36	Royale International	\N	0	price	6	{}	{}	\N	\N	null	\N
    37	ACE	\N	0	price	6	{}	{}	\N	\N	null	\N
    38	fastway couriers	\N	0	price	6	{}	{}	\N	\N	null	\N
    39	Post Office	\N	0	price	6	{}	{}	\N	\N	null	\N
    40	DHL	\N	0	weight	2	{}	{}	\N	\N	null	\N
    41	UPS	\N	0	weight	2	{}	{}	\N	\N	null	\N
    42	Registered priority	\N	0	price	2	{}	{}	\N	\N	null	\N
    43	DB Schenker	\N	0	weight	2	{}	{}	\N	\N	null	\N
    44	FBA	\N	0	weight	3	{}	{}	\N	\N	null	\N
    45	FedEx Express	\N	0	weight	3	{}	{}	\N	\N	null	\N
    46	Oceania Air Mail	\N	0	weight	3	{}	{}	\N	\N	null	\N
    47	China Post	\N	0	weight	4	{}	{}	\N	\N	null	\N
    48	TNT	\N	0	price	4	{}	{}	\N	\N	null	\N
    49	Aramex	\N	0	weight	4	{}	{}	\N	\N	null	\N
    50	EMS	\N	0	price	4	{}	{}	\N	\N	null	\N
    51	DHL	\N	0	weight	5	{}	{}	\N	\N	null	\N
    52	UPS	\N	0	weight	5	{}	{}	\N	\N	null	\N
    53	FedEx	\N	0	weight	5	{}	{}	\N	\N	null	\N
    54	EMS	\N	0	price	5	{}	{}	\N	\N	null	\N
    55	Royale International	\N	0	weight	6	{}	{}	\N	\N	null	\N
    56	ACE	\N	0	weight	6	{}	{}	\N	\N	null	\N
    57	fastway couriers	\N	0	weight	6	{}	{}	\N	\N	null	\N
    58	Post Office	\N	0	weight	6	{}	{}	\N	\N	null	\N
    \.


    --
    -- Data for Name: shipping_shippingmethod_excluded_products; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.shipping_shippingmethod_excluded_products (id, shippingmethod_id, product_id) FROM stdin;
    \.


    --
    -- Data for Name: shipping_shippingmethodchannellisting; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.shipping_shippingmethodchannellisting (id, minimum_order_price_amount, currency, maximum_order_price_amount, price_amount, channel_id, shipping_method_id) FROM stdin;
    1	0.000	USD	\N	0.000	1	1
    2	0.000	PLN	\N	66.040	35	2
    3	0.000	PLN	\N	87.640	35	3
    4	0.000	PLN	\N	75.930	35	4
    5	0.000	PLN	\N	82.420	35	5
    6	0.000	USD	\N	19.480	1	2
    7	0.000	USD	\N	92.410	1	3
    8	0.000	USD	\N	15.780	1	4
    9	0.000	USD	\N	15.650	1	5
    10	0.000	USD	\N	93.870	34	2
    11	0.000	USD	\N	78.400	34	3
    12	0.000	USD	\N	80.160	34	4
    13	0.000	USD	\N	9.750	34	5
    14	0.000	PLN	\N	35.130	35	6
    15	0.000	PLN	\N	93.320	35	7
    16	0.000	PLN	\N	87.110	35	8
    17	0.000	USD	\N	58.710	1	6
    18	0.000	USD	\N	48.410	1	7
    19	0.000	USD	\N	85.830	1	8
    20	0.000	USD	\N	98.940	34	6
    21	0.000	USD	\N	71.960	34	7
    22	0.000	USD	\N	59.340	34	8
    23	0.000	PLN	\N	23.200	35	9
    24	0.000	PLN	\N	94.710	35	10
    25	0.000	PLN	\N	12.200	35	11
    26	0.000	PLN	\N	18.680	35	12
    27	0.000	USD	\N	48.330	1	9
    28	0.000	USD	\N	96.940	1	10
    29	0.000	USD	\N	77.510	1	11
    30	0.000	USD	\N	59.170	1	12
    31	0.000	USD	\N	95.330	34	9
    32	0.000	USD	\N	4.130	34	10
    33	0.000	USD	\N	52.560	34	11
    34	0.000	USD	\N	1.230	34	12
    35	0.000	PLN	\N	9.890	35	13
    36	0.000	PLN	\N	10.130	35	14
    37	0.000	PLN	\N	99.160	35	15
    38	0.000	PLN	\N	15.100	35	16
    39	0.000	USD	\N	90.320	1	13
    40	0.000	USD	\N	17.300	1	14
    41	0.000	USD	\N	8.690	1	15
    42	0.000	USD	\N	14.130	1	16
    43	0.000	USD	\N	14.560	34	13
    44	0.000	USD	\N	20.870	34	14
    45	0.000	USD	\N	9.160	34	15
    46	0.000	USD	\N	34.570	34	16
    47	0.000	PLN	\N	92.300	35	17
    48	0.000	PLN	\N	22.580	35	18
    49	0.000	PLN	\N	41.970	35	19
    50	0.000	PLN	\N	20.760	35	20
    51	0.000	USD	\N	98.450	1	17
    52	0.000	USD	\N	64.280	1	18
    53	0.000	USD	\N	7.150	1	19
    54	0.000	USD	\N	8.420	1	20
    55	0.000	USD	\N	37.590	34	17
    56	0.000	USD	\N	45.990	34	18
    57	0.000	USD	\N	24.660	34	19
    58	0.000	USD	\N	10.930	34	20
    59	0.000	PLN	\N	66.040	35	21
    60	0.000	PLN	\N	87.640	35	22
    61	0.000	PLN	\N	75.930	35	23
    62	0.000	PLN	\N	82.420	35	24
    63	0.000	USD	\N	19.480	1	21
    64	0.000	USD	\N	92.410	1	22
    65	0.000	USD	\N	15.780	1	23
    66	0.000	USD	\N	15.650	1	24
    67	0.000	USD	\N	93.870	34	21
    68	0.000	USD	\N	78.400	34	22
    69	0.000	USD	\N	80.160	34	23
    70	0.000	USD	\N	9.750	34	24
    71	0.000	PLN	\N	35.130	35	25
    72	0.000	PLN	\N	93.320	35	26
    73	0.000	PLN	\N	87.110	35	27
    74	0.000	USD	\N	58.710	1	25
    75	0.000	USD	\N	48.410	1	26
    76	0.000	USD	\N	85.830	1	27
    77	0.000	USD	\N	98.940	34	25
    78	0.000	USD	\N	71.960	34	26
    79	0.000	USD	\N	59.340	34	27
    80	0.000	PLN	\N	23.200	35	28
    81	0.000	PLN	\N	94.710	35	29
    82	0.000	PLN	\N	12.200	35	30
    83	0.000	PLN	\N	18.680	35	31
    84	0.000	USD	\N	48.330	1	28
    85	0.000	USD	\N	96.940	1	29
    86	0.000	USD	\N	77.510	1	30
    87	0.000	USD	\N	59.170	1	31
    88	0.000	USD	\N	95.330	34	28
    89	0.000	USD	\N	4.130	34	29
    90	0.000	USD	\N	52.560	34	30
    91	0.000	USD	\N	1.230	34	31
    92	0.000	PLN	\N	9.890	35	32
    93	0.000	PLN	\N	10.130	35	33
    94	0.000	PLN	\N	99.160	35	34
    95	0.000	PLN	\N	15.100	35	35
    96	0.000	USD	\N	90.320	1	32
    97	0.000	USD	\N	17.300	1	33
    98	0.000	USD	\N	8.690	1	34
    99	0.000	USD	\N	14.130	1	35
    100	0.000	USD	\N	14.560	34	32
    101	0.000	USD	\N	20.870	34	33
    102	0.000	USD	\N	9.160	34	34
    103	0.000	USD	\N	34.570	34	35
    104	0.000	PLN	\N	92.300	35	36
    105	0.000	PLN	\N	22.580	35	37
    106	0.000	PLN	\N	41.970	35	38
    107	0.000	PLN	\N	20.760	35	39
    108	0.000	USD	\N	98.450	1	36
    109	0.000	USD	\N	64.280	1	37
    110	0.000	USD	\N	7.150	1	38
    111	0.000	USD	\N	8.420	1	39
    112	0.000	USD	\N	37.590	34	36
    113	0.000	USD	\N	45.990	34	37
    114	0.000	USD	\N	24.660	34	38
    115	0.000	USD	\N	10.930	34	39
    116	0.000	PLN	\N	66.040	35	40
    117	0.000	PLN	\N	87.640	35	41
    118	0.000	PLN	\N	75.930	35	42
    119	0.000	PLN	\N	82.420	35	43
    120	0.000	USD	\N	19.480	1	40
    121	0.000	USD	\N	92.410	1	41
    122	0.000	USD	\N	15.780	1	42
    123	0.000	USD	\N	15.650	1	43
    124	0.000	USD	\N	93.870	34	40
    125	0.000	USD	\N	78.400	34	41
    126	0.000	USD	\N	80.160	34	42
    127	0.000	USD	\N	9.750	34	43
    128	0.000	PLN	\N	35.130	35	44
    129	0.000	PLN	\N	93.320	35	45
    130	0.000	PLN	\N	87.110	35	46
    131	0.000	USD	\N	58.710	1	44
    132	0.000	USD	\N	48.410	1	45
    133	0.000	USD	\N	85.830	1	46
    134	0.000	USD	\N	98.940	34	44
    135	0.000	USD	\N	71.960	34	45
    136	0.000	USD	\N	59.340	34	46
    137	0.000	PLN	\N	23.200	35	47
    138	0.000	PLN	\N	94.710	35	48
    139	0.000	PLN	\N	12.200	35	49
    140	0.000	PLN	\N	18.680	35	50
    141	0.000	USD	\N	48.330	1	47
    142	0.000	USD	\N	96.940	1	48
    143	0.000	USD	\N	77.510	1	49
    144	0.000	USD	\N	59.170	1	50
    145	0.000	USD	\N	95.330	34	47
    146	0.000	USD	\N	4.130	34	48
    147	0.000	USD	\N	52.560	34	49
    148	0.000	USD	\N	1.230	34	50
    149	0.000	PLN	\N	9.890	35	51
    150	0.000	PLN	\N	10.130	35	52
    151	0.000	PLN	\N	99.160	35	53
    152	0.000	PLN	\N	15.100	35	54
    153	0.000	USD	\N	90.320	1	51
    154	0.000	USD	\N	17.300	1	52
    155	0.000	USD	\N	8.690	1	53
    156	0.000	USD	\N	14.130	1	54
    157	0.000	USD	\N	14.560	34	51
    158	0.000	USD	\N	20.870	34	52
    159	0.000	USD	\N	9.160	34	53
    160	0.000	USD	\N	34.570	34	54
    161	0.000	PLN	\N	92.300	35	55
    162	0.000	PLN	\N	22.580	35	56
    163	0.000	PLN	\N	41.970	35	57
    164	0.000	PLN	\N	20.760	35	58
    165	0.000	USD	\N	98.450	1	55
    166	0.000	USD	\N	64.280	1	56
    167	0.000	USD	\N	7.150	1	57
    168	0.000	USD	\N	8.420	1	58
    169	0.000	USD	\N	37.590	34	55
    170	0.000	USD	\N	45.990	34	56
    171	0.000	USD	\N	24.660	34	57
    172	0.000	USD	\N	10.930	34	58
    \.


    --
    -- Data for Name: shipping_shippingmethodpostalcoderule; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.shipping_shippingmethodpostalcoderule (id, start, "end", shipping_method_id, inclusion_type) FROM stdin;
    \.


    --
    -- Data for Name: shipping_shippingmethodtranslation; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.shipping_shippingmethodtranslation (id, language_code, name, shipping_method_id, description) FROM stdin;
    \.


    --
    -- Data for Name: shipping_shippingzone; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.shipping_shippingzone (id, name, countries, "default", metadata, private_metadata, description) FROM stdin;
    1	Default	US	f	{}	{}	
    2	Europe	AD,AL,AT,AX,BA,BE,BG,BY,CH,CZ,DE,DK,EE,ES,FI,FO,FR,GB,GG,GI,GR,HR,HU,IE,IM,IS,IT,JE,LI,LT,LU,LV,MC,MD,ME,MK,MT,NL,NO,PL,PT,RO,RS,RU,SE,SI,SJ,SK,SM,UA,VA	f	{}	{}	
    3	Oceania	AS,AU,CC,CK,CX,FJ,FM,GU,HM,KI,MH,MP,NC,NF,NR,NU,NZ,PF,PG,PN,PW,SB,TK,TO,TV,UM,VU,WF,WS	f	{}	{}	
    4	Asia	AE,AF,AM,AZ,BD,BH,BN,BT,CN,CY,GE,HK,ID,IL,IN,IQ,IR,JO,JP,KG,KH,KP,KR,KW,KZ,LA,LB,LK,MM,MN,MO,MV,MY,NP,OM,PH,PK,PS,QA,SA,SG,SY,TH,TJ,TL,TM,TR,TW,UZ,VN,YE	f	{}	{}	
    5	Americas	AG,AI,AR,AW,BB,BL,BM,BO,BQ,BR,BS,BV,BZ,CA,CL,CO,CR,CU,CW,DM,DO,EC,FK,GD,GF,GL,GP,GS,GT,GY,HN,HT,JM,KN,KY,LC,MF,MQ,MS,MX,NI,PA,PE,PM,PR,PY,SR,SV,SX,TC,TT,US,UY,VC,VE,VG,VI	f	{}	{}	
    6	Africa	AO,BF,BI,BJ,BW,CD,CF,CG,CI,CM,CV,DJ,DZ,EG,EH,ER,ET,GA,GH,GM,GN,GQ,GW,IO,KE,KM,LR,LS,LY,MA,MG,ML,MR,MU,MW,MZ,NA,NE,NG,RE,RW,SC,SD,SH,SL,SN,SO,SS,ST,SZ,TD,TF,TG,TN,TZ,UG,YT,ZA,ZM,ZW	f	{}	{}	
    \.


    --
    -- Data for Name: shipping_shippingzone_channels; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.shipping_shippingzone_channels (id, shippingzone_id, channel_id) FROM stdin;
    1	1	1
    2	2	1
    3	2	34
    4	2	35
    5	3	1
    6	3	34
    7	3	35
    8	4	1
    9	4	34
    10	4	35
    11	5	1
    12	5	34
    13	5	35
    14	6	1
    15	6	34
    16	6	35
    \.


    --
    -- Data for Name: site_sitesettings; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.site_sitesettings (id, header_text, description, site_id, bottom_menu_id, top_menu_id, display_gross_prices, include_taxes_in_prices, charge_taxes_on_shipping, track_inventory_by_default, default_weight_unit, automatic_fulfillment_digital_products, default_digital_max_downloads, default_digital_url_valid_days, company_address_id, default_mail_sender_address, default_mail_sender_name, customer_set_password_url, fulfillment_allow_unpaid, fulfillment_auto_approve, gift_card_expiry_period, gift_card_expiry_period_type, gift_card_expiry_type, reserve_stock_duration_anonymous_user, reserve_stock_duration_authenticated_user, limit_quantity_per_checkout, enable_account_confirmation_by_email, metadata, private_metadata, allow_login_without_confirmation) FROM stdin;
    1	Test Saleor - a sample shop!		1	2	1	t	t	t	t	kg	f	\N	\N	\N	\N		\N	t	t	\N	\N	never_expire	\N	\N	50	t	{}	{}	f
    \.


    --
    -- Data for Name: site_sitesettingstranslation; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.site_sitesettingstranslation (id, language_code, header_text, description, site_settings_id) FROM stdin;
    \.


    --
    -- Data for Name: tax_taxclass; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.tax_taxclass (id, private_metadata, metadata, name) FROM stdin;
    1	{}	{}	Groceries
    2	{}	{}	Books
    3	{}	{}	Groceries
    4	{}	{}	Books
    5	{}	{}	Groceries
    6	{}	{}	Books
    \.


    --
    -- Data for Name: tax_taxclasscountryrate; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.tax_taxclasscountryrate (id, country, rate, tax_class_id) FROM stdin;
    \.


    --
    -- Data for Name: tax_taxconfiguration; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.tax_taxconfiguration (id, private_metadata, metadata, charge_taxes, tax_calculation_strategy, display_gross_prices, prices_entered_with_tax, channel_id, tax_app_id) FROM stdin;
    1	{}	{}	t	FLAT_RATES	f	f	1	\N
    2	{}	{}	t	FLAT_RATES	t	t	34	\N
    3	{}	{}	t	FLAT_RATES	t	t	35	\N
    \.


    --
    -- Data for Name: tax_taxconfigurationpercountry; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.tax_taxconfigurationpercountry (id, country, charge_taxes, tax_calculation_strategy, display_gross_prices, tax_configuration_id, tax_app_id) FROM stdin;
    \.


    --
    -- Data for Name: thumbnail_thumbnail; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.thumbnail_thumbnail (id, image, size, format, category_id, collection_id, product_media_id, user_id, app_id, app_installation_id) FROM stdin;
    \.


    --
    -- Data for Name: warehouse_allocation; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.warehouse_allocation (id, quantity_allocated, stock_id, order_line_id) FROM stdin;
    1	3	297	31b4aa82-dc3a-4ae4-af04-bb784529d995
    2	3	521	702f9190-8ffe-4d39-a386-1e52bf758aca
    3	3	31	06a9199a-1aae-4bb4-9b42-32e18ff2b309
    4	2	551	47d361bc-ebdd-4a72-b832-c09d2e183f31
    5	1	135	e8f4646d-7c78-4fe5-99d9-ee0fadeb058c
    7	4	367	48791609-c1dc-4ed5-b3f5-50e954e9c649
    6	3	31	990f138d-29dd-4fd7-8223-584e7241816c
    8	4	494	8ddbf2d9-df1e-4426-b9ce-d143e2cc530d
    10	1	286	6d1ac94b-122f-40d3-acb9-22f780a97407
    9	2	382	e93d8c4c-5ce7-4e21-afaf-e8f5c00115fc
    11	1	457	8b57af35-78a6-4adf-bae6-84bfe7d32496
    12	0	17	aee8e01e-d55c-45cf-a6a8-3db0281c270d
    13	4	169	d6df38bc-12db-4679-9a2a-3e278800dacf
    14	2	505	d48623f4-1cde-4a83-b4d1-e566901fb96f
    17	4	98	490f83ad-c496-4561-a9b3-43aecaa2821c
    15	0	514	e7b9dd56-fc82-4635-af9f-dde2d9acdedf
    16	3	50	5ff62c68-32ac-4945-a343-3ce2831b42c2
    18	0	242	fb934334-0233-4985-9683-d98532b93fb4
    20	3	520	05b19556-28b5-4fa7-a31a-ba3f48261e00
    19	3	24	5dca3aa6-0329-4b2d-8dfe-24fe96bfe04c
    21	1	264	2ab60a0d-2ab8-45fc-8da5-6e49cd717d4a
    22	1	72	ee8cb3de-3a7b-434c-be8d-d997405df988
    23	4	121	9896c388-e2a7-4999-8539-eb82555666a9
    24	0	193	efd52fa3-de71-488d-9d13-b90df0e1c178
    25	3	120	95e338e0-767f-4771-bd07-88db3eaf802f
    26	4	152	8823582c-4bbb-4843-9069-edfd9a50884e
    27	2	320	f226cde7-2282-4116-b5ec-86b6e86436fd
    28	1	114	82083514-264e-482f-b23b-c57353e7c9eb
    29	1	170	68f03306-3c03-4753-ab5b-afd8fa664c93
    30	0	82	15763d4f-2ab1-43ed-9115-20c1ddce671c
    31	0	367	bd5f2ef1-8a5d-4411-b4ff-25f26e508f09
    32	1	471	b7e3c798-1a02-4f2f-915b-229df579cdc6
    34	2	530	8e619bd3-39f5-42db-8fe5-a268781db2bf
    35	1	162	bdc9df7f-5df4-49c6-88c0-134fa1df08c1
    36	1	242	861341d1-309c-41de-afdc-2675a5f29e78
    33	0	74	ae897f6e-fd3b-41ae-9a7a-2cc75e19ad2b
    37	1	358	180ebd31-5c0d-48ba-9df0-abca082a61df
    40	2	490	ea147ee9-04c4-4d77-952a-ea0da0c6e13e
    41	1	146	e60b7820-93cc-4625-9d52-a810f29a7ac8
    38	0	450	b042a4b8-5fcd-4d30-9957-528272402620
    39	0	26	5961243b-0717-4a79-954c-dccb9b69f880
    42	2	394	f8eabe27-f94a-4142-a1bd-c927b557040c
    44	3	174	30be4c75-f85a-416e-822d-dd3570badd0b
    43	3	302	07696772-b3a5-44d4-8446-70cb33d22380
    45	3	14	711efb56-10fe-487c-8391-05bcc87cf523
    46	1	158	dbfadeff-eb1c-440c-951c-16ca67601ebe
    48	4	6	48c9e4fb-7c21-4c6c-85d8-0238f5ea7851
    47	0	422	3e546566-c376-4de9-9684-df8b1360ce6e
    49	1	216	930794ac-f5ca-4663-90c1-49e65109455d
    50	3	352	6dd5d081-9748-49f8-9a2b-ff7510e6fb84
    51	2	247	0aa13e7d-a057-476b-ad66-3e8435935000
    52	1	488	08d0f894-c06d-471c-adea-ba06f5523653
    55	2	359	9aa4978d-491b-4447-ba1a-e8b345f72b80
    53	0	167	4f2e79e4-606d-431a-8b2a-5cdd500e83e3
    54	0	31	4ec749e8-2b87-43ab-97ba-73fb75361a71
    56	1	226	895ee9f4-8191-466a-b210-8612119a55fb
    57	3	258	d3409b75-94e4-43d9-8a7d-2a23039a0a04
    58	1	48	f8502f3f-5ff1-412d-99f8-fb6352d5aafd
    59	0	344	c4def8b7-405d-4123-8b6b-034fe7e02a83
    60	1	328	87b60f97-8820-446f-9938-f72077a8f534
    62	1	495	d414072b-d518-4011-8cda-eb7e5d967867
    61	3	167	3dd24bf6-b18c-4d5f-b4d2-649d5d65f8db
    63	2	359	6a81b7ff-3b46-4cd3-933d-b489985d5086
    64	4	183	36d6ac23-77d5-4f5b-9966-ae3e99ff2c4f
    65	2	526	24203d4d-cbf3-4d29-8016-b6616fd66f32
    66	1	54	6d890352-2b10-4660-a8af-cbc7281bba44
    67	2	254	e2dc3a67-fb4b-4149-8716-7a39ee881285
    68	1	208	331ebca3-ceeb-45dc-a437-0bedd53c623c
    69	0	424	dc73e900-aef0-4497-b0ad-2c615a3dfc00
    70	0	88	12c4dccb-f7a1-4ddb-9218-39df5cb2449d
    71	4	520	8f0c995a-0dc1-4462-a061-2239313873e7
    73	2	184	1ca3af18-9acb-4841-b4f0-9da125af61b4
    72	2	208	5d182b9a-0412-4e82-a47b-815ee99618c4
    74	4	430	a5bee344-56c4-4447-9532-f018bdf17fdc
    76	4	246	6865eca1-73df-4fa8-af90-6f3d02c50773
    75	1	310	35a8c8e6-cafd-4e64-a7b4-ec147746552c
    77	3	241	398d5bca-25d0-427f-b578-80dbb10c10a6
    79	1	353	2691306f-ce69-4409-80cb-edbb93bb8c38
    80	1	145	db9704b1-f03a-45a9-9397-852f143dd066
    78	1	289	7939fef0-6813-4f32-8b65-1b1c4d8701c2
    82	4	399	33b70df2-3fdb-49e5-a7bb-b32c06a92ca4
    83	3	143	99a96826-c2e1-4ec1-a09e-2cdc748cac71
    81	1	479	40cb3ae2-d5ea-4e14-a69f-d7519df1380f
    84	1	176	62547330-dec1-4ce6-b728-cd0dcbf3428d
    85	3	200	f7d5775a-b512-4940-a679-7f546715f507
    86	2	498	212a9690-4be4-4aff-a346-be7a73c11ccf
    87	2	224	b3b3125f-9a50-400b-872c-976e0301982f
    88	3	544	fe1f3c04-09cb-45bc-80c7-aebdc843caef
    89	4	496	94ce3590-ab75-4a8f-98a1-95e5bd8b061b
    90	0	222	0d41a8ac-f4d8-4375-994f-116d087637dc
    92	1	137	97b5869a-0d57-4460-a40f-ec2adffcae16
    93	4	353	cf31a836-b59e-4405-9912-633de75ccc2e
    91	0	233	3cc19c3e-25ad-4e23-ab99-b615aab6121e
    94	3	505	6131f5df-1e2c-4f50-9eac-72be1d818b8e
    95	2	570	04b832d1-d2d1-48a5-ba97-e310f9b09e6b
    96	2	474	8f753dcd-bc5c-4894-abf4-254033276a2d
    97	1	418	124ca8bc-cc5e-4403-a6e9-906609c06291
    98	2	114	6b3f7d2c-e56e-42d4-bfe8-59cb19ee400e
    99	0	54	b5471b08-3568-4538-bb82-dd6c5df6c2f5
    100	0	14	1e123fb0-db20-4664-a082-baf63870df9a
    101	1	142	f79836e7-872c-4ee0-b2e5-bf4f95037872
    103	1	488	caac37e0-8a9d-4c5f-a372-34de20686a33
    104	4	512	80e2d409-0549-476d-8352-bffa219de18c
    102	1	424	4f433cde-1a2e-45b9-ba16-391e53d6e8d3
    105	2	336	557f84d9-c283-4af6-b42f-3c9060735ce2
    106	0	320	9ec76d7c-7b82-4b01-9112-d511a09baaec
    107	4	489	f7d10db2-207c-46c2-9788-3067f983c099
    108	4	433	a4419162-587e-49b8-a361-f33d80509241
    109	2	369	fcad68ad-4bdb-4dd9-ace4-d65a6814bc8d
    110	1	430	f35507d8-eae1-4cde-9a71-91f2e4701fa4
    111	3	462	a388d338-f373-46de-98e9-45b9149ce8f6
    112	4	505	9632e41f-4f00-4cc1-9920-ed4fca8f2646
    113	2	561	b43a2241-6dc6-49f7-a46d-4245fcfd6a43
    114	1	153	507c2363-90f9-4689-a89c-815590532d3e
    115	2	289	0f40d16d-cbf3-45ca-be5f-8187d0647975
    116	3	202	eda40b48-df6d-4193-a88f-e147dd9f4ff5
    117	1	250	fba072a0-5087-4dc2-800e-4c4658217fb7
    118	4	450	6b2a6ebf-99c4-49e0-9e11-b6cd0856e135
    119	0	402	7679b648-f311-4b9b-b1a9-0a3fa9d01573
    120	4	310	c60c21c0-c0d5-4c6e-aed7-411cbf3dd3b8
    121	1	566	0ce52efd-2335-49fd-bbef-e596e2c9a636
    122	0	111	7c570801-94e4-4c00-9a32-1cf9527c9b07
    124	3	418	fd2b6b74-8331-4c59-acc4-b373422a82ed
    125	3	178	5dd07e96-86b3-414c-a19b-066d5e5ab8e4
    123	2	114	f1f829f1-322a-4072-89bd-73b6680e5af5
    126	1	430	3cb98b9a-ed40-4cfe-b3e7-6c18a1560536
    129	3	526	43098a62-f9df-40ba-9001-37ab2572339d
    127	0	206	c915b964-3e1e-470c-ba82-585e7df6cdcd
    128	0	518	ab053067-4fd9-4ddc-be94-f28c5fe56165
    130	4	521	35a525af-658c-4f08-89c0-022862a27890
    131	2	121	65acbba0-d051-42c5-a6a9-09b0cedf25ab
    132	4	111	5fc8e00b-d19a-41ad-8ebb-145e41235fde
    133	1	479	8946324c-114c-416e-ba0a-d02b2cf7668f
    134	3	335	76c6a933-6849-4cc7-817a-4449370ff49c
    135	1	183	6437ebc1-f23f-41a5-8083-c74fddfdccf7
    136	3	560	ca86b014-cc20-4832-adc3-91ffbe620210
    137	3	295	1e8db371-5d80-4997-8761-165a7ae02d26
    138	1	457	6fd4a0d8-e7dc-4647-a8e0-a0cf3b07af0d
    139	3	161	eb9ad2d2-029a-43de-920d-42685e0e6932
    140	3	89	e1af6c33-0570-418c-aa66-41fa12cb4cc1
    141	2	466	7d26f947-96bd-425b-9242-9119368ac253
    142	1	234	6afd9dcb-be57-4219-89af-318f8ecef0e6
    144	4	554	f7cfff4b-3463-4687-aa8d-2fe33d191b23
    143	0	354	c19afcd5-45a3-4857-bc4d-ef9c8192b635
    145	3	390	6ff6cd7a-cad5-438d-b268-2d25de4f1183
    146	2	566	ff282e82-5599-409c-901c-17085ceb391a
    147	1	414	9e741d3b-017e-4316-9641-acb165d9072a
    \.


    --
    -- Data for Name: warehouse_channelwarehouse; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.warehouse_channelwarehouse (id, warehouse_id, channel_id, sort_order) FROM stdin;
    1	a023971d-4849-4d37-904b-6fc1eaef9f27	1	\N
    2	6c786422-fc7a-472d-8954-e62970b77a5a	1	\N
    3	6c786422-fc7a-472d-8954-e62970b77a5a	34	\N
    4	6c786422-fc7a-472d-8954-e62970b77a5a	35	\N
    5	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	1	\N
    6	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	34	\N
    7	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	35	\N
    8	94dea4b1-e6d1-42b9-b49b-41a301e2c815	1	\N
    9	94dea4b1-e6d1-42b9-b49b-41a301e2c815	34	\N
    10	94dea4b1-e6d1-42b9-b49b-41a301e2c815	35	\N
    11	4faf2ec1-027e-4900-8534-1fe18929cb58	1	\N
    12	4faf2ec1-027e-4900-8534-1fe18929cb58	34	\N
    13	4faf2ec1-027e-4900-8534-1fe18929cb58	35	\N
    14	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	1	\N
    15	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	34	\N
    16	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	35	\N
    17	4306092b-9813-4c96-ab5a-3f2409b2fc1c	1	\N
    18	4306092b-9813-4c96-ab5a-3f2409b2fc1c	34	\N
    19	4306092b-9813-4c96-ab5a-3f2409b2fc1c	35	\N
    20	a5797659-5627-4037-8a3e-d055fbe69a68	35	\N
    \.


    --
    -- Data for Name: warehouse_preorderallocation; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.warehouse_preorderallocation (id, quantity, product_variant_channel_listing_id, order_line_id) FROM stdin;
    \.


    --
    -- Data for Name: warehouse_preorderreservation; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.warehouse_preorderreservation (id, quantity_reserved, reserved_until, product_variant_channel_listing_id, checkout_line_id) FROM stdin;
    \.


    --
    -- Data for Name: warehouse_reservation; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.warehouse_reservation (id, quantity_reserved, reserved_until, stock_id, checkout_line_id) FROM stdin;
    \.


    --
    -- Data for Name: warehouse_stock; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.warehouse_stock (id, quantity, product_variant_id, warehouse_id, quantity_allocated) FROM stdin;
    1	158	324	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    2	158	324	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    3	158	324	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    4	158	324	a5797659-5627-4037-8a3e-d055fbe69a68	0
    5	158	324	6c786422-fc7a-472d-8954-e62970b77a5a	0
    6	158	324	4faf2ec1-027e-4900-8534-1fe18929cb58	4
    7	158	324	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    8	158	324	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    9	416	325	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    10	416	325	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    11	416	325	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    12	416	325	a5797659-5627-4037-8a3e-d055fbe69a68	0
    19	448	326	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    100	322	336	a5797659-5627-4037-8a3e-d055fbe69a68	0
    26	488	327	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	4
    74	286	333	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	4
    123	152	339	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    124	152	339	a5797659-5627-4037-8a3e-d055fbe69a68	0
    116	321	338	a5797659-5627-4037-8a3e-d055fbe69a68	0
    84	243	334	a5797659-5627-4037-8a3e-d055fbe69a68	0
    76	286	333	a5797659-5627-4037-8a3e-d055fbe69a68	0
    28	488	327	a5797659-5627-4037-8a3e-d055fbe69a68	0
    16	416	325	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    13	416	325	6c786422-fc7a-472d-8954-e62970b77a5a	0
    15	416	325	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    17	448	326	94dea4b1-e6d1-42b9-b49b-41a301e2c815	1
    18	448	326	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    20	448	326	a5797659-5627-4037-8a3e-d055fbe69a68	0
    21	448	326	6c786422-fc7a-472d-8954-e62970b77a5a	0
    23	448	326	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    24	448	326	4306092b-9813-4c96-ab5a-3f2409b2fc1c	4
    25	488	327	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    27	488	327	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    29	488	327	6c786422-fc7a-472d-8954-e62970b77a5a	0
    30	488	327	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    32	488	327	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    33	492	328	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    34	492	328	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    35	492	328	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    36	492	328	a5797659-5627-4037-8a3e-d055fbe69a68	0
    37	492	328	6c786422-fc7a-472d-8954-e62970b77a5a	0
    38	492	328	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    39	492	328	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    41	265	329	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    42	265	329	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    43	265	329	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    44	265	329	a5797659-5627-4037-8a3e-d055fbe69a68	0
    45	265	329	6c786422-fc7a-472d-8954-e62970b77a5a	0
    46	265	329	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    47	265	329	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    49	244	330	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    51	244	330	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    52	244	330	a5797659-5627-4037-8a3e-d055fbe69a68	0
    53	244	330	6c786422-fc7a-472d-8954-e62970b77a5a	0
    55	244	330	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    57	301	331	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    58	301	331	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    59	301	331	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    60	301	331	a5797659-5627-4037-8a3e-d055fbe69a68	0
    61	301	331	6c786422-fc7a-472d-8954-e62970b77a5a	0
    62	301	331	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    63	301	331	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    64	301	331	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    65	401	332	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    66	401	332	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    90	413	335	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    67	401	332	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    68	401	332	a5797659-5627-4037-8a3e-d055fbe69a68	0
    69	401	332	6c786422-fc7a-472d-8954-e62970b77a5a	0
    70	401	332	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    72	401	332	4306092b-9813-4c96-ab5a-3f2409b2fc1c	1
    73	286	333	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    75	286	333	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    77	286	333	6c786422-fc7a-472d-8954-e62970b77a5a	0
    78	286	333	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    79	286	333	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    80	286	333	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    81	243	334	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    82	243	334	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	2
    83	243	334	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    85	243	334	6c786422-fc7a-472d-8954-e62970b77a5a	0
    86	243	334	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    87	243	334	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    88	243	334	4306092b-9813-4c96-ab5a-3f2409b2fc1c	2
    91	413	335	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    92	413	335	a5797659-5627-4037-8a3e-d055fbe69a68	0
    93	413	335	6c786422-fc7a-472d-8954-e62970b77a5a	0
    94	413	335	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    95	413	335	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    96	413	335	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    97	322	336	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    98	322	336	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	4
    99	322	336	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    101	322	336	6c786422-fc7a-472d-8954-e62970b77a5a	0
    115	321	338	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    102	322	336	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    103	322	336	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    104	322	336	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    106	127	337	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    107	127	337	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    108	127	337	a5797659-5627-4037-8a3e-d055fbe69a68	0
    109	127	337	6c786422-fc7a-472d-8954-e62970b77a5a	0
    110	127	337	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    114	324	338	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	8
    112	127	337	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    113	321	338	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    111	133	337	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	6
    117	321	338	6c786422-fc7a-472d-8954-e62970b77a5a	0
    118	321	338	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    119	321	338	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    120	321	338	4306092b-9813-4c96-ab5a-3f2409b2fc1c	3
    122	152	339	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    125	152	339	6c786422-fc7a-472d-8954-e62970b77a5a	0
    126	152	339	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    127	152	339	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    128	152	339	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    129	473	340	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    130	473	340	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    131	473	340	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    132	473	340	a5797659-5627-4037-8a3e-d055fbe69a68	0
    133	473	340	6c786422-fc7a-472d-8954-e62970b77a5a	0
    134	473	340	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    136	473	340	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    14	417	325	4faf2ec1-027e-4900-8534-1fe18929cb58	5
    54	248	330	4faf2ec1-027e-4900-8534-1fe18929cb58	5
    137	275	341	94dea4b1-e6d1-42b9-b49b-41a301e2c815	1
    138	275	341	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    139	275	341	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    140	275	341	a5797659-5627-4037-8a3e-d055fbe69a68	0
    141	275	341	6c786422-fc7a-472d-8954-e62970b77a5a	0
    143	275	341	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	3
    144	275	341	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    145	313	342	94dea4b1-e6d1-42b9-b49b-41a301e2c815	1
    146	313	342	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	1
    147	313	342	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    148	313	342	a5797659-5627-4037-8a3e-d055fbe69a68	0
    266	261	357	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    154	272	343	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    172	422	345	a5797659-5627-4037-8a3e-d055fbe69a68	0
    165	343	344	6c786422-fc7a-472d-8954-e62970b77a5a	0
    149	313	342	6c786422-fc7a-472d-8954-e62970b77a5a	0
    176	422	345	4306092b-9813-4c96-ab5a-3f2409b2fc1c	1
    160	272	343	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    150	313	342	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    151	313	342	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    152	313	342	4306092b-9813-4c96-ab5a-3f2409b2fc1c	4
    202	417	349	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	3
    155	272	343	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    156	272	343	a5797659-5627-4037-8a3e-d055fbe69a68	0
    157	272	343	6c786422-fc7a-472d-8954-e62970b77a5a	0
    177	346	346	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    158	272	343	4faf2ec1-027e-4900-8534-1fe18929cb58	1
    159	272	343	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    234	265	353	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	1
    162	343	344	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	1
    164	343	344	a5797659-5627-4037-8a3e-d055fbe69a68	0
    166	343	344	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    167	343	344	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	5
    168	343	344	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    170	422	345	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	1
    171	422	345	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    173	422	345	6c786422-fc7a-472d-8954-e62970b77a5a	0
    174	422	345	4faf2ec1-027e-4900-8534-1fe18929cb58	3
    175	422	345	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    206	415	349	4faf2ec1-027e-4900-8534-1fe18929cb58	1
    179	346	346	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    180	346	346	a5797659-5627-4037-8a3e-d055fbe69a68	0
    181	346	346	6c786422-fc7a-472d-8954-e62970b77a5a	0
    161	346	344	94dea4b1-e6d1-42b9-b49b-41a301e2c815	3
    184	346	346	4306092b-9813-4c96-ab5a-3f2409b2fc1c	2
    185	306	347	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    186	306	347	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    187	306	347	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    201	414	349	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    188	306	347	a5797659-5627-4037-8a3e-d055fbe69a68	0
    189	306	347	6c786422-fc7a-472d-8954-e62970b77a5a	0
    190	306	347	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    191	306	347	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    192	306	347	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    255	316	355	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    247	295	354	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	2
    194	312	348	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    195	312	348	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    196	312	348	a5797659-5627-4037-8a3e-d055fbe69a68	0
    197	312	348	6c786422-fc7a-472d-8954-e62970b77a5a	0
    199	312	348	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    200	312	348	4306092b-9813-4c96-ab5a-3f2409b2fc1c	3
    250	317	355	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	1
    203	414	349	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    204	414	349	a5797659-5627-4037-8a3e-d055fbe69a68	0
    205	414	349	6c786422-fc7a-472d-8954-e62970b77a5a	0
    183	347	346	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	5
    207	414	349	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    208	414	349	4306092b-9813-4c96-ab5a-3f2409b2fc1c	6
    225	201	352	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    209	425	350	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    210	425	350	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    211	425	350	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    212	425	350	a5797659-5627-4037-8a3e-d055fbe69a68	0
    214	425	350	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    215	425	350	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    217	295	351	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    218	295	351	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    219	295	351	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    220	295	351	a5797659-5627-4037-8a3e-d055fbe69a68	0
    221	295	351	6c786422-fc7a-472d-8954-e62970b77a5a	0
    222	295	351	4faf2ec1-027e-4900-8534-1fe18929cb58	1
    223	295	351	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    224	295	351	4306092b-9813-4c96-ab5a-3f2409b2fc1c	2
    227	201	352	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    226	201	352	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	1
    229	201	352	6c786422-fc7a-472d-8954-e62970b77a5a	0
    230	201	352	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    231	201	352	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    232	201	352	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    233	264	353	94dea4b1-e6d1-42b9-b49b-41a301e2c815	1
    235	264	353	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    236	264	353	a5797659-5627-4037-8a3e-d055fbe69a68	0
    260	475	356	a5797659-5627-4037-8a3e-d055fbe69a68	0
    237	264	353	6c786422-fc7a-472d-8954-e62970b77a5a	0
    238	264	353	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    239	264	353	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    240	264	353	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    241	295	354	94dea4b1-e6d1-42b9-b49b-41a301e2c815	3
    243	295	354	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    245	295	354	6c786422-fc7a-472d-8954-e62970b77a5a	0
    246	295	354	4faf2ec1-027e-4900-8534-1fe18929cb58	4
    248	295	354	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    249	316	355	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    178	349	346	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	3
    251	316	355	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    252	316	355	a5797659-5627-4037-8a3e-d055fbe69a68	0
    253	316	355	6c786422-fc7a-472d-8954-e62970b77a5a	0
    254	316	355	4faf2ec1-027e-4900-8534-1fe18929cb58	2
    256	316	355	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    257	475	356	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    258	475	356	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	3
    261	475	356	6c786422-fc7a-472d-8954-e62970b77a5a	0
    262	475	356	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    263	475	356	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    264	475	356	4306092b-9813-4c96-ab5a-3f2409b2fc1c	1
    265	261	357	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    267	261	357	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    268	261	357	a5797659-5627-4037-8a3e-d055fbe69a68	0
    269	261	357	6c786422-fc7a-472d-8954-e62970b77a5a	0
    270	261	357	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    271	261	357	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    272	261	357	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    153	273	343	94dea4b1-e6d1-42b9-b49b-41a301e2c815	1
    142	277	341	4faf2ec1-027e-4900-8534-1fe18929cb58	2
    273	440	358	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    274	440	358	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    275	440	358	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    276	440	358	a5797659-5627-4037-8a3e-d055fbe69a68	0
    277	440	358	6c786422-fc7a-472d-8954-e62970b77a5a	0
    278	440	358	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    279	440	358	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    280	440	358	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    281	245	359	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    282	245	359	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    283	245	359	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    284	245	359	a5797659-5627-4037-8a3e-d055fbe69a68	0
    384	320	373	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    322	256	364	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    285	245	359	6c786422-fc7a-472d-8954-e62970b77a5a	0
    397	237	375	6c786422-fc7a-472d-8954-e62970b77a5a	0
    304	281	361	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    287	245	359	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    288	245	359	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    290	200	360	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    291	200	360	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    292	200	360	a5797659-5627-4037-8a3e-d055fbe69a68	0
    293	200	360	6c786422-fc7a-472d-8954-e62970b77a5a	0
    294	200	360	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    354	420	370	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	1
    296	200	360	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    298	281	361	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    299	281	361	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    301	281	361	6c786422-fc7a-472d-8954-e62970b77a5a	0
    302	281	361	4faf2ec1-027e-4900-8534-1fe18929cb58	4
    303	281	361	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    305	466	362	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    306	466	362	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    307	466	362	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    308	466	362	a5797659-5627-4037-8a3e-d055fbe69a68	0
    309	466	362	6c786422-fc7a-472d-8954-e62970b77a5a	0
    335	262	365	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	3
    311	466	362	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    312	466	362	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    313	393	363	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    314	393	363	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    315	393	363	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    317	393	363	6c786422-fc7a-472d-8954-e62970b77a5a	0
    318	393	363	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    319	393	363	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    402	272	376	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	2
    321	256	364	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    323	256	364	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    324	256	364	a5797659-5627-4037-8a3e-d055fbe69a68	0
    325	256	364	6c786422-fc7a-472d-8954-e62970b77a5a	0
    326	256	364	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    327	256	364	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    328	256	364	4306092b-9813-4c96-ab5a-3f2409b2fc1c	2
    329	259	365	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    330	259	365	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    331	259	365	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    333	259	365	6c786422-fc7a-472d-8954-e62970b77a5a	0
    334	259	365	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    295	203	360	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	3
    369	181	372	94dea4b1-e6d1-42b9-b49b-41a301e2c815	2
    337	179	366	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    338	179	366	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    339	179	366	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    340	179	366	a5797659-5627-4037-8a3e-d055fbe69a68	0
    360	419	370	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    341	179	366	6c786422-fc7a-472d-8954-e62970b77a5a	0
    342	179	366	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    343	179	366	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    344	179	366	4306092b-9813-4c96-ab5a-3f2409b2fc1c	4
    345	326	368	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    346	326	368	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    348	326	368	a5797659-5627-4037-8a3e-d055fbe69a68	0
    349	326	368	6c786422-fc7a-472d-8954-e62970b77a5a	0
    350	326	368	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    351	326	368	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    353	419	370	94dea4b1-e6d1-42b9-b49b-41a301e2c815	5
    390	200	374	4faf2ec1-027e-4900-8534-1fe18929cb58	3
    355	419	370	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    356	419	370	a5797659-5627-4037-8a3e-d055fbe69a68	0
    357	419	370	6c786422-fc7a-472d-8954-e62970b77a5a	0
    358	419	370	4faf2ec1-027e-4900-8534-1fe18929cb58	2
    359	419	370	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	4
    361	495	371	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    362	495	371	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    364	495	371	a5797659-5627-4037-8a3e-d055fbe69a68	0
    365	495	371	6c786422-fc7a-472d-8954-e62970b77a5a	0
    366	495	371	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    400	237	375	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    368	495	371	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    289	202	360	94dea4b1-e6d1-42b9-b49b-41a301e2c815	5
    370	179	372	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    371	179	372	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    372	179	372	a5797659-5627-4037-8a3e-d055fbe69a68	0
    373	179	372	6c786422-fc7a-472d-8954-e62970b77a5a	0
    374	179	372	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    375	179	372	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    376	179	372	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    377	320	373	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    378	320	373	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    380	320	373	a5797659-5627-4037-8a3e-d055fbe69a68	0
    381	320	373	6c786422-fc7a-472d-8954-e62970b77a5a	0
    382	320	373	4faf2ec1-027e-4900-8534-1fe18929cb58	4
    383	320	373	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    385	197	374	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    386	197	374	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    387	197	374	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    388	197	374	a5797659-5627-4037-8a3e-d055fbe69a68	0
    389	197	374	6c786422-fc7a-472d-8954-e62970b77a5a	0
    391	197	374	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    392	197	374	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    393	237	375	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    394	237	375	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	2
    396	237	375	a5797659-5627-4037-8a3e-d055fbe69a68	0
    398	237	375	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    399	237	375	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	4
    401	270	376	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    310	470	362	4faf2ec1-027e-4900-8534-1fe18929cb58	7
    403	270	376	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    404	270	376	a5797659-5627-4037-8a3e-d055fbe69a68	0
    405	270	376	6c786422-fc7a-472d-8954-e62970b77a5a	0
    406	270	376	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    407	270	376	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    408	270	376	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    320	395	363	4306092b-9813-4c96-ab5a-3f2409b2fc1c	5
    336	261	365	4306092b-9813-4c96-ab5a-3f2409b2fc1c	2
    409	222	377	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    410	222	377	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    411	222	377	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    412	222	377	a5797659-5627-4037-8a3e-d055fbe69a68	0
    413	222	377	6c786422-fc7a-472d-8954-e62970b77a5a	0
    415	222	377	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    416	222	377	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    417	460	378	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    419	460	378	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    420	460	378	a5797659-5627-4037-8a3e-d055fbe69a68	0
    459	242	384	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    516	211	393	a5797659-5627-4037-8a3e-d055fbe69a68	0
    523	164	394	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    473	357	386	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    533	425	395	6c786422-fc7a-472d-8954-e62970b77a5a	0
    452	312	383	a5797659-5627-4037-8a3e-d055fbe69a68	0
    492	338	388	a5797659-5627-4037-8a3e-d055fbe69a68	0
    430	393	379	4faf2ec1-027e-4900-8534-1fe18929cb58	6
    421	460	378	6c786422-fc7a-472d-8954-e62970b77a5a	0
    422	460	378	4faf2ec1-027e-4900-8534-1fe18929cb58	4
    423	460	378	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    425	391	379	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    426	391	379	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    427	391	379	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    428	391	379	a5797659-5627-4037-8a3e-d055fbe69a68	0
    429	391	379	6c786422-fc7a-472d-8954-e62970b77a5a	0
    462	245	384	4faf2ec1-027e-4900-8534-1fe18929cb58	3
    431	391	379	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    518	212	393	4faf2ec1-027e-4900-8534-1fe18929cb58	1
    434	355	380	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    435	355	380	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    436	355	380	a5797659-5627-4037-8a3e-d055fbe69a68	0
    437	355	380	6c786422-fc7a-472d-8954-e62970b77a5a	0
    438	355	380	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    439	355	380	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    440	355	380	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    441	369	382	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    481	415	387	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    442	369	382	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    443	369	382	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    444	369	382	a5797659-5627-4037-8a3e-d055fbe69a68	0
    445	369	382	6c786422-fc7a-472d-8954-e62970b77a5a	0
    446	369	382	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    448	369	382	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    449	312	383	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    418	463	378	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	4
    451	312	383	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    453	312	383	6c786422-fc7a-472d-8954-e62970b77a5a	0
    454	312	383	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    455	312	383	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    456	312	383	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    466	242	385	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	2
    458	242	384	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    460	242	384	a5797659-5627-4037-8a3e-d055fbe69a68	0
    461	242	384	6c786422-fc7a-472d-8954-e62970b77a5a	0
    450	316	383	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	5
    463	242	384	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    465	240	385	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    414	224	377	4faf2ec1-027e-4900-8534-1fe18929cb58	2
    467	240	385	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    468	240	385	a5797659-5627-4037-8a3e-d055fbe69a68	0
    469	240	385	6c786422-fc7a-472d-8954-e62970b77a5a	0
    470	240	385	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    471	240	385	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	4
    472	240	385	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    474	357	386	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	2
    475	357	386	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    476	357	386	a5797659-5627-4037-8a3e-d055fbe69a68	0
    477	357	386	6c786422-fc7a-472d-8954-e62970b77a5a	0
    478	357	386	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    457	243	384	94dea4b1-e6d1-42b9-b49b-41a301e2c815	4
    482	415	387	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    483	415	387	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    484	415	387	a5797659-5627-4037-8a3e-d055fbe69a68	0
    485	415	387	6c786422-fc7a-472d-8954-e62970b77a5a	0
    486	415	387	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    487	415	387	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    433	359	380	94dea4b1-e6d1-42b9-b49b-41a301e2c815	4
    490	338	388	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	2
    491	338	388	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    499	347	389	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    493	338	388	6c786422-fc7a-472d-8954-e62970b77a5a	0
    495	338	388	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	1
    496	338	388	4306092b-9813-4c96-ab5a-3f2409b2fc1c	4
    498	347	389	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	2
    500	347	389	a5797659-5627-4037-8a3e-d055fbe69a68	0
    501	347	389	6c786422-fc7a-472d-8954-e62970b77a5a	0
    502	347	389	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    522	164	394	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    503	347	389	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    504	347	389	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    506	339	390	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    507	339	390	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    527	164	394	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    508	339	390	a5797659-5627-4037-8a3e-d055fbe69a68	0
    512	343	390	4306092b-9813-4c96-ab5a-3f2409b2fc1c	4
    509	339	390	6c786422-fc7a-472d-8954-e62970b77a5a	0
    510	339	390	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    511	339	390	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    489	342	388	94dea4b1-e6d1-42b9-b49b-41a301e2c815	4
    514	211	393	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	3
    515	211	393	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    517	211	393	6c786422-fc7a-472d-8954-e62970b77a5a	0
    526	167	394	4faf2ec1-027e-4900-8534-1fe18929cb58	5
    519	211	393	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    520	211	393	4306092b-9813-4c96-ab5a-3f2409b2fc1c	7
    524	164	394	a5797659-5627-4037-8a3e-d055fbe69a68	0
    525	164	394	6c786422-fc7a-472d-8954-e62970b77a5a	0
    479	358	386	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	3
    528	164	394	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    529	425	395	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    530	425	395	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	2
    532	425	395	a5797659-5627-4037-8a3e-d055fbe69a68	0
    534	425	395	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    535	425	395	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    536	425	395	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    537	443	396	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    538	443	396	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    539	443	396	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    540	443	396	a5797659-5627-4037-8a3e-d055fbe69a68	0
    541	443	396	6c786422-fc7a-472d-8954-e62970b77a5a	0
    542	443	396	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    543	443	396	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    544	443	396	4306092b-9813-4c96-ab5a-3f2409b2fc1c	3
    424	463	378	4306092b-9813-4c96-ab5a-3f2409b2fc1c	5
    570	411	400	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	2
    571	411	400	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    572	411	400	a5797659-5627-4037-8a3e-d055fbe69a68	0
    573	411	400	6c786422-fc7a-472d-8954-e62970b77a5a	0
    574	411	400	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    575	411	400	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    22	448	326	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    566	456	399	4faf2ec1-027e-4900-8534-1fe18929cb58	3
    31	488	327	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	10
    464	242	384	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    480	357	386	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    494	338	388	4faf2ec1-027e-4900-8534-1fe18929cb58	4
    497	347	389	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    513	211	393	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    576	411	400	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    40	492	328	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    577	476	401	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    578	476	401	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    579	476	401	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    580	476	401	a5797659-5627-4037-8a3e-d055fbe69a68	0
    581	476	401	6c786422-fc7a-472d-8954-e62970b77a5a	0
    582	476	401	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    583	476	401	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    584	476	401	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    488	416	387	4306092b-9813-4c96-ab5a-3f2409b2fc1c	2
    505	343	390	94dea4b1-e6d1-42b9-b49b-41a301e2c815	10
    561	455	399	94dea4b1-e6d1-42b9-b49b-41a301e2c815	2
    521	168	394	94dea4b1-e6d1-42b9-b49b-41a301e2c815	7
    121	154	339	94dea4b1-e6d1-42b9-b49b-41a301e2c815	6
    48	265	329	4306092b-9813-4c96-ab5a-3f2409b2fc1c	2
    531	425	395	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    50	244	330	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	4
    56	244	330	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    71	401	332	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    105	127	337	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    135	473	340	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	1
    163	343	344	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    169	422	345	94dea4b1-e6d1-42b9-b49b-41a301e2c815	4
    182	346	346	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    193	312	348	94dea4b1-e6d1-42b9-b49b-41a301e2c815	4
    198	312	348	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    213	425	350	6c786422-fc7a-472d-8954-e62970b77a5a	0
    216	425	350	4306092b-9813-4c96-ab5a-3f2409b2fc1c	1
    228	201	352	a5797659-5627-4037-8a3e-d055fbe69a68	0
    242	295	354	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	2
    244	295	354	a5797659-5627-4037-8a3e-d055fbe69a68	0
    259	475	356	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    286	245	359	4faf2ec1-027e-4900-8534-1fe18929cb58	1
    297	281	361	94dea4b1-e6d1-42b9-b49b-41a301e2c815	3
    300	281	361	a5797659-5627-4037-8a3e-d055fbe69a68	0
    316	393	363	a5797659-5627-4037-8a3e-d055fbe69a68	0
    332	259	365	a5797659-5627-4037-8a3e-d055fbe69a68	0
    347	326	368	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    352	326	368	4306092b-9813-4c96-ab5a-3f2409b2fc1c	3
    363	495	371	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    367	495	371	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	5
    379	320	373	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    395	237	375	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    432	391	379	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    447	369	382	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    545	494	397	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    546	494	397	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    547	494	397	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    548	494	397	a5797659-5627-4037-8a3e-d055fbe69a68	0
    549	494	397	6c786422-fc7a-472d-8954-e62970b77a5a	0
    550	494	397	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    551	494	397	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	2
    552	494	397	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    553	100	398	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    555	100	398	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    556	100	398	a5797659-5627-4037-8a3e-d055fbe69a68	0
    557	100	398	6c786422-fc7a-472d-8954-e62970b77a5a	0
    558	100	398	4faf2ec1-027e-4900-8534-1fe18929cb58	0
    559	100	398	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    562	453	399	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	0
    563	453	399	a023971d-4849-4d37-904b-6fc1eaef9f27	0
    564	453	399	a5797659-5627-4037-8a3e-d055fbe69a68	0
    565	453	399	6c786422-fc7a-472d-8954-e62970b77a5a	0
    567	453	399	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	0
    568	453	399	4306092b-9813-4c96-ab5a-3f2409b2fc1c	0
    569	411	400	94dea4b1-e6d1-42b9-b49b-41a301e2c815	0
    560	103	398	4306092b-9813-4c96-ab5a-3f2409b2fc1c	3
    89	416	335	94dea4b1-e6d1-42b9-b49b-41a301e2c815	3
    554	104	398	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	4
    \.


    --
    -- Data for Name: warehouse_warehouse; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.warehouse_warehouse (id, name, email, address_id, slug, metadata, private_metadata, click_and_collect_option, is_private, external_reference) FROM stdin;
    a023971d-4849-4d37-904b-6fc1eaef9f27	Default Warehouse		1	default-warehouse	{}	{}	disabled	t	\N
    6c786422-fc7a-472d-8954-e62970b77a5a	Default		137	default	{}	{}	disabled	f	\N
    b599fc3a-a2e1-4489-88c1-c1c94f9838ec	Europe		138	europe	{}	{}	all	t	\N
    94dea4b1-e6d1-42b9-b49b-41a301e2c815	Oceania		139	oceania	{}	{}	local	t	\N
    4faf2ec1-027e-4900-8534-1fe18929cb58	Asia		140	asia	{}	{}	disabled	f	\N
    3b48dd53-36a7-4f67-97f3-d4aad0758eaf	Americas		141	americas	{}	{}	all	t	\N
    4306092b-9813-4c96-ab5a-3f2409b2fc1c	Africa		142	africa	{}	{}	all	f	\N
    a5797659-5627-4037-8a3e-d055fbe69a68	Default for click and collect		143	default-for-click-and-collect	{}	{}	local	f	\N
    \.


    --
    -- Data for Name: warehouse_warehouse_shipping_zones; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.warehouse_warehouse_shipping_zones (id, warehouse_id, shippingzone_id) FROM stdin;
    1	a023971d-4849-4d37-904b-6fc1eaef9f27	1
    2	6c786422-fc7a-472d-8954-e62970b77a5a	1
    3	b599fc3a-a2e1-4489-88c1-c1c94f9838ec	2
    4	94dea4b1-e6d1-42b9-b49b-41a301e2c815	3
    5	4faf2ec1-027e-4900-8534-1fe18929cb58	4
    6	3b48dd53-36a7-4f67-97f3-d4aad0758eaf	5
    7	4306092b-9813-4c96-ab5a-3f2409b2fc1c	6
    8	a5797659-5627-4037-8a3e-d055fbe69a68	1
    \.


    --
    -- Data for Name: webhook_webhook; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.webhook_webhook (id, target_url, is_active, secret_key, app_id, name, subscription_query, custom_headers) FROM stdin;
    \.


    --
    -- Data for Name: webhook_webhookevent; Type: TABLE DATA; Schema: public; Owner: saleor
    --

    COPY public.webhook_webhookevent (id, event_type, webhook_id) FROM stdin;
    \.


    --
    -- Name: account_customerevent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.account_customerevent_id_seq', 1, false);


    --
    -- Name: account_customernote_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.account_customernote_id_seq', 1, false);


    --
    -- Name: account_group_channels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.account_group_channels_id_seq', 1, false);


    --
    -- Name: account_serviceaccount_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.account_serviceaccount_id_seq', 1, false);


    --
    -- Name: account_serviceaccount_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.account_serviceaccount_permissions_id_seq', 1, false);


    --
    -- Name: account_serviceaccounttoken_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.account_serviceaccounttoken_id_seq', 1, false);


    --
    -- Name: account_staffnotificationrecipient_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.account_staffnotificationrecipient_id_seq', 1, false);


    --
    -- Name: app_appextension_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.app_appextension_id_seq', 1, false);


    --
    -- Name: app_appextension_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.app_appextension_permissions_id_seq', 1, false);


    --
    -- Name: app_appinstallation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.app_appinstallation_id_seq', 1, false);


    --
    -- Name: app_appinstallation_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.app_appinstallation_permissions_id_seq', 1, false);


    --
    -- Name: attribute_assignedpageattributevalue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.attribute_assignedpageattributevalue_id_seq', 1, false);


    --
    -- Name: attribute_assignedproductattributevalue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.attribute_assignedproductattributevalue_id_seq', 214, true);


    --
    -- Name: attribute_assignedvariantattributevalue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.attribute_assignedvariantattributevalue_id_seq', 731, true);


    --
    -- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.auth_group_id_seq', 24, true);


    --
    -- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 122, true);


    --
    -- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.auth_permission_id_seq', 540, true);


    --
    -- Name: channel_channel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.channel_channel_id_seq', 35, true);


    --
    -- Name: checkout_checkout_gift_cards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.checkout_checkout_gift_cards_id_seq', 1, false);


    --
    -- Name: checkout_checkoutmetadata_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.checkout_checkoutmetadata_id_seq', 1, false);


    --
    -- Name: core_eventdelivery_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.core_eventdelivery_id_seq', 1, false);


    --
    -- Name: core_eventdeliveryattempt_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.core_eventdeliveryattempt_id_seq', 1, false);


    --
    -- Name: core_eventpayload_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.core_eventpayload_id_seq', 1, false);


    --
    -- Name: csv_exportevent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.csv_exportevent_id_seq', 1, false);


    --
    -- Name: csv_exportfile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.csv_exportfile_id_seq', 1, false);


    --
    -- Name: discount_promotion_old_sale_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.discount_promotion_old_sale_id_seq', 1000, false);


    --
    -- Name: discount_promotionrule_channels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.discount_promotionrule_channels_id_seq', 72, true);


    --
    -- Name: discount_promotionrule_gifts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.discount_promotionrule_gifts_id_seq', 1, false);


    --
    -- Name: discount_promotionrule_old_channel_listing_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.discount_promotionrule_old_channel_listing_id_seq', 1000, false);


    --
    -- Name: discount_promotionrule_variants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.discount_promotionrule_variants_id_seq', 50, true);


    --
    -- Name: discount_promotionruletranslation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.discount_promotionruletranslation_id_seq', 1, false);


    --
    -- Name: discount_promotiontranslation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.discount_promotiontranslation_id_seq', 1, false);


    --
    -- Name: discount_voucher_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.discount_voucher_categories_id_seq', 1, false);


    --
    -- Name: discount_voucher_collections_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.discount_voucher_collections_id_seq', 1, false);


    --
    -- Name: discount_voucher_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.discount_voucher_id_seq', 3, true);


    --
    -- Name: discount_voucher_products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.discount_voucher_products_id_seq', 1, false);


    --
    -- Name: discount_voucher_variants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.discount_voucher_variants_id_seq', 1, false);


    --
    -- Name: discount_voucherchannellisting_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.discount_voucherchannellisting_id_seq', 9, true);


    --
    -- Name: discount_vouchercustomer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.discount_vouchercustomer_id_seq', 1, false);


    --
    -- Name: discount_vouchertranslation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.discount_vouchertranslation_id_seq', 1, false);


    --
    -- Name: django_celery_beat_clockedschedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.django_celery_beat_clockedschedule_id_seq', 1, false);


    --
    -- Name: django_celery_beat_crontabschedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.django_celery_beat_crontabschedule_id_seq', 1, false);


    --
    -- Name: django_celery_beat_intervalschedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.django_celery_beat_intervalschedule_id_seq', 1, false);


    --
    -- Name: django_celery_beat_periodictask_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.django_celery_beat_periodictask_id_seq', 1, false);


    --
    -- Name: django_celery_beat_solarschedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.django_celery_beat_solarschedule_id_seq', 1, false);


    --
    -- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.django_content_type_id_seq', 154, true);


    --
    -- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.django_migrations_id_seq', 1186, true);


    --
    -- Name: django_site_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.django_site_id_seq', 33, true);


    --
    -- Name: giftcard_giftcard_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.giftcard_giftcard_id_seq', 10, true);


    --
    -- Name: giftcard_giftcard_tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.giftcard_giftcard_tags_id_seq', 5, true);


    --
    -- Name: giftcard_giftcardevent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.giftcard_giftcardevent_id_seq', 30, true);


    --
    -- Name: giftcard_giftcardtag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.giftcard_giftcardtag_id_seq', 1, true);


    --
    -- Name: invoice_invoice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.invoice_invoice_id_seq', 1, false);


    --
    -- Name: invoice_invoiceevent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.invoice_invoiceevent_id_seq', 1, false);


    --
    -- Name: menu_menu_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.menu_menu_id_seq', 2, true);


    --
    -- Name: menu_menuitem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.menu_menuitem_id_seq', 246, true);


    --
    -- Name: menu_menuitemtranslation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.menu_menuitemtranslation_id_seq', 1, false);


    --
    -- Name: order_fulfillment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.order_fulfillment_id_seq', 34, true);


    --
    -- Name: order_fulfillmentline_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.order_fulfillmentline_id_seq', 49, true);


    --
    -- Name: order_order_gift_cards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.order_order_gift_cards_id_seq', 1, false);


    --
    -- Name: order_order_number_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.order_order_number_seq', 99, true);


    --
    -- Name: order_orderevent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.order_orderevent_id_seq', 1, false);


    --
    -- Name: order_ordergrantedrefund_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.order_ordergrantedrefund_id_seq', 1, false);


    --
    -- Name: order_ordergrantedrefundline_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.order_ordergrantedrefundline_id_seq', 1, false);


    --
    -- Name: page_page_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.page_page_id_seq', 3, true);


    --
    -- Name: page_pagetranslation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.page_pagetranslation_id_seq', 1, false);


    --
    -- Name: page_pagetype_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.page_pagetype_id_seq', 4, true);


    --
    -- Name: payment_paymentmethod_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.payment_paymentmethod_id_seq', 60, true);


    --
    -- Name: payment_transaction_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.payment_transaction_id_seq', 119, true);


    --
    -- Name: payment_transactionevent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.payment_transactionevent_id_seq', 1, false);


    --
    -- Name: payment_transactionitem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.payment_transactionitem_id_seq', 1, false);


    --
    -- Name: plugins_emailtemplate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.plugins_emailtemplate_id_seq', 1, false);


    --
    -- Name: plugins_pluginconfiguration_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.plugins_pluginconfiguration_id_seq', 1, false);


    --
    -- Name: product_assignedvariantattribute_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.product_assignedvariantattribute_id_seq', 191, true);


    --
    -- Name: product_attributechoicevalue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.product_attributechoicevalue_id_seq', 141, true);


    --
    -- Name: product_attributechoicevaluetranslation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.product_attributechoicevaluetranslation_id_seq', 1, false);


    --
    -- Name: product_attributepage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.product_attributepage_id_seq', 1, false);


    --
    -- Name: product_attributeproduct_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.product_attributeproduct_id_seq', 14, true);


    --
    -- Name: product_attributevariant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.product_attributevariant_id_seq', 15, true);


    --
    -- Name: product_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.product_category_id_seq', 44, true);


    --
    -- Name: product_categorytranslation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.product_categorytranslation_id_seq', 1, false);


    --
    -- Name: product_collection_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.product_collection_id_seq', 5, true);


    --
    -- Name: product_collection_products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.product_collection_products_id_seq', 17, true);


    --
    -- Name: product_collectionchannellisting_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.product_collectionchannellisting_id_seq', 10, true);


    --
    -- Name: product_collectiontranslation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.product_collectiontranslation_id_seq', 1, false);


    --
    -- Name: product_digitalcontent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.product_digitalcontent_id_seq', 1, false);


    --
    -- Name: product_digitalcontenturl_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.product_digitalcontenturl_id_seq', 1, false);


    --
    -- Name: product_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.product_product_id_seq', 164, true);


    --
    -- Name: product_productattribute_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.product_productattribute_id_seq', 43, true);


    --
    -- Name: product_productattributetranslation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.product_productattributetranslation_id_seq', 1, false);


    --
    -- Name: product_productchannellisting_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.product_productchannellisting_id_seq', 145, true);


    --
    -- Name: product_productclass_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.product_productclass_id_seq', 24, true);


    --
    -- Name: product_productmedia_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.product_productmedia_id_seq', 48, true);


    --
    -- Name: product_producttranslation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.product_producttranslation_id_seq', 1, false);


    --
    -- Name: product_productvariant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.product_productvariant_id_seq', 401, true);


    --
    -- Name: product_productvariantchannellisting_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.product_productvariantchannellisting_id_seq', 373, true);


    --
    -- Name: product_productvarianttranslation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.product_productvarianttranslation_id_seq', 1, false);


    --
    -- Name: product_variantchannellistingpromotionrule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.product_variantchannellistingpromotionrule_id_seq', 76, true);


    --
    -- Name: product_variantmedia_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.product_variantmedia_id_seq', 73, true);


    --
    -- Name: schedulers_customschedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.schedulers_customschedule_id_seq', 1, false);


    --
    -- Name: shipping_shippingmethod_excluded_products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.shipping_shippingmethod_excluded_products_id_seq', 1, false);


    --
    -- Name: shipping_shippingmethod_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.shipping_shippingmethod_id_seq', 58, true);


    --
    -- Name: shipping_shippingmethodchannellisting_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.shipping_shippingmethodchannellisting_id_seq', 172, true);


    --
    -- Name: shipping_shippingmethodtranslation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.shipping_shippingmethodtranslation_id_seq', 1, false);


    --
    -- Name: shipping_shippingmethodzipcoderule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.shipping_shippingmethodzipcoderule_id_seq', 1, false);


    --
    -- Name: shipping_shippingzone_channels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.shipping_shippingzone_channels_id_seq', 16, true);


    --
    -- Name: shipping_shippingzone_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.shipping_shippingzone_id_seq', 6, true);


    --
    -- Name: site_sitesettings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.site_sitesettings_id_seq', 1, true);


    --
    -- Name: site_sitesettingstranslation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.site_sitesettingstranslation_id_seq', 1, false);


    --
    -- Name: tax_taxclass_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.tax_taxclass_id_seq', 6, true);


    --
    -- Name: tax_taxclasscountryrate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.tax_taxclasscountryrate_id_seq', 1, false);


    --
    -- Name: tax_taxconfiguration_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.tax_taxconfiguration_id_seq', 3, true);


    --
    -- Name: tax_taxconfigurationpercountry_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.tax_taxconfigurationpercountry_id_seq', 1, false);


    --
    -- Name: thumbnail_thumbnail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.thumbnail_thumbnail_id_seq', 1, false);


    --
    -- Name: userprofile_address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.userprofile_address_id_seq', 209, true);


    --
    -- Name: userprofile_user_addresses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.userprofile_user_addresses_id_seq', 144, true);


    --
    -- Name: userprofile_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.userprofile_user_groups_id_seq', 63, true);


    --
    -- Name: userprofile_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.userprofile_user_id_seq', 142, true);


    --
    -- Name: userprofile_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.userprofile_user_user_permissions_id_seq', 1, false);


    --
    -- Name: warehouse_allocation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.warehouse_allocation_id_seq', 147, true);


    --
    -- Name: warehouse_preorderallocation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.warehouse_preorderallocation_id_seq', 1, false);


    --
    -- Name: warehouse_preorderreservation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.warehouse_preorderreservation_id_seq', 1, false);


    --
    -- Name: warehouse_reservation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.warehouse_reservation_id_seq', 1, false);


    --
    -- Name: warehouse_stock_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.warehouse_stock_id_seq', 584, true);


    --
    -- Name: warehouse_warehouse_channels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.warehouse_warehouse_channels_id_seq', 20, true);


    --
    -- Name: warehouse_warehouse_shipping_zones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.warehouse_warehouse_shipping_zones_id_seq', 8, true);


    --
    -- Name: webhook_webhook_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.webhook_webhook_id_seq', 1, false);


    --
    -- Name: webhook_webhookevent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: saleor
    --

    SELECT pg_catalog.setval('public.webhook_webhookevent_id_seq', 1, false);


    --
    -- Name: account_customerevent account_customerevent_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_customerevent
        ADD CONSTRAINT account_customerevent_pkey PRIMARY KEY (id);


    --
    -- Name: account_customernote account_customernote_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_customernote
        ADD CONSTRAINT account_customernote_pkey PRIMARY KEY (id);


    --
    -- Name: account_group_channels account_group_channels_group_id_channel_id_b6d749af_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_group_channels
        ADD CONSTRAINT account_group_channels_group_id_channel_id_b6d749af_uniq UNIQUE (group_id, channel_id);


    --
    -- Name: account_group_channels account_group_channels_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_group_channels
        ADD CONSTRAINT account_group_channels_pkey PRIMARY KEY (id);


    --
    -- Name: account_group account_group_name_key; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_group
        ADD CONSTRAINT account_group_name_key UNIQUE (name);


    --
    -- Name: account_group_permissions account_group_permissions_group_id_permission_id_745742e5_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_group_permissions
        ADD CONSTRAINT account_group_permissions_group_id_permission_id_745742e5_uniq UNIQUE (group_id, permission_id);


    --
    -- Name: account_group_permissions account_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_group_permissions
        ADD CONSTRAINT account_group_permissions_pkey PRIMARY KEY (id);


    --
    -- Name: account_group account_group_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_group
        ADD CONSTRAINT account_group_pkey PRIMARY KEY (id);


    --
    -- Name: app_app account_serviceaccount_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.app_app
        ADD CONSTRAINT account_serviceaccount_pkey PRIMARY KEY (id);


    --
    -- Name: app_apptoken account_serviceaccounttoken_auth_token_key; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.app_apptoken
        ADD CONSTRAINT account_serviceaccounttoken_auth_token_key UNIQUE (auth_token);


    --
    -- Name: app_apptoken account_serviceaccounttoken_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.app_apptoken
        ADD CONSTRAINT account_serviceaccounttoken_pkey PRIMARY KEY (id);


    --
    -- Name: account_staffnotificationrecipient account_staffnotificationrecipient_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_staffnotificationrecipient
        ADD CONSTRAINT account_staffnotificationrecipient_pkey PRIMARY KEY (id);


    --
    -- Name: account_staffnotificationrecipient account_staffnotificationrecipient_staff_email_key; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_staffnotificationrecipient
        ADD CONSTRAINT account_staffnotificationrecipient_staff_email_key UNIQUE (staff_email);


    --
    -- Name: account_staffnotificationrecipient account_staffnotificationrecipient_user_id_key; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_staffnotificationrecipient
        ADD CONSTRAINT account_staffnotificationrecipient_user_id_key UNIQUE (user_id);


    --
    -- Name: account_user account_user_external_reference_key; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_user
        ADD CONSTRAINT account_user_external_reference_key UNIQUE (external_reference);


    --
    -- Name: account_user account_user_uuid_b4063ea1_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_user
        ADD CONSTRAINT account_user_uuid_b4063ea1_uniq UNIQUE (uuid);


    --
    -- Name: app_app_permissions app_app_permissions_app_id_permission_id_0e940a82_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.app_app_permissions
        ADD CONSTRAINT app_app_permissions_app_id_permission_id_0e940a82_uniq UNIQUE (app_id, permission_id);


    --
    -- Name: app_app_permissions app_app_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.app_app_permissions
        ADD CONSTRAINT app_app_permissions_pkey PRIMARY KEY (id);


    --
    -- Name: app_app app_app_uuid_key; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.app_app
        ADD CONSTRAINT app_app_uuid_key UNIQUE (uuid);


    --
    -- Name: app_appextension_permissions app_appextension_permiss_appextension_id_permissi_04ce63c6_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.app_appextension_permissions
        ADD CONSTRAINT app_appextension_permiss_appextension_id_permissi_04ce63c6_uniq UNIQUE (appextension_id, permission_id);


    --
    -- Name: app_appextension_permissions app_appextension_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.app_appextension_permissions
        ADD CONSTRAINT app_appextension_permissions_pkey PRIMARY KEY (id);


    --
    -- Name: app_appextension app_appextension_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.app_appextension
        ADD CONSTRAINT app_appextension_pkey PRIMARY KEY (id);


    --
    -- Name: app_appinstallation_permissions app_appinstallation_perm_appinstallation_id_permi_7b7e0448_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.app_appinstallation_permissions
        ADD CONSTRAINT app_appinstallation_perm_appinstallation_id_permi_7b7e0448_uniq UNIQUE (appinstallation_id, permission_id);


    --
    -- Name: app_appinstallation_permissions app_appinstallation_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.app_appinstallation_permissions
        ADD CONSTRAINT app_appinstallation_permissions_pkey PRIMARY KEY (id);


    --
    -- Name: app_appinstallation app_appinstallation_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.app_appinstallation
        ADD CONSTRAINT app_appinstallation_pkey PRIMARY KEY (id);


    --
    -- Name: app_appinstallation app_appinstallation_uuid_key; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.app_appinstallation
        ADD CONSTRAINT app_appinstallation_uuid_key UNIQUE (uuid);


    --
    -- Name: attribute_assignedpageattributevalue attribute_assignedpageattributevalue_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_assignedpageattributevalue
        ADD CONSTRAINT attribute_assignedpageattributevalue_pkey PRIMARY KEY (id);


    --
    -- Name: attribute_assignedproductattributevalue attribute_assignedproductattributevalue_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_assignedproductattributevalue
        ADD CONSTRAINT attribute_assignedproductattributevalue_pkey PRIMARY KEY (id);


    --
    -- Name: attribute_assignedvariantattributevalue attribute_assignedvarian_value_id_assignment_id_6f7e4e27_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_assignedvariantattributevalue
        ADD CONSTRAINT attribute_assignedvarian_value_id_assignment_id_6f7e4e27_uniq UNIQUE (value_id, assignment_id);


    --
    -- Name: attribute_assignedvariantattributevalue attribute_assignedvariantattributevalue_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_assignedvariantattributevalue
        ADD CONSTRAINT attribute_assignedvariantattributevalue_pkey PRIMARY KEY (id);


    --
    -- Name: attribute_attribute attribute_attribute_external_reference_key; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_attribute
        ADD CONSTRAINT attribute_attribute_external_reference_key UNIQUE (external_reference);


    --
    -- Name: attribute_attributevalue attribute_attributevalue_external_reference_key; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_attributevalue
        ADD CONSTRAINT attribute_attributevalue_external_reference_key UNIQUE (external_reference);


    --
    -- Name: checkout_checkout cart_cart_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.checkout_checkout
        ADD CONSTRAINT cart_cart_pkey PRIMARY KEY (token);


    --
    -- Name: channel_channel channel_channel_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.channel_channel
        ADD CONSTRAINT channel_channel_pkey PRIMARY KEY (id);


    --
    -- Name: channel_channel channel_channel_slug_key; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.channel_channel
        ADD CONSTRAINT channel_channel_slug_key UNIQUE (slug);


    --
    -- Name: checkout_checkout_gift_cards checkout_checkout_gift_c_checkout_id_giftcard_id_401ba79e_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.checkout_checkout_gift_cards
        ADD CONSTRAINT checkout_checkout_gift_c_checkout_id_giftcard_id_401ba79e_uniq UNIQUE (checkout_id, giftcard_id);


    --
    -- Name: checkout_checkout_gift_cards checkout_checkout_gift_cards_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.checkout_checkout_gift_cards
        ADD CONSTRAINT checkout_checkout_gift_cards_pkey PRIMARY KEY (id);


    --
    -- Name: checkout_checkoutline checkout_checkoutline_old_id_key; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.checkout_checkoutline
        ADD CONSTRAINT checkout_checkoutline_old_id_key UNIQUE (old_id);


    --
    -- Name: checkout_checkoutline checkout_checkoutline_token_bc62c7b0_pk; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.checkout_checkoutline
        ADD CONSTRAINT checkout_checkoutline_token_bc62c7b0_pk PRIMARY KEY (id);


    --
    -- Name: checkout_checkoutmetadata checkout_checkoutmetadata_checkout_id_key; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.checkout_checkoutmetadata
        ADD CONSTRAINT checkout_checkoutmetadata_checkout_id_key UNIQUE (checkout_id);


    --
    -- Name: checkout_checkoutmetadata checkout_checkoutmetadata_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.checkout_checkoutmetadata
        ADD CONSTRAINT checkout_checkoutmetadata_pkey PRIMARY KEY (id);


    --
    -- Name: core_eventdelivery core_eventdelivery_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.core_eventdelivery
        ADD CONSTRAINT core_eventdelivery_pkey PRIMARY KEY (id);


    --
    -- Name: core_eventdeliveryattempt core_eventdeliveryattempt_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.core_eventdeliveryattempt
        ADD CONSTRAINT core_eventdeliveryattempt_pkey PRIMARY KEY (id);


    --
    -- Name: core_eventpayload core_eventpayload_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.core_eventpayload
        ADD CONSTRAINT core_eventpayload_pkey PRIMARY KEY (id);


    --
    -- Name: csv_exportevent csv_exportevent_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.csv_exportevent
        ADD CONSTRAINT csv_exportevent_pkey PRIMARY KEY (id);


    --
    -- Name: csv_exportfile csv_exportfile_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.csv_exportfile
        ADD CONSTRAINT csv_exportfile_pkey PRIMARY KEY (id);


    --
    -- Name: discount_checkoutdiscount discount_checkoutdiscoun_checkout_id_promotion_ru_d2e697fb_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_checkoutdiscount
        ADD CONSTRAINT discount_checkoutdiscoun_checkout_id_promotion_ru_d2e697fb_uniq UNIQUE (checkout_id, promotion_rule_id);


    --
    -- Name: discount_checkoutdiscount discount_checkoutdiscount_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_checkoutdiscount
        ADD CONSTRAINT discount_checkoutdiscount_pkey PRIMARY KEY (id);


    --
    -- Name: discount_checkoutlinediscount discount_checkoutlinediscount_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_checkoutlinediscount
        ADD CONSTRAINT discount_checkoutlinediscount_pkey PRIMARY KEY (id);


    --
    -- Name: discount_orderdiscount discount_orderdiscount_old_id_key; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_orderdiscount
        ADD CONSTRAINT discount_orderdiscount_old_id_key UNIQUE (old_id);


    --
    -- Name: discount_orderdiscount discount_orderdiscount_token_e629a3e0_pk; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_orderdiscount
        ADD CONSTRAINT discount_orderdiscount_token_e629a3e0_pk PRIMARY KEY (id);


    --
    -- Name: discount_orderlinediscount discount_orderlinediscount_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_orderlinediscount
        ADD CONSTRAINT discount_orderlinediscount_pkey PRIMARY KEY (id);


    --
    -- Name: discount_promotion discount_promotion_old_sale_id_key; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_promotion
        ADD CONSTRAINT discount_promotion_old_sale_id_key UNIQUE (old_sale_id);


    --
    -- Name: discount_promotion discount_promotion_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_promotion
        ADD CONSTRAINT discount_promotion_pkey PRIMARY KEY (id);


    --
    -- Name: discount_promotionevent discount_promotionevent_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_promotionevent
        ADD CONSTRAINT discount_promotionevent_pkey PRIMARY KEY (id);


    --
    -- Name: discount_promotionrule_channels discount_promotionrule_c_promotionrule_id_channel_561c4e6e_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_promotionrule_channels
        ADD CONSTRAINT discount_promotionrule_c_promotionrule_id_channel_561c4e6e_uniq UNIQUE (promotionrule_id, channel_id);


    --
    -- Name: discount_promotionrule_channels discount_promotionrule_channels_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_promotionrule_channels
        ADD CONSTRAINT discount_promotionrule_channels_pkey PRIMARY KEY (id);


    --
    -- Name: discount_promotionrule_gifts discount_promotionrule_g_promotionrule_id_product_d7f5da3b_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_promotionrule_gifts
        ADD CONSTRAINT discount_promotionrule_g_promotionrule_id_product_d7f5da3b_uniq UNIQUE (promotionrule_id, productvariant_id);


    --
    -- Name: discount_promotionrule_gifts discount_promotionrule_gifts_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_promotionrule_gifts
        ADD CONSTRAINT discount_promotionrule_gifts_pkey PRIMARY KEY (id);


    --
    -- Name: discount_promotionrule discount_promotionrule_old_channel_listing_id_key; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_promotionrule
        ADD CONSTRAINT discount_promotionrule_old_channel_listing_id_key UNIQUE (old_channel_listing_id);


    --
    -- Name: discount_promotionrule discount_promotionrule_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_promotionrule
        ADD CONSTRAINT discount_promotionrule_pkey PRIMARY KEY (id);


    --
    -- Name: discount_promotionrule_variants discount_promotionrule_v_promotionrule_id_product_017c4f65_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_promotionrule_variants
        ADD CONSTRAINT discount_promotionrule_v_promotionrule_id_product_017c4f65_uniq UNIQUE (promotionrule_id, productvariant_id);


    --
    -- Name: discount_promotionrule_variants discount_promotionrule_variants_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_promotionrule_variants
        ADD CONSTRAINT discount_promotionrule_variants_pkey PRIMARY KEY (id);


    --
    -- Name: discount_promotionruletranslation discount_promotionruletr_language_code_promotion__1b8b92f9_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_promotionruletranslation
        ADD CONSTRAINT discount_promotionruletr_language_code_promotion__1b8b92f9_uniq UNIQUE (language_code, promotion_rule_id);


    --
    -- Name: discount_promotionruletranslation discount_promotionruletranslation_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_promotionruletranslation
        ADD CONSTRAINT discount_promotionruletranslation_pkey PRIMARY KEY (id);


    --
    -- Name: discount_promotiontranslation discount_promotiontransl_language_code_promotion__a7ac2f7b_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_promotiontranslation
        ADD CONSTRAINT discount_promotiontransl_language_code_promotion__a7ac2f7b_uniq UNIQUE (language_code, promotion_id);


    --
    -- Name: discount_promotiontranslation discount_promotiontranslation_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_promotiontranslation
        ADD CONSTRAINT discount_promotiontranslation_pkey PRIMARY KEY (id);


    --
    -- Name: discount_voucher_categories discount_voucher_categor_voucher_id_category_id_bb5f8954_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_voucher_categories
        ADD CONSTRAINT discount_voucher_categor_voucher_id_category_id_bb5f8954_uniq UNIQUE (voucher_id, category_id);


    --
    -- Name: discount_voucher_categories discount_voucher_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_voucher_categories
        ADD CONSTRAINT discount_voucher_categories_pkey PRIMARY KEY (id);


    --
    -- Name: discount_voucher_collections discount_voucher_collect_voucher_id_collection_id_736b8f24_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_voucher_collections
        ADD CONSTRAINT discount_voucher_collect_voucher_id_collection_id_736b8f24_uniq UNIQUE (voucher_id, collection_id);


    --
    -- Name: discount_voucher_collections discount_voucher_collections_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_voucher_collections
        ADD CONSTRAINT discount_voucher_collections_pkey PRIMARY KEY (id);


    --
    -- Name: discount_voucher discount_voucher_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_voucher
        ADD CONSTRAINT discount_voucher_pkey PRIMARY KEY (id);


    --
    -- Name: discount_voucher_products discount_voucher_products_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_voucher_products
        ADD CONSTRAINT discount_voucher_products_pkey PRIMARY KEY (id);


    --
    -- Name: discount_voucher_products discount_voucher_products_voucher_id_product_id_2b092ec4_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_voucher_products
        ADD CONSTRAINT discount_voucher_products_voucher_id_product_id_2b092ec4_uniq UNIQUE (voucher_id, product_id);


    --
    -- Name: discount_voucher_variants discount_voucher_variant_voucher_id_productvarian_64886a32_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_voucher_variants
        ADD CONSTRAINT discount_voucher_variant_voucher_id_productvarian_64886a32_uniq UNIQUE (voucher_id, productvariant_id);


    --
    -- Name: discount_voucher_variants discount_voucher_variants_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_voucher_variants
        ADD CONSTRAINT discount_voucher_variants_pkey PRIMARY KEY (id);


    --
    -- Name: discount_voucherchannellisting discount_voucherchannell_voucher_id_channel_id_ef4fd653_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_voucherchannellisting
        ADD CONSTRAINT discount_voucherchannell_voucher_id_channel_id_ef4fd653_uniq UNIQUE (voucher_id, channel_id);


    --
    -- Name: discount_voucherchannellisting discount_voucherchannellisting_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_voucherchannellisting
        ADD CONSTRAINT discount_voucherchannellisting_pkey PRIMARY KEY (id);


    --
    -- Name: discount_vouchercode discount_vouchercode_code_key; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_vouchercode
        ADD CONSTRAINT discount_vouchercode_code_key UNIQUE (code);


    --
    -- Name: discount_vouchercode discount_vouchercode_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_vouchercode
        ADD CONSTRAINT discount_vouchercode_pkey PRIMARY KEY (id);


    --
    -- Name: discount_vouchercustomer discount_vouchercustomer_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_vouchercustomer
        ADD CONSTRAINT discount_vouchercustomer_pkey PRIMARY KEY (id);


    --
    -- Name: discount_vouchercustomer discount_vouchercustomer_voucher_code_id_customer_4411499e_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_vouchercustomer
        ADD CONSTRAINT discount_vouchercustomer_voucher_code_id_customer_4411499e_uniq UNIQUE (voucher_code_id, customer_email);


    --
    -- Name: discount_vouchertranslation discount_vouchertranslat_language_code_voucher_id_af4428b5_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_vouchertranslation
        ADD CONSTRAINT discount_vouchertranslat_language_code_voucher_id_af4428b5_uniq UNIQUE (language_code, voucher_id);


    --
    -- Name: discount_vouchertranslation discount_vouchertranslation_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_vouchertranslation
        ADD CONSTRAINT discount_vouchertranslation_pkey PRIMARY KEY (id);


    --
    -- Name: django_celery_beat_clockedschedule django_celery_beat_clockedschedule_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.django_celery_beat_clockedschedule
        ADD CONSTRAINT django_celery_beat_clockedschedule_pkey PRIMARY KEY (id);


    --
    -- Name: django_celery_beat_crontabschedule django_celery_beat_crontabschedule_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.django_celery_beat_crontabschedule
        ADD CONSTRAINT django_celery_beat_crontabschedule_pkey PRIMARY KEY (id);


    --
    -- Name: django_celery_beat_intervalschedule django_celery_beat_intervalschedule_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.django_celery_beat_intervalschedule
        ADD CONSTRAINT django_celery_beat_intervalschedule_pkey PRIMARY KEY (id);


    --
    -- Name: django_celery_beat_periodictask django_celery_beat_periodictask_name_key; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.django_celery_beat_periodictask
        ADD CONSTRAINT django_celery_beat_periodictask_name_key UNIQUE (name);


    --
    -- Name: django_celery_beat_periodictask django_celery_beat_periodictask_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.django_celery_beat_periodictask
        ADD CONSTRAINT django_celery_beat_periodictask_pkey PRIMARY KEY (id);


    --
    -- Name: django_celery_beat_periodictasks django_celery_beat_periodictasks_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.django_celery_beat_periodictasks
        ADD CONSTRAINT django_celery_beat_periodictasks_pkey PRIMARY KEY (ident);


    --
    -- Name: django_celery_beat_solarschedule django_celery_beat_solar_event_latitude_longitude_ba64999a_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.django_celery_beat_solarschedule
        ADD CONSTRAINT django_celery_beat_solar_event_latitude_longitude_ba64999a_uniq UNIQUE (event, latitude, longitude);


    --
    -- Name: django_celery_beat_solarschedule django_celery_beat_solarschedule_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.django_celery_beat_solarschedule
        ADD CONSTRAINT django_celery_beat_solarschedule_pkey PRIMARY KEY (id);


    --
    -- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.django_content_type
        ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


    --
    -- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.django_content_type
        ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


    --
    -- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.django_migrations
        ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


    --
    -- Name: django_site django_site_domain_a2e37b91_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.django_site
        ADD CONSTRAINT django_site_domain_a2e37b91_uniq UNIQUE (domain);


    --
    -- Name: django_site django_site_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.django_site
        ADD CONSTRAINT django_site_pkey PRIMARY KEY (id);


    --
    -- Name: giftcard_giftcard giftcard_giftcard_code_key; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.giftcard_giftcard
        ADD CONSTRAINT giftcard_giftcard_code_key UNIQUE (code);


    --
    -- Name: giftcard_giftcard giftcard_giftcard_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.giftcard_giftcard
        ADD CONSTRAINT giftcard_giftcard_pkey PRIMARY KEY (id);


    --
    -- Name: giftcard_giftcard_tags giftcard_giftcard_tags_giftcard_id_giftcardtag_id_c8db8a75_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.giftcard_giftcard_tags
        ADD CONSTRAINT giftcard_giftcard_tags_giftcard_id_giftcardtag_id_c8db8a75_uniq UNIQUE (giftcard_id, giftcardtag_id);


    --
    -- Name: giftcard_giftcard_tags giftcard_giftcard_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.giftcard_giftcard_tags
        ADD CONSTRAINT giftcard_giftcard_tags_pkey PRIMARY KEY (id);


    --
    -- Name: giftcard_giftcardevent giftcard_giftcardevent_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.giftcard_giftcardevent
        ADD CONSTRAINT giftcard_giftcardevent_pkey PRIMARY KEY (id);


    --
    -- Name: giftcard_giftcardtag giftcard_giftcardtag_name_key; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.giftcard_giftcardtag
        ADD CONSTRAINT giftcard_giftcardtag_name_key UNIQUE (name);


    --
    -- Name: giftcard_giftcardtag giftcard_giftcardtag_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.giftcard_giftcardtag
        ADD CONSTRAINT giftcard_giftcardtag_pkey PRIMARY KEY (id);


    --
    -- Name: invoice_invoice invoice_invoice_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.invoice_invoice
        ADD CONSTRAINT invoice_invoice_pkey PRIMARY KEY (id);


    --
    -- Name: invoice_invoiceevent invoice_invoiceevent_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.invoice_invoiceevent
        ADD CONSTRAINT invoice_invoiceevent_pkey PRIMARY KEY (id);


    --
    -- Name: menu_menu menu_menu_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.menu_menu
        ADD CONSTRAINT menu_menu_pkey PRIMARY KEY (id);


    --
    -- Name: menu_menu menu_menu_slug_key; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.menu_menu
        ADD CONSTRAINT menu_menu_slug_key UNIQUE (slug);


    --
    -- Name: menu_menuitem menu_menuitem_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.menu_menuitem
        ADD CONSTRAINT menu_menuitem_pkey PRIMARY KEY (id);


    --
    -- Name: menu_menuitemtranslation menu_menuitemtranslation_language_code_menu_item__508dcdd8_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.menu_menuitemtranslation
        ADD CONSTRAINT menu_menuitemtranslation_language_code_menu_item__508dcdd8_uniq UNIQUE (language_code, menu_item_id);


    --
    -- Name: menu_menuitemtranslation menu_menuitemtranslation_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.menu_menuitemtranslation
        ADD CONSTRAINT menu_menuitemtranslation_pkey PRIMARY KEY (id);


    --
    -- Name: order_fulfillment order_fulfillment_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_fulfillment
        ADD CONSTRAINT order_fulfillment_pkey PRIMARY KEY (id);


    --
    -- Name: order_fulfillmentline order_fulfillmentline_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_fulfillmentline
        ADD CONSTRAINT order_fulfillmentline_pkey PRIMARY KEY (id);


    --
    -- Name: order_order order_order_external_reference_key; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_order
        ADD CONSTRAINT order_order_external_reference_key UNIQUE (external_reference);


    --
    -- Name: order_order_gift_cards order_order_gift_cards_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_order_gift_cards
        ADD CONSTRAINT order_order_gift_cards_pkey PRIMARY KEY (id);


    --
    -- Name: order_order order_order_number_49f06f1b_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_order
        ADD CONSTRAINT order_order_number_49f06f1b_uniq UNIQUE (number);


    --
    -- Name: order_order order_order_token_ddb7fb7b_pk; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_order
        ADD CONSTRAINT order_order_token_ddb7fb7b_pk PRIMARY KEY (id);


    --
    -- Name: order_orderevent order_orderevent_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_orderevent
        ADD CONSTRAINT order_orderevent_pkey PRIMARY KEY (id);


    --
    -- Name: order_ordergrantedrefund order_ordergrantedrefund_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_ordergrantedrefund
        ADD CONSTRAINT order_ordergrantedrefund_pkey PRIMARY KEY (id);


    --
    -- Name: order_ordergrantedrefundline order_ordergrantedrefundline_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_ordergrantedrefundline
        ADD CONSTRAINT order_ordergrantedrefundline_pkey PRIMARY KEY (id);


    --
    -- Name: order_orderline order_orderline_old_id_1da97079_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_orderline
        ADD CONSTRAINT order_orderline_old_id_1da97079_uniq UNIQUE (old_id);


    --
    -- Name: order_orderline order_orderline_token_47c4393d_pk; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_orderline
        ADD CONSTRAINT order_orderline_token_47c4393d_pk PRIMARY KEY (id);


    --
    -- Name: page_page page_page_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.page_page
        ADD CONSTRAINT page_page_pkey PRIMARY KEY (id);


    --
    -- Name: page_page page_page_slug_key; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.page_page
        ADD CONSTRAINT page_page_slug_key UNIQUE (slug);


    --
    -- Name: page_pagetranslation page_pagetranslation_language_code_page_id_35685962_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.page_pagetranslation
        ADD CONSTRAINT page_pagetranslation_language_code_page_id_35685962_uniq UNIQUE (language_code, page_id);


    --
    -- Name: page_pagetranslation page_pagetranslation_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.page_pagetranslation
        ADD CONSTRAINT page_pagetranslation_pkey PRIMARY KEY (id);


    --
    -- Name: page_pagetype page_pagetype_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.page_pagetype
        ADD CONSTRAINT page_pagetype_pkey PRIMARY KEY (id);


    --
    -- Name: page_pagetype page_pagetype_slug_key; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.page_pagetype
        ADD CONSTRAINT page_pagetype_slug_key UNIQUE (slug);


    --
    -- Name: payment_payment payment_paymentmethod_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.payment_payment
        ADD CONSTRAINT payment_paymentmethod_pkey PRIMARY KEY (id);


    --
    -- Name: payment_transaction payment_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.payment_transaction
        ADD CONSTRAINT payment_transaction_pkey PRIMARY KEY (id);


    --
    -- Name: payment_transactionevent payment_transactionevent_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.payment_transactionevent
        ADD CONSTRAINT payment_transactionevent_pkey PRIMARY KEY (id);


    --
    -- Name: payment_transactionitem payment_transactionitem_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.payment_transactionitem
        ADD CONSTRAINT payment_transactionitem_pkey PRIMARY KEY (id);


    --
    -- Name: payment_transactionitem payment_transactionitem_token_key; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.payment_transactionitem
        ADD CONSTRAINT payment_transactionitem_token_key UNIQUE (token);


    --
    -- Name: permission_permission permission_permission_content_type_id_codename_aa582bb6_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.permission_permission
        ADD CONSTRAINT permission_permission_content_type_id_codename_aa582bb6_uniq UNIQUE (content_type_id, codename);


    --
    -- Name: permission_permission permission_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.permission_permission
        ADD CONSTRAINT permission_permission_pkey PRIMARY KEY (id);


    --
    -- Name: plugins_emailtemplate plugins_emailtemplate_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.plugins_emailtemplate
        ADD CONSTRAINT plugins_emailtemplate_pkey PRIMARY KEY (id);


    --
    -- Name: plugins_pluginconfiguration plugins_pluginconfiguration_identifier_channel_id_c4cc3730_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.plugins_pluginconfiguration
        ADD CONSTRAINT plugins_pluginconfiguration_identifier_channel_id_c4cc3730_uniq UNIQUE (identifier, channel_id);


    --
    -- Name: plugins_pluginconfiguration plugins_pluginconfiguration_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.plugins_pluginconfiguration
        ADD CONSTRAINT plugins_pluginconfiguration_pkey PRIMARY KEY (id);


    --
    -- Name: attribute_assignedvariantattribute product_assignedvarianta_variant_id_assignment_id_16584418_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_assignedvariantattribute
        ADD CONSTRAINT product_assignedvarianta_variant_id_assignment_id_16584418_uniq UNIQUE (variant_id, assignment_id);


    --
    -- Name: attribute_assignedvariantattribute product_assignedvariantattribute_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_assignedvariantattribute
        ADD CONSTRAINT product_assignedvariantattribute_pkey PRIMARY KEY (id);


    --
    -- Name: attribute_attribute product_attribute_slug_a2ba35f2_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_attribute
        ADD CONSTRAINT product_attribute_slug_a2ba35f2_uniq UNIQUE (slug);


    --
    -- Name: attribute_attributevaluetranslation product_attributechoicev_language_code_attribute__9b58af18_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_attributevaluetranslation
        ADD CONSTRAINT product_attributechoicev_language_code_attribute__9b58af18_uniq UNIQUE (language_code, attribute_value_id);


    --
    -- Name: attribute_attributevalue product_attributechoicevalue_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_attributevalue
        ADD CONSTRAINT product_attributechoicevalue_pkey PRIMARY KEY (id);


    --
    -- Name: attribute_attributevaluetranslation product_attributechoicevaluetranslation_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_attributevaluetranslation
        ADD CONSTRAINT product_attributechoicevaluetranslation_pkey PRIMARY KEY (id);


    --
    -- Name: attribute_attributepage product_attributepage_attribute_id_page_type_id_60aa672e_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_attributepage
        ADD CONSTRAINT product_attributepage_attribute_id_page_type_id_60aa672e_uniq UNIQUE (attribute_id, page_type_id);


    --
    -- Name: attribute_attributepage product_attributepage_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_attributepage
        ADD CONSTRAINT product_attributepage_pkey PRIMARY KEY (id);


    --
    -- Name: attribute_attributeproduct product_attributeproduct_attribute_id_product_typ_85ea87be_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_attributeproduct
        ADD CONSTRAINT product_attributeproduct_attribute_id_product_typ_85ea87be_uniq UNIQUE (attribute_id, product_type_id);


    --
    -- Name: attribute_attributeproduct product_attributeproduct_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_attributeproduct
        ADD CONSTRAINT product_attributeproduct_pkey PRIMARY KEY (id);


    --
    -- Name: attribute_attributevalue product_attributevalue_slug_attribute_id_a9b19472_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_attributevalue
        ADD CONSTRAINT product_attributevalue_slug_attribute_id_a9b19472_uniq UNIQUE (slug, attribute_id);


    --
    -- Name: attribute_attributevariant product_attributevariant_attribute_id_product_typ_304d6c95_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_attributevariant
        ADD CONSTRAINT product_attributevariant_attribute_id_product_typ_304d6c95_uniq UNIQUE (attribute_id, product_type_id);


    --
    -- Name: attribute_attributevariant product_attributevariant_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_attributevariant
        ADD CONSTRAINT product_attributevariant_pkey PRIMARY KEY (id);


    --
    -- Name: product_category product_category_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_category
        ADD CONSTRAINT product_category_pkey PRIMARY KEY (id);


    --
    -- Name: product_category product_category_slug_e1f8ccc4_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_category
        ADD CONSTRAINT product_category_slug_e1f8ccc4_uniq UNIQUE (slug);


    --
    -- Name: product_categorytranslation product_categorytranslat_language_code_category_i_f71fd11d_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_categorytranslation
        ADD CONSTRAINT product_categorytranslat_language_code_category_i_f71fd11d_uniq UNIQUE (language_code, category_id);


    --
    -- Name: product_categorytranslation product_categorytranslation_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_categorytranslation
        ADD CONSTRAINT product_categorytranslation_pkey PRIMARY KEY (id);


    --
    -- Name: product_collection product_collection_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_collection
        ADD CONSTRAINT product_collection_pkey PRIMARY KEY (id);


    --
    -- Name: product_collectionproduct product_collection_products_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_collectionproduct
        ADD CONSTRAINT product_collection_products_pkey PRIMARY KEY (id);


    --
    -- Name: product_collection product_collection_slug_ec186116_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_collection
        ADD CONSTRAINT product_collection_slug_ec186116_uniq UNIQUE (slug);


    --
    -- Name: product_collectionchannellisting product_collectionchanne_collection_id_channel_id_43d58a4f_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_collectionchannellisting
        ADD CONSTRAINT product_collectionchanne_collection_id_channel_id_43d58a4f_uniq UNIQUE (collection_id, channel_id);


    --
    -- Name: product_collectionchannellisting product_collectionchannellisting_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_collectionchannellisting
        ADD CONSTRAINT product_collectionchannellisting_pkey PRIMARY KEY (id);


    --
    -- Name: product_collectionproduct product_collectionproduc_collection_id_product_id_e582d799_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_collectionproduct
        ADD CONSTRAINT product_collectionproduc_collection_id_product_id_e582d799_uniq UNIQUE (collection_id, product_id);


    --
    -- Name: product_collectiontranslation product_collectiontransl_language_code_collection_b1200cd5_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_collectiontranslation
        ADD CONSTRAINT product_collectiontransl_language_code_collection_b1200cd5_uniq UNIQUE (language_code, collection_id);


    --
    -- Name: product_collectiontranslation product_collectiontranslation_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_collectiontranslation
        ADD CONSTRAINT product_collectiontranslation_pkey PRIMARY KEY (id);


    --
    -- Name: product_digitalcontent product_digitalcontent_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_digitalcontent
        ADD CONSTRAINT product_digitalcontent_pkey PRIMARY KEY (id);


    --
    -- Name: product_digitalcontent product_digitalcontent_product_variant_id_key; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_digitalcontent
        ADD CONSTRAINT product_digitalcontent_product_variant_id_key UNIQUE (product_variant_id);


    --
    -- Name: product_digitalcontenturl product_digitalcontenturl_order_line_token_id_6f89be20_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_digitalcontenturl
        ADD CONSTRAINT product_digitalcontenturl_order_line_token_id_6f89be20_uniq UNIQUE (line_id);


    --
    -- Name: product_digitalcontenturl product_digitalcontenturl_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_digitalcontenturl
        ADD CONSTRAINT product_digitalcontenturl_pkey PRIMARY KEY (id);


    --
    -- Name: product_digitalcontenturl product_digitalcontenturl_token_key; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_digitalcontenturl
        ADD CONSTRAINT product_digitalcontenturl_token_key UNIQUE (token);


    --
    -- Name: product_product product_product_default_variant_id_key; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_product
        ADD CONSTRAINT product_product_default_variant_id_key UNIQUE (default_variant_id);


    --
    -- Name: product_product product_product_external_reference_key; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_product
        ADD CONSTRAINT product_product_external_reference_key UNIQUE (external_reference);


    --
    -- Name: product_product product_product_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_product
        ADD CONSTRAINT product_product_pkey PRIMARY KEY (id);


    --
    -- Name: product_product product_product_slug_key; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_product
        ADD CONSTRAINT product_product_slug_key UNIQUE (slug);


    --
    -- Name: attribute_attributetranslation product_productattribute_language_code_product_at_58451db2_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_attributetranslation
        ADD CONSTRAINT product_productattribute_language_code_product_at_58451db2_uniq UNIQUE (language_code, attribute_id);


    --
    -- Name: attribute_attribute product_productattribute_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_attribute
        ADD CONSTRAINT product_productattribute_pkey PRIMARY KEY (id);


    --
    -- Name: attribute_attributetranslation product_productattributetranslation_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_attributetranslation
        ADD CONSTRAINT product_productattributetranslation_pkey PRIMARY KEY (id);


    --
    -- Name: product_productchannellisting product_productchannelli_product_id_channel_id_f50170b5_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_productchannellisting
        ADD CONSTRAINT product_productchannelli_product_id_channel_id_f50170b5_uniq UNIQUE (product_id, channel_id);


    --
    -- Name: product_productchannellisting product_productchannellisting_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_productchannellisting
        ADD CONSTRAINT product_productchannellisting_pkey PRIMARY KEY (id);


    --
    -- Name: product_producttype product_productclass_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_producttype
        ADD CONSTRAINT product_productclass_pkey PRIMARY KEY (id);


    --
    -- Name: product_productmedia product_productmedia_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_productmedia
        ADD CONSTRAINT product_productmedia_pkey PRIMARY KEY (id);


    --
    -- Name: product_producttranslation product_producttranslati_language_code_product_id_b06ba774_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_producttranslation
        ADD CONSTRAINT product_producttranslati_language_code_product_id_b06ba774_uniq UNIQUE (language_code, product_id);


    --
    -- Name: product_producttranslation product_producttranslation_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_producttranslation
        ADD CONSTRAINT product_producttranslation_pkey PRIMARY KEY (id);


    --
    -- Name: product_producttype product_producttype_slug_key; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_producttype
        ADD CONSTRAINT product_producttype_slug_key UNIQUE (slug);


    --
    -- Name: product_productvariant product_productvariant_external_reference_key; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_productvariant
        ADD CONSTRAINT product_productvariant_external_reference_key UNIQUE (external_reference);


    --
    -- Name: product_productvariant product_productvariant_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_productvariant
        ADD CONSTRAINT product_productvariant_pkey PRIMARY KEY (id);


    --
    -- Name: product_productvariant product_productvariant_sku_key; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_productvariant
        ADD CONSTRAINT product_productvariant_sku_key UNIQUE (sku);


    --
    -- Name: product_productvariantchannellisting product_productvariantch_variant_id_channel_id_123d5440_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_productvariantchannellisting
        ADD CONSTRAINT product_productvariantch_variant_id_channel_id_123d5440_uniq UNIQUE (variant_id, channel_id);


    --
    -- Name: product_productvariantchannellisting product_productvariantchannellisting_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_productvariantchannellisting
        ADD CONSTRAINT product_productvariantchannellisting_pkey PRIMARY KEY (id);


    --
    -- Name: product_productvarianttranslation product_productvarianttr_language_code_product_va_cf16d8d0_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_productvarianttranslation
        ADD CONSTRAINT product_productvarianttr_language_code_product_va_cf16d8d0_uniq UNIQUE (language_code, product_variant_id);


    --
    -- Name: product_productvarianttranslation product_productvarianttranslation_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_productvarianttranslation
        ADD CONSTRAINT product_productvarianttranslation_pkey PRIMARY KEY (id);


    --
    -- Name: product_variantchannellistingpromotionrule product_variantchannelli_variant_channel_listing__8f7a36d8_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_variantchannellistingpromotionrule
        ADD CONSTRAINT product_variantchannelli_variant_channel_listing__8f7a36d8_uniq UNIQUE (variant_channel_listing_id, promotion_rule_id);


    --
    -- Name: product_variantchannellistingpromotionrule product_variantchannellistingpromotionrule_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_variantchannellistingpromotionrule
        ADD CONSTRAINT product_variantchannellistingpromotionrule_pkey PRIMARY KEY (id);


    --
    -- Name: product_variantmedia product_variantmedia_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_variantmedia
        ADD CONSTRAINT product_variantmedia_pkey PRIMARY KEY (id);


    --
    -- Name: product_variantmedia product_variantmedia_variant_id_media_id_003e4321_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_variantmedia
        ADD CONSTRAINT product_variantmedia_variant_id_media_id_003e4321_uniq UNIQUE (variant_id, media_id);


    --
    -- Name: schedulers_customperiodictask schedulers_customperiodictask_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.schedulers_customperiodictask
        ADD CONSTRAINT schedulers_customperiodictask_pkey PRIMARY KEY (periodictask_ptr_id);


    --
    -- Name: schedulers_customschedule schedulers_customschedule_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.schedulers_customschedule
        ADD CONSTRAINT schedulers_customschedule_pkey PRIMARY KEY (id);


    --
    -- Name: schedulers_customschedule schedulers_customschedule_schedule_import_path_key; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.schedulers_customschedule
        ADD CONSTRAINT schedulers_customschedule_schedule_import_path_key UNIQUE (schedule_import_path);


    --
    -- Name: shipping_shippingmethod_excluded_products shipping_shippingmethod__shippingmethod_id_produc_2c1bbd46_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.shipping_shippingmethod_excluded_products
        ADD CONSTRAINT shipping_shippingmethod__shippingmethod_id_produc_2c1bbd46_uniq UNIQUE (shippingmethod_id, product_id);


    --
    -- Name: shipping_shippingmethod_excluded_products shipping_shippingmethod_excluded_products_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.shipping_shippingmethod_excluded_products
        ADD CONSTRAINT shipping_shippingmethod_excluded_products_pkey PRIMARY KEY (id);


    --
    -- Name: shipping_shippingmethod shipping_shippingmethod_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.shipping_shippingmethod
        ADD CONSTRAINT shipping_shippingmethod_pkey PRIMARY KEY (id);


    --
    -- Name: shipping_shippingmethodchannellisting shipping_shippingmethodc_shipping_method_id_chann_dcc7298d_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.shipping_shippingmethodchannellisting
        ADD CONSTRAINT shipping_shippingmethodc_shipping_method_id_chann_dcc7298d_uniq UNIQUE (shipping_method_id, channel_id);


    --
    -- Name: shipping_shippingmethodchannellisting shipping_shippingmethodchannellisting_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.shipping_shippingmethodchannellisting
        ADD CONSTRAINT shipping_shippingmethodchannellisting_pkey PRIMARY KEY (id);


    --
    -- Name: shipping_shippingmethodtranslation shipping_shippingmethodt_language_code_shipping_m_70e4f786_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.shipping_shippingmethodtranslation
        ADD CONSTRAINT shipping_shippingmethodt_language_code_shipping_m_70e4f786_uniq UNIQUE (language_code, shipping_method_id);


    --
    -- Name: shipping_shippingmethodtranslation shipping_shippingmethodtranslation_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.shipping_shippingmethodtranslation
        ADD CONSTRAINT shipping_shippingmethodtranslation_pkey PRIMARY KEY (id);


    --
    -- Name: shipping_shippingmethodpostalcoderule shipping_shippingmethodz_shipping_method_id_start_33dae54c_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.shipping_shippingmethodpostalcoderule
        ADD CONSTRAINT shipping_shippingmethodz_shipping_method_id_start_33dae54c_uniq UNIQUE (shipping_method_id, start, "end");


    --
    -- Name: shipping_shippingmethodpostalcoderule shipping_shippingmethodzipcoderule_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.shipping_shippingmethodpostalcoderule
        ADD CONSTRAINT shipping_shippingmethodzipcoderule_pkey PRIMARY KEY (id);


    --
    -- Name: shipping_shippingzone_channels shipping_shippingzone_ch_shippingzone_id_channel__509bee3d_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.shipping_shippingzone_channels
        ADD CONSTRAINT shipping_shippingzone_ch_shippingzone_id_channel__509bee3d_uniq UNIQUE (shippingzone_id, channel_id);


    --
    -- Name: shipping_shippingzone_channels shipping_shippingzone_channels_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.shipping_shippingzone_channels
        ADD CONSTRAINT shipping_shippingzone_channels_pkey PRIMARY KEY (id);


    --
    -- Name: shipping_shippingzone shipping_shippingzone_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.shipping_shippingzone
        ADD CONSTRAINT shipping_shippingzone_pkey PRIMARY KEY (id);


    --
    -- Name: site_sitesettings site_sitesettings_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.site_sitesettings
        ADD CONSTRAINT site_sitesettings_pkey PRIMARY KEY (id);


    --
    -- Name: site_sitesettings site_sitesettings_site_id_key; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.site_sitesettings
        ADD CONSTRAINT site_sitesettings_site_id_key UNIQUE (site_id);


    --
    -- Name: site_sitesettingstranslation site_sitesettingstransla_language_code_site_setti_e767d9e7_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.site_sitesettingstranslation
        ADD CONSTRAINT site_sitesettingstransla_language_code_site_setti_e767d9e7_uniq UNIQUE (language_code, site_settings_id);


    --
    -- Name: site_sitesettingstranslation site_sitesettingstranslation_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.site_sitesettingstranslation
        ADD CONSTRAINT site_sitesettingstranslation_pkey PRIMARY KEY (id);


    --
    -- Name: tax_taxclass tax_taxclass_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.tax_taxclass
        ADD CONSTRAINT tax_taxclass_pkey PRIMARY KEY (id);


    --
    -- Name: tax_taxclasscountryrate tax_taxclasscountryrate_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.tax_taxclasscountryrate
        ADD CONSTRAINT tax_taxclasscountryrate_pkey PRIMARY KEY (id);


    --
    -- Name: tax_taxconfiguration tax_taxconfiguration_channel_id_key; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.tax_taxconfiguration
        ADD CONSTRAINT tax_taxconfiguration_channel_id_key UNIQUE (channel_id);


    --
    -- Name: tax_taxconfiguration tax_taxconfiguration_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.tax_taxconfiguration
        ADD CONSTRAINT tax_taxconfiguration_pkey PRIMARY KEY (id);


    --
    -- Name: tax_taxconfigurationpercountry tax_taxconfigurationperc_tax_configuration_id_cou_6c2371f7_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.tax_taxconfigurationpercountry
        ADD CONSTRAINT tax_taxconfigurationperc_tax_configuration_id_cou_6c2371f7_uniq UNIQUE (tax_configuration_id, country);


    --
    -- Name: tax_taxconfigurationpercountry tax_taxconfigurationpercountry_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.tax_taxconfigurationpercountry
        ADD CONSTRAINT tax_taxconfigurationpercountry_pkey PRIMARY KEY (id);


    --
    -- Name: thumbnail_thumbnail thumbnail_thumbnail_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.thumbnail_thumbnail
        ADD CONSTRAINT thumbnail_thumbnail_pkey PRIMARY KEY (id);


    --
    -- Name: discount_checkoutlinediscount unique_checkoutline_discount_type; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_checkoutlinediscount
        ADD CONSTRAINT unique_checkoutline_discount_type UNIQUE (line_id, unique_type);


    --
    -- Name: tax_taxclasscountryrate unique_country_tax_class; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.tax_taxclasscountryrate
        ADD CONSTRAINT unique_country_tax_class UNIQUE (country, tax_class_id);


    --
    -- Name: discount_orderlinediscount unique_orderline_discount_type; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_orderlinediscount
        ADD CONSTRAINT unique_orderline_discount_type UNIQUE (line_id, unique_type);


    --
    -- Name: payment_transactionevent unique_transaction_event_idempotency; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.payment_transactionevent
        ADD CONSTRAINT unique_transaction_event_idempotency UNIQUE (transaction_id, idempotency_key);


    --
    -- Name: payment_transactionitem unique_transaction_idempotency; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.payment_transactionitem
        ADD CONSTRAINT unique_transaction_idempotency UNIQUE (app_identifier, idempotency_key);


    --
    -- Name: account_address userprofile_address_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_address
        ADD CONSTRAINT userprofile_address_pkey PRIMARY KEY (id);


    --
    -- Name: account_user_addresses userprofile_user_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_user_addresses
        ADD CONSTRAINT userprofile_user_addresses_pkey PRIMARY KEY (id);


    --
    -- Name: account_user_addresses userprofile_user_addresses_user_id_address_id_6cb87bcc_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_user_addresses
        ADD CONSTRAINT userprofile_user_addresses_user_id_address_id_6cb87bcc_uniq UNIQUE (user_id, address_id);


    --
    -- Name: account_user userprofile_user_email_key; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_user
        ADD CONSTRAINT userprofile_user_email_key UNIQUE (email);


    --
    -- Name: account_user_groups userprofile_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_user_groups
        ADD CONSTRAINT userprofile_user_groups_pkey PRIMARY KEY (id);


    --
    -- Name: account_user_groups userprofile_user_groups_user_id_group_id_90ce1781_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_user_groups
        ADD CONSTRAINT userprofile_user_groups_user_id_group_id_90ce1781_uniq UNIQUE (user_id, group_id);


    --
    -- Name: account_user userprofile_user_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_user
        ADD CONSTRAINT userprofile_user_pkey PRIMARY KEY (id);


    --
    -- Name: account_user_user_permissions userprofile_user_user_pe_user_id_permission_id_706d65c8_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_user_user_permissions
        ADD CONSTRAINT userprofile_user_user_pe_user_id_permission_id_706d65c8_uniq UNIQUE (user_id, permission_id);


    --
    -- Name: account_user_user_permissions userprofile_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_user_user_permissions
        ADD CONSTRAINT userprofile_user_user_permissions_pkey PRIMARY KEY (id);


    --
    -- Name: warehouse_allocation warehouse_allocation_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.warehouse_allocation
        ADD CONSTRAINT warehouse_allocation_pkey PRIMARY KEY (id);


    --
    -- Name: warehouse_channelwarehouse warehouse_channelwarehou_channel_id_warehouse_id_a78ef311_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.warehouse_channelwarehouse
        ADD CONSTRAINT warehouse_channelwarehou_channel_id_warehouse_id_a78ef311_uniq UNIQUE (channel_id, warehouse_id);


    --
    -- Name: warehouse_preorderallocation warehouse_preorderallocation_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.warehouse_preorderallocation
        ADD CONSTRAINT warehouse_preorderallocation_pkey PRIMARY KEY (id);


    --
    -- Name: warehouse_preorderreservation warehouse_preorderreservation_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.warehouse_preorderreservation
        ADD CONSTRAINT warehouse_preorderreservation_pkey PRIMARY KEY (id);


    --
    -- Name: warehouse_reservation warehouse_reservation_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.warehouse_reservation
        ADD CONSTRAINT warehouse_reservation_pkey PRIMARY KEY (id);


    --
    -- Name: warehouse_stock warehouse_stock_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.warehouse_stock
        ADD CONSTRAINT warehouse_stock_pkey PRIMARY KEY (id);


    --
    -- Name: warehouse_stock warehouse_stock_warehouse_id_product_variant_id_b04a0a40_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.warehouse_stock
        ADD CONSTRAINT warehouse_stock_warehouse_id_product_variant_id_b04a0a40_uniq UNIQUE (warehouse_id, product_variant_id);


    --
    -- Name: warehouse_channelwarehouse warehouse_warehouse_chan_warehouse_id_channel_id_61b3a7c8_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.warehouse_channelwarehouse
        ADD CONSTRAINT warehouse_warehouse_chan_warehouse_id_channel_id_61b3a7c8_uniq UNIQUE (warehouse_id, channel_id);


    --
    -- Name: warehouse_channelwarehouse warehouse_warehouse_channels_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.warehouse_channelwarehouse
        ADD CONSTRAINT warehouse_warehouse_channels_pkey PRIMARY KEY (id);


    --
    -- Name: warehouse_warehouse warehouse_warehouse_external_reference_key; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.warehouse_warehouse
        ADD CONSTRAINT warehouse_warehouse_external_reference_key UNIQUE (external_reference);


    --
    -- Name: warehouse_warehouse warehouse_warehouse_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.warehouse_warehouse
        ADD CONSTRAINT warehouse_warehouse_pkey PRIMARY KEY (id);


    --
    -- Name: warehouse_warehouse_shipping_zones warehouse_warehouse_ship_warehouse_id_shippingzon_e18400fa_uniq; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.warehouse_warehouse_shipping_zones
        ADD CONSTRAINT warehouse_warehouse_ship_warehouse_id_shippingzon_e18400fa_uniq UNIQUE (warehouse_id, shippingzone_id);


    --
    -- Name: warehouse_warehouse_shipping_zones warehouse_warehouse_shipping_zones_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.warehouse_warehouse_shipping_zones
        ADD CONSTRAINT warehouse_warehouse_shipping_zones_pkey PRIMARY KEY (id);


    --
    -- Name: warehouse_warehouse warehouse_warehouse_slug_key; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.warehouse_warehouse
        ADD CONSTRAINT warehouse_warehouse_slug_key UNIQUE (slug);


    --
    -- Name: webhook_webhook webhook_webhook_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.webhook_webhook
        ADD CONSTRAINT webhook_webhook_pkey PRIMARY KEY (id);


    --
    -- Name: webhook_webhookevent webhook_webhookevent_pkey; Type: CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.webhook_webhookevent
        ADD CONSTRAINT webhook_webhookevent_pkey PRIMARY KEY (id);


    --
    -- Name: account_address_phone_7966e995; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX account_address_phone_7966e995 ON public.account_address USING btree (phone);


    --
    -- Name: account_address_phone_7966e995_like; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX account_address_phone_7966e995_like ON public.account_address USING btree (phone varchar_pattern_ops);


    --
    -- Name: account_customerevent_app_id_b022b4d7; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX account_customerevent_app_id_b022b4d7 ON public.account_customerevent USING btree (app_id);


    --
    -- Name: account_customerevent_order_token_id_fd941a39; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX account_customerevent_order_token_id_fd941a39 ON public.account_customerevent USING btree (order_id);


    --
    -- Name: account_customerevent_user_id_b3d6ec36; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX account_customerevent_user_id_b3d6ec36 ON public.account_customerevent USING btree (user_id);


    --
    -- Name: account_customernote_customer_id_ec50cbf6; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX account_customernote_customer_id_ec50cbf6 ON public.account_customernote USING btree (customer_id);


    --
    -- Name: account_customernote_date_231c3474; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX account_customernote_date_231c3474 ON public.account_customernote USING btree (date);


    --
    -- Name: account_customernote_user_id_b10a6c14; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX account_customernote_user_id_b10a6c14 ON public.account_customernote USING btree (user_id);


    --
    -- Name: account_group_channels_channel_id_04ca83ef; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX account_group_channels_channel_id_04ca83ef ON public.account_group_channels USING btree (channel_id);


    --
    -- Name: account_group_channels_group_id_301893d0; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX account_group_channels_group_id_301893d0 ON public.account_group_channels USING btree (group_id);


    --
    -- Name: account_group_name_034e9f3f_like; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX account_group_name_034e9f3f_like ON public.account_group USING btree (name varchar_pattern_ops);


    --
    -- Name: account_group_permissions_group_id_37f7fcd9; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX account_group_permissions_group_id_37f7fcd9 ON public.account_group_permissions USING btree (group_id);


    --
    -- Name: account_group_permissions_permission_id_f654f978; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX account_group_permissions_permission_id_f654f978 ON public.account_group_permissions USING btree (permission_id);


    --
    -- Name: account_serviceaccount_permissions_permission_id_449791f0; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX account_serviceaccount_permissions_permission_id_449791f0 ON public.app_app_permissions USING btree (permission_id);


    --
    -- Name: account_serviceaccount_permissions_serviceaccount_id_ec78f497; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX account_serviceaccount_permissions_serviceaccount_id_ec78f497 ON public.app_app_permissions USING btree (app_id);


    --
    -- Name: account_serviceaccounttoken_auth_token_e4c38601_like; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX account_serviceaccounttoken_auth_token_e4c38601_like ON public.app_apptoken USING btree (auth_token varchar_pattern_ops);


    --
    -- Name: account_serviceaccounttoken_service_account_id_a8e6dee8; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX account_serviceaccounttoken_service_account_id_a8e6dee8 ON public.app_apptoken USING btree (app_id);


    --
    -- Name: account_staffnotificationrecipient_staff_email_a309b82e_like; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX account_staffnotificationrecipient_staff_email_a309b82e_like ON public.account_staffnotificationrecipient USING btree (staff_email varchar_pattern_ops);


    --
    -- Name: account_user_external_reference_ba2fbb61_like; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX account_user_external_reference_ba2fbb61_like ON public.account_user USING btree (external_reference varchar_pattern_ops);


    --
    -- Name: account_user_updated_at_d33bcfd6; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX account_user_updated_at_d33bcfd6 ON public.account_user USING btree (updated_at);


    --
    -- Name: address_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX address_meta_idx ON public.account_address USING gin (metadata);


    --
    -- Name: address_p_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX address_p_meta_idx ON public.account_address USING gin (private_metadata);


    --
    -- Name: address_search_gin; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX address_search_gin ON public.account_address USING gin (first_name public.gin_trgm_ops, last_name public.gin_trgm_ops, city public.gin_trgm_ops, country public.gin_trgm_ops);


    --
    -- Name: app_appextension_app_id_4b2d27e9; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX app_appextension_app_id_4b2d27e9 ON public.app_appextension USING btree (app_id);


    --
    -- Name: app_appextension_permissions_appextension_id_8ad99c02; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX app_appextension_permissions_appextension_id_8ad99c02 ON public.app_appextension_permissions USING btree (appextension_id);


    --
    -- Name: app_appextension_permissions_permission_id_cb6c3ce0; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX app_appextension_permissions_permission_id_cb6c3ce0 ON public.app_appextension_permissions USING btree (permission_id);


    --
    -- Name: app_appinstallation_permissions_appinstallation_id_f7fe0271; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX app_appinstallation_permissions_appinstallation_id_f7fe0271 ON public.app_appinstallation_permissions USING btree (appinstallation_id);


    --
    -- Name: app_appinstallation_permissions_permission_id_4ee9f6c8; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX app_appinstallation_permissions_permission_id_4ee9f6c8 ON public.app_appinstallation_permissions USING btree (permission_id);


    --
    -- Name: app_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX app_meta_idx ON public.app_app USING gin (metadata);


    --
    -- Name: app_p_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX app_p_meta_idx ON public.app_app USING gin (private_metadata);


    --
    -- Name: assignedpageattrvalue_page_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX assignedpageattrvalue_page_idx ON public.attribute_assignedpageattributevalue USING btree (page_id);


    --
    -- Name: assignedprodattrval_product_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX assignedprodattrval_product_idx ON public.attribute_assignedproductattributevalue USING btree (product_id);


    --
    -- Name: attribute_assignedpageattributevalue_sort_order_4a2a6d66; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX attribute_assignedpageattributevalue_sort_order_4a2a6d66 ON public.attribute_assignedpageattributevalue USING btree (sort_order);


    --
    -- Name: attribute_assignedpageattributevalue_value_id_9d9ee1aa; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX attribute_assignedpageattributevalue_value_id_9d9ee1aa ON public.attribute_assignedpageattributevalue USING btree (value_id);


    --
    -- Name: attribute_assignedproductattributevalue_sort_order_3f6252d6; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX attribute_assignedproductattributevalue_sort_order_3f6252d6 ON public.attribute_assignedproductattributevalue USING btree (sort_order);


    --
    -- Name: attribute_assignedproductattributevalue_value_id_9b9c0c68; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX attribute_assignedproductattributevalue_value_id_9b9c0c68 ON public.attribute_assignedproductattributevalue USING btree (value_id);


    --
    -- Name: attribute_assignedvariantattributevalue_assignment_id_040f7499; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX attribute_assignedvariantattributevalue_assignment_id_040f7499 ON public.attribute_assignedvariantattributevalue USING btree (assignment_id);


    --
    -- Name: attribute_assignedvariantattributevalue_sort_order_3e207536; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX attribute_assignedvariantattributevalue_sort_order_3e207536 ON public.attribute_assignedvariantattributevalue USING btree (sort_order);


    --
    -- Name: attribute_assignedvariantattributevalue_value_id_4bbdc9fa; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX attribute_assignedvariantattributevalue_value_id_4bbdc9fa ON public.attribute_assignedvariantattributevalue USING btree (value_id);


    --
    -- Name: attribute_attribute_external_reference_792d92de_like; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX attribute_attribute_external_reference_792d92de_like ON public.attribute_attribute USING btree (external_reference varchar_pattern_ops);


    --
    -- Name: attribute_attributevalue_external_reference_c57fc8fd_like; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX attribute_attributevalue_external_reference_c57fc8fd_like ON public.attribute_attributevalue USING btree (external_reference varchar_pattern_ops);


    --
    -- Name: attribute_attributevalue_reference_page_id_33727843; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX attribute_attributevalue_reference_page_id_33727843 ON public.attribute_attributevalue USING btree (reference_page_id);


    --
    -- Name: attribute_attributevalue_reference_product_id_43329b37; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX attribute_attributevalue_reference_product_id_43329b37 ON public.attribute_attributevalue USING btree (reference_product_id);


    --
    -- Name: attribute_attributevalue_reference_variant_id_670c09ee; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX attribute_attributevalue_reference_variant_id_670c09ee ON public.attribute_attributevalue USING btree (reference_variant_id);


    --
    -- Name: attribute_gin; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX attribute_gin ON public.attribute_attribute USING gin (slug public.gin_trgm_ops, name public.gin_trgm_ops, type public.gin_trgm_ops, input_type public.gin_trgm_ops, entity_type public.gin_trgm_ops, unit public.gin_trgm_ops);


    --
    -- Name: attribute_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX attribute_meta_idx ON public.attribute_attribute USING gin (metadata);


    --
    -- Name: attribute_p_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX attribute_p_meta_idx ON public.attribute_attribute USING gin (private_metadata);


    --
    -- Name: attribute_search_gin; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX attribute_search_gin ON public.attribute_attributevalue USING gin (name public.gin_trgm_ops, slug public.gin_trgm_ops);


    --
    -- Name: cart_cart_billing_address_id_9eb62ddd; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX cart_cart_billing_address_id_9eb62ddd ON public.checkout_checkout USING btree (billing_address_id);


    --
    -- Name: cart_cart_shipping_address_id_adfddaf9; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX cart_cart_shipping_address_id_adfddaf9 ON public.checkout_checkout USING btree (shipping_address_id);


    --
    -- Name: cart_cart_shipping_method_id_835c02e0; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX cart_cart_shipping_method_id_835c02e0 ON public.checkout_checkout USING btree (shipping_method_id);


    --
    -- Name: cart_cart_user_id_9b4220b9; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX cart_cart_user_id_9b4220b9 ON public.checkout_checkout USING btree (user_id);


    --
    -- Name: cart_cartline_cart_id_c7b9981e; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX cart_cartline_cart_id_c7b9981e ON public.checkout_checkoutline USING btree (checkout_id);


    --
    -- Name: cart_cartline_product_id_1a54130f; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX cart_cartline_product_id_1a54130f ON public.checkout_checkoutline USING btree (variant_id);


    --
    -- Name: category_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX category_meta_idx ON public.product_category USING gin (metadata);


    --
    -- Name: category_p_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX category_p_meta_idx ON public.product_category USING gin (private_metadata);


    --
    -- Name: category_search_name_slug_gin; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX category_search_name_slug_gin ON public.product_category USING gin (name public.gin_trgm_ops, slug public.gin_trgm_ops, description_plaintext public.gin_trgm_ops);


    --
    -- Name: channel_channel_slug_91801cbf_like; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX channel_channel_slug_91801cbf_like ON public.channel_channel USING btree (slug varchar_pattern_ops);


    --
    -- Name: channel_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX channel_meta_idx ON public.channel_channel USING gin (metadata);


    --
    -- Name: channel_p_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX channel_p_meta_idx ON public.channel_channel USING gin (private_metadata);


    --
    -- Name: checklinedisc_promotion_rule_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX checklinedisc_promotion_rule_idx ON public.discount_checkoutlinediscount USING btree (promotion_rule_id);


    --
    -- Name: checklinedisc_voucher_code_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX checklinedisc_voucher_code_idx ON public.discount_checkoutlinediscount USING gin (voucher_code);


    --
    -- Name: checkout_checkout_authorize_status_27351893; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX checkout_checkout_authorize_status_27351893 ON public.checkout_checkout USING btree (authorize_status);


    --
    -- Name: checkout_checkout_authorize_status_27351893_like; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX checkout_checkout_authorize_status_27351893_like ON public.checkout_checkout USING btree (authorize_status varchar_pattern_ops);


    --
    -- Name: checkout_checkout_channel_id_3b1a1e12; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX checkout_checkout_channel_id_3b1a1e12 ON public.checkout_checkout USING btree (channel_id);


    --
    -- Name: checkout_checkout_charge_status_bd143b33; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX checkout_checkout_charge_status_bd143b33 ON public.checkout_checkout USING btree (charge_status);


    --
    -- Name: checkout_checkout_charge_status_bd143b33_like; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX checkout_checkout_charge_status_bd143b33_like ON public.checkout_checkout USING btree (charge_status varchar_pattern_ops);


    --
    -- Name: checkout_checkout_collection_point_id_2dfc8e33; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX checkout_checkout_collection_point_id_2dfc8e33 ON public.checkout_checkout USING btree (collection_point_id);


    --
    -- Name: checkout_checkout_gift_cards_checkout_id_e314728d; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX checkout_checkout_gift_cards_checkout_id_e314728d ON public.checkout_checkout_gift_cards USING btree (checkout_id);


    --
    -- Name: checkout_checkout_gift_cards_giftcard_id_f5994462; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX checkout_checkout_gift_cards_giftcard_id_f5994462 ON public.checkout_checkout_gift_cards USING btree (giftcard_id);


    --
    -- Name: checkout_checkout_last_change_dfde0b31; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX checkout_checkout_last_change_dfde0b31 ON public.checkout_checkout USING btree (last_change);


    --
    -- Name: checkout_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX checkout_meta_idx ON public.checkout_checkout USING gin (metadata);


    --
    -- Name: checkout_p_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX checkout_p_meta_idx ON public.checkout_checkout USING gin (private_metadata);


    --
    -- Name: checkoutdiscount_rule_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX checkoutdiscount_rule_idx ON public.discount_checkoutdiscount USING btree (promotion_rule_id);


    --
    -- Name: checkoutdiscount_voucher_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX checkoutdiscount_voucher_idx ON public.discount_checkoutdiscount USING gin (voucher_code);


    --
    -- Name: checkoutline_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX checkoutline_meta_idx ON public.checkout_checkoutline USING gin (metadata);


    --
    -- Name: checkoutline_p_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX checkoutline_p_meta_idx ON public.checkout_checkoutline USING gin (private_metadata);


    --
    -- Name: checkoutmetadata_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX checkoutmetadata_meta_idx ON public.checkout_checkoutmetadata USING gin (metadata);


    --
    -- Name: checkoutmetadata_p_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX checkoutmetadata_p_meta_idx ON public.checkout_checkoutmetadata USING gin (private_metadata);


    --
    -- Name: collection_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX collection_meta_idx ON public.product_collection USING gin (metadata);


    --
    -- Name: collection_p_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX collection_p_meta_idx ON public.product_collection USING gin (private_metadata);


    --
    -- Name: collection_search_gin; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX collection_search_gin ON public.product_collection USING gin (name public.gin_trgm_ops, slug public.gin_trgm_ops);


    --
    -- Name: core_eventdelivery_payload_id_34de9fbd; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX core_eventdelivery_payload_id_34de9fbd ON public.core_eventdelivery USING btree (payload_id);


    --
    -- Name: core_eventdelivery_webhook_id_1ff668bb; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX core_eventdelivery_webhook_id_1ff668bb ON public.core_eventdelivery USING btree (webhook_id);


    --
    -- Name: core_eventdeliveryattempt_delivery_id_278cb539; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX core_eventdeliveryattempt_delivery_id_278cb539 ON public.core_eventdeliveryattempt USING btree (delivery_id);


    --
    -- Name: csv_exportevent_app_id_8637fcc5; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX csv_exportevent_app_id_8637fcc5 ON public.csv_exportevent USING btree (app_id);


    --
    -- Name: csv_exportevent_export_file_id_35f6c448; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX csv_exportevent_export_file_id_35f6c448 ON public.csv_exportevent USING btree (export_file_id);


    --
    -- Name: csv_exportevent_user_id_6111f193; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX csv_exportevent_user_id_6111f193 ON public.csv_exportevent USING btree (user_id);


    --
    -- Name: csv_exportfile_app_id_bc900999; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX csv_exportfile_app_id_bc900999 ON public.csv_exportfile USING btree (app_id);


    --
    -- Name: csv_exportfile_user_id_2c9071e6; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX csv_exportfile_user_id_2c9071e6 ON public.csv_exportfile USING btree (user_id);


    --
    -- Name: digitalcontent_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX digitalcontent_meta_idx ON public.product_digitalcontent USING gin (metadata);


    --
    -- Name: digitalcontent_p_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX digitalcontent_p_meta_idx ON public.product_digitalcontent USING gin (private_metadata);


    --
    -- Name: discount_ch_name_64e096_gin; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_ch_name_64e096_gin ON public.discount_checkoutdiscount USING gin (name, translated_name);


    --
    -- Name: discount_checkoutdiscount_checkout_id_e5063abc; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_checkoutdiscount_checkout_id_e5063abc ON public.discount_checkoutdiscount USING btree (checkout_id);


    --
    -- Name: discount_checkoutdiscount_created_at_c8166ad7; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_checkoutdiscount_created_at_c8166ad7 ON public.discount_checkoutdiscount USING btree (created_at);


    --
    -- Name: discount_checkoutdiscount_voucher_id_1ef32adb; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_checkoutdiscount_voucher_id_1ef32adb ON public.discount_checkoutdiscount USING btree (voucher_id);


    --
    -- Name: discount_checkoutlinediscount_created_at_000ed677; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_checkoutlinediscount_created_at_000ed677 ON public.discount_checkoutlinediscount USING btree (created_at);


    --
    -- Name: discount_checkoutlinediscount_line_id_b93245a9; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_checkoutlinediscount_line_id_b93245a9 ON public.discount_checkoutlinediscount USING btree (line_id);


    --
    -- Name: discount_checkoutlinediscount_voucher_id_66a61d93; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_checkoutlinediscount_voucher_id_66a61d93 ON public.discount_checkoutlinediscount USING btree (voucher_id);


    --
    -- Name: discount_or_name_d16858_gin; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_or_name_d16858_gin ON public.discount_orderdiscount USING gin (name, translated_name);


    --
    -- Name: discount_orderdiscount_created_at_8ee20efc; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_orderdiscount_created_at_8ee20efc ON public.discount_orderdiscount USING btree (created_at);


    --
    -- Name: discount_orderdiscount_order_token_id_2e6b263a; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_orderdiscount_order_token_id_2e6b263a ON public.discount_orderdiscount USING btree (order_id);


    --
    -- Name: discount_orderdiscount_voucher_id_10f0a1db; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_orderdiscount_voucher_id_10f0a1db ON public.discount_orderdiscount USING btree (voucher_id);


    --
    -- Name: discount_orderlinediscount_created_at_acd29d5a; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_orderlinediscount_created_at_acd29d5a ON public.discount_orderlinediscount USING btree (created_at);


    --
    -- Name: discount_orderlinediscount_line_id_045244c7; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_orderlinediscount_line_id_045244c7 ON public.discount_orderlinediscount USING btree (line_id);


    --
    -- Name: discount_orderlinediscount_voucher_id_07e8fb8a; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_orderlinediscount_voucher_id_07e8fb8a ON public.discount_orderlinediscount USING btree (voucher_id);


    --
    -- Name: discount_promotion_created_at_8775e81a; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_promotion_created_at_8775e81a ON public.discount_promotion USING btree (created_at);


    --
    -- Name: discount_promotion_updated_at_680bf304; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_promotion_updated_at_680bf304 ON public.discount_promotion USING btree (updated_at);


    --
    -- Name: discount_promotionevent_app_id_bf6964c4; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_promotionevent_app_id_bf6964c4 ON public.discount_promotionevent USING btree (app_id);


    --
    -- Name: discount_promotionevent_date_37b2d832; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_promotionevent_date_37b2d832 ON public.discount_promotionevent USING btree (date);


    --
    -- Name: discount_promotionevent_promotion_id_df51584a; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_promotionevent_promotion_id_df51584a ON public.discount_promotionevent USING btree (promotion_id);


    --
    -- Name: discount_promotionevent_user_id_935d264f; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_promotionevent_user_id_935d264f ON public.discount_promotionevent USING btree (user_id);


    --
    -- Name: discount_promotionrule_channels_channel_id_698c2436; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_promotionrule_channels_channel_id_698c2436 ON public.discount_promotionrule_channels USING btree (channel_id);


    --
    -- Name: discount_promotionrule_channels_promotionrule_id_878da3b9; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_promotionrule_channels_promotionrule_id_878da3b9 ON public.discount_promotionrule_channels USING btree (promotionrule_id);


    --
    -- Name: discount_promotionrule_gifts_productvariant_id_5409d0a9; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_promotionrule_gifts_productvariant_id_5409d0a9 ON public.discount_promotionrule_gifts USING btree (productvariant_id);


    --
    -- Name: discount_promotionrule_gifts_promotionrule_id_d56c403e; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_promotionrule_gifts_promotionrule_id_d56c403e ON public.discount_promotionrule_gifts USING btree (promotionrule_id);


    --
    -- Name: discount_promotionrule_promotion_id_6deaa086; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_promotionrule_promotion_id_6deaa086 ON public.discount_promotionrule USING btree (promotion_id);


    --
    -- Name: discount_promotionrule_variants_productvariant_id_e715ba55; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_promotionrule_variants_productvariant_id_e715ba55 ON public.discount_promotionrule_variants USING btree (productvariant_id);


    --
    -- Name: discount_promotionrule_variants_promotionrule_id_d16c1004; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_promotionrule_variants_promotionrule_id_d16c1004 ON public.discount_promotionrule_variants USING btree (promotionrule_id);


    --
    -- Name: discount_promotionruletranslation_promotion_rule_id_e2ab38d7; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_promotionruletranslation_promotion_rule_id_e2ab38d7 ON public.discount_promotionruletranslation USING btree (promotion_rule_id);


    --
    -- Name: discount_promotiontranslation_promotion_id_bc72ea07; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_promotiontranslation_promotion_id_bc72ea07 ON public.discount_promotiontranslation USING btree (promotion_id);


    --
    -- Name: discount_voucher_categories_category_id_fc9d044a; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_voucher_categories_category_id_fc9d044a ON public.discount_voucher_categories USING btree (category_id);


    --
    -- Name: discount_voucher_categories_voucher_id_19a56338; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_voucher_categories_voucher_id_19a56338 ON public.discount_voucher_categories USING btree (voucher_id);


    --
    -- Name: discount_voucher_collections_collection_id_b9de6b54; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_voucher_collections_collection_id_b9de6b54 ON public.discount_voucher_collections USING btree (collection_id);


    --
    -- Name: discount_voucher_collections_voucher_id_4ce1fde3; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_voucher_collections_voucher_id_4ce1fde3 ON public.discount_voucher_collections USING btree (voucher_id);


    --
    -- Name: discount_voucher_products_product_id_4a3131ff; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_voucher_products_product_id_4a3131ff ON public.discount_voucher_products USING btree (product_id);


    --
    -- Name: discount_voucher_products_voucher_id_8a2e6c3a; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_voucher_products_voucher_id_8a2e6c3a ON public.discount_voucher_products USING btree (voucher_id);


    --
    -- Name: discount_voucher_variants_productvariant_id_dcab0bb4; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_voucher_variants_productvariant_id_dcab0bb4 ON public.discount_voucher_variants USING btree (productvariant_id);


    --
    -- Name: discount_voucher_variants_voucher_id_40d96698; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_voucher_variants_voucher_id_40d96698 ON public.discount_voucher_variants USING btree (voucher_id);


    --
    -- Name: discount_voucherchannellisting_channel_id_09f3ed34; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_voucherchannellisting_channel_id_09f3ed34 ON public.discount_voucherchannellisting USING btree (channel_id);


    --
    -- Name: discount_voucherchannellisting_voucher_id_7963fcbd; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_voucherchannellisting_voucher_id_7963fcbd ON public.discount_voucherchannellisting USING btree (voucher_id);


    --
    -- Name: discount_vouchercode_code_8ba04be7_like; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_vouchercode_code_8ba04be7_like ON public.discount_vouchercode USING btree (code varchar_pattern_ops);


    --
    -- Name: discount_vouchertranslation_voucher_id_288246a9; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX discount_vouchertranslation_voucher_id_288246a9 ON public.discount_vouchertranslation USING btree (voucher_id);


    --
    -- Name: django_celery_beat_periodictask_clocked_id_47a69f82; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX django_celery_beat_periodictask_clocked_id_47a69f82 ON public.django_celery_beat_periodictask USING btree (clocked_id);


    --
    -- Name: django_celery_beat_periodictask_crontab_id_d3cba168; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX django_celery_beat_periodictask_crontab_id_d3cba168 ON public.django_celery_beat_periodictask USING btree (crontab_id);


    --
    -- Name: django_celery_beat_periodictask_interval_id_a8ca27da; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX django_celery_beat_periodictask_interval_id_a8ca27da ON public.django_celery_beat_periodictask USING btree (interval_id);


    --
    -- Name: django_celery_beat_periodictask_name_265a36b7_like; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX django_celery_beat_periodictask_name_265a36b7_like ON public.django_celery_beat_periodictask USING btree (name varchar_pattern_ops);


    --
    -- Name: django_celery_beat_periodictask_solar_id_a87ce72c; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX django_celery_beat_periodictask_solar_id_a87ce72c ON public.django_celery_beat_periodictask USING btree (solar_id);


    --
    -- Name: django_site_domain_a2e37b91_like; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX django_site_domain_a2e37b91_like ON public.django_site USING btree (domain varchar_pattern_ops);


    --
    -- Name: email_upper_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX email_upper_idx ON public.account_user USING btree (upper((email)::text));


    --
    -- Name: end_date_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX end_date_idx ON public.discount_promotion USING btree (end_date);


    --
    -- Name: fulfillment_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX fulfillment_meta_idx ON public.order_fulfillment USING gin (metadata);


    --
    -- Name: fulfillment_p_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX fulfillment_p_meta_idx ON public.order_fulfillment USING gin (private_metadata);


    --
    -- Name: gift_card_tag_search_gin; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX gift_card_tag_search_gin ON public.giftcard_giftcardtag USING gin (name public.gin_trgm_ops);


    --
    -- Name: giftcard_giftcard_app_id_8d9d46f0; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX giftcard_giftcard_app_id_8d9d46f0 ON public.giftcard_giftcard USING btree (app_id);


    --
    -- Name: giftcard_giftcard_code_f6fb6be8_like; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX giftcard_giftcard_code_f6fb6be8_like ON public.giftcard_giftcard USING btree (code varchar_pattern_ops);


    --
    -- Name: giftcard_giftcard_created_at_62cb921a; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX giftcard_giftcard_created_at_62cb921a ON public.giftcard_giftcard USING btree (created_at);


    --
    -- Name: giftcard_giftcard_created_by_id_b70093de; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX giftcard_giftcard_created_by_id_b70093de ON public.giftcard_giftcard USING btree (created_by_id);


    --
    -- Name: giftcard_giftcard_fulfillment_line_id_f5bb8062; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX giftcard_giftcard_fulfillment_line_id_f5bb8062 ON public.giftcard_giftcard USING btree (fulfillment_line_id);


    --
    -- Name: giftcard_giftcard_product_id_d4ad7ecd; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX giftcard_giftcard_product_id_d4ad7ecd ON public.giftcard_giftcard USING btree (product_id);


    --
    -- Name: giftcard_giftcard_tags_giftcard_id_4e7e8444; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX giftcard_giftcard_tags_giftcard_id_4e7e8444 ON public.giftcard_giftcard_tags USING btree (giftcard_id);


    --
    -- Name: giftcard_giftcard_tags_giftcardtag_id_8d425074; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX giftcard_giftcard_tags_giftcardtag_id_8d425074 ON public.giftcard_giftcard_tags USING btree (giftcardtag_id);


    --
    -- Name: giftcard_giftcard_used_by_id_4e019509; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX giftcard_giftcard_used_by_id_4e019509 ON public.giftcard_giftcard USING btree (used_by_id);


    --
    -- Name: giftcard_giftcardevent_app_id_9e107653; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX giftcard_giftcardevent_app_id_9e107653 ON public.giftcard_giftcardevent USING btree (app_id);


    --
    -- Name: giftcard_giftcardevent_gift_card_id_28f4a30a; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX giftcard_giftcardevent_gift_card_id_28f4a30a ON public.giftcard_giftcardevent USING btree (gift_card_id);


    --
    -- Name: giftcard_giftcardevent_order_id_a934cb10; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX giftcard_giftcardevent_order_id_a934cb10 ON public.giftcard_giftcardevent USING btree (order_id);


    --
    -- Name: giftcard_giftcardevent_user_id_6b906b4a; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX giftcard_giftcardevent_user_id_6b906b4a ON public.giftcard_giftcardevent USING btree (user_id);


    --
    -- Name: giftcard_giftcardtag_name_215cd989_like; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX giftcard_giftcardtag_name_215cd989_like ON public.giftcard_giftcardtag USING btree (name varchar_pattern_ops);


    --
    -- Name: giftcard_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX giftcard_meta_idx ON public.giftcard_giftcard USING gin (metadata);


    --
    -- Name: giftcard_p_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX giftcard_p_meta_idx ON public.giftcard_giftcard USING gin (private_metadata);


    --
    -- Name: giftcard_tsearch; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX giftcard_tsearch ON public.giftcard_giftcard USING gin (search_vector);


    --
    -- Name: idx_order_created_at; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX idx_order_created_at ON public.order_order USING btree (created_at);


    --
    -- Name: invoice_invoice_order_token_id_d2755b86; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX invoice_invoice_order_token_id_d2755b86 ON public.invoice_invoice USING btree (order_id);


    --
    -- Name: invoice_invoiceevent_app_id_eb92fa41; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX invoice_invoiceevent_app_id_eb92fa41 ON public.invoice_invoiceevent USING btree (app_id);


    --
    -- Name: invoice_invoiceevent_invoice_id_de0632ca; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX invoice_invoiceevent_invoice_id_de0632ca ON public.invoice_invoiceevent USING btree (invoice_id);


    --
    -- Name: invoice_invoiceevent_order_token_id_acbb2c92; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX invoice_invoiceevent_order_token_id_acbb2c92 ON public.invoice_invoiceevent USING btree (order_id);


    --
    -- Name: invoice_invoiceevent_user_id_cd599b8d; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX invoice_invoiceevent_user_id_cd599b8d ON public.invoice_invoiceevent USING btree (user_id);


    --
    -- Name: invoice_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX invoice_meta_idx ON public.invoice_invoice USING gin (metadata);


    --
    -- Name: invoice_p_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX invoice_p_meta_idx ON public.invoice_invoice USING gin (private_metadata);


    --
    -- Name: menu_menu_slug_98939c4e_like; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX menu_menu_slug_98939c4e_like ON public.menu_menu USING btree (slug varchar_pattern_ops);


    --
    -- Name: menu_menuitem_category_id_af353a3b; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX menu_menuitem_category_id_af353a3b ON public.menu_menuitem USING btree (category_id);


    --
    -- Name: menu_menuitem_collection_id_b913b19e; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX menu_menuitem_collection_id_b913b19e ON public.menu_menuitem USING btree (collection_id);


    --
    -- Name: menu_menuitem_menu_id_f466b139; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX menu_menuitem_menu_id_f466b139 ON public.menu_menuitem USING btree (menu_id);


    --
    -- Name: menu_menuitem_page_id_a0c8f92d; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX menu_menuitem_page_id_a0c8f92d ON public.menu_menuitem USING btree (page_id);


    --
    -- Name: menu_menuitem_parent_id_439f55a5; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX menu_menuitem_parent_id_439f55a5 ON public.menu_menuitem USING btree (parent_id);


    --
    -- Name: menu_menuitem_sort_order_f96ed184; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX menu_menuitem_sort_order_f96ed184 ON public.menu_menuitem USING btree (sort_order);


    --
    -- Name: menu_menuitem_tree_id_0d2e9c9a; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX menu_menuitem_tree_id_0d2e9c9a ON public.menu_menuitem USING btree (tree_id);


    --
    -- Name: menu_menuitemtranslation_menu_item_id_3445926c; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX menu_menuitemtranslation_menu_item_id_3445926c ON public.menu_menuitemtranslation USING btree (menu_item_id);


    --
    -- Name: menu_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX menu_meta_idx ON public.menu_menu USING gin (metadata);


    --
    -- Name: menu_p_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX menu_p_meta_idx ON public.menu_menu USING gin (private_metadata);


    --
    -- Name: menuitem_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX menuitem_meta_idx ON public.menu_menuitem USING gin (metadata);


    --
    -- Name: menuitem_p_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX menuitem_p_meta_idx ON public.menu_menuitem USING gin (private_metadata);


    --
    -- Name: order_email_search_gin; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_email_search_gin ON public.order_order USING gin (user_email public.gin_trgm_ops);


    --
    -- Name: order_fulfillment_order_token_id_9cb8226d; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_fulfillment_order_token_id_9cb8226d ON public.order_fulfillment USING btree (order_id);


    --
    -- Name: order_fulfillmentline_fulfillment_id_68f3291d; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_fulfillmentline_fulfillment_id_68f3291d ON public.order_fulfillmentline USING btree (fulfillment_id);


    --
    -- Name: order_fulfillmentline_order_line_token_id_5d3adfcf; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_fulfillmentline_order_line_token_id_5d3adfcf ON public.order_fulfillmentline USING btree (order_line_id);


    --
    -- Name: order_fulfillmentline_stock_id_da5a99fe; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_fulfillmentline_stock_id_da5a99fe ON public.order_fulfillmentline USING btree (stock_id);


    --
    -- Name: order_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_meta_idx ON public.order_order USING gin (metadata);


    --
    -- Name: order_order_authorize_status_3d7fd7b0; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_order_authorize_status_3d7fd7b0 ON public.order_order USING btree (authorize_status);


    --
    -- Name: order_order_authorize_status_3d7fd7b0_like; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_order_authorize_status_3d7fd7b0_like ON public.order_order USING btree (authorize_status varchar_pattern_ops);


    --
    -- Name: order_order_billing_address_id_8fe537cf; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_order_billing_address_id_8fe537cf ON public.order_order USING btree (billing_address_id);


    --
    -- Name: order_order_channel_id_4dacf8a4; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_order_channel_id_4dacf8a4 ON public.order_order USING btree (channel_id);


    --
    -- Name: order_order_charge_status_d96729ef; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_order_charge_status_d96729ef ON public.order_order USING btree (charge_status);


    --
    -- Name: order_order_charge_status_d96729ef_like; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_order_charge_status_d96729ef_like ON public.order_order USING btree (charge_status varchar_pattern_ops);


    --
    -- Name: order_order_collection_point_id_0762767b; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_order_collection_point_id_0762767b ON public.order_order USING btree (collection_point_id);


    --
    -- Name: order_order_external_reference_8badbaae_like; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_order_external_reference_8badbaae_like ON public.order_order USING btree (external_reference varchar_pattern_ops);


    --
    -- Name: order_order_gift_cards_giftcard_id_f6844926; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_order_gift_cards_giftcard_id_f6844926 ON public.order_order_gift_cards USING btree (giftcard_id);


    --
    -- Name: order_order_original_token_id_f061b357; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_order_original_token_id_f061b357 ON public.order_order USING btree (original_id);


    --
    -- Name: order_order_shipping_address_id_57e64931; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_order_shipping_address_id_57e64931 ON public.order_order USING btree (shipping_address_id);


    --
    -- Name: order_order_shipping_method_id_2a742834; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_order_shipping_method_id_2a742834 ON public.order_order USING btree (shipping_method_id);


    --
    -- Name: order_order_shipping_tax_class_id_ec0a5734; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_order_shipping_tax_class_id_ec0a5734 ON public.order_order USING btree (shipping_tax_class_id);


    --
    -- Name: order_order_updated_at_6d31c2bd; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_order_updated_at_6d31c2bd ON public.order_order USING btree (updated_at);


    --
    -- Name: order_order_user_id_7cf9bc2b; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_order_user_id_7cf9bc2b ON public.order_order USING btree (user_id);


    --
    -- Name: order_order_voucher_id_0748ca22; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_order_voucher_id_0748ca22 ON public.order_order USING btree (voucher_id);


    --
    -- Name: order_orderevent_app_id_2d642e9c; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_orderevent_app_id_2d642e9c ON public.order_orderevent USING btree (app_id);


    --
    -- Name: order_orderevent_order_token_id_56352b3d; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_orderevent_order_token_id_56352b3d ON public.order_orderevent USING btree (order_id);


    --
    -- Name: order_orderevent_related_id_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_orderevent_related_id_idx ON public.order_orderevent USING btree (related_id);


    --
    -- Name: order_orderevent_user_id_1056ac9c; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_orderevent_user_id_1056ac9c ON public.order_orderevent USING btree (user_id);


    --
    -- Name: order_ordergrantedrefund_app_id_38ac1ecf; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_ordergrantedrefund_app_id_38ac1ecf ON public.order_ordergrantedrefund USING btree (app_id);


    --
    -- Name: order_ordergrantedrefund_order_id_2905d3e7; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_ordergrantedrefund_order_id_2905d3e7 ON public.order_ordergrantedrefund USING btree (order_id);


    --
    -- Name: order_ordergrantedrefund_updated_at_3aa80ec9; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_ordergrantedrefund_updated_at_3aa80ec9 ON public.order_ordergrantedrefund USING btree (updated_at);


    --
    -- Name: order_ordergrantedrefund_user_id_f344f8ec; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_ordergrantedrefund_user_id_f344f8ec ON public.order_ordergrantedrefund USING btree (user_id);


    --
    -- Name: order_ordergrantedrefundline_granted_refund_id_cd1bb9f6; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_ordergrantedrefundline_granted_refund_id_cd1bb9f6 ON public.order_ordergrantedrefundline USING btree (granted_refund_id);


    --
    -- Name: order_ordergrantedrefundline_order_line_id_c2b8e4af; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_ordergrantedrefundline_order_line_id_c2b8e4af ON public.order_ordergrantedrefundline USING btree (order_line_id);


    --
    -- Name: order_orderline_order_token_id_c8d256ee; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_orderline_order_token_id_c8d256ee ON public.order_orderline USING btree (order_id);


    --
    -- Name: order_orderline_tax_class_id_bc719d4f; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_orderline_tax_class_id_bc719d4f ON public.order_orderline USING btree (tax_class_id);


    --
    -- Name: order_orderline_variant_id_866774cb; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_orderline_variant_id_866774cb ON public.order_orderline USING btree (variant_id);


    --
    -- Name: order_p_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_p_meta_idx ON public.order_order USING gin (private_metadata);


    --
    -- Name: order_search_gin; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_search_gin ON public.order_order USING gin (search_document public.gin_trgm_ops);


    --
    -- Name: order_tsearch; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_tsearch ON public.order_order USING gin (search_vector);


    --
    -- Name: order_user_email_user_id_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_user_email_user_id_idx ON public.order_order USING gin (user_email, user_id);


    --
    -- Name: order_user_search_gin; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_user_search_gin ON public.account_user USING gin (email public.gin_trgm_ops, first_name public.gin_trgm_ops, last_name public.gin_trgm_ops);


    --
    -- Name: order_voucher_code_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX order_voucher_code_idx ON public.order_order USING gin (voucher_code);


    --
    -- Name: orderdiscount_promotion_rule_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX orderdiscount_promotion_rule_idx ON public.discount_orderdiscount USING btree (promotion_rule_id);


    --
    -- Name: orderdiscount_voucher_code_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX orderdiscount_voucher_code_idx ON public.discount_orderdiscount USING gin (voucher_code);


    --
    -- Name: orderline_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX orderline_meta_idx ON public.order_orderline USING gin (metadata);


    --
    -- Name: orderline_p_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX orderline_p_meta_idx ON public.order_orderline USING gin (private_metadata);


    --
    -- Name: orderlinedisc_promotion_rule_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX orderlinedisc_promotion_rule_idx ON public.discount_orderlinediscount USING btree (promotion_rule_id);


    --
    -- Name: orderlinedisc_voucher_code_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX orderlinedisc_voucher_code_idx ON public.discount_orderlinediscount USING gin (voucher_code);


    --
    -- Name: page_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX page_meta_idx ON public.page_page USING gin (metadata);


    --
    -- Name: page_p_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX page_p_meta_idx ON public.page_page USING gin (private_metadata);


    --
    -- Name: page_page_created_at_86e521f7; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX page_page_created_at_86e521f7 ON public.page_page USING btree (created_at);


    --
    -- Name: page_page_page_type_id_06acc00e; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX page_page_page_type_id_06acc00e ON public.page_page USING btree (page_type_id);


    --
    -- Name: page_page_slug_d6b7c8ed_like; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX page_page_slug_d6b7c8ed_like ON public.page_page USING btree (slug varchar_pattern_ops);


    --
    -- Name: page_page_title_964714_gin; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX page_page_title_964714_gin ON public.page_page USING gin (title, slug);


    --
    -- Name: page_pagetranslation_page_id_60216ef5; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX page_pagetranslation_page_id_60216ef5 ON public.page_pagetranslation USING btree (page_id);


    --
    -- Name: page_pagety_name_7c1cb8_gin; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX page_pagety_name_7c1cb8_gin ON public.page_pagetype USING gin (name, slug);


    --
    -- Name: page_pagetype_slug_dc1e7a3f_like; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX page_pagetype_slug_dc1e7a3f_like ON public.page_pagetype USING btree (slug varchar_pattern_ops);


    --
    -- Name: pagetype_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX pagetype_meta_idx ON public.page_pagetype USING gin (metadata);


    --
    -- Name: pagetype_p_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX pagetype_p_meta_idx ON public.page_pagetype USING gin (private_metadata);


    --
    -- Name: payment_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX payment_meta_idx ON public.payment_payment USING gin (metadata);


    --
    -- Name: payment_p_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX payment_p_meta_idx ON public.payment_payment USING gin (private_metadata);


    --
    -- Name: payment_payment_order_token_id_6823f402; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX payment_payment_order_token_id_6823f402 ON public.payment_payment USING btree (order_id);


    --
    -- Name: payment_payment_psp_reference_720e9ba9; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX payment_payment_psp_reference_720e9ba9 ON public.payment_payment USING btree (psp_reference);


    --
    -- Name: payment_payment_psp_reference_720e9ba9_like; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX payment_payment_psp_reference_720e9ba9_like ON public.payment_payment USING btree (psp_reference varchar_pattern_ops);


    --
    -- Name: payment_paymentmethod_checkout_id_5c0aae3d; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX payment_paymentmethod_checkout_id_5c0aae3d ON public.payment_payment USING btree (checkout_id);


    --
    -- Name: payment_transaction_payment_method_id_d35e75c1; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX payment_transaction_payment_method_id_d35e75c1 ON public.payment_transaction USING btree (payment_id);


    --
    -- Name: payment_transactionevent_app_id_98888f6d; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX payment_transactionevent_app_id_98888f6d ON public.payment_transactionevent USING btree (app_id);


    --
    -- Name: payment_transactionevent_transaction_id_381f97d4; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX payment_transactionevent_transaction_id_381f97d4 ON public.payment_transactionevent USING btree (transaction_id);


    --
    -- Name: payment_transactionevent_user_id_7f9244da; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX payment_transactionevent_user_id_7f9244da ON public.payment_transactionevent USING btree (user_id);


    --
    -- Name: payment_transactionitem_app_id_75ae2f40; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX payment_transactionitem_app_id_75ae2f40 ON public.payment_transactionitem USING btree (app_id);


    --
    -- Name: payment_transactionitem_checkout_id_bc8a405f; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX payment_transactionitem_checkout_id_bc8a405f ON public.payment_transactionitem USING btree (checkout_id);


    --
    -- Name: payment_transactionitem_order_id_1e36872b; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX payment_transactionitem_order_id_1e36872b ON public.payment_transactionitem USING btree (order_id);


    --
    -- Name: payment_transactionitem_user_id_780fab59; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX payment_transactionitem_user_id_780fab59 ON public.payment_transactionitem USING btree (user_id);


    --
    -- Name: permission_permission_content_type_id_e526e8f2; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX permission_permission_content_type_id_e526e8f2 ON public.permission_permission USING btree (content_type_id);


    --
    -- Name: plugins_emailtemplate_plugin_configuration_id_9abac2f2; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX plugins_emailtemplate_plugin_configuration_id_9abac2f2 ON public.plugins_emailtemplate USING btree (plugin_configuration_id);


    --
    -- Name: plugins_pluginconfiguration_channel_id_c880e95c; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX plugins_pluginconfiguration_channel_id_c880e95c ON public.plugins_pluginconfiguration USING btree (channel_id);


    --
    -- Name: product_assignedvariantattribute_assignment_id_8fdbffe8; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_assignedvariantattribute_assignment_id_8fdbffe8 ON public.attribute_assignedvariantattribute USING btree (assignment_id);


    --
    -- Name: product_assignedvariantattribute_variant_id_27483e6a; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_assignedvariantattribute_variant_id_27483e6a ON public.attribute_assignedvariantattribute USING btree (variant_id);


    --
    -- Name: product_attribute_slug_a2ba35f2_like; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_attribute_slug_a2ba35f2_like ON public.attribute_attribute USING btree (slug varchar_pattern_ops);


    --
    -- Name: product_attributechoiceval_attribute_choice_value_id_71c4c0a7; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_attributechoiceval_attribute_choice_value_id_71c4c0a7 ON public.attribute_attributevaluetranslation USING btree (attribute_value_id);


    --
    -- Name: product_attributechoicevalue_attribute_id_c28c6c92; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_attributechoicevalue_attribute_id_c28c6c92 ON public.attribute_attributevalue USING btree (attribute_id);


    --
    -- Name: product_attributechoicevalue_slug_e0d2d25b; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_attributechoicevalue_slug_e0d2d25b ON public.attribute_attributevalue USING btree (slug);


    --
    -- Name: product_attributechoicevalue_slug_e0d2d25b_like; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_attributechoicevalue_slug_e0d2d25b_like ON public.attribute_attributevalue USING btree (slug varchar_pattern_ops);


    --
    -- Name: product_attributechoicevalue_sort_order_c4c071c4; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_attributechoicevalue_sort_order_c4c071c4 ON public.attribute_attributevalue USING btree (sort_order);


    --
    -- Name: product_attributepage_attribute_id_29005ba0; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_attributepage_attribute_id_29005ba0 ON public.attribute_attributepage USING btree (attribute_id);


    --
    -- Name: product_attributepage_page_type_id_2723ed1f; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_attributepage_page_type_id_2723ed1f ON public.attribute_attributepage USING btree (page_type_id);


    --
    -- Name: product_attributepage_sort_order_88af052d; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_attributepage_sort_order_88af052d ON public.attribute_attributepage USING btree (sort_order);


    --
    -- Name: product_attributeproduct_attribute_id_0051c706; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_attributeproduct_attribute_id_0051c706 ON public.attribute_attributeproduct USING btree (attribute_id);


    --
    -- Name: product_attributeproduct_product_type_id_54357b3b; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_attributeproduct_product_type_id_54357b3b ON public.attribute_attributeproduct USING btree (product_type_id);


    --
    -- Name: product_attributeproduct_sort_order_cec8a8e2; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_attributeproduct_sort_order_cec8a8e2 ON public.attribute_attributeproduct USING btree (sort_order);


    --
    -- Name: product_attributevariant_attribute_id_e47d3bc3; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_attributevariant_attribute_id_e47d3bc3 ON public.attribute_attributevariant USING btree (attribute_id);


    --
    -- Name: product_attributevariant_product_type_id_ba95c6dd; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_attributevariant_product_type_id_ba95c6dd ON public.attribute_attributevariant USING btree (product_type_id);


    --
    -- Name: product_attributevariant_sort_order_cf4b00ef; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_attributevariant_sort_order_cf4b00ef ON public.attribute_attributevariant USING btree (sort_order);


    --
    -- Name: product_category_parent_id_f6860923; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_category_parent_id_f6860923 ON public.product_category USING btree (parent_id);


    --
    -- Name: product_category_slug_e1f8ccc4_like; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_category_slug_e1f8ccc4_like ON public.product_category USING btree (slug varchar_pattern_ops);


    --
    -- Name: product_category_tree_id_f3c46461; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_category_tree_id_f3c46461 ON public.product_category USING btree (tree_id);


    --
    -- Name: product_categorytranslation_category_id_aa8d0917; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_categorytranslation_category_id_aa8d0917 ON public.product_categorytranslation USING btree (category_id);


    --
    -- Name: product_collection_products_collection_id_0bc817dc; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_collection_products_collection_id_0bc817dc ON public.product_collectionproduct USING btree (collection_id);


    --
    -- Name: product_collection_products_product_id_a45a5b06; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_collection_products_product_id_a45a5b06 ON public.product_collectionproduct USING btree (product_id);


    --
    -- Name: product_collection_slug_ec186116_like; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_collection_slug_ec186116_like ON public.product_collection USING btree (slug varchar_pattern_ops);


    --
    -- Name: product_collectionchannellisting_channel_id_5e167702; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_collectionchannellisting_channel_id_5e167702 ON public.product_collectionchannellisting USING btree (channel_id);


    --
    -- Name: product_collectionchannellisting_collection_id_2ce1b16b; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_collectionchannellisting_collection_id_2ce1b16b ON public.product_collectionchannellisting USING btree (collection_id);


    --
    -- Name: product_collectionproduct_sort_order_5e7b55bb; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_collectionproduct_sort_order_5e7b55bb ON public.product_collectionproduct USING btree (sort_order);


    --
    -- Name: product_collectiontranslation_collection_id_cfbbd453; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_collectiontranslation_collection_id_cfbbd453 ON public.product_collectiontranslation USING btree (collection_id);


    --
    -- Name: product_digitalcontenturl_content_id_654197bd; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_digitalcontenturl_content_id_654197bd ON public.product_digitalcontenturl USING btree (content_id);


    --
    -- Name: product_gin; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_gin ON public.product_product USING gin (name public.gin_trgm_ops, slug public.gin_trgm_ops);


    --
    -- Name: product_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_meta_idx ON public.product_product USING gin (metadata);


    --
    -- Name: product_p_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_p_meta_idx ON public.product_product USING gin (private_metadata);


    --
    -- Name: product_pro_discoun_3145f3_btree; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_pro_discoun_3145f3_btree ON public.product_productchannellisting USING btree (discounted_price_amount);


    --
    -- Name: product_pro_price_a_fb6bd3_gin; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_pro_price_a_fb6bd3_gin ON public.product_productvariantchannellisting USING gin (price_amount, channel_id);


    --
    -- Name: product_pro_publish_a3c049_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_pro_publish_a3c049_idx ON public.product_productchannellisting USING btree (published_at);


    --
    -- Name: product_product_category_id_0c725779; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_product_category_id_0c725779 ON public.product_product USING btree (category_id);


    --
    -- Name: product_product_created_526af21d; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_product_created_526af21d ON public.product_product USING btree (created_at);


    --
    -- Name: product_product_external_reference_af10ae04_like; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_product_external_reference_af10ae04_like ON public.product_product USING btree (external_reference varchar_pattern_ops);


    --
    -- Name: product_product_product_class_id_0547c998; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_product_product_class_id_0547c998 ON public.product_product USING btree (product_type_id);


    --
    -- Name: product_product_search_index_dirty_724d006b; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_product_search_index_dirty_724d006b ON public.product_product USING btree (search_index_dirty);


    --
    -- Name: product_product_slug_76cde0ae_like; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_product_slug_76cde0ae_like ON public.product_product USING btree (slug varchar_pattern_ops);


    --
    -- Name: product_product_tax_class_id_a0476487; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_product_tax_class_id_a0476487 ON public.product_product USING btree (tax_class_id);


    --
    -- Name: product_product_updated_at_0eb084a6; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_product_updated_at_0eb084a6 ON public.product_product USING btree (updated_at);


    --
    -- Name: product_productattributetr_product_attribute_id_56b48511; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_productattributetr_product_attribute_id_56b48511 ON public.attribute_attributetranslation USING btree (attribute_id);


    --
    -- Name: product_productchannellisting_channel_id_f8b52350; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_productchannellisting_channel_id_f8b52350 ON public.product_productchannellisting USING btree (channel_id);


    --
    -- Name: product_productchannellisting_product_id_7838c7a9; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_productchannellisting_product_id_7838c7a9 ON public.product_productchannellisting USING btree (product_id);


    --
    -- Name: product_productmedia_product_id_b83ecd16; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_productmedia_product_id_b83ecd16 ON public.product_productmedia USING btree (product_id);


    --
    -- Name: product_productmedia_sort_order_d9f18acb; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_productmedia_sort_order_d9f18acb ON public.product_productmedia USING btree (sort_order);


    --
    -- Name: product_producttranslation_product_id_2c2c7532; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_producttranslation_product_id_2c2c7532 ON public.product_producttranslation USING btree (product_id);


    --
    -- Name: product_producttype_slug_6871faf2_like; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_producttype_slug_6871faf2_like ON public.product_producttype USING btree (slug varchar_pattern_ops);


    --
    -- Name: product_producttype_tax_class_id_cc83fe88; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_producttype_tax_class_id_cc83fe88 ON public.product_producttype USING btree (tax_class_id);


    --
    -- Name: product_productvariant_created_355c17e4; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_productvariant_created_355c17e4 ON public.product_productvariant USING btree (created_at);


    --
    -- Name: product_productvariant_external_reference_8f7f4882_like; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_productvariant_external_reference_8f7f4882_like ON public.product_productvariant USING btree (external_reference varchar_pattern_ops);


    --
    -- Name: product_productvariant_product_id_43c5a310; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_productvariant_product_id_43c5a310 ON public.product_productvariant USING btree (product_id);


    --
    -- Name: product_productvariant_sku_50706818_like; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_productvariant_sku_50706818_like ON public.product_productvariant USING btree (sku varchar_pattern_ops);


    --
    -- Name: product_productvariant_sort_order_d4acf89b; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_productvariant_sort_order_d4acf89b ON public.product_productvariant USING btree (sort_order);


    --
    -- Name: product_productvariant_updated_at_4ed8c13c; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_productvariant_updated_at_4ed8c13c ON public.product_productvariant USING btree (updated_at);


    --
    -- Name: product_productvariantchannellisting_channel_id_23e849ed; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_productvariantchannellisting_channel_id_23e849ed ON public.product_productvariantchannellisting USING btree (channel_id);


    --
    -- Name: product_productvariantchannellisting_variant_id_f8e7abba; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_productvariantchannellisting_variant_id_f8e7abba ON public.product_productvariantchannellisting USING btree (variant_id);


    --
    -- Name: product_productvarianttranslation_product_variant_id_1b144a85; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_productvarianttranslation_product_variant_id_1b144a85 ON public.product_productvarianttranslation USING btree (product_variant_id);


    --
    -- Name: product_search_gin; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_search_gin ON public.product_product USING gin (search_document public.gin_trgm_ops);


    --
    -- Name: product_tsearch; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_tsearch ON public.product_product USING gin (search_vector);


    --
    -- Name: product_type_search_gin; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_type_search_gin ON public.product_producttype USING gin (name public.gin_trgm_ops, slug public.gin_trgm_ops);


    --
    -- Name: product_variantchannellist_promotion_rule_id_af12d96f; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_variantchannellist_promotion_rule_id_af12d96f ON public.product_variantchannellistingpromotionrule USING btree (promotion_rule_id);


    --
    -- Name: product_variantchannellist_variant_channel_listing_id_3d6a575a; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_variantchannellist_variant_channel_listing_id_3d6a575a ON public.product_variantchannellistingpromotionrule USING btree (variant_channel_listing_id);


    --
    -- Name: product_variantmedia_media_id_e94208c4; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_variantmedia_media_id_e94208c4 ON public.product_variantmedia USING btree (media_id);


    --
    -- Name: product_variantmedia_variant_id_2a29a589; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX product_variantmedia_variant_id_2a29a589 ON public.product_variantmedia USING btree (variant_id);


    --
    -- Name: productmedia_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX productmedia_meta_idx ON public.product_productmedia USING gin (metadata);


    --
    -- Name: productmedia_p_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX productmedia_p_meta_idx ON public.product_productmedia USING gin (private_metadata);


    --
    -- Name: producttype_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX producttype_meta_idx ON public.product_producttype USING gin (metadata);


    --
    -- Name: producttype_p_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX producttype_p_meta_idx ON public.product_producttype USING gin (private_metadata);


    --
    -- Name: productvariant_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX productvariant_meta_idx ON public.product_productvariant USING gin (metadata);


    --
    -- Name: productvariant_p_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX productvariant_p_meta_idx ON public.product_productvariant USING gin (private_metadata);


    --
    -- Name: s_z_countries_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX s_z_countries_idx ON public.shipping_shippingzone USING gin (countries public.gin_trgm_ops);


    --
    -- Name: schedulers_customperiodictask_custom_id_2ce85a70; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX schedulers_customperiodictask_custom_id_2ce85a70 ON public.schedulers_customperiodictask USING btree (custom_id);


    --
    -- Name: schedulers_customschedule_schedule_import_path_d6057fed_like; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX schedulers_customschedule_schedule_import_path_d6057fed_like ON public.schedulers_customschedule USING btree (schedule_import_path varchar_pattern_ops);


    --
    -- Name: shipping_shippingmethod_ex_shippingmethod_id_a522e057; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX shipping_shippingmethod_ex_shippingmethod_id_a522e057 ON public.shipping_shippingmethod_excluded_products USING btree (shippingmethod_id);


    --
    -- Name: shipping_shippingmethod_excluded_products_product_id_c2c20af6; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX shipping_shippingmethod_excluded_products_product_id_c2c20af6 ON public.shipping_shippingmethod_excluded_products USING btree (product_id);


    --
    -- Name: shipping_shippingmethod_shipping_zone_id_265b7413; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX shipping_shippingmethod_shipping_zone_id_265b7413 ON public.shipping_shippingmethod USING btree (shipping_zone_id);


    --
    -- Name: shipping_shippingmethod_tax_class_id_59ec5c19; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX shipping_shippingmethod_tax_class_id_59ec5c19 ON public.shipping_shippingmethod USING btree (tax_class_id);


    --
    -- Name: shipping_shippingmethodcha_shipping_method_id_20c0bc65; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX shipping_shippingmethodcha_shipping_method_id_20c0bc65 ON public.shipping_shippingmethodchannellisting USING btree (shipping_method_id);


    --
    -- Name: shipping_shippingmethodchannellisting_channel_id_10933a3c; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX shipping_shippingmethodchannellisting_channel_id_10933a3c ON public.shipping_shippingmethodchannellisting USING btree (channel_id);


    --
    -- Name: shipping_shippingmethodtranslation_shipping_method_id_31d925d2; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX shipping_shippingmethodtranslation_shipping_method_id_31d925d2 ON public.shipping_shippingmethodtranslation USING btree (shipping_method_id);


    --
    -- Name: shipping_shippingmethodzipcoderule_shipping_method_id_825fd462; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX shipping_shippingmethodzipcoderule_shipping_method_id_825fd462 ON public.shipping_shippingmethodpostalcoderule USING btree (shipping_method_id);


    --
    -- Name: shipping_shippingzone_channels_channel_id_36548abc; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX shipping_shippingzone_channels_channel_id_36548abc ON public.shipping_shippingzone_channels USING btree (channel_id);


    --
    -- Name: shipping_shippingzone_channels_shippingzone_id_6724d6e4; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX shipping_shippingzone_channels_shippingzone_id_6724d6e4 ON public.shipping_shippingzone_channels USING btree (shippingzone_id);


    --
    -- Name: shippingmethod_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX shippingmethod_meta_idx ON public.shipping_shippingmethod USING gin (metadata);


    --
    -- Name: shippingmethod_p_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX shippingmethod_p_meta_idx ON public.shipping_shippingmethod USING gin (private_metadata);


    --
    -- Name: shippingzone_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX shippingzone_meta_idx ON public.shipping_shippingzone USING gin (metadata);


    --
    -- Name: shippingzone_p_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX shippingzone_p_meta_idx ON public.shipping_shippingzone USING gin (private_metadata);


    --
    -- Name: site_sitesettings_bottom_menu_id_e2a78098; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX site_sitesettings_bottom_menu_id_e2a78098 ON public.site_sitesettings USING btree (bottom_menu_id);


    --
    -- Name: site_sitesettings_company_address_id_f0825427; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX site_sitesettings_company_address_id_f0825427 ON public.site_sitesettings USING btree (company_address_id);


    --
    -- Name: site_sitesettings_top_menu_id_ab6f8c46; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX site_sitesettings_top_menu_id_ab6f8c46 ON public.site_sitesettings USING btree (top_menu_id);


    --
    -- Name: site_sitesettingstranslation_site_settings_id_ca085ff6; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX site_sitesettingstranslation_site_settings_id_ca085ff6 ON public.site_sitesettingstranslation USING btree (site_settings_id);


    --
    -- Name: start_date_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX start_date_idx ON public.discount_promotion USING btree (start_date);


    --
    -- Name: tax_taxclasscountryrate_tax_class_id_6ce938aa; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX tax_taxclasscountryrate_tax_class_id_6ce938aa ON public.tax_taxclasscountryrate USING btree (tax_class_id);


    --
    -- Name: tax_taxconfigurationpercountry_tax_configuration_id_63347e1b; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX tax_taxconfigurationpercountry_tax_configuration_id_63347e1b ON public.tax_taxconfigurationpercountry USING btree (tax_configuration_id);


    --
    -- Name: thumbnail_thumbnail_app_id_aa70f2d4; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX thumbnail_thumbnail_app_id_aa70f2d4 ON public.thumbnail_thumbnail USING btree (app_id);


    --
    -- Name: thumbnail_thumbnail_app_installation_id_a5a97d99; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX thumbnail_thumbnail_app_installation_id_a5a97d99 ON public.thumbnail_thumbnail USING btree (app_installation_id);


    --
    -- Name: thumbnail_thumbnail_category_id_e3196106; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX thumbnail_thumbnail_category_id_e3196106 ON public.thumbnail_thumbnail USING btree (category_id);


    --
    -- Name: thumbnail_thumbnail_collection_id_0aa16183; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX thumbnail_thumbnail_collection_id_0aa16183 ON public.thumbnail_thumbnail USING btree (collection_id);


    --
    -- Name: thumbnail_thumbnail_product_media_id_85602a99; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX thumbnail_thumbnail_product_media_id_85602a99 ON public.thumbnail_thumbnail USING btree (product_media_id);


    --
    -- Name: thumbnail_thumbnail_user_id_0bc68981; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX thumbnail_thumbnail_user_id_0bc68981 ON public.thumbnail_thumbnail USING btree (user_id);


    --
    -- Name: transactionitem_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX transactionitem_meta_idx ON public.payment_transactionitem USING gin (metadata);


    --
    -- Name: transactionitem_p_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX transactionitem_p_meta_idx ON public.payment_transactionitem USING gin (private_metadata);


    --
    -- Name: unique_country_without_tax_class; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE UNIQUE INDEX unique_country_without_tax_class ON public.tax_taxclasscountryrate USING btree (country) WHERE (tax_class_id IS NULL);


    --
    -- Name: updated_at_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX updated_at_idx ON public.product_category USING btree (updated_at);


    --
    -- Name: user_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX user_meta_idx ON public.account_user USING gin (metadata);


    --
    -- Name: user_p_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX user_p_meta_idx ON public.account_user USING gin (private_metadata);


    --
    -- Name: user_p_meta_jsonb_path_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX user_p_meta_jsonb_path_idx ON public.account_user USING gin (private_metadata jsonb_path_ops);


    --
    -- Name: user_search_gin; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX user_search_gin ON public.account_user USING gin (search_document public.gin_trgm_ops);


    --
    -- Name: userprofile_user_addresses_address_id_ad7646b4; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX userprofile_user_addresses_address_id_ad7646b4 ON public.account_user_addresses USING btree (address_id);


    --
    -- Name: userprofile_user_addresses_user_id_bb5aa55e; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX userprofile_user_addresses_user_id_bb5aa55e ON public.account_user_addresses USING btree (user_id);


    --
    -- Name: userprofile_user_default_billing_address_id_0489abf1; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX userprofile_user_default_billing_address_id_0489abf1 ON public.account_user USING btree (default_billing_address_id);


    --
    -- Name: userprofile_user_default_shipping_address_id_aae7a203; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX userprofile_user_default_shipping_address_id_aae7a203 ON public.account_user USING btree (default_shipping_address_id);


    --
    -- Name: userprofile_user_email_b0fb0137_like; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX userprofile_user_email_b0fb0137_like ON public.account_user USING btree (email varchar_pattern_ops);


    --
    -- Name: userprofile_user_groups_group_id_c7eec74e; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX userprofile_user_groups_group_id_c7eec74e ON public.account_user_groups USING btree (group_id);


    --
    -- Name: userprofile_user_groups_user_id_5e712a24; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX userprofile_user_groups_user_id_5e712a24 ON public.account_user_groups USING btree (user_id);


    --
    -- Name: userprofile_user_user_permissions_permission_id_1caa8a71; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX userprofile_user_user_permissions_permission_id_1caa8a71 ON public.account_user_user_permissions USING btree (permission_id);


    --
    -- Name: userprofile_user_user_permissions_user_id_6d654469; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX userprofile_user_user_permissions_user_id_6d654469 ON public.account_user_user_permissions USING btree (user_id);


    --
    -- Name: vouchercode_voucher_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX vouchercode_voucher_idx ON public.discount_vouchercode USING btree (voucher_id);


    --
    -- Name: vouchercustomer_voucher_code_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX vouchercustomer_voucher_code_idx ON public.discount_vouchercustomer USING btree (voucher_code_id);


    --
    -- Name: warehouse_address_search_gin; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX warehouse_address_search_gin ON public.account_address USING gin (company_name public.gin_trgm_ops, street_address_1 public.gin_trgm_ops, street_address_2 public.gin_trgm_ops, city public.gin_trgm_ops, postal_code public.gin_trgm_ops, phone public.gin_trgm_ops);


    --
    -- Name: warehouse_allocation_order_line_token_id_a42364d3; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX warehouse_allocation_order_line_token_id_a42364d3 ON public.warehouse_allocation USING btree (order_line_id);


    --
    -- Name: warehouse_allocation_stock_id_73541542; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX warehouse_allocation_stock_id_73541542 ON public.warehouse_allocation USING btree (stock_id);


    --
    -- Name: warehouse_channelwarehouse_sort_order_c572ec34; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX warehouse_channelwarehouse_sort_order_c572ec34 ON public.warehouse_channelwarehouse USING btree (sort_order);


    --
    -- Name: warehouse_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX warehouse_meta_idx ON public.warehouse_warehouse USING gin (metadata);


    --
    -- Name: warehouse_p_meta_idx; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX warehouse_p_meta_idx ON public.warehouse_warehouse USING gin (private_metadata);


    --
    -- Name: warehouse_preorderallocati_product_variant_channel_li_d243ee40; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX warehouse_preorderallocati_product_variant_channel_li_d243ee40 ON public.warehouse_preorderallocation USING btree (product_variant_channel_listing_id);


    --
    -- Name: warehouse_preorderallocation_order_line_token_id_5c2ada8e; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX warehouse_preorderallocation_order_line_token_id_5c2ada8e ON public.warehouse_preorderallocation USING btree (order_line_id);


    --
    -- Name: warehouse_preorderreservat_product_variant_channel_li_3c2d488e; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX warehouse_preorderreservat_product_variant_channel_li_3c2d488e ON public.warehouse_preorderreservation USING btree (product_variant_channel_listing_id);


    --
    -- Name: warehouse_preorderreservation_checkout_line_token_id_e35f4484; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX warehouse_preorderreservation_checkout_line_token_id_e35f4484 ON public.warehouse_preorderreservation USING btree (checkout_line_id);


    --
    -- Name: warehouse_reservation_checkout_line_token_id_1b6b9353; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX warehouse_reservation_checkout_line_token_id_1b6b9353 ON public.warehouse_reservation USING btree (checkout_line_id);


    --
    -- Name: warehouse_reservation_stock_id_5d178c00; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX warehouse_reservation_stock_id_5d178c00 ON public.warehouse_reservation USING btree (stock_id);


    --
    -- Name: warehouse_stock_product_variant_id_bea58a82; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX warehouse_stock_product_variant_id_bea58a82 ON public.warehouse_stock USING btree (product_variant_id);


    --
    -- Name: warehouse_stock_warehouse_id_cc9d4e5d; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX warehouse_stock_warehouse_id_cc9d4e5d ON public.warehouse_stock USING btree (warehouse_id);


    --
    -- Name: warehouse_warehouse_address_id_d46e1096; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX warehouse_warehouse_address_id_d46e1096 ON public.warehouse_warehouse USING btree (address_id);


    --
    -- Name: warehouse_warehouse_channels_channel_id_586b1124; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX warehouse_warehouse_channels_channel_id_586b1124 ON public.warehouse_channelwarehouse USING btree (channel_id);


    --
    -- Name: warehouse_warehouse_channels_warehouse_id_d1b0e96d; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX warehouse_warehouse_channels_warehouse_id_d1b0e96d ON public.warehouse_channelwarehouse USING btree (warehouse_id);


    --
    -- Name: warehouse_warehouse_external_reference_9b228bae_like; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX warehouse_warehouse_external_reference_9b228bae_like ON public.warehouse_warehouse USING btree (external_reference varchar_pattern_ops);


    --
    -- Name: warehouse_warehouse_shipping_zones_shippingzone_id_aeee255b; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX warehouse_warehouse_shipping_zones_shippingzone_id_aeee255b ON public.warehouse_warehouse_shipping_zones USING btree (shippingzone_id);


    --
    -- Name: warehouse_warehouse_shipping_zones_warehouse_id_fccd6647; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX warehouse_warehouse_shipping_zones_warehouse_id_fccd6647 ON public.warehouse_warehouse_shipping_zones USING btree (warehouse_id);


    --
    -- Name: warehouse_warehouse_slug_5ca9c575_like; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX warehouse_warehouse_slug_5ca9c575_like ON public.warehouse_warehouse USING btree (slug varchar_pattern_ops);


    --
    -- Name: webhook_webhook_service_account_id_1073b057; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX webhook_webhook_service_account_id_1073b057 ON public.webhook_webhook USING btree (app_id);


    --
    -- Name: webhook_webhookevent_event_type_cd6b8c13; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX webhook_webhookevent_event_type_cd6b8c13 ON public.webhook_webhookevent USING btree (event_type);


    --
    -- Name: webhook_webhookevent_event_type_cd6b8c13_like; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX webhook_webhookevent_event_type_cd6b8c13_like ON public.webhook_webhookevent USING btree (event_type varchar_pattern_ops);


    --
    -- Name: webhook_webhookevent_webhook_id_73b5c9e1; Type: INDEX; Schema: public; Owner: saleor
    --

    CREATE INDEX webhook_webhookevent_webhook_id_73b5c9e1 ON public.webhook_webhookevent USING btree (webhook_id);


    --
    -- Name: account_customerevent account_customerevent_app_id_b022b4d7_fk_app_app_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_customerevent
        ADD CONSTRAINT account_customerevent_app_id_b022b4d7_fk_app_app_id FOREIGN KEY (app_id) REFERENCES public.app_app(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: account_customerevent account_customerevent_order_id_2d6e2d20_fk_order_order_token; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_customerevent
        ADD CONSTRAINT account_customerevent_order_id_2d6e2d20_fk_order_order_token FOREIGN KEY (order_id) REFERENCES public.order_order(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: account_customerevent account_customerevent_user_id_b3d6ec36_fk_account_user_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_customerevent
        ADD CONSTRAINT account_customerevent_user_id_b3d6ec36_fk_account_user_id FOREIGN KEY (user_id) REFERENCES public.account_user(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: account_customernote account_customernote_customer_id_ec50cbf6_fk_account_user_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_customernote
        ADD CONSTRAINT account_customernote_customer_id_ec50cbf6_fk_account_user_id FOREIGN KEY (customer_id) REFERENCES public.account_user(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: account_customernote account_customernote_user_id_b10a6c14_fk_account_user_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_customernote
        ADD CONSTRAINT account_customernote_user_id_b10a6c14_fk_account_user_id FOREIGN KEY (user_id) REFERENCES public.account_user(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: account_group_channels account_group_channe_channel_id_04ca83ef_fk_channel_c; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_group_channels
        ADD CONSTRAINT account_group_channe_channel_id_04ca83ef_fk_channel_c FOREIGN KEY (channel_id) REFERENCES public.channel_channel(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: account_group_channels account_group_channels_group_id_301893d0_fk_account_group_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_group_channels
        ADD CONSTRAINT account_group_channels_group_id_301893d0_fk_account_group_id FOREIGN KEY (group_id) REFERENCES public.account_group(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: account_group_permissions account_group_permis_permission_id_f654f978_fk_permissio; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_group_permissions
        ADD CONSTRAINT account_group_permis_permission_id_f654f978_fk_permissio FOREIGN KEY (permission_id) REFERENCES public.permission_permission(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: account_group_permissions account_group_permissions_group_id_37f7fcd9_fk_account_group_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_group_permissions
        ADD CONSTRAINT account_group_permissions_group_id_37f7fcd9_fk_account_group_id FOREIGN KEY (group_id) REFERENCES public.account_group(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: account_staffnotificationrecipient account_staffnotific_user_id_538fa3a4_fk_account_u; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_staffnotificationrecipient
        ADD CONSTRAINT account_staffnotific_user_id_538fa3a4_fk_account_u FOREIGN KEY (user_id) REFERENCES public.account_user(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: account_user_groups account_user_groups_group_id_6c71f749_fk_account_group_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_user_groups
        ADD CONSTRAINT account_user_groups_group_id_6c71f749_fk_account_group_id FOREIGN KEY (group_id) REFERENCES public.account_group(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: account_user_user_permissions account_user_user_pe_permission_id_66c44191_fk_permissio; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_user_user_permissions
        ADD CONSTRAINT account_user_user_pe_permission_id_66c44191_fk_permissio FOREIGN KEY (permission_id) REFERENCES public.permission_permission(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: app_app_permissions app_app_permissions_app_id_5941597d_fk_app_app_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.app_app_permissions
        ADD CONSTRAINT app_app_permissions_app_id_5941597d_fk_app_app_id FOREIGN KEY (app_id) REFERENCES public.app_app(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: app_app_permissions app_app_permissions_permission_id_defe4a88_fk_permissio; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.app_app_permissions
        ADD CONSTRAINT app_app_permissions_permission_id_defe4a88_fk_permissio FOREIGN KEY (permission_id) REFERENCES public.permission_permission(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: app_appextension app_appextension_app_id_4b2d27e9_fk_app_app_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.app_appextension
        ADD CONSTRAINT app_appextension_app_id_4b2d27e9_fk_app_app_id FOREIGN KEY (app_id) REFERENCES public.app_app(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: app_appextension_permissions app_appextension_per_appextension_id_8ad99c02_fk_app_appex; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.app_appextension_permissions
        ADD CONSTRAINT app_appextension_per_appextension_id_8ad99c02_fk_app_appex FOREIGN KEY (appextension_id) REFERENCES public.app_appextension(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: app_appextension_permissions app_appextension_per_permission_id_cb6c3ce0_fk_permissio; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.app_appextension_permissions
        ADD CONSTRAINT app_appextension_per_permission_id_cb6c3ce0_fk_permissio FOREIGN KEY (permission_id) REFERENCES public.permission_permission(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: app_appinstallation_permissions app_appinstallation__appinstallation_id_f7fe0271_fk_app_appin; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.app_appinstallation_permissions
        ADD CONSTRAINT app_appinstallation__appinstallation_id_f7fe0271_fk_app_appin FOREIGN KEY (appinstallation_id) REFERENCES public.app_appinstallation(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: app_appinstallation_permissions app_appinstallation__permission_id_4ee9f6c8_fk_permissio; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.app_appinstallation_permissions
        ADD CONSTRAINT app_appinstallation__permission_id_4ee9f6c8_fk_permissio FOREIGN KEY (permission_id) REFERENCES public.permission_permission(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: app_apptoken app_apptoken_app_id_68561141_fk_app_app_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.app_apptoken
        ADD CONSTRAINT app_apptoken_app_id_68561141_fk_app_app_id FOREIGN KEY (app_id) REFERENCES public.app_app(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: attribute_assignedpageattributevalue attribute_assignedpa_page_id_3a9fcc7b_fk_page_page; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_assignedpageattributevalue
        ADD CONSTRAINT attribute_assignedpa_page_id_3a9fcc7b_fk_page_page FOREIGN KEY (page_id) REFERENCES public.page_page(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: attribute_assignedpageattributevalue attribute_assignedpa_value_id_9d9ee1aa_fk_attribute; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_assignedpageattributevalue
        ADD CONSTRAINT attribute_assignedpa_value_id_9d9ee1aa_fk_attribute FOREIGN KEY (value_id) REFERENCES public.attribute_attributevalue(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: attribute_assignedproductattributevalue attribute_assignedpr_product_id_805656f1_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_assignedproductattributevalue
        ADD CONSTRAINT attribute_assignedpr_product_id_805656f1_fk_product_p FOREIGN KEY (product_id) REFERENCES public.product_product(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: attribute_assignedproductattributevalue attribute_assignedpr_value_id_9b9c0c68_fk_attribute; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_assignedproductattributevalue
        ADD CONSTRAINT attribute_assignedpr_value_id_9b9c0c68_fk_attribute FOREIGN KEY (value_id) REFERENCES public.attribute_attributevalue(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: attribute_assignedvariantattributevalue attribute_assignedva_assignment_id_040f7499_fk_attribute; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_assignedvariantattributevalue
        ADD CONSTRAINT attribute_assignedva_assignment_id_040f7499_fk_attribute FOREIGN KEY (assignment_id) REFERENCES public.attribute_assignedvariantattribute(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: attribute_assignedvariantattributevalue attribute_assignedva_value_id_4bbdc9fa_fk_attribute; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_assignedvariantattributevalue
        ADD CONSTRAINT attribute_assignedva_value_id_4bbdc9fa_fk_attribute FOREIGN KEY (value_id) REFERENCES public.attribute_attributevalue(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: attribute_attributevalue attribute_attributev_reference_page_id_33727843_fk_page_page; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_attributevalue
        ADD CONSTRAINT attribute_attributev_reference_page_id_33727843_fk_page_page FOREIGN KEY (reference_page_id) REFERENCES public.page_page(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: attribute_attributevalue attribute_attributev_reference_product_id_43329b37_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_attributevalue
        ADD CONSTRAINT attribute_attributev_reference_product_id_43329b37_fk_product_p FOREIGN KEY (reference_product_id) REFERENCES public.product_product(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: attribute_attributevalue attribute_attributev_reference_variant_id_670c09ee_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_attributevalue
        ADD CONSTRAINT attribute_attributev_reference_variant_id_670c09ee_fk_product_p FOREIGN KEY (reference_variant_id) REFERENCES public.product_productvariant(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: checkout_checkout cart_cart_billing_address_id_9eb62ddd_fk_account_address_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.checkout_checkout
        ADD CONSTRAINT cart_cart_billing_address_id_9eb62ddd_fk_account_address_id FOREIGN KEY (billing_address_id) REFERENCES public.account_address(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: checkout_checkout cart_cart_shipping_address_id_adfddaf9_fk_account_address_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.checkout_checkout
        ADD CONSTRAINT cart_cart_shipping_address_id_adfddaf9_fk_account_address_id FOREIGN KEY (shipping_address_id) REFERENCES public.account_address(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: checkout_checkout cart_cart_user_id_9b4220b9_fk_userprofile_user_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.checkout_checkout
        ADD CONSTRAINT cart_cart_user_id_9b4220b9_fk_userprofile_user_id FOREIGN KEY (user_id) REFERENCES public.account_user(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: checkout_checkoutline cart_cartline_variant_id_dbca56c9_fk_product_productvariant_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.checkout_checkoutline
        ADD CONSTRAINT cart_cartline_variant_id_dbca56c9_fk_product_productvariant_id FOREIGN KEY (variant_id) REFERENCES public.product_productvariant(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: checkout_checkout checkout_cart_shipping_method_id_9f7efa8a_fk_shipping_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.checkout_checkout
        ADD CONSTRAINT checkout_cart_shipping_method_id_9f7efa8a_fk_shipping_ FOREIGN KEY (shipping_method_id) REFERENCES public.shipping_shippingmethod(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: checkout_checkoutline checkout_cartline_checkout_id_41d95a5d_fk_checkout_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.checkout_checkoutline
        ADD CONSTRAINT checkout_cartline_checkout_id_41d95a5d_fk_checkout_ FOREIGN KEY (checkout_id) REFERENCES public.checkout_checkout(token) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: checkout_checkout checkout_checkout_channel_id_3b1a1e12_fk_channel_channel_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.checkout_checkout
        ADD CONSTRAINT checkout_checkout_channel_id_3b1a1e12_fk_channel_channel_id FOREIGN KEY (channel_id) REFERENCES public.channel_channel(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: checkout_checkout checkout_checkout_collection_point_id_2dfc8e33_fk_warehouse; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.checkout_checkout
        ADD CONSTRAINT checkout_checkout_collection_point_id_2dfc8e33_fk_warehouse FOREIGN KEY (collection_point_id) REFERENCES public.warehouse_warehouse(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: checkout_checkout_gift_cards checkout_checkout_gi_checkout_id_e314728d_fk_checkout_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.checkout_checkout_gift_cards
        ADD CONSTRAINT checkout_checkout_gi_checkout_id_e314728d_fk_checkout_ FOREIGN KEY (checkout_id) REFERENCES public.checkout_checkout(token) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: checkout_checkout_gift_cards checkout_checkout_gi_giftcard_id_f5994462_fk_giftcard_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.checkout_checkout_gift_cards
        ADD CONSTRAINT checkout_checkout_gi_giftcard_id_f5994462_fk_giftcard_ FOREIGN KEY (giftcard_id) REFERENCES public.giftcard_giftcard(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: checkout_checkoutmetadata checkout_checkoutmet_checkout_id_24c0ce82_fk_checkout_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.checkout_checkoutmetadata
        ADD CONSTRAINT checkout_checkoutmet_checkout_id_24c0ce82_fk_checkout_ FOREIGN KEY (checkout_id) REFERENCES public.checkout_checkout(token) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: core_eventdelivery core_eventdelivery_payload_id_34de9fbd_fk_core_eventpayload_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.core_eventdelivery
        ADD CONSTRAINT core_eventdelivery_payload_id_34de9fbd_fk_core_eventpayload_id FOREIGN KEY (payload_id) REFERENCES public.core_eventpayload(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: core_eventdelivery core_eventdelivery_webhook_id_1ff668bb_fk_webhook_webhook_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.core_eventdelivery
        ADD CONSTRAINT core_eventdelivery_webhook_id_1ff668bb_fk_webhook_webhook_id FOREIGN KEY (webhook_id) REFERENCES public.webhook_webhook(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: core_eventdeliveryattempt core_eventdeliveryat_delivery_id_278cb539_fk_core_even; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.core_eventdeliveryattempt
        ADD CONSTRAINT core_eventdeliveryat_delivery_id_278cb539_fk_core_even FOREIGN KEY (delivery_id) REFERENCES public.core_eventdelivery(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: csv_exportevent csv_exportevent_app_id_8637fcc5_fk_app_app_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.csv_exportevent
        ADD CONSTRAINT csv_exportevent_app_id_8637fcc5_fk_app_app_id FOREIGN KEY (app_id) REFERENCES public.app_app(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: csv_exportevent csv_exportevent_export_file_id_35f6c448_fk_csv_exportfile_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.csv_exportevent
        ADD CONSTRAINT csv_exportevent_export_file_id_35f6c448_fk_csv_exportfile_id FOREIGN KEY (export_file_id) REFERENCES public.csv_exportfile(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: csv_exportevent csv_exportevent_user_id_6111f193_fk_account_user_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.csv_exportevent
        ADD CONSTRAINT csv_exportevent_user_id_6111f193_fk_account_user_id FOREIGN KEY (user_id) REFERENCES public.account_user(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: csv_exportfile csv_exportfile_app_id_bc900999_fk_app_app_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.csv_exportfile
        ADD CONSTRAINT csv_exportfile_app_id_bc900999_fk_app_app_id FOREIGN KEY (app_id) REFERENCES public.app_app(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: csv_exportfile csv_exportfile_user_id_2c9071e6_fk_account_user_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.csv_exportfile
        ADD CONSTRAINT csv_exportfile_user_id_2c9071e6_fk_account_user_id FOREIGN KEY (user_id) REFERENCES public.account_user(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: discount_checkoutdiscount discount_checkoutdis_checkout_id_e5063abc_fk_checkout_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_checkoutdiscount
        ADD CONSTRAINT discount_checkoutdis_checkout_id_e5063abc_fk_checkout_ FOREIGN KEY (checkout_id) REFERENCES public.checkout_checkout(token) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: discount_checkoutdiscount discount_checkoutdis_promotion_rule_id_46ea4527_fk_discount_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_checkoutdiscount
        ADD CONSTRAINT discount_checkoutdis_promotion_rule_id_46ea4527_fk_discount_ FOREIGN KEY (promotion_rule_id) REFERENCES public.discount_promotionrule(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: discount_checkoutdiscount discount_checkoutdis_voucher_id_1ef32adb_fk_discount_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_checkoutdiscount
        ADD CONSTRAINT discount_checkoutdis_voucher_id_1ef32adb_fk_discount_ FOREIGN KEY (voucher_id) REFERENCES public.discount_voucher(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: discount_checkoutlinediscount discount_checkoutlin_line_id_b93245a9_fk_checkout_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_checkoutlinediscount
        ADD CONSTRAINT discount_checkoutlin_line_id_b93245a9_fk_checkout_ FOREIGN KEY (line_id) REFERENCES public.checkout_checkoutline(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: discount_checkoutlinediscount discount_checkoutlin_promotion_rule_id_3ffa49f6_fk_discount_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_checkoutlinediscount
        ADD CONSTRAINT discount_checkoutlin_promotion_rule_id_3ffa49f6_fk_discount_ FOREIGN KEY (promotion_rule_id) REFERENCES public.discount_promotionrule(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: discount_checkoutlinediscount discount_checkoutlin_voucher_id_66a61d93_fk_discount_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_checkoutlinediscount
        ADD CONSTRAINT discount_checkoutlin_voucher_id_66a61d93_fk_discount_ FOREIGN KEY (voucher_id) REFERENCES public.discount_voucher(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: discount_orderdiscount discount_orderdiscou_promotion_rule_id_0739e0af_fk_discount_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_orderdiscount
        ADD CONSTRAINT discount_orderdiscou_promotion_rule_id_0739e0af_fk_discount_ FOREIGN KEY (promotion_rule_id) REFERENCES public.discount_promotionrule(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: discount_orderdiscount discount_orderdiscou_voucher_id_10f0a1db_fk_discount_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_orderdiscount
        ADD CONSTRAINT discount_orderdiscou_voucher_id_10f0a1db_fk_discount_ FOREIGN KEY (voucher_id) REFERENCES public.discount_voucher(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: discount_orderdiscount discount_orderdiscount_order_id_fcff1737_fk_order_order_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_orderdiscount
        ADD CONSTRAINT discount_orderdiscount_order_id_fcff1737_fk_order_order_id FOREIGN KEY (order_id) REFERENCES public.order_order(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: discount_orderlinediscount discount_orderlinedi_line_id_045244c7_fk_order_ord; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_orderlinediscount
        ADD CONSTRAINT discount_orderlinedi_line_id_045244c7_fk_order_ord FOREIGN KEY (line_id) REFERENCES public.order_orderline(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: discount_orderlinediscount discount_orderlinedi_promotion_rule_id_c8253b01_fk_discount_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_orderlinediscount
        ADD CONSTRAINT discount_orderlinedi_promotion_rule_id_c8253b01_fk_discount_ FOREIGN KEY (promotion_rule_id) REFERENCES public.discount_promotionrule(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: discount_orderlinediscount discount_orderlinedi_voucher_id_07e8fb8a_fk_discount_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_orderlinediscount
        ADD CONSTRAINT discount_orderlinedi_voucher_id_07e8fb8a_fk_discount_ FOREIGN KEY (voucher_id) REFERENCES public.discount_voucher(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: discount_promotionevent discount_promotionev_promotion_id_df51584a_fk_discount_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_promotionevent
        ADD CONSTRAINT discount_promotionev_promotion_id_df51584a_fk_discount_ FOREIGN KEY (promotion_id) REFERENCES public.discount_promotion(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: discount_promotionevent discount_promotionevent_app_id_bf6964c4_fk_app_app_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_promotionevent
        ADD CONSTRAINT discount_promotionevent_app_id_bf6964c4_fk_app_app_id FOREIGN KEY (app_id) REFERENCES public.app_app(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: discount_promotionevent discount_promotionevent_user_id_935d264f_fk_account_user_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_promotionevent
        ADD CONSTRAINT discount_promotionevent_user_id_935d264f_fk_account_user_id FOREIGN KEY (user_id) REFERENCES public.account_user(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: discount_promotionrule_channels discount_promotionru_channel_id_698c2436_fk_channel_c; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_promotionrule_channels
        ADD CONSTRAINT discount_promotionru_channel_id_698c2436_fk_channel_c FOREIGN KEY (channel_id) REFERENCES public.channel_channel(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: discount_promotionrule_gifts discount_promotionru_productvariant_id_5409d0a9_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_promotionrule_gifts
        ADD CONSTRAINT discount_promotionru_productvariant_id_5409d0a9_fk_product_p FOREIGN KEY (productvariant_id) REFERENCES public.product_productvariant(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: discount_promotionrule_variants discount_promotionru_productvariant_id_e715ba55_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_promotionrule_variants
        ADD CONSTRAINT discount_promotionru_productvariant_id_e715ba55_fk_product_p FOREIGN KEY (productvariant_id) REFERENCES public.product_productvariant(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: discount_promotionrule discount_promotionru_promotion_id_6deaa086_fk_discount_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_promotionrule
        ADD CONSTRAINT discount_promotionru_promotion_id_6deaa086_fk_discount_ FOREIGN KEY (promotion_id) REFERENCES public.discount_promotion(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: discount_promotionruletranslation discount_promotionru_promotion_rule_id_e2ab38d7_fk_discount_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_promotionruletranslation
        ADD CONSTRAINT discount_promotionru_promotion_rule_id_e2ab38d7_fk_discount_ FOREIGN KEY (promotion_rule_id) REFERENCES public.discount_promotionrule(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: discount_promotionrule_channels discount_promotionru_promotionrule_id_878da3b9_fk_discount_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_promotionrule_channels
        ADD CONSTRAINT discount_promotionru_promotionrule_id_878da3b9_fk_discount_ FOREIGN KEY (promotionrule_id) REFERENCES public.discount_promotionrule(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: discount_promotionrule_variants discount_promotionru_promotionrule_id_d16c1004_fk_discount_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_promotionrule_variants
        ADD CONSTRAINT discount_promotionru_promotionrule_id_d16c1004_fk_discount_ FOREIGN KEY (promotionrule_id) REFERENCES public.discount_promotionrule(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: discount_promotionrule_gifts discount_promotionru_promotionrule_id_d56c403e_fk_discount_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_promotionrule_gifts
        ADD CONSTRAINT discount_promotionru_promotionrule_id_d56c403e_fk_discount_ FOREIGN KEY (promotionrule_id) REFERENCES public.discount_promotionrule(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: discount_promotiontranslation discount_promotiontr_promotion_id_bc72ea07_fk_discount_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_promotiontranslation
        ADD CONSTRAINT discount_promotiontr_promotion_id_bc72ea07_fk_discount_ FOREIGN KEY (promotion_id) REFERENCES public.discount_promotion(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: discount_voucher_categories discount_voucher_cat_category_id_fc9d044a_fk_product_c; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_voucher_categories
        ADD CONSTRAINT discount_voucher_cat_category_id_fc9d044a_fk_product_c FOREIGN KEY (category_id) REFERENCES public.product_category(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: discount_voucher_categories discount_voucher_cat_voucher_id_19a56338_fk_discount_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_voucher_categories
        ADD CONSTRAINT discount_voucher_cat_voucher_id_19a56338_fk_discount_ FOREIGN KEY (voucher_id) REFERENCES public.discount_voucher(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: discount_voucher_collections discount_voucher_col_collection_id_b9de6b54_fk_product_c; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_voucher_collections
        ADD CONSTRAINT discount_voucher_col_collection_id_b9de6b54_fk_product_c FOREIGN KEY (collection_id) REFERENCES public.product_collection(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: discount_voucher_collections discount_voucher_col_voucher_id_4ce1fde3_fk_discount_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_voucher_collections
        ADD CONSTRAINT discount_voucher_col_voucher_id_4ce1fde3_fk_discount_ FOREIGN KEY (voucher_id) REFERENCES public.discount_voucher(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: discount_voucher_products discount_voucher_pro_product_id_4a3131ff_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_voucher_products
        ADD CONSTRAINT discount_voucher_pro_product_id_4a3131ff_fk_product_p FOREIGN KEY (product_id) REFERENCES public.product_product(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: discount_voucher_products discount_voucher_pro_voucher_id_8a2e6c3a_fk_discount_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_voucher_products
        ADD CONSTRAINT discount_voucher_pro_voucher_id_8a2e6c3a_fk_discount_ FOREIGN KEY (voucher_id) REFERENCES public.discount_voucher(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: discount_voucher_variants discount_voucher_var_productvariant_id_dcab0bb4_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_voucher_variants
        ADD CONSTRAINT discount_voucher_var_productvariant_id_dcab0bb4_fk_product_p FOREIGN KEY (productvariant_id) REFERENCES public.product_productvariant(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: discount_voucher_variants discount_voucher_var_voucher_id_40d96698_fk_discount_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_voucher_variants
        ADD CONSTRAINT discount_voucher_var_voucher_id_40d96698_fk_discount_ FOREIGN KEY (voucher_id) REFERENCES public.discount_voucher(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: discount_voucherchannellisting discount_voucherchan_channel_id_09f3ed34_fk_channel_c; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_voucherchannellisting
        ADD CONSTRAINT discount_voucherchan_channel_id_09f3ed34_fk_channel_c FOREIGN KEY (channel_id) REFERENCES public.channel_channel(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: discount_voucherchannellisting discount_voucherchan_voucher_id_7963fcbd_fk_discount_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_voucherchannellisting
        ADD CONSTRAINT discount_voucherchan_voucher_id_7963fcbd_fk_discount_ FOREIGN KEY (voucher_id) REFERENCES public.discount_voucher(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: discount_vouchercode discount_vouchercode_voucher_id_2720b92f_fk_discount_voucher_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_vouchercode
        ADD CONSTRAINT discount_vouchercode_voucher_id_2720b92f_fk_discount_voucher_id FOREIGN KEY (voucher_id) REFERENCES public.discount_voucher(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: discount_vouchercustomer discount_vouchercust_voucher_code_id_3585f0db_fk_discount_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_vouchercustomer
        ADD CONSTRAINT discount_vouchercust_voucher_code_id_3585f0db_fk_discount_ FOREIGN KEY (voucher_code_id) REFERENCES public.discount_vouchercode(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: discount_vouchertranslation discount_vouchertran_voucher_id_288246a9_fk_discount_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.discount_vouchertranslation
        ADD CONSTRAINT discount_vouchertran_voucher_id_288246a9_fk_discount_ FOREIGN KEY (voucher_id) REFERENCES public.discount_voucher(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: django_celery_beat_periodictask django_celery_beat_p_clocked_id_47a69f82_fk_django_ce; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.django_celery_beat_periodictask
        ADD CONSTRAINT django_celery_beat_p_clocked_id_47a69f82_fk_django_ce FOREIGN KEY (clocked_id) REFERENCES public.django_celery_beat_clockedschedule(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: django_celery_beat_periodictask django_celery_beat_p_crontab_id_d3cba168_fk_django_ce; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.django_celery_beat_periodictask
        ADD CONSTRAINT django_celery_beat_p_crontab_id_d3cba168_fk_django_ce FOREIGN KEY (crontab_id) REFERENCES public.django_celery_beat_crontabschedule(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: django_celery_beat_periodictask django_celery_beat_p_interval_id_a8ca27da_fk_django_ce; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.django_celery_beat_periodictask
        ADD CONSTRAINT django_celery_beat_p_interval_id_a8ca27da_fk_django_ce FOREIGN KEY (interval_id) REFERENCES public.django_celery_beat_intervalschedule(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: django_celery_beat_periodictask django_celery_beat_p_solar_id_a87ce72c_fk_django_ce; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.django_celery_beat_periodictask
        ADD CONSTRAINT django_celery_beat_p_solar_id_a87ce72c_fk_django_ce FOREIGN KEY (solar_id) REFERENCES public.django_celery_beat_solarschedule(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: giftcard_giftcard giftcard_giftcard_app_id_8d9d46f0_fk_app_app_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.giftcard_giftcard
        ADD CONSTRAINT giftcard_giftcard_app_id_8d9d46f0_fk_app_app_id FOREIGN KEY (app_id) REFERENCES public.app_app(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: giftcard_giftcard giftcard_giftcard_created_by_id_b70093de_fk_account_user_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.giftcard_giftcard
        ADD CONSTRAINT giftcard_giftcard_created_by_id_b70093de_fk_account_user_id FOREIGN KEY (created_by_id) REFERENCES public.account_user(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: giftcard_giftcard giftcard_giftcard_fulfillment_line_id_f5bb8062_fk_order_ful; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.giftcard_giftcard
        ADD CONSTRAINT giftcard_giftcard_fulfillment_line_id_f5bb8062_fk_order_ful FOREIGN KEY (fulfillment_line_id) REFERENCES public.order_fulfillmentline(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: giftcard_giftcard giftcard_giftcard_product_id_d4ad7ecd_fk_product_product_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.giftcard_giftcard
        ADD CONSTRAINT giftcard_giftcard_product_id_d4ad7ecd_fk_product_product_id FOREIGN KEY (product_id) REFERENCES public.product_product(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: giftcard_giftcard_tags giftcard_giftcard_ta_giftcard_id_4e7e8444_fk_giftcard_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.giftcard_giftcard_tags
        ADD CONSTRAINT giftcard_giftcard_ta_giftcard_id_4e7e8444_fk_giftcard_ FOREIGN KEY (giftcard_id) REFERENCES public.giftcard_giftcard(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: giftcard_giftcard_tags giftcard_giftcard_ta_giftcardtag_id_8d425074_fk_giftcard_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.giftcard_giftcard_tags
        ADD CONSTRAINT giftcard_giftcard_ta_giftcardtag_id_8d425074_fk_giftcard_ FOREIGN KEY (giftcardtag_id) REFERENCES public.giftcard_giftcardtag(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: giftcard_giftcard giftcard_giftcard_used_by_id_4e019509_fk_account_user_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.giftcard_giftcard
        ADD CONSTRAINT giftcard_giftcard_used_by_id_4e019509_fk_account_user_id FOREIGN KEY (used_by_id) REFERENCES public.account_user(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: giftcard_giftcardevent giftcard_giftcardeve_gift_card_id_28f4a30a_fk_giftcard_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.giftcard_giftcardevent
        ADD CONSTRAINT giftcard_giftcardeve_gift_card_id_28f4a30a_fk_giftcard_ FOREIGN KEY (gift_card_id) REFERENCES public.giftcard_giftcard(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: giftcard_giftcardevent giftcard_giftcardevent_app_id_9e107653_fk_app_app_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.giftcard_giftcardevent
        ADD CONSTRAINT giftcard_giftcardevent_app_id_9e107653_fk_app_app_id FOREIGN KEY (app_id) REFERENCES public.app_app(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: giftcard_giftcardevent giftcard_giftcardevent_order_id_a934cb10_fk_order_order_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.giftcard_giftcardevent
        ADD CONSTRAINT giftcard_giftcardevent_order_id_a934cb10_fk_order_order_id FOREIGN KEY (order_id) REFERENCES public.order_order(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: giftcard_giftcardevent giftcard_giftcardevent_user_id_6b906b4a_fk_account_user_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.giftcard_giftcardevent
        ADD CONSTRAINT giftcard_giftcardevent_user_id_6b906b4a_fk_account_user_id FOREIGN KEY (user_id) REFERENCES public.account_user(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: invoice_invoice invoice_invoice_order_id_c5fc9ae9_fk_order_order_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.invoice_invoice
        ADD CONSTRAINT invoice_invoice_order_id_c5fc9ae9_fk_order_order_id FOREIGN KEY (order_id) REFERENCES public.order_order(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: invoice_invoiceevent invoice_invoiceevent_app_id_eb92fa41_fk_app_app_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.invoice_invoiceevent
        ADD CONSTRAINT invoice_invoiceevent_app_id_eb92fa41_fk_app_app_id FOREIGN KEY (app_id) REFERENCES public.app_app(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: invoice_invoiceevent invoice_invoiceevent_invoice_id_de0632ca_fk_invoice_invoice_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.invoice_invoiceevent
        ADD CONSTRAINT invoice_invoiceevent_invoice_id_de0632ca_fk_invoice_invoice_id FOREIGN KEY (invoice_id) REFERENCES public.invoice_invoice(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: invoice_invoiceevent invoice_invoiceevent_order_id_5a337f7a_fk_order_order_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.invoice_invoiceevent
        ADD CONSTRAINT invoice_invoiceevent_order_id_5a337f7a_fk_order_order_id FOREIGN KEY (order_id) REFERENCES public.order_order(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: invoice_invoiceevent invoice_invoiceevent_user_id_cd599b8d_fk_account_user_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.invoice_invoiceevent
        ADD CONSTRAINT invoice_invoiceevent_user_id_cd599b8d_fk_account_user_id FOREIGN KEY (user_id) REFERENCES public.account_user(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: menu_menuitem menu_menuitem_category_id_af353a3b_fk_product_category_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.menu_menuitem
        ADD CONSTRAINT menu_menuitem_category_id_af353a3b_fk_product_category_id FOREIGN KEY (category_id) REFERENCES public.product_category(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: menu_menuitem menu_menuitem_collection_id_b913b19e_fk_product_collection_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.menu_menuitem
        ADD CONSTRAINT menu_menuitem_collection_id_b913b19e_fk_product_collection_id FOREIGN KEY (collection_id) REFERENCES public.product_collection(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: menu_menuitem menu_menuitem_menu_id_f466b139_fk_menu_menu_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.menu_menuitem
        ADD CONSTRAINT menu_menuitem_menu_id_f466b139_fk_menu_menu_id FOREIGN KEY (menu_id) REFERENCES public.menu_menu(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: menu_menuitem menu_menuitem_page_id_a0c8f92d_fk_page_page_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.menu_menuitem
        ADD CONSTRAINT menu_menuitem_page_id_a0c8f92d_fk_page_page_id FOREIGN KEY (page_id) REFERENCES public.page_page(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: menu_menuitem menu_menuitem_parent_id_439f55a5_fk_menu_menuitem_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.menu_menuitem
        ADD CONSTRAINT menu_menuitem_parent_id_439f55a5_fk_menu_menuitem_id FOREIGN KEY (parent_id) REFERENCES public.menu_menuitem(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: menu_menuitemtranslation menu_menuitemtransla_menu_item_id_3445926c_fk_menu_menu; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.menu_menuitemtranslation
        ADD CONSTRAINT menu_menuitemtransla_menu_item_id_3445926c_fk_menu_menu FOREIGN KEY (menu_item_id) REFERENCES public.menu_menuitem(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: order_fulfillment order_fulfillment_order_id_02695111_fk_order_order_token; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_fulfillment
        ADD CONSTRAINT order_fulfillment_order_id_02695111_fk_order_order_token FOREIGN KEY (order_id) REFERENCES public.order_order(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: order_fulfillmentline order_fulfillmentlin_fulfillment_id_68f3291d_fk_order_ful; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_fulfillmentline
        ADD CONSTRAINT order_fulfillmentlin_fulfillment_id_68f3291d_fk_order_ful FOREIGN KEY (fulfillment_id) REFERENCES public.order_fulfillment(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: order_fulfillmentline order_fulfillmentlin_order_line_id_7d40e054_fk_order_ord; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_fulfillmentline
        ADD CONSTRAINT order_fulfillmentlin_order_line_id_7d40e054_fk_order_ord FOREIGN KEY (order_line_id) REFERENCES public.order_orderline(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: order_fulfillmentline order_fulfillmentline_stock_id_da5a99fe_fk_warehouse_stock_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_fulfillmentline
        ADD CONSTRAINT order_fulfillmentline_stock_id_da5a99fe_fk_warehouse_stock_id FOREIGN KEY (stock_id) REFERENCES public.warehouse_stock(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: order_order order_order_billing_address_id_8fe537cf_fk_userprofi; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_order
        ADD CONSTRAINT order_order_billing_address_id_8fe537cf_fk_userprofi FOREIGN KEY (billing_address_id) REFERENCES public.account_address(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: order_order order_order_channel_id_4dacf8a4_fk_channel_channel_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_order
        ADD CONSTRAINT order_order_channel_id_4dacf8a4_fk_channel_channel_id FOREIGN KEY (channel_id) REFERENCES public.channel_channel(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: order_order order_order_collection_point_id_0762767b_fk_warehouse; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_order
        ADD CONSTRAINT order_order_collection_point_id_0762767b_fk_warehouse FOREIGN KEY (collection_point_id) REFERENCES public.warehouse_warehouse(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: order_order_gift_cards order_order_gift_car_giftcard_id_f6844926_fk_giftcard_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_order_gift_cards
        ADD CONSTRAINT order_order_gift_car_giftcard_id_f6844926_fk_giftcard_ FOREIGN KEY (giftcard_id) REFERENCES public.giftcard_giftcard(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: order_order_gift_cards order_order_gift_cards_order_id_ce5608c4_fk_order_order_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_order_gift_cards
        ADD CONSTRAINT order_order_gift_cards_order_id_ce5608c4_fk_order_order_id FOREIGN KEY (order_id) REFERENCES public.order_order(id);


    --
    -- Name: order_order order_order_original_id_1dd680dd_fk_order_order_token; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_order
        ADD CONSTRAINT order_order_original_id_1dd680dd_fk_order_order_token FOREIGN KEY (original_id) REFERENCES public.order_order(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: order_order order_order_shipping_address_id_57e64931_fk_userprofi; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_order
        ADD CONSTRAINT order_order_shipping_address_id_57e64931_fk_userprofi FOREIGN KEY (shipping_address_id) REFERENCES public.account_address(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: order_order order_order_shipping_method_id_2a742834_fk_shipping_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_order
        ADD CONSTRAINT order_order_shipping_method_id_2a742834_fk_shipping_ FOREIGN KEY (shipping_method_id) REFERENCES public.shipping_shippingmethod(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: order_order order_order_shipping_tax_class_id_ec0a5734_fk_tax_taxclass_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_order
        ADD CONSTRAINT order_order_shipping_tax_class_id_ec0a5734_fk_tax_taxclass_id FOREIGN KEY (shipping_tax_class_id) REFERENCES public.tax_taxclass(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: order_order order_order_user_id_7cf9bc2b_fk_userprofile_user_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_order
        ADD CONSTRAINT order_order_user_id_7cf9bc2b_fk_userprofile_user_id FOREIGN KEY (user_id) REFERENCES public.account_user(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: order_order order_order_voucher_id_0748ca22_fk_discount_voucher_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_order
        ADD CONSTRAINT order_order_voucher_id_0748ca22_fk_discount_voucher_id FOREIGN KEY (voucher_id) REFERENCES public.discount_voucher(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: order_orderevent order_orderevent_app_id_2d642e9c_fk_app_app_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_orderevent
        ADD CONSTRAINT order_orderevent_app_id_2d642e9c_fk_app_app_id FOREIGN KEY (app_id) REFERENCES public.app_app(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: order_orderevent order_orderevent_order_id_09aa7ccd_fk_order_order_token; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_orderevent
        ADD CONSTRAINT order_orderevent_order_id_09aa7ccd_fk_order_order_token FOREIGN KEY (order_id) REFERENCES public.order_order(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: order_orderevent order_orderevent_related_id_c73abd6a_fk_order_orderevent_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_orderevent
        ADD CONSTRAINT order_orderevent_related_id_c73abd6a_fk_order_orderevent_id FOREIGN KEY (related_id) REFERENCES public.order_orderevent(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: order_orderevent order_orderevent_user_id_1056ac9c_fk_userprofile_user_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_orderevent
        ADD CONSTRAINT order_orderevent_user_id_1056ac9c_fk_userprofile_user_id FOREIGN KEY (user_id) REFERENCES public.account_user(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: order_ordergrantedrefundline order_ordergrantedre_granted_refund_id_cd1bb9f6_fk_order_ord; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_ordergrantedrefundline
        ADD CONSTRAINT order_ordergrantedre_granted_refund_id_cd1bb9f6_fk_order_ord FOREIGN KEY (granted_refund_id) REFERENCES public.order_ordergrantedrefund(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: order_ordergrantedrefundline order_ordergrantedre_order_line_id_c2b8e4af_fk_order_ord; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_ordergrantedrefundline
        ADD CONSTRAINT order_ordergrantedre_order_line_id_c2b8e4af_fk_order_ord FOREIGN KEY (order_line_id) REFERENCES public.order_orderline(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: order_ordergrantedrefund order_ordergrantedrefund_app_id_38ac1ecf_fk_app_app_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_ordergrantedrefund
        ADD CONSTRAINT order_ordergrantedrefund_app_id_38ac1ecf_fk_app_app_id FOREIGN KEY (app_id) REFERENCES public.app_app(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: order_ordergrantedrefund order_ordergrantedrefund_order_id_2905d3e7_fk_order_order_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_ordergrantedrefund
        ADD CONSTRAINT order_ordergrantedrefund_order_id_2905d3e7_fk_order_order_id FOREIGN KEY (order_id) REFERENCES public.order_order(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: order_ordergrantedrefund order_ordergrantedrefund_user_id_f344f8ec_fk_account_user_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_ordergrantedrefund
        ADD CONSTRAINT order_ordergrantedrefund_user_id_f344f8ec_fk_account_user_id FOREIGN KEY (user_id) REFERENCES public.account_user(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: order_orderline order_orderline_order_id_eb04ec2d_fk_order_order_token; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_orderline
        ADD CONSTRAINT order_orderline_order_id_eb04ec2d_fk_order_order_token FOREIGN KEY (order_id) REFERENCES public.order_order(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: order_orderline order_orderline_tax_class_id_bc719d4f_fk_tax_taxclass_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_orderline
        ADD CONSTRAINT order_orderline_tax_class_id_bc719d4f_fk_tax_taxclass_id FOREIGN KEY (tax_class_id) REFERENCES public.tax_taxclass(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: order_orderline order_orderline_variant_id_866774cb_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.order_orderline
        ADD CONSTRAINT order_orderline_variant_id_866774cb_fk_product_p FOREIGN KEY (variant_id) REFERENCES public.product_productvariant(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: page_page page_page_page_type_id_06acc00e_fk_page_pagetype_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.page_page
        ADD CONSTRAINT page_page_page_type_id_06acc00e_fk_page_pagetype_id FOREIGN KEY (page_type_id) REFERENCES public.page_pagetype(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: page_pagetranslation page_pagetranslation_page_id_60216ef5_fk_page_page_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.page_pagetranslation
        ADD CONSTRAINT page_pagetranslation_page_id_60216ef5_fk_page_page_id FOREIGN KEY (page_id) REFERENCES public.page_page(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: payment_payment payment_payment_checkout_id_1f32e1ab_fk_checkout_checkout_token; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.payment_payment
        ADD CONSTRAINT payment_payment_checkout_id_1f32e1ab_fk_checkout_checkout_token FOREIGN KEY (checkout_id) REFERENCES public.checkout_checkout(token) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: payment_payment payment_payment_order_id_22b45881_fk_order_order_token; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.payment_payment
        ADD CONSTRAINT payment_payment_order_id_22b45881_fk_order_order_token FOREIGN KEY (order_id) REFERENCES public.order_order(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: payment_transaction payment_transaction_payment_id_df9808d7_fk_payment_payment_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.payment_transaction
        ADD CONSTRAINT payment_transaction_payment_id_df9808d7_fk_payment_payment_id FOREIGN KEY (payment_id) REFERENCES public.payment_payment(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: payment_transactionevent payment_transactione_transaction_id_381f97d4_fk_payment_t; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.payment_transactionevent
        ADD CONSTRAINT payment_transactione_transaction_id_381f97d4_fk_payment_t FOREIGN KEY (transaction_id) REFERENCES public.payment_transactionitem(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: payment_transactionevent payment_transactionevent_app_id_98888f6d_fk_app_app_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.payment_transactionevent
        ADD CONSTRAINT payment_transactionevent_app_id_98888f6d_fk_app_app_id FOREIGN KEY (app_id) REFERENCES public.app_app(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: payment_transactionevent payment_transactionevent_user_id_7f9244da_fk_account_user_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.payment_transactionevent
        ADD CONSTRAINT payment_transactionevent_user_id_7f9244da_fk_account_user_id FOREIGN KEY (user_id) REFERENCES public.account_user(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: payment_transactionitem payment_transactioni_checkout_id_bc8a405f_fk_checkout_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.payment_transactionitem
        ADD CONSTRAINT payment_transactioni_checkout_id_bc8a405f_fk_checkout_ FOREIGN KEY (checkout_id) REFERENCES public.checkout_checkout(token) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: payment_transactionitem payment_transactionitem_app_id_75ae2f40_fk_app_app_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.payment_transactionitem
        ADD CONSTRAINT payment_transactionitem_app_id_75ae2f40_fk_app_app_id FOREIGN KEY (app_id) REFERENCES public.app_app(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: payment_transactionitem payment_transactionitem_order_id_1e36872b_fk_order_order_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.payment_transactionitem
        ADD CONSTRAINT payment_transactionitem_order_id_1e36872b_fk_order_order_id FOREIGN KEY (order_id) REFERENCES public.order_order(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: payment_transactionitem payment_transactionitem_user_id_780fab59_fk_account_user_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.payment_transactionitem
        ADD CONSTRAINT payment_transactionitem_user_id_780fab59_fk_account_user_id FOREIGN KEY (user_id) REFERENCES public.account_user(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: permission_permission permission_permissio_content_type_id_e526e8f2_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.permission_permission
        ADD CONSTRAINT permission_permissio_content_type_id_e526e8f2_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: plugins_emailtemplate plugins_emailtemplat_plugin_configuration_9abac2f2_fk_plugins_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.plugins_emailtemplate
        ADD CONSTRAINT plugins_emailtemplat_plugin_configuration_9abac2f2_fk_plugins_p FOREIGN KEY (plugin_configuration_id) REFERENCES public.plugins_pluginconfiguration(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: plugins_pluginconfiguration plugins_pluginconfig_channel_id_c880e95c_fk_channel_c; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.plugins_pluginconfiguration
        ADD CONSTRAINT plugins_pluginconfig_channel_id_c880e95c_fk_channel_c FOREIGN KEY (channel_id) REFERENCES public.channel_channel(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: attribute_assignedvariantattribute product_assignedvari_assignment_id_8fdbffe8_fk_product_a; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_assignedvariantattribute
        ADD CONSTRAINT product_assignedvari_assignment_id_8fdbffe8_fk_product_a FOREIGN KEY (assignment_id) REFERENCES public.attribute_attributevariant(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: attribute_assignedvariantattribute product_assignedvari_variant_id_27483e6a_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_assignedvariantattribute
        ADD CONSTRAINT product_assignedvari_variant_id_27483e6a_fk_product_p FOREIGN KEY (variant_id) REFERENCES public.product_productvariant(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: attribute_attributevalue product_attributecho_attribute_id_c28c6c92_fk_product_a; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_attributevalue
        ADD CONSTRAINT product_attributecho_attribute_id_c28c6c92_fk_product_a FOREIGN KEY (attribute_id) REFERENCES public.attribute_attribute(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: attribute_attributepage product_attributepag_attribute_id_29005ba0_fk_product_a; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_attributepage
        ADD CONSTRAINT product_attributepag_attribute_id_29005ba0_fk_product_a FOREIGN KEY (attribute_id) REFERENCES public.attribute_attribute(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: attribute_attributepage product_attributepage_page_type_id_2723ed1f_fk_page_pagetype_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_attributepage
        ADD CONSTRAINT product_attributepage_page_type_id_2723ed1f_fk_page_pagetype_id FOREIGN KEY (page_type_id) REFERENCES public.page_pagetype(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: attribute_attributeproduct product_attributepro_attribute_id_0051c706_fk_product_a; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_attributeproduct
        ADD CONSTRAINT product_attributepro_attribute_id_0051c706_fk_product_a FOREIGN KEY (attribute_id) REFERENCES public.attribute_attribute(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: attribute_attributeproduct product_attributepro_product_type_id_54357b3b_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_attributeproduct
        ADD CONSTRAINT product_attributepro_product_type_id_54357b3b_fk_product_p FOREIGN KEY (product_type_id) REFERENCES public.product_producttype(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: attribute_attributetranslation product_attributetra_attribute_id_238dabfc_fk_product_a; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_attributetranslation
        ADD CONSTRAINT product_attributetra_attribute_id_238dabfc_fk_product_a FOREIGN KEY (attribute_id) REFERENCES public.attribute_attribute(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: attribute_attributevaluetranslation product_attributeval_attribute_value_id_8b2cb275_fk_product_a; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_attributevaluetranslation
        ADD CONSTRAINT product_attributeval_attribute_value_id_8b2cb275_fk_product_a FOREIGN KEY (attribute_value_id) REFERENCES public.attribute_attributevalue(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: attribute_attributevariant product_attributevar_attribute_id_e47d3bc3_fk_product_a; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_attributevariant
        ADD CONSTRAINT product_attributevar_attribute_id_e47d3bc3_fk_product_a FOREIGN KEY (attribute_id) REFERENCES public.attribute_attribute(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: attribute_attributevariant product_attributevar_product_type_id_ba95c6dd_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.attribute_attributevariant
        ADD CONSTRAINT product_attributevar_product_type_id_ba95c6dd_fk_product_p FOREIGN KEY (product_type_id) REFERENCES public.product_producttype(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: product_category product_category_parent_id_f6860923_fk_product_category_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_category
        ADD CONSTRAINT product_category_parent_id_f6860923_fk_product_category_id FOREIGN KEY (parent_id) REFERENCES public.product_category(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: product_categorytranslation product_categorytran_category_id_aa8d0917_fk_product_c; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_categorytranslation
        ADD CONSTRAINT product_categorytran_category_id_aa8d0917_fk_product_c FOREIGN KEY (category_id) REFERENCES public.product_category(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: product_collectionproduct product_collection_p_collection_id_0bc817dc_fk_product_c; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_collectionproduct
        ADD CONSTRAINT product_collection_p_collection_id_0bc817dc_fk_product_c FOREIGN KEY (collection_id) REFERENCES public.product_collection(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: product_collectionproduct product_collection_p_product_id_a45a5b06_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_collectionproduct
        ADD CONSTRAINT product_collection_p_product_id_a45a5b06_fk_product_p FOREIGN KEY (product_id) REFERENCES public.product_product(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: product_collectionchannellisting product_collectionch_channel_id_5e167702_fk_channel_c; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_collectionchannellisting
        ADD CONSTRAINT product_collectionch_channel_id_5e167702_fk_channel_c FOREIGN KEY (channel_id) REFERENCES public.channel_channel(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: product_collectionchannellisting product_collectionch_collection_id_2ce1b16b_fk_product_c; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_collectionchannellisting
        ADD CONSTRAINT product_collectionch_collection_id_2ce1b16b_fk_product_c FOREIGN KEY (collection_id) REFERENCES public.product_collection(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: product_collectiontranslation product_collectiontr_collection_id_cfbbd453_fk_product_c; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_collectiontranslation
        ADD CONSTRAINT product_collectiontr_collection_id_cfbbd453_fk_product_c FOREIGN KEY (collection_id) REFERENCES public.product_collection(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: product_digitalcontenturl product_digitalconte_content_id_654197bd_fk_product_d; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_digitalcontenturl
        ADD CONSTRAINT product_digitalconte_content_id_654197bd_fk_product_d FOREIGN KEY (content_id) REFERENCES public.product_digitalcontent(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: product_digitalcontenturl product_digitalconte_line_id_82056694_fk_order_ord; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_digitalcontenturl
        ADD CONSTRAINT product_digitalconte_line_id_82056694_fk_order_ord FOREIGN KEY (line_id) REFERENCES public.order_orderline(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: product_digitalcontent product_digitalconte_product_variant_id_211462a5_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_digitalcontent
        ADD CONSTRAINT product_digitalconte_product_variant_id_211462a5_fk_product_p FOREIGN KEY (product_variant_id) REFERENCES public.product_productvariant(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: product_product product_product_category_id_0c725779_fk_product_category_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_product
        ADD CONSTRAINT product_product_category_id_0c725779_fk_product_category_id FOREIGN KEY (category_id) REFERENCES public.product_category(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: product_product product_product_default_variant_id_bce7dabb_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_product
        ADD CONSTRAINT product_product_default_variant_id_bce7dabb_fk_product_p FOREIGN KEY (default_variant_id) REFERENCES public.product_productvariant(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: product_product product_product_product_type_id_4bfbbfda_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_product
        ADD CONSTRAINT product_product_product_type_id_4bfbbfda_fk_product_p FOREIGN KEY (product_type_id) REFERENCES public.product_producttype(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: product_product product_product_tax_class_id_a0476487_fk_tax_taxclass_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_product
        ADD CONSTRAINT product_product_tax_class_id_a0476487_fk_tax_taxclass_id FOREIGN KEY (tax_class_id) REFERENCES public.tax_taxclass(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: product_productchannellisting product_productchann_channel_id_f8b52350_fk_channel_c; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_productchannellisting
        ADD CONSTRAINT product_productchann_channel_id_f8b52350_fk_channel_c FOREIGN KEY (channel_id) REFERENCES public.channel_channel(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: product_productchannellisting product_productchann_product_id_7838c7a9_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_productchannellisting
        ADD CONSTRAINT product_productchann_product_id_7838c7a9_fk_product_p FOREIGN KEY (product_id) REFERENCES public.product_product(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: product_productmedia product_productmedia_product_id_b83ecd16_fk_product_product_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_productmedia
        ADD CONSTRAINT product_productmedia_product_id_b83ecd16_fk_product_product_id FOREIGN KEY (product_id) REFERENCES public.product_product(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: product_producttranslation product_producttrans_product_id_2c2c7532_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_producttranslation
        ADD CONSTRAINT product_producttrans_product_id_2c2c7532_fk_product_p FOREIGN KEY (product_id) REFERENCES public.product_product(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: product_producttype product_producttype_tax_class_id_cc83fe88_fk_tax_taxclass_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_producttype
        ADD CONSTRAINT product_producttype_tax_class_id_cc83fe88_fk_tax_taxclass_id FOREIGN KEY (tax_class_id) REFERENCES public.tax_taxclass(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: product_productvariantchannellisting product_productvaria_channel_id_23e849ed_fk_channel_c; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_productvariantchannellisting
        ADD CONSTRAINT product_productvaria_channel_id_23e849ed_fk_channel_c FOREIGN KEY (channel_id) REFERENCES public.channel_channel(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: product_productvariant product_productvaria_product_id_43c5a310_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_productvariant
        ADD CONSTRAINT product_productvaria_product_id_43c5a310_fk_product_p FOREIGN KEY (product_id) REFERENCES public.product_product(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: product_productvarianttranslation product_productvaria_product_variant_id_1b144a85_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_productvarianttranslation
        ADD CONSTRAINT product_productvaria_product_variant_id_1b144a85_fk_product_p FOREIGN KEY (product_variant_id) REFERENCES public.product_productvariant(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: product_productvariantchannellisting product_productvaria_variant_id_f8e7abba_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_productvariantchannellisting
        ADD CONSTRAINT product_productvaria_variant_id_f8e7abba_fk_product_p FOREIGN KEY (variant_id) REFERENCES public.product_productvariant(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: product_variantchannellistingpromotionrule product_variantchann_promotion_rule_id_af12d96f_fk_discount_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_variantchannellistingpromotionrule
        ADD CONSTRAINT product_variantchann_promotion_rule_id_af12d96f_fk_discount_ FOREIGN KEY (promotion_rule_id) REFERENCES public.discount_promotionrule(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: product_variantchannellistingpromotionrule product_variantchann_variant_channel_list_3d6a575a_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_variantchannellistingpromotionrule
        ADD CONSTRAINT product_variantchann_variant_channel_list_3d6a575a_fk_product_p FOREIGN KEY (variant_channel_listing_id) REFERENCES public.product_productvariantchannellisting(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: product_variantmedia product_variantmedia_media_id_e94208c4_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_variantmedia
        ADD CONSTRAINT product_variantmedia_media_id_e94208c4_fk_product_p FOREIGN KEY (media_id) REFERENCES public.product_productmedia(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: product_variantmedia product_variantmedia_variant_id_2a29a589_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.product_variantmedia
        ADD CONSTRAINT product_variantmedia_variant_id_2a29a589_fk_product_p FOREIGN KEY (variant_id) REFERENCES public.product_productvariant(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: schedulers_customperiodictask schedulers_customper_custom_id_2ce85a70_fk_scheduler; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.schedulers_customperiodictask
        ADD CONSTRAINT schedulers_customper_custom_id_2ce85a70_fk_scheduler FOREIGN KEY (custom_id) REFERENCES public.schedulers_customschedule(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: schedulers_customperiodictask schedulers_customper_periodictask_ptr_id_adac7c25_fk_django_ce; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.schedulers_customperiodictask
        ADD CONSTRAINT schedulers_customper_periodictask_ptr_id_adac7c25_fk_django_ce FOREIGN KEY (periodictask_ptr_id) REFERENCES public.django_celery_beat_periodictask(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: shipping_shippingmethodchannellisting shipping_shippingmet_channel_id_10933a3c_fk_channel_c; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.shipping_shippingmethodchannellisting
        ADD CONSTRAINT shipping_shippingmet_channel_id_10933a3c_fk_channel_c FOREIGN KEY (channel_id) REFERENCES public.channel_channel(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: shipping_shippingmethod_excluded_products shipping_shippingmet_product_id_c2c20af6_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.shipping_shippingmethod_excluded_products
        ADD CONSTRAINT shipping_shippingmet_product_id_c2c20af6_fk_product_p FOREIGN KEY (product_id) REFERENCES public.product_product(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: shipping_shippingmethodchannellisting shipping_shippingmet_shipping_method_id_20c0bc65_fk_shipping_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.shipping_shippingmethodchannellisting
        ADD CONSTRAINT shipping_shippingmet_shipping_method_id_20c0bc65_fk_shipping_ FOREIGN KEY (shipping_method_id) REFERENCES public.shipping_shippingmethod(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: shipping_shippingmethodtranslation shipping_shippingmet_shipping_method_id_31d925d2_fk_shipping_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.shipping_shippingmethodtranslation
        ADD CONSTRAINT shipping_shippingmet_shipping_method_id_31d925d2_fk_shipping_ FOREIGN KEY (shipping_method_id) REFERENCES public.shipping_shippingmethod(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: shipping_shippingmethodpostalcoderule shipping_shippingmet_shipping_method_id_825fd462_fk_shipping_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.shipping_shippingmethodpostalcoderule
        ADD CONSTRAINT shipping_shippingmet_shipping_method_id_825fd462_fk_shipping_ FOREIGN KEY (shipping_method_id) REFERENCES public.shipping_shippingmethod(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: shipping_shippingmethod shipping_shippingmet_shipping_zone_id_265b7413_fk_shipping_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.shipping_shippingmethod
        ADD CONSTRAINT shipping_shippingmet_shipping_zone_id_265b7413_fk_shipping_ FOREIGN KEY (shipping_zone_id) REFERENCES public.shipping_shippingzone(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: shipping_shippingmethod_excluded_products shipping_shippingmet_shippingmethod_id_a522e057_fk_shipping_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.shipping_shippingmethod_excluded_products
        ADD CONSTRAINT shipping_shippingmet_shippingmethod_id_a522e057_fk_shipping_ FOREIGN KEY (shippingmethod_id) REFERENCES public.shipping_shippingmethod(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: shipping_shippingmethod shipping_shippingmet_tax_class_id_59ec5c19_fk_tax_taxcl; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.shipping_shippingmethod
        ADD CONSTRAINT shipping_shippingmet_tax_class_id_59ec5c19_fk_tax_taxcl FOREIGN KEY (tax_class_id) REFERENCES public.tax_taxclass(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: shipping_shippingzone_channels shipping_shippingzon_channel_id_36548abc_fk_channel_c; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.shipping_shippingzone_channels
        ADD CONSTRAINT shipping_shippingzon_channel_id_36548abc_fk_channel_c FOREIGN KEY (channel_id) REFERENCES public.channel_channel(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: shipping_shippingzone_channels shipping_shippingzon_shippingzone_id_6724d6e4_fk_shipping_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.shipping_shippingzone_channels
        ADD CONSTRAINT shipping_shippingzon_shippingzone_id_6724d6e4_fk_shipping_ FOREIGN KEY (shippingzone_id) REFERENCES public.shipping_shippingzone(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: site_sitesettings site_sitesettings_bottom_menu_id_e2a78098_fk_menu_menu_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.site_sitesettings
        ADD CONSTRAINT site_sitesettings_bottom_menu_id_e2a78098_fk_menu_menu_id FOREIGN KEY (bottom_menu_id) REFERENCES public.menu_menu(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: site_sitesettings site_sitesettings_company_address_id_f0825427_fk_account_a; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.site_sitesettings
        ADD CONSTRAINT site_sitesettings_company_address_id_f0825427_fk_account_a FOREIGN KEY (company_address_id) REFERENCES public.account_address(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: site_sitesettings site_sitesettings_site_id_64dd8ff8_fk_django_site_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.site_sitesettings
        ADD CONSTRAINT site_sitesettings_site_id_64dd8ff8_fk_django_site_id FOREIGN KEY (site_id) REFERENCES public.django_site(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: site_sitesettings site_sitesettings_top_menu_id_ab6f8c46_fk_menu_menu_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.site_sitesettings
        ADD CONSTRAINT site_sitesettings_top_menu_id_ab6f8c46_fk_menu_menu_id FOREIGN KEY (top_menu_id) REFERENCES public.menu_menu(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: site_sitesettingstranslation site_sitesettingstra_site_settings_id_ca085ff6_fk_site_site; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.site_sitesettingstranslation
        ADD CONSTRAINT site_sitesettingstra_site_settings_id_ca085ff6_fk_site_site FOREIGN KEY (site_settings_id) REFERENCES public.site_sitesettings(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: tax_taxclasscountryrate tax_taxclasscountryr_tax_class_id_6ce938aa_fk_tax_taxcl; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.tax_taxclasscountryrate
        ADD CONSTRAINT tax_taxclasscountryr_tax_class_id_6ce938aa_fk_tax_taxcl FOREIGN KEY (tax_class_id) REFERENCES public.tax_taxclass(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: tax_taxconfiguration tax_taxconfiguration_channel_id_b4035d3a_fk_channel_channel_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.tax_taxconfiguration
        ADD CONSTRAINT tax_taxconfiguration_channel_id_b4035d3a_fk_channel_channel_id FOREIGN KEY (channel_id) REFERENCES public.channel_channel(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: tax_taxconfigurationpercountry tax_taxconfiguration_tax_configuration_id_63347e1b_fk_tax_taxco; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.tax_taxconfigurationpercountry
        ADD CONSTRAINT tax_taxconfiguration_tax_configuration_id_63347e1b_fk_tax_taxco FOREIGN KEY (tax_configuration_id) REFERENCES public.tax_taxconfiguration(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: thumbnail_thumbnail thumbnail_thumbnail_app_id_aa70f2d4_fk_app_app_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.thumbnail_thumbnail
        ADD CONSTRAINT thumbnail_thumbnail_app_id_aa70f2d4_fk_app_app_id FOREIGN KEY (app_id) REFERENCES public.app_app(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: thumbnail_thumbnail thumbnail_thumbnail_app_installation_id_a5a97d99_fk_app_appin; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.thumbnail_thumbnail
        ADD CONSTRAINT thumbnail_thumbnail_app_installation_id_a5a97d99_fk_app_appin FOREIGN KEY (app_installation_id) REFERENCES public.app_appinstallation(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: thumbnail_thumbnail thumbnail_thumbnail_category_id_e3196106_fk_product_category_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.thumbnail_thumbnail
        ADD CONSTRAINT thumbnail_thumbnail_category_id_e3196106_fk_product_category_id FOREIGN KEY (category_id) REFERENCES public.product_category(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: thumbnail_thumbnail thumbnail_thumbnail_collection_id_0aa16183_fk_product_c; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.thumbnail_thumbnail
        ADD CONSTRAINT thumbnail_thumbnail_collection_id_0aa16183_fk_product_c FOREIGN KEY (collection_id) REFERENCES public.product_collection(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: thumbnail_thumbnail thumbnail_thumbnail_product_media_id_85602a99_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.thumbnail_thumbnail
        ADD CONSTRAINT thumbnail_thumbnail_product_media_id_85602a99_fk_product_p FOREIGN KEY (product_media_id) REFERENCES public.product_productmedia(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: thumbnail_thumbnail thumbnail_thumbnail_user_id_0bc68981_fk_account_user_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.thumbnail_thumbnail
        ADD CONSTRAINT thumbnail_thumbnail_user_id_0bc68981_fk_account_user_id FOREIGN KEY (user_id) REFERENCES public.account_user(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: account_user_addresses userprofile_user_add_address_id_ad7646b4_fk_userprofi; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_user_addresses
        ADD CONSTRAINT userprofile_user_add_address_id_ad7646b4_fk_userprofi FOREIGN KEY (address_id) REFERENCES public.account_address(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: account_user_addresses userprofile_user_add_user_id_bb5aa55e_fk_userprofi; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_user_addresses
        ADD CONSTRAINT userprofile_user_add_user_id_bb5aa55e_fk_userprofi FOREIGN KEY (user_id) REFERENCES public.account_user(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: account_user userprofile_user_default_billing_addr_0489abf1_fk_userprofi; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_user
        ADD CONSTRAINT userprofile_user_default_billing_addr_0489abf1_fk_userprofi FOREIGN KEY (default_billing_address_id) REFERENCES public.account_address(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: account_user userprofile_user_default_shipping_add_aae7a203_fk_userprofi; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_user
        ADD CONSTRAINT userprofile_user_default_shipping_add_aae7a203_fk_userprofi FOREIGN KEY (default_shipping_address_id) REFERENCES public.account_address(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: account_user_groups userprofile_user_groups_user_id_5e712a24_fk_userprofile_user_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_user_groups
        ADD CONSTRAINT userprofile_user_groups_user_id_5e712a24_fk_userprofile_user_id FOREIGN KEY (user_id) REFERENCES public.account_user(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: account_user_user_permissions userprofile_user_use_user_id_6d654469_fk_userprofi; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.account_user_user_permissions
        ADD CONSTRAINT userprofile_user_use_user_id_6d654469_fk_userprofi FOREIGN KEY (user_id) REFERENCES public.account_user(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: warehouse_allocation warehouse_allocation_order_line_id_693dcb84_fk_order_ord; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.warehouse_allocation
        ADD CONSTRAINT warehouse_allocation_order_line_id_693dcb84_fk_order_ord FOREIGN KEY (order_line_id) REFERENCES public.order_orderline(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: warehouse_allocation warehouse_allocation_stock_id_73541542_fk_warehouse_stock_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.warehouse_allocation
        ADD CONSTRAINT warehouse_allocation_stock_id_73541542_fk_warehouse_stock_id FOREIGN KEY (stock_id) REFERENCES public.warehouse_stock(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: warehouse_preorderallocation warehouse_preorderal_order_line_id_a37726e3_fk_order_ord; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.warehouse_preorderallocation
        ADD CONSTRAINT warehouse_preorderal_order_line_id_a37726e3_fk_order_ord FOREIGN KEY (order_line_id) REFERENCES public.order_orderline(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: warehouse_preorderallocation warehouse_preorderal_product_variant_chan_d243ee40_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.warehouse_preorderallocation
        ADD CONSTRAINT warehouse_preorderal_product_variant_chan_d243ee40_fk_product_p FOREIGN KEY (product_variant_channel_listing_id) REFERENCES public.product_productvariantchannellisting(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: warehouse_preorderreservation warehouse_preorderre_checkout_line_id_d13d1466_fk_checkout_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.warehouse_preorderreservation
        ADD CONSTRAINT warehouse_preorderre_checkout_line_id_d13d1466_fk_checkout_ FOREIGN KEY (checkout_line_id) REFERENCES public.checkout_checkoutline(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: warehouse_preorderreservation warehouse_preorderre_product_variant_chan_3c2d488e_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.warehouse_preorderreservation
        ADD CONSTRAINT warehouse_preorderre_product_variant_chan_3c2d488e_fk_product_p FOREIGN KEY (product_variant_channel_listing_id) REFERENCES public.product_productvariantchannellisting(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: warehouse_reservation warehouse_reservatio_checkout_line_id_54daacb7_fk_checkout_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.warehouse_reservation
        ADD CONSTRAINT warehouse_reservatio_checkout_line_id_54daacb7_fk_checkout_ FOREIGN KEY (checkout_line_id) REFERENCES public.checkout_checkoutline(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: warehouse_reservation warehouse_reservation_stock_id_5d178c00_fk_warehouse_stock_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.warehouse_reservation
        ADD CONSTRAINT warehouse_reservation_stock_id_5d178c00_fk_warehouse_stock_id FOREIGN KEY (stock_id) REFERENCES public.warehouse_stock(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: warehouse_stock warehouse_stock_product_variant_id_bea58a82_fk_product_p; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.warehouse_stock
        ADD CONSTRAINT warehouse_stock_product_variant_id_bea58a82_fk_product_p FOREIGN KEY (product_variant_id) REFERENCES public.product_productvariant(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: warehouse_stock warehouse_stock_warehouse_id_cc9d4e5d_fk_warehouse_warehouse_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.warehouse_stock
        ADD CONSTRAINT warehouse_stock_warehouse_id_cc9d4e5d_fk_warehouse_warehouse_id FOREIGN KEY (warehouse_id) REFERENCES public.warehouse_warehouse(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: warehouse_channelwarehouse warehouse_warehouse__channel_id_586b1124_fk_channel_c; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.warehouse_channelwarehouse
        ADD CONSTRAINT warehouse_warehouse__channel_id_586b1124_fk_channel_c FOREIGN KEY (channel_id) REFERENCES public.channel_channel(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: warehouse_warehouse_shipping_zones warehouse_warehouse__shippingzone_id_aeee255b_fk_shipping_; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.warehouse_warehouse_shipping_zones
        ADD CONSTRAINT warehouse_warehouse__shippingzone_id_aeee255b_fk_shipping_ FOREIGN KEY (shippingzone_id) REFERENCES public.shipping_shippingzone(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: warehouse_channelwarehouse warehouse_warehouse__warehouse_id_d1b0e96d_fk_warehouse; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.warehouse_channelwarehouse
        ADD CONSTRAINT warehouse_warehouse__warehouse_id_d1b0e96d_fk_warehouse FOREIGN KEY (warehouse_id) REFERENCES public.warehouse_warehouse(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: warehouse_warehouse_shipping_zones warehouse_warehouse__warehouse_id_fccd6647_fk_warehouse; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.warehouse_warehouse_shipping_zones
        ADD CONSTRAINT warehouse_warehouse__warehouse_id_fccd6647_fk_warehouse FOREIGN KEY (warehouse_id) REFERENCES public.warehouse_warehouse(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: warehouse_warehouse warehouse_warehouse_address_id_d46e1096_fk_account_address_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.warehouse_warehouse
        ADD CONSTRAINT warehouse_warehouse_address_id_d46e1096_fk_account_address_id FOREIGN KEY (address_id) REFERENCES public.account_address(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: webhook_webhook webhook_webhook_app_id_604d7610_fk_app_app_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.webhook_webhook
        ADD CONSTRAINT webhook_webhook_app_id_604d7610_fk_app_app_id FOREIGN KEY (app_id) REFERENCES public.app_app(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- Name: webhook_webhookevent webhook_webhookevent_webhook_id_73b5c9e1_fk_webhook_webhook_id; Type: FK CONSTRAINT; Schema: public; Owner: saleor
    --

    ALTER TABLE ONLY public.webhook_webhookevent
        ADD CONSTRAINT webhook_webhookevent_webhook_id_73b5c9e1_fk_webhook_webhook_id FOREIGN KEY (webhook_id) REFERENCES public.webhook_webhook(id) DEFERRABLE INITIALLY DEFERRED;


    --
    -- PostgreSQL database dump complete
    --
EOSQL
