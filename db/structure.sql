--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- Name: intarray; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS intarray WITH SCHEMA public;


--
-- Name: EXTENSION intarray; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION intarray IS 'functions, operators, and index support for 1-D arrays of integers';


SET search_path = public, pg_catalog;

--
-- Name: array_agg_mult(anyarray); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE array_agg_mult(anyarray) (
    SFUNC = array_cat,
    STYPE = anyarray,
    INITCOND = '{}'
);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: groups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE groups (
    id integer NOT NULL,
    name character varying(32) NOT NULL,
    system_flags bigint DEFAULT 0 NOT NULL
);


--
-- Name: groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE groups_id_seq OWNED BY groups.id;


--
-- Name: inspection_atoms; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE inspection_atoms (
    id integer NOT NULL,
    inspection_item_id integer,
    title character varying(128) NOT NULL,
    code character varying(64) NOT NULL,
    unit character varying(16) NOT NULL,
    order_index integer DEFAULT 0 NOT NULL,
    data_type character varying(32) NOT NULL,
    data_descriptor text NOT NULL,
    program_code character varying(64) NOT NULL
);


--
-- Name: inspection_atoms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE inspection_atoms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inspection_atoms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE inspection_atoms_id_seq OWNED BY inspection_atoms.id;


--
-- Name: inspection_bundles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE inspection_bundles (
    id integer NOT NULL,
    title character varying(128) NOT NULL,
    group_name character varying(64) NOT NULL,
    code character varying(64),
    item_ids integer[] NOT NULL
);


--
-- Name: inspection_bundles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE inspection_bundles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inspection_bundles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE inspection_bundles_id_seq OWNED BY inspection_bundles.id;


--
-- Name: inspection_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE inspection_items (
    id integer NOT NULL,
    title character varying(128) NOT NULL,
    group_name character varying(64) NOT NULL,
    code character varying(64),
    sample_type character varying(64) NOT NULL
);


--
-- Name: inspection_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE inspection_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inspection_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE inspection_items_id_seq OWNED BY inspection_items.id;


