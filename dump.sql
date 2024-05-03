--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1 (Ubuntu 16.1-1.pgdg22.04+1)
-- Dumped by pg_dump version 16.1 (Ubuntu 16.1-1.pgdg22.04+1)

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
-- Name: album; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.album (
    id_alb integer NOT NULL,
    nom_album character varying(40) NOT NULL,
    couverture character varying(100) NOT NULL,
    date_sortie date NOT NULL,
    description text DEFAULT 'Aucune description'::text,
    id_grp integer
);


ALTER TABLE public.album OWNER TO postgres;

--
-- Name: album_id_alb_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.album_id_alb_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.album_id_alb_seq OWNER TO postgres;

--
-- Name: album_id_alb_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.album_id_alb_seq OWNED BY public.album.id_alb;


--
-- Name: artiste; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.artiste (
    id_art integer NOT NULL,
    nom character varying(20) NOT NULL,
    prenom character varying(20) NOT NULL,
    nationalite character varying(20) NOT NULL,
    date_n date NOT NULL,
    date_d date,
    CONSTRAINT check_date CHECK ((date_n < date_d))
);


ALTER TABLE public.artiste OWNER TO postgres;

--
-- Name: artiste_id_art_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.artiste_id_art_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.artiste_id_art_seq OWNER TO postgres;

--
-- Name: artiste_id_art_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.artiste_id_art_seq OWNED BY public.artiste.id_art;


--
-- Name: contient; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contient (
    id_alb integer NOT NULL,
    id_mor integer NOT NULL,
    num_tracklist integer NOT NULL
);


ALTER TABLE public.contient OWNER TO postgres;

--
-- Name: ecoute; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ecoute (
    id_mor integer NOT NULL,
    pseudo character varying(20) NOT NULL,
    date_ecoute timestamp without time zone DEFAULT date_trunc('second'::text, CURRENT_TIMESTAMP) NOT NULL
);


ALTER TABLE public.ecoute OWNER TO postgres;

--
-- Name: est_abonne; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.est_abonne (
    pseudo character varying(20) NOT NULL,
    id_grp integer NOT NULL
);


ALTER TABLE public.est_abonne OWNER TO postgres;

--
-- Name: est_dans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.est_dans (
    id_pl integer NOT NULL,
    id_mor integer NOT NULL,
    numero_track integer
);


ALTER TABLE public.est_dans OWNER TO postgres;

--
-- Name: fait_partie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fait_partie (
    id_art integer NOT NULL,
    id_grp integer NOT NULL,
    role character varying(20) NOT NULL,
    date_arr date NOT NULL,
    date_dep date,
    CONSTRAINT date_check CHECK ((date_arr < date_dep))
);


ALTER TABLE public.fait_partie OWNER TO postgres;

--
-- Name: groupe; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.groupe (
    id_grp integer NOT NULL,
    nom_groupe character varying(50) NOT NULL,
    nationalite_g character varying(20) NOT NULL,
    genre character varying(20) NOT NULL
);


ALTER TABLE public.groupe OWNER TO postgres;

--
-- Name: groupe_id_grp_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.groupe_id_grp_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.groupe_id_grp_seq OWNER TO postgres;

--
-- Name: groupe_id_grp_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.groupe_id_grp_seq OWNED BY public.groupe.id_grp;


--
-- Name: groupes_plus_suivis; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.groupes_plus_suivis AS
 SELECT groupe.id_grp,
    groupe.nom_groupe,
    count(est_abonne.id_grp) AS nombre_abonnes
   FROM (public.groupe
     LEFT JOIN public.est_abonne ON ((groupe.id_grp = est_abonne.id_grp)))
  GROUP BY groupe.nom_groupe, groupe.id_grp
  ORDER BY (count(est_abonne.id_grp)) DESC
 LIMIT 5;


ALTER VIEW public.groupes_plus_suivis OWNER TO postgres;

--
-- Name: mets_album_favoris; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mets_album_favoris (
    pseudo character varying(20) NOT NULL,
    id_alb integer NOT NULL
);


ALTER TABLE public.mets_album_favoris OWNER TO postgres;

--
-- Name: mets_en_favoris; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mets_en_favoris (
    pseudo character varying(20) NOT NULL,
    id_mor integer NOT NULL
);


ALTER TABLE public.mets_en_favoris OWNER TO postgres;

--
-- Name: morceau; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.morceau (
    id_mor integer NOT NULL,
    titre character varying(30) NOT NULL,
    duree time without time zone NOT NULL,
    audio character varying(100) NOT NULL,
    paroles text,
    date_pub date NOT NULL,
    id_grp integer NOT NULL
);


ALTER TABLE public.morceau OWNER TO postgres;

--
-- Name: morceau_id_mor_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.morceau_id_mor_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.morceau_id_mor_seq OWNER TO postgres;

--
-- Name: morceau_id_mor_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.morceau_id_mor_seq OWNED BY public.morceau.id_mor;


--
-- Name: participe; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.participe (
    id_mor integer NOT NULL,
    id_art integer NOT NULL
);


ALTER TABLE public.participe OWNER TO postgres;

--
-- Name: playlist; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.playlist (
    id_pl integer NOT NULL,
    nom_playlist character varying(100) NOT NULL,
    description_playlist text DEFAULT 'Aucune description'::text,
    statut character varying(8) DEFAULT 'private'::character varying NOT NULL,
    proprietaire character varying(20) NOT NULL,
    date_creation timestamp without time zone DEFAULT date_trunc('second'::text, CURRENT_TIMESTAMP) NOT NULL,
    CONSTRAINT playlist_state CHECK ((((statut)::text = 'private'::text) OR ((statut)::text = 'public'::text)))
);


ALTER TABLE public.playlist OWNER TO postgres;

--
-- Name: playlist_id_pl_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.playlist_id_pl_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.playlist_id_pl_seq OWNER TO postgres;

--
-- Name: playlist_id_pl_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.playlist_id_pl_seq OWNED BY public.playlist.id_pl;


--
-- Name: popular_tracks; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.popular_tracks AS
 SELECT morceau.id_mor,
    morceau.titre,
    morceau.id_grp,
    count(ecoute.id_mor) AS nombre_ecoutes
   FROM (public.morceau
     NATURAL JOIN public.ecoute)
  WHERE (ecoute.date_ecoute >= (CURRENT_DATE - '7 days'::interval))
  GROUP BY morceau.id_mor, morceau.titre, morceau.id_grp
  ORDER BY (count(ecoute.id_mor)) DESC
 LIMIT 10;


ALTER VIEW public.popular_tracks OWNER TO postgres;

--
-- Name: sauvegarde_playlist; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sauvegarde_playlist (
    pseudo character varying(20) NOT NULL,
    id_pl integer NOT NULL
);


ALTER TABLE public.sauvegarde_playlist OWNER TO postgres;

--
-- Name: suit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.suit (
    follower character varying(20) NOT NULL,
    following character varying(20) NOT NULL,
    CONSTRAINT followpossiblity CHECK (((follower)::text <> (following)::text))
);


ALTER TABLE public.suit OWNER TO postgres;

--
-- Name: utilisateur; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.utilisateur (
    pseudo character varying(20) NOT NULL,
    mdp character varying(64) NOT NULL,
    date_insc date DEFAULT CURRENT_DATE NOT NULL,
    email character varying(40) NOT NULL
);


ALTER TABLE public.utilisateur OWNER TO postgres;

--
-- Name: vue_statistiques_morceau; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vue_statistiques_morceau AS
 SELECT morceau.id_mor AS id_morceau,
    morceau.titre AS titre_morceau,
    count(DISTINCT ecoute_unique.pseudo) AS nombre_ecoutes_uniques,
    count(DISTINCT ecoute.pseudo) AS utilisateurs_ecoutes,
    count(DISTINCT playlist.id_pl) AS nombre_partages_playlist
   FROM ((((public.morceau
     LEFT JOIN ( SELECT ecoute_1.id_mor,
            ecoute_1.pseudo
           FROM public.ecoute ecoute_1
          GROUP BY ecoute_1.id_mor, ecoute_1.pseudo
         HAVING (count(*) = 1)) ecoute_unique ON ((morceau.id_mor = ecoute_unique.id_mor)))
     LEFT JOIN public.ecoute ON ((morceau.id_mor = ecoute.id_mor)))
     LEFT JOIN public.est_dans ON ((est_dans.id_mor = morceau.id_mor)))
     LEFT JOIN public.playlist ON (((playlist.id_pl = est_dans.id_pl) AND ((playlist.statut)::text = 'public'::text))))
  GROUP BY morceau.id_mor, morceau.titre;


ALTER VIEW public.vue_statistiques_morceau OWNER TO postgres;

--
-- Name: album id_alb; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.album ALTER COLUMN id_alb SET DEFAULT nextval('public.album_id_alb_seq'::regclass);


--
-- Name: artiste id_art; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artiste ALTER COLUMN id_art SET DEFAULT nextval('public.artiste_id_art_seq'::regclass);


--
-- Name: groupe id_grp; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groupe ALTER COLUMN id_grp SET DEFAULT nextval('public.groupe_id_grp_seq'::regclass);


--
-- Name: morceau id_mor; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.morceau ALTER COLUMN id_mor SET DEFAULT nextval('public.morceau_id_mor_seq'::regclass);


--
-- Name: playlist id_pl; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.playlist ALTER COLUMN id_pl SET DEFAULT nextval('public.playlist_id_pl_seq'::regclass);


--
-- Data for Name: album; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.album (id_alb, nom_album, couverture, date_sortie, description, id_grp) FROM stdin;
1	Born Pink	couverturebornpink	2023-09-16	BLACKPINK in your area	1
2	Square Up	couverturesquareup	2016-09-16	tchang TCHANG	1
3	Pink Whistle	couverturepinkvenom	2023-09-16	Taste that Venom	1
4	Made	couverturemade	2016-09-16	Made in China	2
5	Behdja	couverturebehdja	1980-09-16	Behdja Biydha	4
6	Dystopia	couverturedystopia	2021-09-16	It's lit	6
7	Paradise City	couvertureparadisecity	2012-09-16	Heavens	12
8	Blue	couvertureblue	2023-09-16	Red	2
9	La Vie En Rose	couverturelavieenrose	1947-09-16	Tout est rose	10
10	Non Je Ne Regrette Rien	couverturenon	1960-09-16	Rien de rien	10
11	Love Yourself	couvertureloveyourself	2017-01-24	Love is everywhere	11
12	The Marshall Mathers LP	couverturemarshall	2000-05-23	The white Black Man	7
13	Appetite For Destruction	couvertureappetite	2023-07-21	Enjoy your meal	12
14	Use Your Illusion	couvertureuse	1991-09-17	Hypnose	12
15	BTS The Best	couverturebts	2022-06-19	FIRE	11
16	Lettre Ouverte	couverturelettre	1998-01-05	Monsieur le président	5
17	Y a Renaud y a Le Renard	couverturerenaud	1980-01-05	Toujours vivant	3
18	L'École des points vitaux	lien_couverture_ecole_points_vitaux.jpg	2010-03-29	WATI HOUSE	13
19	Subliminal	lien_couverture_subliminal.jpg	2013-05-20	Imagine moi sans lunettes	14
20	Les yeux plus gros que le monde	lien_couverture_yeux_plus_gros_que_le_monde.jpg	2014-03-31	Merci madame Pavoshko	15
21	Le chant des sirènes	lien_couverture_sirenes.jpg	2011-09-26	Je porte un toast à la mort de l'industrie	16
22	Feu	lien_couverture_nekfeu.jpg	2016-12-02	J'entends les bruits qui courent	17
23	Ipseité	lien_couverture_damso.jpg	2017-04-28	Batterie faible m'a fait perdre beaucoup d'amis	18
24	A Night at the Opera	lien_couverture_queen.jpg	1975-11-21	MaMAAAAAAAAAAAAA	19
25	Scorpions	lien_couverture_Scorpions.jpg	2023-11-21	21 CAN YOU DO SOMETHING FOR ME	20
26	Sendu	lien_couverture_Sendu.jpg	2023-11-21	faites-vous plaisir	9
\.


--
-- Data for Name: artiste; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.artiste (id_art, nom, prenom, nationalite, date_n, date_d) FROM stdin;
1	Kim	Jisoo	Korean	1995-01-03	\N
2	Kim	Jennie	Korean	1996-01-16	\N
3	Manoban	Lisa	Thai	1997-03-27	\N
4	Park	Chaeyoung	Australian	1997-02-11	\N
5	Kwon	Jiyong	Korean	1988-08-18	\N
6	Choi	Seunghyun	Korean	1987-11-04	\N
7	Dong	Youngbae	Korean	1988-05-18	\N
8	Kang	Daesung	Korean	1989-04-26	\N
9	Lee	Seunghyun	Korean	1990-12-12	\N
10	Matoub	Lounes	Algerian	1956-01-24	1998-06-25
11	Séchan	Renaud	French	1952-05-11	\N
12	Harrachi	Dehmane	Algerian	1926-02-24	1980-08-31
13	Webster	Jacques	American	1991-04-30	\N
14	Kim	Nam-joon	South Korean	1994-09-12	\N
15	Kim	Seok-jin	South Korean	1992-12-04	\N
16	Min	Yoon-gi	South Korean	1993-03-09	\N
17	Jung	Ho-seok	South Korean	1994-02-18	\N
18	Park	Ji-min	South Korean	1995-10-13	\N
19	Kim	Tae-hyung	South Korean	1995-12-30	\N
20	Jeon	Jung-kook	South Korean	1997-09-01	\N
21	Piaf	Edith	French	1915-12-19	1963-10-10
22	West	Kanye	American	1977-06-08	\N
23	Mathers	Marshall	American	1972-10-17	\N
24	Cheriet	Hamid	Algerian	1949-10-25	\N
25	Rose	Axl	American	1962-02-06	\N
26	McKagan	Duff	American	1964-02-05	\N
27	saul	hudson	British-American	1965-07-23	\N
28	Stradlin	Izzy	American	1962-04-08	\N
29	Adler	Steven	American	1965-01-22	\N
30	Djuna	Gandhi	French	1986-05-06	\N
31	Fall	Karim	French	1985-11-28	\N
32	Magassouba	Abou	French	1985-07-24	\N
33	Baccour	Bachir	French	1985-01-28	\N
34	Diallo	Alpha	French	1984-12-27	\N
35	Ndonga	Amos	French	1984-11-30	\N
36	Aurelien	Cotentin	French	1982-08-01	\N
37	Ken	Samaras	French	1990-04-03	\N
38	William	Kalubi Mwamba	Belgian	1992-05-10	\N
39	Freddie	Mercury	British	1946-09-05	\N
40	Brian	May	British	1947-07-19	\N
41	Roger	Taylor	British	1949-07-26	\N
42	John	Deacon	British	1951-08-19	\N
43	Aubrey	Graham	Canadian	1986-10-24	\N
\.


--
-- Data for Name: contient; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contient (id_alb, id_mor, num_tracklist) FROM stdin;
1	1	1
1	2	2
1	3	3
2	29	1
2	30	2
2	31	3
6	10	1
6	11	2
6	12	3
6	13	3
7	20	1
7	21	2
7	22	3
8	31	1
8	32	2
4	4	1
4	5	2
3	6	1
9	23	1
9	24	2
10	25	2
11	14	1
11	15	2
12	17	1
12	18	2
12	19	3
13	20	1
13	22	2
13	21	3
14	20	1
14	21	2
14	22	3
15	16	2
16	26	1
16	27	2
18	34	1
18	35	2
18	36	3
18	37	4
18	38	5
19	39	1
19	40	2
19	41	3
19	42	4
19	43	5
20	44	1
20	45	2
20	46	3
20	47	4
20	48	5
21	49	1
21	50	2
21	51	3
21	52	4
21	53	5
22	54	1
22	55	2
22	56	3
22	57	4
22	58	5
23	59	1
23	60	2
23	61	3
23	62	4
23	63	5
24	64	1
24	65	2
24	66	3
24	67	4
24	68	5
25	75	1
25	76	2
25	77	3
26	72	1
26	73	2
17	74	1
17	8	2
\.


--
-- Data for Name: ecoute; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ecoute (id_mor, pseudo, date_ecoute) FROM stdin;
1	drose_x9	2023-12-05 15:30:02
1	drose_x9	2023-12-05 15:31:02
2	drose_x9	2023-12-05 15:33:00
1	drose_x9	2023-12-05 15:32:02
3	drose_x9	2023-12-05 15:39:02
7	drose_x9	2023-12-05 14:30:02
1	marie	2023-12-10 15:30:02
1	marie	2023-12-10 15:30:05
8	drose_x9	2023-12-10 15:30:02
7	drose_x9	2023-12-10 15:30:02
4	ghiles	2023-12-10 15:30:02
4	ghiles	2023-12-10 15:30:04
4	drose_x9	2023-12-10 15:30:02
8	miguel	2023-12-10 15:30:02
2	ghiles	2023-12-10 15:30:02
6	drose_x9	2023-12-10 15:30:02
9	marie	2023-12-10 15:30:02
5	ghiles	2023-12-10 15:30:02
10	drose_x9	2023-12-10 15:30:02
58	Olteron	2023-12-17 17:43:25
58	Olteron	2023-12-17 17:43:28
58	Olteron	2023-12-17 17:43:31
58	Olteron	2023-12-17 17:44:55
58	Olteron	2023-12-17 17:44:58
58	Olteron	2023-12-17 17:45:00
58	Olteron	2023-12-17 17:45:02
58	Olteron	2023-12-17 17:45:05
58	Olteron	2023-12-17 17:45:06
52	Olteron	2023-12-17 17:49:09
52	Olteron	2023-12-17 17:49:38
52	Olteron	2023-12-17 17:49:42
52	Olteron	2023-12-17 17:49:43
52	Olteron	2023-12-17 17:49:46
52	Olteron	2023-12-17 17:49:57
52	Olteron	2023-12-17 17:49:59
52	Olteron	2023-12-17 17:50:01
52	Olteron	2023-12-17 17:50:02
52	Olteron	2023-12-17 17:50:04
52	Olteron	2023-12-17 17:50:06
61	Olteron	2023-12-17 17:50:27
61	Olteron	2023-12-17 17:50:30
61	Olteron	2023-12-17 17:50:32
61	Olteron	2023-12-17 17:50:33
61	Olteron	2023-12-17 17:50:35
61	Olteron	2023-12-17 17:50:36
53	Olteron	2023-12-17 17:50:53
53	Olteron	2023-12-17 17:50:55
53	Olteron	2023-12-17 17:50:56
53	Olteron	2023-12-17 17:50:57
53	Olteron	2023-12-17 17:50:58
53	Olteron	2023-12-17 17:50:59
53	Olteron	2023-12-17 17:51:00
53	Olteron	2023-12-17 17:51:02
53	Olteron	2023-12-17 17:51:03
64	Olteron	2023-12-17 17:51:15
64	Olteron	2023-12-17 17:51:16
64	Olteron	2023-12-17 17:51:17
64	Olteron	2023-12-17 17:51:18
64	Olteron	2023-12-17 17:51:21
64	Olteron	2023-12-17 17:51:22
52	Momo	2023-12-17 18:12:05
58	Momo	2023-12-17 18:12:08
53	Momo	2023-12-17 18:12:11
64	Momo	2023-12-17 18:12:14
61	Momo	2023-12-17 18:12:16
61	Momo	2023-12-17 18:12:21
6	Momo	2023-12-17 18:12:29
6	Momo	2023-12-17 18:12:34
6	Momo	2023-12-17 18:12:36
6	Momo	2023-12-17 18:12:37
6	Momo	2023-12-17 18:12:38
6	Momo	2023-12-17 18:12:39
6	Momo	2023-12-17 18:12:40
6	Momo	2023-12-17 18:12:41
6	Momo	2023-12-17 18:12:42
6	Momo	2023-12-17 18:12:43
6	Momo	2023-12-17 18:12:45
6	Momo	2023-12-17 18:12:46
6	Momo	2023-12-17 18:12:47
7	Momo	2023-12-17 18:13:07
7	Momo	2023-12-17 18:13:08
7	Momo	2023-12-17 18:13:09
7	Momo	2023-12-17 18:13:10
7	Momo	2023-12-17 18:13:11
26	Momo	2023-12-17 18:13:16
26	Momo	2023-12-17 18:13:18
26	Momo	2023-12-17 18:13:19
27	Momo	2023-12-17 18:13:25
27	Momo	2023-12-17 18:13:27
27	Momo	2023-12-17 18:13:28
27	Momo	2023-12-17 18:13:29
27	Momo	2023-12-17 18:13:30
27	Momo	2023-12-17 18:13:31
55	clara_la_blonde	2023-12-17 18:26:06
55	clara_la_blonde	2023-12-17 18:26:13
55	clara_la_blonde	2023-12-17 18:26:15
55	clara_la_blonde	2023-12-17 18:26:16
55	clara_la_blonde	2023-12-17 18:26:17
55	clara_la_blonde	2023-12-17 18:26:18
55	clara_la_blonde	2023-12-17 18:26:19
55	clara_la_blonde	2023-12-17 18:26:20
55	clara_la_blonde	2023-12-17 18:26:21
55	clara_la_blonde	2023-12-17 18:26:23
55	clara_la_blonde	2023-12-17 18:26:24
55	clara_la_blonde	2023-12-17 18:26:25
55	clara_la_blonde	2023-12-17 18:26:26
55	clara_la_blonde	2023-12-17 18:26:27
55	clara_la_blonde	2023-12-17 18:26:28
55	clara_la_blonde	2023-12-17 18:26:29
55	clara_la_blonde	2023-12-17 18:26:30
55	clara_la_blonde	2023-12-17 18:26:31
55	clara_la_blonde	2023-12-17 18:26:32
55	clara_la_blonde	2023-12-17 18:26:33
52	clara_la_blonde	2023-12-17 18:26:43
52	clara_la_blonde	2023-12-17 18:26:51
52	clara_la_blonde	2023-12-17 18:27:00
52	clara_la_blonde	2023-12-17 18:27:03
52	clara_la_blonde	2023-12-17 18:27:04
52	clara_la_blonde	2023-12-17 18:28:04
54	clara_la_blonde	2023-12-17 18:28:41
54	clara_la_blonde	2023-12-17 18:28:46
54	clara_la_blonde	2023-12-17 18:28:48
54	clara_la_blonde	2023-12-17 18:28:49
54	clara_la_blonde	2023-12-17 18:28:50
54	clara_la_blonde	2023-12-17 18:28:51
54	clara_la_blonde	2023-12-17 18:28:59
54	clara_la_blonde	2023-12-17 18:29:04
54	clara_la_blonde	2023-12-17 18:29:07
54	clara_la_blonde	2023-12-17 18:29:11
54	clara_la_blonde	2023-12-17 18:29:13
17	miguel	2023-12-17 18:31:45
17	miguel	2023-12-17 18:31:47
17	miguel	2023-12-17 18:31:48
17	miguel	2023-12-17 18:31:49
17	miguel	2023-12-17 18:31:50
17	miguel	2023-12-17 18:31:51
17	miguel	2023-12-17 18:31:52
19	miguel	2023-12-17 18:32:08
19	miguel	2023-12-17 18:32:10
19	miguel	2023-12-17 18:32:11
19	miguel	2023-12-17 18:32:12
19	Mike Oxlong	2023-12-17 18:41:26
19	Mike Oxlong	2023-12-17 18:41:29
19	Mike Oxlong	2023-12-17 18:41:32
19	Mike Oxlong	2023-12-17 18:41:33
19	Mike Oxlong	2023-12-17 18:41:34
17	Mike Oxlong	2023-12-17 18:41:39
17	Mike Oxlong	2023-12-17 18:41:41
17	Mike Oxlong	2023-12-17 18:41:42
17	Mike Oxlong	2023-12-17 18:41:43
17	Mike Oxlong	2023-12-17 18:41:44
17	Mike Oxlong	2023-12-17 18:41:45
17	Mike Oxlong	2023-12-17 18:41:46
18	Mike Oxlong	2023-12-17 18:41:53
18	Mike Oxlong	2023-12-17 18:41:55
18	Mike Oxlong	2023-12-17 18:41:57
18	Mike Oxlong	2023-12-17 18:41:58
18	Mike Oxlong	2023-12-17 18:42:05
18	Mike Oxlong	2023-12-17 18:42:12
18	Mike Oxlong	2023-12-17 18:42:13
10	Mike Oxlong	2023-12-17 18:42:39
10	Mike Oxlong	2023-12-17 18:42:41
10	Mike Oxlong	2023-12-17 18:42:42
10	Mike Oxlong	2023-12-17 18:42:44
10	Mike Oxlong	2023-12-17 18:42:45
10	Mike Oxlong	2023-12-17 18:42:47
10	Mike Oxlong	2023-12-17 18:42:55
10	Mike Oxlong	2023-12-17 18:42:58
10	Mike Oxlong	2023-12-17 18:43:00
10	Mike Oxlong	2023-12-17 18:43:01
10	Mike Oxlong	2023-12-17 18:43:02
10	Mike Oxlong	2023-12-17 18:43:03
10	Mike Oxlong	2023-12-17 18:43:04
10	Mike Oxlong	2023-12-17 18:43:05
11	Mike Oxlong	2023-12-17 18:43:09
11	Mike Oxlong	2023-12-17 18:43:11
11	Mike Oxlong	2023-12-17 18:43:12
11	Mike Oxlong	2023-12-17 18:43:15
11	Mike Oxlong	2023-12-17 18:43:16
11	Mike Oxlong	2023-12-17 18:43:17
11	Mike Oxlong	2023-12-17 18:43:18
11	Mike Oxlong	2023-12-17 18:43:19
12	Mike Oxlong	2023-12-17 18:43:25
12	Mike Oxlong	2023-12-17 18:43:27
12	Mike Oxlong	2023-12-17 18:43:28
12	Mike Oxlong	2023-12-17 18:43:29
12	Mike Oxlong	2023-12-17 18:43:30
12	Mike Oxlong	2023-12-17 18:43:31
12	Mike Oxlong	2023-12-17 18:43:32
13	Mike Oxlong	2023-12-17 18:43:43
13	Mike Oxlong	2023-12-17 18:43:44
13	Mike Oxlong	2023-12-17 18:43:45
13	Mike Oxlong	2023-12-17 18:43:46
13	Mike Oxlong	2023-12-17 18:43:47
13	Mike Oxlong	2023-12-17 18:43:49
\.


