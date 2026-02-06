--
-- PostgreSQL database dump
--

-- Dumped from database version 14.7 (Homebrew)
-- Dumped by pg_dump version 14.7 (Homebrew)

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
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: notify_updated_price(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.notify_updated_price() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  DECLARE
    payload TEXT;
  BEGIN
    IF (TG_OP = 'UPDATE') OR (TG_OP = 'INSERT') THEN
      payload := json_build_object('id',OLD.id,'old',row_to_json(OLD),'new',row_to_json(NEW));
      PERFORM pg_notify('prices_updated', payload);
    END IF;

    RETURN NEW;
  END;
  $$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: coins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.coins (
    id bigint NOT NULL,
    code character varying(255),
    name character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: coins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.coins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: coins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.coins_id_seq OWNED BY public.coins.id;


--
-- Name: prices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.prices (
    id bigint NOT NULL,
    price numeric,
    coin_id bigint,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: prices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.prices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: prices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.prices_id_seq OWNED BY public.prices.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- Name: coins id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coins ALTER COLUMN id SET DEFAULT nextval('public.coins_id_seq'::regclass);


--
-- Name: prices id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prices ALTER COLUMN id SET DEFAULT nextval('public.prices_id_seq'::regclass);


--
-- Name: coins coins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.coins
    ADD CONSTRAINT coins_pkey PRIMARY KEY (id);


--
-- Name: prices prices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prices
    ADD CONSTRAINT prices_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: prices_coin_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX prices_coin_id_index ON public.prices USING btree (coin_id);


--
-- Name: prices price_changed_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER price_changed_trigger AFTER UPDATE ON public.prices FOR EACH ROW EXECUTE FUNCTION public.notify_updated_price();


--
-- Name: prices prices_coin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prices
    ADD CONSTRAINT prices_coin_id_fkey FOREIGN KEY (coin_id) REFERENCES public.coins(id);


--
-- PostgreSQL database dump complete
--

INSERT INTO public."schema_migrations" (version) VALUES (20221020060156);
INSERT INTO public."schema_migrations" (version) VALUES (20221020232946);
INSERT INTO public."schema_migrations" (version) VALUES (20221021050351);
INSERT INTO public."schema_migrations" (version) VALUES (20221116041424);
