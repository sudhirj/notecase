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


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE accounts (
    id bigint NOT NULL,
    type character varying,
    ref character varying NOT NULL,
    data jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE accounts_id_seq OWNED BY accounts.id;


--
-- Name: double_entry_account_balances; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE double_entry_account_balances (
    id bigint NOT NULL,
    account character varying(31) NOT NULL,
    scope character varying(23),
    balance integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: double_entry_account_balances_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE double_entry_account_balances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: double_entry_account_balances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE double_entry_account_balances_id_seq OWNED BY double_entry_account_balances.id;


--
-- Name: double_entry_line_aggregates; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE double_entry_line_aggregates (
    id bigint NOT NULL,
    function character varying(15) NOT NULL,
    account character varying(31) NOT NULL,
    code character varying(47),
    scope character varying(23),
    year integer,
    month integer,
    week integer,
    day integer,
    hour integer,
    amount integer NOT NULL,
    filter character varying,
    range_type character varying(15) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: double_entry_line_aggregates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE double_entry_line_aggregates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: double_entry_line_aggregates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE double_entry_line_aggregates_id_seq OWNED BY double_entry_line_aggregates.id;


--
-- Name: double_entry_line_checks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE double_entry_line_checks (
    id bigint NOT NULL,
    last_line_id bigint NOT NULL,
    errors_found boolean NOT NULL,
    log text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: double_entry_line_checks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE double_entry_line_checks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: double_entry_line_checks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE double_entry_line_checks_id_seq OWNED BY double_entry_line_checks.id;


--
-- Name: double_entry_line_metadata; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE double_entry_line_metadata (
    id bigint NOT NULL,
    line_id bigint NOT NULL,
    key character varying(48) NOT NULL,
    value character varying(64) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: double_entry_line_metadata_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE double_entry_line_metadata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: double_entry_line_metadata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE double_entry_line_metadata_id_seq OWNED BY double_entry_line_metadata.id;


--
-- Name: double_entry_lines; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE double_entry_lines (
    id bigint NOT NULL,
    account character varying(31) NOT NULL,
    scope character varying(23),
    code character varying(47) NOT NULL,
    amount integer NOT NULL,
    balance integer NOT NULL,
    partner_id bigint,
    partner_account character varying(31) NOT NULL,
    partner_scope character varying(23),
    detail_id bigint,
    detail_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: double_entry_lines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE double_entry_lines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: double_entry_lines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE double_entry_lines_id_seq OWNED BY double_entry_lines.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE transactions (
    id bigint NOT NULL,
    type character varying,
    ref character varying NOT NULL,
    data jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE transactions_id_seq OWNED BY transactions.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts ALTER COLUMN id SET DEFAULT nextval('accounts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY double_entry_account_balances ALTER COLUMN id SET DEFAULT nextval('double_entry_account_balances_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY double_entry_line_aggregates ALTER COLUMN id SET DEFAULT nextval('double_entry_line_aggregates_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY double_entry_line_checks ALTER COLUMN id SET DEFAULT nextval('double_entry_line_checks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY double_entry_line_metadata ALTER COLUMN id SET DEFAULT nextval('double_entry_line_metadata_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY double_entry_lines ALTER COLUMN id SET DEFAULT nextval('double_entry_lines_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY transactions ALTER COLUMN id SET DEFAULT nextval('transactions_id_seq'::regclass);


--
-- Name: accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: double_entry_account_balances_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY double_entry_account_balances
    ADD CONSTRAINT double_entry_account_balances_pkey PRIMARY KEY (id);


--
-- Name: double_entry_line_aggregates_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY double_entry_line_aggregates
    ADD CONSTRAINT double_entry_line_aggregates_pkey PRIMARY KEY (id);


--
-- Name: double_entry_line_checks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY double_entry_line_checks
    ADD CONSTRAINT double_entry_line_checks_pkey PRIMARY KEY (id);


--
-- Name: double_entry_line_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY double_entry_line_metadata
    ADD CONSTRAINT double_entry_line_metadata_pkey PRIMARY KEY (id);


--
-- Name: double_entry_lines_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY double_entry_lines
    ADD CONSTRAINT double_entry_lines_pkey PRIMARY KEY (id);


--
-- Name: transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: index_account_balances_on_account; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_account_balances_on_account ON double_entry_account_balances USING btree (account);


--
-- Name: index_account_balances_on_scope_and_account; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_account_balances_on_scope_and_account ON double_entry_account_balances USING btree (scope, account);


--
-- Name: index_accounts_on_ref; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_accounts_on_ref ON accounts USING btree (ref);


--
-- Name: index_transactions_on_ref; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_transactions_on_ref ON transactions USING btree (ref);


--
-- Name: line_aggregate_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX line_aggregate_idx ON double_entry_line_aggregates USING btree (function, account, code, year, month, week, day);


--
-- Name: lines_account_code_created_at_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX lines_account_code_created_at_idx ON double_entry_lines USING btree (account, code, created_at);


--
-- Name: lines_account_created_at_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX lines_account_created_at_idx ON double_entry_lines USING btree (account, created_at);


--
-- Name: lines_meta_line_id_key_value_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX lines_meta_line_id_key_value_idx ON double_entry_line_metadata USING btree (line_id, key, value);


--
-- Name: lines_scope_account_created_at_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX lines_scope_account_created_at_idx ON double_entry_lines USING btree (scope, account, created_at);


--
-- Name: lines_scope_account_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX lines_scope_account_id_idx ON double_entry_lines USING btree (scope, account, id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20150728143130');

INSERT INTO schema_migrations (version) VALUES ('20150728143914');

INSERT INTO schema_migrations (version) VALUES ('20150728145908');

INSERT INTO schema_migrations (version) VALUES ('20150828044630');

INSERT INTO schema_migrations (version) VALUES ('20160307061649');

