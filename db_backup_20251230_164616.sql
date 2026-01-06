--
-- PostgreSQL database dump
--

\restrict oeFC06FTOcIjpaDcNOXp2zS54rsRVwt8SrMaIccATAwThmsIv0zqlP5e8vocE7J

-- Dumped from database version 16.10 (Debian 16.10-1.pgdg13+1)
-- Dumped by pg_dump version 16.10 (Debian 16.10-1.pgdg13+1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: chefs; Type: TABLE; Schema: public; Owner: rsvp
--

CREATE TABLE public.chefs (
    id bigint NOT NULL,
    name text NOT NULL,
    type text DEFAULT 'GROUP'::text NOT NULL,
    email text,
    phone text,
    notes text,
    active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chefs_type_check CHECK ((type = ANY (ARRAY['PERSON'::text, 'GROUP'::text, 'EXTERNAL'::text])))
);


ALTER TABLE public.chefs OWNER TO rsvp;

--
-- Name: chefs_id_seq; Type: SEQUENCE; Schema: public; Owner: rsvp
--

CREATE SEQUENCE public.chefs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.chefs_id_seq OWNER TO rsvp;

--
-- Name: chefs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rsvp
--

ALTER SEQUENCE public.chefs_id_seq OWNED BY public.chefs.id;


--
-- Name: dish_ingredients; Type: TABLE; Schema: public; Owner: rsvp
--

CREATE TABLE public.dish_ingredients (
    dish_id bigint NOT NULL,
    ingredient_id bigint NOT NULL,
    qty_per_quart numeric(10,3) NOT NULL
);


ALTER TABLE public.dish_ingredients OWNER TO rsvp;

--
-- Name: dishes; Type: TABLE; Schema: public; Owner: rsvp
--

CREATE TABLE public.dishes (
    id bigint NOT NULL,
    name character varying(200) NOT NULL,
    description text,
    default_quarts_per_thaali_unit numeric(6,2) DEFAULT 1.00 NOT NULL,
    active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.dishes OWNER TO rsvp;

--
-- Name: dishes_id_seq; Type: SEQUENCE; Schema: public; Owner: rsvp
--

CREATE SEQUENCE public.dishes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dishes_id_seq OWNER TO rsvp;

--
-- Name: dishes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rsvp
--

ALTER SEQUENCE public.dishes_id_seq OWNED BY public.dishes.id;


--
-- Name: event_chefs; Type: TABLE; Schema: public; Owner: rsvp
--

CREATE TABLE public.event_chefs (
    event_id bigint NOT NULL,
    chef_id bigint NOT NULL,
    role text
);


ALTER TABLE public.event_chefs OWNER TO rsvp;

--
-- Name: event_person_chefs; Type: TABLE; Schema: public; Owner: rsvp
--

CREATE TABLE public.event_person_chefs (
    event_id bigint NOT NULL,
    person_id bigint NOT NULL
);


ALTER TABLE public.event_person_chefs OWNER TO rsvp;

--
-- Name: events; Type: TABLE; Schema: public; Owner: rsvp
--

CREATE TABLE public.events (
    id bigint NOT NULL,
    event_type character varying(16) NOT NULL,
    title character varying(200),
    description character varying(2000),
    event_date date NOT NULL,
    start_time time without time zone,
    registration_open_at timestamp with time zone NOT NULL,
    registration_close_at timestamp with time zone NOT NULL,
    status character varying(16) DEFAULT 'DRAFT'::character varying NOT NULL,
    miqaat_name character varying(200),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_event_status CHECK (((status)::text = ANY ((ARRAY['DRAFT'::character varying, 'PUBLISHED'::character varying, 'CANCELLED'::character varying])::text[]))),
    CONSTRAINT chk_event_type CHECK (((event_type)::text = ANY ((ARRAY['NIYAZ'::character varying, 'THAALI'::character varying])::text[])))
);


ALTER TABLE public.events OWNER TO rsvp;

--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: rsvp
--

CREATE SEQUENCE public.events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.events_id_seq OWNER TO rsvp;

--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rsvp
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- Name: flyway_schema_history; Type: TABLE; Schema: public; Owner: rsvp
--

CREATE TABLE public.flyway_schema_history (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


ALTER TABLE public.flyway_schema_history OWNER TO rsvp;

--
-- Name: ingredients; Type: TABLE; Schema: public; Owner: rsvp
--

CREATE TABLE public.ingredients (
    id bigint NOT NULL,
    name character varying(200) NOT NULL,
    unit character varying(32) NOT NULL,
    notes character varying(500),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    category character varying(32),
    default_store character varying(64),
    storage_location character varying(100)
);


ALTER TABLE public.ingredients OWNER TO rsvp;

--
-- Name: ingredients_id_seq; Type: SEQUENCE; Schema: public; Owner: rsvp
--

CREATE SEQUENCE public.ingredients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ingredients_id_seq OWNER TO rsvp;

--
-- Name: ingredients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rsvp
--

ALTER SEQUENCE public.ingredients_id_seq OWNED BY public.ingredients.id;


--
-- Name: menu_item_ingredients; Type: TABLE; Schema: public; Owner: rsvp
--

CREATE TABLE public.menu_item_ingredients (
    menu_item_id bigint NOT NULL,
    ingredient_id bigint NOT NULL,
    qty_per_quart numeric(19,6) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.menu_item_ingredients OWNER TO rsvp;

--
-- Name: menu_items; Type: TABLE; Schema: public; Owner: rsvp
--

CREATE TABLE public.menu_items (
    id bigint NOT NULL,
    event_id bigint NOT NULL,
    name character varying(200),
    description character varying(1000),
    quarts_per_thaali_unit numeric(19,6) DEFAULT 1.0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    dish_id bigint,
    "position" integer
);


ALTER TABLE public.menu_items OWNER TO rsvp;

--
-- Name: menu_items_id_seq; Type: SEQUENCE; Schema: public; Owner: rsvp
--

CREATE SEQUENCE public.menu_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.menu_items_id_seq OWNER TO rsvp;

--
-- Name: menu_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rsvp
--

ALTER SEQUENCE public.menu_items_id_seq OWNED BY public.menu_items.id;


--
-- Name: niyaz_event_hosts; Type: TABLE; Schema: public; Owner: rsvp
--

CREATE TABLE public.niyaz_event_hosts (
    event_id bigint NOT NULL,
    person_id bigint NOT NULL
);


ALTER TABLE public.niyaz_event_hosts OWNER TO rsvp;

--
-- Name: niyaz_rsvps; Type: TABLE; Schema: public; Owner: rsvp
--

CREATE TABLE public.niyaz_rsvps (
    id bigint NOT NULL,
    event_id bigint NOT NULL,
    person_id bigint NOT NULL,
    adults integer DEFAULT 0 NOT NULL,
    kids integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_niyaz_counts_nonneg CHECK (((adults >= 0) AND (kids >= 0)))
);


ALTER TABLE public.niyaz_rsvps OWNER TO rsvp;

--
-- Name: niyaz_rsvps_id_seq; Type: SEQUENCE; Schema: public; Owner: rsvp
--

CREATE SEQUENCE public.niyaz_rsvps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.niyaz_rsvps_id_seq OWNER TO rsvp;

--
-- Name: niyaz_rsvps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rsvp
--

ALTER SEQUENCE public.niyaz_rsvps_id_seq OWNED BY public.niyaz_rsvps.id;


--
-- Name: password_reset_tokens; Type: TABLE; Schema: public; Owner: rsvp
--

CREATE TABLE public.password_reset_tokens (
    id uuid NOT NULL,
    person_id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    used_at timestamp with time zone
);


ALTER TABLE public.password_reset_tokens OWNER TO rsvp;

--
-- Name: person_roles; Type: TABLE; Schema: public; Owner: rsvp
--

CREATE TABLE public.person_roles (
    person_id bigint NOT NULL,
    role character varying(50) NOT NULL
);


ALTER TABLE public.person_roles OWNER TO rsvp;

--
-- Name: persons; Type: TABLE; Schema: public; Owner: rsvp
--

CREATE TABLE public.persons (
    id bigint NOT NULL,
    its_number character varying(32) NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    phone character varying(32),
    email character varying(255) NOT NULL,
    password_hash character varying(100) NOT NULL,
    account_status character varying(16) DEFAULT 'ACTIVE'::character varying NOT NULL,
    reset_token character varying(100),
    reset_expires_at timestamp with time zone,
    failed_login_count integer DEFAULT 0 NOT NULL,
    last_login_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    pickup_zone_id bigint,
    CONSTRAINT chk_person_account_status CHECK (((account_status)::text = ANY ((ARRAY['ACTIVE'::character varying, 'LOCKED'::character varying, 'DISABLED'::character varying])::text[])))
);


ALTER TABLE public.persons OWNER TO rsvp;

--
-- Name: persons_id_seq; Type: SEQUENCE; Schema: public; Owner: rsvp
--

CREATE SEQUENCE public.persons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.persons_id_seq OWNER TO rsvp;

--
-- Name: persons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rsvp
--

ALTER SEQUENCE public.persons_id_seq OWNED BY public.persons.id;


--
-- Name: pickup_zones; Type: TABLE; Schema: public; Owner: rsvp
--

CREATE TABLE public.pickup_zones (
    id bigint NOT NULL,
    name text NOT NULL,
    active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.pickup_zones OWNER TO rsvp;

--
-- Name: pickup_zones_id_seq; Type: SEQUENCE; Schema: public; Owner: rsvp
--

CREATE SEQUENCE public.pickup_zones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pickup_zones_id_seq OWNER TO rsvp;

--
-- Name: pickup_zones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rsvp
--

ALTER SEQUENCE public.pickup_zones_id_seq OWNED BY public.pickup_zones.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: rsvp
--

CREATE TABLE public.roles (
    id bigint NOT NULL,
    name character varying(50) NOT NULL,
    description character varying(255),
    active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.roles OWNER TO rsvp;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: rsvp
--

CREATE SEQUENCE public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_id_seq OWNER TO rsvp;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rsvp
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: session_tokens; Type: TABLE; Schema: public; Owner: rsvp
--

CREATE TABLE public.session_tokens (
    id uuid NOT NULL,
    person_id bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    revoked boolean DEFAULT false NOT NULL
);


ALTER TABLE public.session_tokens OWNER TO rsvp;

--
-- Name: thaali_order_items; Type: TABLE; Schema: public; Owner: rsvp
--

CREATE TABLE public.thaali_order_items (
    id bigint NOT NULL,
    order_id bigint NOT NULL,
    menu_item_id bigint NOT NULL,
    size character varying(16) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.thaali_order_items OWNER TO rsvp;

--
-- Name: thaali_order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: rsvp
--

CREATE SEQUENCE public.thaali_order_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.thaali_order_items_id_seq OWNER TO rsvp;

--
-- Name: thaali_order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rsvp
--

ALTER SEQUENCE public.thaali_order_items_id_seq OWNED BY public.thaali_order_items.id;


--
-- Name: thaali_orders; Type: TABLE; Schema: public; Owner: rsvp
--

CREATE TABLE public.thaali_orders (
    id bigint NOT NULL,
    event_id bigint NOT NULL,
    person_id bigint NOT NULL,
    notes character varying(500),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    pickup_zone_id bigint NOT NULL
);


ALTER TABLE public.thaali_orders OWNER TO rsvp;

--
-- Name: thaali_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: rsvp
--

CREATE SEQUENCE public.thaali_orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.thaali_orders_id_seq OWNER TO rsvp;

--
-- Name: thaali_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rsvp
--

ALTER SEQUENCE public.thaali_orders_id_seq OWNED BY public.thaali_orders.id;


--
-- Name: v_event_menu_dish_ingredients; Type: VIEW; Schema: public; Owner: rsvp
--

CREATE VIEW public.v_event_menu_dish_ingredients AS
 SELECT mi.event_id,
    mi.id AS menu_item_id,
    d.id AS dish_id,
    di.ingredient_id,
    di.qty_per_quart,
    COALESCE(mi.quarts_per_thaali_unit, d.default_quarts_per_thaali_unit) AS quarts_per_thaali_unit
   FROM ((public.menu_items mi
     JOIN public.dishes d ON ((d.id = mi.dish_id)))
     JOIN public.dish_ingredients di ON ((di.dish_id = d.id)));


ALTER VIEW public.v_event_menu_dish_ingredients OWNER TO rsvp;

--
-- Name: chefs id; Type: DEFAULT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.chefs ALTER COLUMN id SET DEFAULT nextval('public.chefs_id_seq'::regclass);


--
-- Name: dishes id; Type: DEFAULT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.dishes ALTER COLUMN id SET DEFAULT nextval('public.dishes_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- Name: ingredients id; Type: DEFAULT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.ingredients ALTER COLUMN id SET DEFAULT nextval('public.ingredients_id_seq'::regclass);


--
-- Name: menu_items id; Type: DEFAULT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.menu_items ALTER COLUMN id SET DEFAULT nextval('public.menu_items_id_seq'::regclass);


--
-- Name: niyaz_rsvps id; Type: DEFAULT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.niyaz_rsvps ALTER COLUMN id SET DEFAULT nextval('public.niyaz_rsvps_id_seq'::regclass);


--
-- Name: persons id; Type: DEFAULT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.persons ALTER COLUMN id SET DEFAULT nextval('public.persons_id_seq'::regclass);


--
-- Name: pickup_zones id; Type: DEFAULT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.pickup_zones ALTER COLUMN id SET DEFAULT nextval('public.pickup_zones_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: thaali_order_items id; Type: DEFAULT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.thaali_order_items ALTER COLUMN id SET DEFAULT nextval('public.thaali_order_items_id_seq'::regclass);


--
-- Name: thaali_orders id; Type: DEFAULT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.thaali_orders ALTER COLUMN id SET DEFAULT nextval('public.thaali_orders_id_seq'::regclass);


--
-- Data for Name: chefs; Type: TABLE DATA; Schema: public; Owner: rsvp
--

COPY public.chefs (id, name, type, email, phone, notes, active, created_at) FROM stdin;
1	Jabalpurwala	GROUP	\N	(301) 661-4672	\N	t	2025-12-27 03:17:24.902342+00
2	Turabi	GROUP	\N	(571) 234-2943	\N	t	2025-12-27 03:18:05.211137+00
3	Ravat	GROUP	\N	(240) 520-2546	\N	t	2025-12-27 03:18:37.404316+00
4	Rangwala	GROUP	\N	(240) 476-2096	\N	t	2025-12-27 03:19:08.084865+00
5	Kanchwala	GROUP	\N	(240) 475-8599	\N	t	2025-12-27 03:19:29.515454+00
6	Hanif	PERSON	\N	(703) 622-0169	\N	t	2025-12-27 03:20:43.568694+00
7	Samreena	PERSON	\N	(240) 595-4927	\N	t	2025-12-27 03:21:17.997697+00
\.


--
-- Data for Name: dish_ingredients; Type: TABLE DATA; Schema: public; Owner: rsvp
--

COPY public.dish_ingredients (dish_id, ingredient_id, qty_per_quart) FROM stdin;
1	57	1.350
1	51	0.050
1	17	0.030
1	255	0.400
1	121	0.120
1	66	0.100
2	37	0.167
3	62	0.500
3	210	0.450
3	194	0.200
3	27	0.400
3	31	0.400
3	179	0.150
3	81	0.300
3	65	0.050
3	169	0.200
4	52	1.300
4	179	0.050
4	46	0.040
4	185	0.120
4	201	0.600
4	109	0.050
4	40	0.150
4	147	0.020
4	2	0.050
4	163	0.040
5	62	1.000
5	38	0.400
5	179	0.250
5	171	0.150
5	48	0.200
5	26	0.150
5	27	0.150
5	124	0.050
5	222	0.100
5	79	0.100
5	214	0.040
6	206	0.450
6	61	1.200
6	150	0.050
6	239	0.150
6	181	0.050
6	234	0.050
6	2	0.050
6	73	0.100
7	136	0.200
8	47	1.000
8	78	1.000
8	87	1.000
8	22	1.000
8	131	1.000
8	130	1.000
8	74	200.000
8	106	1.000
8	88	1.000
9	79	1.000
9	45	1.000
9	111	1.000
9	127	1.000
9	147	1.000
9	108	1.000
9	30	1.000
9	222	1.000
9	89	1.000
9	241	1.000
9	14	1.000
9	109	1.000
9	240	1.000
9	214	1.000
9	29	1.000
9	100	1.000
9	205	1.000
9	211	1.000
10	201	1.000
11	96	0.750
11	189	0.100
11	76	0.020
11	215	0.020
11	230	0.080
11	67	1.000
11	75	0.080
12	6	0.300
12	32	0.120
12	196	0.120
12	137	0.120
12	179	0.100
12	69	0.050
12	26	0.075
12	237	0.100
12	11	0.250
13	62	0.300
13	206	0.550
13	27	0.350
13	212	0.250
13	73	0.100
13	191	0.100
13	98	0.150
14	112	1.000
14	75	0.250
14	179	0.050
14	105	0.040
14	148	0.100
14	129	0.020
14	20	0.060
14	66	0.100
14	152	0.050
14	109	0.050
15	57	1.080
15	9	0.200
15	73	0.050
15	255	0.150
15	179	0.185
15	237	0.150
16	24	0.300
16	155	0.500
16	179	0.150
16	27	0.300
16	176	0.150
16	163	0.180
16	40	0.050
16	10	0.200
16	102	0.080
16	81	0.100
16	63	0.250
17	206	0.450
17	61	1.200
17	150	0.030
17	239	0.150
17	181	0.050
17	234	0.050
17	2	0.050
17	73	0.100
18	98	0.450
18	75	0.350
18	135	0.200
18	89	0.100
18	51	0.100
18	172	0.100
19	40	0.250
20	98	1.000
21	209	1.000
22	233	0.080
22	161	1.000
23	98	0.450
23	75	0.350
23	179	0.200
23	89	0.100
23	230	0.100
23	66	0.100
23	73	0.080
23	241	0.200
24	57	1.125
24	179	0.250
24	134	0.013
24	230	0.100
24	75	0.200
24	89	0.100
24	241	0.200
24	73	0.100
24	76	0.050
25	25	0.500
25	63	0.350
25	179	0.100
25	40	0.040
25	221	0.040
25	199	0.020
25	185	0.040
25	2	0.030
25	94	0.380
25	98	0.040
25	172	0.010
25	109	0.020
26	63	0.400
26	5	0.500
26	179	0.300
26	171	0.150
26	20	0.200
26	27	0.500
26	250	0.150
26	222	0.050
26	79	0.100
26	214	0.040
26	25	0.400
26	236	0.200
26	223	0.200
27	62	1.200
27	5	0.500
27	179	0.300
27	171	0.150
27	20	0.200
27	27	0.500
27	250	0.150
27	222	0.050
27	79	0.100
27	214	0.040
28	57	1.000
28	75	0.250
28	201	0.100
28	48	0.080
28	26	0.080
28	95	0.100
28	171	0.080
28	105	0.040
28	148	0.100
28	129	0.020
28	20	0.060
28	73	0.300
28	66	0.100
28	152	0.050
28	109	0.050
29	57	1.000
29	179	0.250
29	228	0.300
29	77	0.250
29	85	0.200
29	241	0.200
29	73	0.100
29	76	0.050
30	57	1.200
30	254	0.333
30	179	0.333
30	15	0.222
30	30	0.100
31	112	1.000
31	254	0.330
31	179	0.330
31	15	0.220
31	30	0.100
32	206	0.600
32	112	0.600
32	73	0.250
32	164	0.120
32	179	0.250
32	12	0.250
32	75	0.130
33	96	1.000
33	201	0.450
33	179	0.180
33	241	0.180
33	73	0.100
34	225	0.750
34	201	0.500
34	179	0.250
34	241	0.250
34	73	0.120
34	159	0.300
35	52	1.000
35	201	0.450
35	179	0.180
35	241	0.180
35	73	0.100
36	114	0.850
36	179	0.400
36	201	0.400
36	240	0.167
36	73	0.083
36	121	0.083
36	51	0.067
37	201	1.500
37	73	0.100
37	89	0.100
38	60	1.000
39	59	2.000
39	48	0.200
39	185	0.120
39	52	0.200
39	27	0.500
39	147	0.020
39	201	0.200
39	40	0.050
40	21	1.000
41	59	2.300
41	172	0.030
41	1	0.250
41	109	0.030
42	62	1.000
42	172	0.030
42	1	0.250
42	179	0.080
42	7	0.375
43	25	0.200
43	32	0.120
43	196	0.120
43	137	0.120
43	179	0.100
43	69	0.050
43	26	0.075
43	237	0.100
43	11	0.250
43	63	0.200
44	239	0.300
44	179	0.350
44	174	1.850
44	73	0.100
45	35	0.100
45	202	0.100
45	249	0.250
45	162	0.050
45	163	0.070
46	4	1.000
47	146	1.000
48	173	1.000
49	183	1.000
50	218	1.000
51	57	1.080
51	51	0.075
51	40	0.050
51	123	0.050
51	179	0.185
51	163	0.050
51	238	0.350
51	39	0.200
51	73	0.050
52	42	1.800
52	43	0.200
52	179	0.150
52	168	0.020
52	73	0.070
53	52	1.250
53	179	0.350
53	73	0.120
53	66	0.080
53	51	0.050
53	238	0.670
53	28	0.130
53	75	0.120
54	55	0.450
54	91	1.000
54	240	0.150
54	73	0.150
54	179	0.150
55	112	1.100
55	179	0.300
55	240	0.200
55	55	0.200
55	73	0.100
56	33	0.250
56	206	0.550
56	179	0.250
56	241	0.250
56	73	0.100
56	66	0.050
57	57	1.050
57	75	0.250
57	128	0.150
57	89	0.100
57	230	0.100
57	66	0.050
58	206	0.450
58	255	0.220
58	57	0.600
58	30	0.130
58	237	0.040
58	164	0.130
58	73	0.170
58	13	0.100
58	201	0.220
59	62	0.200
59	179	0.200
59	84	0.200
59	81	0.200
59	98	0.080
60	57	1.100
60	179	0.250
60	240	0.300
60	73	0.100
61	61	1.000
61	101	0.222
61	73	0.100
61	115	0.200
61	179	0.650
61	26	0.350
62	57	1.000
62	174	0.175
62	54	0.120
62	179	0.120
62	26	0.100
62	102	0.100
62	138	0.200
63	118	0.400
63	212	0.500
63	49	0.180
63	42	0.250
63	171	0.100
63	26	0.170
63	66	0.100
63	222	0.020
63	251	0.010
63	214	0.050
63	109	0.100
63	14	0.050
63	72	0.500
63	62	0.300
64	57	1.500
64	179	0.500
64	254	0.250
64	239	0.250
64	97	0.250
64	26	0.600
64	73	0.100
65	63	1.100
65	226	0.950
65	179	0.200
65	241	0.150
66	57	0.350
66	179	0.100
66	164	0.200
66	48	0.100
66	54	0.100
66	163	0.070
67	63	1.300
67	164	0.100
67	30	0.030
67	239	0.100
67	147	0.002
67	179	0.100
67	98	0.100
67	36	0.100
67	73	0.150
68	58	2.300
68	255	0.400
68	221	0.200
68	189	0.070
68	38	0.250
68	171	0.100
68	170	0.150
68	83	0.150
68	27	0.500
68	51	0.030
68	147	0.050
68	65	0.100
69	58	1.600
69	30	0.070
69	240	0.300
69	73	0.100
70	57	1.300
70	51	0.100
70	255	0.200
70	163	0.030
70	229	0.025
70	179	0.100
70	73	0.070
70	121	0.040
70	58	1.600
70	185	0.120
70	54	0.200
70	38	0.250
70	40	0.050
70	171	0.100
70	184	0.050
71	62	1.500
71	212	0.350
71	133	0.200
71	179	0.100
71	98	0.100
71	66	0.100
71	222	0.020
71	79	0.070
71	214	0.080
71	109	0.030
72	62	0.500
72	192	0.450
72	38	0.250
72	27	0.300
72	256	0.200
72	179	0.150
72	171	0.150
72	163	0.050
72	40	0.050
72	169	0.100
72	102	0.200
72	2	0.030
73	59	2.000
73	46	0.040
73	185	0.120
73	192	0.200
73	38	0.200
73	40	0.050
74	61	0.500
74	101	0.222
74	10	0.500
74	115	0.200
74	179	0.100
75	57	1.000
75	179	0.350
75	73	0.120
75	66	0.080
75	51	0.050
75	238	0.670
75	27	0.150
75	75	0.120
76	56	0.200
76	179	0.300
76	73	0.200
76	81	0.200
76	152	0.100
76	207	0.250
76	32	0.120
76	69	0.100
76	80	1.000
76	175	0.020
76	2	0.050
76	241	0.250
76	10	0.150
76	153	0.500
77	61	0.250
77	206	0.550
77	179	0.250
77	241	0.250
77	73	0.100
77	66	0.050
77	165	0.350
78	62	0.750
78	83	0.200
78	38	0.550
78	27	0.500
78	201	0.100
78	179	0.200
78	171	0.250
78	163	0.050
78	40	0.050
78	10	0.100
78	102	0.200
78	2	0.030
78	169	0.100
79	201	0.250
79	103	0.650
79	179	0.250
79	239	0.200
79	112	0.500
79	228	0.100
79	191	0.200
79	5	0.100
79	243	0.200
79	157	0.070
79	93	0.050
80	62	1.350
80	212	0.400
80	49	0.150
80	179	0.200
80	26	0.300
80	66	0.100
80	222	0.020
80	79	0.070
80	214	0.080
80	109	0.100
80	14	0.050
80	237	0.050
81	107	1.670
81	71	0.125
81	179	0.200
81	239	0.200
81	66	0.070
81	73	0.125
81	255	0.170
82	212	0.300
82	49	0.100
82	42	0.750
82	43	0.150
82	253	0.250
82	158	0.100
82	92	0.080
83	114	0.150
83	192	0.600
83	38	0.150
83	27	0.300
83	256	0.200
83	179	0.150
83	171	0.150
83	163	0.050
83	40	0.050
83	184	0.100
83	123	0.050
83	48	0.150
83	242	0.150
83	20	0.100
84	206	0.550
84	244	0.250
85	179	0.200
85	243	0.400
85	241	0.100
85	112	0.350
85	73	0.100
86	248	0.300
86	137	0.120
86	55	0.060
86	121	0.100
86	40	0.060
86	237	0.100
87	239	0.100
87	179	0.200
87	243	0.350
87	73	0.025
87	66	0.040
87	89	0.100
87	55	0.050
88	179	0.200
88	254	0.400
88	89	0.100
88	73	0.100
88	66	0.100
88	239	0.200
88	29	0.050
89	55	0.650
89	179	0.160
89	240	0.100
89	73	0.100
89	89	0.100
89	109	0.020
89	110	0.020
90	91	1.600
90	179	0.350
90	241	0.150
90	73	0.150
90	89	0.080
91	200	1.250
91	51	0.200
91	73	0.050
91	255	0.150
91	179	0.200
91	240	0.200
92	18	1.000
93	19	1.000
94	34	2.000
95	193	1.000
96	139	1.000
97	180	1.000
98	188	1.000
99	190	1.000
100	198	1.000
101	245	0.125
102	206	0.520
102	112	0.490
102	255	0.220
102	30	0.130
102	237	0.040
102	164	0.150
102	73	0.170
102	13	0.100
102	201	0.220
103	112	1.050
103	75	0.250
103	128	0.150
103	89	0.100
103	230	0.100
103	66	0.050
104	112	0.850
104	240	0.200
104	179	0.200
104	66	0.050
104	201	0.300
105	5	1.000
105	201	0.450
105	179	0.200
105	239	0.200
105	73	0.100
106	57	1.400
106	73	0.650
106	51	0.150
106	164	0.100
106	76	0.100
106	239	0.200
106	147	0.020
106	66	0.080
106	255	0.250
106	179	0.250
107	112	1.200
107	73	0.650
107	51	0.150
107	164	0.100
107	30	0.050
107	241	0.200
107	147	0.020
107	66	0.080
107	254	0.250
107	179	0.250
108	117	1.000
108	201	0.450
108	179	0.180
108	239	0.180
108	73	0.100
109	112	0.450
109	120	0.150
109	243	0.030
109	55	0.030
109	168	0.030
109	179	0.200
109	66	0.050
109	241	0.170
109	73	0.170
109	119	0.070
110	149	0.070
110	30	0.050
110	164	0.100
111	57	1.500
111	179	0.250
111	73	0.120
111	66	0.080
111	255	0.080
111	240	0.100
112	143	1.000
112	142	1.000
113	154	1.200
113	179	0.100
113	66	0.170
113	241	0.200
113	237	0.100
113	73	0.050
114	57	1.500
114	179	0.100
114	73	0.120
114	66	0.080
114	241	0.500
114	237	0.100
115	132	1.000
116	90	0.125
117	25	0.450
117	63	0.550
117	201	0.600
117	179	0.200
117	241	0.150
117	114	0.150
118	63	0.550
118	226	0.950
118	179	0.200
118	241	0.150
118	24	0.550
119	206	0.500
119	25	0.300
119	255	0.220
119	30	0.130
119	237	0.040
119	164	0.130
119	73	0.170
119	13	0.100
119	201	0.220
119	63	0.350
120	168	0.150
120	206	0.550
120	179	0.250
120	241	0.250
120	73	0.100
120	66	0.050
120	25	0.300
120	63	0.300
121	25	0.450
121	63	0.600
121	187	0.950
121	179	0.200
121	241	0.150
122	24	0.450
122	63	0.550
122	73	0.100
122	179	0.400
122	239	0.350
122	114	0.300
122	7	0.250
123	206	0.450
123	168	0.150
124	25	0.450
124	63	0.600
124	238	0.200
124	254	0.250
124	30	0.100
124	73	0.100
124	98	0.020
125	206	0.250
125	156	0.250
125	99	0.100
125	107	0.150
125	179	0.300
125	238	0.350
125	30	0.100
125	73	0.100
126	25	0.550
126	63	0.700
126	164	0.100
126	30	0.030
126	239	0.100
126	147	0.002
126	179	0.100
126	98	0.100
126	36	0.100
126	73	0.150
127	63	0.100
127	25	0.100
127	186	0.200
127	179	0.150
127	171	0.200
127	225	0.150
127	208	0.400
127	82	0.200
127	184	0.050
127	144	0.235
127	169	0.200
128	58	1.650
128	179	0.150
128	149	0.050
128	177	0.150
128	27	0.100
128	73	0.100
129	112	0.950
129	240	0.300
129	179	0.300
129	66	0.050
130	241	0.100
130	179	0.200
130	156	0.400
130	73	0.025
131	112	0.500
132	156	0.250
132	206	0.550
132	179	0.250
132	241	0.250
132	73	0.100
132	66	0.050
132	112	0.400
133	114	0.850
133	179	0.400
133	182	0.400
133	240	0.167
133	73	0.083
133	121	0.083
133	51	0.067
134	255	0.500
134	163	0.050
134	227	0.100
134	252	0.080
135	125	0.330
136	8	6.000
137	3	0.250
138	232	0.330
139	247	0.330
140	44	1.000
141	104	1.000
142	44	1.000
143	116	0.222
144	126	1.000
145	217	1.000
146	220	1.000
146	166	1.000
147	246	0.125
148	179	0.200
148	157	0.130
148	248	0.120
148	55	0.110
148	167	0.080
148	241	0.100
149	179	0.200
149	157	0.110
149	248	0.100
149	55	0.100
149	167	0.075
149	241	0.100
149	112	0.450
150	165	1.100
150	201	0.400
150	179	0.400
150	239	0.400
150	73	0.100
151	167	0.250
151	206	0.550
151	179	0.250
151	241	0.250
151	73	0.100
151	66	0.050
152	112	0.150
152	179	0.100
152	164	0.120
152	48	0.120
152	113	0.180
152	54	0.120
152	163	0.070
153	113	1.000
153	179	0.300
153	241	0.200
153	73	1.100
153	112	0.250
154	52	0.200
154	201	0.250
154	5	0.150
154	179	0.400
154	26	0.100
154	27	0.300
154	51	0.120
154	121	0.050
154	50	0.150
154	239	0.400
154	195	0.100
155	23	1.300
155	179	0.300
155	66	0.100
155	73	0.110
155	102	0.050
156	219	0.033
157	177	0.150
158	157	0.353
158	179	0.294
158	241	0.206
158	73	0.088
158	66	0.059
159	201	0.400
159	53	0.350
159	179	0.200
159	240	0.200
159	48	0.200
159	114	0.250
159	26	0.200
159	38	0.250
160	122	4.000
161	224	1.000
162	225	1.200
162	182	0.450
162	179	0.300
162	239	0.250
162	73	0.150
162	254	0.080
163	244	0.100
163	91	0.200
163	93	0.100
163	140	0.040
163	179	0.100
163	239	0.150
163	109	0.050
163	29	0.100
164	57	1.000
164	75	0.250
164	201	0.100
164	48	0.080
164	27	0.250
164	95	0.100
164	171	0.080
164	105	0.040
164	148	0.100
164	129	0.020
164	20	0.100
164	73	0.080
164	68	0.150
164	152	0.050
164	109	0.050
164	189	0.050
165	182	1.200
165	179	0.500
165	254	0.250
165	239	0.400
165	27	1.000
165	26	0.300
165	73	0.100
166	182	0.900
166	179	0.350
166	73	0.120
166	66	0.080
166	241	0.500
166	237	0.100
166	26	0.150
166	253	0.100
167	182	0.900
167	51	0.075
167	40	0.050
167	123	0.050
167	179	0.185
167	163	0.050
167	238	0.350
167	39	0.200
167	73	0.050
168	182	0.780
168	179	0.350
168	73	0.120
168	66	0.080
168	51	0.050
168	238	0.500
168	28	0.200
168	75	0.120
169	204	1.100
169	160	0.080
169	194	0.140
169	184	0.040
170	57	1.000
170	179	0.150
170	201	0.150
170	48	0.080
170	26	0.100
170	177	0.100
170	185	0.050
170	239	0.100
170	69	0.020
170	73	0.080
170	109	0.050
171	97	1.333
171	179	0.467
171	241	0.400
171	26	0.333
171	73	0.133
172	255	0.600
172	86	0.150
172	178	0.150
172	73	0.050
172	164	0.050
173	204	1.100
173	179	0.050
173	225	0.100
173	171	0.080
173	184	0.040
173	186	0.300
173	121	0.050
173	123	0.020
174	86	1.000
175	150	0.333
176	27	1.000
177	48	2.000
178	151	1.000
179	199	0.063
179	163	0.063
179	162	0.150
179	227	0.050
179	16	0.030
179	197	0.030
179	40	0.025
180	216	0.050
180	203	0.050
180	135	0.050
180	211	0.100
180	161	0.200
180	227	0.100
181	63	0.550
181	172	0.030
181	238	0.150
181	179	0.100
181	26	0.050
181	24	0.500
181	122	6.000
182	213	0.250
182	203	0.050
182	227	0.120
182	70	10.000
182	161	0.300
182	110	0.120
182	16	0.100
182	40	0.080
183	62	0.500
183	26	0.150
183	41	0.150
183	50	0.150
183	179	0.200
183	195	0.150
183	38	0.200
183	133	0.025
184	229	0.400
184	147	0.100
184	252	0.100
184	109	0.100
185	58	1.750
185	254	0.070
185	73	0.100
185	231	0.200
185	147	0.020
186	235	2.000
186	179	0.050
186	73	0.050
187	238	0.350
187	163	0.040
187	179	0.125
187	54	0.200
187	81	0.100
187	48	0.090
188	206	0.450
188	165	0.650
188	255	0.230
188	30	0.150
188	238	0.045
188	164	0.130
188	73	0.170
188	13	0.100
188	201	0.200
188	96	0.100
189	118	0.400
189	212	0.500
189	49	0.180
189	42	0.250
189	171	0.100
189	26	0.170
189	66	0.100
189	222	0.020
189	251	0.010
189	214	0.050
189	109	0.100
189	14	0.050
189	72	0.500
190	165	0.600
190	201	0.250
190	38	0.270
190	179	0.250
190	254	0.300
190	141	0.150
190	51	0.075
190	75	0.170
191	169	0.200
191	145	0.235
191	186	0.200
191	179	0.150
191	171	0.200
191	28	0.150
191	208	0.400
191	256	0.200
191	184	0.050
192	206	0.550
193	64	1.000
193	51	0.100
193	255	0.200
193	163	0.030
193	229	0.025
193	179	0.100
193	73	0.070
193	121	0.040
194	64	1.000
194	30	0.100
194	240	0.300
194	73	0.100
194	255	0.100
\.


--
-- Data for Name: dishes; Type: TABLE DATA; Schema: public; Owner: rsvp
--

COPY public.dishes (id, name, description, default_quarts_per_thaali_unit, active, created_at, updated_at) FROM stdin;
1	Afghani Chicken	\N	1.00	t	2025-12-27 03:04:43.656441+00	2025-12-27 03:04:43.656441+00
2	Afghani bread	\N	1.00	t	2025-12-27 03:04:43.657293+00	2025-12-27 03:04:43.657293+00
3	Black bean Veggie Pesto Chicken Pasta	\N	1.00	t	2025-12-27 03:04:43.657882+00	2025-12-27 03:04:43.657882+00
4	Cauliflower steaks w/mashed and picatta sauce	\N	1.00	t	2025-12-27 03:04:43.658563+00	2025-12-27 03:04:43.658563+00
5	Chinese chicken stirfry	\N	1.00	t	2025-12-27 03:04:43.659119+00	2025-12-27 03:04:43.659119+00
6	Falafel with rice	\N	1.00	t	2025-12-27 03:04:43.65972+00	2025-12-27 03:04:43.65972+00
7	General - kheer	\N	1.00	t	2025-12-27 03:04:43.660266+00	2025-12-27 03:04:43.660266+00
8	General - pantry spice	\N	1.00	t	2025-12-27 03:04:43.660804+00	2025-12-27 03:04:43.660804+00
9	General - pantry staple	\N	1.00	t	2025-12-27 03:04:43.661462+00	2025-12-27 03:04:43.661462+00
10	General Items - stock adjust	\N	1.00	t	2025-12-27 03:04:43.66212+00	2025-12-27 03:04:43.66212+00
11	Hyderbadi baingan	\N	1.00	t	2025-12-27 03:04:43.662714+00	2025-12-27 03:04:43.662714+00
12	Impossible chili	\N	1.00	t	2025-12-27 03:04:43.663324+00	2025-12-27 03:04:43.663324+00
13	Indian-style chicken fried rice	\N	1.00	t	2025-12-27 03:04:43.663943+00	2025-12-27 03:04:43.663943+00
14	Indonesian rendang curry (goat)	\N	1.00	t	2025-12-27 03:04:43.664576+00	2025-12-27 03:04:43.664576+00
15	Lahori chicken	\N	1.00	t	2025-12-27 03:04:43.665218+00	2025-12-27 03:04:43.665218+00
16	Mexican mac and cheese	\N	1.00	t	2025-12-27 03:04:43.665866+00	2025-12-27 03:04:43.665866+00
17	Mideast Chicken and Rice	\N	1.00	t	2025-12-27 03:04:43.666552+00	2025-12-27 03:04:43.666552+00
18	North Indian egg curry	\N	1.00	t	2025-12-27 03:04:43.667137+00	2025-12-27 03:04:43.667137+00
19	SEHORI butter	\N	1.00	t	2025-12-27 03:04:43.66776+00	2025-12-27 03:04:43.66776+00
20	SEHORI eggs	\N	1.00	t	2025-12-27 03:04:43.668459+00	2025-12-27 03:04:43.668459+00
21	SEHORI roti	\N	1.00	t	2025-12-27 03:04:43.669137+00	2025-12-27 03:04:43.669137+00
22	SEHORI tea items	\N	1.00	t	2025-12-27 03:04:43.66973+00	2025-12-27 03:04:43.66973+00
23	South Indian egg curry	\N	1.00	t	2025-12-27 03:04:43.670381+00	2025-12-27 03:04:43.670381+00
24	Sri Lankan chicken curry	\N	1.00	t	2025-12-27 03:04:43.670959+00	2025-12-27 03:04:43.670959+00
25	Swedish meatballs	\N	1.00	t	2025-12-27 03:04:43.671541+00	2025-12-27 03:04:43.671541+00
26	Thai beef stirfry	\N	1.00	t	2025-12-27 03:04:43.672142+00	2025-12-27 03:04:43.672142+00
27	Thai chicken stirfry	\N	1.00	t	2025-12-27 03:04:43.672728+00	2025-12-27 03:04:43.672728+00
28	Thai green curry (chicken)	\N	1.00	t	2025-12-27 03:04:43.673314+00	2025-12-27 03:04:43.673314+00
29	West African peanut chicken curry	\N	1.00	t	2025-12-27 03:04:43.673903+00	2025-12-27 03:04:43.673903+00
30	achaar chicken	\N	1.00	t	2025-12-27 03:04:43.67455+00	2025-12-27 03:04:43.67455+00
31	achaar gosht	\N	1.00	t	2025-12-27 03:04:43.675178+00	2025-12-27 03:04:43.675178+00
32	akhni pulao	\N	1.00	t	2025-12-27 03:04:43.675777+00	2025-12-27 03:04:43.675777+00
33	aloo baingan	\N	1.00	t	2025-12-27 03:04:43.676669+00	2025-12-27 03:04:43.676669+00
34	aloo bhajhi	\N	1.00	t	2025-12-27 03:04:43.677569+00	2025-12-27 03:04:43.677569+00
35	aloo gobi	\N	1.00	t	2025-12-27 03:04:43.678277+00	2025-12-27 03:04:43.678277+00
36	aloo matar	\N	1.00	t	2025-12-27 03:04:43.678866+00	2025-12-27 03:04:43.678866+00
37	aloo tarkari (rai wala)	\N	1.00	t	2025-12-27 03:04:43.679491+00	2025-12-27 03:04:43.679491+00
38	baked chicken tenders	\N	1.00	t	2025-12-27 03:04:43.680031+00	2025-12-27 03:04:43.680031+00
39	baked herb chicken	\N	1.00	t	2025-12-27 03:04:43.680594+00	2025-12-27 03:04:43.680594+00
40	batura bread	\N	1.00	t	2025-12-27 03:04:43.681225+00	2025-12-27 03:04:43.681225+00
41	bbq chicken legs	\N	1.00	t	2025-12-27 03:04:43.681798+00	2025-12-27 03:04:43.681798+00
42	bbq chicken sliders	\N	1.00	t	2025-12-27 03:04:43.682402+00	2025-12-27 03:04:43.682402+00
43	beef chili	\N	1.00	t	2025-12-27 03:04:43.682966+00	2025-12-27 03:04:43.682966+00
44	bhinda masala	\N	1.00	t	2025-12-27 03:04:43.683697+00	2025-12-27 03:04:43.683697+00
45	blueberry poundcake trifle	\N	1.00	t	2025-12-27 03:04:43.684258+00	2025-12-27 03:04:43.684258+00
46	bread - baguette	\N	1.00	t	2025-12-27 03:04:43.684804+00	2025-12-27 03:04:43.684804+00
47	bread - lavash	\N	1.00	t	2025-12-27 03:04:43.685434+00	2025-12-27 03:04:43.685434+00
48	bread - naan	\N	1.00	t	2025-12-27 03:04:43.686048+00	2025-12-27 03:04:43.686048+00
49	bread - paratha	\N	1.00	t	2025-12-27 03:04:43.68663+00	2025-12-27 03:04:43.68663+00
50	bread - sheermal	\N	1.00	t	2025-12-27 03:04:43.687218+00	2025-12-27 03:04:43.687218+00
51	butter chicken	\N	1.00	t	2025-12-27 03:04:43.687781+00	2025-12-27 03:04:43.687781+00
52	cabbage stirfry	\N	1.00	t	2025-12-27 03:04:43.688428+00	2025-12-27 03:04:43.688428+00
53	cauliflower tikka masala	\N	1.00	t	2025-12-27 03:04:43.689036+00	2025-12-27 03:04:43.689036+00
54	chana doodhi	\N	1.00	t	2025-12-27 03:04:43.68962+00	2025-12-27 03:04:43.68962+00
55	chana gosht	\N	1.00	t	2025-12-27 03:04:43.690182+00	2025-12-27 03:04:43.690182+00
56	chawla pulao	\N	1.00	t	2025-12-27 03:04:43.690752+00	2025-12-27 03:04:43.690752+00
57	chicen kaari	\N	1.00	t	2025-12-27 03:04:43.691368+00	2025-12-27 03:04:43.691368+00
58	chicken biryani	\N	1.00	t	2025-12-27 03:04:43.691929+00	2025-12-27 03:04:43.691929+00
59	chicken corn soup	\N	1.00	t	2025-12-27 03:04:43.69256+00	2025-12-27 03:04:43.69256+00
60	chicken curry	\N	1.00	t	2025-12-27 03:04:43.693149+00	2025-12-27 03:04:43.693149+00
61	chicken fajita	\N	1.00	t	2025-12-27 03:04:43.693714+00	2025-12-27 03:04:43.693714+00
62	chicken gumbo	\N	1.00	t	2025-12-27 03:04:43.694286+00	2025-12-27 03:04:43.694286+00
63	chicken hakka noodles	\N	1.00	t	2025-12-27 03:04:43.695044+00	2025-12-27 03:04:43.695044+00
64	chicken jalfrezi	\N	1.00	t	2025-12-27 03:04:43.695632+00	2025-12-27 03:04:43.695632+00
65	chicken kheema bhaji	\N	1.00	t	2025-12-27 03:04:43.696232+00	2025-12-27 03:04:43.696232+00
66	chicken khurdhi	\N	1.00	t	2025-12-27 03:04:43.696827+00	2025-12-27 03:04:43.696827+00
67	chicken lagan ni seekh	\N	1.00	t	2025-12-27 03:04:43.697465+00	2025-12-27 03:04:43.697465+00
68	chicken legs in peanut sauce	\N	1.00	t	2025-12-27 03:04:43.698074+00	2025-12-27 03:04:43.698074+00
69	chicken legs in red sauce	\N	1.00	t	2025-12-27 03:04:43.698656+00	2025-12-27 03:04:43.698656+00
70	chicken legs in white sauce	\N	1.00	t	2025-12-27 03:04:43.699201+00	2025-12-27 03:04:43.699201+00
71	chicken manchurian	\N	1.00	t	2025-12-27 03:04:43.6998+00	2025-12-27 03:04:43.6998+00
72	chicken pasta casserole	\N	1.00	t	2025-12-27 03:04:43.700413+00	2025-12-27 03:04:43.700413+00
73	chicken picatta	\N	1.00	t	2025-12-27 03:04:43.70097+00	2025-12-27 03:04:43.70097+00
74	chicken quesadilla	\N	1.00	t	2025-12-27 03:04:43.70151+00	2025-12-27 03:04:43.70151+00
75	chicken tikka masala	\N	1.00	t	2025-12-27 03:04:43.702073+00	2025-12-27 03:04:43.702073+00
76	chicken tortilla soup w/rice and beans	\N	1.00	t	2025-12-27 03:04:43.702639+00	2025-12-27 03:04:43.702639+00
77	chicken vegetable pulao	\N	1.00	t	2025-12-27 03:04:43.70321+00	2025-12-27 03:04:43.70321+00
78	chicken veggie casserole	\N	1.00	t	2025-12-27 03:04:43.703804+00	2025-12-27 03:04:43.703804+00
79	chickoli	\N	1.00	t	2025-12-27 03:04:43.704488+00	2025-12-27 03:04:43.704488+00
80	chilli chicken	\N	1.00	t	2025-12-27 03:04:43.705098+00	2025-12-27 03:04:43.705098+00
81	chola batura	\N	1.00	t	2025-12-27 03:04:43.705677+00	2025-12-27 03:04:43.705677+00
82	coleslaw	\N	1.00	t	2025-12-27 03:04:43.706245+00	2025-12-27 03:04:43.706245+00
83	creamy pasta primavera	\N	1.00	t	2025-12-27 03:04:43.706803+00	2025-12-27 03:04:43.706803+00
84	daal chawal	\N	1.00	t	2025-12-27 03:04:43.707374+00	2025-12-27 03:04:43.707374+00
85	daal gosht	\N	1.00	t	2025-12-27 03:04:43.70792+00	2025-12-27 03:04:43.70792+00
86	daal makhani	\N	1.00	t	2025-12-27 03:04:43.708497+00	2025-12-27 03:04:43.708497+00
87	daal tadka (daal fry)	\N	1.00	t	2025-12-27 03:04:43.70913+00	2025-12-27 03:04:43.70913+00
88	dahi kadhi	\N	1.00	t	2025-12-27 03:04:43.709718+00	2025-12-27 03:04:43.709718+00
89	dhaba chana dal fry	\N	1.00	t	2025-12-27 03:04:43.710341+00	2025-12-27 03:04:43.710341+00
90	doodhi tarkari	\N	1.00	t	2025-12-27 03:04:43.71097+00	2025-12-27 03:04:43.71097+00
91	dum aloo	\N	1.00	t	2025-12-27 03:04:43.711623+00	2025-12-27 03:04:43.711623+00
92	fruit - apple	\N	1.00	t	2025-12-27 03:04:43.712311+00	2025-12-27 03:04:43.712311+00
93	fruit - banana	\N	1.00	t	2025-12-27 03:04:43.712889+00	2025-12-27 03:04:43.712889+00
94	fruit - blueberries	\N	1.00	t	2025-12-27 03:04:43.713629+00	2025-12-27 03:04:43.713629+00
95	fruit - buyer's choice	\N	1.00	t	2025-12-27 03:04:43.714293+00	2025-12-27 03:04:43.714293+00
96	fruit - kiwi	\N	1.00	t	2025-12-27 03:04:43.714899+00	2025-12-27 03:04:43.714899+00
97	fruit - orange	\N	1.00	t	2025-12-27 03:04:43.71553+00	2025-12-27 03:04:43.71553+00
98	fruit - peach	\N	1.00	t	2025-12-27 03:04:43.716105+00	2025-12-27 03:04:43.716105+00
99	fruit - pear	\N	1.00	t	2025-12-27 03:04:43.716702+00	2025-12-27 03:04:43.716702+00
100	fruit - plum	\N	1.00	t	2025-12-27 03:04:43.717352+00	2025-12-27 03:04:43.717352+00
101	general - tres leches caramel cake	\N	1.00	t	2025-12-27 03:04:43.71794+00	2025-12-27 03:04:43.71794+00
102	gosht biryani	\N	1.00	t	2025-12-27 03:04:43.71851+00	2025-12-27 03:04:43.71851+00
103	gosht kaari	\N	1.00	t	2025-12-27 03:04:43.719233+00	2025-12-27 03:04:43.719233+00
104	gosht ni tarkari	\N	1.00	t	2025-12-27 03:04:43.719864+00	2025-12-27 03:04:43.719864+00
105	green bean aloo curry	\N	1.00	t	2025-12-27 03:04:43.720531+00	2025-12-27 03:04:43.720531+00
106	green chicken (caju ni murghi)	\N	1.00	t	2025-12-27 03:04:43.721091+00	2025-12-27 03:04:43.721091+00
107	green gosht (caju ni gosht)	\N	1.00	t	2025-12-27 03:04:43.72165+00	2025-12-27 03:04:43.72165+00
108	guvar aloo	\N	1.00	t	2025-12-27 03:04:43.722257+00	2025-12-27 03:04:43.722257+00
109	haleem	\N	1.00	t	2025-12-27 03:04:43.722866+00	2025-12-27 03:04:43.722866+00
110	haleem - garnish	\N	1.00	t	2025-12-27 03:04:43.723475+00	2025-12-27 03:04:43.723475+00
111	handi chicken	\N	1.00	t	2025-12-27 03:04:43.724054+00	2025-12-27 03:04:43.724054+00
112	ice cream	\N	1.00	t	2025-12-27 03:04:43.72462+00	2025-12-27 03:04:43.72462+00
113	kaleji ni tarkari	\N	1.00	t	2025-12-27 03:04:43.725182+00	2025-12-27 03:04:43.725182+00
114	karahi chicken	\N	1.00	t	2025-12-27 03:04:43.72577+00	2025-12-27 03:04:43.72577+00
115	kebabs, frozen (ready-made)	\N	1.00	t	2025-12-27 03:04:43.726378+00	2025-12-27 03:04:43.726378+00
116	khajoor	\N	1.00	t	2025-12-27 03:04:43.726951+00	2025-12-27 03:04:43.726951+00
117	kheema aloo matar	\N	1.00	t	2025-12-27 03:04:43.727524+00	2025-12-27 03:04:43.727524+00
118	kheema bhaji	\N	1.00	t	2025-12-27 03:04:43.7281+00	2025-12-27 03:04:43.7281+00
119	kheema biryani	\N	1.00	t	2025-12-27 03:04:43.728676+00	2025-12-27 03:04:43.728676+00
120	kheema khichdhi	\N	1.00	t	2025-12-27 03:04:43.729231+00	2025-12-27 03:04:43.729231+00
121	kheema patvelia	\N	1.00	t	2025-12-27 03:04:43.72978+00	2025-12-27 03:04:43.72978+00
122	kheema pau	\N	1.00	t	2025-12-27 03:04:43.730343+00	2025-12-27 03:04:43.730343+00
123	khichdi	\N	1.00	t	2025-12-27 03:04:43.730896+00	2025-12-27 03:04:43.730896+00
124	kofta curry	\N	1.00	t	2025-12-27 03:04:43.731512+00	2025-12-27 03:04:43.731512+00
125	kushari	\N	1.00	t	2025-12-27 03:04:43.732071+00	2025-12-27 03:04:43.732071+00
126	lagan ni seekh	\N	1.00	t	2025-12-27 03:04:43.732666+00	2025-12-27 03:04:43.732666+00
127	lasagne with meat sauce	\N	1.00	t	2025-12-27 03:04:43.733304+00	2025-12-27 03:04:43.733304+00
128	lemon olive chicken tagine	\N	1.00	t	2025-12-27 03:04:43.733891+00	2025-12-27 03:04:43.733891+00
129	malvi gosht	\N	1.00	t	2025-12-27 03:04:43.734694+00	2025-12-27 03:04:43.734694+00
130	masoor daal	\N	1.00	t	2025-12-27 03:04:43.735482+00	2025-12-27 03:04:43.735482+00
131	masoor daal w/gosht	\N	1.00	t	2025-12-27 03:04:43.736263+00	2025-12-27 03:04:43.736263+00
132	masoor pulao	\N	1.00	t	2025-12-27 03:04:43.737004+00	2025-12-27 03:04:43.737004+00
133	matar paneer	\N	1.00	t	2025-12-27 03:04:43.737677+00	2025-12-27 03:04:43.737677+00
134	mattho	\N	1.00	t	2025-12-27 03:04:43.738383+00	2025-12-27 03:04:43.738383+00
135	mezze - hummus	\N	1.00	t	2025-12-27 03:04:43.739083+00	2025-12-27 03:04:43.739083+00
136	mezze - pita bread	\N	1.00	t	2025-12-27 03:04:43.739658+00	2025-12-27 03:04:43.739658+00
137	mezze - stuffed grape leaves	\N	1.00	t	2025-12-27 03:04:43.740254+00	2025-12-27 03:04:43.740254+00
138	mezze - tapenade	\N	1.00	t	2025-12-27 03:04:43.740803+00	2025-12-27 03:04:43.740803+00
139	mezze - tzaziki	\N	1.00	t	2025-12-27 03:04:43.741378+00	2025-12-27 03:04:43.741378+00
140	mithaas - caju pak	\N	1.00	t	2025-12-27 03:04:43.741923+00	2025-12-27 03:04:43.741923+00
141	mithaas - fruit custard	\N	1.00	t	2025-12-27 03:04:43.742467+00	2025-12-27 03:04:43.742467+00
142	mithaas - gajar nu halwo	\N	1.00	t	2025-12-27 03:04:43.742988+00	2025-12-27 03:04:43.742988+00
143	mithaas - gulab jamun	\N	1.00	t	2025-12-27 03:04:43.743543+00	2025-12-27 03:04:43.743543+00
144	mithaas - ice cream	\N	1.00	t	2025-12-27 03:04:43.744128+00	2025-12-27 03:04:43.744128+00
145	mithaas - sev zarda	\N	1.00	t	2025-12-27 03:04:43.744681+00	2025-12-27 03:04:43.744681+00
146	mithaas - sooji halwa	\N	1.00	t	2025-12-27 03:04:43.745212+00	2025-12-27 03:04:43.745212+00
147	mithaas - tuxedo cake	\N	1.00	t	2025-12-27 03:04:43.74575+00	2025-12-27 03:04:43.74575+00
148	mixed daal	\N	1.00	t	2025-12-27 03:04:43.746492+00	2025-12-27 03:04:43.746492+00
149	mixed daal gosht	\N	1.00	t	2025-12-27 03:04:43.747227+00	2025-12-27 03:04:43.747227+00
150	mixed vegetable tarkari	\N	1.00	t	2025-12-27 03:04:43.747806+00	2025-12-27 03:04:43.747806+00
151	moong pulao	\N	1.00	t	2025-12-27 03:04:43.748355+00	2025-12-27 03:04:43.748355+00
152	mutton khurdhi	\N	1.00	t	2025-12-27 03:04:43.7489+00	2025-12-27 03:04:43.7489+00
153	mutton paya	\N	1.00	t	2025-12-27 03:04:43.749475+00	2025-12-27 03:04:43.749475+00
154	navratan korma	\N	1.00	t	2025-12-27 03:04:43.750075+00	2025-12-27 03:04:43.750075+00
155	nihari	\N	1.00	t	2025-12-27 03:04:43.750699+00	2025-12-27 03:04:43.750699+00
156	nut packet	\N	1.00	t	2025-12-27 03:04:43.751324+00	2025-12-27 03:04:43.751324+00
157	olives, green	\N	1.00	t	2025-12-27 03:04:43.751887+00	2025-12-27 03:04:43.751887+00
158	orange masoor daal	\N	1.00	t	2025-12-27 03:04:43.752504+00	2025-12-27 03:04:43.752504+00
159	paav bhaji	\N	1.00	t	2025-12-27 03:04:43.753078+00	2025-12-27 03:04:43.753078+00
160	paav bhaji - buns	\N	1.00	t	2025-12-27 03:04:43.753609+00	2025-12-27 03:04:43.753609+00
161	pakorda	\N	1.00	t	2025-12-27 03:04:43.754169+00	2025-12-27 03:04:43.754169+00
162	palak paneer	\N	1.00	t	2025-12-27 03:04:43.754704+00	2025-12-27 03:04:43.754704+00
163	palida	\N	1.00	t	2025-12-27 03:04:43.755232+00	2025-12-27 03:04:43.755232+00
164	panang curry (chicken)	\N	1.00	t	2025-12-27 03:04:43.755754+00	2025-12-27 03:04:43.755754+00
165	paneer jalfrezi	\N	1.00	t	2025-12-27 03:04:43.756313+00	2025-12-27 03:04:43.756313+00
166	paneer karahi	\N	1.00	t	2025-12-27 03:04:43.756828+00	2025-12-27 03:04:43.756828+00
167	paneer makhani	\N	1.00	t	2025-12-27 03:04:43.757327+00	2025-12-27 03:04:43.757327+00
168	paneer tikka masala	\N	1.00	t	2025-12-27 03:04:43.757868+00	2025-12-27 03:04:43.757868+00
169	pesto ravioli	\N	1.00	t	2025-12-27 03:04:43.758486+00	2025-12-27 03:04:43.758486+00
170	pollo guisado	\N	1.00	t	2025-12-27 03:04:43.759066+00	2025-12-27 03:04:43.759066+00
171	punjabi baingan ka bharta	\N	1.00	t	2025-12-27 03:04:43.759594+00	2025-12-27 03:04:43.759594+00
172	raita	\N	1.00	t	2025-12-27 03:04:43.760155+00	2025-12-27 03:04:43.760155+00
173	ravioli Florentine	\N	1.00	t	2025-12-27 03:04:43.7607+00	2025-12-27 03:04:43.7607+00
174	salad - English cumbers	\N	1.00	t	2025-12-27 03:04:43.761256+00	2025-12-27 03:04:43.761256+00
175	salad - Romaine lettuce	\N	1.00	t	2025-12-27 03:04:43.761784+00	2025-12-27 03:04:43.761784+00
176	salad - bell peppers	\N	1.00	t	2025-12-27 03:04:43.762344+00	2025-12-27 03:04:43.762344+00
177	salad - carrots	\N	1.00	t	2025-12-27 03:04:43.762875+00	2025-12-27 03:04:43.762875+00
178	salad - mixed greens lettuce	\N	1.00	t	2025-12-27 03:04:43.763494+00	2025-12-27 03:04:43.763494+00
179	shahi tukda	\N	1.00	t	2025-12-27 03:04:43.764062+00	2025-12-27 03:04:43.764062+00
180	sheer khurma	\N	1.00	t	2025-12-27 03:04:43.764592+00	2025-12-27 03:04:43.764592+00
181	sloppy joes	\N	1.00	t	2025-12-27 03:04:43.765122+00	2025-12-27 03:04:43.765122+00
182	sooji halwa	\N	1.00	t	2025-12-27 03:04:43.765664+00	2025-12-27 03:04:43.765664+00
183	sweet and sour chicken over rice	\N	1.00	t	2025-12-27 03:04:43.766186+00	2025-12-27 03:04:43.766186+00
184	tahini sauce	\N	1.00	t	2025-12-27 03:04:43.76672+00	2025-12-27 03:04:43.76672+00
185	tandoori chicken legs	\N	1.00	t	2025-12-27 03:04:43.767255+00	2025-12-27 03:04:43.767255+00
186	tindoora fry	\N	1.00	t	2025-12-27 03:04:43.767779+00	2025-12-27 03:04:43.767779+00
187	tomato soup	\N	1.00	t	2025-12-27 03:04:43.768366+00	2025-12-27 03:04:43.768366+00
188	vegetable biryani	\N	1.00	t	2025-12-27 03:04:43.768948+00	2025-12-27 03:04:43.768948+00
189	vegetable hakka noodles	\N	1.00	t	2025-12-27 03:04:43.769557+00	2025-12-27 03:04:43.769557+00
190	vegetable korma	\N	1.00	t	2025-12-27 03:04:43.770134+00	2025-12-27 03:04:43.770134+00
191	vegetable lasagne	\N	1.00	t	2025-12-27 03:04:43.770712+00	2025-12-27 03:04:43.770712+00
192	white rice	\N	1.00	t	2025-12-27 03:04:43.771349+00	2025-12-27 03:04:43.771349+00
193	whole chicken in white sauce	\N	1.00	t	2025-12-27 03:04:43.771933+00	2025-12-27 03:04:43.771933+00
194	whole chicken keit (red sauce)	\N	1.00	t	2025-12-27 03:04:43.772519+00	2025-12-27 03:04:43.772519+00
\.


--
-- Data for Name: event_chefs; Type: TABLE DATA; Schema: public; Owner: rsvp
--

COPY public.event_chefs (event_id, chef_id, role) FROM stdin;
2	6	\N
\.


--
-- Data for Name: event_person_chefs; Type: TABLE DATA; Schema: public; Owner: rsvp
--

COPY public.event_person_chefs (event_id, person_id) FROM stdin;
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: rsvp
--

COPY public.events (id, event_type, title, description, event_date, start_time, registration_open_at, registration_close_at, status, miqaat_name, created_at, updated_at) FROM stdin;
2	THAALI	Saturday Thaali - Rajab 15, 1447H	Saturday - Rajab 15, 1447H	2026-01-03	14:30:00	2025-12-26 00:00:00+00	2025-12-28 23:59:59+00	PUBLISHED	\N	2025-12-27 03:48:28.515511+00	2025-12-27 05:21:20.936148+00
3	NIYAZ	Milad Moulana Ali SA	Milad Moulana Ali SA on Wed, 12/31\n\nTime:\n6:10 PM- Muminaat Tasbeeh\n6:30 PM- Milad Majlis and Haflat program.\n7:45 PM- Niyaaz Jaman\n\nOn behalf of Aqa Moula TUS, all mumineen are invited to attend. Please RSVP !!	2025-12-31	18:10:00	2025-12-27 00:00:00+00	2025-12-30 23:59:59+00	PUBLISHED	Milad Moulana Ali SA	2025-12-27 13:37:04.426904+00	2025-12-27 13:38:12.227716+00
\.


--
-- Data for Name: flyway_schema_history; Type: TABLE DATA; Schema: public; Owner: rsvp
--

COPY public.flyway_schema_history (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
1	1	rsvp domain	SQL	V1__rsvp_domain.sql	91008059	rsvp	2025-12-27 02:55:29.208132	56	t
2	2	chefs and dish catalog	SQL	V2__chefs_and_dish_catalog.sql	1434094856	rsvp	2025-12-27 02:55:29.300253	40	t
3	3	auth session and reset	SQL	V3__auth_session_and_reset.sql	-1362874939	rsvp	2025-12-27 02:55:29.360219	11	t
4	4	menu items position integer	SQL	V4__menu_items_position_integer.sql	-1232099658	rsvp	2025-12-27 02:55:29.380037	12	t
5	5	pickup zones table	SQL	V5__pickup_zones_table.sql	1631318156	rsvp	2025-12-27 02:55:29.401771	10	t
6	6	thaali pickup zone fk	SQL	V6__thaali_pickup_zone_fk.sql	1044357285	rsvp	2025-12-27 02:55:29.420527	19	t
7	7	thaali order items and niyaz hosts	SQL	V7__thaali_order_items_and_niyaz_hosts.sql	-16214484	rsvp	2025-12-27 02:55:29.451227	25	t
8	8	drop niyaz miqaat date time	SQL	V8__drop_niyaz_miqaat_date_time.sql	-1889498924	rsvp	2025-12-27 02:55:29.486343	2	t
9	9	ingredient metadata	SQL	V9__ingredient_metadata.sql	596446472	rsvp	2025-12-27 02:55:29.497439	9	t
10	10	roles table	SQL	V10__roles_table.sql	-1771729154	rsvp	2025-12-27 02:55:29.513638	11	t
11	11	coordinator roles	SQL	V11__coordinator_roles.sql	1019147671	rsvp	2025-12-27 02:55:29.53212	2	t
12	12	remove role check constraint	SQL	V12__remove_role_check_constraint.sql	1329647187	rsvp	2025-12-27 02:55:29.542315	4	t
13	13	menu items name nullable	SQL	V13__menu_items_name_nullable.sql	1367648523	rsvp	2025-12-27 03:36:08.690047	11	t
\.


--
-- Data for Name: ingredients; Type: TABLE DATA; Schema: public; Owner: rsvp
--

COPY public.ingredients (id, name, unit, notes, created_at, updated_at, category, default_store, storage_location) FROM stdin;
1	BBQ sauce, Sweet Baby Ray's brand	lb	\N	2025-12-27 03:04:43.487792+00	2025-12-27 03:04:43.487792+00	non-perishable	Costco	refrigerator rack, bottom shelf
2	Better than Boullion roasted vegetable	jar	\N	2025-12-27 03:04:43.489692+00	2025-12-27 03:04:43.489692+00	pantry	Costco	refrigerator rack, middle upper shelf
3	Frankly Fresh stuffed grape leaves	box	\N	2025-12-27 03:04:43.490541+00	2025-12-27 03:04:43.490541+00	perishable	Costco	refrigerator
4	French baguette	loaf	\N	2025-12-27 03:04:43.491406+00	2025-12-27 03:04:43.491406+00	bread	Grocery	dishwasher rack, bottom shelf
5	French beans, whole fresh	lb	\N	2025-12-27 03:04:43.492122+00	2025-12-27 03:04:43.492122+00	produce	Costco	refrigerator
6	Impossible burger	lb	\N	2025-12-27 03:04:43.492892+00	2025-12-27 03:04:43.492892+00	meat	Grocery	refrigerator
7	King's Hawaiian sweet rolls	32 roll packet	\N	2025-12-27 03:04:43.493578+00	2025-12-27 03:04:43.493578+00	bread	Costco	refrigerator rack, bottom shelf
8	Kontos pita loaves	loaf	\N	2025-12-27 03:04:43.494326+00	2025-12-27 03:04:43.494326+00	other	\N	\N
9	Lahori charga masala, Shan brand	box	\N	2025-12-27 03:04:43.495088+00	2025-12-27 03:04:43.495088+00	non-perishable	Indian	spice rack
10	Mexican blend cheese, shredded	lb	\N	2025-12-27 03:04:43.495916+00	2025-12-27 03:04:43.495916+00	produce	Costco	refrigerator
11	Mexican chili powder	oz	\N	2025-12-27 03:04:43.496654+00	2025-12-27 03:04:43.496654+00	non-perishable	Grocery	refrigerator rack, bottom shelf
12	Punjabi Yakhni Pulao masala, Shan brand	box	\N	2025-12-27 03:04:43.497365+00	2025-12-27 03:04:43.497365+00	non-perishable	Indian	spice rack
13	Sindhi biryani masala, Shan brand	box	\N	2025-12-27 03:04:43.498021+00	2025-12-27 03:04:43.498021+00	non-perishable	Indian	spice rack
14	Sri racha chile sauce	lb	\N	2025-12-27 03:04:43.498665+00	2025-12-27 03:04:43.498665+00	pantry	Korean	refrigerator rack, bottom shelf
15	achaar gosht masala, Shan brand	box	\N	2025-12-27 03:04:43.499391+00	2025-12-27 03:04:43.499391+00	non-perishable	Indian	spice rack
16	almonds, sliced	lb	\N	2025-12-27 03:04:43.500093+00	2025-12-27 03:04:43.500093+00	non-perishable	Indian	spice rack
17	almonds, whole unsalted	lb	\N	2025-12-27 03:04:43.500713+00	2025-12-27 03:04:43.500713+00	non-perishable	Costco	mawaid
18	apples	pieces	\N	2025-12-27 03:04:43.501341+00	2025-12-27 03:04:43.501341+00	other	\N	mawaid table
19	banana	pieces	\N	2025-12-27 03:04:43.502014+00	2025-12-27 03:04:43.502014+00	other	\N	mawaid table
20	basil leaves, fresh	bunch	\N	2025-12-27 03:04:43.502622+00	2025-12-27 03:04:43.502622+00	produce	Korean	refrigerator
21	batura bread	packet	\N	2025-12-27 03:04:43.503245+00	2025-12-27 03:04:43.503245+00	bread	Indian	white freezer
22	bay leaves	100 gm	\N	2025-12-27 03:04:43.504015+00	2025-12-27 03:04:43.504015+00	pantry	Indian	spice rack
23	beef, boneless nihari cut 2" pieces	lb	\N	2025-12-27 03:04:43.504667+00	2025-12-27 03:04:43.504667+00	meat	Indus	refrigerator
24	beef, ground 85% lean (frozen)	lb	\N	2025-12-27 03:04:43.505324+00	2025-12-27 03:04:43.505324+00	meat	Costco	refrigerator
25	beef, ground 90% lean	lb	\N	2025-12-27 03:04:43.505986+00	2025-12-27 03:04:43.505986+00	meat	Indus	refrigerator
26	bell pepper, green	lb	\N	2025-12-27 03:04:43.506628+00	2025-12-27 03:04:43.506628+00	produce	Grocery	refrigerator
27	bell pepper, mixed colored	pieces	\N	2025-12-27 03:04:43.50729+00	2025-12-27 03:04:43.50729+00	produce	Costco	refrigerator
28	bell pepper, red	lb	\N	2025-12-27 03:04:43.50792+00	2025-12-27 03:04:43.50792+00	produce	Grocery	refrigerator
29	besan (gram flour)	lb	\N	2025-12-27 03:04:43.508622+00	2025-12-27 03:04:43.508622+00	pantry	Indian	spice rack
30	birista	lb	\N	2025-12-27 03:04:43.509303+00	2025-12-27 03:04:43.509303+00	pantry	Indian	refrigerator rack, bottom shelf
31	black beans, canned	lb	\N	2025-12-27 03:04:43.50995+00	2025-12-27 03:04:43.50995+00	non-perishable	Costco	refrigerator rack, bottom shelf
32	black beans, dry	lb	\N	2025-12-27 03:04:43.510634+00	2025-12-27 03:04:43.510634+00	non-perishable	Grocery	spice rack
33	black eyed peas (chawla)	lb	\N	2025-12-27 03:04:43.511379+00	2025-12-27 03:04:43.511379+00	non-perishable	Indian	refrigerator rack, bottom shelf
34	blueberries	pieces	\N	2025-12-27 03:04:43.512173+00	2025-12-27 03:04:43.512173+00	other	\N	mawaid table
35	blueberries, fresh	lb	\N	2025-12-27 03:04:43.512804+00	2025-12-27 03:04:43.512804+00	produce	Costco	refrigerator
36	bread crumb	lb	\N	2025-12-27 03:04:43.513442+00	2025-12-27 03:04:43.513442+00	pantry	Grocery	\N
37	bread, Afghani style	loaf	\N	2025-12-27 03:04:43.514126+00	2025-12-27 03:04:43.514126+00	bread	Indian	refrigerator
38	brocolli florets, fresh	lb	\N	2025-12-27 03:04:43.514764+00	2025-12-27 03:04:43.514764+00	produce	Costco	refrigerator
39	butter chicken masala, Shan brand	box	\N	2025-12-27 03:04:43.515437+00	2025-12-27 03:04:43.515437+00	non-perishable	Indian	spice rack
40	butter, unsalted	lb	\N	2025-12-27 03:04:43.516098+00	2025-12-27 03:04:43.516098+00	pantry	Costco	refrigerator
41	cabbage, Napa	lb	\N	2025-12-27 03:04:43.516732+00	2025-12-27 03:04:43.516732+00	produce	Grocery	refrigerator
42	cabbage, green	lb	\N	2025-12-27 03:04:43.517427+00	2025-12-27 03:04:43.517427+00	produce	Grocery	refrigerator
43	cabbage, red	lb	\N	2025-12-27 03:04:43.51813+00	2025-12-27 03:04:43.51813+00	produce	Grocery	refrigerator
44	caju pak	packet	\N	2025-12-27 03:04:43.518731+00	2025-12-27 03:04:43.518731+00	other	\N	white refrigerator
45	canola oil	96 oz bottle	\N	2025-12-27 03:04:43.519366+00	2025-12-27 03:04:43.519366+00	pantry	Costco	door rack, bottom shelf
46	capers	32 oz jar	\N	2025-12-27 03:04:43.519979+00	2025-12-27 03:04:43.519979+00	non-perishable	Costco	\N
47	cardamom, green	lb	\N	2025-12-27 03:04:43.520585+00	2025-12-27 03:04:43.520585+00	pantry	Indian	spice rack
48	carrots, fresh baby cut	lb	\N	2025-12-27 03:04:43.521208+00	2025-12-27 03:04:43.521208+00	produce	Costco	refrigerator
49	carrots, shredded	lb	\N	2025-12-27 03:04:43.521824+00	2025-12-27 03:04:43.521824+00	produce	Grocery	refrigerator
50	carrots, whole fresh	lb	\N	2025-12-27 03:04:43.522517+00	2025-12-27 03:04:43.522517+00	produce	Grocery	refrigerator
51	cashews, roasted salted	lb	\N	2025-12-27 03:04:43.523114+00	2025-12-27 03:04:43.523114+00	non-perishable	Costco	spice rack
52	cauliflower, fresh	lb	\N	2025-12-27 03:04:43.523716+00	2025-12-27 03:04:43.523716+00	produce	Grocery	refrigerator
53	cauliflower, frozen riced	lb	\N	2025-12-27 03:04:43.524331+00	2025-12-27 03:04:43.524331+00	frozen	Costco	white freezer
54	celery, whole fresh	lb	\N	2025-12-27 03:04:43.524959+00	2025-12-27 03:04:43.524959+00	produce	Costco	refrigerator
55	chana daal	lb	\N	2025-12-27 03:04:43.525693+00	2025-12-27 03:04:43.525693+00	non-perishable	Indian	spice rack
56	chicken breast, boneless	lb	\N	2025-12-27 03:04:43.526437+00	2025-12-27 03:04:43.526437+00	meat	Indus	refrigerator
57	chicken legs, cut into 4 pieces	lb	\N	2025-12-27 03:04:43.527348+00	2025-12-27 03:04:43.527348+00	meat	Indus	refrigerator
58	chicken legs, whole skin off	lb	\N	2025-12-27 03:04:43.527968+00	2025-12-27 03:04:43.527968+00	meat	Indus	refrigerator
59	chicken legs, whole with skin	lb	\N	2025-12-27 03:04:43.528687+00	2025-12-27 03:04:43.528687+00	meat	Indus	refrigerator
60	chicken tenders, boneless breaded (halal)	lb	\N	2025-12-27 03:04:43.529579+00	2025-12-27 03:04:43.529579+00	meat	Restaurant Depot	white freezer
61	chicken thigh, boneless	lb	\N	2025-12-27 03:04:43.530313+00	2025-12-27 03:04:43.530313+00	meat	Indus	refrigerator
62	chicken thigh, boneless cut 1" pieces	lb	\N	2025-12-27 03:04:43.531095+00	2025-12-27 03:04:43.531095+00	meat	Indus	refrigerator
63	chicken thigh, ground	lb	\N	2025-12-27 03:04:43.531738+00	2025-12-27 03:04:43.531738+00	meat	Indus	refrigerator
64	chicken, whole baby skin off	bird	\N	2025-12-27 03:04:43.532494+00	2025-12-27 03:04:43.532494+00	meat	Indus	refrigerator
65	chili garlic sauce	lb	\N	2025-12-27 03:04:43.533201+00	2025-12-27 03:04:43.533201+00	refrigerator	Indian	refrigerator
66	chilies, green fresh	handful	\N	2025-12-27 03:04:43.533861+00	2025-12-27 03:04:43.533861+00	produce	Indian	refrigerator
67	chilies, long green fresh	pieces	\N	2025-12-27 03:04:43.53484+00	2025-12-27 03:04:43.53484+00	produce	Indian	refrigerator
68	chilies, red fresh (Thai)	handful	\N	2025-12-27 03:04:43.535554+00	2025-12-27 03:04:43.535554+00	produce	Korean	refrigerator
69	chipotle chilies in adobo, Goya brand canned	can	\N	2025-12-27 03:04:43.536208+00	2025-12-27 03:04:43.536208+00	non-perishable	Grocery	refrigerator rack, bottom shelf
70	chironji	gm	\N	2025-12-27 03:04:43.536815+00	2025-12-27 03:04:43.536815+00	non-perishable	Indian	spice rack
71	chola batura masala, Badshah brand	box	\N	2025-12-27 03:04:43.537519+00	2025-12-27 03:04:43.537519+00	non-perishable	Indian	spice rack
72	chowmein hakka noodle masala, Ching's Secret brand	oz	\N	2025-12-27 03:04:43.538188+00	2025-12-27 03:04:43.538188+00	pantry	Indian	spice rack
73	cilantro	bunch	\N	2025-12-27 03:04:43.538827+00	2025-12-27 03:04:43.538827+00	produce	Indian	refrigerator
74	cinnamon stick	gm	\N	2025-12-27 03:04:43.539478+00	2025-12-27 03:04:43.539478+00	pantry	Indian	spice rack
75	coconut milk	can	\N	2025-12-27 03:04:43.540124+00	2025-12-27 03:04:43.540124+00	non-perishable	Costco	dishwasher shelf
76	coconut, dried shredded	lb	\N	2025-12-27 03:04:43.540743+00	2025-12-27 03:04:43.540743+00	non-perishable	Indian	spice rack
77	collard greens	lb	\N	2025-12-27 03:04:43.5414+00	2025-12-27 03:04:43.5414+00	produce	Grocery	refrigerator
78	coriander powder	lb	\N	2025-12-27 03:04:43.542112+00	2025-12-27 03:04:43.542112+00	pantry	Indian	spice rack
79	corn starch	lb	\N	2025-12-27 03:04:43.542729+00	2025-12-27 03:04:43.542729+00	pantry	Grocery	refrigerator rack, middle upper shelf
80	corn tortilla	count	\N	2025-12-27 03:04:43.543371+00	2025-12-27 03:04:43.543371+00	shelf	Grocery	shelf
81	corn, frozen kernels	lb	\N	2025-12-27 03:04:43.543963+00	2025-12-27 03:04:43.543963+00	frozen	Costco	white freezer
82	cottage cheese, 2% fat	lb	\N	2025-12-27 03:04:43.544665+00	2025-12-27 03:04:43.544665+00	produce	Costco	refrigerator
83	cream of celery condensed soup	can	\N	2025-12-27 03:04:43.545275+00	2025-12-27 03:04:43.545275+00	non-perishable	Grocery	refrigerator rack, bottom shelf
84	creamed corn, canned	can	\N	2025-12-27 03:04:43.545914+00	2025-12-27 03:04:43.545914+00	non-perishable	Grocery	refrigerator rack, bottom shelf
85	crunchy peanut butter, JIF brand	lb	\N	2025-12-27 03:04:43.5467+00	2025-12-27 03:04:43.5467+00	non-perishable	Costco	refrigerator rack, bottom shelf
86	cucumber, English	3-pack	\N	2025-12-27 03:04:43.547339+00	2025-12-27 03:04:43.547339+00	produce	Costco	refrigerator
87	cumin powder	lb	\N	2025-12-27 03:04:43.547997+00	2025-12-27 03:04:43.547997+00	pantry	Indian	spice rack
88	cumin seeds, whole	lb	\N	2025-12-27 03:04:43.5487+00	2025-12-27 03:04:43.5487+00	pantry	Indian	spice rack
89	curry leaves, fresh	bunch	\N	2025-12-27 03:04:43.549396+00	2025-12-27 03:04:43.549396+00	produce	Indian	refrigerator
90	dates, medjool pitted	lb	\N	2025-12-27 03:04:43.550069+00	2025-12-27 03:04:43.550069+00	non-perishable	Costco	refrigerator rack, bottom shelf
91	doodhi	lb	\N	2025-12-27 03:04:43.550684+00	2025-12-27 03:04:43.550684+00	produce	Indian	refrigerator
92	dried apricots	lb	\N	2025-12-27 03:04:43.551392+00	2025-12-27 03:04:43.551392+00	non-perishable	Costco	\N
93	drumsticks	lb	\N	2025-12-27 03:04:43.552111+00	2025-12-27 03:04:43.552111+00	frozen	Indian	white freezer
94	egg noodles, wide	lb	\N	2025-12-27 03:04:43.552724+00	2025-12-27 03:04:43.552724+00	non-perishable	Grocery	refrigerator rack, bottom shelf
95	eggplant, Chinese	lb	\N	2025-12-27 03:04:43.553355+00	2025-12-27 03:04:43.553355+00	produce	Grocery	refrigerator
96	eggplant, Indian	lb	\N	2025-12-27 03:04:43.553981+00	2025-12-27 03:04:43.553981+00	produce	Indian	refrigerator
97	eggplant, regular	lb	\N	2025-12-27 03:04:43.554595+00	2025-12-27 03:04:43.554595+00	produce	Grocery	refrigerator
98	eggs	dozen	\N	2025-12-27 03:04:43.555212+00	2025-12-27 03:04:43.555212+00	produce	Costco	refrigerator
99	elbow pasta	lb	\N	2025-12-27 03:04:43.555868+00	2025-12-27 03:04:43.555868+00	non-perishable	Grocery	dishwasher shelf
100	fenugreek (methi) seeds	lb	\N	2025-12-27 03:04:43.556609+00	2025-12-27 03:04:43.556609+00	pantry	Indian	spice rack
101	flour tortilla, Mission brand	36 cnt packet	\N	2025-12-27 03:04:43.557307+00	2025-12-27 03:04:43.557307+00	bread	Costco	dishwasher rack bottom shelf
102	flour, all-purpose unbleached	lb	\N	2025-12-27 03:04:43.557944+00	2025-12-27 03:04:43.557944+00	pantry	Grocery	spice rack
103	flour, chapatti atta	lb	\N	2025-12-27 03:04:43.558586+00	2025-12-27 03:04:43.558586+00	non-perishable	Indian	refrigerator rack, bottom shelf
104	fruit custard	packet	\N	2025-12-27 03:04:43.559204+00	2025-12-27 03:04:43.559204+00	other	\N	white refrigerator
105	galangal, fresh	lb	\N	2025-12-27 03:04:43.55981+00	2025-12-27 03:04:43.55981+00	produce	Korean	refrigerator
106	garam masala powder	lb	\N	2025-12-27 03:04:43.560535+00	2025-12-27 03:04:43.560535+00	pantry	Indian	spice rack
107	garbanzo beans, canned	lb	\N	2025-12-27 03:04:43.561181+00	2025-12-27 03:04:43.561181+00	non-perishable	Costco	prep table, bottom shelf
108	garlic paste	bottle	\N	2025-12-27 03:04:43.561815+00	2025-12-27 03:04:43.561815+00	pantry	Indian	stove prep table middle shelf
109	garlic, whole peeled	lb	\N	2025-12-27 03:04:43.562508+00	2025-12-27 03:04:43.562508+00	produce	Indian	refrigerator
110	ghee	lb	\N	2025-12-27 03:04:43.563151+00	2025-12-27 03:04:43.563151+00	non-perishable	Indian	refrigerator rack, middle shelf
111	ginger paste	bottle	\N	2025-12-27 03:04:43.563782+00	2025-12-27 03:04:43.563782+00	pantry	Indian	stove prep table middle shelf
112	goat cubes	lb	\N	2025-12-27 03:04:43.564458+00	2025-12-27 03:04:43.564458+00	meat	Indus	refrigerator
113	goat paya	lb	\N	2025-12-27 03:04:43.565131+00	2025-12-27 03:04:43.565131+00	meat	Indus	refrigerator
114	green peas, frozen	lb	\N	2025-12-27 03:04:43.565754+00	2025-12-27 03:04:43.565754+00	frozen	Costco	white freezer
115	guacamole single serve mini-cup	20 cnt pack	\N	2025-12-27 03:04:43.566445+00	2025-12-27 03:04:43.566445+00	produce	Costco	refrigerator
116	gulab jamun, canned	can	\N	2025-12-27 03:04:43.567055+00	2025-12-27 03:04:43.567055+00	non-perishable	Indian	mawaid table
117	guvar, frozen	lb	\N	2025-12-27 03:04:43.567702+00	2025-12-27 03:04:43.567702+00	frozen	Indian	white freezer
118	hakka noodles, Ching's Secret	lb	\N	2025-12-27 03:04:43.568378+00	2025-12-27 03:04:43.568378+00	non-perishable	Indian	door rack, bottom shelf
119	haleem masala, Shan brand	box	\N	2025-12-27 03:04:43.569045+00	2025-12-27 03:04:43.569045+00	non-perishable	Indian	spice rack
120	haleem wheat, Sadaf brand	lb	\N	2025-12-27 03:04:43.569651+00	2025-12-27 03:04:43.569651+00	non-perishable	Indian	spice rack
121	half and half	quart	\N	2025-12-27 03:04:43.570247+00	2025-12-27 03:04:43.570247+00	produce	Costco	refrigerator
122	hamburger bun	bun	\N	2025-12-27 03:04:43.570844+00	2025-12-27 03:04:43.570844+00	bread	Costco	dishwasher rack, bottom shelf
123	heavy cream	quart	\N	2025-12-27 03:04:43.57156+00	2025-12-27 03:04:43.57156+00	produce	Costco	refrigerator
124	honey	lb	\N	2025-12-27 03:04:43.572214+00	2025-12-27 03:04:43.572214+00	pantry	Costco	refrigerator rack, middle upper shelf
125	hummus	lb	\N	2025-12-27 03:04:43.572883+00	2025-12-27 03:04:43.572883+00	produce	Costco	refrigerator
126	ice cream - any variey	48 oz	\N	2025-12-27 03:04:43.573607+00	2025-12-27 03:04:43.573607+00	other	\N	silver freezer
127	iodized salt	box	\N	2025-12-27 03:04:43.574207+00	2025-12-27 03:04:43.574207+00	pantry	Costco	spice rack
128	kaari masala	lb	\N	2025-12-27 03:04:43.57483+00	2025-12-27 03:04:43.57483+00	non-perishable	\N	white freezer
129	kafir lime leaves, whole	lb	\N	2025-12-27 03:04:43.57554+00	2025-12-27 03:04:43.57554+00	produce	Korean	refrigerator
130	kashmiri red chili powder	lb	\N	2025-12-27 03:04:43.576126+00	2025-12-27 03:04:43.576126+00	pantry	Indian	spice rack
131	kasuri methi leaves	lb	\N	2025-12-27 03:04:43.576742+00	2025-12-27 03:04:43.576742+00	pantry	Indian	spice rack
132	kebabs, frozen (ready-made)	box	\N	2025-12-27 03:04:43.577439+00	2025-12-27 03:04:43.577439+00	frozen	Indus	silver freezer
133	ketchup	lb	\N	2025-12-27 03:04:43.578067+00	2025-12-27 03:04:43.578067+00	pantry	Costco	refrigerator rack, bottom shelf
134	kewra essence	bottle	\N	2025-12-27 03:04:43.578646+00	2025-12-27 03:04:43.578646+00	pantry	Indian	stove prep table bottom shelf
135	kharak	lb	\N	2025-12-27 03:04:43.57923+00	2025-12-27 03:04:43.57923+00	non-perishable	Indian	mawaid
136	kheer	lb	\N	2025-12-27 03:04:43.579791+00	2025-12-27 03:04:43.579791+00	other	\N	\N
137	kidney beans, light dry	lb	\N	2025-12-27 03:04:43.58039+00	2025-12-27 03:04:43.58039+00	non-perishable	Grocery	spice rack
138	kielbasa sausage	lb	\N	2025-12-27 03:04:43.581037+00	2025-12-27 03:04:43.581037+00	meat	Indus	silver freezer
139	kiwi	pieces	\N	2025-12-27 03:04:43.58169+00	2025-12-27 03:04:43.58169+00	other	\N	mawaid table
140	kokum	lb	\N	2025-12-27 03:04:43.582324+00	2025-12-27 03:04:43.582324+00	produce	Indian	refrigerator
141	korma masala, Shan brand	box	\N	2025-12-27 03:04:43.582915+00	2025-12-27 03:04:43.582915+00	non-perishable	Indian	spice rack
142	kulfi - kesar/kesar pista/other similar	unit	\N	2025-12-27 03:04:43.583536+00	2025-12-27 03:04:43.583536+00	other	\N	silver freezer
143	kulfi - mango	unit	\N	2025-12-27 03:04:43.584129+00	2025-12-27 03:04:43.584129+00	other	\N	silver freezer
144	lasagne noodles	lb	\N	2025-12-27 03:04:43.584704+00	2025-12-27 03:04:43.584704+00	non-perishable	Grocery	dishwasher shelf
145	lasagne noodles, no-boil variety	lb	\N	2025-12-27 03:04:43.58537+00	2025-12-27 03:04:43.58537+00	non-perishable	Grocery	refrigerator rack, bottom shelf
146	lavash wrap, Damascus Bakeries brand	packet	\N	2025-12-27 03:04:43.585992+00	2025-12-27 03:04:43.585992+00	bread	Costco	dishwasher rack, bottom shelf
147	lemon juice	bottle	\N	2025-12-27 03:04:43.586587+00	2025-12-27 03:04:43.586587+00	pantry	Costco	refrigerator rack, middle shelf
148	lemongrass, whole stalk	stalk	\N	2025-12-27 03:04:43.587181+00	2025-12-27 03:04:43.587181+00	produce	Korean	dishwasher rack, bottom shelf
149	lemons, whole fresh	lb	\N	2025-12-27 03:04:43.587778+00	2025-12-27 03:04:43.587778+00	produce	Costco	refrigerator
150	lettuce, Romaine whole head	6-pack	\N	2025-12-27 03:04:43.588498+00	2025-12-27 03:04:43.588498+00	produce	Costco	refrigerator
151	lettuce, Spring Mix (mixed greens)	box	\N	2025-12-27 03:04:43.589152+00	2025-12-27 03:04:43.589152+00	refrigerator	Costco	refrigerator
152	lime juice	bottle	\N	2025-12-27 03:04:43.589743+00	2025-12-27 03:04:43.589743+00	non-perishable	Grocery	refrigerator rack, bottom shelf
153	limes, fresh	count	\N	2025-12-27 03:04:43.590351+00	2025-12-27 03:04:43.590351+00	shelf	Costco	refrigerator
154	liver, goat	lb	\N	2025-12-27 03:04:43.590942+00	2025-12-27 03:04:43.590942+00	meat	Indus	silver freezer
155	macaroni elbow pasta	lb	\N	2025-12-27 03:04:43.591559+00	2025-12-27 03:04:43.591559+00	non-perishable	Grocery	refrigerator rack, bottom shelf
156	masoor daal, brown (whole)	lb	\N	2025-12-27 03:04:43.59221+00	2025-12-27 03:04:43.59221+00	non-perishable	Indian	spice rack
157	masoor daal, red	lb	\N	2025-12-27 03:04:43.592812+00	2025-12-27 03:04:43.592812+00	non-perishable	Indian	spice rack
158	mayonaise	lb	\N	2025-12-27 03:04:43.59349+00	2025-12-27 03:04:43.59349+00	refrigerator	Grocery	refrigerator rack, bottom shelf
159	methi bhaji leaves, frozen	lb	\N	2025-12-27 03:04:43.594134+00	2025-12-27 03:04:43.594134+00	frozen	Indian	freezer
160	milk, 1% fat	gallon	\N	2025-12-27 03:04:43.594721+00	2025-12-27 03:04:43.594721+00	produce	Costco	refrigerator
161	milk, evaporated canned	can	\N	2025-12-27 03:04:43.595307+00	2025-12-27 03:04:43.595307+00	non-perishable	Costco	mawaid table
162	milk, sweetened condensed canned	can	\N	2025-12-27 03:04:43.595906+00	2025-12-27 03:04:43.595906+00	non-perishable	Costco	mawaid table
163	milk, whole fat	gallon	\N	2025-12-27 03:04:43.596549+00	2025-12-27 03:04:43.596549+00	produce	Costco	refrigerator
164	mint leaves, fresh	bunch	\N	2025-12-27 03:04:43.597207+00	2025-12-27 03:04:43.597207+00	produce	Indian	refrigerator
165	mixed vegetables, frozen	lb	\N	2025-12-27 03:04:43.597789+00	2025-12-27 03:04:43.597789+00	frozen	Costco	white freezer
166	moong daal halwa	packet	\N	2025-12-27 03:04:43.598389+00	2025-12-27 03:04:43.598389+00	other	\N	white refrigerator
167	moong daal, whole (green)	lb	\N	2025-12-27 03:04:43.599015+00	2025-12-27 03:04:43.599015+00	non-perishable	Indian	spice rack
168	moong daal, yellow (split)	lb	\N	2025-12-27 03:04:43.599678+00	2025-12-27 03:04:43.599678+00	non-perishable	Indian	spice rack
169	mozzarella cheese, shredded	lb	\N	2025-12-27 03:04:43.600351+00	2025-12-27 03:04:43.600351+00	produce	Costco	refrigerator
170	mushroom soup, canned condensed	lb	\N	2025-12-27 03:04:43.601083+00	2025-12-27 03:04:43.601083+00	non-perishable	Grocery	dishwasher shelf
171	mushrooms, white fresh	lb	\N	2025-12-27 03:04:43.601745+00	2025-12-27 03:04:43.601745+00	produce	Costco	refrigerator
172	mustard, yellow spicy	lb	\N	2025-12-27 03:04:43.602327+00	2025-12-27 03:04:43.602327+00	non-perishable	Grocery	spice rack
173	naan, tandoori style (frozen)	packet	\N	2025-12-27 03:04:43.602921+00	2025-12-27 03:04:43.602921+00	frozen	Indian	white freezer
174	okra, frozen cut	lb	\N	2025-12-27 03:04:43.603508+00	2025-12-27 03:04:43.603508+00	frozen	Indian	white freezer
175	olive oil, extra virgin	bottle	\N	2025-12-27 03:04:43.60415+00	2025-12-27 03:04:43.60415+00	shelf	Costco	shelf
176	olives, black sliced	can	\N	2025-12-27 03:04:43.604748+00	2025-12-27 03:04:43.604748+00	non-perishable	Costco	refrigerator rack, bottom shelf
177	olives, green pimento stuffed	lb	\N	2025-12-27 03:04:43.605396+00	2025-12-27 03:04:43.605396+00	non-perishable	Costco	refrigerator rack, bottom shelf
178	onions, red	lb	\N	2025-12-27 03:04:43.605994+00	2025-12-27 03:04:43.605994+00	produce	Grocery	door rack, lower middle shelf
179	onions, yellow	lb	\N	2025-12-27 03:04:43.606603+00	2025-12-27 03:04:43.606603+00	produce	Costco	door rack, lower middle shelf
180	orange	pieces	\N	2025-12-27 03:04:43.60722+00	2025-12-27 03:04:43.60722+00	other	\N	mawaid table
181	oregano leaves, dried McCormick brand	bottles	\N	2025-12-27 03:04:43.607811+00	2025-12-27 03:04:43.607811+00	pantry	Costco	refrigerator rack, middle upper shelf
182	paneer	lb	\N	2025-12-27 03:04:43.608444+00	2025-12-27 03:04:43.608444+00	produce	Indian	refrigerator
183	paratha, frozen	packet	\N	2025-12-27 03:04:43.609008+00	2025-12-27 03:04:43.609008+00	frozen	Indian	white freezer
184	parmesan cheese, grated	lb	\N	2025-12-27 03:04:43.609599+00	2025-12-27 03:04:43.609599+00	produce	Costco	refrigerator
185	parsley, fresh	bunch	\N	2025-12-27 03:04:43.610203+00	2025-12-27 03:04:43.610203+00	produce	Grocery	refrigerator
186	pasta sauce, Ragu brand	quart	\N	2025-12-27 03:04:43.610795+00	2025-12-27 03:04:43.610795+00	non-perishable	Costco	dishwasher shelf
187	patvelia, frozen	lb	\N	2025-12-27 03:04:43.611461+00	2025-12-27 03:04:43.611461+00	frozen	Indian	white freezer
188	peach	pieces	\N	2025-12-27 03:04:43.61211+00	2025-12-27 03:04:43.61211+00	other	\N	mawaid table
189	peanuts, salted roasted	lb	\N	2025-12-27 03:04:43.612726+00	2025-12-27 03:04:43.612726+00	non-perishable	Costco	spice rack
190	pear	pieces	\N	2025-12-27 03:04:43.613353+00	2025-12-27 03:04:43.613353+00	other	\N	mawaid table
191	peas and carrots, frozen diced	lb	\N	2025-12-27 03:04:43.613929+00	2025-12-27 03:04:43.613929+00	frozen	Grocery	white freezer
192	penne pasta	lb	\N	2025-12-27 03:04:43.614575+00	2025-12-27 03:04:43.614575+00	non-perishable	Costco	dishwasher shelf
193	persimmons, pomegranates, or other uncut fruit	pieces	\N	2025-12-27 03:04:43.615341+00	2025-12-27 03:04:43.615341+00	other	\N	mawaid table
194	pesto, Kirkland Signature	bottle	\N	2025-12-27 03:04:43.616209+00	2025-12-27 03:04:43.616209+00	perishable	Costco	refrigerator
195	pineapple chunks, canned	lb	\N	2025-12-27 03:04:43.616888+00	2025-12-27 03:04:43.616888+00	non-perishable	Grocery	refrigerator rack, bottom shelf
196	pinto beans, dry	lb	\N	2025-12-27 03:04:43.617652+00	2025-12-27 03:04:43.617652+00	non-perishable	Grocery	spice rack
197	pistachios, whole shelled	lb	\N	2025-12-27 03:04:43.618268+00	2025-12-27 03:04:43.618268+00	non-perishable	Indian	spice rack
198	plum	pieces	\N	2025-12-27 03:04:43.61886+00	2025-12-27 03:04:43.61886+00	other	\N	mawaid table
199	potato bread, Martin's brand	loaf	\N	2025-12-27 03:04:43.619515+00	2025-12-27 03:04:43.619515+00	bread	Costco	dishwasher rack, bottom shelf
200	potatoes, baby size	lb	\N	2025-12-27 03:04:43.620124+00	2025-12-27 03:04:43.620124+00	produce	Costco	dishwasher rack, bottom shelf
201	potatoes, red or yellow	lb	\N	2025-12-27 03:04:43.620722+00	2025-12-27 03:04:43.620722+00	produce	Costco	door rack, 2nd shelf
202	pound cake	loaf	\N	2025-12-27 03:04:43.621312+00	2025-12-27 03:04:43.621312+00	bread	Costco	refrigerator
203	raisins, golden	lb	\N	2025-12-27 03:04:43.621905+00	2025-12-27 03:04:43.621905+00	non-perishable	Indian	mawaid
204	ravioli, spinach and mozzarella (Pasta Prima brand)	lb	\N	2025-12-27 03:04:43.622627+00	2025-12-27 03:04:43.622627+00	frozen	Costco	silver freezer
205	red chilies, whole dried	lb	\N	2025-12-27 03:04:43.623184+00	2025-12-27 03:04:43.623184+00	pantry	Indian	spice rack
206	rice, basmati	lb	\N	2025-12-27 03:04:43.623771+00	2025-12-27 03:04:43.623771+00	non-perishable	Costco	door rack, top shelf
207	rice, jasmine	lb	\N	2025-12-27 03:04:43.624352+00	2025-12-27 03:04:43.624352+00	non-perishable	Costco	door rack, top shelf
208	ricotta cheese, whole milk	lb	\N	2025-12-27 03:04:43.624922+00	2025-12-27 03:04:43.624922+00	produce	Costco	refrigerator
209	roti packet, frozen	packet	\N	2025-12-27 03:04:43.625517+00	2025-12-27 03:04:43.625517+00	frozen	Indian	white freezer
210	rotini pasta	lb	\N	2025-12-27 03:04:43.626119+00	2025-12-27 03:04:43.626119+00	non-perishable	Grocery	refrigerator rack, bottom shelf
211	saffron	gm	\N	2025-12-27 03:04:43.626715+00	2025-12-27 03:04:43.626715+00	pantry	Indian	spice rack
212	scallions, fresh (green onions)	bunch	\N	2025-12-27 03:04:43.627387+00	2025-12-27 03:04:43.627387+00	produce	Grocery	refrigerator
213	semolina, fine (sooji)	lb	\N	2025-12-27 03:04:43.628159+00	2025-12-27 03:04:43.628159+00	refrigerator	Indian	refrigerator rack, bottom shelf
214	sesame oil	bottle	\N	2025-12-27 03:04:43.62875+00	2025-12-27 03:04:43.62875+00	pantry	Grocery	refrigerator rack, bottom shelf
215	sesame seeds	lb	\N	2025-12-27 03:04:43.629339+00	2025-12-27 03:04:43.629339+00	non-perishable	Costco	refrigerator rack, 2nd shelf
216	sev vermicelli	lb	\N	2025-12-27 03:04:43.629938+00	2025-12-27 03:04:43.629938+00	non-perishable	Indian	refrigerator rack, bottom shelf
217	sev zarda	24 oz bottle	\N	2025-12-27 03:04:43.630579+00	2025-12-27 03:04:43.630579+00	other	\N	mawaid table
218	sheermal	packet	\N	2025-12-27 03:04:43.631168+00	2025-12-27 03:04:43.631168+00	bread	Indian	white freezer
219	snack nut variety pack, Kirkland Signature	30-cnt box	\N	2025-12-27 03:04:43.631793+00	2025-12-27 03:04:43.631793+00	non-perishable	Costco	dishwasher rack, bottom shelf
220	sooji halwa	packet	\N	2025-12-27 03:04:43.63242+00	2025-12-27 03:04:43.63242+00	other	\N	white refrigerator
221	sour cream	lb	\N	2025-12-27 03:04:43.633141+00	2025-12-27 03:04:43.633141+00	perishable	Costco	refrigerator
222	soy sauce	bottle	\N	2025-12-27 03:04:43.633858+00	2025-12-27 03:04:43.633858+00	pantry	Grocery	refrigerator rack, bottom shelf
223	spinach leaves, fresh	lb	\N	2025-12-27 03:04:43.634589+00	2025-12-27 03:04:43.634589+00	produce	Costco	refrigerator
224	spinach pakoda, frozen, Deep brand	packet	\N	2025-12-27 03:04:43.635258+00	2025-12-27 03:04:43.635258+00	frozen	Indian	white freezer
225	spinach, frozen chopped	lb	\N	2025-12-27 03:04:43.635889+00	2025-12-27 03:04:43.635889+00	frozen	Grocery	white freezer
226	spinach, frozen cut	lb	\N	2025-12-27 03:04:43.636623+00	2025-12-27 03:04:43.636623+00	frozen	Grocery	white freezer
227	sugar	lb	\N	2025-12-27 03:04:43.637239+00	2025-12-27 03:04:43.637239+00	non-perishable	Costco	spice rack
228	sweet potatoes	lb	\N	2025-12-27 03:04:43.637825+00	2025-12-27 03:04:43.637825+00	produce	Grocery	refrigerator rack, bottom shelf
229	tahini paste	lb	\N	2025-12-27 03:04:43.638473+00	2025-12-27 03:04:43.638473+00	non-perishable	Indian	stove prep table middle shelf
230	tamarind paste	bottle	\N	2025-12-27 03:04:43.639157+00	2025-12-27 03:04:43.639157+00	pantry	Indian	refrigerator rack, middle upper shelf
231	tandoori masala, Shan brand	box	\N	2025-12-27 03:04:43.639727+00	2025-12-27 03:04:43.639727+00	non-perishable	Indian	refrigerator rack, bottom shelf
232	tapenade	lb	\N	2025-12-27 03:04:43.64041+00	2025-12-27 03:04:43.64041+00	other	\N	\N
233	tea, Wagh Bakhri or Safari brand	100 cnt box	\N	2025-12-27 03:04:43.64104+00	2025-12-27 03:04:43.64104+00	non-perishable	Indian	mawaid table
234	thyme leaves, dried McCormick brand	bottles	\N	2025-12-27 03:04:43.641656+00	2025-12-27 03:04:43.641656+00	pantry	Costco	refrigerator rack, middle upper shelf
235	tindoora, frozen	lb	\N	2025-12-27 03:04:43.642237+00	2025-12-27 03:04:43.642237+00	frozen	Indian	white freezer
236	tofu, extra firm	lb	\N	2025-12-27 03:04:43.642826+00	2025-12-27 03:04:43.642826+00	produce	Grocery	refrigerator
237	tomato paste, canned	lb	\N	2025-12-27 03:04:43.643568+00	2025-12-27 03:04:43.643568+00	non-perishable	Costco	stove prep table bottom shelf
238	tomato sauce, canned	lb	\N	2025-12-27 03:04:43.64422+00	2025-12-27 03:04:43.64422+00	non-perishable	Costco	stove prep table shelf
239	tomato, fresh	lb	\N	2025-12-27 03:04:43.644805+00	2025-12-27 03:04:43.644805+00	produce	Costco	refrigerator
240	tomatoes, canned crushed	lb	\N	2025-12-27 03:04:43.645414+00	2025-12-27 03:04:43.645414+00	non-perishable	Costco	stove prep table middle shelf
241	tomatoes, canned diced	lb	\N	2025-12-27 03:04:43.646121+00	2025-12-27 03:04:43.646121+00	non-perishable	Costco	stove prep table middle shelf
242	tomatoes, cherry fresh	lb	\N	2025-12-27 03:04:43.646747+00	2025-12-27 03:04:43.646747+00	produce	Grocery	refrigerator
243	toor daal	lb	\N	2025-12-27 03:04:43.647364+00	2025-12-27 03:04:43.647364+00	non-perishable	Indian	spice rack
244	toor daal, oily	lb	\N	2025-12-27 03:04:43.648096+00	2025-12-27 03:04:43.648096+00	non-perishable	Indian	refrigerator rack, top shelf
245	tres leches caramel cake	cake	\N	2025-12-27 03:04:43.648714+00	2025-12-27 03:04:43.648714+00	produce	Costco	refrigerator
246	tuxedo cake	cake	\N	2025-12-27 03:04:43.649366+00	2025-12-27 03:04:43.649366+00	produce	Costco	refrigerator
247	tzaziki dip, Hannah brand	lb	\N	2025-12-27 03:04:43.649969+00	2025-12-27 03:04:43.649969+00	perishable	Costco	refrigerator
248	urad daal, whole (black)	lb	\N	2025-12-27 03:04:43.650589+00	2025-12-27 03:04:43.650589+00	non-perishable	Indian	spice rack
249	vanilla pudding mix, Jello instant	box	\N	2025-12-27 03:04:43.651182+00	2025-12-27 03:04:43.651182+00	non-perishable	Grocery	refrigerator rack, bottom shelf
250	vegetarian oyster sauce	bottle	\N	2025-12-27 03:04:43.651809+00	2025-12-27 03:04:43.651809+00	non-perishable	Korean	refrigerator rack, bottom shelf
251	vinegar, white	quart	\N	2025-12-27 03:04:43.652545+00	2025-12-27 03:04:43.652545+00	pantry	Grocery	refrigerator rack, bottom shelf
252	water	gallon	\N	2025-12-27 03:04:43.653236+00	2025-12-27 03:04:43.653236+00	pantry	\N	\N
253	yogurt, greek 0% fat	lb	\N	2025-12-27 03:04:43.653905+00	2025-12-27 03:04:43.653905+00	produce	Costco	refrigerator
254	yogurt, lowfat	lb	\N	2025-12-27 03:04:43.65456+00	2025-12-27 03:04:43.65456+00	produce	Costco	refrigerator
255	yogurt, whole milk	lb	\N	2025-12-27 03:04:43.655181+00	2025-12-27 03:04:43.655181+00	produce	Costco	refrigerator
256	zucchini	lb	\N	2025-12-27 03:04:43.655831+00	2025-12-27 03:04:43.655831+00	produce	Grocery	refrigerator
\.


--
-- Data for Name: menu_item_ingredients; Type: TABLE DATA; Schema: public; Owner: rsvp
--

COPY public.menu_item_ingredients (menu_item_id, ingredient_id, qty_per_quart, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: menu_items; Type: TABLE DATA; Schema: public; Owner: rsvp
--

COPY public.menu_items (id, event_id, name, description, quarts_per_thaali_unit, created_at, updated_at, dish_id, "position") FROM stdin;
2	2	\N	\N	1.000000	2025-12-27 03:48:28.512584+00	2025-12-27 03:48:28.512584+00	104	1
3	2	\N	\N	1.000000	2025-12-27 03:48:28.512584+00	2025-12-27 03:48:28.512584+00	18	2
\.


--
-- Data for Name: niyaz_event_hosts; Type: TABLE DATA; Schema: public; Owner: rsvp
--

COPY public.niyaz_event_hosts (event_id, person_id) FROM stdin;
3	28
3	24
3	41
\.


--
-- Data for Name: niyaz_rsvps; Type: TABLE DATA; Schema: public; Owner: rsvp
--

COPY public.niyaz_rsvps (id, event_id, person_id, adults, kids, created_at, updated_at) FROM stdin;
1	3	26	2	0	2025-12-27 13:38:56.963934+00	2025-12-27 13:38:56.963934+00
2	3	5	1	0	2025-12-28 01:09:45.403811+00	2025-12-28 01:09:45.403811+00
3	3	61	1	0	2025-12-28 01:09:45.403811+00	2025-12-28 01:09:45.403811+00
4	3	60	1	0	2025-12-28 01:09:45.403811+00	2025-12-28 01:09:45.403811+00
5	3	30	1	0	2025-12-28 01:09:45.403811+00	2025-12-28 01:09:45.403811+00
6	3	31	1	0	2025-12-28 01:09:45.403811+00	2025-12-28 01:09:45.403811+00
7	3	3	1	0	2025-12-28 01:09:45.403811+00	2025-12-28 01:09:45.403811+00
8	3	56	1	0	2025-12-28 01:09:45.403811+00	2025-12-28 01:09:45.403811+00
9	3	42	1	0	2025-12-28 01:09:45.403811+00	2025-12-28 01:09:45.403811+00
10	3	9	1	0	2025-12-28 01:09:45.403811+00	2025-12-28 01:09:45.403811+00
11	3	10	1	0	2025-12-28 01:09:45.403811+00	2025-12-28 01:09:45.403811+00
12	3	57	1	0	2025-12-28 01:09:45.403811+00	2025-12-28 01:09:45.403811+00
13	3	36	1	0	2025-12-28 01:09:45.403811+00	2025-12-28 01:09:45.403811+00
14	3	29	1	0	2025-12-28 01:09:45.403811+00	2025-12-28 01:09:45.403811+00
15	3	20	1	0	2025-12-28 01:09:45.403811+00	2025-12-28 01:09:45.403811+00
16	3	8	1	0	2025-12-28 01:09:45.403811+00	2025-12-28 01:09:45.403811+00
17	3	44	1	0	2025-12-28 01:09:45.403811+00	2025-12-28 01:09:45.403811+00
18	3	64	2	1	2025-12-28 01:09:45.403811+00	2025-12-28 01:09:45.403811+00
19	3	62	2	1	2025-12-28 01:09:45.403811+00	2025-12-28 01:09:45.403811+00
20	3	25	2	1	2025-12-28 01:09:45.403811+00	2025-12-28 01:09:45.403811+00
21	3	38	2	1	2025-12-28 01:09:45.403811+00	2025-12-28 01:09:45.403811+00
22	3	67	2	1	2025-12-28 01:09:45.403811+00	2025-12-28 01:09:45.403811+00
23	3	66	2	1	2025-12-28 01:09:45.403811+00	2025-12-28 01:09:45.403811+00
24	3	34	2	1	2025-12-28 01:09:45.403811+00	2025-12-28 01:09:45.403811+00
25	3	28	2	1	2025-12-28 01:09:45.403811+00	2025-12-28 01:09:45.403811+00
26	3	6	2	1	2025-12-28 01:09:45.403811+00	2025-12-28 01:09:45.403811+00
27	3	48	2	1	2025-12-28 01:09:45.403811+00	2025-12-28 01:09:45.403811+00
28	3	37	2	1	2025-12-28 01:09:45.403811+00	2025-12-28 01:09:45.403811+00
29	3	52	2	1	2025-12-28 01:09:45.403811+00	2025-12-28 01:09:45.403811+00
30	3	4	2	1	2025-12-28 01:09:45.403811+00	2025-12-28 01:09:45.403811+00
31	3	12	2	1	2025-12-28 01:09:45.403811+00	2025-12-28 01:09:45.403811+00
32	3	35	2	1	2025-12-28 01:09:45.403811+00	2025-12-28 01:09:45.403811+00
33	3	27	2	1	2025-12-28 01:09:45.403811+00	2025-12-28 01:09:45.403811+00
34	3	22	2	1	2025-12-28 01:09:45.403811+00	2025-12-28 01:09:45.403811+00
35	3	58	2	1	2025-12-28 01:09:45.403811+00	2025-12-28 01:09:45.403811+00
36	3	2	2	0	2025-12-30 10:36:02.025825+00	2025-12-30 10:36:02.025825+00
\.


--
-- Data for Name: password_reset_tokens; Type: TABLE DATA; Schema: public; Owner: rsvp
--

COPY public.password_reset_tokens (id, person_id, created_at, expires_at, used_at) FROM stdin;
\.


--
-- Data for Name: person_roles; Type: TABLE DATA; Schema: public; Owner: rsvp
--

COPY public.person_roles (person_id, role) FROM stdin;
1	USER
2	USER
3	USER
4	USER
7	USER
8	USER
9	USER
10	USER
11	USER
12	USER
13	USER
14	USER
15	USER
16	USER
17	USER
18	USER
19	USER
20	USER
21	USER
22	USER
23	USER
24	USER
25	USER
26	USER
27	USER
28	USER
29	USER
31	USER
32	USER
33	USER
34	USER
35	USER
36	USER
37	USER
38	USER
39	USER
40	USER
41	USER
42	USER
43	USER
44	USER
45	USER
46	USER
47	USER
48	USER
49	USER
50	USER
51	USER
52	USER
53	USER
54	USER
55	USER
56	USER
57	USER
58	USER
59	USER
60	USER
61	USER
62	USER
63	USER
64	USER
65	USER
66	USER
67	USER
26	ADMIN
5	ADMIN
5	USER
6	USER
6	NIYAZ_COORDINATOR
30	USER
30	NIYAZ_COORDINATOR
\.


--
-- Data for Name: persons; Type: TABLE DATA; Schema: public; Owner: rsvp
--

COPY public.persons (id, its_number, first_name, last_name, phone, email, password_hash, account_status, reset_token, reset_expires_at, failed_login_count, last_login_at, created_at, updated_at, pickup_zone_id) FROM stdin;
1	30603259	Bhai Murtaza	Hassonjee	\N	bhaimurtaza.hassonjee@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.346872+00	2025-12-27 03:04:13.346872+00	7
3	20355750	Yusuf	Hameed	410-696-8699	yusuf.hameed@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.35075+00	2025-12-27 03:04:13.35075+00	6
4	30415904	Adnan	Hameed	\N	adnan.hameed@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.351553+00	2025-12-27 03:04:13.351553+00	6
7	20342143	Adil	Merchant	443-285-0791	adil.merchant@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.353895+00	2025-12-27 03:04:13.353895+00	6
8	20355778	Khuzaima	Pirbhai	410-772-0383	khuzaima.pirbhai@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.354555+00	2025-12-27 03:04:13.354555+00	6
9	30602213	Qusai	Poonawala	313-384-0826	qusai.poonawala@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.355307+00	2025-12-27 03:04:13.355307+00	6
10	30469204	Mohammed	Qaiyumi	\N	mohammed.qaiyumi@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.356247+00	2025-12-27 03:04:13.356247+00	6
11	20355703	Saifuddin	Qaiyumi	410-381-5896	saifuddin.qaiyumi@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.357022+00	2025-12-27 03:04:13.357022+00	6
12	20357958	Shabbir	Rangwala	410-461-2924	shabbir.rangwala@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.35772+00	2025-12-27 03:04:13.35772+00	6
13	30712127	Samina	Saifuddin	\N	samina.saifuddin@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.358389+00	2025-12-27 03:04:13.358389+00	6
14	30469253	Taher	Ezzi	\N	taher.ezzi@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.35908+00	2025-12-27 03:04:13.35908+00	6
15	20394720	Bhai Zainuddin	Tajbhai	\N	bhaizainuddin.tajbhai@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.35976+00	2025-12-27 03:04:13.35976+00	6
16	20355776	Juzer	Babuji	301-300-2484	juzer.babuji@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.360396+00	2025-12-27 03:04:13.360396+00	5
17	20355767	Quraish	Hakimji	301-631-6789	quraish.hakimji@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.36106+00	2025-12-27 03:04:13.36106+00	5
18	40406259	Mustafa	Rawat	240-520-2546	mustafa.rawat@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.361681+00	2025-12-27 03:04:13.361681+00	5
19	50171755	Dr. Hussaina	Saria	\N	dr.hussaina.saria@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.362355+00	2025-12-27 03:04:13.362355+00	5
20	20342717	Zahid	Rangoonwala	\N	zahid.rangoonwala@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.363056+00	2025-12-27 03:04:13.363056+00	5
21	30602220	Firoz	Arastu	240-654-4002	firoz.arastu@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.363717+00	2025-12-27 03:04:13.363717+00	3
22	50183675	Esmail	Chitalwala	\N	esmail.chitalwala@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.364403+00	2025-12-27 03:04:13.364403+00	3
23	30602245	Qutbuddin	Ghulamali	301-528-9081	qutbuddin.ghulamali@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.365034+00	2025-12-27 03:04:13.365034+00	3
24	20355779	Shahed	Husain	301-972-1760	shahed.husain@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.365686+00	2025-12-27 03:04:13.365686+00	3
25	20355727	Shujaat	Hussain	301-972-3486	shujaat.hussain@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.366323+00	2025-12-27 03:04:13.366323+00	3
26	30702039	Mustafa	Kanchwala	\N	mustafa.kanchwala@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.36702+00	2025-12-27 03:04:13.36702+00	3
27	20355723	Mustafa	Shahmalak	\N	mustafa.shahmalak@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.367648+00	2025-12-27 03:04:13.367648+00	3
28	30469231	Murtaza	Shajapurwala	301-540-4509	murtaza.shajapurwala@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.368304+00	2025-12-27 03:04:13.368304+00	3
29	50401803	Zeeshan	Ali	\N	zeeshan.ali@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.369012+00	2025-12-27 03:04:13.369012+00	3
31	20355732	Faisal	Ghadially	301-217-0836	faisal.ghadially@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.370536+00	2025-12-27 03:04:13.370536+00	2
32	30309367	Behen Sakina	Goawala	\N	behensakina.goawala@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.37141+00	2025-12-27 03:04:13.37141+00	2
33	30303336	Husein	Kagalwala	\N	husein.kagalwala@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.372106+00	2025-12-27 03:04:13.372106+00	2
34	30469245	Mufaddal	Manasawala	\N	mufaddal.manasawala@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.372813+00	2025-12-27 03:04:13.372813+00	2
35	30466244	Dr. Idris	Amin	646-322-6413	dr.idris.amin@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.373628+00	2025-12-27 03:04:13.373628+00	1
36	20355804	Abbas	Amin	\N	abbas.amin@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.374367+00	2025-12-27 03:04:13.374367+00	1
37	30311267	Hozefa	Arsiwala	312-498-9880	hozefa.arsiwala@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.375146+00	2025-12-27 03:04:13.375146+00	1
38	20355702	Adnan	Basrai	301-460-5266	adnan.basrai@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.375848+00	2025-12-27 03:04:13.375848+00	1
39	30456247	Fakhruddin	Bootwala	443-905-7860	fakhruddin.bootwala@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.376549+00	2025-12-27 03:04:13.376549+00	1
6	20355731	Qusai	Kagalwala	443-364-4134	qusai.kagalwala@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.353106+00	2025-12-28 12:17:00.403792+00	6
30	30415859	Hussein	Seifuddin	469-583-0651	hussein.seifuddin@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.369735+00	2025-12-28 19:31:42.962685+00	3
2	30907725	Abbas	Sinnar	443-851-4292	abbas.sinnar@example.com	$2a$10$rWZqAlHidvKpM1S9W8mtKOV9mXnMSEVp7OQ7G7UGZzBNWYXbq.VSm	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.349879+00	2025-12-30 02:01:07.623342+00	7
40	20355718	Murtaza	Colombowala	\N	murtaza.colombowala@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.377248+00	2025-12-27 03:04:13.377248+00	1
41	30602681	Murtaza	Dawood	410-312-4951	murtaza.dawood@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.378114+00	2025-12-27 03:04:13.378114+00	1
42	30800216	Abid	Fakhri	412-607-1834	abid.fakhri@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.378837+00	2025-12-27 03:04:13.378837+00	1
43	20355770	Aliasgar	Gadiwalla	410-531-7552	aliasgar.gadiwalla@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.379521+00	2025-12-27 03:04:13.379521+00	1
44	30440154	Shabbir	Hamid	\N	shabbir.hamid@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.380202+00	2025-12-27 03:04:13.380202+00	1
45	30151129	Rashida	Hussain	304-906-7224	rashida.hussain@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.380941+00	2025-12-27 03:04:13.380941+00	1
46	30434889	Bhai Shabbir	Kanchwala	443-713-0286	bhaishabbir.kanchwala@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.38163+00	2025-12-27 03:04:13.38163+00	1
47	20355714	Fakhruddin	Kurawadwala	301-774-6440	fakhruddin.kurawadwala@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.382296+00	2025-12-27 03:04:13.382296+00	1
48	30373440	Abbas	Lokhandwala	646-244-4205	abbas.lokhandwala@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.383067+00	2025-12-27 03:04:13.383067+00	1
49	20324764	Taher	Lukmanji	\N	taher.lukmanji@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.383756+00	2025-12-27 03:04:13.383756+00	1
50	30469249	Mohammed	Manasawala	302-465-1952	mohammed.manasawala@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.384395+00	2025-12-27 03:04:13.384395+00	1
51	20353730	Shireen	Marfatia	301-593-0108	shireen.marfatia@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.385061+00	2025-12-27 03:04:13.385061+00	1
52	30602218	Maleka	Marvi	410-997-7056	maleka.marvi@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.385682+00	2025-12-27 03:04:13.385682+00	1
53	50423797	Ammar	Motorwala	\N	ammar.motorwala@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.386375+00	2025-12-27 03:04:13.386375+00	1
54	20412494	Janab Amilsaheb Ali Asgar BS	Najmi	\N	janabamilsahebaliasgarbs.najmi@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.387022+00	2025-12-27 03:04:13.387022+00	1
55	30920001	Yusuf	Patel	\N	yusuf.patel@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.387651+00	2025-12-27 03:04:13.387651+00	1
56	30805389	Tahir	Patel	\N	tahir.patel@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.388318+00	2025-12-27 03:04:13.388318+00	1
57	20342480	Ibrahim	Sabir	301-637-4347	ibrahim.sabir@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.389026+00	2025-12-27 03:04:13.389026+00	1
58	20327445	Shaikh Idris Bhai	Sunelwala	\N	shaikhidrisbhai.sunelwala@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.389667+00	2025-12-27 03:04:13.389667+00	1
59	20338717	Murtaza	Zaki	240-786-6114	murtaza.zaki@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.390296+00	2025-12-27 03:04:13.390296+00	1
60	30469235	Yusuf	Husain	\N	yusuf.husain@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.390984+00	2025-12-27 03:04:13.390984+00	1
61	20439188	Murtaza	Patanwala	\N	murtaza.patanwala@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.391648+00	2025-12-27 03:04:13.391648+00	1
62	30469206	Nisrin	Suterwala	\N	nisrin.suterwala@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.39229+00	2025-12-27 03:04:13.39229+00	1
63	30469207	Hussain	Sutterwala	\N	hussain.sutterwala@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.392999+00	2025-12-27 03:04:13.392999+00	1
64	30464515	Kusai	Merchant	240-381-3104	kusai.merchant@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.393693+00	2025-12-27 03:04:13.393693+00	4
65	30464507	Huzefa	Mun	\N	huzefa.mun@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.394339+00	2025-12-27 03:04:13.394339+00	4
66	30462008	Behen Tasneem	Dollar	713-897-9792	behentasneem.dollar@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.395108+00	2025-12-27 03:04:13.395108+00	4
67	30329984	Khuzema	Habib	\N	khuzema.habib@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.395803+00	2025-12-27 03:04:13.395803+00	4
5	30394967	Shabbar	Jamali	443-739-8968	shabbar.jamali@example.com	$2a$10$/wGG1m91.CeFb5GC5kkfN.Ssub.N6eZDn6m4eZEcAynkKQ0enpmfK	ACTIVE	\N	\N	0	\N	2025-12-27 03:04:13.352245+00	2025-12-28 12:16:26.990609+00	6
\.


--
-- Data for Name: pickup_zones; Type: TABLE DATA; Schema: public; Owner: rsvp
--

COPY public.pickup_zones (id, name, active, created_at) FROM stdin;
1	SELF_PICKUP_NAJMI_MASJID	t	2025-12-27 02:55:29.406054+00
2	NORTH_POTOMAC_ROCKVILLE	t	2025-12-27 02:55:29.406054+00
3	GERMANTOWN	t	2025-12-27 02:55:29.406054+00
4	WASHINGTON_DC	t	2025-12-27 02:55:29.406054+00
5	FREDERICK	t	2025-12-27 02:55:29.406054+00
6	ELLICOTT_CITY_COLUMBIA	t	2025-12-27 02:55:29.406054+00
7	CLARKSVILLE	t	2025-12-27 02:55:29.406054+00
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: rsvp
--

COPY public.roles (id, name, description, active, created_at, updated_at) FROM stdin;
1	USER	Basic access to view events, submit RSVPs, and place Thaali orders	t	2025-12-27 02:55:29.517648	2025-12-27 02:55:29.517648
2	SUPER_USER	Elevated access to view reports and manage event data	t	2025-12-27 02:55:29.517648	2025-12-27 02:55:29.517648
3	ADMIN	Full administrative access to all system features	t	2025-12-27 02:55:29.517648	2025-12-27 02:55:29.517648
4	NIYAZ_COORDINATOR	Can create and manage Niyaz events	t	2025-12-27 02:55:29.537062	2025-12-27 02:55:29.537062
5	THAALI_COORDINATOR	Can create and manage Thaali events	t	2025-12-27 02:55:29.537062	2025-12-27 02:55:29.537062
\.


--
-- Data for Name: session_tokens; Type: TABLE DATA; Schema: public; Owner: rsvp
--

COPY public.session_tokens (id, person_id, created_at, expires_at, revoked) FROM stdin;
4680c784-d528-4fe9-84c2-a2cef0abece4	26	2025-12-27 03:05:37.232119+00	2026-01-03 03:05:37.232119+00	f
7ae9c53b-4eac-42d8-9c76-0819c33d4ad4	26	2025-12-27 03:05:45.860575+00	2026-01-03 03:05:45.860575+00	t
d308574e-c1c9-461a-975b-918493b6b155	26	2025-12-27 17:17:20.524032+00	2026-01-03 17:17:20.524032+00	f
ae2e63b8-93da-4c3c-b68d-30f142d477c7	26	2025-12-28 03:30:29.08705+00	2026-01-04 03:30:29.08705+00	t
9e007bee-428b-486a-afe6-f0825a40fd8c	30	2025-12-28 19:31:57.928511+00	2026-01-04 19:31:57.928511+00	t
749ce9b0-9114-4f63-a865-35e46e196217	26	2025-12-28 19:33:00.759899+00	2026-01-04 19:33:00.759899+00	t
a00aad27-7fb5-4c60-9deb-169a4905af2e	2	2025-12-30 02:01:23.482355+00	2026-01-06 02:01:23.482355+00	t
8db8784f-ac29-4cc7-b7e0-352bc390e0ce	26	2025-12-30 10:36:20.151683+00	2026-01-06 10:36:20.151683+00	f
\.


--
-- Data for Name: thaali_order_items; Type: TABLE DATA; Schema: public; Owner: rsvp
--

COPY public.thaali_order_items (id, order_id, menu_item_id, size, created_at, updated_at) FROM stdin;
1	1	2	SMALL	2025-12-27 05:22:26.226732+00	2025-12-27 05:22:26.226732+00
2	1	3	SMALL	2025-12-27 05:22:26.229911+00	2025-12-27 05:22:26.229911+00
3	2	2	LARGE	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
4	2	3	LARGE	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
5	3	2	BARAKATI	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
6	3	3	SMALL	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
7	4	2	LARGE	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
8	4	3	LARGE	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
9	5	2	SMALL	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
10	5	3	LARGE	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
11	6	2	LARGE	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
12	6	3	SMALL	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
13	7	2	LARGE	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
14	7	3	SMALL	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
15	8	2	LARGE	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
16	8	3	SMALL	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
17	9	2	LARGE	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
18	9	3	LARGE	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
19	10	2	SMALL	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
20	10	3	SMALL	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
21	11	2	LARGE	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
22	11	3	BARAKATI	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
23	12	2	LARGE	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
24	12	3	LARGE	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
25	13	2	LARGE	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
26	13	3	LARGE	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
27	14	2	LARGE	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
28	14	3	BARAKATI	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
29	15	2	SMALL	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
30	15	3	BARAKATI	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
31	16	2	LARGE	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
32	16	3	LARGE	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
33	17	2	SMALL	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
34	17	3	LARGE	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
35	18	2	LARGE	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
36	18	3	LARGE	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
37	19	2	SMALL	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
38	19	3	LARGE	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
39	20	2	SMALL	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
40	20	3	SMALL	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
41	21	2	LARGE	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
42	21	3	LARGE	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
43	22	2	LARGE	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
44	22	3	LARGE	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
45	23	2	LARGE	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
46	23	3	SMALL	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
47	24	2	LARGE	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
48	24	3	LARGE	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
49	25	2	SMALL	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
50	25	3	LARGE	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
51	26	2	LARGE	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
52	26	3	SMALL	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
53	27	2	LARGE	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
54	27	3	SMALL	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
55	28	2	LARGE	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
56	28	3	LARGE	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
57	29	2	SMALL	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
58	29	3	LARGE	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
59	30	2	LARGE	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
60	30	3	LARGE	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
61	31	2	LARGE	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
62	31	3	LARGE	2025-12-28 01:10:14.678304+00	2025-12-28 01:10:14.678304+00
\.


--
-- Data for Name: thaali_orders; Type: TABLE DATA; Schema: public; Owner: rsvp
--

COPY public.thaali_orders (id, event_id, person_id, notes, created_at, updated_at, pickup_zone_id) FROM stdin;
1	2	26	\N	2025-12-27 05:22:26.223266+00	2025-12-27 05:22:26.223266+00	3
2	2	54	\N	2025-12-28 01:10:02.783028+00	2025-12-28 01:10:02.783028+00	1
3	2	52	\N	2025-12-28 01:10:02.783028+00	2025-12-28 01:10:02.783028+00	1
4	2	22	\N	2025-12-28 01:10:02.783028+00	2025-12-28 01:10:02.783028+00	1
5	2	40	\N	2025-12-28 01:10:02.783028+00	2025-12-28 01:10:02.783028+00	1
6	2	37	\N	2025-12-28 01:10:02.783028+00	2025-12-28 01:10:02.783028+00	1
7	2	2	\N	2025-12-28 01:10:02.783028+00	2025-12-28 01:10:02.783028+00	1
8	2	21	\N	2025-12-28 01:10:02.783028+00	2025-12-28 01:10:02.783028+00	1
9	2	28	\N	2025-12-28 01:10:02.783028+00	2025-12-28 01:10:02.783028+00	1
10	2	7	\N	2025-12-28 01:10:02.783028+00	2025-12-28 01:10:02.783028+00	1
11	2	11	\N	2025-12-28 01:10:02.783028+00	2025-12-28 01:10:02.783028+00	1
12	2	12	\N	2025-12-28 01:10:02.783028+00	2025-12-28 01:10:02.783028+00	2
13	2	41	\N	2025-12-28 01:10:02.783028+00	2025-12-28 01:10:02.783028+00	2
14	2	46	\N	2025-12-28 01:10:02.783028+00	2025-12-28 01:10:02.783028+00	2
15	2	8	\N	2025-12-28 01:10:02.783028+00	2025-12-28 01:10:02.783028+00	2
16	2	10	\N	2025-12-28 01:10:02.783028+00	2025-12-28 01:10:02.783028+00	2
17	2	15	\N	2025-12-28 01:10:02.783028+00	2025-12-28 01:10:02.783028+00	2
18	2	35	\N	2025-12-28 01:10:02.783028+00	2025-12-28 01:10:02.783028+00	2
19	2	45	\N	2025-12-28 01:10:02.783028+00	2025-12-28 01:10:02.783028+00	2
20	2	1	\N	2025-12-28 01:10:02.783028+00	2025-12-28 01:10:02.783028+00	2
21	2	25	\N	2025-12-28 01:10:02.783028+00	2025-12-28 01:10:02.783028+00	2
22	2	14	\N	2025-12-28 01:10:02.783028+00	2025-12-28 01:10:02.783028+00	2
23	2	4	\N	2025-12-28 01:10:02.783028+00	2025-12-28 01:10:02.783028+00	3
24	2	23	\N	2025-12-28 01:10:02.783028+00	2025-12-28 01:10:02.783028+00	3
25	2	57	\N	2025-12-28 01:10:02.783028+00	2025-12-28 01:10:02.783028+00	3
26	2	27	\N	2025-12-28 01:10:02.783028+00	2025-12-28 01:10:02.783028+00	3
27	2	62	\N	2025-12-28 01:10:02.783028+00	2025-12-28 01:10:02.783028+00	3
28	2	50	\N	2025-12-28 01:10:02.783028+00	2025-12-28 01:10:02.783028+00	3
29	2	6	\N	2025-12-28 01:10:02.783028+00	2025-12-28 01:10:02.783028+00	3
30	2	43	\N	2025-12-28 01:10:02.783028+00	2025-12-28 01:10:02.783028+00	3
31	2	59	\N	2025-12-28 01:10:02.783028+00	2025-12-28 01:10:02.783028+00	3
\.


--
-- Name: chefs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rsvp
--

SELECT pg_catalog.setval('public.chefs_id_seq', 7, true);


--
-- Name: dishes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rsvp
--

SELECT pg_catalog.setval('public.dishes_id_seq', 194, true);


--
-- Name: events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rsvp
--

SELECT pg_catalog.setval('public.events_id_seq', 3, true);


--
-- Name: ingredients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rsvp
--

SELECT pg_catalog.setval('public.ingredients_id_seq', 256, true);


--
-- Name: menu_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rsvp
--

SELECT pg_catalog.setval('public.menu_items_id_seq', 3, true);


--
-- Name: niyaz_rsvps_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rsvp
--

SELECT pg_catalog.setval('public.niyaz_rsvps_id_seq', 36, true);


--
-- Name: persons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rsvp
--

SELECT pg_catalog.setval('public.persons_id_seq', 67, true);


--
-- Name: pickup_zones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rsvp
--

SELECT pg_catalog.setval('public.pickup_zones_id_seq', 14, true);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rsvp
--

SELECT pg_catalog.setval('public.roles_id_seq', 5, true);


--
-- Name: thaali_order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rsvp
--

SELECT pg_catalog.setval('public.thaali_order_items_id_seq', 62, true);


--
-- Name: thaali_orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rsvp
--

SELECT pg_catalog.setval('public.thaali_orders_id_seq', 31, true);


--
-- Name: chefs chefs_name_key; Type: CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.chefs
    ADD CONSTRAINT chefs_name_key UNIQUE (name);


--
-- Name: chefs chefs_pkey; Type: CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.chefs
    ADD CONSTRAINT chefs_pkey PRIMARY KEY (id);


--
-- Name: dish_ingredients dish_ingredients_pkey; Type: CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.dish_ingredients
    ADD CONSTRAINT dish_ingredients_pkey PRIMARY KEY (dish_id, ingredient_id);


--
-- Name: dishes dishes_name_key; Type: CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.dishes
    ADD CONSTRAINT dishes_name_key UNIQUE (name);


--
-- Name: dishes dishes_pkey; Type: CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.dishes
    ADD CONSTRAINT dishes_pkey PRIMARY KEY (id);


--
-- Name: event_person_chefs event_chefs_pkey; Type: CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.event_person_chefs
    ADD CONSTRAINT event_chefs_pkey PRIMARY KEY (event_id, person_id);


--
-- Name: event_chefs event_chefs_pkey1; Type: CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.event_chefs
    ADD CONSTRAINT event_chefs_pkey1 PRIMARY KEY (event_id, chef_id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: flyway_schema_history flyway_schema_history_pk; Type: CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.flyway_schema_history
    ADD CONSTRAINT flyway_schema_history_pk PRIMARY KEY (installed_rank);


--
-- Name: ingredients ingredients_name_key; Type: CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.ingredients
    ADD CONSTRAINT ingredients_name_key UNIQUE (name);


--
-- Name: ingredients ingredients_pkey; Type: CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.ingredients
    ADD CONSTRAINT ingredients_pkey PRIMARY KEY (id);


--
-- Name: menu_item_ingredients menu_item_ingredients_pkey; Type: CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.menu_item_ingredients
    ADD CONSTRAINT menu_item_ingredients_pkey PRIMARY KEY (menu_item_id, ingredient_id);


--
-- Name: menu_items menu_items_pkey; Type: CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.menu_items
    ADD CONSTRAINT menu_items_pkey PRIMARY KEY (id);


--
-- Name: niyaz_event_hosts niyaz_event_hosts_pkey; Type: CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.niyaz_event_hosts
    ADD CONSTRAINT niyaz_event_hosts_pkey PRIMARY KEY (event_id, person_id);


--
-- Name: niyaz_rsvps niyaz_rsvps_pkey; Type: CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.niyaz_rsvps
    ADD CONSTRAINT niyaz_rsvps_pkey PRIMARY KEY (id);


--
-- Name: password_reset_tokens password_reset_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_pkey PRIMARY KEY (id);


--
-- Name: person_roles person_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.person_roles
    ADD CONSTRAINT person_roles_pkey PRIMARY KEY (person_id, role);


--
-- Name: persons persons_email_key; Type: CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.persons
    ADD CONSTRAINT persons_email_key UNIQUE (email);


--
-- Name: persons persons_its_number_key; Type: CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.persons
    ADD CONSTRAINT persons_its_number_key UNIQUE (its_number);


--
-- Name: persons persons_pkey; Type: CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.persons
    ADD CONSTRAINT persons_pkey PRIMARY KEY (id);


--
-- Name: pickup_zones pickup_zones_name_key; Type: CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.pickup_zones
    ADD CONSTRAINT pickup_zones_name_key UNIQUE (name);


--
-- Name: pickup_zones pickup_zones_pkey; Type: CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.pickup_zones
    ADD CONSTRAINT pickup_zones_pkey PRIMARY KEY (id);


--
-- Name: roles roles_name_key; Type: CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_key UNIQUE (name);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: session_tokens session_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.session_tokens
    ADD CONSTRAINT session_tokens_pkey PRIMARY KEY (id);


--
-- Name: thaali_order_items thaali_order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.thaali_order_items
    ADD CONSTRAINT thaali_order_items_pkey PRIMARY KEY (id);


--
-- Name: thaali_orders thaali_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.thaali_orders
    ADD CONSTRAINT thaali_orders_pkey PRIMARY KEY (id);


--
-- Name: niyaz_rsvps uc_niyaz_event_person; Type: CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.niyaz_rsvps
    ADD CONSTRAINT uc_niyaz_event_person UNIQUE (event_id, person_id);


--
-- Name: thaali_order_items uc_order_menu_item; Type: CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.thaali_order_items
    ADD CONSTRAINT uc_order_menu_item UNIQUE (order_id, menu_item_id);


--
-- Name: thaali_orders uc_thaali_event_person; Type: CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.thaali_orders
    ADD CONSTRAINT uc_thaali_event_person UNIQUE (event_id, person_id);


--
-- Name: flyway_schema_history_s_idx; Type: INDEX; Schema: public; Owner: rsvp
--

CREATE INDEX flyway_schema_history_s_idx ON public.flyway_schema_history USING btree (success);


--
-- Name: idx_roles_active; Type: INDEX; Schema: public; Owner: rsvp
--

CREATE INDEX idx_roles_active ON public.roles USING btree (active);


--
-- Name: idx_roles_name; Type: INDEX; Schema: public; Owner: rsvp
--

CREATE INDEX idx_roles_name ON public.roles USING btree (name);


--
-- Name: ix_event_date; Type: INDEX; Schema: public; Owner: rsvp
--

CREATE INDEX ix_event_date ON public.events USING btree (event_date);


--
-- Name: ix_ingredients_category; Type: INDEX; Schema: public; Owner: rsvp
--

CREATE INDEX ix_ingredients_category ON public.ingredients USING btree (category);


--
-- Name: ix_ingredients_store; Type: INDEX; Schema: public; Owner: rsvp
--

CREATE INDEX ix_ingredients_store ON public.ingredients USING btree (default_store);


--
-- Name: ix_menu_items_event; Type: INDEX; Schema: public; Owner: rsvp
--

CREATE INDEX ix_menu_items_event ON public.menu_items USING btree (event_id);


--
-- Name: ix_niyaz_event; Type: INDEX; Schema: public; Owner: rsvp
--

CREATE INDEX ix_niyaz_event ON public.niyaz_rsvps USING btree (event_id);


--
-- Name: ix_niyaz_event_hosts_person; Type: INDEX; Schema: public; Owner: rsvp
--

CREATE INDEX ix_niyaz_event_hosts_person ON public.niyaz_event_hosts USING btree (person_id);


--
-- Name: ix_password_reset_active; Type: INDEX; Schema: public; Owner: rsvp
--

CREATE INDEX ix_password_reset_active ON public.password_reset_tokens USING btree (person_id, expires_at) WHERE (used_at IS NULL);


--
-- Name: ix_session_active; Type: INDEX; Schema: public; Owner: rsvp
--

CREATE INDEX ix_session_active ON public.session_tokens USING btree (person_id, expires_at) WHERE (revoked = false);


--
-- Name: ix_thaali_event; Type: INDEX; Schema: public; Owner: rsvp
--

CREATE INDEX ix_thaali_event ON public.thaali_orders USING btree (event_id);


--
-- Name: ix_thaali_order_items_menu_item; Type: INDEX; Schema: public; Owner: rsvp
--

CREATE INDEX ix_thaali_order_items_menu_item ON public.thaali_order_items USING btree (menu_item_id);


--
-- Name: ix_thaali_order_items_order; Type: INDEX; Schema: public; Owner: rsvp
--

CREATE INDEX ix_thaali_order_items_order ON public.thaali_order_items USING btree (order_id);


--
-- Name: ix_thaali_orders_pickup_zone; Type: INDEX; Schema: public; Owner: rsvp
--

CREATE INDEX ix_thaali_orders_pickup_zone ON public.thaali_orders USING btree (pickup_zone_id);


--
-- Name: uk_menu_items_event_dish; Type: INDEX; Schema: public; Owner: rsvp
--

CREATE UNIQUE INDEX uk_menu_items_event_dish ON public.menu_items USING btree (event_id, dish_id) WHERE (dish_id IS NOT NULL);


--
-- Name: dish_ingredients dish_ingredients_dish_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.dish_ingredients
    ADD CONSTRAINT dish_ingredients_dish_id_fkey FOREIGN KEY (dish_id) REFERENCES public.dishes(id) ON DELETE CASCADE;


--
-- Name: dish_ingredients dish_ingredients_ingredient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.dish_ingredients
    ADD CONSTRAINT dish_ingredients_ingredient_id_fkey FOREIGN KEY (ingredient_id) REFERENCES public.ingredients(id) ON DELETE RESTRICT;


--
-- Name: event_chefs event_chefs_chef_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.event_chefs
    ADD CONSTRAINT event_chefs_chef_id_fkey FOREIGN KEY (chef_id) REFERENCES public.chefs(id) ON DELETE RESTRICT;


--
-- Name: event_person_chefs event_chefs_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.event_person_chefs
    ADD CONSTRAINT event_chefs_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(id) ON DELETE CASCADE;


--
-- Name: event_chefs event_chefs_event_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.event_chefs
    ADD CONSTRAINT event_chefs_event_id_fkey1 FOREIGN KEY (event_id) REFERENCES public.events(id) ON DELETE CASCADE;


--
-- Name: event_person_chefs event_chefs_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.event_person_chefs
    ADD CONSTRAINT event_chefs_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.persons(id) ON DELETE CASCADE;


--
-- Name: menu_items fk_menu_items_dish; Type: FK CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.menu_items
    ADD CONSTRAINT fk_menu_items_dish FOREIGN KEY (dish_id) REFERENCES public.dishes(id) ON DELETE RESTRICT;


--
-- Name: person_roles fk_person_roles_role; Type: FK CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.person_roles
    ADD CONSTRAINT fk_person_roles_role FOREIGN KEY (role) REFERENCES public.roles(name) ON UPDATE CASCADE;


--
-- Name: thaali_orders fk_thaali_orders_pickup_zone; Type: FK CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.thaali_orders
    ADD CONSTRAINT fk_thaali_orders_pickup_zone FOREIGN KEY (pickup_zone_id) REFERENCES public.pickup_zones(id);


--
-- Name: menu_item_ingredients menu_item_ingredients_ingredient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.menu_item_ingredients
    ADD CONSTRAINT menu_item_ingredients_ingredient_id_fkey FOREIGN KEY (ingredient_id) REFERENCES public.ingredients(id) ON DELETE CASCADE;


--
-- Name: menu_item_ingredients menu_item_ingredients_menu_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.menu_item_ingredients
    ADD CONSTRAINT menu_item_ingredients_menu_item_id_fkey FOREIGN KEY (menu_item_id) REFERENCES public.menu_items(id) ON DELETE CASCADE;


--
-- Name: menu_items menu_items_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.menu_items
    ADD CONSTRAINT menu_items_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(id) ON DELETE CASCADE;


--
-- Name: niyaz_event_hosts niyaz_event_hosts_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.niyaz_event_hosts
    ADD CONSTRAINT niyaz_event_hosts_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(id) ON DELETE CASCADE;


--
-- Name: niyaz_event_hosts niyaz_event_hosts_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.niyaz_event_hosts
    ADD CONSTRAINT niyaz_event_hosts_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.persons(id) ON DELETE CASCADE;


--
-- Name: niyaz_rsvps niyaz_rsvps_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.niyaz_rsvps
    ADD CONSTRAINT niyaz_rsvps_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(id) ON DELETE CASCADE;


--
-- Name: niyaz_rsvps niyaz_rsvps_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.niyaz_rsvps
    ADD CONSTRAINT niyaz_rsvps_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.persons(id) ON DELETE CASCADE;


--
-- Name: password_reset_tokens password_reset_tokens_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.persons(id) ON DELETE CASCADE;


--
-- Name: person_roles person_roles_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.person_roles
    ADD CONSTRAINT person_roles_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.persons(id) ON DELETE CASCADE;


--
-- Name: persons persons_pickup_zone_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.persons
    ADD CONSTRAINT persons_pickup_zone_id_fkey FOREIGN KEY (pickup_zone_id) REFERENCES public.pickup_zones(id);


--
-- Name: session_tokens session_tokens_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.session_tokens
    ADD CONSTRAINT session_tokens_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.persons(id) ON DELETE CASCADE;


--
-- Name: thaali_order_items thaali_order_items_menu_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.thaali_order_items
    ADD CONSTRAINT thaali_order_items_menu_item_id_fkey FOREIGN KEY (menu_item_id) REFERENCES public.menu_items(id) ON DELETE CASCADE;


--
-- Name: thaali_order_items thaali_order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.thaali_order_items
    ADD CONSTRAINT thaali_order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.thaali_orders(id) ON DELETE CASCADE;


--
-- Name: thaali_orders thaali_orders_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.thaali_orders
    ADD CONSTRAINT thaali_orders_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(id) ON DELETE CASCADE;


--
-- Name: thaali_orders thaali_orders_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rsvp
--

ALTER TABLE ONLY public.thaali_orders
    ADD CONSTRAINT thaali_orders_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.persons(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict oeFC06FTOcIjpaDcNOXp2zS54rsRVwt8SrMaIccATAwThmsIv0zqlP5e8vocE7J