--
-- Data for Name: est_abonne; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.est_abonne (pseudo, id_grp) FROM stdin;
drose_x9	1
drose_x9	2
drose_x9	5
ghiles	4
ghiles	5
marie	3
miguel	1
miguel	2
miguel	3
miguel	4
miguel	5
Olteron	13
Olteron	14
Olteron	15
Olteron	16
Olteron	17
Olteron	18
Olteron	19
Momo	5
Momo	1
Momo	4
Momo	3
Momo	2
Momo	17
Momo	18
Momo	16
Momo	9
clara_la_blonde	17
Mike Oxlong	7
Mike Oxlong	8
Mike Oxlong	6
\.


--
-- Data for Name: est_dans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.est_dans (id_pl, id_mor, numero_track) FROM stdin;
1	1	1
1	2	2
1	3	3
1	4	4
1	5	5
2	1	1
2	3	2
3	6	1
3	7	2
4	1	1
4	2	2
4	3	3
4	4	4
4	5	4
4	6	6
4	7	7
4	8	8
5	8	1
5	1	2
6	34	\N
6	35	\N
6	36	\N
6	37	\N
6	38	\N
6	39	\N
6	40	\N
6	41	\N
6	42	\N
6	43	\N
6	44	\N
6	45	\N
6	46	\N
6	47	\N
6	48	\N
6	49	\N
6	50	\N
6	51	\N
6	52	\N
6	53	\N
6	54	\N
6	55	\N
6	56	\N
6	57	\N
6	58	\N
6	59	\N
6	60	\N
6	61	\N
6	62	\N
6	63	\N
3	52	\N
7	7	\N
7	26	\N
7	27	\N
7	6	\N
8	55	\N
4	17	\N
4	19	\N
9	10	\N
9	11	\N
9	13	\N
9	17	\N
9	18	\N
9	19	\N
\.


--
-- Data for Name: fait_partie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fait_partie (id_art, id_grp, role, date_arr, date_dep) FROM stdin;
1	1	Visual	2016-08-08	\N
1	1	Vocalist	2016-08-08	\N
2	1	Rapper	2016-08-08	\N
3	1	Dancer	2016-08-08	\N
3	1	Rapper	2016-08-08	\N
4	1	Vocalist	2016-08-08	\N
5	2	Leader	2006-08-19	\N
5	2	Rapper	2006-08-19	\N
6	2	Rapper	2006-08-19	\N
7	2	Vocalist	2006-08-19	\N
8	2	Vocalist	2006-08-19	\N
9	2	Vocalist	2006-08-19	2019-03-11
10	5	Rebel	1978-01-01	\N
11	3	Singer	1975-01-01	\N
12	4	Singer	1970-01-01	\N
13	6	Rapper	2008-01-01	\N
14	11	Leader	2013-06-13	\N
15	11	Singer	2013-06-13	\N
16	11	Rapper	2013-06-13	\N
17	11	Rapper	2013-06-13	\N
18	11	Singer	2013-06-13	\N
19	11	Singer	2013-06-13	\N
20	11	Singer	2013-06-13	\N
21	10	Singer	1935-01-01	\N
22	8	Rapper	2000-01-01	\N
23	7	Rapper	1996-01-01	\N
25	12	Singer	1985-01-01	\N
26	12	Guitarist	1985-01-01	\N
27	12	Bassist	1985-01-01	\N
28	12	Drummer	1985-01-01	\N
29	12	Singer	1985-01-01	\N
30	14	Rapper	2013-01-01	\N
34	15	Rapper	2016-01-01	\N
30	13	Rapper	2002-01-01	\N
31	13	Rapper	2002-01-01	\N
32	13	Rapper	2002-01-01	\N
33	13	Rapper	2002-01-01	\N
34	13	Rapper	2002-01-01	\N
36	16	Singer	2008-01-01	\N
37	17	Singer	2010-01-01	\N
38	18	Rapper	2014-01-01	\N
39	19	Singer	1970-01-01	\N
40	19	Guitarist	1970-01-01	\N
41	19	Drummer	1970-01-01	\N
42	19	Bassist	1970-01-01	\N
43	20	Solo	2008-05-03	\N
24	9	Solo	2008-05-03	\N
\.


--
-- Data for Name: groupe; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.groupe (id_grp, nom_groupe, nationalite_g, genre) FROM stdin;
1	Blackpink	Korean	K-pop
2	Bigbang	Korean	K-pop
3	Renaud	French	Chanson française
4	Dehmane Al Harrachi	Algerian	Chaabi
5	Matoub Lounes	Algerian	Chanson kabyle
6	Travis Scott	American	Rap
7	Eminem	American	Rap
8	Kanye West	American	Rap
9	Idir	Algerian	World Music
10	Edith Piaf	French	Chanson française
11	Bts	South-Korean	K-Pop
12	Guns N Roses	American	Hard Rock
13	Sexion d'Assaut	French	Rap
14	Maître Gims	French	Rap
15	Black M	French	Rap
16	Orelsan	French	Rap
17	Nekfeu	French	Rap
18	Damso	Belgian	Rap
19	Queen	British	Rock
20	Drake	Canadian	Rap
\.


--
-- Data for Name: mets_album_favoris; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mets_album_favoris (pseudo, id_alb) FROM stdin;
Olteron	23
Olteron	22
Momo	8
Momo	3
Momo	1
Momo	13
Momo	15
clara_la_blonde	22
miguel	12
Mike Oxlong	6
Mike Oxlong	12
\.


--
-- Data for Name: mets_en_favoris; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mets_en_favoris (pseudo, id_mor) FROM stdin;
Olteron	61
Olteron	53
Olteron	52
Olteron	51
Olteron	54
Olteron	56
Olteron	57
Olteron	58
Olteron	60
Olteron	64
Olteron	65
Momo	52
Momo	58
Momo	53
Momo	64
Momo	61
Momo	4
Momo	1
Momo	8
Momo	5
clara_la_blonde	55
miguel	17
miguel	19
Mike Oxlong	10
Mike Oxlong	11
Mike Oxlong	12
Mike Oxlong	13
Mike Oxlong	17
Mike Oxlong	18
Mike Oxlong	19
\.