--
-- Name: issue_bundles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE issue_bundles (
    id integer NOT NULL,
    issue_id integer NOT NULL,
    inspection_bundle_id integer,
    inspection_item_ids integer[] NOT NULL,
    locked boolean DEFAULT false NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: issue_bundles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE issue_bundles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: issue_bundles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE issue_bundles_id_seq OWNED BY issue_bundles.id;


--
-- Name: issue_status_permissions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE issue_status_permissions (
    id integer NOT NULL,
    issue_status_id integer NOT NULL,
    group_id integer NOT NULL,
    permission_flags integer DEFAULT 0 NOT NULL,
    issue_status_ids integer[] NOT NULL
);


--
-- Name: issue_status_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE issue_status_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: issue_status_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE issue_status_permissions_id_seq OWNED BY issue_status_permissions.id;


--
-- Name: issue_statuses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE issue_statuses (
    id integer NOT NULL,
    name character varying(64) NOT NULL,
    "order" integer DEFAULT 0 NOT NULL,
    mode character varying(10) NOT NULL
);


--
-- Name: issue_statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE issue_statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: issue_statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE issue_statuses_id_seq OWNED BY issue_statuses.id;


--
-- Name: issue_values; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE issue_values (
    id integer NOT NULL,
    issue_bundle_id integer NOT NULL,
    inspection_atom_id integer NOT NULL,
    data character varying(128),
    override_error boolean,
    override_describe character varying(256),
    editor_id integer,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: issue_values_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE issue_values_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: issue_values_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE issue_values_id_seq OWNED BY issue_values.id;


--
-- Name: issues; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE issues (
    id integer NOT NULL,
    profile_id integer NOT NULL,
    issue_status_id integer NOT NULL,
    created_by_id integer NOT NULL,
    access_group character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: issues_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE issues_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: issues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE issues_id_seq OWNED BY issues.id;


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE profiles (
    id integer NOT NULL,
    identify character varying(32),
    firstname character varying(128) NOT NULL,
    surname character varying(128) NOT NULL,
    sex_flag character varying(1),
    birthday date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE profiles_id_seq OWNED BY profiles.id;


--
-- Name: samples; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE samples (
    id integer NOT NULL,
    issue_id integer NOT NULL,
    no character varying(64) NOT NULL,
    sample_type character varying(32) NOT NULL,
    quantity integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: samples_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE samples_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: samples_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE samples_id_seq OWNED BY samples.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: user_groups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_groups (
    id integer NOT NULL,
    user_id integer,
    group_id integer
);


--
-- Name: user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_groups_id_seq OWNED BY user_groups.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    username character varying(64) NOT NULL,
    hashed_password character varying(128) NOT NULL,
    name character varying(128) NOT NULL,
    email character varying(128),
    flags integer DEFAULT 0 NOT NULL,
    lastlogin_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY groups ALTER COLUMN id SET DEFAULT nextval('groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY inspection_atoms ALTER COLUMN id SET DEFAULT nextval('inspection_atoms_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY inspection_bundles ALTER COLUMN id SET DEFAULT nextval('inspection_bundles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY inspection_items ALTER COLUMN id SET DEFAULT nextval('inspection_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY issue_bundles ALTER COLUMN id SET DEFAULT nextval('issue_bundles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY issue_status_permissions ALTER COLUMN id SET DEFAULT nextval('issue_status_permissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY issue_statuses ALTER COLUMN id SET DEFAULT nextval('issue_statuses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY issue_values ALTER COLUMN id SET DEFAULT nextval('issue_values_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY issues ALTER COLUMN id SET DEFAULT nextval('issues_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY profiles ALTER COLUMN id SET DEFAULT nextval('profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY samples ALTER COLUMN id SET DEFAULT nextval('samples_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_groups ALTER COLUMN id SET DEFAULT nextval('user_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: inspection_atoms_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY inspection_atoms
    ADD CONSTRAINT inspection_atoms_pkey PRIMARY KEY (id);


--
-- Name: inspection_bundles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY inspection_bundles
    ADD CONSTRAINT inspection_bundles_pkey PRIMARY KEY (id);


--
-- Name: inspection_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY inspection_items
    ADD CONSTRAINT inspection_items_pkey PRIMARY KEY (id);


--
-- Name: issue_bundles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY issue_bundles
    ADD CONSTRAINT issue_bundles_pkey PRIMARY KEY (id);


--
-- Name: issue_status_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY issue_status_permissions
    ADD CONSTRAINT issue_status_permissions_pkey PRIMARY KEY (id);


--
-- Name: issue_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY issue_statuses
    ADD CONSTRAINT issue_statuses_pkey PRIMARY KEY (id);


--
-- Name: issue_values_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY issue_values
    ADD CONSTRAINT issue_values_pkey PRIMARY KEY (id);


--
-- Name: issues_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY issues
    ADD CONSTRAINT issues_pkey PRIMARY KEY (id);


--
-- Name: profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: samples_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY samples
    ADD CONSTRAINT samples_pkey PRIMARY KEY (id);


--
-- Name: user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_groups
    ADD CONSTRAINT user_groups_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_issue_status_permissions_on_issue_status_id_and_group_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_issue_status_permissions_on_issue_status_id_and_group_id ON issue_status_permissions USING btree (issue_status_id, group_id);


--
-- Name: index_user_groups_on_user_id_and_group_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_user_groups_on_user_id_and_group_id ON user_groups USING btree (user_id, group_id);


--
-- Name: index_users_on_username; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_username ON users USING btree (username);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20140824111033');

INSERT INTO schema_migrations (version) VALUES ('20140824150304');

INSERT INTO schema_migrations (version) VALUES ('20140908150305');

INSERT INTO schema_migrations (version) VALUES ('20141106140538');

INSERT INTO schema_migrations (version) VALUES ('20141106140559');

INSERT INTO schema_migrations (version) VALUES ('20141106142951');

INSERT INTO schema_migrations (version) VALUES ('20141109014409');

INSERT INTO schema_migrations (version) VALUES ('20141109021101');

INSERT INTO schema_migrations (version) VALUES ('20141109021110');

INSERT INTO schema_migrations (version) VALUES ('20141109021712');

INSERT INTO schema_migrations (version) VALUES ('20141109021721');

INSERT INTO schema_migrations (version) VALUES ('20141110151353');

INSERT INTO schema_migrations (version) VALUES ('20141128034015');

INSERT INTO schema_migrations (version) VALUES ('20141128034123');

INSERT INTO schema_migrations (version) VALUES ('20141202121340');

INSERT INTO schema_migrations (version) VALUES ('20141202130656');