--
-- Data for Name: morceau; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.morceau (id_mor, titre, duree, audio, paroles, date_pub, id_grp) FROM stdin;
1	Boombayah	00:03:30	audioboombayah	BLACKPINK in your area (Hot) BLACKPINK in your area Been a bad girl, I know I am And I'm so hot, I need a fan I don't want a boy, I need a man Click-clack, bada bing, bada boom 문을 박차면 모두 날 바라봄 굳이 애써 노력 안 해도 모든 남자들은 코피가 팡팡팡 (팡팡 파라파라 팡팡팡) 지금 날 위한 축배를 짠짠짠 (Hands up) 내 손엔 bottle full o' Henny 니가 말로만 듣던 걔가 나야 Jennie 춤추는 불빛은 날 감싸고 도네 Black to the Pink 어디서든 특별해 (Oh, yes) 쳐다 보든 말든 I wanna dance Like 따라다라단딴 따라다라단딴 뚜루룹바우 좋아, 이 분위기가 좋아 좋아, 난 지금 니가 좋아 정말 반했어 오늘 밤 너와 춤추고 싶어 붐바야 (ah!) Yah-yah-yah 붐바야 Yah-yah-yah 붐바야 yah-yah-yah-yah 붐붐바 붐붐바 (오빠!) Yah-yah-yah, yah-yah-yah, yah-yah-yah-yah (loo-loo-loo-loo) Yah-yah-yah, yah-yah-yah, yah-yah-yah-yah (오빠!) Yah-yah-yah, yah-yah-yah, yah-yah-yah-yah (loo-loo-loo-loo) Yah-yah-yah, yah-yah-yah-yah 붐붐바 붐바야 BLACKPINK in your area Oh 이제 달려야지, 뭘 어떡해? 난 철없어, 겁없어 man Middle finger up, F-U pay me '90s baby, I pump up the jam 달려봐, 달려봐, 오빠야 Lambo 오늘은 너와 나 젊음을 gamble 감히 날 막지마, 혹시나 누가 날 막아도 I'ma go brr, Rambo 니 손이 내 허리를 감싸고 도네 Front to my back 내 몸매는 특별해 (Oh, yes) 니 눈빛은 I know you wanna touch Like touch, touch, tou-tou-touch 뚜루룹바우 좋아, 이 분위기가 좋아 좋아, 난 지금 니가 좋아 정말 멋있어 오늘 밤 너와 춤추고 싶어 붐바야 (ah!) Yah-yah-yah 붐바야 Yah-yah-yah 붐바야 yah-yah-yah-yah 붐붐바 붐붐바 (오빠!) Yah-yah-yah, yah-yah-yah, yah-yah-yah-yah (loo-loo-loo-loo) Yah-yah-yah, yah-yah-yah, yah-yah-yah-yah (오빠!) Yah-yah-yah, yah-yah-yah, yah-yah-yah-yah (loo-loo-loo-loo) Yah-yah-yah, yah-yah-yah-yah 붐붐바 붐바야 오늘은 맨 정신 따윈 버리고 (loo-loo-loo-loo) 하늘을 넘어서 올라 갈 거야 (loo-loo-loo-loo) 끝을 모르게 빨리 달리고 싶어 Let's go (hoo-ooh) Let's go (hoo-ooh) 오늘은 맨 정신 따윈 버리고 (loo-loo-loo-loo) 하늘을 넘어서 올라 갈 거야 (loo-loo-loo-loo) 끝을 모르게 빨리 달리고 싶어 Let's go (hoo-ooh) Let's go (hoo-ooh)	2016-08-08	1
2	Whistle	00:03:30	audiowhistle	Hey, boy Make 'em whistle like a missile bomb, bomb Every time I show up, blow up, uh Make 'em whistle like a missile bomb, bomb Every time I show up, blow up, uh 넌 너무 아름다워, 널 잊을 수가 없어 그 눈빛이 아직 나를 이렇게 설레게 해, boom, boom 24, 365, 오직 너와 같이 하고파 낮에도, 이 밤에도, 이렇게 너를 원해, mmm, mmm Yeah, 모든 남자들이 날 매일 check out 대부분이 날 가질 수 있다 착각 절대 많은 걸 원치 않아, 맘을 원해 난 (uh) 넌 심장을 도려내 보여봐 아주 씩씩하게, 때론 chic, chic 하게 So hot, so hot, 내가 어쩔 줄 모르게 해 (uh) 나지막이 불러줘 내 귓가에 도는 휘파람처럼 이대로 지나치지 마요 너도 나처럼 날 잊을 수가 없다면, whoa 널 향한 이 마음은 fire 내 심장이 빠르게 뛰잖아 점점 가까이 들리잖아 휘파람, uh 휘파람, 파람, 파람 (can you hear that?) 휘-파라-파라-파라-밤 휘파람, uh 휘파람, 파람, 파람 (can you hear that?) 휘-파라-파라-파라-밤 (hold up) 아무 말 하지 마, just whistle to my heart 그 소리가 지금 나를 이렇게 설레게 해, boom, boom 생각은 지루해, 느낌이, shh Every day, all day, 내 곁에만 있어 줘, zoom, zoom Uh, 언제나 난 stylin' 도도하지만 네 앞에선 darlin' 뜨거워지잖아, like a desert island 너 알아갈수록 울려대는 마음속 그만 내빼 넘어와라 내게, boy 이젠 checkmate, 게임은 내가 win (uh-huh) 난 널 택해, 안아줘 더 세게 누가 널 가로 채 가기 전에 내가 (uh) 이대로 지나치지 마요 너도 나처럼 날 잊을 수가 없다면, whoa 널 향한 이 마음은 fire 내 심장이 빠르게 뛰잖아 점점 가까이 들리잖아 휘파람, uh 휘파람, 파람, 파람 (can you hear that?) 휘-파라-파라-파라-밤 휘파람, uh 휘파람, 파람, 파람 (can you hear that?) 휘-파라-파라-파라-밤 This beat got me feelin' like 바람처럼 스쳐가는 흔한 인연이 아니길 많은 말은 필요 없어 지금 너의 곁에 나를 데려가 줘, ooh Make 'em whistle like a missile bomb, bomb Every time I show up, blow up, uh Make 'em whistle like a missile bomb, bomb Every time I show up, blow up, uh	2016-08-08	1
3	Pinkvenom	00:03:30	audiopinkvenom	Blackpink Blackpink Blackpink Blackpink Kick in the door, waving the coco' 팝콘이나 챙겨 껴들 생각 말고 I talk that talk, runways I walk-walk 눈 감고, pop-pop, 안 봐도 척 One by one, then two by two 내 손끝 툭 하나에 다 무너지는 중 가짜 쇼 치곤 화려했지 Makes no sense, you couldn't get a dollar out of me 자, 오늘 밤이야, 난 독을 품은 꽃 네 혼을 빼앗은 다음, look what you made us do 천천히 널 잠재울 fire 잔인할 만큼 아름다워 (I bring the pain like) This that pink venom, this that pink venom This that pink venom (get 'em, get 'em, get 'em) Straight to ya dome like whoa-whoa-whoa Straight to ya dome like ah-ah-ah Taste that pink venom, taste that pink venom Taste that pink venom (get 'em, get 'em, get 'em) Straight to ya dome like whoa-whoa-whoa Straight to ya dome like ah-ah-ah Black paint and ammo', got bodies like Rambo Rest in peace, please, light up a candle This the life of a vandal, masked up, and I'm still in CELINE Designer crimes, or it wouldn't be me, ooh! Diamonds shining, drive in silence, I don't mind it, I'm riding Flying private side by side with the pilot up in the sky And I'm wyling, styling on them and there's no chance 'Cause we got bodies on bodies like this a slow dance 자, 오늘 밤이야, 난 독을 품은 꽃 네 혼을 빼앗은 다음, look what you made us do 천천히 널 잠재울 fire 잔인할 만큼 아름다워 (I bring the pain like) This that pink venom, this that pink venom This that pink venom (get 'em, get 'em, get 'em) Straight to ya dome like whoa-whoa-whoa Straight to ya dome like ah-ah-ah Taste that pink venom, taste that pink venom Taste that pink venom (get 'em, get 'em, get 'em) Straight to ya dome like whoa-whoa-whoa Straight to ya dome like ah-ah-ah 원한다면 provoke us 감당 못해 and you know this 이미 퍼져버린 shot that potion 네 눈앞은 핑크빛 ocean Come and give me all the smoke 도 아니면 모 like I'm so rock and roll Come and give me all the smoke 다 줄 세워 봐, 자, stop, drop (I bring the pain like) 라타타타, 트라타타타 라타타타, 트라타타타 라타타타, 트라타타타 Straight to ya, straight to ya, straight to ya dome like 라타타타, 트라타타타 (BLACKPINK) 라타타타, 트라타타타 (BLACKPINK) 라타타타, 트라타타타 (BLACKPINK) I bring the pain like-	2023-08-26	1
4	Blues	00:03:40	audioblue	겨울이 가고 봄이 찾아오죠 우린 시들고 그리움 속에 맘이 멍들었죠 (I'm singing my blues) 파란 눈물에 파란 슬픔에 길들여져 (I'm singing my blues) 뜬구름에 날려보낸 사랑 oh oh 같은 하늘 다른 곳 너와나 위험하니까 너에게서 떠나주는 거야 님이란 글자에 점하나 비겁하지만 내가 못나 숨는 거야 잔인한 이별은 사랑의 末路(말로) 그 어떤 말도 위로 될 수는 없다고 아마 내 인생의 마지막 멜로 막이 내려오네요 이제 태어나서 널 만나고 죽을 만큼 사랑하고 파랗게 물들어 시린 내 마음 눈을 감아도 널 느낄 수 없잖아 겨울이 가고 봄이 찾아오죠 우린 시들고 그리움 속에 맘이 멍들었죠 (I'm singing my blues) 파란 눈물에 파란 슬픔에 길들여져 (I'm singing my blues) 뜬구름에 날려보낸 사랑 oh oh 심장이 멎은 것 만 같아 전쟁이 끝나고 그 곳에 얼어 붙은 너와나 내 머릿속 새겨진 Trauma 이 눈물 마르면 촉촉히 기억하리 내 사랑 괴롭지도 외롭지도 않아 행복은 다 혼잣말 그 이상에 복잡한 건 못 참아 대수롭지 아무렇지도 않아 별수없는 방황 사람들은 왔다 간다 태어나서 널 만나고 죽을 만큼 사랑하고 파랗게 물들어 시린 내 마음 너는 떠나도 난 그대로 있잖아 겨울이 가고 봄이 찾아오죠 우린 시들고 그리움 속에 맘이 멍들었죠 오늘도 파란 저 달빛아래에 나 홀로 잠이 들겠죠 꿈속에서도 난 그대를 찾아 헤매이며 이 노래를 불러요 (I'm singing my blues) 파란 눈물에 파란 슬픔에 길들여져 (I'm singing my blues) 뜬구름에 날려보낸 사랑 oh oh (I'm singing my blues) 파란 눈물에 파란 슬픔에 길들여져 (I'm singing my blues) 뜬구름에 날려보낸 사랑 oh oh	2013-10-08	2
5	Haruharu	00:03:40	audioharuharu	떠나가 Yeah Finally, I realize That I'm nothing without you I was wrong, forgive me Ah, ah, ah, ah Ah-ah-ah, ah, ah, ah, ah, ah 파도처럼 부숴진 내 맘 바람처럼 흔들리는 내 맘 연기처럼 사라진 내 사랑 문신처럼 지워지지 않아 한숨만 땅이 꺼지라 쉬죠 (oh, oh, oh, oh, oh) 가슴 속에 먼지만 쌓이죠 (say goodbye) Yeah 네가 없인 단 하루도 못 살 것만 같았던 나 생각과는 다르게도 그럭저럭 혼자 잘 살아 보고 싶다고 불러봐도 넌 아무 대답 없잖아 헛된 기대 걸어봐도 이젠 소용없잖아 (oh) 니 옆에 있는 그 사람이 뭔지, 혹시 널 울리진 않는지 그대 내가 보이긴 하는지, 벌써 싹 다 잊었는지 걱정돼 다가가기조차 말을 걸 수조차 없어 애태우고 나 홀로 밤을 지새우죠, 수백 번 지워내죠 돌아보지 말고 떠나가라 또 나를 찾지 말고 살아가라 너를 사랑했기에 후회 없기에 좋았던 기억만 가져가라 그럭저럭 참아볼 만해 그럭저럭 견뎌낼 만해 넌 그럴수록 행복해야 돼 하루하루 무뎌져 가네 Oh, girl, I cry, cry You're my all, say goodbye 길을 걷다 너와 나 우리 마주친다 해도 못 본 척하고서 그대로 가던 길 가줘 자꾸만 옛 생각이 떠오르면 아마도 나도 몰래 그댈 찾아갈지도 몰라 넌 늘 그 사람과 행복하게 (yeah) 넌 늘 내가 다른 맘 안 먹게 (right) 넌 늘 작은 미련도 안 남게끔 (oh) 잘 지내줘 나 보란 듯이 넌 늘 저 하늘같이 하얗게 뜬구름과도 같이 새파랗게 넌 늘 그래 그렇게 웃어줘 아무 일 없듯이 돌아보지 말고 떠나가라 또 나를 찾지 말고 살아가라 너를 사랑했기에 후회 없기에 좋았던 기억만 가져가라 그럭저럭 참아볼 만해 그럭저럭 견뎌낼 만해 넌 그럴수록 행복해야 돼 하루하루 무뎌져 가네-eh-eh-eh 나를 떠나서 맘 편해지길 나를 잊고서 살아가 줘 그 눈물은 다 마를 테니 yeah 하루하루 지나면 차라리 만나지 않았더라면 덜 아플 텐데 ooh 영원히 함께하자던 그 약속 이젠 추억에 묻어두길 바래 baby 널 위해 기도해 (돌아보지 말고 떠나가라) 또 나를 찾지 말고 살아가라 (날 찾지 말고서) 너를 사랑했기에 후회 없기에 좋았던 기억만 가져가라 (내 기억까지도) 그럭저럭 참아볼 만해 (참아볼 만해) 그럭저럭 견뎌낼 만해 (난 견뎌낼 만해) 넌 그럴수록 행복해야 돼 (oh) 하루하루 무뎌져 가네-eh-eh-eh Oh, girl, I cry, cry You're my all, say goodbye-bye Oh, my love, don't lie, lie You're my heart, say goodbye	2023-10-30	2
6	Ya Rayah	00:03:40	audioyarayah	يا الرايح يا الرَايح وين مسافر تروح تعيا وتولي شحال ندموا العباد الغافلين قبلك وقبلي يا الرَايح وين مسافر تروح تعيا وتولي شحال ندموا العباد الغافلين قبلك وقبلي شحال شفت البلدان العامرين والبر الخالي شحال ضيعت اوقات وشحال تزيد ما زال تخلي يا الغايب في بلاد الناس شحال تعيا ما تجري بـِيك وعد القدرة ولّى زمان وانت ما تدري يا الرَايح وين مسافر تروح تعيا وتولي شحال ندموا العباد الغافلين قبلك وقبلي يا الرَايح وين مسافر تروح تعيا وتولي شحال ندموا العباد الغافلين قبلك وقبلي يا مسافر نعطيك وصايتي ادّيها على بكري شوف ما يصلح بيك قبل ما تبيع وما تشري يا النايم جاني خبرك كيما صرالك يصرى لي هكذا راد وقدر في الجبين سبحان العالي يا الرَايح وين مسافر تروح تعيا وتولي شحال ندموا العباد الغافلين قبلك وقبلي يا الرَايح وين مسافر تروح تعيا وتولي شحال ندموا العباد الغافلين قبلك وقبلي علاش قلبك حزين وعلاش هكذا كي الزاوالي ما تدوم الشدة والى قريب تعلم وتدري يا الغايب في بلاد الناس شحال تعيا ما تجري يا حليلو مسكين اللي غاب سعدو كي زَهري يا الرَايح وين مسافر تروح تعيا وتولي شحال ندموا العباد الغافلين قبلك وقبلي يا الرَايح وين مسافر تروح تعيا وتولي شحال ندموا العباد الغافلين قبلك وقبلي يا الرَايح وين مسافر تروح تعيا وتولي يا الرَايح وين مسافر تروح تعيا وتولي شحال ندموا العباد الغافلين قبلك وقبلي يا الرَايح وين مسافر تروح تعيا وتولي شحال ندموا العباد الغافلين قبلك وقبلي Merci, merci شكرا\n	2013-10-08	4
7	Kumisar	00:03:40	audiokumisar	\N	1979-10-08	5
8	Pierrot	00:04:40	audiopierrot	T'es pas né dans la rue T'es pas né dans l'ruisseau T'es pas un enfant perdu Pas un enfant d'salaud Vu qu't'es né qu'dans ma tête Et qu'tu vis dans ma peau J'ai construit ta planete Au fond de mon cerveau. Pierrot Mon gosse mon frangin, mon poteau Mon copain, tu m'tiens chaud Pierrot. Depuis l'temps que j'te rêve Depuis l'temps que j't'invente Ne pas te voir j'en crève Mais j'te sens dans mon ventre. Le jour où tu t'ramènes J'arrête de boire promis Au moins toute une semaine Ce s'ra dur, mais tant pis. Pierrot Mon gosse mon frangin, mon poteau Mon copain, tu m'tiens chaud Pierrot. Qu'tu sois fils de princesse Ou qu'tu sois fils de rien Tu s'ras fils de tendresse Tu s'ras pas orphelin. Mais j'connais pas ta mère Et je la cherche en vain Je connais qu'la misère D'être tout seul sur le chemin. Pierrot Mon gosse mon frangin, mon poteau Mon copain, tu m'tiens chaud Pierrot. Dans un coin de ma tête Y'a déjà ton trousseau: Un jean une mobylette Une paire de Santiago. T'iras pas à l'école J't'apprendrai des gros mots On jouera au football On ira au bistrot. Pierrot Mon gosse mon frangin, mon poteau Mon copain, tu m'tiens chaud Pierrot. Tu t'lav'ras pas les pognes Avant d'venir à table Et tu m'traitera d'ivrogne Quand j'piquerai ton cartable J't'apprendrai mes chansons Tu les trouveras débiles T'auras p't'être bien raison Mais j's'rai vexé quand même. Pierrot Mon gosse mon frangin, mon poteau Mon copain, tu m'tiens chaud Pierrot. Allez, viens, mon Pierrot Tu s'ras l'chef de ma bande J'te r'filerai mon couteau J't'apprendrai la truande. Allez, viens, mon copain J't'ai trouvé une maman Tous les trois, ça s'ra bien. Allez, viens, je t'attends. Pierrot Mon gosse mon frangin, mon poteau Mon copain, tu m'tiens chaud Pierrot.	1980-10-08	3
9	Black	00:03:40	audioblack	내 심장의 색깔은 black 시커멓게 타버려 just like that 틈만 나면 유리를 깨부수고 피가 난 손을 보고 난 왜 이럴까 왜 네 미소는 빛나는 gold 하지만 말투는 feel so cold 갈수록 날 너무 닮아가 가끔씩은 karma가 뒤쫓는 것 같아 사랑의 본명은 분명히 증오 희망은 실망과 절망의 부모 어느새 내 얼굴에 드리워진 그림자가 너란 빛에서 생긴 걸 몰랐을까 너와 내 사이에 시간은 멈춘 지 오래 언제나 고통의 원인은 오해 하기야 나도 날 모르는데 네가 날 알아주길 바라는 것 그 자체가 오해 사람들은 다 애써 웃지 진실을 숨긴 채 그저 행복한 것처럼 사랑이란 말 속 가려진 거짓을 숨긴 채 마치 영원할 것처럼 우울한 내 세상의 색깔은 black 처음과 끝은 변해 흑과 백 사람이란 간사해 가끔 헛된 망상에 들어 정말 난 왜 이럴까 왜 그 입술은 새빨간 red 거짓말처럼 새빨갛게 갈수록 둘만의 언어가 서로 가진 color가 안 맞는 것 같아 사랑의 본명은 분명히 증오 희망은 실망과 절망의 부모 어느새 내 얼굴에 드리워진 그림자가 너란 빛에서 생긴 걸 몰랐을까 너를 만나고 남은 건 끝 없는 고뇌 날마다 시련과 시험의 연속 고개 이젠 이별을 노래해 네게 고해 이건 내 마지막 고해 사람들은 다 애써 웃지 진실을 숨긴 채 그저 행복한 것처럼 사랑이란 말 속 가려진 거짓을 숨긴 채 마치 영원할 것처럼 Someday 세상의 끝에 홀로 버려진 채 널 그리워 할지도 yeah Someday 슬픔의 끝에 나 길들여진 채 끝내 후회 할지도 몰라 나 돌아갈게 내가 왔던 그 길로 BLACK 너와 내가 뜨거웠던 그 여름은 IT’S BEEN TO LONG 나 돌아갈게 내가 왔던 그 길로 BLACK 너와 내가 뜨거웠던 그 여름은 IT’S BEEN TO LONG FADE AWAY FADE AWAY FADE AWAY FADE AWAY FADE AWAY FADE AWAY FADE AWAY FADE AWAY	2015-10-30	2
10	Sicko Mode	00:03:40	audiosicko	Astro, yeah Sun is down, freezin' cold That's how we already know winter's here My dawg would prolly do it for a Louis belt That's just all he know, he don't know nothin' else I tried to show 'em, yeah I tried to show 'em, yeah, yeah Yeah, yeah, yeah Gone on you with the pick and roll Young LaFlame, he in sicko mode Woo, made this here with all the ice on in the booth At the gate outside, when they pull up, they get me loose Yeah, Jump Out boys, that's Nike boys, hoppin' out coupes This shit way too big, when we pull up give me the loot (Gimme the loot) Was off the Remy, had a Papoose Had to hit my old town to duck the news Two-four hour lockdown, we made no moves Now it's 4AM and I'm back up poppin' with the crew I just landed in, Chase B mixes pop like Jamba Juice Different colored chains, think my jeweler really sellin' fruits And they chokin', man, know the crackers wish it was a noose Some-some-some, someone said To win the retreat, we all in too deep P-p-playin' for keeps, don't play us for weak (someone said) To win the retreat, we all in too deep P-p-playin' for keeps, don't play us for weak (yeah) This shit way too formal, y'all know I don't follow suit Stacey Dash, most of these girls ain't got a clue All of these hoes I made off records I produced I might take all my exes and put 'em all in a group Hit my esés, I need the bootch 'Bout to turn this function to Bonnaroo Told her, "Hop in, you comin' too" In the 305, bitches treat me like I'm Uncle Luke (Don't stop, pop that pussy) Had to slop the top off, it's just a roof (uh) She said, "Where we goin'?" I said, "The moon" We ain't even make it to the room She thought it was the ocean, it's just the pool Now I got her open, it's just the Goose Who put this shit together? I'm the glue (someone said) Shorty FaceTimed me out the blue Someone said (playin'-playin' for keeps) Someone said, motherfuck what someone said (Don't play us for weak) Yeah Astro Yeah, yeah Tay Keith, fuck these niggas up (ayy, ayy) She's in love with who I am Back in high school, I used to bus it to the dance (yeah) Now I hit the FBO with duffles in my hands I did half a Xan, thirteen hours 'til I land Had me out like a light, ayy, yeah Like a light, ayy, yeah Like a light, ayy Slept through the flight, ayy Knocked for the night, ayy, 767, man This shit got double bedroom, man I still got scores to settle, man I crept down the block (down the block), made a right (yeah, right) Cut the lights (yeah, what?), paid the price (yeah) Niggas think it's sweet (nah, nah), it's on sight (yeah, what?) Nothin' nice (yeah), baguettes in my ice (aww, man) Jesus Christ (yeah), checks over stripes (yeah) That's what I like (yeah), that's what we like (yeah) Lost my respect, you not a threat When I shoot my shot, that shit wetty like I'm Sheck (bitch) See the shots that I took (ayy), wet like I'm Book (ayy) Wet like I'm Lizzie, I be spinnin' Valley Circle blocks 'til I'm dizzy (yeah, what?) Like where is he? (Yeah, what?) No one seen him (yeah, yeah) I'm tryna clean 'em (yeah) She's in love with who I am Back in high school, I used to bus it to the dance Now I hit the FBO with duffles in my hand (woo) I did half a Xan, thirteen hours 'til I land Had me out like a light, like a light Like a light, like a light Like a light (yeah), like a light Like a light Yeah, passed the dawgs a celly Sendin' texts, ain't sendin' kites, yeah He said, "Keep that on lock" I said, "You know this shit, it's stife", yeah It's absolute (yeah), I'm back reboot (it's lit) LaFerrari to Jamba Juice, yeah (skrrt, skrrt) We back on the road, they jumpin' off, no parachute, yeah Shawty in the back She said she workin' on her glutes, yeah (oh my God) Ain't by the book, yeah This how it look, yeah 'Bout a check, yeah Just check the foots, yeah Pass this to my daughter, I'm gonna show her what it took (yeah) Baby mama cover Forbes, got these other bitches shook, yeah Ye-ah 	2018-10-30	6
11	Goosebumps	00:03:40	audiogoosebumps	Yeah 7:30 in the night, yeah Ooh-ooh, ooh I get those goosebumps every time, yeah, you come around, yeah You ease my mind, you make everything feel fine Worried 'bout those comments, I'm way too numb, yeah It's way too dumb, yeah I get those goosebumps every time, I need the Heimlich Throw that to the side, yeah I get those goosebumps every time, yeah, when you're not around (straight up) When you throw that to the side, yeah (it's lit) I get those goosebumps every time, yeah 7-1-3 through the 2-8-1, yeah I'm ridin' Why they on me? Why they on me? I'm flyin', sippin' low-key I be sippin' low-key in Onyx, rider, rider When I'm pullin' up right beside ya Pop star, lil' Mariah When I text, kick game, knowledge Throw a stack on the Bible Never Snapchat or took molly She fall through plenty, her and all her ginnies, yeah We at the top floor, right there off Doheny, yeah Oh no, I can't fuck with y'all, yeah When I'm with my squad I cannot do no wrong, yeah Saucin' in the city, don't get misinformed, yeah They gon' pull up on you (brrt, brrt, brrt) Yeah, we gon' do some things, some things you can't relate Yeah, 'cause we from a place, a place you cannot stay Oh, you can't go, oh, I don't know Oh, back the fuck up off me (brrt, brrt, brrt) I get those goosebumps every time, yeah, you come around, yeah You ease my mind, you make everything feel fine Worried 'bout those comments, I'm way too numb, yeah It's way too dumb, yeah I get those goosebumps every time, I need the Heimlich Throw that to the side, yeah I get those goosebumps every time, yeah, when you're not around When you throw that to the side, yeah I get those goosebumps every time Uh, I wanna press my like, yeah, I wanna press my I want a green light, I wanna be like I wanna press my line, yeah I wanna to take that ride, yeah I'm gonna press my line I want a green light, I wanna be like, I wanna press my Mama, dear, spare your feelings I'm relivin' moments, peelin' more residual I can buy the building, burn the building, take your bitch Rebuild the building just to fuck some more I can justify my love for you And touch the sky for God to stop debatin' war Put the pussy on a pedestal (ayy) Put the pussy on a high horse That pussy to die for That pussy to die for Peter Piper, picked a pepper So I could pick your brain and put your heart together We depart the shady parts and party hard, the diamonds yours The coupe forever My best shot, just might shoot forever like (brrt) I get those goosebumps every time, yeah, you come around, yeah You ease my mind, you make everything feel fine Worried 'bout those comments, I'm way too numb, yeah It's way too dumb, yeah I get those goosebumps every time, I need the Heimlich Throw that to the side, yeah I get those goosebumps every time, yeah, when you're not around When you throw that to the side, yeah I get those goosebumps every time	2018-10-30	6
12	Antidote	00:03:40	audioantidote	Don't you open up that window Don't you let out that antidote (yeah) Poppin' pills is all we know (ooh) In the hills is all we know (Hollywood) Don't go through the front door (through the back) It's lowkey at the night show (ooh) So don't you open up that window (ooh) Don't you let out that antidote, yeah Party on a Sunday (that was fun) Do it all again on Monday (one more time) Spent the check on a weekend (oh my God) I might do it all again (that's boss shit) I just hit a three peat (ooh) Fucked three hoes I met this week (Robert Horry) I don't do no old hoes (oh, no, no) My nigga, that's a no-no (straight up) She just want the coco (cocaina) I just want dinero (paper hunt) Who that at the front door? (Who that is?) If it's the feds, oh-no-no-no (don't let 'em in, shhh) Don't you open up that window (yah) Don't you let out that antidote (yah, ooh) Poppin' pills is all we know (yah) In the hills is all we know (Hollywood) Don't go through the front door (in the back) It's lowkey at the night show (ooh) Ayy, ooh, ooh At the night show (ooh-ooh-ooh) At the night show (higher) At the night show (ooh-ooh-ooh) Ooh, at the night show (get lit, my nigga) Ooh, at the night show Anything can happen at the night show (yah) Everything can happen at the night show (ooh) Ooh, at the night show Anything can happen at the night show (ooh) At the night show (ooh) Your bitch not at home, she at the night show, ooh (straight up) Fuckin' right, hoe (ooh) Had to catch a flight for the night show (ooh) Let's get piped though Bottles got us right though, we ain't sippin' light though (syke) I ain't got no type, though Only got one night though, we can do it twice though It's lit at the night show (ooh) At the night show (ooh) At the night show (ooh) At the night show At the night show Everything can happen at the night show (ooh) At the night show Anything can happen at the night show (ooh) Stackin' up day to day Young nigga, you know you gotta go get it, go get it, my nigga They hatin', they stinkin', they waitin' Don't be mistaken, we dyin', they stayin' Lord, I'm on fire they think that I'm Satan Callin' me crazy on different occasions Kickin' the cameraman off of my stages 'Cause I don't like how he snappin' my angles I'm overboard and I'm over-impatient Over my niggas and these kids my ages Dealin' with Mo' shit that's more complicated Like these two bitches that might be related H-Town, you got one and you Bun B like a number one It's late night, got a late show If you wanna roll, I got a place where Poppin' pills is all we know (ooh) In the hills is all we know (Hollywood!) Don't go through the front door (through the back) It's lowkey at the night show (ooh) So don't you open up that window (ooh) Don't you let out that antidote	2018-10-30	6
13	Highest In The Room	00:03:40	audiohighest	I got room In my fumes (yeah) She fill my mind up with ideas I'm the highest in the room (it's lit) Hope I make it outta here (let's go) She saw my eyes, she know I'm gone (ah) I see some things that you might fear I'm doin' a show, I'll be back soon (soon) That ain't what she wanna hear (nah) Now I got her in my room (ah) Legs wrapped around my beard Got the fastest car, it zoom (skrrt) Hope we make it outta here (ah) When I'm with you, I feel alive You say you love me, don't you lie (yeah) Won't cross my heart, don't wanna die Keep the pistol on my side (yeah) Case it's fumes (smoke) She fill my mind up with ideas (straight up) I'm the highest in the room (it's lit) Hope I make it outta here (let's go, yeah) We ain't stressin' 'bout the loot (yeah) My block made of queseria This not the Molly, this the boot Ain't no comin' back from here Live the life of La Familia It's so much gang that I can't see ya (yeah) Turn it up 'til they can't hear (we can't) Runnin', runnin' 'round for the thrill Yeah, dawg, dawg, 'round my real (gang) Raw, raw, I been pourin' to the real (drank) Nah, nah, nah, they not back of the VIP (in the VIP) Gorgeous, baby, keep me hard as steel Ah, this my life, I did not choose Uh, been on this since we was kids We gon' stay on top and break the rules Uh, I fill my mind up with ideas Case it's fumes She fill my mind up with ideas (straight up) I'm the highest in the room (I'm the highest, it's lit) Hope I make it outta here I'm the highest, you might got the Midas touch What the vibe is? And my bitch the vibiest, yeah Everyone excited, everyone too excited, yeah now Play with the giants, little bit too extravagant, yeah now Night, everyone feel my vibe, yeah In the broad day, everyone hypnotizing, yeah I'm okay and I take the cake, yeah	2023-10-30	6
14	Dynamite	00:03:30	audiodynamite	parolesdynamite	2020-05-12	11
15	Butter	00:03:30	audiobutter	parolesbutter	2023-05-12	11
16	Fake Love	00:03:20	audiofaklove	parolesfaklove	2018-05-12	11
17	Rap God	00:03:30	audiorapgod	Look, I was gonna go easy on you not to hurt your feelings But I'm only going to get this one chance (six minutes-, six minutes-) Something's wrong, I can feel it (six minutes, Slim Shady, you're on!) Just a feeling I've got, like something's about to happen, but I don't know what If that means what I think it means, we're in trouble, big trouble And if he is as bananas as you say, I'm not taking any chances You are just what the doc ordered I'm beginnin' to feel like a Rap God, Rap God All my people from the front to the back nod, back nod Now, who thinks their arms are long enough to slap box, slap box? They said I rap like a robot, so call me Rap-bot But for me to rap like a computer, it must be in my genes I got a laptop in my back pocket My pen'll go off when I half-cock it Got a fat knot from that rap profit Made a livin' and a killin' off it Ever since Bill Clinton was still in office With Monica Lewinsky feelin' on his nutsack I'm an MC still as honest But as rude and as indecent as all hell Syllables, skill-a-holic (kill 'em all with) This flippity dippity-hippity Rap You don't really wanna get into a pissin' match With this rappity brat, packin' a MAC in the back of the Ac' Backpack rap crap, yap-yap, yackety-yack And at the exact same time, I attempt these lyrical acrobat stunts while I'm practicin' that I'll still be able to break a motherfuckin' table Over the back of a couple of faggots and crack it in half Only realized it was ironic, I was signed to Aftermath after the fact How could I not blow? All I do is drop F-bombs Feel my wrath of attack Rappers are havin' a rough time period, here's a maxi pad It's actually disastrously bad for the wack While I'm masterfully constructing this masterpièce 'Cause I'm beginnin' to feel like a Rap God, Rap God All my people from the front to the back nod, back nod Now, who thinks their arms are long enough to slap box, slap box? Let me show you maintainin' this shit ain't that hard, that hard Everybody want the key and the secret to rap immortality like Ι have got Well, to be truthful the blueprint's Simply rage and youthful exuberance Everybody loves to root for a nuisance Hit the Earth like an asteroid Did nothing but shoot for the Moon since (pew!) MCs get taken to school with this music 'Cause I use it as a vehicle to "Bus the rhyme" Now I lead a new school full of students Me? I'm a product of Rakim Lakim Shabazz, 2Pac, N.W.A, Cube, hey Doc, Ren Yella, Eazy, thank you, they got Slim Inspired enough to one day grow up, blow up and be in a position To meet Run-D.M.C., induct them Into the motherfuckin' Rock and Roll Hall of Fame Even though I'll walk in the church and burst in a ball of flames Only Hall of Fame I'll be inducted in is the alcohol of fame On the wall of shame You fags think it's all a game, 'til I walk a flock of flames Off a plank and, tell me what in the fuck are you thinkin'? Little gay-lookin' boy So gay, I can barely say it with a straight face, lookin' boy (ha-ha!) You're witnessin' a mass-occur Like you're watching a church gathering take place, lookin' boy "Oy vey, that boy's gay!" That's all they say, lookin' boy You get a thumbs up, pat on the back And a "Way to go" from your label every day, lookin' boy Hey, lookin' boy! What you say, lookin' boy? I get a "Hell, yeah" from Dre, lookin' boy I'ma work for everything I have, never asked nobody for shit Get outta my face, lookin' boy! Basically, boy, you're never gonna be capable Of keepin' up with the same pace, lookin' boy, 'cause- I'm beginnin' to feel like a Rap God, Rap God All my people from the front to the back nod, back nod The way I'm racin' around the track, call me NASCAR, NASCAR Dale Earnhardt of the trailer park, the White Trash God Kneel before General Zod This planet's Krypton-, no, Asgard, Asgard So you'll be Thor and I'll be Odin You rodent, I'm omnipotent Let off, then I'm reloadin' Immediately with these bombs I'm totin' And I should not be woken I'm the walkin' dead, but I'm just a talkin' head, a zombie floatin' But I got your mom deep-throatin' I'm out my Ramen Noodle We have nothin' in common, poodle I'm a Doberman, pinch yourself in the arm and pay homage, pupil It's me, my honesty's brutal But it's honestly futile if I don't utilize what I do though For good at least once in a while So I wanna make sure somewhere in this chicken scratch I scribble and doodle enough rhymes To maybe try to help get some people through tough times But I gotta keep a few punchlines Just in case 'cause even you unsigned Rappers are hungry lookin' at me like it's lunchtime I know there was a time where once I Was king of the underground But I still rap like I'm on my Pharoahe Monch grind So I crunch rhymes, but sometimes when you combine Appeal with the skin color of mine You get too big and here they come tryin' To censor you like that one line I said on "I'm Back" from The Mathers LP 1 when I Tried to say I'll take seven kids from Columbine Put 'em all in a line, add an AK-47, a revolver and a .9 See if I get away with it now that I ain't as big as I was, but I'm Morphin' into an immortal, comin' through the portal You're stuck in a time warp from 2004 though And I don't know what the fuck that you rhyme for You're pointless as Rapunzel with fuckin' cornrows You write normal? Fuck being normal! And I just bought a new raygun from the future Just to come and shoot ya, like when Fabolous made Ray J mad 'Cause Fab said he looked like a fag at Mayweather's pad Singin' to a man while he played piano Man, oh man, that was a 24-7 special on the cable channel So Ray J went straight to the radio station The very next day, "Hey Fab, I'ma kill you!" Lyrics comin' at you at supersonic speed (J.J. Fad) Uh, summa-lumma, dooma-lumma, you assumin' I'm a human What I gotta do to get it through to you I'm superhuman? Innovative and I'm made of rubber so that anything You say is ricochetin' off of me, and it'll glue to you and I'm devastating, more than ever demonstrating How to give a motherfuckin' audience a feeling like it's levitating Never fading, and I know the haters are forever waiting For the day that they can say I fell off, they'll be celebrating 'Cause I know the way to get 'em motivated I make elevating music, you make elevator music "Oh, he's too mainstream" Well, that's what they do when they get jealous, they confuse it "It's not Rap, it's pop, " 'cause I found a hella way to fuse it With rock, shock rap with Doc Throw on "Lose Yourself" and make 'em lose it I don't know how to make songs like that I don't know what words to use Let me know when it occurs to you While I'm rippin' any one of these verses that versus you It's curtains, I'm inadvertently hurtin' you How many verses I gotta murder to Prove that if you were half as nice, your songs you could sacrifice virgins too? Ugh, school flunky, pill junkie But look at the accolades these skills brung me Full of myself, but still hungry I bully myself 'cause I make me do what I put my mind to And I'm a million leagues above you Ill when I speak in tongues, but it's still tongue-in-cheek, fuck you I'm drunk, so, Satan, take the fucking wheel I'ma sleep in the front seat Bumpin' Heavy D and the Boyz, still "Chunky but Funky" But in my head, there's something I can feel tugging and struggling Angels fight with devils and here's what they want from me They're askin' me to eliminate some of the women hate But if you take into consideration the bitter hatred I have, then you may be a little patient And more sympathetic to the situation And understand the discrimination But fuck it, life's handin' you lemons? Make lemonade then! But if I can't batter the women How the fuck am I supposed to bake them a cake then? Don't mistake him for Satan; it's a fatal mistake If you think I need to be overseas and take a vacation To trip a broad, and make her fall on her face and Don't be a retard, be a king? Think not Why be a king when you can be a god?	2013-05-12	7
18	Lose Yourself	00:03:30	audioloseyourself	Look, if you had one shot, one opportunity To seize everything you ever wanted One moment Would you capture it or just let it slip? His palms are sweaty, knees weak, arms are heavy There's vomit on his sweater already, mom's spaghetti He's nervous, but on the surface he looks calm and ready To drop bombs, but he keeps on forgettin What he wrote down, the whole crowd goes so loud He opens his mouth, but the words won't come out He's chokin, how everybody's jokin now The clocks run out, times up over, bloah! Snap back to reality, oh there goes gravity Oh, there goes rabbit, he choked Hes so mad, but he wont give up that Is he? no He wont have it, he knows his whole back citys ropes It dont matter, hes dope He knows that, but hes broke Hes so stacked that he knows When he goes back to his mobile home, thats when its Back to the lab again yo This whole rap shit He better go capture this moment and hope it dont pass him You better lose yourself in the music, the moment You own it, you better never let it go You only get one shot, do not miss your chance to blow This opportunity comes once in a lifetime yo The souls escaping, through this hole that its gaping This world is mine for the taking Make me king, as we move toward a, new world order A normal life is borin, but superstardoms close to post mortar It only grows harder, only grows hotter He blows us all over these hoes is all on him Coast to coast shows, hes know as the globetrotter Lonely roads, god only knows Hes grown farther from home, hes no father He goes home and barely knows his own daughter But hold your nose cuz here goes the cold water His bosses dont want him no mo, hes cold product They moved on to the next schmoe who flows He nose dove and sold nada So the soap opera is told and unfolds I suppose its old potna, but the beat goes on Da da dum da dum da da No more games, ima change what you call rage Tear this mothafuckin roof off like 2 dogs caged I was playin in the beginnin, the mood all changed I been chewed up and spit out and booed off stage But i kept rhymin and stepwritin the next cypher Best believe somebodys payin the pied piper All the pain inside amplified by the fact That i cant get by with my 9 to 5 And i cant provide the right type of life for my family Cuz man, these goddam food stamps dont buy diapers And its no movie, theres no mekhi phifer, this is my life And these times are so hard and it's getting even harder Tryin to feed and water my seed, plus See dishonor caught up bein a father and a prima donna Baby mama drama screamin on and Too much for me to wanna Stay in one spot, another jam or not Has gotten me to the point, i'm like a snail I've got to formulate a plot fore i end up in jail or shot Success is my only mothafuckin option, failures not Mom, i love you, but this trail has got to go I cannot grow old in salems lot So here i go is my shot. Feet fail me not cuz maybe the only opportunity that i got You can do anything you set your mind to, man	2002-05-12	7
19	Godzilla	00:03:30	audiogodzilla	I can swallow a bottle of alcohol and I'll feel like Godzilla Better hit the deck like the card dealer My whole squad's in here, walkin' around the party A cross between a zombie apocalypse and B-Bobby, "The Brain" Heenan which is probably the same reason I wrestle with mania Shady's in this bitch, I'm posse'd up Consider it to cross me a costly mistake If they sleepin' on me, the hoes better get insomnia, ADHD, Hydroxycut Pass the Courvoisi' (hey, hey) In AA, with an AK, melee, finna set it like a playdate Better vacate, retreat like a vacay, mayday (ayy) This beat is cray-cray, Ray J, H-A-H-A-H-A Laughin' all the way to the bank, I spray flames They cannot tame or placate the (ayy) Monster You get in my way? I'ma feed you to the monster (yeah) I'm normal during the day, but at night turn to a monster (yeah) When the moon shines like Ice Road Truckers I look like a villain outta those blockbusters Godzilla, fire spitter, monster Blood on the dance floor, and on the Louis V carpet Fire, Godzilla, fire, monster Blood on the dance floor, and on the Louis V carpet I'm just a product of Slick Rick, at Onyx, told 'em lick the balls Had 'em just appalled at so many things that pissed 'em off It's impossible to list 'em all And in the midst of all this I'm in a mental hospital with a crystal ball Tryna see, will I still be like this tomorrow? Risperdal, voices whisper My fist is balled back up against the wall, pencil drawn This is just the song to go ballistic on You just pulled a pistol on the guy with the missile launcher I'm just a Loch Ness, the mythological Quick to tell a bitch screw off like a fifth of Vodka When you twist the top of the bottle, I'm a Monster You get in my way? I'ma feed you to the monster (yeah) I'm normal during the day, but at night turn to a monster (yeah) When the moon shines like Ice Road Truckers I look like a villain outta those blockbusters Godzilla, fire spitter, monster Blood on the dance floor, and on the Louis V carpet Fire, Godzilla, fire, monster Blood on the dance floor, and on the Louis V carpet If you never gave a damn, raise your hand 'Cause I'm about to set trip, vacation plans I'm on point, like my index is, so all you will ever get is The motherfuckin' finger (finger), prostate exam ('xam) How can I have all these fans and perspire? Like a liar's pants, I'm on fire And I got no plans to retire and I'm still the man you admire These chicks are spazzin' out, I only get more handsome and flier I got 'em passin' out like what you do, when you hand someone flyers What goes around, comes around just like the blades on a chainsaw 'Cause I caught the flaps of my dollar stack Right off the bat like a baseball, like Kid Ink Bitch, I got them racks with so much ease that they call me Diddy 'Cause I make bands and I call getting cheese a cakewalk (cheesecake!) Bitch, I'm a player, I'm too motherfuckin' stingy for Cher Won't even lend you an ear, ain't even pretendin' to care But I tell a bitch I'll marry her, if she'll bury her Face on my genital area, the original Richard Ramirez Christian Rivera 'Cause my lyrics never sit well, so they wanna give me the chair Like a paraplegic, and it's scary, call it Harry Carry 'Cause every Tom and Dick and Harry Carry a Merriam motherfuckin' dictionary Got 'em swearin' up and down, they can't spit, this shit's hilarious It's time to put these bitches in the obituary column We wouldn't see eye to eye with a staring problem Get the shaft like a steering column (monster) Trigger happy, pack heat, but it's black ink Evil half of the Bad Meets Evil That means take a back seat Take it back to Fat Beats with a maxi single Look at my rap sheets, what attracts these people Is my gangster, bitch, like Apache with a catchy jingle I stack these chips, you barely got a half-eaten Cheeto Fill 'em with the venom, and eliminate 'em Other words, I Minute Maid 'em I don't wanna hurt 'em, but I did, I'm in a fit of rage I'm murderin' again, nobody will evade I'm finna kill 'em, I'm dumpin' their fuckin' bodies in the lake Obliteratin' everything, incinerate a renegade I'm here to make anybody who want it with the pen afraid But don't nobody want it but they're gonna get it anyway 'Cause I'm beginnin' to feel like I'm mentally ill I'm Atilla, kill or be killed, I'm a killer bee, the vanilla gorilla You're bringin' the killer within me, out of me You don't want to be the enemy of the demon Who went in me, and be on the receiving of me, what stupidity it'd be Every bit of me is the epitome of a spitter When I'm in the vicinity, motherfucker, you better duck Or you finna be dead the minute you run into me A hundred percent of you is a fifth of a percent of me I'm 'bout to fuckin' finish you bitch, I'm unfadable You wanna battle, I'm available, I'm blowin' up like an inflatable I'm undebatable, I'm unavoidable, I'm unevadable I'm on the toilet bowl I got a trailer full of money and I'm paid in full I'm not afraid to pull a-, man, stop Look what I'm plannin' (haha)	2020-05-12	7
20	Sweet Child O Mine	00:03:30	audiosweetchild	She's got a smile that it seems to me Reminds me of childhood memories Where everything was as fresh as the bright blue sky Now and then when I see her face She takes me away to that special place And if I stare too long, I'd probably break down and cry Whoa, oh, oh Sweet child o' mine Whoa, oh, oh, oh Sweet love of mine She's got eyes of the bluest skies As if they thought of rain I'd hate to look into those eyes and see an ounce of pain Her hair reminds me of a warm safe place Where as a child I'd hide And pray for the thunder and the rain to quietly pass me by Whoa, oh, oh Sweet child o' mine Whoa whoa, oh, oh, oh Sweet love of mine Whoa, yeah Whoa, oh, oh, oh Sweet child o' mine Whoa, oh, whoa, oh Sweet love of mine Whoa, oh, oh, oh Sweet child o' mine Ooh, yeah Ooh, sweet love of mine Where do we go? Where do we go now? Where do we go? Ooh, oh, where do we go? Where do we go now? Oh, where do we go now? Where do we go? (Sweet child) Where do we go now? Ay, ay, ay, ay, ay, ay, ay, ay Where do we go now? Ah, ah Where do we go? Oh, where do we go now? Oh, where do we go? Oh, where do we go now? Where do we go? Oh, where do we go now? Now, now, now, now, now, now, now Sweet child Sweet child of mine	1987-05-12	12
21	Welcome To The Jungle	00:03:30	audiowelcome	Welcome to the jungle. We got fun and games. We got everything you want. Honey, we know the names. We are the people that can find whatever you may need. If you got no money, honey, we got your disease. In the jungle, welcome to the jungle. Watch it bring you to your knees, knees. Ooh-ah, I wanna watch you bleed. Welcome to the jungle. We take it day by day. If you want it, you're gonna bleed. But that's the price you pay. You're a very sexy girl who's very hard to please. You can taste the bright lights, but you won't get them for free. In the jungle, welcome to the jungle. Feel my, my, my, my serpentine. I, I wanna hear you scream. Welcome to the jungle. It's worse here every day. You learn to live like an animal in the jungle where we play. You got a hunger for what you see. You'll take it eventually. You can have anything you want. But you better not take it from me. In the jungle, welcome to the jungle. Watch it bring you to your knees, knees. Ooh-ah, I'm gonna watch you bleed. And when you're high, you never ever want to come down. So down, so down, so down, yeah. Aw. You know where you are? You're in the jungle, baby. You're gonna die. In the jungle, welcome to the jungle. Watch it bring you to your knees, knees. In the jungle, welcome to the jungle. Feel my, my, my, my serpentine. In the jungle, welcome to the jungle. Watch it bring you to your knees, knees. In the jungle, welcome to the jungle. Watch it bring to your... It's gonna bring you down, huh.	1987-05-12	12
22	Paradise City	00:03:30	audioparadise	Take me down to the Paradise City Where the grass is green and the girls are pretty (take me home) Oh, won't you please take me home? Take me down to the Paradise City Where the grass is green and the girls are pretty (take me home) Oh, won't you please take me home? Just an urchin living under the street, I'm a Hard case that's tough to beat I'm your charity case so buy me somethin' to eat I'll pay you at another time Take it to the end of the line Rags and riches, or so they say, you gotta Keep pushing for the fortune and fame You know it's, it's all a gamble when it's just a game You treat it like a capital crime Everybody's doing their time Take me down to the Paradise City Where the grass is green and the girls are pretty Oh, won't you please take me home? Yeah-yeah Take me down to the Paradise City Where the grass is green and the girls are pretty Take me home Strapped in the chair of the city's gas chamber Why I'm here, I can't quite remember The surgeon general says it's hazardous to breathe I'd have another cigarette but I can't see Tell me, who you're gonna believe? Take me down to the Paradise City Where the grass is green and the girls are pretty Take me home, yeah-yeah Take me down to the Paradise City Where the grass is green and the girls are pretty Oh, won't you please take me home? Yeah So far away So far away So far away So far away Captain America's been torn apart, now He's a court jester with a broken heart He said, "Turn me around and take me back to the start" I must be losin' my mind, "Are you blind?" "I've seen it all a million times" Take me down to the Paradise City Where the grass is green and the girls are pretty Take me home, yeah-yeah Take me down to the Paradise City Where the grass is green and the girls are pretty Oh, won't you please take me home? Take me down to the Paradise City Where the grass is green and the girls are pretty Take me home, yeah-yeah Take me down to the Paradise City Where the grass is green and the girls are pretty Oh, won't you please take me home? Home I wanna go, I wanna know Oh, won't you please take me home? I wanna see, how good it can be Oh, won't you please take me home? Take me down to the Paradise City Where the grass is green and the girls are pretty Take me home (oh, won't you please take me home?) Take me down to the Paradise City Where the grass is green and the girls are pretty Oh, won't you please take me home? Take me down (oh yeah), spin me 'round Oh, won't you please take me home? I wanna see, how good it can be Oh, won't you please take me home? I wanna see, how good it can be Oh, oh, take me home Take me down to the Paradise City Where the grass is green and the girls are pretty Oh, won't you please take me home? (I want you, I want you take me home) I wanna go, I wanna know Oh, won't you please take me home? Baby, yeah	2023-05-12	12
23	La Vie En Rose	00:03:30	audiolavie	Des yeux qui font baisser les miens Un rire qui se perd sur sa bouche Voilà le portrait sans retouches De l'homme auquel j'appartiens Quand il me prend dans ses bras Qu'il me parle tout bas Je vois la vie en rose Il me dit des mots d'amour Des mots de tous les jours Mais moi, ça me fait quelque chose Il est entré dans mon cœur Une grande part de bonheur Dont je connais la cause C'est lui pour moi, moi pour lui dans la vie Il me l'a dit, l'a juré pour la vie Et dès que je l'aperçois Alors je sens en moi Mon cœur qui bat Des nuits d'amour à plus finir Un grand bonheur qui prend sa place Des ennuis, des chagrins s'effacent Heureux, heureux à en mourir Quand il me prend dans ses bras Qu'il me parle tout bas Je vois la vie en rose Il me dit des mots d'amour Des mots de tous les jours Et ça me fait quelque chose Il est entré dans mon cœur Une part de bonheur Dont je connais la cause C'est lui pour moi, moi pour lui dans la vie Il me l'a dit, l'a juré pour la vie Et dès que je l'aperçois Alors je sens en moi Mon cœur qui bat Et dès que je l'aperçois Alors je sens en moi Mon cœur qui bat	1947-05-12	10
24	Non Je Ne Regrette Rien	00:03:30	audionon	Non, rien de rien Non, je ne regrette rien Ni le bien qu'on m'a fait Ni le mal Tout ça m'est bien égal Non, rien de rien Non, je ne regrette rien C'est payé, balayé, oublié Je me fous du passé Avec mes souvenirs J'ai allumé le feu Mes chagrins, mes plaisirs Je n'ai plus besoin d'eux Balayé les amours Avec leurs trémolos Balayé pour toujours Je repars à zéro Non, rien de rien Non, je ne regrette rien Ni le bien qu'on m'a fait Ni le mal Tout ça m'est bien égal Non, rien de rien Non, je ne regrette rien Car ma vie Car mes joies Aujourd'hui Ça commence avec toi	1960-05-12	10
25	Milord	00:03:30	audiomilord	Allez, venez, Milord! Vous asseoir à ma table Il fait si froid, dehors Ici c'est confortable Laissez-vous faire, Milord Et prenez bien vos aises Vos peines sur mon cœur Et vos pieds sur une chaise Je vous connais, Milord Vous n'm'avez jamais vue Je n'suis qu'une fille du port Qu'une ombre de la rue Pourtant j'vous ai frôlé Quand vous passiez hier Vous n'étiez pas peu fier Dame! Le ciel vous comblait Votre foulard de soie Flottant sur vos épaules Vous aviez le beau rôle On aurait dit le roi Vous marchiez en vainqueur Au bras d'une demoiselle Mon Dieu! Qu'elle était belle J'en ai froid dans le cœur Allez, venez, Milord! Vous asseoir à ma table Il fait si froid, dehors Ici c'est confortable Laissez-vous faire, Milord Et prenez bien vos aises Vos peines sur mon cœur Et vos pieds sur une chaise Je vous connais, Milord Vous n'm'avez jamais vue Je n'suis qu'une fille du port Qu'une ombre de la rue Dire qu'il suffit parfois Qu'il y ait un navire Pour que tout se déchire Quand le navire s'en va Il emmenait avec lui La douce aux yeux si tendres Qui n'a pas su comprendre Qu'elle brisait votre vie L'amour, ça fait pleurer Comme quoi l'existence Ça vous donne toutes les chances Pour les reprendre après Allez, venez, Milord! Vous avez l'air d'un môme! Laissez-vous faire, Milord Venez dans mon royaume Je soigne les remords Je chante la romance Je chante les milords Qui n'ont pas eu de chance! Regardez-moi, Milord Vous n'm'avez jamais vue Mais vous pleurez, Milord? Ça j'l'aurais jamais cru Eh ben, voyons, Milord! Souriez-moi, Milord! Mieux qu'ça! Un p'tit effort Voilà, c'est ça! Allez, riez, Milord! Allez, chantez, Milord! Pa lalalalala Lalalala lala Lalalala lala Lalalala lala La lalalalala Mais oui, dansez, Milord! Pa lalalalala Lalalala lala Ta lalalalala Bravo Milord Palalala lala Lalalala lala Palalala lala Encore Milord Palalala lala Lalalala lala Palalala lala Pa la la la lala Lalalala lala Lalalala lala Ta pa lalalalala	1959-05-12	10
26	Ay Ahlili	00:03:40	audioayahvivi	I lawan grec-d asfel Ul-iw ay yeǧefel Yeṛẓa-d akk idmaren-iw Ur d yeqim deg-i laεqel Ma d ttufɣa laεqel Teṭef tasga deg lmux-iw A win s yenna-n sbeṛ yeshel Ad iyi d iqabel Ad yefreq y-idi aṭan-iw Ay aḥlili, ay aḥlili D ul-iw i yebɣan tigi Ay aḥlili, ay aḥlili Yenɣa-i uzzu n tayri Helkaɣ lahlak d afuḥan ṭebat yella-n A win iwumi ḥkiɣ Ad yesmaεraq Ul-iw wtent iɣisan Lǧǧiha yeḥlan Di tayeḍ ad iceqeq D aǧenwi lḥub iyi zlan Yeǧǧa-i i yesɣan Asmi aken id udreɣ laεceq Ay aḥlili, ay aḥlili D ul-iw i yebɣan tigi Ay aḥlili, ay aḥlili Lḥiɣ ɣeɣ targin ḥafi Asmi akken id bedreɣ laεceq ẓriɣ att ɣereq Sfina lahna yes-i Yenɣa-i w ul s laḥmeq ǧǧiɣ-t iseweq Yewwi-d leǧṛuḥ d cwami Limer as ḥekmeɣ s lḥeq Ad yettufeleq Lamaεna ad yeglu yes-i Ay aḥlili, ay aḥlili D ul-iw i yebɣan tigi Ay aḥlili, ay aḥlili Yenɣayi w uzzu n tayri S kra n win yumnen ul-is Ihega naεc-is Ihega abrid s aẓekka Ur-t ttheni ddunit-is Tin teẓra tiṭ-is As tt-id yecreḍ Di dqiqa Ma ur s-id yeqḍ-ara ccɣel-is Ass-n d cum-is Mkul iḍ ur yesgan ara Ay aḥlili, ay aḥlili D ul-iw i yebɣan tigi Ay aḥlili, ay aḥlili Yenɣayi w uzzu n tayri Ay aḥlili, ay aḥlili D ul-iw i yebɣan tigi Ay aḥlili, ay aḥlili Lḥiɣ ɣef targin ḥafi	1979-10-08	5
27	Ayatma	00:03:40	audioayatma	\N	1979-10-08	5
28	Killthislove	00:03:30	audiokillthislove	paroleskillthislove	2019-04-04	1
29	Ddududdudu	00:03:30	audioddududdudu	parolesddududdudu	2018-06-15	1
30	Foreveryoung	00:03:30	audioforeveryoung	parolesforeveryoung	2018-06-15	1
31	Stay	00:03:30	audiostay	parolesstay	2018-06-15	1
32	Bangbangbang	00:03:40	audiobangbangbang	parolesbangbangbang	2013-10-30	2
33	Fantasticbaby	00:03:40	audiofantasticbaby	parolesfantasticbaby	2013-10-30	2
34	Mets pas celle-là	03:50:00	lien_audio_mets_pas_celle_la.mp3	Celle-là c'est pour ceux qu'on néglige Leurs putains d'trophées avec ou sans, on existe Celle-là c'est pour ceux qu'on néglige Leurs putains d'trophées avec ou sans, on existe Si tu veux du son pour t'poser, mets pas celle-là Si tu veux pas faire d'excès d'vitesse, mets pas celle-là Mh si tu veux des mots doux ma grande, mets pas celle-là Si tu sais pas ser-dan ma3lich, mets pas celle-là Allô la Terre? Ici l'apogée On a dû déplacer not' QG J'vais kicker ça vu la haine que j'ai À vous la Terre, ici l'apogée On vise le disque de cristal, car on l'peut J'vais t'faire mal comme Shaquille O'Neal dans du 42 Repoussez vos bum-al, voilà l'équipe des 40 bœufs Là c'est Sexion d'Assaut ch-ch-ch-challenger Oh-oh-oh-oh-oh Gim's t'es un tueur Non, c'est grâce à nous tous si ça parle de nous au 20 heures On est des hommes donc on s'adapte à toutes leurs salades À toutes heures, ils nous baladent et rien qu'ça palabre sur Twitter Nigga shut up, j't'avoue qu'd'un coup j'ai envie de meurtre J'passe le salaam à vous Paname, okay akhi fuck ton Rap J'espère qu'ton disque flop Grosse pointure, petite frappe, wech wech qu'est-ce qui s'passe? Cousin, j'détiens le trône tous les matins, je chie dedans Tu viens reboucher le trou en t'imaginant que j'suis dedans Tu veux la peau de l'ours? Tiens prends c'qu'il en reste J'compte même plus les traces de coups d'fouet camouflées sous la veste Si tu veux d'quoi critiquer, mets pas l'Apogée On est venu faire regretter ceux qui voulaient nous déloger Allô la Terre, Belize akhi ici Sexion, on arrive ooh Si tu veux du son pour t'poser, mets pas celle-là Si tu veux pas faire d'excès d'vitesse, mets pas celle-là Mh si tu veux des mots doux ma grande, mets pas celle-là Si tu sais pas ser-dan ma3lich, mets pas celle-là Allô la Terre? Ici l'apogée On a dû déplacer not' QG J'vais kicker ça vu la haine que j'ai À vous la Terre, ici l'apogée J'suis avec Lefa, Gim's, Black M, Maska, Doums, kick On craint personne, y a qu'devant Dieu qu'on s'incline C'est pas leurs putains d'costards qui nous prouvent qu'ils sont clean T'entends? Ça c'est la gifle qu'on t'inflige Woo quelle chaleur quand on kick mets la clim' On est ding-dingue-dingue bien qu'on prie dans les square Quelqu'un écrit bang-bang sur les camions des shtars Tu crois briller mets pas celle-là sinon tu vas tout d'suite t'éteindre Même les plus grands des boxeurs n'évitent pas les coups du destin J'crois qu'il est temps d'remettre de l'ordre chez les petites frappes JR Chrome, un ours polaire dans une petite Smart On veut s'détendre, mais c'est la guérilla non-stop Donc, on a toujours quelques punchlines en stock Mmmh tu connais voilà l'équipe qu'on a souvent comparé au G-Unit On m'a dit qu'c'est l'Apogée donc j'ai ouvert le robinet D'où je suis, je vois la Terre en tout petit, mais où on est? Si tu veux d'quoi critiquer, mets pas l'Apogée On est venu faire regretter ceux qui voulaient nous déloger Allô la Terre, Belize akhi ici Sexion, on arrive ooh Si tu veux du son pour t'poser, mets pas celle-là Si tu veux pas faire d'excès d'vitesse, mets pas celle-là Mh si tu veux des mots doux ma grande, mets pas celle-là Si tu sais pas ser-dan ma3lich, mets pas celle-là Allô la Terre? Ici l'apogée On a dû déplacer not' QG J'vais kicker ça vu la haine que j'ai À vous la Terre, ici l'apogée On t'avait dit "ne mets pas celle-là" Ici y a pas de blacks intégrés, tah Harry Roselmack Veuillez déposer le mic MC, car là c'est l'Apogée Redouté comme celui avec qui Carla s'est posée C'est les mecs qui kickent sale, les tis-pe qui tapent des gravons Comment leur faire comprendre qu'il en manque huit au Musée Grevin? Huit au Musée Grevin Huit au Musée Grevin Huit au Musée Grevin Huit au Musée Grevin L'A-P-O-G-E-E d'où on est, on voit en tout petit les haineux S-E-X-I-O-N très tôt faut s'vé-le Chouf la distance qu'il y a entre nous et eux L'A-P-O-G-E-E d'où on est, on voit en tout petit les haineux S-E-X-I-O-N très tôt faut s'vé-le Chouf la distance qu'il y a entre nous et eux L'A-P-O-G-E-E d'où on est, on voit en tout petit les haineux S-E-X-I-O-N très tôt faut s'vé-le Chouf la distance qu'il y a entre nous et eux	2010-08-25	13
35	Casquette à l'envers	04:32:00	lien_audio_casquette_a_lenvers.mp3	Okay déconcentré, t'étais dès qu'on s'est téma Déconcentré, t'étais dès qu'on s'est téma Déconcentré, t'étais dès qu'on s'est téma Dès qu'on s'est téma t'étais, dès qu'on s'est téma J'ai fait un rêve, j'ai vu la Terre, belle ronde avec une squette' Ron-ronde avec une squette', ron-ronde avec une squette' J'ai fait un rêve, j'ai vu la Terre, belle ronde avec une squette-ca Monte-les en l'air s'ils n'te respectent pas Dans ma Wati-bulle, le temps me fout les boules J'l'ai juste mis à l'envers, me cassez pas les- Casquette à l'envers akhi au cas où y a d'l'action Celle de Black M a plus d'valeur que le chapeau de Jackson Au comico j'la retire as-p et encore moins devant l'physio J'irais jusqu'à trouver mon double pour une putain d'fusion Wati-B et pas une autre, moi j'en ai plus rien à foutre Les gens du dessus me font pas peur, un homme peut pas faire venir la foudre W-A-T-I- B confonds pas avec L-A Prends pas l'seum si ta go t'avoue qu'sous le charme, elle est Hum, ma vie est synonyme de casse-tête Black M n'a pas retourné sa veste, il a retourné sa casquette J'irais jusque devant le chef d'État Lui dire en face c'que j'pense sans faire de détails (casquette à l'envers) On dit qu'l'habit ne fait pas le moine Mais moi, on m'a jugé parce que j'avais ma (casquette à l'envers) J'vais pas faire de cinéma, c'est (die) Désormais, je n'vais frapper que là où ça fait (mal) Tout Bériz me guette akhi c'est (die) Désormais, je n'vais frapper que là où ça fait (mal) Okay, casquette à l'envers ou sur l'té-c', c'est la même J'suis excellent même quand il s'agit d'textes sans thème J'teste des centaines, de flow de tech' et ça t'aimes hein Déconcentré t'étais dès qu'on s'est té-ma Fle-gi dans l'sage-vi, m'arrives-tu à la cheville? J'crois qu'tu voulais m'achever, mais j'suis toujours là, j'vis Casquette Gucci, Lacoste, L-A, k-NewYor Vraie ou fausse, à l'envers elle est que meilleure Y a autant d'casquette à l'envers que de Mac ou de BlackBerry Nombreux comme les bactéries, détends-toi y a pas d'dédicace Là, c'est l'7-5 cousin assume un peu faut pas que t'évites Les vrais se font rares, tout autant qu'un gars qui du da-s' guérit Puis ça ti-sor, l'pe-pom en cas, d'pépins Entre Chirac et the game, bah y a qu'une casquette qui sépare En plein, jet-pro, m'touche pas, j'sé-po "Liberté, égalité, fraternité", chapeau Casquette à l'envers pour pas qu'j'oublie qu'on m'la mise à l'envers Demande à mon shab Jerry R ainsi qu'à ceux d'Anvers Cousin, j'fais plus d'sourire, j'vois qu'l'État surine Des petites comme Suri, j'en dis trop sorry J'irais jusque devant le chef d'État Lui dire en face c'que j'pense sans faire de détails (casquette à l'envers) On dit qu'l'habit ne fait pas le moine Mais moi, on m'a jugé parce que j'avais ma (casquette à l'envers) J'vais pas faire de cinéma, c'est (die) Désormais, je n'vais frapper que là où ça fait (mal) Tout Bériz me guette akhi c'est (die) Désormais, je n'vais frapper que là où ça fait (mal) JR O Crom, moi c'est bitume et casquette à l'envers Ça casse la démarche, flash iPod petit on-s à l'ancienne Ça niaque sous vos fenêtres, squatte les boîtes, les banquettes arrière Ça clashe la journée, ça transac' à la "nique sa mère" (nique sa mère) J'me réveille avec des maux d'tête Gueule de ois-b, encore à m'remémorer la cuite d'hier Pur zonard négligé, débrouillard et sans complexes Au tier-quar boule à Z, re-cui, squette-ca sur la tête On marche avec un oigt-d dans l'boule Depuis l'Euro poto, pour ça qu'on vit comme des ghetto youth Garde à vue, dépôts, ces claqués j'en ai croisé des foules Plaqués, menottés, à s'faire té-shoo comme des ballons d'foot Au lycée j'ai pas fait long feu tellement j'étais naze Mon ze-bla c'était "le perturbateur du fond d'la classe" Casquette à l'envers, chez moi, c'est comme ça qu'mes potes la mettent J'préfère lever l'oigt-d, j'veux pas tourner le dos pour qu'on m'la mette On a des yeux dans l'dos donc on porte nos casquettes à l'envers Et ça dans, n'importe quelle cascade Allez hop une casse-déd' À ceux qui la portent comme un casque, parce qu'on vit dans un énorme casse-tête (akhi) À ceux qui la retournent pour mettre des coups d'plafond Aux gorilles qui hagar' les gens juste parce qu'ils poussent d'la fonte J'irais jusque devant le chef d'État Lui dire en face c'que j'pense sans faire de détails (casquette à l'envers) On dit qu'l'habit ne fait pas le moine Mais moi, on m'a jugé parce que j'avais ma (casquette à l'envers) J'vais pas faire de cinéma, c'est (die) Désormais, je n'vais frapper que là où ça fait (mal) Tout Bériz me guette akhi c'est (die) Désormais, je n'vais frapper que là où ça fait (mal) Okay déconcentré, t'étais dès qu'on s'est téma Dès qu'on s'est téma t'étais déconcentré man Déconcentré, t'étais dès qu'on s'est téma Dès qu'on s'est téma t'étais déconcentré man (casquette à l'envers) Déconcentré, t'étais dès qu'on s'est téma Dès qu'on s'est téma t'étais déconcentré man (casquette à l'envers) Déconcentré, t'étais dès qu'on s'est téma (die) Dès qu'on s'est téma t'étais déconcentré man (die) (Die) Casquette à l'envers (die)	2009-11-15	13
36	Wati House	04:12:00	lien_audio_wati_house.mp3	Hé, Akhi, hé Murder L'inspi provient de Meda Ca m'a tout l'air d'un hold up Ramène mon verre de soda Apelle moi docteur Gero De-spee comme un Aguëro Paris ça d'vient Soweto Va falloir s'lever tôt He-he-he-he-Heeee mi amor, c'est une mise à mort He-he-he-he-Heeee mi amor, c'est une mise à mort Por favor, mi amor por favor Mi amor por favor, mi amor por favor Mais-mais-mais qui c'est qui va payer les pots cassés? (Yeah) Qui va payer les pots cassés? Putain mais qui c'est qui va payer les pots cassés? (Yeah) Sûrement pas les gens des beaux quartiers Merde, tu t'es mis dans la merde, t'aurais pas dû faire l'nerveux On va t'monter en l'air, arrête ton numéro On s'improvise pas héros, j'kick même sur d'l'électro Appelle moi l'torero J'en place une spécial pour nos ennemis Venez-venez nous voir sur scène A tous ceux qui étaient présents au Zenith On vous aime Toujours entouré d'mes associés Barack et le blanc pour m'saucer Ca-ca-catapulté vers le sommet Système solaire He-he-he-he-Heeee mi amor, c'est une mise à mort He-he-he-he-Heeee mi amor, c'est une mise à mort Por favor, mi amor por favor Mi amor por favor, mi amor por favor C'est nous on fait du bruit pendant qu'le FN dort FN dort e-e-FN dort! J'suis dvant la porte avec des khoya akhi open the door Open the door o-o-open the door (J'ai dit) C'est nous on fait du bruit pendant qu'le FN dort FN dort e-e-FN dort! J'suis dvant la porte avec des khoya akhi open the door Open the door o-o-open the door Beriz, au tieks on manque de khaliss Moi dans ma tête c'est l'Afrique J'vois bien tout l'Wa au Mali Vas-y Akhi fais kiffer ta Nicki Tissage Ments lui dis lui qu'elle a le plus beau des visages Va-va-vas-y met du son, met du swag, met du... Aaah Ici c'est danse obligatoire le minimum le petit... Pas! Bordel, comme dit l'boss y'a des problèmes Autant qu'à Paris L'OM Faut qu'j'me téj' du haut d'la scène (Seine) He-he-he-he-Heeee mi amor, c'est une mise à mort He-he-he-he-Heeee mi amor, c'est une mise à mort Por favor, mi amor por favor Mi amor por favor, mi amor por favor Po-po-po-pump it up Po-pump it pump it up Ca c'est du son qui ressort d'Paris centre Ca c'est le son qui t'reprend ta licence Po-po-po-pump it up Po-pump it pump it up Crois pas qu'il frappe, c'est le Wa ça rend barge Dans les textes dans les boîtes, dans les Porsches Po-po-po pump it up Po-pump it pump it up Numéro 1 n'en doute pas Wati B a.k.a le bateau qui coule pas Po-po-po pump it up Po-pump it pump it up On s'voit après l'apéro Guapa te quiero (Wa-Ti-B Baby) t'as reconnu la voix le style le beat (Eh la lady) T'as reconnu le style le mec du wa (Pa-name ci-ty) T'as reconnu le style le mec du wa (Ma-ma-ma-Marackech) T'as reconnu le style le mec du wa (Lo-lo-lo-lo-lo-London) T'as reconnu le style le mec du wa (A-a-a-a-Abidjan) T'as reconnu le style le mec du wa (Lisbone) T'as reconnu le style le mec du wa (Dou-dou-dou-dou-dou-Dubaï) T'as reconnu le style le mec du wa (I-i-i-Ibiza) T'as reconnu le style le mec du wa (Miami) T'as reconnu le style le mec du wa Mi amor por favor Mi amor por favor Mi amor por favor (T'as reconnu le style le mec du wa) Mi amor por favor Mi amor por favor Mi amor por favor (T'as reconnu le style le mec du wa)	2012-06-30	13
37	Africain	03:58:00	lien_audio_africain.mp3	Africain Ne jugez pas, chaque humain est comme il est Je n'suis qu'un africain J'veux marcher sur la lune mais l'avouer c'est m'humilier Et tous les jours, mes frères meurent par centaines et par milliers J'ai les cheveux crépus, j'pourrais pas les gominer Ils nous ont divisé pour mieux nous dominer Ils nous ont séparé de nos frères les antillais (antillais) J'viens d'ici et j'suis sénégalais J'viens de France, mon enfance, moi j'vais pas t'l'étaler J'repense souvent à l'Afrique, j'aimerais la voir décoller Mais c'qui compte c'est la santé, ouais c'est la santé J'voulais rentrer au G8 mais je n'suis qu'un africain	2011-04-20	13
38	Balader	04:05:00	lien_audio_balader_sa.mp3	Wah, toh-toh-toh-toh Bébé, j'fais des sous, j'rentre tard C'est léger, j'suis pas trop fêtard J'suis léwé, j'roule sur la costa Ma te-tê sur les tous les posters J'ai visé tout là-haut (là-haut) écouté jusqu'à Macao Tu critiques mais t'es K.O Là, c'est Soolking et Charo des charos (Boumi') Ouh, oui, elle veut que j'bois dans son verre Ouh, oui, elle veut l'faire dans l'Range Rover (Dans la tchop) Ouh, oui, elle veut que j'bois dans son verre (Oh my God) Ouh, oui, elle veut l'faire dans l'Range Rover (gang) J'veux m'balader (sale) mais c'est plus comme avant J'chanterai l'quartier toute ma vie (my life) Même si j'fais l'tour du monde (oh, oui) J'veux m'balader (gang) mais c'est plus comme avant J'chanterai l'quartier toute ma vie (yeah) Même si j'fais l'tour du monde Encaisser des kichtas, on est bon qu'à ça Alger, Bériz, Kinshasa Mais pourquoi le binks ne me quitte pas? (Pourquoi?) J'ai sorti le bail qui les fait danser Elle aime trop ma musique, elle aime que ça Alger, Bériz, Kinshasa Mais pourquoi le binks ne me quitte pas? J'ai sorti le bail qui les fait danser C'est trop d'la D (ouh, oui) C'est plus la même qu'avant (han, han) Chacal, crois pas qu'on t'a zappé On va t'chercher dans toute la France J'fais bouger les tisses-mé (ah, ah, ah, ah) J'fais partir le tos-ma (ah, ah, ah, ah) La zone, elle est minée (ah, ah, ah, ah) Faut v-esqui les menottes (ah, ah, ah, ah) Charlie, delta au quartier latin Diogo Jota ou Kiki Lottin Méchant, méchant, on a gâté le coin Car depuis longtemps, on est culottés (woh, woh, woh) Ouh, oui, elle veut que j'bois dans son verre (C'est la merde) Ouh, oui, elle veut l'faire dans l'Range Rover (Dans la tchop) Ouh, oui, elle veut que j'bois dans son verre (Oh my God) Ouh, oui, elle veut l'faire dans l'Range Rover (gang) J'veux m'balader (sale) mais c'est plus comme avant J'chanterai l'quartier toute ma vie (my life) Même si j'fais l'tour du monde (ouh, oui) J'veux m'balader (gang) mais c'est plus comme avant J'chanterai l'quartier toute ma vie (yeah) Même si j'fais l'tour du monde Encaisser des kichtas, on est bon qu'à ça Alger, Bériz, Kinshasa Mais pourquoi le binks ne me quitte pas? (Pourquoi?) J'ai sorti le bail qui les fait danser Elle aime trop ma musique, elle aime que ça Alger, Bériz, Kinshasa Mais pourquoi le binks ne me quitte pas? J'ai sorti le bail qui les fait danser J'veux m'balader, mais c'est plus comme avant J'chanterai l'quartier toute ma vie Même si j'fais l'tour du monde J'veux m'balader, mais c'est plus comme avant J'chanterai l'quartier toute ma vie Même si j'fais l'tour du monde	2010-12-18	13
39	Bella	03:58:00	lien_audio_bella.mp3	Bella, Bella Bella, Bella Bella, Bella Bella, Bella Elle répondait au nom de Bella Les gens du coin ne voulaient pas la cher-lâ Elle faisait trembler tous les villages Les gens me disaient: Méfie-toi d'cette fille-là Elle répondait au nom de Bella Les gens du coin ne voulaient pas la cher-lâ Elle faisait trembler tous les villages Les gens me disaient: Méfie-toi d'cette fille-là C'était un phénomène, elle n'était pas humaine Le genre de femme qui change le plus grand délinquant en gentleman Une beauté sans pareille, tout le monde veut s'en emparer Sans savoir qu'elle les mène en bateau Hypnotisés, on pouvait tout donner Elle n'avait qu'à demander, puis aussitôt on démarrait On cherchait à l'impressionner, à devenir son préféré Sans savoir qu'elle les mène en bateau Mais quand je la vois danser le soir J'aimerais devenir la chaise sur laquelle elle s'assoit Ou moins que ça, un moins que rien Juste une pierre sur son chemin Elle répondait au nom de Bella Les gens du coin ne voulaient pas la cher-lâ Elle faisait trembler tous les villages Les gens me disaient: Méfie-toi d'cette fille-là Elle répondait au nom de Bella Les gens du coin ne voulaient pas la cher-lâ Elle faisait trembler tous les villages Les gens me disaient: Méfie-toi d'cette fille-là Oui, c'est un phénomène qui aime hanter nos rêves Cette femme était nommée "Bella la peau dorée" Les femmes la haïssaient, toutes la jalousaient Mais les hommes ne pouvaient que l'aimer Elle n'était pas d'ici, ni facile, ni difficile Synonyme de "magnifique", à ses pieds: que des disciples Qui devenaient vite indécis, tremblants comme des feuilles Elle te caressait sans même te toucher Mais quand je la vois danser le soir J'aimerais devenir la chaise sur laquelle elle s'assoit Ou moins que ça, un moins que rien Juste une pierre sur son chemin Elle répondait au nom de Bella Les gens du coin ne voulaient pas la cher-lâ Elle faisait trembler tous les villages Les gens me disaient: Méfie-toi d'cette fille-là Elle répondait au nom de Bella Les gens du coin ne voulaient pas la cher-lâ Elle faisait trembler tous les villages Les gens me disaient: Méfie-toi d'cette fille-là Allez, fais-moi tourner la tête, hé hé Tourner la tête, hé hé Rends-moi bête comme mes ieds-p', hé hé Bête comme mes ieds-p', hé hé J'suis l'ombre de ton ien-ch', hé hé L'ombre de ton ien-ch', hé hé Fais-moi tourner la tête, hé hé Tourner la tête, hé hé Fais-moi tourner la tête, hé hé Tourner la tête, hé hé Rends-moi bête comme mes ieds-p', hé hé Bête comme mes ieds-p', hé hé J'suis l'ombre de ton ien-ch', hé hé L'ombre de ton ien-ch', hé hé Fais-moi tourner la tête, hé hé Tourner la tête, hé hé Elle répondait au nom de Bella Les gens du coin ne voulaient pas la cher-lâ Elle faisait trembler tous les villages Les gens me disaient: Méfie-toi d'cette fille-là Elle répondait au nom de Bella Les gens du coin ne voulaient pas la cher-lâ Elle faisait trembler tous les villages Les gens me disaient: Méfie-toi d'cette fille-là Elle répondait au nom de Bella Les gens du coin ne voulaient pas la cher-lâ Elle faisait trembler tous les villages Les gens me disaient: Méfie-toi d'cette fille-là Elle répondait au nom de Bella Les gens du coin ne voulaient pas la cher-lâ Elle faisait trembler tous les villages Les gens me disaient: Méfie-toi d'cette fille-là	2013-04-30	14
40	J'me tire	04:21:00	lien_audio_jme_tire.mp3	Je me tire, ne me demande pas pourquoi je suis parti sans motif Parfois je sens mon cœur qui s'endurcit C'est triste à dire mais plus rien ne m'attriste Laisse-moi partir loin d'ici Pour garder le sourire, je me disais que y'a pire Si c'est comme ça, bah fuck la vie d'artiste Je sais que ça fait cliché de dire qu'on est pris pour cible Mais je veux le dire juste pour la rime Je me tire dans un endroit où je serai pas le suspect Après je vais changer de nom comme Cassius Clay Un endroit où j'aurai plus besoin de prendre le mic' Un endroit où tout le monde s'en tape de ma life Je me tire, ne me demande pas pourquoi je suis parti sans motif Parfois je sens mon cœur qui s'endurcit C'est triste à dire mais plus rien ne m'attriste Laisse-moi partir loin d'ici Pour garder le sourire, je me disais que y'a pire Si c'est comme ça, bah fuck la vie d'artiste Je sais que ça fait cliché de dire qu'on est pris pour cible Mais je veux le dire juste pour la rime Si je reste, les gens me fuiront sûrement comme la peste Vos interviews m'ont donné trop de maux de tête La vérité c'est que je me auto-déteste Faut que je préserve tout ce qu'il me reste Et tous ces gens qui voudraient prendre mon tél' Allez leur dire que je suis pas leur modèle Merci à ceux qui disent "Meu-gui on t'aime Malgré ta couleur ébène" Je me tire dans un endroit où je serai pas le suspect Après je vais changer de nom comme Cassius Clay Un endroit où j'aurai plus besoin de prendre le mic' Un endroit où tout le monde s'en tape de ma life Je me tire, ne me demande pas pourquoi je suis parti sans motif Parfois je sens mon cœur qui s'endurcit C'est triste à dire mais plus rien ne m'attriste Laisse-moi partir loin d'ici Pour garder le sourire, je me disais que y'a pire Si c'est comme ça, bah fuck la vie d'artiste Je sais que ça fait cliché de dire qu'on est pris pour cible Mais je veux le dire juste pour la rime Je suis parti sans mot dire, sans me dire "Qu'est-ce que je vais devenir?" Stop! Ne réfléchis plus, Meu-gui Stop! Ne réfléchis plus, vas-y! Parti sans mentir, sans me dire "Qu'est ce que je vais devenir?" Stop! Ne réfléchis plus, Meu-gui Stop! Ne réfléchis plus, vas-y! Je me tire, ne me demande pas pourquoi je suis parti sans motif Parfois je sens mon cœur qui s'endurcit C'est triste à dire mais plus rien ne m'attriste Laisse-moi partir loin d'ici Pour garder le sourire, je me disais que y'a pire Si c'est comme ça, bah fuck la vie d'artiste Je sais que ça fait cliché de dire qu'on est pris pour cible Mais je veux le dire juste pour la rime	2013-02-10	14
41	Changer	04:45:00	lien_audio_changer.mp3	Mon ami, mon avenir Ma vie, pardonne moi Ce visage inexpressif rempli de tristesse De nombreuses fois j'ai du te mentir Ou me mettre dans la peau d'un autre Des kilomètres entre la parole et l'acte T'as fini par voir mon petit jeu d'acteur Mais laisse moi, je peux tout t'expliquer Des fois je fais des choses que je comprends pas La nuit m'aide à méditer C'est dans ces moments que je me dis que je vais changer (changer) Je vais changer (changer) Mes ennuis, mes envies Mes désirs, mes plaisirs Ont pris le dessus sur ma vie de famille Jusqu'à m'en détourner L'argent détruit le cœur d'autrui Je ne peux dissocier l'ennemi de l'ami Tant pis je ne veux pas plaire en pire Je préfère ton sourire dans un trou de souris Mais laisse moi, je peux tout t'expliquer Des fois je fais des choses que je comprends pas La nuit m'aide à méditer C'est dans ces moments que je me dis que je vais changer (changer) Je vais changer (changer) Assis dans le noir Occupé à compter mes défauts Au fin fond du couloir Accroché à un atome d'espoir Assis dans le noir Occupé à compter mes défauts Au fin fond du couloir Accroché à un atome d'espoir Laisse moi, je peux tout t'expliquer Des fois je fais des choses que je comprends pas La nuit m'aide à méditer C'est dans ces moments que je me dis que je vais changer (changer) Je vais changer (changer)	2013-06-25	14
42	Est-ce que tu m'aimes ?	04:11:00	lien_audio_est_ce_que_tu_maimes.mp3	J'ai retrouvé le sourire quand j'ai vu le bout du tunnel Où nous mènera ce jeu du mâle et de la femelle Du mâle et de la femelle On était tellement complices on a brisé nos complexes Pour te faire comprendre t'avais juste à lever le cil T'avais juste à lever le cil J'étais prêt à graver ton image à l'encre noire sous mes paupières Afin de te voir même dans un sommeil éternel Même dans un sommeil éternel Même dans un sommeil éternel J'étais censé t'aimer mais j'ai vu l'averse J'ai cligné des yeux tu n'étais plus la même Est-ce que je t'aime? J'sais pas si je t'aime Est-ce que tu m'aimes? J'sais pas si je t'aime J'étais censé t'aimer mais j'ai vu l'averse J'ai cligné des yeux tu n'étais plus la même Est-ce que je t'aime? J'sais pas si je t'aime Est-ce que tu m'aimes? J'sais pas si je t'aime Pour t'éviter de souffrir je n'avais plus qu'à te dire je t'aime Ça me fait mal de te faire mal je n'ai jamais autant souffert Je n'ai jamais autant souffert Quand je t'ai mis la bague au doigt je me suis passé les bracelets Pendant ce temps le temps passe, et je subis tes balivernes Et je subis tes balivernes J'étais prêt à graver ton image à l'encre noire sous mes paupières Afin de te voir même dans un sommeil éternel Même dans un sommeil éternel Même dans un sommeil éternel J'étais censé t'aimer mais j'ai vu l'averse J'ai cligné des yeux tu n'étais plus la même Est-ce que je t'aime? J'sais pas si je t'aime Est-ce que tu m'aimes? J'sais pas si je t'aime J'étais censé t'aimer mais j'ai vu l'averse J'ai cligné des yeux tu n'étais plus la même Est-ce que je t'aime? J'sais pas si je t'aime Est-ce que tu m'aimes? J'sais pas si je t'aime Je ne sais pas si je t'aime Je ne sais pas si je t'aime Je m' suis fais mal en m'envolant Je n'avais pas vu le plafond de verre Tu me trouvais ennuyeux si je t'aimais à ta manière Si je t'aimais à ta manière Si je t'aimais à ta manière J'étais censé t'aimer mais j'ai vu l'averse J'ai cligné des yeux tu n'étais plus la même Est-ce que je t'aime? J'sais pas si je t'aime Est-ce que tu m'aimes? J'sais pas si je t'aime J'étais censé t'aimer mais j'ai vu l'averse J'ai cligné des yeux tu n'étais plus la même Est-ce que je t'aime? J'sais pas si je t'aime Est-ce que tu m'aimes? J'sais pas si je t'aime J'sais pas si je t'aime J'sais pas si je t'aime	2015-04-22	14
43	Sapés comme jamais	03:26:00	lien_audio_sapes_comme_jamais.mp3	[Intro - Niska:] Sapés comme jamain, sapés comme jamain de jamain Sapés comme jamain, jamain Sapés comme jamain, sapés comme jamain de jamain Sapés comme jamain, jamain [Verse 1 - Maître Gims:] On casse ta porte, c'est la Gestapo J'vais t'retrouver, Meugui Columbo Ça veut vendre des tonnes à la Gustavo Un café sans sucre, j'en ai plein sur l'dos Hé ouais, ma puce, la thune rend beau Ça va faire six ans qu'on met des combos Je manie les mélos, Waraoui, Warano Tu te demandes si c'est pas un complot [Hook - Maître Gims:] Haut les mains, haut les mains Sauf les mecs sapés en Balmain Balmain, Balmain Sarouel façon Aladdin Haut les mains, haut les mains Sauf les mecs sapés en Balmain Balmain, Balmain Sarouel façon Aladdin [Pre-Chorus - Maître Gims:] Passe avant minuit (Passe avant minuit) Je vais t'faire vivre un dream (Je vais t'faire vivre un dream) Avance sur la piste, les yeux sont rivés sur toi Les habits qui brillent tels Les Mille Et Une Nuits Paris est vraiment ma-ma-ma-magique [Chorus - Maitre Gims:] Sapés comme jamais (jamais) Sapés comme jamais (jamais) Sapés comme jamais (jamais) Sapés comme jamais Loulou' et 'Boutin (bando) Loulou' et 'Boutin ('Boutin na 'Boutin) Coco na Chanel (Coco) Coco na Chanel (Coco Chanel) [Verse 2 - Niska:] Niama na ngwaku des ngwaku J'contrôle la ne-zo, apprécie mon parcours Handek à ta go, sale petit coquin, t'es cocu Quand elle m'a vu, elle t'a plaqué Ferregamo, peau de croco sur la chaussure J'suis Congolais, tu vois j'veux dire? Hein hein, Norbatisé Maître Gims m'a convoitisé Charlie Delta localisé Les mbilas sont focalisés Sapés comme jaja, jamain Dorénavant, j'fais des jaloux J'avoue, je vis que pour la victoire, imbécile La concurrence à ma vessie Loubou', Zano' et Hermès Louis, vide ton sac, j'veux la recette (Bando na bando) [Pre-Chorus - Maître Gims:] Passe avant minuit (Passe avant minuit) Je vais t'faire vivre un dream (Je vais t'faire vivre un dream) Avance sur la piste, les yeux sont rivés sur toi Les habits qui brillent tels Les Mille Et Une Nuits Paris est vraiment ma-ma-ma-magique [Chorus - Maitre Gims:] Sapés comme jamais (jamais) Sapés comme jamais (jamais) Sapés comme jamais (jamais) Sapés comme jamais Loulou' et 'Boutin (bando) Loulou' et 'Boutin ('Boutin na 'Boutin) Coco na Chanel (Coco) Coco na Chanel (Coco Chanel) [Outro - Maître Gims:] Kinshasa na Brazza (God bless) Libreville, Abidjan (God bless) Yaoundé na Douala (God bless) Bamako na Dakar (God bless) Dany Synthé oh (God bless) Bedjik na Darcy hé (God bless) Bilou na Dem-dem (God bless) Djuna Djanana hé (God bless) [Chorus - Maitre Gims:] Sapés comme jamais (jamais) Sapés comme jamais (jamais) Sapés comme jamais (jamais) Sapés comme jamais Loulou' et 'Boutin (bando) Loulou' et 'Boutin ('Boutin na 'Boutin) Coco na Chanel (Coco) Coco na Chanel (Coco Chanel)	2015-10-02	14
44	Sur ma route	04:12:00	lien_audio_sur_ma_route.mp3	Sur ma route, oui, il y a eu du move, oui De l'aventure dans l'movie, une vie de roots (une vie de roots) Sur ma route, oui, je n'compte plus les soucis De quoi devenir fou, oui, une vie de roots Sur ma route, sur ma route Sur ma route, sur ma route Sur ma route, j'ai eu des moments de doute J'marchais sans savoir vers où, j'étais têtu rien à foutre Sur ma route, j'avais pas d'bagage en soute Et dans ma poche, pas un sou, juste la famille, entre nous Sur ma route, y a eu un tas d'bouchons La vérité, j'ai souvent trébuché Est-ce que tu sais que quand tu touches le fond Il y a peu de gens chez qui tu peux te réfugier? Tu peux compter que sur tes chers parents Parce que les amis, eux, disparaissent un par un Oui, il m'arrive d'avoir le front au sol Parce que Dieu est grand et on naît seul, on meurt seul Sur ma route, oui, il y a eu du move, oui De l'aventure dans l'movie, une vie de roots (une vie de roots) Sur ma route, oui, je n'compte plus les soucis De quoi devenir fou, oui, une vie de roots Sur ma route, sur ma route Sur ma route, sur ma route Sur ma route, on m'a fait des coups en douce L'impression qu'mon cœur en souffre, mais j'suis sous anesthésie Sur mon chemin, j'ai croisé pas mal d'anciens Ils m'parlaient du lendemain et que tout allait si vite Ne me parle pas de nostalgie Parce que j't'avoue que mon cœur est trop fragile J'suis comme un pirate naufragé Oui, mon équipage est plus que endommagé Je sèche mes larmes, j'baisse les armes J'veux même plus savoir pourquoi ils m'testent, les autres Si y a plus rien à prendre, je sais qu'il m'reste une chose Et ma route, elle est trop longue, pas l'temps de faire une pause Sur ma route, oui, il y a eu du move, oui De l'aventure dans l'movie, une vie de roots (une vie de roots) Sur ma route, oui, je n'compte plus les soucis De quoi devenir fou, oui, une vie de roots Sur ma route, sur ma route Sur ma route, sur ma route, sur ma route Sur ma route Sur ma route, oui, il y a eu du move, oui De l'aventure dans l'movie, une vie de roots (une vie de roots) Sur ma route, oui, je n'compte plus les soucis De quoi devenir fou, oui, une vie de roots (une vie de roots) Sur ma route, oui, il y a eu du move, oui De l'aventure dans l'movie, une vie de roots (une vie de roots) Sur ma route, oui, je n'compte plus les soucis De quoi devenir fou, oui, une vie de roots Sur ma route, sur ma route Sur ma route, sur ma route	2014-06-20	15
45	Je suis chez moi	03:45:00	lien_audio_je_suis_chez_moi.mp3	Tout le monde me regarde À travers mon innocence je pense qu'ils me charment Ma maîtresse d'école m'a dit que j'étais chez moi Mais mon papa, lui, pourtant se méfie d'elle Est-elle fidèle? La France est belle (est belle) Mais elle m'regarde de haut comme la Tour Eiffel (Eiffel) Mes parents m'ont pas mis au monde pour toucher les aides (aides) J'ai vu que Marion m'a twitté, d'quoi elle se mêle? Je sais qu'elle m'aime Je suis Français Ils veulent pas qu'Marianne soit ma fiancée Peut-être parce qu'ils me trouvent trop foncé Laisse-moi juste l'inviter à danser J'vais l'ambiancer J'paye mes impôts, moi J'pensais pas que l'amour pouvait être un combat À la base j'voulais juste lui rendre un hommage J'suis tiraillé comme mon grand-père Ils le savent, c'est dommage Jolie Marianne (Marianne) J'préfère ne rien voir comme Amadou et Mariam (Mariam) J't'invite à manger un bon mafé d'chez ma tata Je sais qu'un jour tu me déclareras ta flamme Aïe aïe aïe Je suis Français Ils veulent pas qu'Marianne soit ma fiancée Peut-être parce qu'ils me trouvent trop foncé Laisse-moi juste l'inviter à danser J'vais l'ambiancer Je suis Français Ils veulent pas qu'Marianne soit ma fiancée Peut-être parce qu'ils me trouvent trop foncé Laisse-moi juste l'inviter à danser J'vais l'ambiancer Je suis chez moi, chez moi, chez moi Je suis chez moi, chez moi, chez moi, chez moi Je suis chez moi, chez moi, chez moi, ah Je suis chez moi, chez moi, chez moi, ah Je suis Français (chez, moi, chez moi) Ils veulent pas qu'Marianne soit ma fiancée (chez moi, chez moi, ah) Peut-être parce qu'ils me trouvent trop foncé (chez moi, chez moi, ah) Laisse-moi juste l'inviter à danser (chez moi) J'vais l'ambiancer (chez moi) Je suis Français Ils veulent pas qu'Marianne soit ma fiancée Peut-être parce qu'ils me trouvent trop foncé Laisse-moi juste l'inviter à danser J'vais l'ambiancer Je suis Noir, je suis Beur, je suis Jaune, je suis Blanc Je suis un être humain comme toi Je suis chez moi Fier d'être Français d'origine guinéenne Fier d'être le fils de Monsieur Diallo Éternellement insatisfait À suivre	2016-01-15	15
46	La légende Black	03:55:00	lien_audio_la_legende_black.mp3	Oh oh oh! Les yeux plus gros que le monde! Dr Beriz Big Black M Et on disait qu'il avait trop d'style Et qu'il vendait du rêve au ladies Et pour lui personne se faisait de bill Pas besoin d'cogiter t'as d'ja tilté Et quand il chantait il faisait la dif' Et avec ses mélodies on oubliait la crise Renoi se prend la tête disait, ainsi soit il Pas besoin d'cogiter t'as d'ja tilté Tout le monde fait (Na na na) Bériz (Na na na) Black M Hello Bériz, euh Comment vas-tu depuis Wati euh Comment leur dire que c'est moi l'king, euh C'est moi qui vous dicte le chapitre Rêveur, on me dit que j'suis ché-per Mais le Big Black M il a cé-per Et on dit que la chute elle est sévère Mais le débrouillard il sait faire J'ai le sang du daron de la Guinée Tout comme j'ai le sang d'un rappeur qui sait kicker Je me fous de vos idéales cain-ri, c'est pas eux qui me donne le maro Je suis pas dans les délires L.A, quand le soleil frappe je suis plutôt Maroc Gros son pour les reufrés Il faut que tout le monde chante mon refrain Et on disait qu'il avait trop d'style Et qu'il vendait du rêve au ladies Et pour lui personne se faisait de bill Pas besoin d'cogiter t'as d'ja tilté Et quand il chantait il faisait la dif' Et avec ses mélodies on oubliait la crise Renoi se prend la tête disait, ainsi soit il Pas besoin d'cogiter t'as d'ja tilté Tout le monde fait (Na na na) Bériz (Na na na) Black M Je voulais juste prendre mes lovés Sans pour autant vouloir être mauvais M'en voulez pas d'avoir innové Oh, tout vos sons me donne la nausée J'étais au tier-quar souvent posé J'voulais que personne vienne me causer Je voulais juste dreamer, m'sauver Fuck l'Interim j'préférais chômer Beaucoup ont dit qu'je finirai paumé J'avais que Sexion pour m'épauler J'étais souvent dur et en colère Oui je n'aimais pas l'système scolaire J'avais du mal avec les horaires Et mes ennemis j'disais j'les aurais Je ne suis pas là pour décorer Non renoi faut pas déconner Et on disait qu'il avait trop d'style Et qu'il vendait du rêve au ladies Et pour lui personne se faisait de bill Pas besoin d'cogiter t'as d'ja tilté Et quand il chantait il faisait la dif' Et avec ses mélodies on oubliait la crise Renoi se prend la tête disait, ainsi soit il Pas besoin d'cogiter t'as d'ja tilté Tout le monde fait (Na na na) Bériz (Na na na) Black M Si j'ai les yeux plus gros qu'le monde C'est que j'ai du voir ce qu'ont vu tous les grands de ce monde N'est ce pas, j'ai que ma gueule, ma musique et mon style Pour m'en sortir j'ai du transmettre ma peine sur mes titres mon gars Si j'ai les yeux plus gros qu'le monde C'est que j'ai du voir ce qu'ont vu tous les grands de ce monde N'est ce pas, j'ai que ma gueule, ma musique et mon style Pour m'en sortir j'ai du transmettre ma peine sur mes titres mon gars Et on disait qu'il avait trop d'style Et qu'il vendait du rêve au ladies Et pour lui personne se faisait de bill Pas besoin d'cogiter t'as d'ja tilté Et quand il chantait il faisait la dif' Et avec ses mélodies on oubliait la crise Renoi se prend la tête disait, ainsi soit il Pas besoin d'cogiter t'as d'ja tilté Tout le monde fait (Na na na) Bériz (Na na na) Black M	2016-10-05	15
47	Death Note	04:30:00	lien_audio_death_note.mp3	Ah-ha, ah-ha Yeah, yeah B.L.A.C.K.M Yo, passionné, passe à la son-mai voir Il n'y a personne pour me raisonner, moi Quand tu dors, je travaille mais frappe fort Ça joue, t'es hors-jeu, mon jeu est hardcore Si tu veux, on s'fait un p'tit flash-back T'auras de quoi créer enfin un bon hashtag Retour des Rois non, retour de Black mais C'est pas grave, parce que le black est un roi, ah T'as oublié, tu fais l'amnésique T'as l'seum parce que, derrière, y'a toute ta mif qui crame mes 'siques Ah, dis-moi, où est-ce que j'cache l'or? Bats les couilles du Bachelor Si, nous, on a Ebola, eux, ils ont la vache folle Un million d'albums, je sais qu't'en as ras-le-bol Pas d'bol, la suite arrive, tu cogiteras sous alcool Hello les nouveaux-nés, v'nez kicker sur c'BPM Soudain, ça devient compliqué, comme les rappeurs dans mes DM Validé par Shakira Bats les couilles d'qui c'est qui rappe, j'ai l'Death Note, j'suis l'Blackira J'suis là depuis des lustres C'putain d'game est frustré, ils aimeraient s'incruster Ils disent que je n'suis plus rappeur, les salauds Chasse le naturel, il revient au galop Pire il revient paro comme les mecs derrière les barreaux Je saigne même pour l'garrot, aujourd'hui, faut mettre le tarot Qu'est-ce qu'il faut pas faire pour exister? Venez à cent, j'essaierai toujours de résister Paraît qu'ça stream fort, ça sème la discorde Un jour ou l'autre, la vérité va se faire screenshot Ils m'les cassent tous, t'étonne pas si j'casse tout J'suis pas seul dans ma tête, si t'es chaud, cousin, menace-nous Pourquoi cette 'tasse l'ouvre? Il faut que j'brasse tout Non, je ne suis pas Snoop mais, igo, ça vaut l'coût Y'a-t-il une couleur que j'n'ai pas vue? (pas vue) C'est la merde à cause d'un cavu Inouïe, elle cherche entre midi/quatorze (quatorze) Alors que je ne sors qu'après minuit Dites à Donald qu'il s'Trump (Trump) Non, je ne suis pas venu semer la discorde Tous sous drogues dures comme dans les années disco Oups, j'crois qu'j'ai plus de fans que l'grand Obispo J'voulais pas t'humilier À la base, j'étais à La Terre du Milieu Comme Alonz', mes gars sûrs m'ont dit "Black, finis-les" Il se peut que je n'ai que très peu d'alliés, que j'me crache comme Aliyah Oh my God, ils ont rayé ma gov' La mictho' est en cloque, Young Thug, il met des robes La SACEM, j'l'a dérobe, ton flow, il est bof J'me tue à "Mama Lova", mais nique sa mère le Rap Ça crée des clans comme Booba-Rohff, j'préfère Anne Roumanoff Surveille ta go quand je rappe, oui, elle aime J'suis présent depuis L'Skadrille jusqu'à PNL Putain d'merde, j'devrais passer sur CNN On devrait vivre dans un monde où il n'y a plus l'FN Demande aux frères d'Afrique de l'Ouest si j'ai retourné ma veste Pas l'temps d'la retirer au bled parce qu'avec la hess on t'agresse J'regrette l'époque de "Shimmy shimmy yay" Aujourd'hui, la musique, elle est cheum mais j'replay Ne venez pas m'demander si, dans le game, je m'y plais Je serai avec le Père Noël dans vos foutues cheminées J'suis toujours chez Wati B, j'ai pas signé chez Maybach Paris sera toujours magique, avec ou sans Neymar Yeah, freestyle Death Note, ha-ha Si j'écris leur blase, ils vont mourir Je suis comme Kira, je les baise avec le sourire Quand j'entends que c'est la fin, j'me tape un fou rire Laisse-moi faire, j'ai le Death Note, Death Note Si j'écris leur blase, ils vont mourrir Je suis comme Kira, je les baise avec le sourire Quand j'entends que c'est la fin, j'me tape un fou rire Laisse-moi faire, j'ai le Death Note, Death Note Yeah B.L.A.C.K.M Zerfry Ah-ha, ah-ha Akatsuki Gang La guette deux On remet ça Stan-E 2017, 2018 Yeah Rappe jusqu'à fatiguer Le Death Note en main Eh Personne va rien faire	2015-03-10	15
48	Frérot	04:20:00	lien_audio_frerot.mp3	Mon frérot Les histoires d'amitié ça fait mal J'ai vu des frères y laisser leur vie au final (oh) Oui quand le diable s'en mêle Il dira t'es l'seul à pouvoir aller au sommet J'ai voulu soulager mon ego J'me répète j'voulais pas faire de mal à mon frérot (oh) On a fait les 400 coups Tout c'qui s'passe autour de moi mes vrais gars s'en foutent Ensemble depuis tout petit Mon cœur se resserre à l'idée qu'on est devenu ennemis Des hommes aujourd'hui, c'est plus la même Mon ami je suis devenu un père de famille Mon ego (ego) Pas devant les frérots (frérots) Je voulais juste un vrai rôle (vrai rôle) Pas faire du mal à mon frérot (frérot) Oh mon ego (ego) Dites-le moi si j'en fait trop (fait trop) Devrais-je repartir à zéro? (Zéro) Pas faire du mal à mon frérot (frérot) Frérot Mon frérot Mon frérot, mon frérot Mon frérot, mon frérot Mon frérot, mon frérot Mon frérot, mon frérot Frérot C'est fou comme les années sont passées On m'dit que ta fille va bientôt rentrer au lycée (oh oh) Elle doit être trop belle Connaît-elle notre histoire, nos liens fraternels? Je sais que mes rêves m'ont éloigné Mais pour toucher les étoiles faut savoir s'envoler! (oh oh) Ça me fait d'la peine Quand tu penses que j'ai changé pour de l'oseille Un vrai frère ne doute pas du cœur d'un frère surtout quand il se bat pour s'en sortir Avec tout ce qu'on a traversé j'espère que la vie a prévu de nous réunir Mon ego (ego) Pas devant les frérots (frérots) Je voulais juste un vrai rôle (vrai rôle) Pas faire du mal à mon frérot (frérot) Oh mon ego (ego) Dites-le moi si j'en fait trop (fait trop) Devrais-je repartir à zéro? (Zéro) Pas faire du mal à mon frérot (frérot) Frérot Mon frérot Mon frérot, mon frérot Mon frérot, mon frérot Mon frérot, mon frérot Mon frérot, mon frérot Frérot Pardonne-moi si je t'ai blessé Pardonne-moi si je t'ai touché Mais ce n'était pas mon intention Mon frérot Pardonne-moi si je t'ai blessé Pardonne-moi si je t'ai touché Mais quoi qu'il arrive tu resteras mon frérot Mon ego (ego) Pas devant les frérots (frérots) Je voulais juste un vrai rôle (vrai rôle) Pas faire du mal à mon frérot (frérot) Oh mon ego (ego) Dites-le moi si j'en fait trop (fait trop) Devrais-je repartir à zéro? (Zéro) Pas faire du mal à mon frérot (frérot) Frérot Mon frérot Mon frérot, mon frérot Mon frérot, mon frérot Mon frérot, mon frérot Mon frérot, mon frérot Frérot Mister Big Black M (Mon frérot) Éternel Insatisfait, L'Everest (Mon frérot) 2017, 2018, 2019, jusqu'à tant plus (Mon frérot) Frérot, mes kwells!	2018-04-22	15
49	Basique	04:12:00	lien_audio_basique.mp3	Ok, j'vais sortir un nouvel album Mais, avant, faut qu'on revoit les bases. J'vais faire une vidéo simple Où j'vais dire des trucs simples parce que vous êtes trop cons. Simple, basique, ok Les gens les plus intelligents sont pas toujours ceux qui parlent le mieux (simple) Les hommes politiques doivent mentir sinon tu voterais pas pour eux (basique) Si tu dis souvent qu't'as pas d'problème avec l'alcool, c'est qu't'en as un (simple) Faut pas faire un enfant avec les personnes que tu connais pas bien (basique) Les mecs du FN ont la même tête que les méchants dans les films (simple) Entre avoir des principes et être un sale con, la ligne est très fine (basique) Hugo Boss habillait les nazis, le style a son importance (simple) Les dauphins sont des violeurs, ouais, Méfie-toi des apparences (basique) Basique, basique, simple, simple Basique, basique, simple, simple Vous n'avez pas les bases, vous n'avez pas les bases Vous n'avez pas les bases, vous n'avez pas les bases Si c'est marqué sur internet, c'est p't-être faux mais c'est p't-être vrai (simple) Illuminati ou pas, qu'est-ce que ça change ? Tu t'fais baiser (basique) À l'étranger, t'es un étranger, ça sert à rien d'être raciste (simple) Les mecs les plus fous sont souvent les mecs les plus tristes (basique) Cent personnes possèdent la moitié des richesses du globe (simple) Tu s'ras toujours à un ou deux numéros d'avoir le quinté dans l'ordre (basique) Si t'es souvent seul avec tes problèmes, c'est parce que, souvent, l'problème, c'est toi (simple) Toutes les générations disent que celle d'après fait n'importe quoi (cliché) Basique, basique, simple, simple Basique, basique, simple, simple Basique, basique, simple, simple Basique, basique, simple, simple Vous n'avez pas les bases Vous n'avez pas les bases Vous n'avez pas les bases Vous n'avez pas les bases Basique, simple, vous n'avez pas les bases Basique, simple, vous n'avez pas les bases Basique, simple, vous n'avez pas les bases Basique, simple, vous n'avez pas les bases Basique, simple, simple, basique Basique, simple, simple, basique Basique, simple, simple, basique Basique, simple, simple, vous n'avez pas les bases	2022-01-01	16
50	Tout va bien	03:45:00	lien_audio_tout_va_bien.mp3	Dors Dors Yeah Steady livin' without stressin' Praise the God above, we never had to run with the younger, with the weapon Flies Gucci when they steppin' While the mommas at home, praying for a bit of dough it's like A way of thinkin' so backwards, turnin' back chapters Just to cause to seem with these actors They practice Rappers when they wake up from the matrice Another night, another actress Tout va bien, tout va bien Petit, tout va bien, tout va bien Tout va bien, petit, tout va bien Tout va bien, tout va bien Miss, see, everything's nice, everything's sweet The money comes fast, yeah, the money completes Never stress out Yeah, the hood, yeah, me come from, me get out Yeah, the paid that I had, yeah, I let out Me no lie, miss, see, momma, don't cry, it's alright Everything's fine We're not gonna lie Yeah, we livin' good life Yeah, we livin' good life Tout va bien, tout va bien Petit, tout va bien, tout va bien Tout va bien, petit, tout va bien Tout va bien, tout va bien Si le monsieur parle tout seul, c'est qu'il raconte des histoires Que le vent rapporte aux enfants pieds nus qui jouent dans les gares Petit, les gens sur les bancs allongés dans les squares Attendent l'arrivée d'un amour dont l'avion a pris du retard Petit, la dame est sur le sol parce qu'elle s'occupe des fourmis L'aiguille à côté d'elle, ça sert à mieux les nourrir Le plastique dans la mer, ça sert à faire des jouets La nuit est noire pour que tu puisses rêver Tout va bien, tout va bien Petit, tout va bien, tout va bien Tout va bien, petit, tout va bien Tout va bien, tout va bien Dors Dors	2022-02-15	16
51	La terre est ronde	05:20:00	lien_audio_terre_ronde.mp3	Au fond, j'crois qu'la Terre est ronde Pour une seule bonne raison Après avoir fait l'tour du monde Tout c'qu'on veut, c'est être à la maison T'as besoin d'une voiture pour aller travailler Tu travailles pour rembourser la voiture que tu viens d'acheter (viens d'acheter) Tu vois l'genre de cercle vicieux? Le genre de trucs qui donne envie d'tout faire sauf de mourir vieux (mourir vieux) Tu peux courir à l'infini À la poursuite du bonheur La Terre est ronde, autant l'attendre ici (l'attendre ici) J'suis pas fainéant mais j'ai la flemme Et ça va finir en arrêt maladie pour toute la semaine (toute la semaine) J'veux profiter des gens qu'j'aime J'veux prendre le temps, avant qu'le temps m'prenne et m'emmène (et m'emmène) J'ai des centaines de trucs sur le feu Mais j'ferai juste c'que je veux quand même Au fond, j'crois qu'la Terre est ronde Pour une seule bonne raison Après avoir fait l'tour du monde Tout c'qu'on veut, c'est être à la maison Au fond, j'crois qu'la Terre est ronde Pour une seule bonne raison Après avoir fait l'tour du monde Tout c'qu'on veut, c'est être à la maison Les rappeurs cainris donnent les mêmes conseils que mes parents Fais c'que tu veux dans ta vie, mais surtout, fais d'l'argent (fais d'l'argent) J'essaye de trouver l'équilibre À quoi ça sert de préparer l'avenir si t'oublies d'vivre? (t'oublies d'vivre) En caleçon qui m'sert de pyjama Au lieu d'lécher mon patron pour une avance qu'il m'filera pas (m'filera pas) Ce soir, j'rameuterai l'équipe En attendant, merci d'appeler Mais s'il te plaît, parle après l'bip (parle après l'bip) Aujourd'hui, je me sens bien J'voudrais pas tout gâcher J'vais tout remettre au lendemain (au lendemain) Y'a vraiment rien dont j'ai vraiment besoin On verra bien si j'me perds en chemin Au fond, j'crois qu'la Terre est ronde Pour une seule bonne raison Après avoir fait l'tour du monde Tout c'qu'on veut, c'est être à la maison Au fond, j'crois qu'la Terre est ronde Pour une seule bonne raison Après avoir fait l'tour du monde Tout c'qu'on veut, c'est être à la maison Pourquoi faire tout d'suite tout c'qu'on peut faire plus tard? (plus tard) Tout c'qu'on veut c'est profiter d'l'instant (d'l'instant) On s'épanouit dans la lumière du soir (du soir) Tout c'qu'on veut c'est pouvoir vivre maintenant (maintenant) Pourquoi faire tout d'suite tout c'qu'on peut faire plus tard? (plus tard) Tout c'qu'on veut c'est profiter d'l'instant (d'l'instant) On s'épanouit dans la lumière du soir (du soir) Tout c'qu'on veut c'est pouvoir vivre maintenant (maintenant) Au fond, j'crois qu'la Terre est ronde Pour une seule bonne raison Après avoir fait l'tour du monde Tout c'qu'on veut, c'est être à la maison Au fond, j'crois qu'la Terre est ronde Pour une seule bonne raison Après avoir fait l'tour du monde Tout c'qu'on veut, c'est être à la maison Au fond, j'crois qu'la Terre est ronde Pour une seule bonne raison Après avoir fait l'tour du monde Tout c'qu'on veut, c'est être à la maison	2021-11-20	16
52	Suicide social	03:30:00	lien_audio_suicide_social.mp3	Aujourd'hui sera le dernier jour de mon existence La dernière fois que je ferme les yeux Mon dernier silence J'ai longtemps cherché la solution à ces nuisances Ça m'apparaît maintenant comme une évidence Fini d'être une photocopie Finies la monotonie, la lobotomie Aujourd'hui je mettrai ni ma chemise ni ma cravate J'irai pas jusqu'au travail, je donnerai pas la patte Adieu les employés de bureau et leurs vies bien rangées Si tu pouvais rater la tienne, ça les arrangerait Ça prendrait un peu de place dans leurs cerveaux étriqués Ça les conforterait dans leur médiocrité Adieu les représentants grassouillets Qui boivent jamais d'eau comme s'ils ne voulaient pas se mouiller Les commerciaux qui sentent l'after-shave et le cassoulet Mets de la mayonnaise sur leur mallette, ils se la boufferaient Adieu, adieu les vieux comptables séniles Adieu les secrétaires débiles et leurs discussions stériles Adieu les jeunes cadres fraîchement diplômés Qu'empileraient les cadavres pour arriver jusqu'au sommet Adieu tous ces grands PDG Essaie d'ouvrir ton parachute doré quand tu te fais défenestrer Ils font leur beurre sur des salariés désespérés Et jouent les vierges effarouchées quand ils se font séquestrer Tous ces fils de quelqu'un Ces fils d'une pute snob Qui partagent les trois quarts des richesses du globe Adieu les petits patrons Ces beaufs embourgeoisés Qui grattent des RTT pour payer leurs vacances d'été Adieu les ouvriers, ces produits périmés C'est la loi du marché mon pote, t'es bon qu'à te faire virer Ça t'empêchera d'engraisser ta gamine affreuse Qui se fera sauter par un pompier, qui va finir coiffeuse Adieu la campagne et ses familles crasseuses Proches du porc au point d'attraper la fièvre aphteuse Toutes ces vieilles, ces commères qui se bouffent entre elles Ces vieux radins et leurs économies de bouts de chandelles Adieu cette France profonde Profondément stupide, cupide, inutile, putride C'est fini, vous êtes en retard d'un siècle Plus personne n'a besoin de vos bandes d'incestes Adieu tous ces gens prétentieux dans la capitale Qui essaient de prouver qu'ils valent mieux que toi chaque fois qu'ils te parlent Tous ces connards dans la pub, dans la finance Dans la com', dans la télé, dans la musique, dans la mode Ces Parisiens, jamais contents, médisants Faussement cultivés, à peine intelligents Ces répliquant qui pensent avoir le monopole du bon goût Qui regardent la province d'un œil méprisant Adieu les sudistes abrutis par leur soleil cuisant Leur seul but dans la vie c'est la troisième mi-temps Accueillants, soi-disant Ils te baisent avec le sourire Tu peux le voir à leur façon de conduire Adieu ces nouveaux fascistes Qui justifient leurs vies de merde par des idéaux racistes Devenu néo-nazis parce que t'avais aucune passion Au lieu de jouer les SS, trouve une occupation Adieu les piranhas dans leur banlieue Qui voient pas plus loin que le bout de leur haine au point qu'ils se bouffent entre eux Qui deviennent agressifs une fois qu'ils sont à 12 Seuls ils lèveraient pas le petit doigt dans un combat de pouce Adieu les jeunes moyens, les pires de tous Ces baltringues supportent pas la moindre petite secousse Adieu les fils de bourges Qui possèdent tout mais ne savent pas quoi en faire Donne leur l'Eden ils t'en font un Enfer Adieu tous ces profs dépressifs T'as raté ta propre vie, comment tu comptes élever mes fils? Adieu les grévistes et leur CGT Qui passent moins de temps à chercher des solutions que des slogans pétés Qui fouettent la défaite du survêt' au visage Transforment n'importe quelle manif' en fête au village Adieu les journalistes qui font dire ce qu'ils veulent aux images Vendraient leur propre mère pour écouler quelques tirages Adieu la ménagère devant son écran Prête à gober la merde qu'on lui jette entre les dents Qui pose pas de question tant qu'elle consomme Qui s'étonne même plus de se faire cogner par son homme Adieu, ces associations bien-pensantes Ces dictateurs de la bonne conscience Bien contents qu'on leur fasse du tort C'est à celui qui condamnera le plus fort Adieu lesbiennes refoulées, surexcitées Qui cherchent dans leur féminité une raison d'exister Adieu ceux qui vivent à travers leur sexualité Danser sur des chariots, c'est ça votre fierté? Les Bisounours et leur pouvoir de l'arc-en-ciel Qui voudraient me faire croire qu'être hétéro c'est à l'ancienne Tellement tellement susceptibles Pour prouver que t'es pas homophobe faudra bientôt que tu suces des types Adieu ma nation, tous ces incapables dans les administrations Ces rois de l'inaction Avec leur bâtiments qui donnent envie de vomir Qui font exprès d'ouvrir à des heures où personne peut venir Mêh, tous ces moutons pathétiques Change une fonction dans leur logiciel, ils se mettent au chômage technique À peu près le même Q.I. Que ces saletés de flics Qui savent pas construire une phrase en dehors de leur sales répliques Adieu les politiques, en parler serait perdre mon temps Tout le système est complètement incompétent Adieu les sectes, adieu les religieux Ceux qui voudraient m'imposer des règles pour que je vive mieux Adieu les poivrots qui rentrent jamais chez eux Qui préfèrent se faire enculer par la Française des Jeux Adieu les banquiers véreux Le monde leur appartient Adieu tous les pigeons qui leur mangent dans la main Je comprends que j'ai rien à faire ici quand je branche la un Adieu la France de Joséphine Ange-Gardien Adieu les hippies leur naïveté qui changera rien Adieu les SM, libertins et tous ces gens malsains Adieu ces pseudo-artistes engagés Pleins de banalités démagogues dans la trachée Écouter des chanteurs faire la morale ça me fait chier Essaie d'écrire des bonnes paroles avant de la prêcher Adieu les petits mongoles qui savent écrire qu'en abrégé Adieu les sans papiers, les clochards, tous ces tas de déchets Je les hais! Les sportifs, les hooligans dans les stades Les citadins, les bouseux dans leur étables Les marginaux, les gens respectables Les chômeurs, les emplois stables, les génies, les gens passables De la plus grande crapule à la Médaille du Mérite De la première dame au dernier trav' du pays!	2022-03-10	16
53	RaelSan	04:50:00	lien_audio_raelsan.mp3	Lève ton verre Lève ton verre Lève ton verre Santé Je porte un toast à la mort de l'industrie Sortez les huit six on viens fêter la fin du disque Écouter la radio c'est devenu un supplice Sauf que j'aime pas non plus les putains de puristes Musique rétro futuriste, la bande originale des aventures d'Ulysse J'habiterais dans les abysses, j'aurais pas plus de pression Tout ce que je veux, foutre le feu dans ma ville, Néron Donner mon corps à la science inclus la dissection Des jours entiers je récite mes leçons Tourmentés dans une pluie de questions Rien qu'en un an ça m'a saoulé je voulais tout plaquer, quitter le son J'ai presque abandonné sans faire ma deuxième livraison Han, mais bordel j'ai fais le plus dur Autant tenter un salto avant d'échouer au pied du mur Je suis de retour avec ma sous-culture Ouais, sauf que c'est nous le futur, hein (c'est nous le futur) J'viens retourner l'opinel entre les points de suture Ils sont la censure, plus tard on aura l'usure Plus tard on ira danser sur leur sépulture Le chant des succubes, au bord de la luxure Sans concessions les sentiments sont plus pures Voilà pourquoi j'écris des chansons de rupture J'essaye de prendre du recul, j'essaye d'avancer Les gens murmurent, j'ai du mal à m'entendre penser Fils d'extraterrestre, étoile céleste J'viens féconder une femelle de chaque espèces J'apprends à contrôler mes sales réflexes, je me fais jouir avant d'écrire J'en ai marre de parler de sexe J'sais que ta petite copine n'aime pas mes textes Mais si j'écoutais toutes les juments je ferais du rap équestre Ça m'énerve pas je respecte J'fais comme Rocky dans la réserve, je m'en bas les steaks J'aimerais faire parti des optimistes (optimistes) J'aime rapporter une sorte de message positif (positif) Comme l'héroïne dans un test d'urine (positif) Comme le dépistage de Freddy Mercury Je reviens faire du bruit, j'ai le son qui frappe Skread m'a ordonné d'enfoncer le clou comme Ponce Pilate Comme d'hab Ablaye et Gringe font les bacs on est quatre Les cavaliers de l'apocalypse on débarque En l'an de grâce MJ plus un La moitié de ma jeunesse est morte le 25 juin Je continue de faire du chemin pour devenir moi même Dans l'amour, dans la haine, dans la moyenne Je resterais pas bloqué dans une parodie de succès Dans une version d'Entourage à petit budgets Je ferais que ce qui me plaît jusqu'à ma dernière quête Jusqu'à retourner dans l'hôtellerie plier des serviette La peur n'existe plus dans mon dojo, eh eh, j'ai retrouvé mon Mojo (baby) Dites à la ménagère qu'on a ressuscité CloClo Dites aux connards d'intermittents d'allumer les projos Appelez les Pow-wow, on va déterrer la hache de guerre Ramener la concurrence à l'âge de pierre Si t'as la fureur de vaincre, moi, j'ai la rage de perdre Je prends même plus la peine de répondre à vos clashs de merde Je prêterais ni mon buzz, ni mon temps (ni mon temps) Je verserais ni ma sueur, ni mon sang (ni mon sang) Tu parles de moi pour rien dans tes titres Tu ferais même pas de buzz avec un album antisémite Merci quand même pour le coup de pub (merci) Merci les chiennes de garde pour le coup de pute (merci) Merci à tout ceux qui m'ont soutenus J'oublie trop souvent de remercier les gens qui m'ont soutenu Faut qu'on s'offre une nouvelle vie, faut qu'on s'ouvre l'esprit Faut que les pantins coupe les fils Prend la route et fuis, j'ai une soucoupe en double file Je te ramène avec oim, RaelSan	2022-04-05	16
54	On verra	04:00:00	lien_audio_on_verra.mp3	On sèche les cours, la flemme marque le quotidien Être en couple, ça fait mal que quand t'y tiens Même si j'ai rien à prouver, j'me sens un peu seul J'ai toujours pas trouvé la pièce manquante du puzzle En possession d'drogues, les jeunes sont fêtards Quelle ironie d'mourir en position fœtale Je viens à peine de naître, demain j'serai vieux Mais j'vais tout faire pour être à jamais ce rêveur On verra bien ce que l'avenir nous réservera On verra bien, vas-y, viens, on n'y pense pas On verra bien ce que l'avenir nous réservera On verra bien, on verra bien Ce soir, on ira faire un tour chez l'épicier ouvert en bas Et on parlera d'amour, entassés sur une véranda Élevé par une vraie ronne-da, j'ai des valeurs qu'ils verront pas Être un homme ça prend du temps Comme commander un verre en boîte J'ai l'vertige quand j'pense à toute la route Qu'il me reste à accomplir J'suis prêt à t'casser les couilles si t'as bu J'te laisserai pas conduire Le temps, ça file, on a peur d'enchaîner les défaites et puis rater Sa vie, pas de projets à part mater des DVD piratés Ah, on verra bien Ce monde rend fou, tout le monde est en guerre Plus on s'renfloue et moins on voit clair Quand t'as pas d'argent, dans ce monde, t'as pas d'droit Y a ceux qui cassent un tête et ceux qui tapent à trois Combien d'fois j'ai volé par flemme de faire la queue? Mon papa m'croit pas, mes sappes sentent le tabac froid On s'fait chier au taff, on attend les cances-va On s'parle derrière un ordi mais, en vrai, quand est-ce qu'on s'voit? On verra bien ce que l'avenir nous réservera On verra bien, vas-y, viens, on n'y pense pas On verra bien ce que l'avenir nous réservera On verra bien, on verra bien Ici, non seulement ça rappe Mais quand y a un gros ceau-mor ça rapplique N'aie pas peur des insultes qu'on se lance Aux consonances arabiques On est tous dans le même bateau (bateau) Même ceux que l'on aime pas trop Car l'amour, le son et la bouffe sont devenus consommation rapide Les jeunes pensent plus à des stars débiles qu'à Martin Luther King Se lèvent jamais avant midi à part le matin d'une perquis' Pendant qu'ses copains révisaient, le petit Ken devenait écrivain Oui, je pense qu'à m'amuser mais pour la coke j'ai le nez de Krilin S-Crew (Han, han) 1.9.9.5 (Han, han) on en a rien à foutre de rien (Han, han) Blackbird (Han, han) L'Entourage (Han, han) on en a rien à foutre de rien, non Nos corps fonctionnent à l'envers, on marche avec des têtes On se sent avec un regard et on joue avec les nerfs Moi, je parle avec les mains, parfois j'pense avec ma Mais je touche avec mes pensées et j'écris avec le cœur J'en ai rien à foutre de rien, rien à foutre de rien, je n'en ai vraiment Rien à foutre de rien, rien à foutre de rien, on verra bien Rien à foutre de rien, rien à foutre de rien, je n'en ai vraiment Rien à foutre de rien, rien à foutre de rien, on verra bien Rien à foutre de rien, rien à foutre de rien, je n'en ai vraiment Rien à foutre de rien, rien à foutre de rien, on verra bien Rien à foutre de rien, rien à foutre de rien, je n'en ai vraiment Rien à foutre de rien, rien à foutre de rien, on verra bien Rien à foutre de rien, rien à foutre de rien, je n'en ai vraiment Rien à foutre de rien, rien à foutre de rien, on verra bien Rien à foutre de rien, rien à foutre de rien, je n'en ai vraiment Rien à foutre de rien, rien à foutre de rien, on verra bien	2022-05-20	17
55	Ma dope	03:25:00	lien_audio_ma_dope.mp3	Yup Anh Anh Check J'en ai rien à foutre de ton avis J'suis seul aux commandes, j'représenterai toujours mes amis Les salauds comme moi, quoi, tu voudrais contrôler ma vie? Wesh, c'est comment? J'en ai rien à foutre de ton avis J'suis seul aux commandes On profite de la journée jusqu'à ce qu'elle parte sur un gros son d'Heltah Skeltah Ramène les 'tasses que t'as, on squatte quelque part, peut-être un skate park, hah Je ne veux pas que l'on me porte Je veux glisser dans ma ville sur un longboard Accoutrements étranges, mes troupes ont la coupe de Trunks et vendent la verte Tu sous-estimes ces blancs, tu prends des coups d'truck dans ta mère Tu t'entraînes sur des rampes jusqu'à ce que tu rampes Tu rentres tard, ça ne mène à rien selon tes rents-pa Un de mes potes fait une chute en skate, fracture du péroné Pendant ce temps-là, moi, j'suis fonce-dé Je répète "Mac Cain" comme un perroquet Mac Cain, Mac Cain, Mac Cain, Mac Cain T'inquiète, ma caille, l'hôpital m'accueille Jamais de repos pour le phénomène au mic' Ils veulent me maquer mais je mène ma quête Prêt à foutre le bordel comme un Rolling Stone Mes gars sont dans la place et tout le monde est stone Ça, c'est ma dope, ça, c'est ma dope Ma ville, mon clan, mon style, mon flow, ça, c'est ma dope Ta petite amie m'appelle "mon beau", ça, c'est ma dope Mamen, ma bande protège mon dos, ça, c'est ma dope Ma ville, mon clan, mon style, mon flow, ça, c'est ma dope Ta petite amie m'appelle "mon beau", ça, c'est ma dope Mamen, ma bande protège mon dos, ça, c'est ma dope Ma ville, mon clan, mon style, mon flow, ça, c'est ma dope Bébé, j'ai quatre-vingt-dix-neuf 'blèmes Je veux pas t'avoir sur le dos, je veux t'avoir sur le ventre On investit des fortunes que l'on n'a pas, pourtant On n'est même pas sûrs de vendre J'laisse pas les radios formater mon boulot En autoprod', je n'suis jamais épuisé Je fais pas mon son pour plaire à Laurent Bouneau Mais c'est une victoire quand il est diffusé Pour mes porteurs de Nikes Pour mes mangeurs de naan cheese Qui ne croient plus rien de ce qu'on leur dit Comme tous les jeunes nés dans les nineties Si tu m'amènes de la thaï', je vais te faire une prise d'aïkido Qui donc bédave autant qu'oim, j'ai des kilos de white widow Widow weed, oh oui, j'ai de la, de la weed, weed d'Hollande, d'Hollande Oui, dawg, on m'en demande en mode dollar-dollar, donnant-donnant Chez moi, c'est à vous de rouler, servez-vous là, question d'honneur Tu sors de là après deux lattes, cerveau troué comme un donut, donut Weed, oh oui, j'ai de la, de la weed, weed d'Hollande, d'Hollande Oui, dawg, on m'en demande en mode dollar-dollar, donnant-donnant Yup Ça, c'est ma dope, ça, c'est ma dope Ma ville, mon clan, mon style, mon flow, ça, c'est ma dope Ta petite amie m'appelle "mon beau", ça, c'est ma dope Mamen, ma bande protège mon dos, ça, c'est ma dope Ma ville, mon clan, mon style, mon flow, ça, c'est ma dope Ta petite amie m'appelle "mon beau", ça, c'est ma dope Mamen, ma bande protège mon dos, ça, c'est ma dope Ma ville, mon clan, mon style, mon flow, ça, c'est ma dope Prêt à foutre le bordel comme un Rolling Stone Mes gars sont dans la place et tout le monde est stone Yup	2022-06-18	17
56	Egérie	03:55:00	lien_audio_egerie.mp3	Je suis devenu celui dont aurait rêvé celui que je rêvais d'être Tu me suis? Je ne veux pas me réveiller Une marque de luxe m'a dit "on veut pas de rap" Tu connais les ches-ri J'ai dit "tant pis, tranquille, moi je parle ap'" Le lendemain, je me suis tapé leur égérie Elle avait le visage de Natalie Portman Elle m'a dit "moi non plus je ne veux pas de vie de couple" Cette nuit, je veux me couper de ce monde qui dégoûte Bébé, viens dans mon hôtel et on éteint les portables J'en connais un rayon, je raconte pas de disquettes Elle a mordu l'oreiller comme si c'était un cheesecake Mais c'est toujours la même, elle a tenu mes mains Elle m'a dit "tu m'aimes?" j'ai dit "non, tu m'aimes?" Je me répète, je n'ai pas de repères Tu n'es pas la seule vraie perle de mon répertoire Un soir, pété sous les réverbères Peut-être que je me retournerais vers toi Le temps passe je ne connais pas le surplace, j'ai Fini pété au milieu des Champs, dans ma ville de champions J'suis comme une bulle de champagne Venu d'en bas je veux crever à la surface Soirée bien arrosée, donnez-moi leur oseille Le saumon sera rosé, le champ' sera rosé Mac Cain Family au stud, ça rappelle Woodstock Cinq dans la Mini aussi, le son t'emmène à Houston Je suis devenu celui dont aurait rêvé celui que je rêvais d'être Tu me suis? Je ne veux pas me réveiller La même marque de luxe m'a dit "on veut bien ton rap" Tu connais les ches-ri J'ai dit "non, merci, j'ai monté ma propre marque" Et rappelez-moi de rappeler votre égérie Je ne lui ai pas donné de nouvelles On n'était pas naturels, on n'était pas nous-même Toujours en déplacement le soir Mais ce qui compte c'est le dépassement de soi Je me dois de profiter de la vie que je mène Avant que le bonheur ne devienne un autre coup dur Je n'avais pas les moyens de bien me saper Maintenant, je m'applique dans la haute couture J'ai vu des gens se noyer, je me permets de détailler Les faits, dur de payer le loyer quand le salaire est faible En effet se tailler les veines est devenu pour certains jeunes Le seul moyen de se faire des grosses coupures Vu ma cons', c'est sûr, j'suis high Je me sens proche de L.A Moi aussi, j'me suis construit sur des failles Tout le monde est mauvais, ils aiment tellement la monnaie Tu parles d'amitié mais tu pars Dès que tu n'as plus besoin de mon aide Même sous jetlag, j'reste un gentleman, menteur C'est dur d'être un jeune qui rejette le mal, mon cœur Irradié aux rayons gamma, laisse-moi tirer de la came Je lis debout dans les rayons manga, parfois, on dirait un gamin "T'es dangereux, Nekfeu, sur scène, tu fais de la merde, t'abuses" Prudence est mère de sûreté, sûreté, ta mère la pute Ils veulent me filer des conseils, mon phone-télé vibre Ils filment mes concerts au lieu de les vivre Frémont Tu vois, cette image qu'ont les gens du rap? Nous, on va changer ça	2022-07-12	17
57	Tempête	04:30:00	lien_audio_tempete.mp3	Je mène pas une vie hyper saine Même si j'ai percé J'aperçois des personnes derrière les persiennes Seul dans mon appart sale Ma soeur révise un partiel Y'a pas de loi impartiale à part le ciel J'suis entouré de zonars sur le sonar Mais c'est trop tard quand les ennuis sont là Les accusés sont sur le banc et transpirent comme au sauna Les mères pleurent comme Solaar T'es jamais à l'abri Le mal me l'a appris La me-la brille, une maman prie Pourquoi tu me l'as pris? Ô Dieu, c'est pas le ciel c'est les Hommes Ô Dieu, leur âme est scellée par le sexe et les sommes J'ai vu le seum donner du sale C'est comme si leur coeur avait regardé les deux yeux de Médusa Le courage et la peur ensemble sont mes deux armes Quand je me sens déraciné je monte au sommet des arbres De là-haut j'vois la mort, faut être précis, elle approche La vie c'est apprécier la vue après scier la branche (Feu, feu, feu, feu, feu, feu, feu...) Avis de tempête Ici on est vite tentés On veut finir du bon côté de la vitre teintée Ah ouais, je sais que t'as envie de tâter Les fonds et les formes pourvu que ça vide ta tête Ah ouais Ici on est vite tentés On veut finir du bon côté de la vitre teintée Ah ouais, je sais que t'as envie de tâter Les fonds et les formes pourvu que ça vide ta tête La nuit je sors sans but comme un somnambule Y'a certains rêves que les Hommes n'ont plus J'ai vu cette fille, on était seuls dans le bus Elle avait les yeux rouges Elle avait pas seulement bu Elle avait de la came dans un sac Balenciaga Elle s'est fait canée, c'est ça de balancer un gars Dans Paname y'en a qui se perdent Y'en a qui espèrent péter des sapes Agnès b. des Nike SB Dehors c'est froid y'a plus d'humanité Un homme est mort inanimé devant un immeuble inhabité (C'est la crise) La crise, qui est-ce qu'elle atteint? Toi, moi ou le suicidaire qui escalade un toit? Ici on est vite tentés On veut finir du bon côté de la vitre teintée Ah ouais, je sais que t'as envie de tâter Les fonds et les formes pourvu que ça vide ta tête Ah ouais, ici on est vite tentés On veut finir du bon côté de la vitre teintée Ah ouais, je sais que t'as envie de tâter Les fonds et les formes pourvu que ça vide ta tête Comme Walter White j'ai mes Clarks Wallabees sœur Serre-moi la main frère, claque-moi la bise Je ne côtoie que des avions à la carlingue parfaite J'ai beaucoup plus de goût que Karl Lagerfeld Le monde de l'art est vantard, ils te vendent du street-art Mais ne veulent surtout pas voir mes scarlas graffeurs vandales (non) (Feu, feu, feu, feu, feu, feu, feu...) Tu peux ressentir l'aura dans nos raps Sortez les anoraks, on aura bientot l'orage selon l'oracle Ma conscience m'a dit "qui es-tu?" Veux-tu vivre dans le vice ou dans la quiétude? Ça dépend où est le pèze, on doit être bêtes, ouais, p't-être Mais ma plume peut clouer le bec de Houellebecq Ici on est vite tentés, il vaut mieux que tu vives ta quête J'ai entendu "vide ta caisse", le lendemain les flics enquêtent Avis de tempête Ici on est vite tentés On veut finir du bon côté de la vitre teintée Ah ouais, je sais que t'as envie de tâter Les fonds et les formes pourvu que ça vide ta tête Ah ouais Ici on est vite tentés On veut finir du bon côté de la vitre teintée Ah ouais, je sais que t'as envie de tâter Les fonds et les formes pourvu que ça vide...	2022-08-04	17
58	Martin Eden	04:10:00	lien_audio_martin_eden.mp3	Wouh, aïeaïeaïeaïeaïe C'est le retour de Ken Masters Kenshin, Kentaro, Ken ken ta sœur On veut tous se mettre bien, rien ne sert de nier On est là, on bougera pas de là maintenant qu'on y est Y a que quand j'suis premier que j'reste à ma place Et y a que quand j'suis premier que j'reste à ma place Ça, c'est pour les miens, nos destins sont liés On est là, on bougera pas de là maintenant qu'on y est Y a que quand j'suis premier que j'reste à ma place Et y a que quand j'suis premier, yeah C'est sur la Seine que les premières lueurs du matin déteignent L'humanité meurt depuis qu'on a quitté l'Jardin d'Éden On a le rêve dans le cœur, le cauchemar dans les veines Plus je monte et plus je m'identifie à Martin Eden Moi, je suis un babtou à part, j'vois plein de babtous pompeux Mais sache que les babtous comme moi N'aiment pas les babtous comme eux Surtout quand les babtous ont peur Tout le monde m'invite dans les plans Fils de pute, bien sûr qu'c'est plus facile pour toi quand t'es blanc Les riches font partie des plus radins dans cet empire de piranhas Parfois, j'reconnais même plus ma patrie comme mon pote Iranien T'oublies tout tellement tu rappes, hein, obligé de se mentir un peu Du genre, si jamais je mets ce panier du premier coup, tout ira bien J'ai jamais tté-gra, t'as rien quand tu taffes peu Il m'faut un casque intégral Je vais braquer l'industrie comme les Daft Punk Ça, c'est pour les miens, nos destins sont liés On est là, on bougera pas de là maintenant qu'on y est Y a que quand je suis premier que je reste à ma place Et y a que quand je suis premier que je reste à ma place On veut se mettre bien, rien ne sert de nier On est là, on bougera pas de là maintenant qu'on y est Y a que quand j'suis premier que je reste à ma place Et y a que quand je suis premier, yeah, yeah J'devais bicrave cette beuh mais j'm'allume un bédo Puis deux, puis un autre Et j'oublie tout sur cette putain de mélodie de piano J'pense à c'garçon si fier, un jour, ses soucis s'intensifièrent Dire qu'on s'est vus hier, aujourd'hui, il survit sur une civière Subir un traumatisme mais t'remettre à moitié Entre médicaments et came Autrement dit, la trame est dramatique Mais, pour faire la fête, pas besoin d'méthamphétamine En fait, t'es faible, frère, mais maintenant fais ta vie J'mets la nitro, j'veux une femme ni trop bête ni trop belle J'fume de l'hydroponique, j'bois de l'hydromel On embarque tout l'équipage ou le bateau ne part pas Si tu parles de ceux qui parlent, fais pas croire que tu parles pas J'ai vomi dans la Benz, oh, de mon homie Kezo Nouveau hoodie Kenzo, c'est comme ça que Ken zone Je me téléporte dans la Batcave, j'aime pas les bords mais pas que "Bla bla bla bla bla" ta gueule, j'ai claqué les portes comme la BAC Ceux qui n'aiment pas le petit Grec seront en rogne Je m'en tape tant que mes tigresses ronronnent Mes ennemis sont en bad, vu qu'ils sont en bas de L'échelle, et j'me fais lécher par les modèles d'Aubade Ah, rien ne sert de nier, y a pas meilleur que nous, y a Connectés aux piliers de L.A. Jusqu'à 'ke-New-Yor' Voyage en avion, on a pris un billet On a fait le show et on a pris un billet Ça, c'est pour les miens, nos destins sont liés On est là, on bougera pas de là maintenant qu'on y est Y a que quand je suis premier que je reste à ma place Et y a que quand je suis premier que je reste à ma place On veut se mettre bien, rien ne sert de nier On est là, on bougera pas de là maintenant qu'on y est Y a que quand je suis premier que je reste à ma place Et y a que quand je suis premier, yeah, yeah Yah Yah Yah Yah Yah Yah Je vais transformer en S dollar le S du S-Crew Transformer en S dollar le S du S-Crew Transformer en S dollar le S du S-Crew Après 1995, il me semble qu'il manque un K Rien ne sert de nier! Je vais le faire en mode Tupac Rien ne sert de nier! S-crew Hugz, t'es en feu sur celle-là!	2022-09-01	17
59	Θ. Macarena	03:40:00	lien_audio_macarena.mp3	Double X on the track, bitch Le monde est à nous, le monde est à toi et moi Mais peut-être que sans moi le monde sera à toi Et peut-être qu'avec lui le monde sera à vous, et c'est peut-être mieux ainsi Mes sentiments dansent la macarena Donc je me dis qu'si t'es avec lui, tu t'sentiras mieux Mais si tu t'sens mieux, tu t'souviendras plus de moi, oh la la Mon cœur danse la macarena la-la la-la la-la la-la la-la Oh la la Mon cœur danse la macarena la-la la-la la-la la-la la-la Sabrina T'es déjà trentenaire, on s'envoie en l'air mais j'ai qu'la vingtaine, donc j'ai qu'ça à faire Me parle pas de mariage, j'te Fais perdre ton temps mais qu'est-ce que c'est bon quand j'pelote tes implants J'me sens comme avant comme quand j'n'avais rien à battre, je Suis jeune, m'en fous d'l'avenir, de c'que notre relation va devenir Mais pour lui c'n'est pas le cas, il a déjà un taf, il fait le mec mature Mais tu sais qu'au lit, plus que lui j'assure Rappelle-toi quand t'avais des courbatures, j't'avais bien niqué ta race Rappelle-toi bien de la suite, dans les hôtels et les suites J't'invitais aux soirées VIP, à la télé, tu regardais mes clips On l'a fait sans autotune, sur une prod de Twinsmatic C'est ma manière romantique de dire que j'n'avais pas mis de préservatif Le monde est à nous, le monde est à toi et moi Mais peut-être que sans moi le monde sera à toi Et peut-être qu'avec lui le monde sera à vous, et c'est peut-être mieux ainsi Mes sentiments dansent la macarena Donc je me dis qu'si t'es avec lui, tu t'sentiras mieux Mais si tu t'sens mieux, tu t'souviendras plus de moi, oh la la Mon cœur danse la macarena la-la la-la la-la la-la la-la Oh la la Mon cœur danse la macarena la-la la-la la-la la-la la-la J'ai fait semblant d'bien aller Quand t'as démarré, qu't'es allée chez lui, ben nan j'ai rien dit Pourtant j'le savais qu'tu baisais pour t'évader Après tout j'étais là que pour dépanner (oui) J'vais pas trop m'étaler, saigner fallait, blessé j'étais J't'ai remballé, tu m'as remplacé, tu m'as délaissé (oui) Mais comme tout salaud, j't'ai téléphoné, j't'ai récupéré Puis j't'ai fait pleurer parce que j'en ai rien à foutre, c'est ça la life (ouais) Qu'est-c'tu croyais? Tu baises avec moi, tu baises avec d'autres Même si j'fais pareil, c'est pas la même chose Ben oui et non, moi, j'ai besoin d'ma dose, de ma libido Et casse pas les illes-c', fais pas celle qui réplique T'façon j'veux plus trop qu'on s'explique Peut-être qu'avec lui le monde sera à vous et c'est peut-être mieux ainsi Donc je me dis qu'si t'es avec lui, tu t'sentiras mieux Mais si tu t'sens mieux, tu t'souviendras plus de moi Oh la la (oui) Mon cœur danse la macarena la-la la-la la-la la-la la-la Oh la la (oui, oui) Mon cœur danse la macarena la-la la-la la-la la-la la-la Oui Dams Oui, oui, oui, oui	2022-10-15	18
60	Amnésie	04:15:00	lien_audio_amnesie.mp3	\N	2022-11-12	18
61	Mosaïque solitaire	04:05:00	lien_audio_mosaique_solitaire.mp3	\N	2022-12-05	18
62	Deux toiles de mer	03:55:00	lien_audio_deux_toiles_de_mer.mp3	\N	2023-01-20	18
63	Dieu ne ment jamais	04:40:00	lien_audio_dieu_ment_jamais.mp3	\N	2023-02-28	18
64	Bohemian Rhapsody	06:00:00	lien_audio_bohemian_rhapsody.mp3	\N	1975-10-31	19
65	Another One Bites the Dust	03:35:00	lien_audio_another_one.mp3	\N	1980-08-22	19
66	We Will Rock You	02:00:00	lien_audio_we_will_rock_you.mp3	\N	1977-10-07	19
67	Under Pressure	04:05:00	lien_audio_under_pressure.mp3	\N	1981-10-27	19
68	Somebody to Love	04:55:00	lien_audio_somebody_to_love.mp3	\N	1976-11-12	19
69	Reve bizzare	3:20:00 	lien_audio_reve_bizzare.mp3	\N	2019-12-03	16
70	Zone	4:00:00	lien_audio_zone.mp3	\N	2023-01-02	16
71	Tricheur	3:50:00	lien_audio_tricheur.mp3	\N	2023-10-09	17
72	Sendu	3:50:00	lien_audio_sendu.mp3	\N	1980-10-09	9
73	Vava inouva	3:50:00	lien_audio_vava.mp3	\N	1980-10-09	9
74	Manu	3:50:00	lien_audio_manu.mp3	\N	1980-10-09	3
75	Godsplan	3:50:00	lien_audio_godsplan.mp3	\N	2023-10-09	20
76	Emotionless	3:50:00	lien_audio_Emotionless.mp3	\N	2023-10-09	20
77	I'm upset	3:50:00	lien_audio_imupset.mp3	\N	2023-10-09	20
\.


--
-- Data for Name: participe; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.participe (id_mor, id_art) FROM stdin;
1	1
1	2
1	3
1	4
2	1
2	2
2	3
2	4
3	1
3	2
3	3
3	4
4	5
4	6
4	7
4	8
4	9
5	5
5	6
5	7
5	8
5	9
9	5
9	2
6	12
8	11
7	10
10	10
10	13
11	13
12	13
13	13
14	14
14	15
14	16
14	17
14	18
14	19
14	20
14	21
15	15
15	16
16	17
17	23
18	23
19	23
20	25
20	26
20	27
20	28
20	29
21	25
21	26
21	27
21	28
21	29
22	25
22	26
22	27
22	28
22	29
23	21
24	21
25	21
26	10
27	10
34	30
35	30
36	30
37	30
38	30
34	31
35	31
36	31
37	31
38	31
34	32
35	32
36	32
37	32
38	32
34	33
35	33
36	33
37	33
38	33
34	34
35	34
36	34
37	34
38	34
34	35
35	35
36	35
37	35
38	35
39	30
40	30
41	30
42	30
43	30
44	34
45	34
46	34
47	34
48	34
49	36
50	36
51	36
52	36
53	36
54	37
55	37
56	37
57	37
58	37
59	38
60	38
61	38
62	38
63	38
64	39
65	39
66	39
67	39
68	39
10	43
69	36
69	38
70	36
70	37
71	37
71	38
75	43
76	43
77	43
74	11
72	24
73	24
\.


--
-- Data for Name: playlist; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.playlist (id_pl, nom_playlist, description_playlist, statut, proprietaire, date_creation) FROM stdin;
1	Wavekpop	fun	public	drose_x9	2023-12-17 17:14:40
2	Blackpink_playlist	for blinks	private	drose_x9	2023-12-17 17:14:40
3	Algerian_music	nostalgie	private	ghiles	2023-12-17 17:14:40
4	Worldwide_song	travel with music	public	miguel	2023-12-17 17:14:40
5	Mix_renaud	cest pas lhomme qui prend la mer	public	marie	2023-12-17 17:14:40
6	Rap FR	Classiques du rap français	public	Olteron	2023-12-17 17:30:17
7	Secret playlist	this is some music that i quite like but want people to know about it	private	Momo	2023-12-17 18:08:59
8	Nekfeu ma vie 😍	Il est trop deep	public	clara_la_blonde	2023-12-17 18:21:28
9	Rap US	Da Hood	public	Mike Oxlong	2023-12-17 18:53:08
\.


--
-- Data for Name: sauvegarde_playlist; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sauvegarde_playlist (pseudo, id_pl) FROM stdin;
Olteron	4
Momo	6
Momo	1
Momo	5
Momo	4
drose_x9	6
miguel	6
Mike Oxlong	6
\.


--
-- Data for Name: suit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.suit (follower, following) FROM stdin;
drose_x9	miguel
drose_x9	marie
ghiles	drose_x9
ghiles	miguel
marie	miguel
miguel	drose_x9
miguel	ghiles
miguel	marie
ghiles	Olteron
Olteron	ghiles
Olteron	miguel
Momo	Olteron
Momo	miguel
Momo	marie
Momo	drose_x9
clara_la_blonde	Olteron
drose_x9	Olteron
marie	Olteron
miguel	Olteron
\.


--
-- Data for Name: utilisateur; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.utilisateur (pseudo, mdp, date_insc, email) FROM stdin;
drose_x9	$2b$12$C7/K7StgJSByBHk6A6SymOoj.E4LIGGHKKFPaPFXnpfIxqc.6bFUW	2015-01-02	idir@gmail.com
ghiles	$2b$12$2uO9ePn4WVVf/MdnI0MDzeyIdKQLf1pYcmnGdtPRrtgWvJIx44IK.	2015-01-02	ghiles@gmail.com
miguel	$2b$12$SIFAI9W7uwOrSQqdpb0E4.wk6yaT9aJVuUgk8xjL9e69BeRU1H1yu	2015-01-02	miguel@gmail.com
marie	$2b$12$NaRxRM4N2IGu64hXqhRlE.t3flngEqcGvKy03RZhXIbwpEUQsx7eK	2015-01-02	marie@gmail.com
Olteron	$2b$12$ZCWHOQhxdtt2s8eycibD/.kEZzj.TAHybx8/psSVhfyWw1f8nJjja	2023-12-17	olteron@gmail.com  
Momo	$2b$12$eiJrqXxG/QW99AXnkdfK8exiSPMB8KktM3ICs.gsHEJQUP6KskiDG	2023-12-17	momo@gmail.com    
clara_la_blonde	$2b$12$03vs.VMaS/TTaMzKfMmNnegAMco5DE8VEDzQT0qfP8jUwpuqY33Pe	2023-12-17	clara@gmail.com  
Mike Oxlong	$2b$12$VLIl3BPPgs2AMU/s7bEE/OrYEEO0CqpyAjOaxisczXO.94Yd5U88G	2023-12-17	mikoxlong@gmail.com 
\.


--
-- Name: album_id_alb_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.album_id_alb_seq', 24, true);


--
-- Name: artiste_id_art_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.artiste_id_art_seq', 42, true);


--
-- Name: groupe_id_grp_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.groupe_id_grp_seq', 19, true);


--
-- Name: morceau_id_mor_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.morceau_id_mor_seq', 68, true);


--
-- Name: playlist_id_pl_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.playlist_id_pl_seq', 9, true);


--
-- Name: album album_couverture_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.album
    ADD CONSTRAINT album_couverture_key UNIQUE (couverture);


--
-- Name: album album_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.album
    ADD CONSTRAINT album_pkey PRIMARY KEY (id_alb);


--
-- Name: artiste artiste_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.artiste
    ADD CONSTRAINT artiste_pkey PRIMARY KEY (id_art);


--
-- Name: contient contient_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contient
    ADD CONSTRAINT contient_pkey PRIMARY KEY (id_alb, id_mor);


--
-- Name: ecoute ecoute_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ecoute
    ADD CONSTRAINT ecoute_pkey PRIMARY KEY (id_mor, pseudo, date_ecoute);


--
-- Name: est_abonne est_abonne_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.est_abonne
    ADD CONSTRAINT est_abonne_pkey PRIMARY KEY (pseudo, id_grp);


--
-- Name: est_dans est_dans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.est_dans
    ADD CONSTRAINT est_dans_pkey PRIMARY KEY (id_mor, id_pl);


--
-- Name: fait_partie fait_partie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fait_partie
    ADD CONSTRAINT fait_partie_pkey PRIMARY KEY (id_art, id_grp, role, date_arr);


--
-- Name: groupe groupe_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groupe
    ADD CONSTRAINT groupe_pkey PRIMARY KEY (id_grp);


--
-- Name: mets_album_favoris mets_album_favoris_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mets_album_favoris
    ADD CONSTRAINT mets_album_favoris_pkey PRIMARY KEY (pseudo, id_alb);


--
-- Name: mets_en_favoris mets_en_favoris_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mets_en_favoris
    ADD CONSTRAINT mets_en_favoris_pkey PRIMARY KEY (pseudo, id_mor);


--
-- Name: morceau morceau_audio_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.morceau
    ADD CONSTRAINT morceau_audio_key UNIQUE (audio);


--
-- Name: morceau morceau_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.morceau
    ADD CONSTRAINT morceau_pkey PRIMARY KEY (id_mor);


--
-- Name: participe participe_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.participe
    ADD CONSTRAINT participe_pkey PRIMARY KEY (id_art, id_mor);


--
-- Name: playlist playlist_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.playlist
    ADD CONSTRAINT playlist_pkey PRIMARY KEY (id_pl);


--
-- Name: sauvegarde_playlist sauvegarde_playlist_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sauvegarde_playlist
    ADD CONSTRAINT sauvegarde_playlist_pkey PRIMARY KEY (pseudo, id_pl);


--
-- Name: suit suit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suit
    ADD CONSTRAINT suit_pkey PRIMARY KEY (follower, following);


--
-- Name: utilisateur utilisateur_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utilisateur
    ADD CONSTRAINT utilisateur_email_key UNIQUE (email);


--
-- Name: utilisateur utilisateur_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utilisateur
    ADD CONSTRAINT utilisateur_pkey PRIMARY KEY (pseudo);


--
-- Name: album album_id_grp_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.album
    ADD CONSTRAINT album_id_grp_fkey FOREIGN KEY (id_grp) REFERENCES public.groupe(id_grp) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: contient contient_id_alb_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contient
    ADD CONSTRAINT contient_id_alb_fkey FOREIGN KEY (id_alb) REFERENCES public.album(id_alb) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: contient contient_id_mor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contient
    ADD CONSTRAINT contient_id_mor_fkey FOREIGN KEY (id_mor) REFERENCES public.morceau(id_mor) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ecoute ecoute_id_mor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ecoute
    ADD CONSTRAINT ecoute_id_mor_fkey FOREIGN KEY (id_mor) REFERENCES public.morceau(id_mor) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ecoute ecoute_pseudo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ecoute
    ADD CONSTRAINT ecoute_pseudo_fkey FOREIGN KEY (pseudo) REFERENCES public.utilisateur(pseudo) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: est_abonne est_abonne_id_grp_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.est_abonne
    ADD CONSTRAINT est_abonne_id_grp_fkey FOREIGN KEY (id_grp) REFERENCES public.groupe(id_grp) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: est_abonne est_abonne_pseudo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.est_abonne
    ADD CONSTRAINT est_abonne_pseudo_fkey FOREIGN KEY (pseudo) REFERENCES public.utilisateur(pseudo) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: est_dans est_dans_id_mor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.est_dans
    ADD CONSTRAINT est_dans_id_mor_fkey FOREIGN KEY (id_mor) REFERENCES public.morceau(id_mor) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: est_dans est_dans_id_pl_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.est_dans
    ADD CONSTRAINT est_dans_id_pl_fkey FOREIGN KEY (id_pl) REFERENCES public.playlist(id_pl) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fait_partie fait_partie_id_art_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fait_partie
    ADD CONSTRAINT fait_partie_id_art_fkey FOREIGN KEY (id_art) REFERENCES public.artiste(id_art) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fait_partie fait_partie_id_grp_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fait_partie
    ADD CONSTRAINT fait_partie_id_grp_fkey FOREIGN KEY (id_grp) REFERENCES public.groupe(id_grp) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: mets_album_favoris mets_album_favoris_id_alb_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mets_album_favoris
    ADD CONSTRAINT mets_album_favoris_id_alb_fkey FOREIGN KEY (id_alb) REFERENCES public.album(id_alb) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: mets_album_favoris mets_album_favoris_pseudo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mets_album_favoris
    ADD CONSTRAINT mets_album_favoris_pseudo_fkey FOREIGN KEY (pseudo) REFERENCES public.utilisateur(pseudo) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: mets_en_favoris mets_en_favoris_id_mor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mets_en_favoris
    ADD CONSTRAINT mets_en_favoris_id_mor_fkey FOREIGN KEY (id_mor) REFERENCES public.morceau(id_mor) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: mets_en_favoris mets_en_favoris_pseudo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mets_en_favoris
    ADD CONSTRAINT mets_en_favoris_pseudo_fkey FOREIGN KEY (pseudo) REFERENCES public.utilisateur(pseudo) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: morceau morceau_id_grp_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.morceau
    ADD CONSTRAINT morceau_id_grp_fkey FOREIGN KEY (id_grp) REFERENCES public.groupe(id_grp) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: participe participe_id_art_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.participe
    ADD CONSTRAINT participe_id_art_fkey FOREIGN KEY (id_art) REFERENCES public.artiste(id_art) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: participe participe_id_mor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.participe
    ADD CONSTRAINT participe_id_mor_fkey FOREIGN KEY (id_mor) REFERENCES public.morceau(id_mor) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: playlist playlist_proprietaire_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.playlist
    ADD CONSTRAINT playlist_proprietaire_fkey FOREIGN KEY (proprietaire) REFERENCES public.utilisateur(pseudo) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: sauvegarde_playlist sauvegarde_playlist_id_pl_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sauvegarde_playlist
    ADD CONSTRAINT sauvegarde_playlist_id_pl_fkey FOREIGN KEY (id_pl) REFERENCES public.playlist(id_pl) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: sauvegarde_playlist sauvegarde_playlist_pseudo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sauvegarde_playlist
    ADD CONSTRAINT sauvegarde_playlist_pseudo_fkey FOREIGN KEY (pseudo) REFERENCES public.utilisateur(pseudo) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: suit suit_follower_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suit
    ADD CONSTRAINT suit_follower_fkey FOREIGN KEY (follower) REFERENCES public.utilisateur(pseudo) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: suit suit_following_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suit
    ADD CONSTRAINT suit_following_fkey FOREIGN KEY (following) REFERENCES public.utilisateur(pseudo) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

