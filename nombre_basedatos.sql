--
-- PostgreSQL database dump
--

-- Dumped from database version 16.0 (Debian 16.0-1.pgdg120+1)
-- Dumped by pg_dump version 16.0 (Debian 16.0-1.pgdg120+1)

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
-- Name: qubytss_core; Type: SCHEMA; Schema: -; Owner: qubytss_core
--

CREATE SCHEMA qubytss_core;


ALTER SCHEMA qubytss_core OWNER TO qubytss_core;

--
-- Name: qubytss_rrhh; Type: SCHEMA; Schema: -; Owner: qubytss_rrhh
--

CREATE SCHEMA qubytss_rrhh;


ALTER SCHEMA qubytss_rrhh OWNER TO qubytss_rrhh;

--
-- Name: get_next_correlativo(character varying); Type: FUNCTION; Schema: qubytss_core; Owner: qubytss_core
--

CREATE FUNCTION qubytss_core.get_next_correlativo(keycorr character varying) RETURNS bigint
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
   value bigint;
begin
   SELECT MAX(last_corr)
     INTO value
     FROM qubytss_core.correlativo
    WHERE key_corr = keycorr;

   IF value IS NULL THEN
        value = 1;
        INSERT INTO correlativo(key_corr, last_corr) VALUES(keycorr, value);
   ELSE
        value = value + 1;
        UPDATE correlativo SET
            last_corr = value
        WHERE key_corr = keycorr;
   END IF;

   RETURN value;
end;
$$;


ALTER FUNCTION qubytss_core.get_next_correlativo(keycorr character varying) OWNER TO qubytss_core;

--
-- Name: get_cod_planilla(integer); Type: FUNCTION; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

CREATE FUNCTION qubytss_rrhh.get_cod_planilla(idplanilla integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
      v_num    varchar;
      r record;
BEGIN

    SELECT pl.id_anio,
           pl.id_mes,
           pt.cod_tipo_pla,
           tt.cod_tipo_trabajador,
           'PL' AS prefijo
           INTO r
      FROM qubytss_rrhh.planilla pl
           INNER JOIN qubytss_rrhh.planilla_tipo pt
                   ON pl.id_tipo_planilla = pt.id_tipo_planilla
           INNER JOIN qubytss_rrhh.trabajador_tipo tt
                   ON pl.id_tipo_trabajador = tt.id_tipo_trabajador
     WHERE id_planilla = idplanilla;

     SELECT r.prefijo
       || r.id_anio
       || r.id_mes
       || r.cod_tipo_pla
       || r.cod_tipo_trabajador
       || lpad(qubytss_core.get_next_correlativo('PLANILLA.RRHH.'
                                                     || r.prefijo
                                                     || '.'
                                                     || r.id_anio
                                                     || '.'
                                                     || r.id_mes
                                                     || '.'
                                                     || r.cod_tipo_pla
                                                     || '.'
                                                     || r.cod_tipo_trabajador) :: text, 2, '0')
     INTO v_num;


    RETURN v_num;
END;
$$;


ALTER FUNCTION qubytss_rrhh.get_cod_planilla(idplanilla integer) OWNER TO qubytss_rrhh;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: anio; Type: TABLE; Schema: public; Owner: qubytss_core
--

CREATE TABLE public.anio (
    id_anio integer NOT NULL,
    cod_anio character varying(20) NOT NULL,
    nom_anio character varying(500),
    fech_ini_anio date,
    fech_fin_anio date,
    esta_anio character(1)
);


ALTER TABLE public.anio OWNER TO qubytss_core;

--
-- Name: TABLE anio; Type: COMMENT; Schema: public; Owner: qubytss_core
--

COMMENT ON TABLE public.anio IS 'Catálogo de años';


--
-- Name: COLUMN anio.id_anio; Type: COMMENT; Schema: public; Owner: qubytss_core
--

COMMENT ON COLUMN public.anio.id_anio IS 'Identificador del año';


--
-- Name: COLUMN anio.cod_anio; Type: COMMENT; Schema: public; Owner: qubytss_core
--

COMMENT ON COLUMN public.anio.cod_anio IS 'Código';


--
-- Name: COLUMN anio.nom_anio; Type: COMMENT; Schema: public; Owner: qubytss_core
--

COMMENT ON COLUMN public.anio.nom_anio IS 'Nombre del año';


--
-- Name: COLUMN anio.fech_ini_anio; Type: COMMENT; Schema: public; Owner: qubytss_core
--

COMMENT ON COLUMN public.anio.fech_ini_anio IS 'Fecha de inicio del año';


--
-- Name: COLUMN anio.fech_fin_anio; Type: COMMENT; Schema: public; Owner: qubytss_core
--

COMMENT ON COLUMN public.anio.fech_fin_anio IS 'Fecha de término del año';


--
-- Name: COLUMN anio.esta_anio; Type: COMMENT; Schema: public; Owner: qubytss_core
--

COMMENT ON COLUMN public.anio.esta_anio IS 'Estado del año (A=Abierto, C=Cerrado)';


--
-- Name: anio; Type: TABLE; Schema: qubytss_core; Owner: qubytss_core
--

CREATE TABLE qubytss_core.anio (
    id_anio integer NOT NULL,
    cod_anio character varying(20) NOT NULL,
    nom_anio character varying(500),
    fech_ini_anio date,
    fech_fin_anio date,
    esta_anio character(1)
);


ALTER TABLE qubytss_core.anio OWNER TO qubytss_core;

--
-- Name: TABLE anio; Type: COMMENT; Schema: qubytss_core; Owner: qubytss_core
--

COMMENT ON TABLE qubytss_core.anio IS 'Catálogo de años';


--
-- Name: COLUMN anio.id_anio; Type: COMMENT; Schema: qubytss_core; Owner: qubytss_core
--

COMMENT ON COLUMN qubytss_core.anio.id_anio IS 'Identificador del año';


--
-- Name: COLUMN anio.cod_anio; Type: COMMENT; Schema: qubytss_core; Owner: qubytss_core
--

COMMENT ON COLUMN qubytss_core.anio.cod_anio IS 'Código';


--
-- Name: COLUMN anio.nom_anio; Type: COMMENT; Schema: qubytss_core; Owner: qubytss_core
--

COMMENT ON COLUMN qubytss_core.anio.nom_anio IS 'Nombre del año';


--
-- Name: COLUMN anio.fech_ini_anio; Type: COMMENT; Schema: qubytss_core; Owner: qubytss_core
--

COMMENT ON COLUMN qubytss_core.anio.fech_ini_anio IS 'Fecha de inicio del año';


--
-- Name: COLUMN anio.fech_fin_anio; Type: COMMENT; Schema: qubytss_core; Owner: qubytss_core
--

COMMENT ON COLUMN qubytss_core.anio.fech_fin_anio IS 'Fecha de término del año';


--
-- Name: COLUMN anio.esta_anio; Type: COMMENT; Schema: qubytss_core; Owner: qubytss_core
--

COMMENT ON COLUMN qubytss_core.anio.esta_anio IS 'Estado del año (A=Abierto, C=Cerrado)';


--
-- Name: correlativo; Type: TABLE; Schema: qubytss_core; Owner: qubytss_core
--

CREATE TABLE qubytss_core.correlativo (
    key_corr character varying(100) NOT NULL,
    last_corr bigint
);


ALTER TABLE qubytss_core.correlativo OWNER TO qubytss_core;

--
-- Name: TABLE correlativo; Type: COMMENT; Schema: qubytss_core; Owner: qubytss_core
--

COMMENT ON TABLE qubytss_core.correlativo IS 'Correlativo de documentos';


--
-- Name: COLUMN correlativo.key_corr; Type: COMMENT; Schema: qubytss_core; Owner: qubytss_core
--

COMMENT ON COLUMN qubytss_core.correlativo.key_corr IS 'Clave del correlativo';


--
-- Name: COLUMN correlativo.last_corr; Type: COMMENT; Schema: qubytss_core; Owner: qubytss_core
--

COMMENT ON COLUMN qubytss_core.correlativo.last_corr IS 'Ultimo valor generado';


--
-- Name: id_persona_seq; Type: SEQUENCE; Schema: qubytss_core; Owner: qubytss_core
--

CREATE SEQUENCE qubytss_core.id_persona_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999
    CACHE 1;


ALTER SEQUENCE qubytss_core.id_persona_seq OWNER TO qubytss_core;

--
-- Name: list; Type: TABLE; Schema: qubytss_core; Owner: qubytss_core
--

CREATE TABLE qubytss_core.list (
    id_lista integer NOT NULL,
    entidad character varying(30),
    cod_lista character varying(30),
    desc_lista character varying(300),
    estado_lista integer NOT NULL
);


ALTER TABLE qubytss_core.list OWNER TO qubytss_core;

--
-- Name: mes; Type: TABLE; Schema: qubytss_core; Owner: qubytss_core
--

CREATE TABLE qubytss_core.mes (
    id_mes character varying(2) NOT NULL,
    nomb_mes character varying(10),
    nomb_cort_mes character varying(4)
);


ALTER TABLE qubytss_core.mes OWNER TO qubytss_core;

--
-- Name: persona; Type: TABLE; Schema: qubytss_core; Owner: qubytss_core
--

CREATE TABLE qubytss_core.persona (
    id_persona integer DEFAULT nextval('qubytss_core.id_persona_seq'::regclass) NOT NULL,
    tipo_per character(1) NOT NULL,
    tipo_doc_per integer,
    nro_doc_per character varying(20),
    ape_pat_per character varying(100),
    ape_mat_per character varying(100),
    nomb_per character varying(200),
    direc_per character varying(500),
    sex_per character(1),
    fech_nac_per date,
    id_pais_nac integer,
    aud_fech_crea date DEFAULT now() NOT NULL,
    est_civil_per character(1),
    id_ubigeo_nac integer,
    nro_ruc character varying(11),
    id_pais_emisor_doc integer
);


ALTER TABLE qubytss_core.persona OWNER TO qubytss_core;

--
-- Name: COLUMN persona.tipo_per; Type: COMMENT; Schema: qubytss_core; Owner: qubytss_core
--

COMMENT ON COLUMN qubytss_core.persona.tipo_per IS 'Tipo de persona (N=Natural, J=Jurídica)';


--
-- Name: COLUMN persona.tipo_doc_per; Type: COMMENT; Schema: qubytss_core; Owner: qubytss_core
--

COMMENT ON COLUMN qubytss_core.persona.tipo_doc_per IS 'Tipo de documento (LISTA[DOC-IDENTIDAD])';


--
-- Name: COLUMN persona.sex_per; Type: COMMENT; Schema: qubytss_core; Owner: qubytss_core
--

COMMENT ON COLUMN qubytss_core.persona.sex_per IS 'Tipo de persona (M=Masculino, F=Femenino)';


--
-- Name: COLUMN persona.id_pais_nac; Type: COMMENT; Schema: qubytss_core; Owner: qubytss_core
--

COMMENT ON COLUMN qubytss_core.persona.id_pais_nac IS 'País de nacimiento (LISTA[PAIS])';


--
-- Name: COLUMN persona.est_civil_per; Type: COMMENT; Schema: qubytss_core; Owner: qubytss_core
--

COMMENT ON COLUMN qubytss_core.persona.est_civil_per IS 'Estado civil (S=Soltero, C=Casado, V=Viudo, D=Divorciado)';


--
-- Name: COLUMN persona.id_pais_emisor_doc; Type: COMMENT; Schema: qubytss_core; Owner: qubytss_core
--

COMMENT ON COLUMN qubytss_core.persona.id_pais_emisor_doc IS 'País de nacimiento (LISTA[PAIS])';


--
-- Name: concepto; Type: TABLE; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

CREATE TABLE qubytss_rrhh.concepto (
    id_concepto integer NOT NULL,
    cod_conc character varying(10) NOT NULL,
    nomb_conc character varying(300),
    tipo_conc integer,
    fech_reg_conc date,
    id_sub_tipo_conc integer,
    afecto_essalud boolean,
    afecto_previsional boolean,
    afecto_impuesto boolean,
    bonif_ext boolean,
    est_conc integer
);


ALTER TABLE qubytss_rrhh.concepto OWNER TO qubytss_rrhh;

--
-- Name: TABLE concepto; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON TABLE qubytss_rrhh.concepto IS 'Concepto';


--
-- Name: COLUMN concepto.id_concepto; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.concepto.id_concepto IS 'Código único del concepto';


--
-- Name: COLUMN concepto.cod_conc; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.concepto.cod_conc IS 'Código del concepto';


--
-- Name: COLUMN concepto.nomb_conc; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.concepto.nomb_conc IS 'Nombre';


--
-- Name: COLUMN concepto.tipo_conc; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.concepto.tipo_conc IS 'Tipo (1=REMUNERACION, 2=DESCUENTO, 3=REINTEGRO, 4=APORTE)';


--
-- Name: COLUMN concepto.fech_reg_conc; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.concepto.fech_reg_conc IS 'Fecha de registro';


--
-- Name: COLUMN concepto.id_sub_tipo_conc; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.concepto.id_sub_tipo_conc IS 'Sub tipo de concepto (bytsscom_bytcore.lista(SUB-TIPO-CONCEPTO))';


--
-- Name: COLUMN concepto.afecto_essalud; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.concepto.afecto_essalud IS 'Afecto essalud (1=SI, 0=NO)';


--
-- Name: COLUMN concepto.afecto_previsional; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.concepto.afecto_previsional IS 'Afecto previsional (1=SI, 0=NO)';


--
-- Name: COLUMN concepto.afecto_impuesto; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.concepto.afecto_impuesto IS 'Afecto impuesto (1=SI, 0=NO)';


--
-- Name: COLUMN concepto.est_conc; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.concepto.est_conc IS 'Estado del concepto (1=Activo, 0=Inactivo)';


--
-- Name: planilla; Type: TABLE; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

CREATE TABLE qubytss_rrhh.planilla (
    id_planilla integer NOT NULL,
    id_planilla_plantilla integer,
    id_tipo_planilla integer,
    id_tipo_trabajador integer,
    id_estado_personal_pla integer,
    id_clasificador integer,
    est_planilla integer,
    id_anio integer,
    id_mes character varying(2),
    num_planilla character varying(20),
    tit_planilla character varying(500),
    obs_planilla character varying(500),
    id_persona_registro integer,
    id_persona_proceso integer,
    id_persona_transf integer,
    id_persona_cierre integer,
    fech_cierre_pla timestamp without time zone,
    sys_fech_registro timestamp without time zone DEFAULT now(),
    fech_transf timestamp without time zone
);


ALTER TABLE qubytss_rrhh.planilla OWNER TO qubytss_rrhh;

--
-- Name: planilla_tipo; Type: TABLE; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

CREATE TABLE qubytss_rrhh.planilla_tipo (
    id_tipo_planilla integer NOT NULL,
    cod_tipo_pla character varying(10),
    nomb_tipo_pla character varying(100),
    est_tipo_pla integer
);


ALTER TABLE qubytss_rrhh.planilla_tipo OWNER TO qubytss_rrhh;

--
-- Name: planilla_trabajador; Type: TABLE; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

CREATE TABLE qubytss_rrhh.planilla_trabajador (
    id_planilla integer NOT NULL,
    id_persona integer NOT NULL,
    id_corr_trab integer NOT NULL,
    id_unidad integer,
    id_area integer,
    id_tipo_personal_pla integer,
    id_estado_personal_pla integer,
    id_condicion_pla integer,
    id_categoria_pla integer,
    id_cargo_laboral integer,
    id_regimen_salud integer,
    id_regimen_pension integer,
    id_regimen_pension_estado integer,
    fech_ingreso date,
    fech_cese date,
    declaracion_jurada character varying(200),
    tipo_pago character(1),
    id_banco integer,
    num_cuenta_banco character varying(30),
    cuspp character varying(15),
    num_regimen_salud character varying(20),
    situacion integer,
    observacion character varying(2000),
    id_sub_subvencion integer,
    is_monto_excedente numeric(20,4)
);


ALTER TABLE qubytss_rrhh.planilla_trabajador OWNER TO qubytss_rrhh;

--
-- Name: TABLE planilla_trabajador; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON TABLE qubytss_rrhh.planilla_trabajador IS 'Trabajadores de la planilla';


--
-- Name: COLUMN planilla_trabajador.id_planilla; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.planilla_trabajador.id_planilla IS 'Código único de la planilla';


--
-- Name: COLUMN planilla_trabajador.id_persona; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.planilla_trabajador.id_persona IS 'Código único de persona';


--
-- Name: COLUMN planilla_trabajador.id_corr_trab; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.planilla_trabajador.id_corr_trab IS 'Correlativo de trabajador';


--
-- Name: COLUMN planilla_trabajador.id_unidad; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.planilla_trabajador.id_unidad IS 'Código único de la dependencia/facultad';


--
-- Name: COLUMN planilla_trabajador.id_area; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.planilla_trabajador.id_area IS 'Código único de la unidad';


--
-- Name: COLUMN planilla_trabajador.observacion; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.planilla_trabajador.observacion IS 'Observación en planilla para el trabajador';


--
-- Name: COLUMN planilla_trabajador.id_sub_subvencion; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.planilla_trabajador.id_sub_subvencion IS 'Código sub subvencion de planilla subvencion';


--
-- Name: COLUMN planilla_trabajador.is_monto_excedente; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.planilla_trabajador.is_monto_excedente IS 'Monto excedente del trabajador por mes';


--
-- Name: planilla_trabajador_concepto; Type: TABLE; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

CREATE TABLE qubytss_rrhh.planilla_trabajador_concepto (
    id_planilla integer NOT NULL,
    id_persona integer NOT NULL,
    id_corr_trab integer NOT NULL,
    id_concepto integer NOT NULL,
    monto_conc numeric(20,4),
    tipo_conc_pla integer,
    id_registro integer,
    id_corr_fase integer,
    id_grupo integer,
    id_clasificador integer
);


ALTER TABLE qubytss_rrhh.planilla_trabajador_concepto OWNER TO qubytss_rrhh;

--
-- Name: TABLE planilla_trabajador_concepto; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON TABLE qubytss_rrhh.planilla_trabajador_concepto IS 'Trabajadores de la planilla';


--
-- Name: COLUMN planilla_trabajador_concepto.id_planilla; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.planilla_trabajador_concepto.id_planilla IS 'Código único de la planilla';


--
-- Name: COLUMN planilla_trabajador_concepto.id_persona; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.planilla_trabajador_concepto.id_persona IS 'Código único de persona';


--
-- Name: COLUMN planilla_trabajador_concepto.id_corr_trab; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.planilla_trabajador_concepto.id_corr_trab IS 'Correlativo de trabajador';


--
-- Name: COLUMN planilla_trabajador_concepto.id_concepto; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.planilla_trabajador_concepto.id_concepto IS 'Código único del concepto';


--
-- Name: COLUMN planilla_trabajador_concepto.monto_conc; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.planilla_trabajador_concepto.monto_conc IS 'Monto del concepto';


--
-- Name: COLUMN planilla_trabajador_concepto.tipo_conc_pla; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.planilla_trabajador_concepto.tipo_conc_pla IS 'Tipo de concepto en la planilla (1=Manual, 2=Calculado)';


--
-- Name: trabajador; Type: TABLE; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

CREATE TABLE qubytss_rrhh.trabajador (
    id_persona integer NOT NULL,
    id_corr_trab integer NOT NULL,
    cod_trab character varying(10),
    estado_trabajador integer NOT NULL,
    id_tipo_trabajador integer,
    id_situacion_educativa integer,
    id_ocupacion integer,
    has_discapacidad boolean,
    id_condicion_laboral integer,
    renta_quinta_exo boolean,
    sujeto_a_regimen boolean,
    sujeto_a_jornada boolean,
    sujeto_a_horario boolean,
    periodo_remuneracion integer,
    situacion integer,
    id_situacion_especial integer,
    tipo_pago integer,
    id_tipo_cuent_banco integer,
    id_banco_sueldo integer,
    num_cuenta_banco_sueldo character varying(30),
    num_cuenta_banco_sueldo_cci character varying(30),
    id_banco_cts integer,
    num_cuenta_banco_cts character varying(30),
    fech_ingreso date,
    id_doc_ingreso integer,
    fech_doc_ingreso date,
    num_doc_ingreso character varying(30),
    mot_ingreso character varying(500),
    fech_registro_sis date,
    fech_salida date,
    id_motivo_salida integer,
    id_tipo_prestador integer,
    fech_ingreso_salud date,
    id_regimen_salud integer,
    num_regimen_salud character varying(20),
    id_entidad_salud integer,
    fech_ingreso_pension date,
    id_regimen_pension integer,
    id_regimen_pension_estado integer,
    cuspp character varying(15),
    is_cod_generado_sys boolean,
    id_persona_registro integer,
    id_filefoto integer
);


ALTER TABLE qubytss_rrhh.trabajador OWNER TO qubytss_rrhh;

--
-- Name: COLUMN trabajador.id_persona; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.id_persona IS 'Código único de persona';


--
-- Name: COLUMN trabajador.id_corr_trab; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.id_corr_trab IS 'Correlativo de trabajador';


--
-- Name: COLUMN trabajador.cod_trab; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.cod_trab IS 'Código del trabajador';


--
-- Name: COLUMN trabajador.estado_trabajador; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.estado_trabajador IS 'Estado del trabajador (1 = Activo, 2 = Inactivo, etc.)';


--
-- Name: COLUMN trabajador.id_tipo_trabajador; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.id_tipo_trabajador IS 'Identificador del tipo de trabajador (si es aplicable)';


--
-- Name: COLUMN trabajador.id_situacion_educativa; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.id_situacion_educativa IS 'Situación educativa del trabajador (bytsscom_bytcore.lista(SIT-EDUCATIVA))';


--
-- Name: COLUMN trabajador.id_ocupacion; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.id_ocupacion IS 'Ocupación del trabajador (bytsscom_bytcore.lista(OCUPACION))';


--
-- Name: COLUMN trabajador.has_discapacidad; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.has_discapacidad IS 'Discapacitado (1 = SI, 0 = NO)';


--
-- Name: COLUMN trabajador.id_condicion_laboral; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.id_condicion_laboral IS 'Condición laboral / Tipo de contrato de trabajo (bytsscom_bytcore.lista(COND-LABORAL))';


--
-- Name: COLUMN trabajador.renta_quinta_exo; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.renta_quinta_exo IS 'Rentas de 5ta categoría exoneradas (inciso e del art. 19 de la ley del impuesto a la renta) (1=SI, 0=NO)';


--
-- Name: COLUMN trabajador.sujeto_a_regimen; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.sujeto_a_regimen IS 'Sujeto a régimen alternativo, acumulativo o atípico de jornada de trabajo y descanso. (1=SI, 0=NO)';


--
-- Name: COLUMN trabajador.sujeto_a_jornada; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.sujeto_a_jornada IS 'Sujeto a jornada de trabajo máxima (1=SI, 0=NO)';


--
-- Name: COLUMN trabajador.sujeto_a_horario; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.sujeto_a_horario IS 'Sujeto a horario nocturno (1=SI, 0=NO)';


--
-- Name: COLUMN trabajador.periodo_remuneracion; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.periodo_remuneracion IS 'Periodo de remuneración (1=Mensual, 2=Quincenal, 3=Semanal, 4=Diaria, 5=Otros)';


--
-- Name: COLUMN trabajador.situacion; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.situacion IS 'Situación (0 = Baja, 1= Activo/Subsidiado, 2=Sin vínculo laboral con conceptos pendiente de liquidar, 3=Suspensión perfecta de labores)';


--
-- Name: COLUMN trabajador.id_situacion_especial; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.id_situacion_especial IS 'Situación especial del trabajador (bytsscom_bytcore.lista(SITUACION-ESPECIAL))';


--
-- Name: COLUMN trabajador.tipo_pago; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.tipo_pago IS 'Tipo de pago (1=Efectivo, 2=Depósito en cuenta, 3=Otros)';


--
-- Name: COLUMN trabajador.id_tipo_cuent_banco; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.id_tipo_cuent_banco IS 'Identificador del tipo de cuenta bancaria';


--
-- Name: COLUMN trabajador.id_banco_sueldo; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.id_banco_sueldo IS 'Código único del Banco para depósito en cuenta (bytsscom_bytcore.lista(BANCO))';


--
-- Name: COLUMN trabajador.num_cuenta_banco_sueldo; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.num_cuenta_banco_sueldo IS 'Número de cuenta del banco para depósito en cuenta';


--
-- Name: COLUMN trabajador.num_cuenta_banco_sueldo_cci; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.num_cuenta_banco_sueldo_cci IS 'Número de cuenta del banco para depósito en cuenta en formato CCI';


--
-- Name: COLUMN trabajador.id_banco_cts; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.id_banco_cts IS 'Código de banco para depósito de la CTS (bytsscom_bytcore.lista(BANCO))';


--
-- Name: COLUMN trabajador.num_cuenta_banco_cts; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.num_cuenta_banco_cts IS 'Número de cuenta del banco para el depósito de la CTS';


--
-- Name: COLUMN trabajador.fech_ingreso; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.fech_ingreso IS 'Fecha de ingreso del trabajador';


--
-- Name: COLUMN trabajador.id_doc_ingreso; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.id_doc_ingreso IS 'Identificador del documento de ingreso';


--
-- Name: COLUMN trabajador.fech_doc_ingreso; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.fech_doc_ingreso IS 'Fecha del documento de ingreso';


--
-- Name: COLUMN trabajador.num_doc_ingreso; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.num_doc_ingreso IS 'Número del documento de ingreso';


--
-- Name: COLUMN trabajador.mot_ingreso; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.mot_ingreso IS 'Motivo de ingreso del trabajador';


--
-- Name: COLUMN trabajador.fech_registro_sis; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.fech_registro_sis IS 'Fecha de registro en el sistema';


--
-- Name: COLUMN trabajador.fech_salida; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.fech_salida IS 'Fecha de salida del trabajador';


--
-- Name: COLUMN trabajador.id_motivo_salida; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.id_motivo_salida IS 'Motivo de salida del trabajador (bytsscom_bytcore.lista(MOTIVO-BAJA-PERSONAL))';


--
-- Name: COLUMN trabajador.id_tipo_prestador; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.id_tipo_prestador IS 'Tipo de prestador de servicios (bytsscom_bytcore.lista(PRESTADOR-SERVICIOS))';


--
-- Name: COLUMN trabajador.fech_ingreso_salud; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.fech_ingreso_salud IS 'Fecha de inicio del régimen de aseguramiento de salud';


--
-- Name: COLUMN trabajador.id_regimen_salud; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.id_regimen_salud IS 'Régimen de aseguramiento de salud (bytsscom_bytcore.lista(REGIMEN-SALUD))';


--
-- Name: COLUMN trabajador.num_regimen_salud; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.num_regimen_salud IS 'Número de régimen de aseguramiento de salud';


--
-- Name: COLUMN trabajador.id_entidad_salud; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.id_entidad_salud IS 'Identificador de la entidad prestadora de salud';


--
-- Name: COLUMN trabajador.fech_ingreso_pension; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.fech_ingreso_pension IS 'Fecha de ingreso al sistema de pensiones';


--
-- Name: COLUMN trabajador.id_regimen_pension; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.id_regimen_pension IS 'Régimen de pension (bytsscom_bytcore.lista(REGIMEN-PENSION))';


--
-- Name: COLUMN trabajador.id_regimen_pension_estado; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.id_regimen_pension_estado IS 'Estado del régimen de pension';


--
-- Name: COLUMN trabajador.cuspp; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.cuspp IS 'Código único de Identificación del Sistema Privado de Pensiones';


--
-- Name: COLUMN trabajador.is_cod_generado_sys; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.is_cod_generado_sys IS 'Indicador de si el código fue generado por el sistema';


--
-- Name: COLUMN trabajador.id_persona_registro; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.id_persona_registro IS 'Identificador de la persona que registró al trabajador';


--
-- Name: COLUMN trabajador.id_filefoto; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador.id_filefoto IS 'Identificador del archivo de la foto del trabajador';


--
-- Name: trabajador_concepto; Type: TABLE; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

CREATE TABLE qubytss_rrhh.trabajador_concepto (
    id_persona integer NOT NULL,
    id_corr_trab integer NOT NULL,
    id_concepto integer NOT NULL,
    monto_conc numeric(18,2)
);


ALTER TABLE qubytss_rrhh.trabajador_concepto OWNER TO qubytss_rrhh;

--
-- Name: TABLE trabajador_concepto; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON TABLE qubytss_rrhh.trabajador_concepto IS 'Conceptos del trabajador';


--
-- Name: COLUMN trabajador_concepto.id_persona; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador_concepto.id_persona IS 'Código único de persona';


--
-- Name: COLUMN trabajador_concepto.id_corr_trab; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador_concepto.id_corr_trab IS 'Correlativo de trabajador';


--
-- Name: COLUMN trabajador_concepto.id_concepto; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador_concepto.id_concepto IS 'Código único del concepto';


--
-- Name: COLUMN trabajador_concepto.monto_conc; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador_concepto.monto_conc IS 'Monto del concepto';


--
-- Name: trabajador_tipo; Type: TABLE; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

CREATE TABLE qubytss_rrhh.trabajador_tipo (
    id_tipo_trabajador integer NOT NULL,
    cod_tipo_trabajador integer,
    desc_tipo_trabajador character varying(50),
    est_tipo_trabajador integer
);


ALTER TABLE qubytss_rrhh.trabajador_tipo OWNER TO qubytss_rrhh;

--
-- Name: COLUMN trabajador_tipo.id_tipo_trabajador; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador_tipo.id_tipo_trabajador IS 'Código único del tipo de trabajador';


--
-- Name: COLUMN trabajador_tipo.cod_tipo_trabajador; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador_tipo.cod_tipo_trabajador IS 'Código del tipo de trabajador';


--
-- Name: COLUMN trabajador_tipo.desc_tipo_trabajador; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador_tipo.desc_tipo_trabajador IS 'Descripción del tipo de trabajador';


--
-- Name: COLUMN trabajador_tipo.est_tipo_trabajador; Type: COMMENT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COMMENT ON COLUMN qubytss_rrhh.trabajador_tipo.est_tipo_trabajador IS 'Estado (1=Activo, 0=Inactivo)';


--
-- Data for Name: anio; Type: TABLE DATA; Schema: public; Owner: qubytss_core
--

COPY public.anio (id_anio, cod_anio, nom_anio, fech_ini_anio, fech_fin_anio, esta_anio) FROM stdin;
\.


--
-- Data for Name: anio; Type: TABLE DATA; Schema: qubytss_core; Owner: qubytss_core
--

COPY qubytss_core.anio (id_anio, cod_anio, nom_anio, fech_ini_anio, fech_fin_anio, esta_anio) FROM stdin;
2010	2010	\N	2010-01-01	2010-12-31	C
2013	2013	\N	2013-01-01	2013-12-31	C
2012	2012	\N	2012-01-01	2012-12-31	C
2011	2011	\N	2011-01-01	2011-12-31	C
2014	2014	\N	2014-01-01	2014-12-31	C
2015	2015	Año de la Diversificación Productiva y del Fortalecimiento de la Educación	2015-01-01	2015-12-31	C
2016	2016	Año de la consolidación del Mar de Grau	2016-01-01	2016-12-31	C
2017	2017	Año del Buen Servicio al Ciudadano	2017-01-01	2017-12-31	C
2020	2020	Año de la Universalización de la Salud	2020-01-01	2020-12-31	C
2018	2018	Año del Diálogo y la Reconciliación Nacional	2018-01-01	2018-12-31	C
2019	2019	Año de la lucha contra la corrupción y la impunidad	2019-01-01	2019-12-31	C
2021	2021	Año del Bicentenario del Perú: 200 años de Independencia	2021-01-01	2021-12-31	C
2022	2022	Año 2022	2022-01-01	2022-12-31	C
2023	2023	Año 2023	2023-01-12	2023-12-31	C
2024	2024	Año 2024	2024-01-12	2024-12-31	A
\.


--
-- Data for Name: correlativo; Type: TABLE DATA; Schema: qubytss_core; Owner: qubytss_core
--

COPY qubytss_core.correlativo (key_corr, last_corr) FROM stdin;
PLANILLA.RRHH.PL.2012.4.03.3	82
PLANILLA.RRHH.PL.2024.02.01.2	2
PLANILLA.RRHH.PL.2016.8.04.4	39
PLANILLA.RRHH.PL.2024.02.01.1	7
PLANILLA.RRHH.PL.2024.02.03.3	7
\.


--
-- Data for Name: list; Type: TABLE DATA; Schema: qubytss_core; Owner: qubytss_core
--

COPY qubytss_core.list (id_lista, entidad, cod_lista, desc_lista, estado_lista) FROM stdin;
1152	MARCA	1234	AOC	1
1616	MARCA	0396	PENTEL	1
1767	ORG_MISION_IMGSUGERENTE	\N	¿ Cómo nos gustaria ser, y como nos gustaría que nos describan en el futuro ?	1
1768	ORG_MISION_IMGSUGERENTE	\N	¿ Cómo quisiéramos que se expresen los usuarios de nosotros en el futuro ?	1
1769	ORG_MISION_IMGSUGERENTE	\N	¿ Cuál es nuestra cualidad única, la que quisiéramos que nos distinga ?	1
20448	TIPO-SUBVENCIONADO	\N	Docente	1
1770	ORG_MISION_IMGSUGERENTE	\N	¿ Hacia dónde queremos cambiar ?	1
1771	ORG_MISION_IMGSUGERENTE	\N	¿ Qué es lo que realmente queremos ?	1
1772	ORG_MISION_IMGSUGERENTE	\N	¿ Qué es lo que realmente quiero ?	1
1773	ORG_MISION_IMGSUGERENTE	\N	¿ Qué es lo que haría comprometer mi mente y mi corazón a esta Visión en los proximos años ?	1
1774	ORG_MISION_IMGSUGERENTE	\N	¿ Cuáles son los objetivos estratégicos de los niveles superiores, que serán apoyados por mi institución?	1
1775	ORG_MISION_IMGSUGERENTE	\N	¿ Qué es lo que el país, sector, región, localidad, etc. necesita de nuestra organización ?	1
1776	ORG_MISION_MOTIVO	\N	¿ Cuáles son los valores institucionales de la entidad ?	1
1777	ORG_MISION_MOTIVO	\N	¿ Cuál es la prioridad de la entidad ?	1
1617	MARCA	0397	PINESOL	1
1618	MARCA	0398	RIBBON	1
1778	ORG_MISION_MOTIVO	\N	¿ A qué aspiramos como grupo humano, qué tipo de cuestiones son importantes para nosotros ?	1
1779	ORG_MISION_MOTIVO	\N	¿ Cuál es el rol social que desempeña la entidad, su responsabilidad social ?	1
1780	ORG_MISION_MOTIVO	\N	¿ Cuál es el beneficio que brinda la entidad a la sociedad ?	1
1781	ORG_MISION_MOTIVO	\N	¿ Qué diferencia marca en las personas ?	1
1782	ORG_MISION_MOTIVO	\N	¿ Porqué cree que la entidad debe existir ?	1
1783	ORG_MISION_NECESIDAD	\N	¿ Cuál es la principal necesidad a la cuál se orienta la entidad ?	1
1784	ORG_MISION_NECESIDAD	\N	¿ Para qué tipo de clientes / usuarios brinda sus servicios? ó ¿para quiénes produce ?	1
1785	ORG_MISION_NECESIDAD	\N	¿ La entidad está cumpliendo con satisfacer las necesidades actuales de mercado ?	1
1786	ORG_MISION_NECESIDAD	\N	¿ La necesidad que la entidad satisface es de gran importancia para la sociedad ? ¿Por qué?	1
1787	ORG_MISION_VALORFUND	\N	¿ Cómo queremos actuar en coherencia con nuestra Misión a lo largo de la senda que conducirá al logro de nuestra Visión ?	1
1788	ORG_MISION_VALORFUND	\N	¿ Cuáles son nuestros valores verdaderamente prioritarios ? describir el valor y significado	1
1789	ORG_MISION_VIABILIDAD	\N	¿ Con qué productos y/o servicios la entidad satisface la necesidad identificada ?	1
2	ADJUNTO	EETT	Expediente Técnico	1
393	TIPO-CONTACTO	\N	RPM	1
130	CARGO-LAB	\N	Asistente Logistico	1
1048	MARCA	1130	TEBA	1
3	ADJUNTO	EETTyP	Expediente Técnico y Planos	1
5	ADJUNTO	INFINV	Informe de Inversión	1
7	PROFESION	\N	ACUACULTURA	1
8	PROFESION	\N	AGRONOMIA	1
9	PROFESION	\N	ANTROPOLOGIA	1
20292	MARCA	\N	STICK NOTES	1
472	MARCA	0554	CCI	1
1790	ORG_MISION_VIABILIDAD	\N	¿ Cuáles son los puntos fuertes que le sirven a la entidad para atender la necesidad identificada ?	1
1791	ORG_MISION_VIABILIDAD	\N	¿ Qué metodología utiliza ?	1
1295	MARCA	0075	CRONOX	1
1296	MARCA	0076	CROWN	1
1297	MARCA	0077	CUSCO	1
1298	MARCA	0078	CYCLOPS	1
1299	MARCA	0079	CZ	1
1345	MARCA	0125	BARNES	1
1346	MARCA	0126	FLEX TECH	1
1347	MARCA	0127	FLORIDA	1
1348	MARCA	0128	FOCUS	1
1349	MARCA	0129	FORMETAL	1
1350	MARCA	0130	FORTE	1
1351	MARCA	0131	FRENOSITO	1
1352	MARCA	0132	FUJI	1
1353	MARCA	0133	FULLER	1
1354	MARCA	0134	GALLO	1
1355	MARCA	0135	GARRET	1
1356	MARCA	0136	THERMOSOL	1
1357	MARCA	0137	GENERAL	1
1358	MARCA	0138	GENERAL ELECTRIC	1
587	MARCA	0669	ONWARD	1
588	MARCA	0670	OPAL	1
589	MARCA	0671	OPTIPLEX	1
590	MARCA	0672	OPUS SYSTEM	1
591	MARCA	0673	PARKE-DAVIS	1
592	MARCA	0674	PETALO	1
593	MARCA	0675	PHILIP HARRIS	1
594	MARCA	0676	POLYFOAM	1
595	MARCA	0677	POLYSTEL	1
596	MARCA	0678	POWER FAN	1
597	MARCA	0679	POWERTRONIC	1
598	MARCA	0680	PRESTIGE	1
1222	MARCA	0002	3COM	1
599	MARCA	0681	PROPAL	1
1229	MARCA	0009	ADLER	1
600	MARCA	0682	PROTECTOR LINE	1
601	MARCA	0683	SPTRONIC	1
602	MARCA	0684	RANK.L.A.	1
603	MARCA	0685	REAL	1
604	MARCA	0686	REMINGTON	1
605	MARCA	0687	REPORT	1
606	MARCA	0688	RICOH	1
607	MARCA	0689	ROEMMERS	1
608	MARCA	0690	ROUSSEL UCLAT	1
609	MARCA	0691	ROYAL	1
610	MARCA	0692	RUBBERMAID	1
611	MARCA	0693	SANDOZ	1
612	MARCA	0694	SANDVIK	1
335	NIVEL-TRABAJADOR	08	Profesional III	1
336	NIVEL-TRABAJADOR	09	Secretaria	1
614	MARCA	0696	SANKEY	1
615	MARCA	0697	SAPOLIO	1
1359	MARCA	0139	GENIUS	1
1360	MARCA	0140	GESTETNER	1
1361	MARCA	0141	GOLDSTAR	1
1362	MARCA	0142	GOOD YEAR	1
1592	MARCA	0372	WHITE WESTINHOUSE	1
1593	MARCA	0373	WINGO	1
1594	MARCA	0374	WORTHINGTON	1
1595	MARCA	0375	XEROX	1
1596	MARCA	0376	YAESU	1
1599	MARCA	0379	YAMATO	1
1600	MARCA	0380	YERFIL	1
1601	MARCA	0381	ALFA	1
1602	MARCA	0382	AURORA	1
1603	MARCA	0383	AYUDIN	1
1604	MARCA	0384	CELIMA	1
1605	MARCA	0385	CONSOLA	1
1606	MARCA	0386	ELITE	1
1607	MARCA	0387	INDECO	1
1608	MARCA	0388	KILLER	1
1609	MARCA	0389	KIRMA	1
1610	MARCA	0390	LINEA AZUL	1
1611	MARCA	0391	MAGNUN	1
1612	MARCA	0392	MAGO	1
1613	MARCA	0393	MC COLLINS	1
1614	MARCA	0394	OLFA	1
1615	MARCA	0395	OZASOL	1
1619	MARCA	0399	STANDFLEX	1
1622	MARCA	0402	TINTAS	1
1623	MARCA	0403	MONARCA	1
1624	MARCA	0404	CARACOLILLO	1
1625	MARCA	0405	NESCAFE	1
1409	MARCA	0189	LADA	1
11	PROFESION	\N	ARQUITECTURA	1
12	PROFESION	\N	ARTE	1
13	PROFESION	\N	BIBLIOTECOLOGIA Y CIENCIAS DE LA INF.	1
14	PROFESION	\N	BIOLOGO	1
15	PROFESION	\N	BIOLOGIA PESQUERA	1
16	PROFESION	\N	BROMATOLOGIA Y NUTRICION	1
17	PROFESION	\N	CIENCIAS DE LA COMUNICACION	1
18	PROFESION	\N	CIENCIAS AGROPECUARIAS	1
20	PROFESION	\N	COOPERATIVISMO	1
21	PROFESION	\N	ABOGADO	1
22	PROFESION	\N	ECONOMIA	1
23	PROFESION	\N	EDUCACION	1
24	PROFESION	\N	EDUCACION FISICA	1
25	PROFESION	\N	ENFERMERA	1
26	PROFESION	\N	ESTADISTICA	1
27	PROFESION	\N	FARMACIA Y BIOQUIMICA	1
28	PROFESION	\N	FILOSOFIA	1
29	PROFESION	\N	FISICA	1
30	PROFESION	\N	FISICO MATEMATICA	1
31	PROFESION	\N	GEOFISICA	1
32	PROFESION	\N	GEOGRAFIA	1
33	PROFESION	\N	GEOLOGIA	1
34	PROFESION	\N	HISTORIA	1
35	PROFESION	\N	ING. ADMINISTRATIVA	1
36	PROFESION	\N	ING. AGRICOLA	1
37	PROFESION	\N	ING. AGRONOMO	1
1105	MARCA	1187	STECA	1
1106	MARCA	1188	CAREL	1
1107	MARCA	1189	PROMELSA	1
1108	MARCA	1190	THERMO IEC	1
1109	MARCA	1191	WEDECO	1
1110	MARCA	1192	TECHNE	1
1111	MARCA	1193	TELSTAR	1
1112	MARCA	1194	SEWARD	1
1113	MARCA	1195	TUTTNAUER	1
1114	MARCA	1196	FORESTRY	1
1115	MARCA	1197	EXTECH	1
1116	MARCA	1198	KENDALL COMPANY	1
1117	MARCA	1199	PONTIAC	1
1118	MARCA	1200	CONSOLIDATED STILL & STERILIZER	1
1119	MARCA	1201	KARCHER	1
1120	MARCA	1202	CONTROL JHONSONS	1
1121	MARCA	1203	LEICA MICROSYSTEMS	1
1122	MARCA	1204	INGENALPES IA002	1
1123	MARCA	1205	QUIXUN CORPORATION	1
1124	MARCA	1206	ADTEC	1
1192	MARCA	1274	SMARCA	1
1193	MARCA	1275	NCOMPUTING	1
1221	MARCA	0001	ADOBE	1
1223	MARCA	0003	3M	1
1224	MARCA	0004	A.B.SEGURIDAD	1
1225	MARCA	0005	ABC	1
1226	MARCA	0006	ACCTON	1
1227	MARCA	0007	ACER	1
1228	MARCA	0008	ACTTON	1
38	PROFESION	\N	ING. AGRO INDUSTRIAL	1
39	PROFESION	\N	ING. DEL AMBIENTE	1
40	PROFESION	\N	ING. CIVIL	1
41	PROFESION	\N	ING. DE COMPUTACION	1
42	PROFESION	\N	ING. DE CONTROLES IND.	1
43	PROFESION	\N	ING. ECONOMICA	1
44	PROFESION	\N	ING. ELECTRICA	1
45	PROFESION	\N	ING. ELECTRONICA	1
46	PROFESION	\N	ING. DE ENERGIA	1
47	PROFESION	\N	ING. DE ESTAD. E INFORM.	1
48	PROFESION	\N	ING. FORESTAL	1
49	PROFESION	\N	ING. GEOGRAFICA	1
50	PROFESION	\N	ING. GEOLOGICA	1
51	PROFESION	\N	ING. INDUSTRIAL	1
1234	MARCA	0014	ALCATEL	1
134	CARGO-LAB	\N	Asistente Técnico Monitoreo de Fondos de Apoyo	1
136	CARGO-LAB	\N	Conductor de Vehículo	1
137	CARGO-LAB	\N	Consultor	1
138	CARGO-LAB	\N	Consultor de Equipamiento	1
139	CARGO-LAB	\N	Consultor en Ingeniería	1
126	CARGO-LAB	\N	Apoyo en las Accciones de Campo	1
127	CARGO-LAB	\N	Apoyo organizativo y logístico para talleres de capacitación	1
128	CARGO-LAB	\N	Asistente Administrativo	1
129	CARGO-LAB	\N	Asistente de Monitoreo	1
1464	MARCA	0244	OMEGA	1
143	CARGO-LAB	\N	Coordinador del Proyecto	1
144	CARGO-LAB	\N	Coordinador General	1
145	CARGO-LAB	\N	Coordinador General (e)	1
148	CARGO-LAB	\N	Encargado de Servicios Generales	1
149	CARGO-LAB	\N	Especialista de Adquisiciones	1
175	CARGO-MOTIVO	\N	REPOSICION	1
176	CARGO-MOTIVO	\N	ROTACION	1
177	CARGO-MOTIVO	\N	TRANSFERENCIA	1
178	CARGO-BAJA	\N	RENUNCIA O CESE	1
179	CARGO-BAJA	\N	RESCISION EN EL CONTRATO	1
180	CARGO-BAJA	\N	DESTITUCION	1
183	CARGO-BAJA	\N	RECTIFICACION O MODIFICACION	1
477	MARCA	0559	COMMAX	1
131	CARGO-LAB	\N	Asistente Técnico en Monitoreo Programático	1
20290	MARCA	\N	KP	1
20289	MARCA	\N	ARTI	1
20288	MARCA	\N	KW-TRIO	1
20287	MARCA	\N	LENOVO	1
20286	MARCA	\N	RAY PERU	1
20285	MARCA	\N	GRAFIRESA	1
20284	MARCA	\N	INTIFILE	1
399	MARCA	0481	QUEIROLO	1
400	MARCA	0482	SOLGAS	1
20283	MARCA	\N	ULTRACOPY	1
20282	MARCA	\N	CLASSIC	1
20281	MARCA	\N	MUNDIAL	1
1546	MARCA	0326	STORAGE	1
1547	MARCA	0327	SUAVE	1
1548	MARCA	0328	SUBARU	1
1524	MARCA	0304	SAMTROM	1
1500	MARCA	0280	PROFESSIONAL	1
1501	MARCA	0281	PROQUIMA	1
1502	MARCA	0282	PROTEX	1
1503	MARCA	0283	PROXIMA	1
1504	MARCA	0284	QC PASS	1
1505	MARCA	0285	QUALCOMM	1
1506	MARCA	0286	QUANTUM	1
1507	MARCA	0287	RAPID	1
1508	MARCA	0288	RECORD	1
1509	MARCA	0289	REMA	1
1510	MARCA	0290	RENZ	1
325	TIPO-CAPACITACION	\N	Autor o coautor de libros publicados	1
1125	MARCA	1207	SHARP LIQUID CRYSTAL TV	1
705	MARCA	0787	BBL-BECTON DICKINSON	1
706	MARCA	0788	DAKO CORP.	1
707	MARCA	0789	M Y B	1
708	MARCA	0790	OXOID	1
709	MARCA	0791	ATCC	1
710	MARCA	0792	BELKIN	1
711	MARCA	0793	LIEBERT/EMERSON	1
712	MARCA	0794	HELLA	1
713	MARCA	0795	SELECT II	1
714	MARCA	0796	PFIZER	1
715	MARCA	0797	BIOQUIP	1
716	MARCA	0798	LIFTER	1
717	MARCA	0799	NUNC	1
718	MARCA	0800	STOCKA	1
719	MARCA	0801	POWER LINE	1
721	MARCA	0803	MAGELLAN	1
722	MARCA	0804	APC	1
723	MARCA	0805	INTERGRAPH	1
724	MARCA	0806	BRONCEX	1
725	MARCA	0807	JUBILEE	1
726	MARCA	0808	KARPEX	1
727	MARCA	0809	OLIDATA	1
728	MARCA	0810	GUARANY	1
729	MARCA	0811	FISHER SCIENTIFIC	1
730	MARCA	0812	KPL	1
731	MARCA	0813	GLASS	1
732	MARCA	0814	JOHNSON CONTROLS	1
733	MARCA	0815	BOHRER	1
734	MARCA	0816	TECNOFAN	1
735	MARCA	0817	BIORAD	1
736	MARCA	0818	ERSHAM PHAR	1
737	MARCA	0819	EDDING	1
738	MARCA	0820	IRC	1
739	MARCA	0821	IMACO	1
740	MARCA	0822	APIN	1
741	MARCA	0823	PERFECTION	1
742	MARCA	0824	ALDRICH	1
743	MARCA	0825	OEPECH	1
744	MARCA	0826	SPICE TECHNOLOGY	1
745	MARCA	0827	LISTER STAMFORD	1
746	MARCA	0828	THUNDER	1
747	MARCA	0829	FAVINI	1
748	MARCA	0830	DURO	1
749	MARCA	0831	LEGIS	1
629	MARCA	0711	SOLO	1
750	MARCA	0832	SUMITOMO CHEMICAL COMPANY	1
751	MARCA	0833	MONTENEGRO	1
752	MARCA	0834	FAST	1
753	MARCA	0835	VENCENAMEL	1
754	MARCA	0836	LUCERO	1
755	MARCA	0837	AGDEN	1
756	MARCA	0838	COORS	1
757	MARCA	0839	CIP	1
758	MARCA	0840	CORNING	1
759	MARCA	0841	COSTAR	1
760	MARCA	0842	DAIGGER	1
764	MARCA	0846	EREIE SCIENTIFIC	1
765	MARCA	0847	ERTCO	1
766	MARCA	0848	FALCON	1
767	MARCA	0849	FINNPIPETTE	1
768	MARCA	0850	GIBCO	1
769	MARCA	0851	GOLD SEAL	1
770	MARCA	0852	HS	1
771	MARCA	0853	LADD RESEARCH	1
772	MARCA	0854	RED LABEL	1
773	MARCA	0855	S&S	1
774	MARCA	0856	SANOFI	1
775	MARCA	0857	ISOTEMP	1
776	MARCA	0858	BECKMAN COULTER	1
777	MARCA	0859	FISHER MARATHON 21000R	1
778	MARCA	0860	ENVIRCO	1
779	MARCA	0861	DENVER	1
780	MARCA	0862	FISHER - HAMILTON	1
781	MARCA	0863	HOSHIZAKI	1
782	MARCA	0864	LABCONCO	1
880	MARCA	0962	WILL	1
881	MARCA	0963	COLLEMAN	1
882	MARCA	0964	YELI	1
883	MARCA	0965	SEARS	1
884	MARCA	0966	ED	1
885	MARCA	0967	TTOT POINT	1
886	MARCA	0968	CORAL	1
887	MARCA	0969	IGEBA	1
888	MARCA	0970	ASAHI PENTAX	1
473	MARCA	0555	CHALLENGER	1
474	MARCA	0556	CIM	1
475	MARCA	0557	COLDEX	1
476	MARCA	0558	COMICA	1
617	MARCA	0699	SCHERING PLOUG	1
478	MARCA	0560	CONSUL	1
479	MARCA	0561	COPIMAX	1
480	MARCA	0562	CPTRONIC	1
481	MARCA	0563	CREATIVE	1
482	MARCA	0564	CRIOLLO	1
483	MARCA	0565	CRISFRISA	1
484	MARCA	0566	DALITE	1
485	MARCA	0567	DANFOSS	1
486	MARCA	0568	DENKY	1
487	MARCA	0569	DHL	1
488	MARCA	0570	DIFCO	1
489	MARCA	0571	DPOWER	1
490	MARCA	0572	DRAGON	1
491	MARCA	0573	DURACELL	1
492	MARCA	0574	DURAPLAST	1
493	MARCA	0575	EDANDER	1
494	MARCA	0576	EL CRUZADO	1
495	MARCA	0577	ELKAY	1
542	MARCA	0624	JP SELECTA	1
543	MARCA	0625	KARATE	1
544	MARCA	0626	KENWOOD	1
545	MARCA	0627	KIMAX	1
442	MARCA	0524	ARMSTRONG	1
443	MARCA	0525	ARSEG	1
444	MARCA	0526	ASSAY PLATES FALCON 3911	1
445	MARCA	0527	ASSIST	1
446	MARCA	0528	ASTORIA	1
447	MARCA	0529	ASTROM	1
448	MARCA	0530	ATU	1
449	MARCA	0531	AUS-JENA	1
450	MARCA	0532	B.F. GOODRICH	1
496	MARCA	0578	EPPENDORF	1
1021	MARCA	1103	OLLAND	1
1395	MARCA	0175	JVC	1
895	MARCA	0977	BRUNTON	1
896	MARCA	0978	BOCCO	1
897	MARCA	0979	HYGROMETER	1
898	MARCA	0980	BLOHIT	1
899	MARCA	0981	SPRINGFIELD	1
900	MARCA	0982	NONG-SDE	1
901	MARCA	0983	EVERX	1
902	MARCA	0984	EUROCHRON	1
903	MARCA	0985	MICROM	1
904	MARCA	0986	ANALYTIK JENA	1
905	MARCA	0987	SIEMENS	1
906	MARCA	0988	LAUDA	1
907	MARCA	0989	TURNER	1
908	MARCA	0990	BOSCH	1
909	MARCA	0991	FELLOWES	1
910	MARCA	0992	KANGLE	1
911	MARCA	0993	KENMORE	1
912	MARCA	0994	UCHIDA	1
913	MARCA	0995	COMPATIBLE	1
914	MARCA	0996	CHECOSLOVACA	1
915	MARCA	0997	GARMIN	1
916	MARCA	0998	REDSA	1
917	MARCA	0999	ESPIROMAQ	1
918	MARCA	1000	BELTEC	1
919	MARCA	1001	HOMELITE	1
920	MARCA	1002	TOP LINE	1
921	MARCA	1003	INDURAMA	1
922	MARCA	1004	HILFE	1
923	MARCA	1005	DIMOTOR	1
924	MARCA	1006	YVISA	1
925	MARCA	1007	KLIMATIC	1
927	MARCA	1009	ACROPRING	1
928	MARCA	1010	FISHER/BIOTECH	1
929	MARCA	1011	NETSCREEN	1
930	MARCA	1012	HEIMANN	1
931	MARCA	1013	ALFASA	1
1126	MARCA	1208	REVCO	1
1127	MARCA	1209	MARKET FORGE	1
1128	MARCA	1210	SAMSUNG	1
1129	MARCA	1211	TRAFYS	1
1130	MARCA	1212	TRENDNET	1
1131	MARCA	1213	GIANT-USA	1
1132	MARCA	1214	SIGFYS	1
1133	MARCA	1215	DLINK	1
1134	MARCA	1216	AMERICAN DRYER	1
337	NIVEL-TRABAJADOR	10	Asistente	1
1135	MARCA	1217	CHECK POINT	1
1136	MARCA	1218	OPALUX	1
1137	MARCA	1219	EXCITING	1
1139	MARCA	1221	KYOCERA	1
1140	MARCA	1222	FRIO NOVO	1
1141	MARCA	1223	UTSTARCOM	1
1142	MARCA	1224	HALION	1
1144	MARCA	1226	MAXRAD	1
1145	MARCA	1227	SECOM	1
1146	MARCA	1228	EL CID	1
1147	MARCA	1229	COLD POINT	1
1148	MARCA	1230	INTOMASA	1
1149	MARCA	1231	DELTA-POWER	1
1150	MARCA	1232	INTELLITY CONSULTING	1
1151	MARCA	1233	CYBERTEL	1
1153	MARCA	1235	FACUSA	1
1154	MARCA	1236	MAJEFESA	1
1155	MARCA	1237	FASE	1
1156	MARCA	1238	ZOJIRUSHI	1
1157	MARCA	1239	ILUMI	1
1159	MARCA	1241	TEMPO	1
1160	MARCA	1242	WEX	1
1161	MARCA	1243	ALFANO	1
1162	MARCA	1244	ALLEANZA	1
1163	MARCA	1245	BEAUTONE	1
1164	MARCA	1246	DURABLE	1
1165	MARCA	1247	GRAPHOS	1
1166	MARCA	1248	IMPORT	1
1167	MARCA	1249	MEDIFLEX	1
1168	MARCA	1250	MEMORIS PRECIOUS	1
1169	MARCA	1251	NORIS	1
1170	MARCA	1252	PAGODA	1
1171	MARCA	1253	PIAGGIO	1
1172	MARCA	1254	PRINCO	1
1173	MARCA	1255	SHURTAPE	1
1174	MARCA	1256	AQUAOASIS	1
1175	MARCA	1257	NEW HOSPIVAC	1
1176	MARCA	1258	HANSHIN MEDICAL	1
1177	MARCA	1259	THERMO SCIENTIFIC	1
1178	MARCA	1260	METRO	1
1179	MARCA	1261	KACIL	1
1180	MARCA	1262	THERMO FISHER	1
1181	MARCA	1263	GLF	1
1182	MARCA	1264	TECHNE/JENWAY	1
1183	MARCA	1265	RUD RIESTER	1
1184	MARCA	1266	ROCHE	1
1185	MARCA	1267	EKF DIAGNOSTIC	1
1186	MARCA	1268	GIMA	1
1187	MARCA	1269	QUEST TECHNOLOGIES	1
1188	MARCA	1270	NOVEL	1
1189	MARCA	1271	HELMER	1
1190	MARCA	1272	NORTEL	1
1191	MARCA	1273	NDD	1
1194	MARCA	1287	AMPROBE	1
1195	MARCA	1286	SPACELABS	1
1196	MARCA	1293	WARRIOR	1
1312	MARCA	0092	DIAMOND	1
1313	MARCA	0093	DIAZIT	1
1314	MARCA	0094	DIETZGEN	1
1315	MARCA	0095	DIGITAL	1
1316	MARCA	0096	DIN	1
1317	MARCA	0097	DINAPOWER	1
1318	MARCA	0098	DMU	1
1320	MARCA	0100	DTK	1
1321	MARCA	0101	DUPLOMANT	1
1322	MARCA	0102	DUPLOMAX	1
1323	MARCA	0103	DUPONT	1
1324	MARCA	0104	DVE	1
1325	MARCA	0105	EBERHARD FABER	1
1326	MARCA	0106	ECO	1
1327	MARCA	0107	ELECTROLUX	1
1328	MARCA	0108	EMERSON	1
1329	MARCA	0109	EMPERATRIZ	1
1330	MARCA	0110	EPSON	1
1331	MARCA	0111	EQUAL	1
1332	MARCA	0112	ESCRIB	1
1333	MARCA	0113	ETHERNET	1
1334	MARCA	0114	ETICOM	1
1336	MARCA	0116	FACIT	1
1337	MARCA	0117	FAN STAR	1
1338	MARCA	0118	FARADAY	1
1339	MARCA	0119	FARGO	1
1340	MARCA	0120	FETAP	1
1341	MARCA	0121	FIAT	1
1342	MARCA	0122	FIELD	1
1343	MARCA	0123	FLET TECH	1
1344	MARCA	0124	FLEX	1
1393	MARCA	0173	JUMBO	1
1394	MARCA	0174	JUSTUS	1
1396	MARCA	0176	KAISSEN	1
1397	MARCA	0177	KERN	1
1398	MARCA	0178	KLERAT	1
1399	MARCA	0179	KODAK	1
1400	MARCA	0180	KODALITH	1
1401	MARCA	0181	KORES	1
1402	MARCA	0182	KRAF	1
1403	MARCA	0183	KRAVIL	1
1404	MARCA	0184	KRISTI	1
1405	MARCA	0185	KSET	1
1406	MARCA	0186	KUTTER	1
1407	MARCA	0187	KVA1	1
1408	MARCA	0188	KYOTO	1
1410	MARCA	0190	LAMINEX	1
1411	MARCA	0191	LASER	1
1412	MARCA	0192	LAYCOSA	1
1413	MARCA	0193	LEIZ	1
1414	MARCA	0194	LEON	1
1415	MARCA	0195	LEROY	1
1416	MARCA	0196	LGM	1
1417	MARCA	0197	LIMEX	1
1418	MARCA	0198	LINKBUILDER	1
1419	MARCA	0199	LINKWORLD	1
1420	MARCA	0200	LION	1
1421	MARCA	0201	LIQUID-PAPER	1
1422	MARCA	0202	LISTOS	1
1423	MARCA	0203	LOGITECH	1
1424	MARCA	0204	LORO	1
1425	MARCA	0205	LTC	1
1426	MARCA	0206	MARCA	1
1427	MARCA	0207	MARKIN	1
1428	MARCA	0208	MCL	1
1429	MARCA	0209	MECANORMA	1
1431	MARCA	0211	METABO	1
1432	MARCA	0212	MICROLAND	1
1433	MARCA	0213	MINI-MICRO	1
1434	MARCA	0214	MINI POWER	1
1435	MARCA	0215	MINOLTA	1
1436	MARCA	0216	MIRAY	1
1437	MARCA	0217	MIRAY/FS3	1
1438	MARCA	0218	MITA	1
1439	MARCA	0219	MOFER	1
1440	MARCA	0220	MONFER	1
1441	MARCA	0221	MONGOL	1
1442	MARCA	0222	MOTOROLA	1
1443	MARCA	0223	MOULINES	1
1444	MARCA	0224	MPS	1
1445	MARCA	0225	MULTILITE	1
1446	MARCA	0226	MULTILITH	1
1447	MARCA	0227	MYTEK	1
1448	MARCA	0228	NATIONAL	1
1449	MARCA	0229	NCS	1
1450	MARCA	0230	NET COMPUTER	1
1451	MARCA	0231	NIPPON	1
1452	MARCA	0232	NISSAN	1
1453	MARCA	0233	NOKIA	1
1454	MARCA	0234	NOVELL	1
1455	MARCA	0235	NSC	1
1456	MARCA	0236	NTC	1
1457	MARCA	0237	NUARC	1
1458	MARCA	0238	NUEVO MUNDO	1
1459	MARCA	0239	OFINORMA	1
1460	MARCA	0240	OFITECNER	1
1461	MARCA	0241	OKY	1
1463	MARCA	0243	OLIVETTI	1
1694	MARCA	0474	RED LINE	1
345	AFP	\N	AFP PRIMA	1
93	PROFESION	\N	TECNOLOGO EN LABORATORIO	1
94	PROFESION	\N	CIENCIAS ADMINISTRATIVAS	1
96	PROFESION	\N	CONTABILIDAD	1
97	PROFESION	\N	COMPUTACION E INFORMATICA	1
209	MERITO	\N	FELICITACION	1
210	MERITO	\N	AMONESTACION POR CONDUCTA LABORAL	1
211	MERITO	\N	PRIMERA AMONESTACION POR TARDANZA	1
212	MERITO	\N	SEGUNDA AMONESTACION POR TARDANZA	1
213	MERITO	\N	CARTA DE ADVERTENCIA POR TARDANZA	1
618	MARCA	0700	SECRETO	1
619	MARCA	0701	SEEDBURO	1
620	MARCA	0702	SELECTA	1
621	MARCA	0703	SERVIFABRI	1
622	MARCA	0704	SHANGAI	1
623	MARCA	0705	SHENWOOD	1
624	MARCA	0706	SIGMA	1
625	MARCA	0707	SILEX	1
626	MARCA	0708	SIMPORT	1
627	MARCA	0709	SMITH KLINE BECHAM	1
628	MARCA	0710	SOFT LINE	1
697	MARCA	0779	BIC	1
720	MARCA	0802	TRIMBLE NAVIGATION	1
20297	SIAF-TIPO-OPER	A	ENCARGO INTERNO	1
60	PROFESION	\N	ING. DE PETROLEO	1
61	PROFESION	\N	ING. PETROQUIMICA	1
62	PROFESION	\N	ING. QUIMICA	1
63	PROFESION	\N	ING. SANITARIA	1
64	PROFESION	\N	ING. DE HIG. Y SEGURIDAD	1
65	PROFESION	\N	ING. DE SISTEMAS	1
66	PROFESION	\N	ING. TEXTIL	1
67	PROFESION	\N	INVESTIGACION OPERATIVA	1
68	PROFESION	\N	LINGUISTICA	1
69	PROFESION	\N	LITERATURA	1
70	PROFESION	\N	MATEMATICAS	1
71	PROFESION	\N	MEDICINA HUMANA	1
72	PROFESION	\N	MEDICINA VETERINARIA	1
73	PROFESION	\N	METEREOLOGIA	1
74	PROFESION	\N	MICROBIOLOGIA	1
75	PROFESION	\N	MUSICA	1
76	PROFESION	\N	NUTRICION	1
77	PROFESION	\N	OBSTETRICIA	1
78	PROFESION	\N	OCEANOGRAFIA	1
79	PROFESION	\N	ODONTOLOGIA	1
80	PROFESION	\N	QUIMICA	1
1230	MARCA	0010	ADMIRAAL	1
1231	MARCA	0011	AIIO	1
1232	MARCA	0012	AIWA	1
1233	MARCA	0013	AJV	1
1235	MARCA	0015	ALEMAN	1
1236	MARCA	0016	ALLIED	1
1237	MARCA	0017	ALVIN	1
1238	MARCA	0018	AMC	1
1239	MARCA	0019	AMERICA MEGATREND	1
1240	MARCA	0020	AMIGO	1
1241	MARCA	0021	ANCHOR	1
1242	MARCA	0022	ANGELITO	1
1243	MARCA	0023	ANVIL	1
1244	MARCA	0024	ARC	1
1245	MARCA	0025	AROS	1
1246	MARCA	0026	ARTESCO	1
1247	MARCA	0027	ARTLINE	1
1248	MARCA	0028	AST	1
1249	MARCA	0029	AT&T	1
81	PROFESION	\N	RECURSOS NATURALES RENOVABLES	1
82	PROFESION	\N	RELACIONES INDUSTRIALES	1
83	PROFESION	\N	PSICOLOGIA	1
84	PROFESION	\N	SOCIOLOGIA	1
85	PROFESION	\N	TECNOLOGIA MEDICA	1
86	PROFESION	\N	TEOLOGIA	1
87	PROFESION	\N	TRABAJO SOCIAL	1
88	PROFESION	\N	TRADUCCION E INTERPRETACION	1
89	PROFESION	\N	TURISMO	1
90	PROFESION	\N	MEDICINA VETERINARIA Y ZOOTECNISTA	1
91	PROFESION	\N	CIENCIAS ECONOMICAS Y COMERCIALES	1
92	PROFESION	\N	SECRETARIA EJECUTIVA	1
1626	MARCA	0406	DORE	1
132	CARGO-LAB	\N	Asistente Técnico en Supervisión y Monitoreo	1
133	CARGO-LAB	\N	Asistente Técnico Estrategia PAL	1
135	CARGO-LAB	\N	Cajero	1
681	MARCA	0763	PIRELLI	1
682	MARCA	0764	IMATION	1
683	MARCA	0765	ARFE	1
684	MARCA	0766	BASH	1
685	MARCA	0767	DELL POWER EDGE	1
686	MARCA	0768	FIRESTONE	1
687	MARCA	0769	HETTICH	1
688	MARCA	0770	ZEBRA	1
689	MARCA	0771	SWISS PRIMO	1
690	MARCA	0772	WESPLAST	1
691	MARCA	0773	TRANSPACK	1
692	MARCA	0774	SCENTRY BIOLOGICALS INC.	1
693	MARCA	0775	ADAPTEC	1
695	MARCA	0777	HAMEX	1
696	MARCA	0778	BRIGGS & STRATTON	1
761	MARCA	0843	DURINA	1
762	MARCA	0844	DYNEX	1
763	MARCA	0845	EM SCIENCE	1
339	NIVEL-TRABAJADOR	12	CAS	1
814	MARCA	0896	EPPRNDORF	1
815	MARCA	0897	SEGUEL	1
816	MARCA	0898	UL-BRAUD	1
817	MARCA	0899	CERTIFIED	1
818	MARCA	0900	UNIVERSAL	1
819	MARCA	0901	MIATECH	1
820	MARCA	0902	T-2-386DX	1
821	MARCA	0903	T-3-386DX	1
822	MARCA	0904	JUSTLINK	1
823	MARCA	0905	GLOBAL	1
824	MARCA	0906	VIEWSONIC	1
825	MARCA	0907	MAN PACK	1
826	MARCA	0908	BELL-HOMEL	1
827	MARCA	0909	CHISHOLM	1
828	MARCA	0910	MAXON	1
829	MARCA	0911	CDMA	1
830	MARCA	0912	SCS	1
831	MARCA	0913	WORK DRIER	1
832	MARCA	0914	KIKA	1
833	MARCA	0915	MEMMERT	1
834	MARCA	0916	NOMO	1
835	MARCA	0917	TEW	1
836	MARCA	0918	SUNCH	1
837	MARCA	0919	SUUNTO	1
838	MARCA	0920	REFLECTA	1
839	MARCA	0921	MARATHON	1
840	MARCA	0922	BUNTRON	1
841	MARCA	0923	ONAN	1
842	MARCA	0924	KIOWA	1
843	MARCA	0925	FLORENCE	1
844	MARCA	0926	GOLD POWER	1
845	MARCA	0927	LUCENT	1
892	MARCA	0974	COMODOY	1
893	MARCA	0975	MORAVECO	1
932	MARCA	1014	SUPERIOR	1
933	MARCA	1015	GLOBE	1
935	MARCA	1017	BIOCAN	1
936	MARCA	1018	TEOBA	1
937	MARCA	1019	HYGRO	1
938	MARCA	1020	HAND TALLY	1
939	MARCA	1021	SURGE	1
940	MARCA	1022	MVE	1
941	MARCA	1023	RADMAL	1
942	MARCA	1024	SWINTEC	1
943	MARCA	1025	BIONET	1
944	MARCA	1026	SAMAN	1
945	MARCA	1027	INTERPLUS	1
1079	MARCA	1161	KEY CHEMICAL	1
1080	MARCA	1162	UVP	1
1081	MARCA	1163	AWARENESS	1
1250	MARCA	0030	ATLAS	1
1251	MARCA	0031	ATP	1
1252	MARCA	0032	AUDI	1
1253	MARCA	0033	AUDIVOX	1
1254	MARCA	0034	AVER	1
1255	MARCA	0035	AXIAL	1
1256	MARCA	0036	BALAY	1
1257	MARCA	0037	BASA	1
1258	MARCA	0038	BAYER	1
1259	MARCA	0039	BAYGON	1
1260	MARCA	0040	BELTRON	1
1261	MARCA	0041	BERKEL	1
1262	MARCA	0042	BERLOY	1
1263	MARCA	0043	BLACK DECKER	1
1264	MARCA	0044	BOHERER	1
1265	MARCA	0045	BOMCO	1
1266	MARCA	0046	BOSTISCH	1
1267	MARCA	0047	BOSTON	1
1268	MARCA	0048	BRIG STRATON	1
1269	MARCA	0049	BRILL	1
1270	MARCA	0050	BUHL	1
1271	MARCA	0051	CANON	1
1272	MARCA	0052	CANSON	1
1273	MARCA	0053	CASIO	1
1274	MARCA	0054	CASPER	1
1275	MARCA	0055	CASTROL	1
1276	MARCA	0056	CAT	1
1277	MARCA	0057	CATERPILLAR	1
1278	MARCA	0058	CECS	1
1279	MARCA	0059	CHASQUI	1
1280	MARCA	0060	CHAVIN	1
1281	MARCA	0061	CHEMICAL	1
1282	MARCA	0062	CHEVROLET	1
1283	MARCA	0063	CHINON	1
1284	MARCA	0064	CIBERTEC	1
1285	MARCA	0065	CITIZEN	1
1286	MARCA	0066	CITROEN	1
1287	MARCA	0067	COEL	1
1288	MARCA	0068	COLORAMA	1
1289	MARCA	0069	COLUMBIA	1
1290	MARCA	0070	COMET	1
1291	MARCA	0071	COMPAQ PRESARIO	1
1292	MARCA	0072	COMPUTER SYSTEM	1
1293	MARCA	0073	COMPUTRONIC	1
1294	MARCA	0074	CROMEX	1
1363	MARCA	0143	GRAMFINAL	1
1364	MARCA	0144	GYRA	1
1365	MARCA	0145	HALLO	1
1366	MARCA	0146	HANNA	1
1367	MARCA	0147	HARTMAN	1
1368	MARCA	0148	HIDROSTAL	1
1369	MARCA	0149	HILD	1
1370	MARCA	0150	HIOSUNG	1
1371	MARCA	0151	HONDA	1
1372	MARCA	0152	HORNIMANS	1
1373	MARCA	0153	HP	1
1374	MARCA	0154	HTC-40	1
1375	MARCA	0155	HUSKY	1
1376	MARCA	0156	HYUNDAI	1
1377	MARCA	0157	IBM	1
1378	MARCA	0158	ICC	1
1379	MARCA	0159	ICOM	1
1380	MARCA	0160	IDEAL	1
1381	MARCA	0161	IMC	1
1382	MARCA	0162	IMFA	1
1383	MARCA	0163	IMPULSE SEALER	1
1384	MARCA	0164	INCOLMA	1
1385	MARCA	0165	INTEL	1
1386	MARCA	0166	INTEL INSIDE	1
1387	MARCA	0167	INTRATEC	1
1388	MARCA	0168	IRUMA	1
1389	MARCA	0169	JANITROL	1
1390	MARCA	0170	JEEP	1
1391	MARCA	0171	JMB	1
1392	MARCA	0172	JORDUIT	1
1462	MARCA	0242	OLYMPIA	1
1466	MARCA	0246	OSRAM	1
1467	MARCA	0247	OSTER	1
1468	MARCA	0248	OXFORD	1
1469	MARCA	0249	OZALID	1
1470	MARCA	0250	PACKARD BELL	1
1471	MARCA	0251	PALMOLIVE	1
1472	MARCA	0252	PANASONIC	1
1473	MARCA	0253	PAPER-MATE	1
1474	MARCA	0254	PAQUITA	1
1475	MARCA	0255	PARAMONGA	1
1476	MARCA	0256	PAVEY	1
1477	MARCA	0257	PC	1
1478	MARCA	0258	PC'S	1
1479	MARCA	0259	PEGAFAN	1
1480	MARCA	0260	PEKLLAK	1
1481	MARCA	0261	PELIFIX	1
1482	MARCA	0262	PELIKAN	1
1570	MARCA	0350	TH	1
1571	MARCA	0351	TICINO	1
1572	MARCA	0352	TOBISHI	1
1573	MARCA	0353	TOWA	1
1574	MARCA	0354	TOYOTA	1
1575	MARCA	0355	TRIUMPH	1
1576	MARCA	0356	TRODAT	1
1577	MARCA	0357	TURBO 2000	1
1578	MARCA	0358	TURBON	1
1579	MARCA	0359	TWC	1
1580	MARCA	0360	TWN	1
1581	MARCA	0361	UHU	1
1582	MARCA	0362	UNOMAT	1
1583	MARCA	0363	VAINSA	1
1584	MARCA	0364	VICKERS - ARMSTRONGS	1
1585	MARCA	0365	VIDEONICS	1
1586	MARCA	0366	VIVITAL	1
1587	MARCA	0367	VOLKSWAGEN	1
1588	MARCA	0368	WANG	1
1589	MARCA	0369	WESTER DIGITAL	1
1590	MARCA	0370	WHATMAN	1
1591	MARCA	0371	WHIRLPOOL	1
926	MARCA	1008	TUMI	1
151	CARGO-LAB	\N	Especialista en Infraestructura	1
152	CARGO-LAB	\N	Especialista en Ingeniería Eléctrica	1
153	CARGO-LAB	\N	Especialista en Levantamiento de Información	1
155	CARGO-LAB	\N	Especialista en Recursos Humanos	1
1695	MARCA	0475	VENCEDOR	1
1696	MARCA	0476	VERIPRINT 2000	1
156	CARGO-LAB	\N	Especialista en Relaciones Interinstitucional y Gubernamental en Salud	1
159	CARGO-LAB	\N	Responsable Monitoreo y Evaluación	1
161	CARGO-LAB	\N	Técnico en Ingeniería	1
162	CARGO-MOTIVO	\N	ADECUACION	1
163	CARGO-MOTIVO	\N	ASCENSO	1
164	CARGO-MOTIVO	\N	ASIGNACION	1
165	CARGO-MOTIVO	\N	COMISION DE SERVICIO	1
166	CARGO-MOTIVO	\N	CONTRATO	1
167	CARGO-MOTIVO	\N	DESIGNACION	1
168	CARGO-MOTIVO	\N	DESTAQUES	1
169	CARGO-MOTIVO	\N	ENCARGOS	1
170	CARGO-MOTIVO	\N	NOMBRAMIENTO	1
1545	MARCA	0325	STC	1
171	CARGO-MOTIVO	\N	PROMOCION	1
172	CARGO-MOTIVO	\N	RATIFICACION	1
173	CARGO-MOTIVO	\N	REASIGNACION	1
174	CARGO-MOTIVO	\N	REINGRESO	1
398	MARCA	0480	NEC	1
1511	MARCA	0291	REX ROTARY	1
1512	MARCA	0292	REXON	1
1513	MARCA	0293	RINDEZA	1
1514	MARCA	0294	WRIGTH LINE	1
1515	MARCA	0295	RL	1
1516	MARCA	0296	ROBOTICS	1
1517	MARCA	0297	ROLL	1
1518	MARCA	0298	ROSBACK	1
1519	MARCA	0299	ROTAPRINT	1
1520	MARCA	0300	ROTATRIM	1
1521	MARCA	0301	ROTRING	1
1522	MARCA	0302	ROTROM	1
1523	MARCA	0303	SAHO	1
1566	MARCA	0346	TEKPLUS	1
1567	MARCA	0347	TEMPUS	1
1568	MARCA	0348	TEROKAL	1
1569	MARCA	0349	TEXACO	1
1525	MARCA	0305	SAN ANTONIO	1
1526	MARCA	0306	SAN LUIS	1
1527	MARCA	0307	SAN MARTIN	1
1528	MARCA	0308	SCANPLUS	1
1529	MARCA	0309	SCOTH BRITE	1
1530	MARCA	0310	SCRIPT	1
1531	MARCA	0311	SECA	1
1532	MARCA	0312	SEGRES	1
1533	MARCA	0313	SHARP	1
1534	MARCA	0314	SHREDEX	1
1535	MARCA	0315	SILVANIA	1
1536	MARCA	0316	SILVER CROWN	1
1537	MARCA	0317	SIMAR	1
1538	MARCA	0318	SIMPLEX	1
1539	MARCA	0319	WALTON	1
1540	MARCA	0320	SISTELEC	1
1541	MARCA	0321	SISTELEY BARDAL	1
1542	MARCA	0322	SONY	1
1543	MARCA	0323	STAEDTLER	1
1544	MARCA	0324	STANZA	1
338	NIVEL-TRABAJADOR	11	Auxiliar	1
340	NIVEL-TRABAJADOR	13	Practicante	1
341	NIVEL-TRABAJADOR	99	NO DEFINIDO	1
342	AFP	\N	AFP HABITAT	1
343	AFP	\N	AFP HORIZONTE	1
344	AFP	\N	AFP INTEGRA	1
630	MARCA	0712	STA. SYSTEMS	1
631	MARCA	0713	STIHL	1
632	MARCA	0714	STONE	1
633	MARCA	0715	SUNRAY	1
634	MARCA	0716	SUPER	1
20298	SIAF-TIPO-OPER	AP	ADELANTO A PROVEEDORES	1
19	PROFESION	\N	COMPUTACION	1
20299	SIAF-TIPO-OPER	AV	ENCARGO INTERNO PARA VIATICOS	1
20300	SIAF-TIPO-OPER	C	GASTO - FONDO FIJO PARA CAJA CHICA (APERTURA Y/O AMPLIACIONES)	1
20301	SIAF-TIPO-OPER	CA	CONTRATO - ADELANTOS	1
20302	SIAF-TIPO-OPER	CF	CARTA FIANZA	1
20303	SIAF-TIPO-OPER	CL	CONTRATO - LIQUIDACION	1
20304	SIAF-TIPO-OPER	CP	CONTRATO - PAGOS A CUENTA	1
320	TIPO-CAPACITACION	\N	Recibida	1
321	TIPO-CAPACITACION	\N	Otorgado	1
322	TIPO-CAPACITACION	\N	Como oyente	1
323	TIPO-CAPACITACION	\N	Como ponente	1
324	TIPO-CAPACITACION	\N	Material Divulgativo	1
326	TIPO-CAPACITACION	\N	Articulos en revistas cientificas	1
327	TIPO-CAPACITACION	\N	Edicion o compilacion de libros publicados	1
328	NIVEL-TRABAJADOR	01	Presidente	1
329	NIVEL-TRABAJADOR	02	Gerente General	1
330	NIVEL-TRABAJADOR	03	Gerente	1
331	NIVEL-TRABAJADOR	04	Auditor Interno	1
332	NIVEL-TRABAJADOR	05	Asesor	1
333	NIVEL-TRABAJADOR	06	Profesional I	1
334	NIVEL-TRABAJADOR	07	Profesional II	1
613	MARCA	0695	SANFLEX	1
635	MARCA	0717	SUPER STACK	1
636	MARCA	0718	SUZUKI	1
637	MARCA	0719	TECCTROMIX	1
638	MARCA	0720	TECNIART	1
639	MARCA	0721	TERUMO	1
640	MARCA	0722	TESTA	1
641	MARCA	0723	TEXSPORT	1
616	MARCA	0698	SARTORIUS	1
698	MARCA	0780	AGRALE MODASA	1
699	MARCA	0781	Y-TEX	1
700	MARCA	0782	NORTON	1
701	MARCA	0783	MGE - MERLIN GERIN	1
702	MARCA	0784	SHOLLERSHAMER	1
703	MARCA	0785	COMPUTER ASSOCIATES	1
704	MARCA	0786	DIFCO-BECTON DICKINSON	1
783	MARCA	0865	MILLIPORE	1
784	MARCA	0866	NAPCO	1
785	MARCA	0867	ORION	1
786	MARCA	0868	TROEMNER	1
787	MARCA	0869	BLUE M	1
788	MARCA	0870	IEC	1
789	MARCA	0871	MENUMASTER	1
790	MARCA	0872	REVCO - UII	1
791	MARCA	0873	GE / KENMORE	1
846	MARCA	0928	FRAVIL	1
847	MARCA	0929	COLD MASTER	1
848	MARCA	0930	CITECIL	1
849	MARCA	0931	HOPE	1
850	MARCA	0932	COLUZEEP	1
851	MARCA	0933	YUSPHONE FONOTEL	1
852	MARCA	0934	HANGAR	1
853	MARCA	0935	TAYLOR	1
854	MARCA	0936	SUPER COOL	1
855	MARCA	0937	AUDIOTEK	1
856	MARCA	0938	MOVITEC	1
857	MARCA	0939	SHMPHIL	1
858	MARCA	0940	CHARGE AIR	1
859	MARCA	0941	HERAUS	1
860	MARCA	0942	OPTIFIX	1
861	MARCA	0943	HERTEL	1
862	MARCA	0944	HOT MASTER	1
863	MARCA	0945	MICLAN	1
864	MARCA	0946	CONMAX	1
865	MARCA	0947	STABYTRON	1
866	MARCA	0948	GEMMY INDUSTRIAL	1
867	MARCA	0949	SAHQUER	1
868	MARCA	0950	SHAKER	1
869	MARCA	0951	FANEN	1
870	MARCA	0952	PEMALOR	1
871	MARCA	0953	COBOS PRECISION	1
872	MARCA	0954	ELKOMAT	1
873	MARCA	0955	FORTUNA	1
875	MARCA	0957	BIOLAM	1
876	MARCA	0958	PRAZISIONS AMARELL	1
877	MARCA	0959	INRESA	1
98	PROFESION	\N	QUIMICA FARMACEUTICA	1
878	MARCA	0960	HIGH POWER	1
879	MARCA	0961	OMO	1
497	MARCA	0579	EVERGREEN SCIENTIFIC	1
498	MARCA	0580	EWT	1
499	MARCA	0581	EXCELL	1
500	MARCA	0582	FACTORY	1
501	MARCA	0583	FAMSA	1
502	MARCA	0584	FAN-80	1
962	MARCA	\N	REICHERT	1
963	MARCA	1045	DESPATCH	1
964	MARCA	1046	THELCO	1
965	MARCA	1047	IBICO	1
966	MARCA	1048	SAUTER	1
967	MARCA	1049	MELCO	1
968	MARCA	1050	PHILCO	1
969	MARCA	1051	CLAY ADAMS	1
970	MARCA	1052	GELMAN	1
971	MARCA	1053	APPARECCHI	1
972	MARCA	1054	BIOHAZARD	1
973	MARCA	1055	DAMON	1
974	MARCA	1056	SEALPETTE	1
975	MARCA	1057	ARMALAB	1
976	MARCA	1058	KYOWA	1
977	MARCA	1059	CONTINENTAL	1
978	MARCA	1060	ANGELANTONI SCIENT	1
979	MARCA	1061	AMERICAN POTICAL	1
980	MARCA	1062	CADIVEL	1
981	MARCA	1063	GARVER ELECTRIFUGE	1
982	MARCA	1064	SWIFT	1
983	MARCA	1065	MICROCOID	1
984	MARCA	1066	COLE PHAMER	1
985	MARCA	1067	GECH	1
986	MARCA	1068	MOTIC	1
987	MARCA	1069	OFTIFIX	1
988	MARCA	1070	MEGAPHON	1
989	MARCA	1071	ECHO	1
990	MARCA	1072	OVENS	1
991	MARCA	1073	ROMO	1
992	MARCA	1074	MGC-9	1
993	MARCA	1075	COSMOS	1
994	MARCA	1076	SKY	1
995	MARCA	1077	SLOMO	1
644	MARCA	0726	TITO	1
996	MARCA	1078	LEOPARDS	1
997	MARCA	1079	WARSZAWA	1
998	MARCA	1080	BLACK STELL	1
999	MARCA	1081	LEKASIDE	1
1000	MARCA	1082	INSECTOCUTOR	1
1001	MARCA	1083	NORDION	1
1002	MARCA	1084	TEMPTALE	1
1003	MARCA	1085	QUIRKE CKECK	1
1004	MARCA	1086	SHEPERD	1
1005	MARCA	1087	CONFORT AIR	1
1006	MARCA	1088	HAAKEV	1
1007	MARCA	1089	NOVAR	1
1008	MARCA	1090	SCHNIDER WIEN	1
1009	MARCA	1091	AQUARIUS	1
1010	MARCA	1092	PLANNING	1
1011	MARCA	1093	SANYO	1
1012	MARCA	1094	HOBART	1
1013	MARCA	1095	DETECTO	1
1014	MARCA	1096	OTSUKA	1
1015	MARCA	1097	RAYTECHI	1
1016	MARCA	1098	PRESTO	1
1017	MARCA	1099	DEMAG	1
1018	MARCA	1100	WALLCE & TIERNAN	1
1019	MARCA	1101	CABIN	1
1020	MARCA	1102	SURE FIRE	1
1022	MARCA	1104	TOPLA	1
1023	MARCA	1105	LIBROR	1
1024	MARCA	1106	JET	1
1025	MARCA	1107	SUPERAD	1
1026	MARCA	1108	UNION POSTALES	1
1027	MARCA	1109	INTERCOM	1
1028	MARCA	1110	FURNAS	1
1029	MARCA	1111	LUDLUM	1
1030	MARCA	1112	BICRON	1
1031	MARCA	1113	NURDIUN	1
1032	MARCA	1114	LSM	1
1034	MARCA	1116	SORVALL	1
1035	MARCA	1117	MEOPA	1
1036	MARCA	1118	YORK	1
1037	MARCA	1119	KOMBO	1
1038	MARCA	1120	EXACTAM	1
1039	MARCA	1121	JOWA	1
1040	MARCA	1122	SWORD FISH	1
1041	MARCA	1123	JENA	1
1042	MARCA	1124	JSB	1
1043	MARCA	1125	S&P	1
1044	MARCA	1126	SCIENTECH	1
1045	MARCA	1127	BELTEL	1
1046	MARCA	1128	WOLFE	1
1047	MARCA	1129	DVH	1
1049	MARCA	1131	ZEISS ICON	1
1050	MARCA	1132	VAREZ	1
1051	MARCA	1133	RFUESS	1
1052	MARCA	1134	WATCH DOG	1
1053	MARCA	1135	BALPER	1
1054	MARCA	1136	LA PAZ	1
1055	MARCA	1137	SUNOH	1
1056	MARCA	1138	AGUILA	1
1057	MARCA	1139	ELISE	1
1058	MARCA	1140	FADEX	1
1059	MARCA	1141	SUNTO	1
1060	MARCA	1142	AD ELCTRONIC	1
1061	MARCA	1143	MAX MIN	1
1062	MARCA	1144	SALVATO	1
1063	MARCA	1145	ANGAR	1
1064	MARCA	1146	ROVIC	1
1065	MARCA	1147	SEALER	1
1066	MARCA	1148	HUNT BOSTON	1
1067	MARCA	1149	ELE INTERNATIONAL	1
1068	MARCA	1150	BRANSO	1
1069	MARCA	1151	GILMONT	1
1070	MARCA	1152	BERKELEY NUCLEONICS	1
1071	MARCA	1153	MITUTOYO	1
1072	MARCA	1154	SPER SCIENTIFIC	1
1073	MARCA	1155	CRUMAIR	1
1074	MARCA	1156	BURDINOLA	1
1075	MARCA	1157	LUFFT	1
1076	MARCA	1158	YVIMEN	1
1078	MARCA	1160	ADVANCE PC	1
535	MARCA	0617	JACTO	1
536	MARCA	0618	JAMECO	1
537	MARCA	0619	JENCONS	1
538	MARCA	0620	JENWAY	1
539	MARCA	0621	JHONSON	1
540	MARCA	0622	JM DALCO	1
541	MARCA	0623	JOHNSON	1
20305	SIAF-TIPO-OPER	E	GASTO - ENCARGO	1
20306	SIAF-TIPO-OPER	EO	ENCARGO OTORGADO	1
1597	MARCA	0377	YALE	1
1598	MARCA	0378	YAMAHA	1
20307	SIAF-TIPO-OPER	F	GASTO - FONDO PARA PAGOS EN EFECTIVO (APERTURA Y/O AMPLIACIONES)	1
465	MARCA	0547	BRAND	1
20308	SIAF-TIPO-OPER	IV	GASTO - PAGO IGV A SUNAT	1
20309	SIAF-TIPO-OPER	N	GASTO - ADQUISICION DE BIENES Y SERVICIOS	1
20310	SIAF-TIPO-OPER	NA	NO APLICABLE	1
451	MARCA	0533	BARNSTEAD	1
20311	SIAF-TIPO-OPER	OG	GASTO - OTROS GASTOS DEFINITIVOS (SIN PROVEEDOR)	1
20312	SIAF-TIPO-OPER	ON	GASTO-PLANILLAS	1
20313	SIAF-TIPO-OPER	PD	PAGO DE DEUDA PÚBLICA	1
20314	SIAF-TIPO-OPER	RC	GASTO - FONDO CAJA CHICA (RENDICION Y REEMBOLSO)	1
20315	SIAF-TIPO-OPER	RF	GASTO - FONDO PARA PAGOS EN EFECTIVO (RENDICION Y REEMBOLSO)	1
20316	SIAF-TIPO-OPER	S	GASTO - SIN CLASIFICADOR	1
934	MARCA	1016	FRIOLUX	1
20317	SIAF-TIPO-OPER	SD	SERVICIO DE LA DEUDA	1
894	MARCA	0976	ELMOR	1
1197	MARCA	1294	ARTI CREATIVO	1
1198	MARCA	1295	MEMOREX	1
1199	MARCA	1296	GREAT WALL	1
1200	MARCA	1297	LED SPA	1
1201	MARCA	1298	DAIWHA	1
1202	MARCA	1299	EDAN	1
511	MARCA	0593	GFL	1
1203	MARCA	1300	JEWIN PHARMACEUTICAL (SHANDONG) CO. LTD.	1
1204	MARCA	1301	NELLCOR	1
1205	MARCA	1277	LAB-PRODUCTS	1
1206	MARCA	1278	FISATOM	1
1207	MARCA	1279	POWER SUPPLY	1
1208	MARCA	1280	BENQ.	1
1209	MARCA	1281	LOGITECH.	1
1212	MARCA	1284	BAKER	1
1213	MARCA	1285	MEDIX	1
1214	MARCA	1288	CATALINA CYLINDERS	1
1143	MARCA	1225	EASY	1
1215	MARCA	1289	HB PUKANG	1
1216	MARCA	1290	MONITEX	1
1217	MARCA	1291	WECTRON	1
1218	MARCA	1292	KAVO	1
1219	MARCA	1276	RUBICOM	1
1220	MARCA	0000	SIN MARCA	1
1300	MARCA	0080	DATSUN	1
1301	MARCA	0081	DACIER	1
1302	MARCA	0082	DAEWOO	1
1303	MARCA	0083	DATA FUTURE	1
1304	MARCA	0084	DAVID	1
1305	MARCA	0085	DAVID SYSTEM	1
1306	MARCA	0086	DE LONGHI	1
1307	MARCA	0087	DELCROSA	1
1308	MARCA	0088	DELISSE	1
1309	MARCA	0089	DELL	1
1310	MARCA	0090	DIALID	1
1311	MARCA	0091	DIAMANTE	1
1430	MARCA	0210	MERCEDES BENZ	1
546	MARCA	0628	KING OF FENS	1
547	MARCA	0629	KONTIKI	1
548	MARCA	0630	KONUS	1
549	MARCA	0631	KRAUSE	1
550	MARCA	0632	KSR	1
551	MARCA	0633	LAB-LINE	1
552	MARCA	0634	LABSYSTEM	1
553	MARCA	0635	LACO	1
554	MARCA	0636	LAD CONECCTIONS	1
555	MARCA	0637	LAND ROVER	1
556	MARCA	0638	LEICA	1
557	MARCA	0639	LEITZ	1
558	MARCA	0640	LEXMARK	1
559	MARCA	0641	LG	1
560	MARCA	0642	LIVOR	1
561	MARCA	0643	LKB	1
562	MARCA	0644	LLGIC CDMA	1
563	MARCA	0645	LUX	1
564	MARCA	0646	LYNER	1
565	MARCA	0647	MABE	1
566	MARCA	0648	MARINER	1
567	MARCA	0649	MATUSITA	1
568	MARCA	0650	MEC	1
569	MARCA	0651	MECRIL	1
570	MARCA	0652	MERCK	1
571	MARCA	0653	MERRELL	1
572	MARCA	0654	METROHM	1
573	MARCA	0655	METTLER TOLEDO	1
574	MARCA	0656	MICHELIN	1
575	MARCA	0657	MINSK	1
576	MARCA	0658	MITSUWA	1
577	MARCA	0659	MUTO	1
578	MARCA	0660	NALGENE	1
579	MARCA	0661	NASHUA	1
580	MARCA	0662	NIKON	1
581	MARCA	0663	NORMA	1
582	MARCA	0664	NOTEBOOK	1
583	MARCA	0665	NUOVA	1
584	MARCA	0666	OAKES	1
585	MARCA	0667	OHAUS	1
586	MARCA	0668	OLYMPUS	1
1033	MARCA	1115	INFOCUS	1
1319	MARCA	0099	DODGE	1
1465	MARCA	0245	OSAKI ELECTRIC	1
1082	MARCA	1164	ROBINAIR	1
1083	MARCA	1165	UNIWELD	1
1084	MARCA	1166	THERMO SHANDON	1
1085	MARCA	1167	PRECIX WEIGHT	1
1086	MARCA	1168	SCOTSMAN	1
1087	MARCA	1169	OMROM	1
1088	MARCA	1170	MASALLES	1
1089	MARCA	1171	THALES NAVIGATION	1
1090	MARCA	1172	JAAMSA	1
1091	MARCA	1173	AKITA	1
1092	MARCA	1174	LI-TECH	1
1093	MARCA	1175	WARING COMERCIAL	1
1094	MARCA	1176	MIN-GERMANY	1
1552	MARCA	0332	SUNSHINE	1
1095	MARCA	1177	TRIANGLE BIOMEDICAL SCIENCE	1
1096	MARCA	1178	GAST	1
1097	MARCA	1179	COMPAQ-HP	1
1098	MARCA	1180	KAMA	1
1099	MARCA	1181	INTER	1
1100	MARCA	1182	ARMATHERM	1
1101	MARCA	1183	BIOTEX INSTRUMENTS	1
1102	MARCA	1184	THERMO ELECTRON	1
1103	MARCA	1185	NABERTHEM	1
1104	MARCA	1186	BOECO	1
346	AFP	\N	AFP PROFUTURO	1
347	AFP	\N	AFP UNION VIDA	1
20318	SIAF-TIPO-OPER	SU	GASTO - SUBSIDIOS	1
20319	SIAF-TIPO-OPER	TC	TRANSFERENCIA ENTRE CUENTAS BANCARIAS	1
20320	SIAF-TIPO-OPER	TF	TRANSFERENCIA FINANCIERA OTORGADA	1
20321	SIAF-TIPO-OPER	Y	INGRESO - OPERACIONES VARIAS	1
20322	SIAF-TIPO-OPER	YC	INGRESO - SIN CLASIFICADOR	1
20323	SIAF-TIPO-OPER	YD	INGRESOS POR OPERACIONES DE ENDEUDAMIENTO	1
20324	SIAF-TIPO-OPER	YF	TRANSFERENCIA FINANCIERA RECIBIDA	1
20325	SIAF-TIPO-OPER	YG	OPERACION GASTO/INGRESO	1
20326	SIAF-TIPO-OPER	YT	INGRESOS TRANSFERENCIA	1
20327	SIAF-TIPO-OPER	YV	IGV - REBAJA INGRESOS X PAGO A SUNAT	1
95	PROFESION	\N	ZOOTECNISTA	1
507	MARCA	0589	FISHER	1
508	MARCA	0590	FRANCES	1
509	MARCA	0591	FRIGIDAIRE	1
510	MARCA	0592	FUNKEGERBER	1
512	MARCA	0594	GRAFIPAPEL	1
513	MARCA	0595	GRAFOPLAS	1
514	MARCA	0596	GRUNENTHAL	1
515	MARCA	0597	H.L.LITE	1
516	MARCA	0598	HALLCREST	1
517	MARCA	0599	HANSAPLAST	1
518	MARCA	0600	HERSIL	1
519	MARCA	0601	HITACHI	1
520	MARCA	0602	HUDE	1
521	MARCA	0603	HUSQVARNA	1
522	MARCA	0604	IBERO	1
523	MARCA	0605	IDE	1
524	MARCA	0606	IDEA POWER	1
525	MARCA	0607	IDEASA	1
526	MARCA	0608	IDEXX	1
527	MARCA	0609	IKA	1
528	MARCA	0610	IMRAB	1
529	MARCA	0611	INCUBAT	1
530	MARCA	0612	INSTITUTO SANITAS S.P.S.A.	1
531	MARCA	0613	INTEGRA	1
532	MARCA	0614	INTERIN	1
533	MARCA	0615	IOMEGA	1
534	MARCA	0616	IZUZO	1
391	MONEDA	US$	Dolar Americano	1
392	MONEDA	EURO	EURO	1
874	MARCA	0956	BONCES	1
1158	MARCA	1240	BENQ	1
140	CARGO-LAB	\N	Coordinador	1
141	CARGO-LAB	\N	Coordinador de Área	1
142	CARGO-LAB	\N	Coordinador de Área (e)	1
100	PROFESION	\N	CIENCIAS BIOLOGICAS	1
101	PROFESION	\N	AGROPECUARIA	1
102	PROFESION	\N	CIENCIAS ECONOMICAS	1
104	PROFESION	\N	ADMINISTRACION DE NEGOCIOS (MBA)	1
105	PROFESION	\N	ASISTENTA SOCIAL	1
106	PROFESION	\N	PERIODISMO	1
109	PROFESION	\N	CARPINTERO	1
111	PROFESION	\N	ADMINISTRACION	1
112	PROFESION	\N	INDUSTRIAS ALIMENTARIAS	1
222	GRADO-TIPO	\N	Carrera	1
223	GRADO-TIPO	\N	Maestría	1
224	GRADO-TIPO	\N	Doctorado	1
225	GRADO-INSTRUCCION	\N	Estudios Incompletos	1
226	GRADO-INSTRUCCION	\N	Estudios concluidos	1
661	MARCA	0743	VWR	1
1483	MARCA	0263	PELIKANOL	1
1484	MARCA	0264	PENTA	1
1485	MARCA	0265	PERKINS	1
1486	MARCA	0266	PETROLUBE	1
1487	MARCA	0267	PETROPERU	1
1488	MARCA	0268	PEUGEOT	1
1489	MARCA	0269	PEVEY	1
1490	MARCA	0270	PHILIPS	1
1491	MARCA	0271	PIATELLI	1
1492	MARCA	0272	PILOT	1
1493	MARCA	0273	PIONNER	1
1494	MARCA	0274	POLAR	1
1495	MARCA	0275	POWER	1
1496	MARCA	0276	PRELIN	1
1497	MARCA	0277	PREMIER	1
1498	MARCA	0278	PREMIUM	1
1499	MARCA	0279	PRIMOR	1
10	PROFESION	\N	ARQUEOLOGIA	1
1549	MARCA	0329	SUIT	1
1550	MARCA	0330	SUMMA JET	1
1551	MARCA	0331	SUN	1
1553	MARCA	0333	SUNSMAKETH III	1
1554	MARCA	0334	SUPER CROWN	1
1555	MARCA	0335	SUPER DE LUXE	1
1556	MARCA	0336	SUPER FAX	1
1557	MARCA	0337	SURCO	1
1558	MARCA	0338	SYMBOL	1
1559	MARCA	0339	SYSTEM PLUS	1
1560	MARCA	0340	TALY	1
1561	MARCA	0341	TASHIN	1
1562	MARCA	0342	TECHNICS	1
402	MARCA	0484	GLASEX	1
452	MARCA	0534	BASF	1
453	MARCA	0535	BAUSH	1
454	MARCA	0536	BAUSCH & LOMB	1
455	MARCA	0537	BDSL	1
456	MARCA	0538	BEL ART	1
457	MARCA	0539	BELLOTA	1
458	MARCA	0540	BESELER	1
459	MARCA	0541	BIPLAX	1
460	MARCA	0542	BOECKEL	1
461	MARCA	0543	BOEHRINGER INGELHEIM	1
462	MARCA	0544	BOEKEL	1
463	MARCA	0545	BOGAZ	1
464	MARCA	0546	BOHORES	1
466	MARCA	0548	BRIDGESTONE	1
467	MARCA	0549	BRINKMAN	1
468	MARCA	0550	BUCKEYE	1
469	MARCA	0551	CARL ZEISS	1
470	MARCA	0552	CARONI	1
471	MARCA	0553	CARRIER	1
1138	MARCA	1220	SEGO	1
52	PROFESION	\N	ING. DE IND. ALIMENTARIAS	1
53	PROFESION	\N	ING. MECANICA	1
54	PROFESION	\N	ING. MECANICA Y ELECTRICA	1
55	PROFESION	\N	ING. DE MECANICA DE FLUIDOS	1
56	PROFESION	\N	ING. METALURGICA	1
57	PROFESION	\N	ING. DE MINAS	1
58	PROFESION	\N	ING. PESQUERA	1
59	PROFESION	\N	ING. PESQUERA TECNOLOGICA	1
694	MARCA	0776	GOJO	1
655	MARCA	0737	VENTANAS LISTAS	1
656	MARCA	0738	VIEDA POWER	1
657	MARCA	0739	VINIFAN	1
658	MARCA	0740	VITORINOX	1
659	MARCA	0741	VOLAC	1
660	MARCA	0742	VORTEX	1
662	MARCA	0744	VWR SCIENTIFIC	1
663	MARCA	0745	VWRBRAND	1
664	MARCA	0746	WAL-MUR	1
665	MARCA	0747	WEBER	1
666	MARCA	0748	WHITE WESTINGHOUSE	1
667	MARCA	0749	WINDEX	1
668	MARCA	0750	WIZARD	1
669	MARCA	0751	WRITER	1
670	MARCA	0752	YOKOHAMA	1
671	MARCA	0753	ZENIT	1
672	MARCA	0754	ZEUS	1
673	MARCA	0755	PURINA	1
674	MARCA	0756	PYREX	1
675	MARCA	0757	TERRA UNIVERSAL INC.	1
676	MARCA	0758	PHOMAS	1
677	MARCA	0759	SCHOTT	1
678	MARCA	0760	RIEDEL	1
679	MARCA	0761	SIMAX	1
680	MARCA	0762	APPLE	1
1077	MARCA	1159	MAFRA	1
181	CARGO-BAJA	\N	DAR POR CONCLUIDA DESIGNACION	1
182	CARGO-BAJA	\N	DAR POR CONCLUIDA ENCARGATURA	1
397	MARCA	0479	ITALY	1
407	MARCA	0489	KASEMAN	1
408	MARCA	0490	EDITORA MONTERRICO S.A.	1
409	MARCA	0491	REY	1
410	MARCA	0492	UNIX	1
411	MARCA	0493	UNIPEX	1
412	MARCA	0494	HILTRA	1
413	MARCA	0495	JADIAN	1
414	MARCA	0496	SANEX	1
415	MARCA	0497	LYS	1
416	MARCA	0498	THUBAN	1
417	MARCA	0499	ALPHA	1
418	MARCA	0500	UMC	1
419	MARCA	0501	MITEK	1
420	MARCA	0502	LEVITON	1
421	MARCA	0503	PRESTOLITE	1
422	MARCA	0504	DEMESA	1
423	MARCA	0505	IBIS	1
424	MARCA	0506	TEKNO	1
425	MARCA	0507	RAISEN	1
426	MARCA	0508	MITSUMI	1
427	MARCA	0509	ABB	1
428	MARCA	0510	ABEEFE	1
429	MARCA	0511	AC ELECTRONIC	1
430	MARCA	0512	ACQUA RICCA	1
431	MARCA	0513	AGDIA	1
432	MARCA	0514	AGDIA INC.	1
433	MARCA	0515	AKILES	1
434	MARCA	0516	ALFA RSL	1
435	MARCA	0517	ALICOR	1
436	MARCA	0518	ALWAYS	1
437	MARCA	0519	AMANO	1
438	MARCA	0520	AMERICAN CAMPER	1
439	MARCA	0521	APOLLO	1
889	MARCA	0971	SKINA	1
890	MARCA	0972	MACROMEDIA	1
891	MARCA	0973	NEXTEL	1
1563	MARCA	0343	TECHNONICS	1
1620	MARCA	0400	STANLEY	1
1621	MARCA	0401	TDK	1
1627	MARCA	0407	TOSHIBA	1
1628	MARCA	0408	BAYCLIN	1
1629	MARCA	0409	NEW CLEANER	1
1630	MARCA	0410	GUILLETTE	1
1631	MARCA	0411	HAVOLINE	1
1632	MARCA	0412	KYO	1
1633	MARCA	0413	MANELSA	1
1634	MARCA	0414	SANWA	1
1635	MARCA	0415	XILOMAN	1
1636	MARCA	0416	B+W	1
1637	MARCA	0417	SHURE	1
1638	MARCA	0418	ROWI	1
1639	MARCA	0419	SAXON	1
1640	MARCA	0420	RICOHFAX	1
1641	MARCA	0421	PUNTO AZUL	1
1642	MARCA	0422	ALFAC	1
1643	MARCA	0423	DISTON	1
1644	MARCA	0424	ARROW USA	1
1645	MARCA	0425	COOPER TOOL	1
1646	MARCA	0426	WELLER	1
1647	MARCA	0427	SKIL	1
1648	MARCA	0428	BLANK DEDLER	1
1649	MARCA	0429	BRISTOL	1
1650	MARCA	0430	FOLCKOTE	1
1651	MARCA	0431	KIMBERLY	1
1652	MARCA	0432	OPALINA	1
1653	MARCA	0433	DIGITAL MASTER	1
1654	MARCA	0434	KUSKK	1
1655	MARCA	0435	WINSOR Y NEWTON	1
1656	MARCA	0436	ESCHENBACK	1
1657	MARCA	0437	ELIMINAR	1
1658	MARCA	0438	LETRASET	1
1659	MARCA	0439	LINEX	1
1660	MARCA	0440	STANDAGRAP	1
1661	MARCA	0441	DUPLIMATS	1
1662	MARCA	0442	ART PEN	1
1663	MARCA	0443	OCEANO	1
1664	MARCA	0444	INCA KOLA	1
234	GRUPO-SANGUINEO	\N	A+	1
1665	MARCA	0445	COCA COLA	1
1666	MARCA	0446	SPRITE	1
1667	MARCA	0447	KOLA REAL	1
1668	MARCA	0448	MICROSOFT	1
1669	MARCA	0449	AIMS LAB	1
1670	MARCA	0450	CREATIVE LABS	1
1671	MARCA	0451	PETROMAX	1
1672	MARCA	0452	SAP	1
1673	MARCA	0453	CMS	1
1674	MARCA	0454	MULTI MODEM	1
1675	MARCA	0455	MAN SENA	1
1676	MARCA	0456	DEXA	1
1677	MARCA	0457	CISCO	1
1678	MARCA	0458	TAICHE	1
1679	MARCA	0459	LUIUSE	1
1680	MARCA	0460	KEYBOARD	1
1681	MARCA	0461	BTC	1
1682	MARCA	0462	TURBO PLUS	1
1683	MARCA	0463	MICRONICS	1
1684	MARCA	0464	SOFT KEY	1
1685	MARCA	0465	ATR	1
1686	MARCA	0466	QTRONIX	1
1687	MARCA	0467	TTL	1
1688	MARCA	0468	JCLM	1
1689	MARCA	0469	TAIPING	1
1690	MARCA	0470	QUARTZ	1
1691	MARCA	0471	TOYOBA	1
1692	MARCA	0472	PQS	1
1693	MARCA	0473	TEL	1
642	MARCA	0724	THE HACKER	1
643	MARCA	0725	THOMAS	1
645	MARCA	0727	TRAMONTINA	1
646	MARCA	0728	TRANSVOLTEC	1
647	MARCA	0729	TRIPLETONG	1
648	MARCA	0730	TRIPP LITE	1
649	MARCA	0731	TYLER	1
650	MARCA	0732	UNIFAM	1
651	MARCA	0733	US ROBOTICS	1
652	MARCA	0734	USBECK	1
653	MARCA	0735	VASTER	1
654	MARCA	0736	VEGATRONIC	1
792	MARCA	0874	THERMOLYNE	1
793	MARCA	0875	PRECISION SCIENTIFIC	1
794	MARCA	0876	INMEZENT	1
795	MARCA	0877	CAROLINA SCIENCE	1
796	MARCA	0878	EEE EIRL. INDUSTRIA NACIONAL	1
797	MARCA	0879	LASSANE	1
798	MARCA	0880	FOR WEST	1
799	MARCA	0881	EVANS	1
800	MARCA	0882	KIA	1
801	MARCA	0883	FAEDA	1
802	MARCA	0884	MITSUBISHI	1
803	MARCA	0885	OAKTON	1
804	MARCA	0886	W.T.CLIMA	1
805	MARCA	0887	BELL-HOME	1
806	MARCA	0888	POLIJACTO	1
807	MARCA	0889	DAE-HEUNG	1
808	MARCA	0890	T-1 386DX	1
809	MARCA	0891	LOW-RATION	1
810	MARCA	0892	PS-TRONIC	1
811	MARCA	0893	YA-30	1
812	MARCA	0894	V.W.R	1
813	MARCA	0895	NIKON-ALPHAPOT-2	1
946	MARCA	1028	SPENCER	1
947	MARCA	1029	BELCOM	1
948	MARCA	1030	DEXION	1
949	MARCA	1031	AMARELL	1
950	MARCA	1032	ARNOLD	1
951	MARCA	1033	TAVOR	1
952	MARCA	1034	ERNST LEITZ	1
953	MARCA	1035	BELLCO GLAS	1
954	MARCA	1036	FEDEGARS	1
955	MARCA	1037	INTERNATIONAL CORP	1
956	MARCA	1038	OFFILINE MECCANICHE	1
957	MARCA	1039	CASTLE	1
958	MARCA	1040	LAKESIDE	1
959	MARCA	1041	WEST BEND	1
960	MARCA	1042	WEST BAND	1
961	MARCA	1043	GILSON	1
401	MARCA	0483	PINOTECK	1
228	GRADO-INSTRUCCION	\N	Grado de Bachiller	1
229	GRADO-INSTRUCCION	\N	Título profesional	1
230	GRADO-INSTRUCCION	\N	Estudio de maestría concluidos	1
231	GRADO-INSTRUCCION	\N	Grado de maestría	1
232	GRADO-INSTRUCCION	\N	Estudios de doctorado concluidos	1
233	GRADO-INSTRUCCION	\N	Grado de Doctor (PhD)	1
440	MARCA	0522	ARIEL	1
441	MARCA	0523	ARMONY	1
214	MERITO	\N	PRIMERA AMONESTACION POR FALTA INJUSTIF.	1
215	MERITO	\N	SEGUNDA AMONESTACION POR FALTA INJUSTIF.	1
216	MERITO	\N	CARTA DE ADVERTENCIA POR FALTA INJUSTIF.	1
395	MARCA	0477	DATA LI	1
396	MARCA	0478	ANDINA	1
403	MARCA	0485	BRASSO	1
404	MARCA	0486	THERMOS	1
405	MARCA	0487	OLD PARR	1
406	MARCA	0488	TACAMA	1
503	MARCA	0585	FARMTEK	1
504	MARCA	0586	FERNEZ	1
505	MARCA	0587	FERRINI & SCHOELLER	1
506	MARCA	0588	FIBERGLASS S.A.	1
1564	MARCA	0344	TECNIBALL	1
1565	MARCA	0345	TEKNO MATE	1
125	DOC-PATERNIDAD	PAR. NAC.	PARTIDA DE NACIMIENTO	1
1804	MONEDA	$	Peso Chileno	1
1805	MONEDA	$A	Peso Argentino	1
1806	MONEDA	AU$	Dolar Australiano	1
1807	MONEDA	AUSTR	Austral	1
1808	MONEDA	BAR$	Dolar de Barbados	1
1809	MONEDA	BOL	Bolivar Venezolano	1
1810	MONEDA	CAN$	Dolar Canadiense	1
1811	MONEDA	COL$	Peso Colombiano	1
1812	MONEDA	CR.SC	Corona Sueca	1
1813	MONEDA	CRUZ$	Nuevo Cruzado	1
1814	MONEDA	DEG	DEG	1
1815	MONEDA	DIRHA	Dirha (Arabia)	1
1816	MONEDA	DM	Marco Aleman Federal	1
1817	MONEDA	DRACH	Drachma Griego	1
1818	MONEDA	DY	Dinar Yugoslavo	1
1819	MONEDA	ECU	Unidad Monetaria Europea	1
1820	MONEDA	FIJ$	Dolar de Fiji	1
1821	MONEDA	FL.HL	Florin Holandes	1
1822	MONEDA	FMK	Marco Finlandes	1
1823	MONEDA	FR.B	Franco Belga	1
1824	MONEDA	FR.FR	Franco Frances	1
1825	MONEDA	FR.SZ	Franco Suizo	1
1826	MONEDA	HK$	Dolar de Hong Kong	1
1827	MONEDA	IRLS	Riyal Irani	1
1828	MONEDA	JAM$	Dolar Jamaicano	1
1829	MONEDA	KR.DN	Corona Danesa	1
1830	MONEDA	KR.IS	Corona Islandesa	1
1831	MONEDA	KRN	Corona Noruega	1
1832	MONEDA	KWD	Dinar de Kuwait	1
1833	MONEDA	L.	Libra Esterlina	1
1834	MONEDA	L.EIR	Libra del Eire	1
1835	MONEDA	L.LIB	Libra de Libano	1
1836	MONEDA	LD	Dinar de Libia	1
1837	MONEDA	LEG	Libra Egipcia	1
1838	MONEDA	LIT	Lira Italiana	1
1839	MONEDA	MAL$	Dolar Malasia	1
1840	MONEDA	MEX$	Peso Mexicano	1
1841	MONEDA	NICO	Cordova Nicaraguense	1
1842	MONEDA	NZ$	Dolar Neozelandes	1
1843	MONEDA	OS	Chelin Austriaco	1
1844	MONEDA	PORES	Escudo Portugues	1
1845	MONEDA	PTAS	Pesetas Espanolas	1
1846	MONEDA	R$	Real Brasileño	1
1847	MONEDA	RAND	Rand	1
1848	MONEDA	RBL	Rublo	1
1849	MONEDA	RUPIN	Rupia Hindu	1
1850	MONEDA	RY	Riyal de Arabia Saudita	1
1851	MONEDA	SING$	Dolar de Singapur	1
1852	MONEDA	Y	Yen Japones	1
1	ADJUNTO	TDR	Términos de Referencia	1
20955	MARCA	1543	MRC	1
20956	MARCA	1544	ALKOFAR	1
20957	MARCA	1545	ACCU-SCOPE	1
146	CARGO-LAB	\N	Digitador de información del SIGA	0
147	CARGO-LAB	\N	Digitador de Laboratorio	0
150	CARGO-LAB	\N	Especialista de Laboratorio	0
154	CARGO-LAB	\N	Especialista en Medicamentos e Insumos en Salud	0
157	CARGO-LAB	\N	Especialista en Tuberculosis	0
158	CARGO-LAB	\N	Profesional de Laboratorio	0
160	CARGO-LAB	\N	Tecnico de Laboratorio	0
1876	CONV-POST-DELAPROP-TIPOCONTROL	area	Area prioritaria	1
1879	CONV-POST-DELAPROP-TIPOCONTROL	distrito	Ubigeo - distrito	1
390	MONEDA	S/.	Sol	1
20958	MARCA	1546	DIGI-SENSE	1
20959	MARCA	1547	AIHUA	1
2080	CONV-POST-DELAPROP-TIPOCONTROL	ppto	Presupuesto	1
2081	CONV-POST-DELAPROP-TIPOCONTROL	cronograma	Cronograma	1
2082	CONV-POST-DELAPROP-TIPOCONTROL	cronograma-proyectos	Cronograma de Proyectos	1
2083	CONV-POST-DELAPROP-TIPOCONTROL	ppto-proyectos	Presupuesto de Proyectos	1
1873	CONV-POST-DELAPROP-TIPOCONTROL	titulo	Titulo	1
2088	TIPO-VIVIENDA	PR	PROPIA	1
2089	ALERGIAS	BT	BETALACTAMICOS (Penicilina - Cefalosporinicos)	1
2096	TIPO-VIVIENDA	AL	ALQUILADA	1
2097	TIPO-VIVIENDA	FM	FAMILIARES	1
2098	TIPO-VIVIENDA	PS	PENSION	1
2099	TIPO-VIVIENDA	TM	TEMPORAL	1
2100	ENFERMEDADES	DB	DIAETES	1
20100	ENFERMEDADES	HA	HIPERTENSION ARTERIAL	1
20101	ENFERMEDADES	AS	ASMA	1
20102	ENFERMEDADES	EPL	EPILEPSIA	1
20103	ALERGIAS	AN	ANALGESICOS - ANTI-INFLAMATORIOS (Kerotolaco-Diciofenaco-Ibuprofeno)	1
2084	ZONA	\N	ZONA 1	1
2085	ZONA	\N	ZONA 2	1
2086	ZONA	\N	ZONA 3	1
20165	PROCESO-SELECCION	\N	LICITACION PUBLICA (SOLO PARA EL CASO DE MEDICAMENTOS)	1
20214	PROCESO-SELECCION	\N	CONCURSO PUBLICO	1
20280	TIPO-CONTACTO	SKY	Skype	1
20215	PROCESO-SELECCION	ADP	ADJUDICACION DIRECTA PUBLICA	1
20216	PROCESO-SELECCION	ADS	ADJUDICACION DIRECTA SELECTIVA	1
20217	PROCESO-SELECCION	\N	ADJUDICACION DE MENOR CUANTIA POR DECLARACION DE DESIERTO	1
20218	PROCESO-SELECCION	LPN	LICITACION PUBLICA NACIONAL	1
20219	PROCESO-SELECCION	LPI	LICITACION PUBLICA INTERNACIONAL	1
20220	PROCESO-SELECCION	\N	CONCURSO PUBLICO NACIONAL (SOLO EN EL CASO DE CONSULTORIAS)	1
20221	PROCESO-SELECCION	\N	CONCURSO PUBLICO INTERNACIONAL (SOLO EN EL CASO DE CONSULTOR	1
20222	PROCESO-SELECCION	AMC	ADJUDICACION DE MENOR CUANTIA	1
20223	PROCESO-SELECCION	\N	Programación	1
20224	PROCESO-SELECCION	\N	ADJUDICACION DE MENOR CUANTIA POR EXONERACION	1
20225	PROCESO-SELECCION	\N	ADJUDICACION DE MENOR CUANTIA PARA CONTRATACION DE EXPERTOS	1
20226	PROCESO-SELECCION	\N	ADJUDICACION DE MENOR CUANTIA A TRABAJAR URBANO	1
20227	PROCESO-SELECCION	LP	LICITACION PUBLICA	1
20228	PROCESO-SELECCION	\N	SISTEMA INTERNACIONAL DE EVALUACION DE PROCESOS	1
20229	PROCESO-SELECCION	\N	BOLSA DE PRODUCTOS	1
20230	PROCESO-SELECCION	\N	CONVENIO	1
20231	PROCESO-SELECCION	ASP	ADJUDICACION SIN PROCESO	1
20232	PROCESO-SELECCION	\N	PROCEDIMIENTO ESPECIAL DE SELECCION - DS 24-2006-VIVIENDA	1
20233	PROCESO-SELECCION	\N	COMPETENCIA MAYOR	1
20234	PROCESO-SELECCION	\N	Distribución de la Asignación x Meta	1
20235	PROCESO-SELECCION	\N	COMPETENCIA MENOR	1
20236	PROCESO-SELECCION	\N	ADQUISICION Y CONTRATACION DIRECTA	1
20237	PROCESO-SELECCION	\N	PROCESOS POR EL FENOMENO DEL NIÑO - D.U.25-2006	1
20238	PROCESO-SELECCION	\N	PROCESOS INTERNACIONALES (LEY 25565)	1
20239	PROCESO-SELECCION	\N	COMPRAS EN EL EXTRANJERO	1
20240	PROCESO-SELECCION	\N	CONTRATACION POR CATALOGO ELECTRONICO	1
20241	PROCESO-SELECCION	\N	DECRETO DE URGENCIA N°020 - 2009	1
20242	PROCESO-SELECCION	\N	DECRETO DE URGENCIA N°041 - 2009	1
20243	PROCESO-SELECCION	\N	DECRETO DE URGENCIA N° 078-2009 (LICITACION)	1
20244	PROCESO-SELECCION	\N	DECRETO DE URGENCIA N° 078-2009 (CONCURSO)	1
20245	PROCESO-SELECCION	\N	Distribución del Calendario x Meta	1
20246	PROCESO-SELECCION	\N	DECRETO DE URGENCIA N° 078-2009 (ADJUDICACION DIRECTA)	1
20247	PROCESO-SELECCION	\N	DECRETO DE URGENCIA N° 078-2009 (MENOR CUANTIA)	1
20601	PAC-UNIDAD	36	SERVICIOS	1
20248	PROCESO-SELECCION	\N	REGIMEN ESPECIAL	1
20713	MARCA	\N	REYSER	1
20249	PROCESO-SELECCION	\N	DECRETO DE URGENCIA N°054-2011 (LICITACION)	1
20250	PROCESO-SELECCION	\N	PROCEDIMIENTO LEY 29792(MIDIS)	1
20251	PROCESO-SELECCION	\N	DECRETO DE URGENCIA N°016-2012	1
20252	PROCESO-SELECCION	\N	ADJUDICACIÓN DE MENOR CUANTÍA - CENTÉSIMA DISPOSICIÓN COMPLE	1
20253	PROCESO-SELECCION	\N	ADJUDICACIÓN DE MENOR CUANTÍA - DECRETO DE URGENCIA Nº 130-2	1
20254	PROCESO-SELECCION	\N	ADJUDICACIÓN DE MENOR CUANTÍA - DECRETO LEGISLATIVO Nº 1023	1
20255	PROCESO-SELECCION	\N	ADJUDICACIÓN DE MENOR CUANTÍA - LEY Nº 27638	1
20256	PROCESO-SELECCION	\N	Distribución de la Asignación x UE	1
20257	PROCESO-SELECCION	\N	ADJUDICACIÓN DE MENOR CUANTÍA - OCTAVA DISPOSICIÓN COMPLEMEN	1
20258	PROCESO-SELECCION	\N	ADJUDICACIÓN DE MENOR CUANTÍA - DL Nº 1017 (EXPERTO INDEPEND	1
20259	PROCESO-SELECCION	\N	ADJUDICACIÓN DE MENOR CUANTÍA - LEY Nº 26859	1
20260	PROCESO-SELECCION	\N	DECRETO LEGISLATIVO N° 1155	1
20261	PROCESO-SELECCION	\N	DECRETO LEGISLATIVO N° 1155.	1
20262	PROCESO-SELECCION	\N	PROCEDIMIENTO LEY Nº 30191 (LP)	1
20263	PROCESO-SELECCION	\N	ADJUDICACION DE MENOR CUANTIA - LEY Nº 30191	1
20264	PROCESO-SELECCION	\N	Aprobación de la Programación	1
20265	PROCESO-SELECCION	\N	Aprobación de la Distribución de la Asignación x UE	1
20266	PROCESO-SELECCION	\N	Aprobación de la Distribución del Calendario x Meta	1
20109	TIPO-CONTACTO	TELF	Telf. Emergencia 1	1
20110	TIPO-CONTACTO	TELF	Telf. Emergencia 2	1
116	TIPO-CONTACTO	CEL	Celular	1
117	TIPO-CONTACTO	FIJO	Telf. Fijo	1
118	TIPO-CONTACTO	EMAIL	EMail	1
1862	TIPO-CONTACTO	FAX	Fax	1
1877	CONV-POST-DELAPROP-TIPOCONTROL	tipo_inv	Tipo de investigación	1
1863	CONV-POST-DELAPROP-TIPOCONTROL	ocde	Areas OCDE	1
1864	CONV-POST-DELAPROP-TIPOCONTROL	equipo	Equipo de la propuesta	1
1880	CONV-POST-DELAPROP-TIPOCONTROL	si-no	Lista SI / NO	1
20269	TIPO-CONTACTO	\N	FaceBook	1
20270	TIPO-CONTACTO	\N	Twitter	1
20271	TIPO-CONTACTO	\N	Linkedin	1
20272	TIPO-CONTACTO	\N	YouTube	1
1865	CONV-POST-DELAPROP-TIPOCONTROL	indicadores	Obj. Especificos / Componentes e Indicadores	1
1866	CONV-POST-DELAPROP-TIPOCONTROL	registrador	FORMATO - Del Registrador de la Propuesta	1
1867	CONV-POST-DELAPROP-TIPOCONTROL	rep-legal	FORMATO - Del Representante Legal	1
1868	CONV-POST-DELAPROP-TIPOCONTROL	coordinador	FORMATO - Del Coordinador General de la propuesta	1
1869	CONV-POST-DELAPROP-TIPOCONTROL	asociadas	FORMATO - Entidades Asociadas	1
1870	CONV-POST-DELAPROP-TIPOCONTROL	entidad	FORMATO - Entidad Solicitante	1
1871	CONV-POST-DELAPROP-TIPOCONTROL	proyecto-fecha	Fecha de inicio y término del proyecto	1
1872	CONV-POST-DELAPROP-TIPOCONTROL	ppto-resumen	FORMATO - Resumen del Presupuesto	1
1874	CONV-POST-DELAPROP-TIPOCONTROL	texto	Texto	1
1878	CONV-POST-DELAPROP-TIPOCONTROL	distrito-grid	Lista de Ubigeo - distrito	1
20273	GRUPO-SANGUINEO	\N	A−	1
20274	GRUPO-SANGUINEO	\N	O+	1
20275	GRUPO-SANGUINEO	\N	O-	1
20276	GRUPO-SANGUINEO	\N	B+	1
20277	GRUPO-SANGUINEO	\N	B−	1
20278	GRUPO-SANGUINEO	\N	AB+	1
20279	GRUPO-SANGUINEO	\N	AB−	1
20329	ACTIVIDADES	\N	\N	1
20328	ESTADOS	RE	REGISTRADO	1
20330	ESTADOS	OB	OBSERVADO	1
20331	ESTADOS	AP	APROBADO	1
20332	ESTADOS	ER	EN REVISION	1
20333	ESTADOS	CA	CANCELADO	1
20334	ACTIVIDADES	0111	CULTIVO DE CEREALES (EXCEPTO ARROZ), LEGUMBRES Y SEMILLAS OLEAGINOSAS	1
20339	ACTIVIDADES	1811	IMPRESION	1
20338	ACTIVIDADES	1520	FABRICACION DE CALZADO	1
20337	ACTIVIDADES	1410	FABRICACION DE PRENDAS DE VESTIR, EXCEPTO PRENDAS DE PIEL	1
20336	ACTIVIDADES	1071	ELABORACION DE PRODUCTOS DE PANADERIA	1
20335	ACTIVIDADES	0162	ACTIVIDADES DE APOYO A LA GANADERIA	1
20340	ACTIVIDADES	1812	ACTIVIDADES DE SERVICIOS RELACIONADAS CON LA IMPRESION	1
20341	ACTIVIDADES	2511	FABRICACION DE PRODUCTOS METALICOS PARA USO ESTRUCTURAL	1
20345	MEF-FUNCION	00	FUNCION GENERICA	1
20342	ACTIVIDADES	6209	OTROS SERVICIOS INFORMATICOS Y DE TECNOLOGIAS DE LA INFORMACION	1
20343	ACTIVIDADES	7220	INVESTIGACIONES Y DESARROLLO EXPERIMENTAL EN EL CAMPO DE LAS CIENCIAS SOCIALES Y LAS HUMANIDADES	1
20344	ACTIVIDADES	6920	ACTIVIDADES DE CONTABILIDAD, TENEDURIA DE LIBROS Y AUDITORIA; ASESORAMIENTO EN MATERIA DE IMPUESTOS	1
20346	MEF-FUNCION	22	EDUCACION	1
20347	MEF-FUNCION	24	PREVISION SOCIAL	1
20348	MEF-PROGRAMA	000	PROGRAMA GENERICO	1
20349	MEF-PROGRAMA	004	PLANEAMIENTO GUBERNAMENTAL	1
20350	MEF-PROGRAMA	006	GESTION	1
20351	MEF-PROGRAMA	048	EDUCACION SUPERIOR	1
20352	MEF-PROGRAMA	052	PREVISION SOCIAL	1
20353	MEF-SUBPROGRAMA	0000	SUB PROGRAMA GENERICO	1
20354	MEF-SUBPROGRAMA	0005	PLANEAMIENTO INSTITUCIONAL	1
20355	MEF-SUBPROGRAMA	0007	DIRECCION Y SUPERVISION SUPERIOR	1
20356	MEF-SUBPROGRAMA	0008	ASESORAMIENTO Y APOYO	1
20357	MEF-SUBPROGRAMA	0010	INFRAESTRUCTURA Y EQUIPAMIENTO	1
20358	MEF-SUBPROGRAMA	0012	CONTROL INTERNO	1
20359	MEF-SUBPROGRAMA	0015	INVESTIGACION BASICA	1
20360	MEF-SUBPROGRAMA	0016	INVESTIGACION APLICADA	1
20361	MEF-SUBPROGRAMA	0109	EDUCACION SUPERIOR UNIVERSITARIA	1
20362	MEF-SUBPROGRAMA	0110	EDUCACION DE POST-GRADO	1
20363	MEF-SUBPROGRAMA	0111	EXTENSION UNIVERSITARIA	1
20364	MEF-SUBPROGRAMA	0116	SISTEMAS DE PENSIONES	1
20365	MEF-ACT-PROY	0000000	ACTIVIDAD PROYECTO GENERICO	1
20366	MEF-ACT-PROY	2001621	ESTUDIOS DE PRE-INVERSION	1
20367	MEF-ACT-PROY	2115811	MEJORAMIENTO DE LAS CONDICIONES PARA LA FORMACION ACADEMICA DE LOS ALUMNOS DE LA ESCUELA PROFESIONAL DE RELACIONES INDUSTRIALES DE LA UNIVERSIDAD NACIONAL DE SAN AGUSTIN	0
20368	MEF-ACT-PROY	2171444	MEJORAMIENTO DE LAS CONDICIONES PARA LA FORMACION ACADEMICA DE LOS ALUMNOS DE LA FACULTAD DE ARQUITECTURA Y URBANISMO DE LA UNIVERSIDAD NACIONAL DE SAN AGUSTIN DE AREQUIPA	1
20369	MEF-ACT-PROY	2171553	MEJORAMIENTO DE LOS SERVICIOS DEL COMEDOR UNIVERSITARIO DE LA UNIVERSIDAD NACIONAL DE SAN AGUSTIN DE AREQUIPA	1
20370	MEF-ACT-PROY	2234381	MEJORAMIENTO DE LA HABILITACION URBANA DEL CAMPUS UNIVERSITARIO - AREA CIENCIAS SOCIALES DE LA UNIVERSIDAD NACIONAL DE SAN AGUSTIN DE AREQUIPA	1
20371	MEF-ACT-PROY	3000001	ACCIONES COMUNES	1
20372	MEF-ACT-PROY	3000402	UNIVERSIDADES CUENTAN CON UN PROCESO DE INCORPORACION E INTEGRACION DE ESTUDIANTES EFECTIVO	1
20373	MEF-ACT-PROY	3000403	PROGRAMA DE FORTALECIMIENTO DE CAPACIDADES Y EVALUACION DEL DESEMPEÑO DOCENTE	1
20374	MEF-ACT-PROY	3000404	CURRICULOS DE LAS CARRERAS PROFESIONALES DE PRE-GRADO ACTUALIZADOS Y ARTICULADOS A LOS PROCESOS PRODUCTIVOS Y SOCIALES	1
20375	MEF-ACT-PROY	3000405	DOTACION DE AULAS, LABORATORIOS Y BIBLIOTECAS PARA LOS ESTUDIANTES DE PRE-GRADO	1
20376	MEF-ACT-PROY	3000406	GESTION DE LA CALIDAD DE LAS CARRERAS PROFESIONALES	1
20377	MEF-ACT-PROY	3999999	SIN PRODUCTO	1
20378	MEF-COMPONENTE	0000000	COMPONENTE GENERICO	1
20379	MEF-COMPONENTE	4000034	AMPLIACION DE INFRAESTRUCTURA DE EDUCACION UNIVERSITARIA	0
20380	MEF-COMPONENTE	4000040	MEJORAMIENTO DE INFRAESTRUCTURA DE EDUCACION UNIVERSITARIA	1
20381	MEF-COMPONENTE	5000001	PLANEAMIENTO Y PRESUPUESTO	1
20382	MEF-COMPONENTE	5000002	CONDUCCION Y ORIENTACION SUPERIOR	1
20383	MEF-COMPONENTE	5000003	GESTION ADMINISTRATIVA	1
20384	MEF-COMPONENTE	5000004	ASESORAMIENTO TECNICO Y JURIDICO	1
20385	MEF-COMPONENTE	5000006	ACCIONES DE CONTROL Y AUDITORIA	1
20386	MEF-COMPONENTE	5000650	DESARROLLO DE ESTUDIOS, INVESTIGACION Y ESTADISTICA	1
20387	MEF-COMPONENTE	5000670	DESARROLLO DE LA ENSEÑANZA DE POST-GRADO	1
20388	MEF-COMPONENTE	5000753	EXTENSION Y PROYECCION SOCIAL	1
20389	MEF-COMPONENTE	5000805	FORTALECIMIENTO INSTITUCIONAL	1
20390	MEF-COMPONENTE	5000991	OBLIGACIONES PREVISIONALES	1
20391	MEF-COMPONENTE	5001029	PRESERVACION DEL PATRIMONIO CULTURAL	1
20392	MEF-COMPONENTE	5001090	PROMOCION E INCENTIVO DE LAS ACTIVIDADES ARTISTICAS Y CULTURALES	1
20393	MEF-COMPONENTE	5001276	UNIDADES DE ENSEÑANZA Y PRODUCCION	1
20394	MEF-COMPONENTE	5001353	DESARROLLO DE LA EDUCACION UNIVERSITARIA DE PREGRADO	1
20395	MEF-COMPONENTE	5001549	GESTION ADMINISTRATIVA PARA EL APOYO A LA ACTIVIDAD ACADEMICA	1
20396	MEF-COMPONENTE	5001550	SERVICIO DEL COMEDOR UNIVERSITARIO	1
20397	MEF-COMPONENTE	5001551	SERVICIO MEDICO AL ALUMNO	1
20398	MEF-COMPONENTE	5001553	SERVICIO DE TRANSPORTE UNIVERSITARIO	1
20399	MEF-COMPONENTE	5001820	APOYO MEDICO A LA COMUNIDAD	1
20400	MEF-COMPONENTE	5001904	CONSERVACION Y PRESERVACION DE LOS BIENES DE LA INSTITUCION	1
20401	MEF-COMPONENTE	5001923	DESARROLLO DE INVESTIGACIONES CIENTIFICAS	1
20402	MEF-COMPONENTE	5003195	INCORPORACION DE NUEVOS ESTUDIANTES DE ACUERDO AL PERFIL DEL INGRESANTE	1
20403	MEF-COMPONENTE	5003196	IMPLEMENTACION DE MECANISMOS DE ORIENTACION, TUTORIA Y A POYO ACADEMICO PARA INGRESANTES	1
20404	MEF-COMPONENTE	5003197	PROGRAMA DE FORTALECIMIENTO DE CAPACIDADES DE LOS DOCENTES EN METODOLOGIAS, INVESTIGACION Y USO DE TECNOLOGIAS PARA LA ENSEÑANZA	1
20405	MEF-COMPONENTE	5003198	IMPLEMENTACION DE UN SISTEMA DE SELECCION SEGUIMIENTO Y EVALUACION DOCENTE	1
20406	MEF-COMPONENTE	5003199	IMPLEMENTACION DE UN PROGRAMA DE FOMENTO PARA LA INVESTIGACION FORMATIVA, DESARROLLADOS POR ESTUDIANTES Y DOCENTES DE PRE-GRADO	1
20407	MEF-COMPONENTE	5003200	REVISION Y ACTUALIZACION PERIODICA Y OPORTUNA DE LOS CURRICULOS	1
20408	MEF-COMPONENTE	5003201	DOTACION DE INFRAESTRUCTURA Y EQUIPAMIENTO BASICO DE AULAS	1
20409	MEF-COMPONENTE	5003202	DOTACION DE LABORATORIOS, EQUIPOS E INSUMOS	1
20410	MEF-COMPONENTE	5003203	DOTACION DE BIBLIOTECAS ACTUALIZADAS	1
20411	MEF-COMPONENTE	5003204	EVALUACION Y ACREDITACION DE CARRERAS PROFESIONALES	1
20412	MEF-COMPONENTE	5003205	PROGRAMA DE CAPACITACION PARA LOS MIEMBROS DE LOS COMITES DE ACREDITACION, DOCENTES Y ADMINISTRATIVOS DE LAS CARRERAS PROFESIONALES	1
20413	MEF-COMPONENTE	6000032	ESTUDIOS DE PRE - INVERSION	1
20414	MEF-META	00000	META GENERICA	1
20415	MEF-META	00001		1
20441	RESOLUCION	RDE	Resolución Directorial Ejecutiva	1
20442	RESOLUCION	RVR	Resolución Vicerrectorial	1
20443	TIPO-SUBVENCIONADO	\N	Administrativo	1
20444	TIPO-SUBVENCIONADO	\N	Estudiante de pregrado	1
20445	TIPO-SUBVENCIONADO	\N	Estudiante de posgrado maestría	1
20446	TIPO-SUBVENCIONADO	\N	Estudiante de posgrado doctorado	1
20447	TIPO-SUBVENCIONADO	\N	Egresado	1
20449	TIPO-CONTACTO	EMAILINST	Correo Institucional	1
2200	TIPO-PERSONAL	DOC	DOCENTE	1
20704	MARCA	\N	NOVUS	1
2201	TIPO-PERSONAL	ADM	ADMINISTRATIVO	1
2202	TIPO-PERSONAL	DMG	DOCENTE DEL MAGISTERIO	1
2203	TIPO-PERSONAL	PSA	ADM. PROF. DE LA SALUD	1
20714	MARCA	1302	EUROMEX	1
2204	TIPO-PERSONAL	OBR	OBRERO	1
2205	TIPO-PERSONAL	ST	SIN TIPO	1
2206	TIPO-PERSONAL	DES	DESIGNADO	1
2207	TIPO-PERSONAL	DDM	DESIGNADO DOC. DEL MAGISTERIO	1
2600	AFP-ESTADO	CMIX	COMISION MIXTA	1
2601	AFP-ESTADO	NOR	NORMAL	1
2602	AFP-ESTADO	SPS	SIN PRIMA DE SEGURO	1
2603	AFP-ESTADO	CSE	CESE	1
2604	AFP-ESTADO	SPSM	SIN PR-MIXTA	1
2700	CONDICION-PLANILLA	FP	FUERA DE PLANILLA	1
2701	CONDICION-PLANILLA	AC	ACTIVO	1
2702	CONDICION-PLANILLA	LS	LSGH	1
2703	CONDICION-PLANILLA	SD	SANC. DISCIPLINARIA	1
2704	CONDICION-PLANILLA	SI	SUSP. INASISTENCIA	1
2705	CONDICION-PLANILLA	CS	CESE	1
2706	CONDICION-PLANILLA	FA	FALLECIDO	1
2707	CONDICION-PLANILLA	FU	FUERA UNMSM	1
2708	CONDICION-PLANILLA	LC	LCGH	1
2709	CONDICION-PLANILLA	TC	TERMINO CONTRAT	1
2710	CONDICION-PLANILLA	RE	RENUNCIA	1
2711	CONDICION-PLANILLA	PS	PENSION SUSPENDIDA	1
2712	CONDICION-PLANILLA	DT	DESTACADO	1
2713	CONDICION-PLANILLA	ES	EXCLUIDO-SPR	1
2714	CONDICION-PLANILLA	CP	CADUCIDAD DE PENSION	1
2715	CONDICION-PLANILLA	NR	NO RATIFICADO	1
2800	ENTIDAD-SEGURO	ESSALUD	ESSALUD	1
2801	ENTIDAD-SEGURO	ONP	ONP	1
20452	MARCA	\N	ANYPSA	1
20453	MARCA	\N	CHARITO	1
20454	MARCA	\N	PREMIO	1
1335	MARCA	0115	FABER CASTELL	1
20455	MARCA	\N	SAN JACINTO	1
20456	MARCA	\N	ARQUERITO	1
20457	MARCA	\N	KW -TRIO	1
20458	MARCA	\N	STABILO	1
20459	MARCA	\N	EUROLUZ	1
20460	MARCA	\N	COMERCIAL	1
20461	MARCA	\N	PROTEC	1
20462	MARCA	\N	OFFI ECONOMICA	1
20463	MARCA	\N	FULTONS	1
20464	MARCA	\N	CLEENER	1
20465	MARCA	\N	COPITO	1
20466	MARCA	\N	DIMERC	1
20467	MARCA	\N	KASTELO	1
20468	MARCA	\N	RMP	1
20469	MARCA	\N	LAYCONSA	1
20291	MARCA	\N	POST IT	1
20470	MARCA	\N	BTICINO	1
20471	MARCA	\N	WASA PLUS	1
20472	MARCA	\N	CPP	1
20473	MARCA	\N	VIRUTEX	1
1210	MARCA	1282	XEROX.	0
1211	MARCA	1283	XEROX..	0
20474	MARCA	\N	KOPPAS	1
20475	MARCA	\N	NICHOLSON	1
20476	MARCA	\N	MR. BRILLO	1
20477	MARCA	\N	PURESHIELD	1
20478	MARCA	\N	PRISTER	1
20479	MARCA	\N	NEKO	1
20499	MARCA	\N	KINGSTON	1
20501	MARCA	\N	FORZA	1
20520	PROCEDENTE	\N	VARIOS	1
20521	MARCA	\N	BIO SOLUTIONS	1
20522	MARCA	\N	D'AMAZON	1
20523	MARCA	\N	BUBBLE	1
20526	MARCA	\N	NOBLE	1
20527	MARCA	\N	ASATEX	1
20529	MARCA	\N	ENERGIZER	1
20530	MARCA	\N	GATY	1
20531	BANCO	\N	FROST BANK	1
20532	MARCA	\N	STANDFORD	1
20533	MARCA	\N	HILIMP	1
20534	MARCA	\N	PROLIMSO	1
20535	MARCA	\N	DARYZA	1
20536	MARCA	\N	BRISOL	1
20537	MARCA	\N	COMPUCLEANER	1
20538	MARCA	\N	PRIDE	1
20539	MARCA	\N	LIMPIAMAX	1
20540	MARCA	\N	YES	1
20541	MARCA	\N	GLOVES	1
20542	MARCA	\N	FLUMISA	1
20543	MARCA	\N	AVAL	1
20544	MARCA	\N	ETERNA	1
20545	MARCA	\N	VICTORIA	1
20546	MARCA	\N	STICK N	1
20547	MARCA	\N	CORPAPEL	1
20548	MARCA	\N	EBRIEL	1
20549	MARCA	\N	DALHI	1
20550	MARCA	\N	PORFIN	1
20551	MARCA	\N	HANGZHOU HONOR	1
20552	MARCA	\N	FRIHS	1
20553	MARCA	\N	FIBRA PERU	1
20554	MARCA	\N	OVE	1
20555	MARCA	\N	TOPEX	1
20556	MARCA	\N	MR CLEANER	1
20557	MARCA	\N	DERSA	1
20558	MARCA	\N	FRISH	1
20559	MARCA	\N	PERUFAN	1
20560	MARCA	\N	EINS	1
20561	MARCA	\N	H.P	1
20562	MARCA	\N	ARTESCO.	1
20563	MARCA	\N	PEGAFAN.	1
20564	MARCA	\N	FABER-CASTELL	1
20565	MARCA	\N	SAPOLIO.	1
20566	MARCA	\N	CHARITO.	1
20567	MARCA	\N	SCP	1
20500	MARCA	\N	SANDISK	1
20524	MARCA	\N	SONIX	1
20525	MARCA	\N	GLORINDA	1
20528	MARCA	\N	FRESH WIPES	1
20568	MARCA	\N	SIN MARCA.	1
20570	MARCA	\N	VIRUTEX.	1
20600	PAC-UNIDAD	40	UNIDAD	1
1916	PAIS	528	PAÍSES BAJOS - HOLANDA	1
20705	MARCA	\N	CAYBOX	1
20706	MARCA	\N	AR CREACION	1
20707	MARCA	\N	ROTAPEL	1
20708	MARCA	\N	SHARK	1
20709	MARCA	\N	SPIME	1
20710	MARCA	\N	SKS	1
20711	MARCA	\N	DATA OFFICE	1
20712	MARCA	\N	DACER	1
20715	MARCA	1303	BELTRAN	1
20716	MARCA	1304	SANTIS	1
20717	MARCA	1305	SONAX	1
20718	MARCA	1306	CDP	1
20719	MARCA	1307	SENNHEISER	1
20720	MARCA	1308	MY CLOUD	1
20721	MARCA	1309	NEWTEK	1
20722	MARCA	1310	AVANTECH	1
20723	MARCA	1311	LABNET	1
20724	MARCA	1312	HIKVISION	1
20725	MARCA	1313	YKY	1
20726	MARCA	1314	CHISON	1
20727	MARCA	1315	ISOLAB	1
20728	MARCA	1316	KYNTEL	1
20729	MARCA	1317	YIDI	1
20730	MARCA	1318	BEGO	1
20731	MARCA	1319	LIVESTREAM	1
20732	MARCA	1320	LBB	1
20733	MARCA	1321	ALPHA OPTICS	1
20734	MARCA	1322	PEDROLLO	1
20735	MARCA	1323	MOBIC	1
20736	MARCA	1324	BINDER	1
20737	MARCA	1325	FARMINDUSTRIA GENERICOS	1
20738	MARCA	1326	PORTUGAL GENERICO	1
20739	MARCA	1327	GSK/OTC	1
20740	MARCA	1328	FAMINDUSTRIA K2	1
20824	MARCA	1412	BLACKMAGIC	1
20741	MARCA	1329	SANOFI NEW SNC	1
20742	MARCA	1330	HHITECH-ECO-S15UV	1
20743	MARCA	1331	SWASTIC	1
20744	MARCA	1332	MAJOR SCIENCE	1
20745	MARCA	1333	BIOSAN	1
20746	MARCA	1334	EQUITEC	1
20747	MARCA	1335	SEAGATE	1
20748	MARCA	1336	BIOBASE	1
20749	MARCA	1337	GENERICO	1
20750	MARCA	1338	TP-LINK	1
20751	MARCA	1339	NVIDIA	1
20753	MARCA	1341	TRUPER	1
20755	MARCA	1343	WACOM	1
20756	MARCA	1344	ZKTEKO	1
20757	MARCA	1345	STICK'N MAGIC	1
20758	MARCA	1346	SCHNEIDER ELECTRIC	1
20759	MARCA	1347	MINDARY	1
20760	MARCA	1348	CENTER	1
20761	MARCA	1349	THERMALTAKE	1
20762	MARCA	1350	STICK'N	1
20763	MARCA	1351	LAMOSA CLEAN	1
20764	MARCA	1352	GRAFIPAPEL.	1
20765	MARCA	1353	DJI	1
20766	MARCA	1354	RAYPA	1
20767	MARCA	1355	GIGABYTE	1
20768	MARCA	1356	INDUMELAB	1
20769	MARCA	1357	GRAPHOS ECOFILE	1
20825	MARCA	1413	VILTROX	1
20770	MARCA	1358	LAIVE	1
20771	MARCA	1359	BEAMLINK DUO - 2	1
20772	MARCA	1360	FAVERO	1
20773	MARCA	1361	CONTROL	1
20774	MARCA	1362	LORO.	1
20775	MARCA	1363	ELITE.	1
20776	MARCA	1364	ACTIVE LIFE	1
20777	MARCA	1365	ESET	1
20778	MARCA	1366	LEROY BIOTECH	1
20779	MARCA	1367	INTENSE DEVICES	1
20780	MARCA	1368	EARTEC	1
20781	MARCA	1369	JINPEX	1
20782	MARCA	1370	BIOTEK	1
20783	MARCA	1371	TREBOL	1
20784	MARCA	1372	ASUS	1
20785	MARCA	1373	GRAPHICS	1
20786	MARCA	1374	SIMPLICITY UV	1
20787	MARCA	1375	POWER FORCE	1
20788	MARCA	1376	WTA	1
20789	MARCA	1377	ANTON	1
20790	MARCA	1378	TRACEABLE	1
20791	MARCA	1379	MPW	1
20792	MARCA	1380	SUNPAK	1
20793	MARCA	1381	CSB	1
20794	MARCA	1382	GLOBELEC	1
20795	MARCA	1383	EATON	1
20796	MARCA	1384	INVERPOR	1
20797	MARCA	1385	BODOT	1
20798	MARCA	1386	FORTEXGYM	1
20799	MARCA	1387	NUTRIMIX	1
20800	MARCA	1388	ROTOPLAST	1
20801	MARCA	1389	TECNAL	1
20802	MARCA	1390	VISION	1
20803	MARCA	1391	WATSON MARLOW	1
20804	MARCA	1392	D-LAB	1
20805	MARCA	1393	SOLSAME	1
20806	MARCA	1394	FAST COMTEC	1
20807	MARCA	1395	PELLTRON	1
20808	MARCA	1396	LUMINEX	1
20809	MARCA	1397	IVYMEN-SYSTEM	1
20810	MARCA	1398	MICROS	1
20811	MARCA	1399	DEL NEVADO	1
20826	MARCA	1414	MILLI-DI	1
20812	MARCA	1400	ADVANCED RESEARCH	1
20813	MARCA	1401	LACIE	1
20814	MARCA	1402	KENSINGTON\r\n	1
20569	MARCA	\N	GRAFOS	1
20602	COLOR	\N	Rojo	1
20603	COLOR	\N	Azul	1
20604	COLOR	\N	Amarillo	1
20605	COLOR	\N	Verde	1
20606	COLOR	\N	Negro	1
20607	COLOR	\N	Blanco	1
20608	COLOR	\N	Rosado	1
20609	COLOR	\N	Celeste	1
20494	MARCA	\N	R&G	1
20493	MARCA	\N	DELFIN	1
20495	PROYECTO-EQUIPO-CARGO	\N	COORDINADOR GENERAL	1
20496	PROYECTO-EQUIPO-CARGO	\N	COORDINADOR ADMINISTRATIVO	1
20497	PROYECTO-EQUIPO-CARGO	\N	MIEMBRO DEL EQUIPO	1
20700	PROCESO-CONTRATO	\N	ADICIONAL	1
20701	PROCESO-CONTRATO	\N	COMPLEMETARIO	1
20702	PROCESO-CONTRATO	\N	PRÓRROGA	1
20841	MARCA	1429	SAMSUNG.	1
20703	PROCESO-CONTRATO	\N	AMPLIACIÓN DE PLAZO	1
20752	MARCA	1340	COOLER MASTER 	1
20754	MARCA	1342	HTC-2	1
20815	MARCA	1403	HEAD MITO	1
20827	MARCA	1415	BLUE PARD	1
20834	MARCA	1422	ERBA	1
20852	MARCA	1440	NIPRO	1
20853	MARCA	1441	COPPON	1
20854	MARCA	1442	LABIX	1
20855	MARCA	1443	ALKOFARMA	1
20856	MARCA	1444	DAYR	1
20863	MARCA	1451	DIVERSEY	1
20857	MARCA	1445	REPRODUX	1
20858	MARCA	1446	MILWAUKEE	1
20864	MARCA	1452	MEDICPLUS	1
20859	MARCA	1447	CLEAN SOAP	1
20860	MARCA	1448	NFT	1
20861	MARCA	1449	GOGGLES	1
20862	MARCA	1450	ECOLOVE PERU	1
20865	MARCA	1453	CHAPOMEDIC	1
20922	MARCA	1510	 INNOVASTILL	1
20866	MARCA	1454	ENTEGRIS INC	1
20867	MARCA	1455	LONGMAI	1
20868	MARCA	1456	ECOGLOVE PERU	1
20869	MARCA	1457	ALESSI	1
20870	MARCA	1458	CHAMBRIL	1
20871	MARCA	1459	SHNEIDER	1
20872	MARCA	1460	CLEAN SOAP.	1
20873	MARCA	1461	BONAVISTA	1
20874	MARCA	1462	HALUX	1
20875	MARCA	1463	CREATIVE  MEDICAL	1
20876	MARCA	1464	GLORIA	1
20877	MARCA	1465	CHASQUY	1
20878	MARCA	1466	MOLITALIA	1
20879	MARCA	1467	ACE	1
20880	MARCA	1468	INDULATEX	1
20881	MARCA	1469	PARACAS	1
20882	MARCA	1470	VASTEC	1
20883	MARCA	1471	NETSCOUT FLUKE NETWORKS	1
20884	MARCA	1472	OEM	1
20885	MARCA	1473	LABNET  INTERNATIONAL	1
20886	MARCA	1474	HANKOOK	1
20887	MARCA	1475	SOLE	1
20888	MARCA	1476	KOLFF	1
20889	MARCA	1477	DIGISYSTEM	1
20890	MARCA	1478	HANNA INSTRUMENTS	1
20891	MARCA	1479	HINOTEK	1
20892	MARCA	1480	PARAMEDICAL	1
20893	MARCA	1481	HYPACK	1
20894	MARCA	1482	FASIN	1
20895	MARCA	1483	BADGER	1
20896	MARCA	1484	CHRIST	1
20897	MARCA	1485	Ubiquiti	1
20898	MARCA	1486	SCOP	1
20899	MARCA	1487	VAISALA	1
20900	MARCA	1488	DAVIS	1
20901	MARCA	1489	LIGHTECH	1
20902	MARCA	1490	AGROSTA	1
20903	MARCA	1491	NATIONAL INSTRUMENT	1
20904	MARCA	1492	TRIMBLE	1
20905	MARCA	1493	DELAVAL	1
20906	MARCA	1494	BAR DIAMOND	1
20907	MARCA	1495	FUJITSU	1
20908	MARCA	1496	FACE MASK	1
20909	MARCA	1497	FLUKE	1
20910	MARCA	1498	YOKOGAWA	1
20911	MARCA	1499	PCE  INSTRUMENTS	1
20912	MARCA	1500	 EUROLAB	1
20913	MARCA	1501	Zeutec	1
20914	MARCA	1502	USALAB	1
20915	MARCA	1503	KOGY	1
20916	MARCA	1504	AVANTES	1
20917	MARCA	1505	SAN FERNANDO	1
20918	MARCA	1506	FLUKE NETWORKS	1
20919	MARCA	1507	BIO MOLECULAR SYSTEMS	1
20920	MARCA	1508	BIOPAC	1
20921	MARCA	1509	CHCNAV	1
20923	MARCA	1511	Huion	1
20924	MARCA	1512	SIDER PERU	1
20925	MARCA	1513	SOL	1
20926	MARCA	1514	HISDROSTAL	1
20927	MARCA	1515	Ingenia	1
20928	MARCA	1516	LENOX	1
20929	MARCA	1517	DLAB	1
20930	MARCA	1518	CLEAVER SCIENTIFIC	1
20931	MARCA	1519	APPLIED BIOSYSTEMS	1
20932	MARCA	1520	ALLEN BRADLEY	1
20933	MARCA	1521	FLUKE BIOMEDICAL	1
20934	MARCA	1522	STAPLEX	1
20935	MARCA	1523	KEYSIGHT TECHNOLOGIES	1
20936	MARCA	1524	Microwave Vision Group (MVG)	1
20937	MARCA	1525	PEAK INSTRUMENTS	1
20938	MARCA	1526	UPTODATE	1
20939	MARCA	1527	BRUKER	1
20940	MARCA	1528	ZEISS	1
20492	BANCO	\N	SCOTIABANK	1
3000	CONCEPTO-IMPORTACION	\N	Flete	1
3001	CONCEPTO-IMPORTACION	\N	Seguro	1
3002	CONCEPTO-IMPORTACION	\N	Derechos e impuestos	1
3003	CONCEPTO-IMPORTACION	\N	Transporte	1
3004	CONCEPTO-IMPORTACION	\N	Acarreo	1
3005	CONCEPTO-IMPORTACION	\N	Gastos de aduana	1
20816	MARCA	1404	KENSINGTON	1
20828	MARCA	1416	NEOGEN	1
20829	MARCA	1417	MAVIC 2 PRO	1
20830	MARCA	1418	LOSER - MINITUBE	1
20831	MARCA	1419	FORMLABS	1
20832	MARCA	1420	DREMEL	1
20833	MARCA	1421	INTECH	1
20835	MARCA	1423	PROAIR	1
20836	MARCA	1424	KARL STORZ-MINITUBE	1
20837	MARCA	1425	AORUS	1
20838	MARCA	1426	WESTERN DIGITAL	1
20839	MARCA	1427	NAVIGLIO	1
20840	MARCA	1428	THERMO FISHER SCIENTIFIC	1
20842	MARCA	1430	FAMILY DOCTOR	1
20941	MARCA	1529	TRIA	1
20843	MARCA	1431	AAA	1
20844	MARCA	1432	DHP	1
20845	MARCA	1433	NEUTROGENA	1
20846	MARCA	1434	TRENDNET TPE PG80G	1
20847	MARCA	1435	MAXXIS	1
20848	MARCA	1436	UNIQSCAN	1
20849	MARCA	1437	KARL STORZ	1
20850	MARCA	1438	WP WINPACT MAJOR SCIENCE	1
20851	MARCA	1439	3S CIENTIFIC	1
20960	MARCA	1548	ELESNA	1
20961	MARCA	1549	BEESURE	1
20962	MARCA	1550	IEDA POWER SAFE	1
20963	MARCA	1551	TPLINK	1
20964	MARCA	1552	ALKHOFAR	1
20965	MARCA	1553	\N	1
20967	MARCA	1555	WD	1
20451	BANCO	\N	CAIXA D' ENGINYERS	0
20450	BANCO	\N	HSBC BANK PERU S.A.	0
20296	BANCO	\N	US BANK	0
20294	BANCO	\N	THE BANK OF NEW YORK MELLON	0
1756	BANCO	\N	CAJA RURAL DE AHORRO Y CREDITO, CREDINKA S.A. - CUSCO	0
20817	MARCA	1405	AMP/COMMSCOPE	1
20818	MARCA	1406	PANDUIT\r\n	1
20820	MARCA	1408	DEXSON	1
20821	MARCA	1409	SATRA	1
20942	MARCA	1530	UVITEC	1
20943	MARCA	1531	\N	1
20944	MARCA	1532	SUIZA	1
20945	MARCA	1533	DENOVIX	1
20946	MARCA	1534	APPLE BUS	1
20947	MARCA	1535	SHINY	1
20948	MARCA	1536	AMD	1
20949	MARCA	1537	BOKAMG	1
20950	MARCA	1538	IMPLEN	1
20951	MARCA	1539	OLIVE	1
20952	MARCA	1540	FAITHFUL	1
20953	MARCA	1541	INVITROGEN	1
20954	MARCA	1542	HEROLAB	1
20966	MARCA	1554	ROSCH	1
20819	MARCA	1407	PANDUIT	1
20822	MARCA	1410	AMP	1
20823	MARCA	1411	TODINNO	1
1709	BANCO	\N	BANCOSUR	0
1735	BANCO	\N	CAJA MUNICIPAL DE AHORRO Y CREDITO PISCO	1
1736	BANCO	\N	CAJA MUNICIPAL DE CREDITO POPULAR DE LIMA	1
1737	BANCO	\N	CAJA RURAL DE AHORRO Y CREDITO CAJAMARCA	1
1738	BANCO	\N	CAJA RURAL DE AHORRO Y CREDITO CAJASUR	1
1701	BANCO	\N	NBK - BANK	0
1731	BANCO	\N	BANCO PARIBAS-ANDES	1
1699	BANCO	\N	BANCO LATINO	0
1745	BANCO	\N	CAJA RURAL DE AHORRO Y CREDITO QUILLABAMBA	1
1739	BANCO	\N	CAJA RURAL DE AHORRO Y CREDITO CHAVIN	1
1722	BANCO	\N	BANCO WIESE SUDAMERIS	1
1723	BANCO	\N	CORPORACION FINANCIERA DE DESARROLLO-COFIDE	1
1724	BANCO	\N	CAJA RURAL LOS AYMARAS S.A. - PUNO	1
1726	BANCO	\N	TESORO PUBLICO	1
20416	BANCO	\N	BALBOA BANK INSERT INTO SIAFMEF.BANCO	1
20417	BANCO	\N	BANCO BILBAO VIZCAYA ARGENTARIA  S.A.	1
20418	BANCO	\N	BANCO BILBAO VIZCAYA ARGENTARIA S.A. (BBVA)	1
1715	BANCO	\N	ORION CORPORACION DE CREDITO BANCO	0
1717	BANCO	\N	BANCO BOSTON (SUCURSAL DEL PERU)	1
20480	BANCO	\N	BANCO DE CREDITO	1
20481	BANCO	\N	BANCO FINANCIERO	1
20487	BANCO	\N	COOPERATIVA DE AHORRO Y CREDITO LA REHABILITADORA	1
20488	BANCO	\N	COOPERATIVA DE AHORRO Y CREDITO PETROPERU	1
20489	BANCO	\N	COOPERATIVA DE AHORRO Y CREDITO SAN ISIDRO	1
352	BANCO	011	BANCO BBVA CONTINENTAL	0
20498	BANCO	\N	BANCO CONTINENTAL	1
1718	BANCO	\N	THE BANK OF TOKYO - MITSUBISHI, LTD - TOKYO, JAPON	1
367	BANCO	\N	CAJA MUNICIPAL PIURA	1
1746	BANCO	\N	CAJA RURAL DE AHORRO Y CREDITO SEÑOR DE LUREN	1
1748	BANCO	\N	FONDO METROPOLITANO DE INVERSIONES - INVERMET	1
1727	BANCO	\N	CORPORACION FINANCIERA DE DESARROLLO- COFIDE	1
1721	BANCO	\N	CAJA RURAL SELVA CENTRAL	1
1752	BANCO	\N	DEUTSHE BANK (PERU) S.A.	1
361	BANCO	\N	BANCO SUDAMERICANO	0
357	BANCO	035	BANCO FINANCIERO DEL PERU	0
1747	BANCO	053	BANCO GNB PERU	1
350	BANCO	057	BANCO AZTECA	1
359	BANCO	059	BANCO RIPLEY	1
364	BANCO	800	CAJA METROPOLITANA DE LIMA	1
366	BANCO	808	CAJA MUNICIPAL DE AHORRO Y CREDITO HUANCAYO	1
1734	BANCO	820	CAJA MUNICIPAL DE AHORRO Y CREDITO DEL SANTA	1
20490	BANCO	900	COOPERATIVA DE AHORRO Y CREDITO  SIPAN S.A.	1
20482	BANCO	902	CAJA RURAL DE AHORRO Y CREDITO DEL CENTRO S.A.	1
20483	BANCO	904	CAJA RURAL DE AHORRO Y CREDITO INCASUR	1
1744	BANCO	906	CAJA RURAL DE AHORRO Y CREDITO PRYMERA	1
20439	BANCO	\N	ROYAL BANK OF CANADA	1
20438	BANCO	\N	MIVIVIENDA	1
20436	BANCO	\N	M.E.F.	1
20435	BANCO	\N	KOREA EXCHANGE BANK IKEBl	1
20434	BANCO	\N	FIN. UNO	1
20432	BANCO	\N	FDO.EMP. BCR	1
20431	BANCO	\N	DEUTSCHE BANK	1
20430	BANCO	\N	DBS BANK	1
20429	BANCO	\N	COOPERATIVA DE AHORRO Y CRÉDITO DEL PERU	1
20428	BANCO	\N	COMMONWEALTH  BANK OF AUSTRALIA	1
362	BANCO	\N	BANCO WIESE	0
388	BANCO	\N	SIN BANCO	1
20293	BANCO	\N	BANK OF AMERICA	1
20295	BANCO	\N	BANCO DO BRASIL S.A.	1
1714	BANCO	\N	CAJA MUNICIPAL CUSCO - AGENCIA ABANCAY	1
356	BANCO	\N	BANCO FALABELLA	1
371	BANCO	\N	CAJA NUESTRA GENTE	1
20427	BANCO	\N	CITIBANK N.A (BANCO DE CHILE)	1
20426	BANCO	\N	CITIBANK F.S.B.	1
20425	BANCO	\N	CAVALI	1
20424	BANCO	\N	BANCO SOCIETE GENERALE	1
1730	BANCO	\N	CAJA MUNICIPAL DE PAITA	1
1729	BANCO	\N	CUENTA BCRP - DEPOSITOS ESPECIALES	1
20437	BANCO	\N	MITSUILEASING	1
1720	BANCO	\N	CAJA RURAL DE AHORRO Y CREDITO DE LA REGION SAN MARTIN	1
1751	BANCO	\N	CAJA RURAL DE AHORRO Y CREDITO NUESTRA GENTE	1
1749	BANCO	\N	FINANCIERA CORDILLERA S.A.	1
1716	BANCO	\N	BANCO DEL PAIS	1
1712	BANCO	\N	CAJA RURAL DE ICA	1
1711	BANCO	\N	BANCO CENTRAL DE RESERVA DEL PERU	1
1698	BANCO	\N	BANCO REPUBLICA	0
1710	BANCO	\N	SERBANCO	0
1861	BANCO	\N	FINANCIERA NUEVA VISION	1
1719	BANCO	\N	CAJA MUNICIPAL CUSCO	1
1733	BANCO	\N	CAJA MUNICIPAL DE AHORRO Y CREDITO CHINCHA	1
1740	BANCO	\N	CAJA RURAL DE AHORRO Y CREDITO CRUZ DE CHALPON	1
1728	BANCO	\N	CAJA NORPERU	1
1725	BANCO	\N	FIRST UNION NATIONAL BANK (NEW YORK)	1
20440	BANCO	\N	UNICREDIT BANCA DI ROMA	1
1757	BANCO	\N	COOPERATIVA DE AHORRO Y CREDITO SANTO CRISTO DE BAGAZAN	1
20485	BANCO	\N	CITIBANK	1
1743	BANCO	\N	CAJA RURAL DE AHORRO Y CREDITO PROFINANZAS	1
1741	BANCO	\N	CAJA RURAL DE AHORRO Y CREDITO LIBERTADORES DE AYACUCHO	1
20486	BANCO	\N	COOPERATIVA DE AHORRO Y CREDITO EL DORADO	1
1713	BANCO	\N	CAJA MUNICIPAL DE ICA	1
1755	BANCO	\N	FINANCIERA CREAR	1
1761	BANCO	\N	BANCO AGROPECUARIO - AGROBANCO	1
20420	BANCO	\N	BANCO DE LA NACIÓN ARGENTINA	1
20421	BANCO	\N	BANCO DEL PICHINCHA CA.	1
20422	BANCO	\N	BANCO DE OCCIDENTE	1
20423	BANCO	\N	BANCO INDUSTRIAL Y COMERCIAL DE CHINA ICBC	1
1758	BANCO	\N	FINANCIERA UNIVERSAL S.A.	1
1759	BANCO	\N	DIRECCION GENERAL DE ENDEUDAMIENTO Y TESORO PUBLICO	1
1700	BANCO	\N	BANCO DE LIMA	0
1702	BANCO	\N	STANDARD CHARTERED PERU	1
1703	BANCO	\N	BANCO BANEX	1
1704	BANCO	\N	BANCO DEL PROGRESO	0
1750	BANCO	\N	FINANCIERA EDYFICAR	1
1705	BANCO	\N	BANCO DEL TRABAJO	1
1706	BANCO	\N	BANCO SANTANDER CENTRAL HISPANO	1
1707	BANCO	\N	BANCO SOLVENTA	0
1708	BANCO	\N	BANCO DEL NUEVO MUNDO	0
355	BANCO	018	BANCO DE LA NACION	1
353	BANCO	023	BANCO DE COMERCIO	1
358	BANCO	038	BANCO INTERAMERICANO DE FINANZAS (BIF)	1
374	BANCO	043	CREDISCOTIA FINANCIERA S.A.	1
360	BANCO	056	BANCO SANTANDER PERU	1
20419	BANCO	058	BANCO CENCOSUD	1
1732	BANCO	070	MIBANCO	1
2307	SUB-TIPO-CONCEPTO	PI	PAGO INDEBIDO	1
2301	SUB-TIPO-CONCEPTO	BS	BASICO	1
2302	SUB-TIPO-CONCEPTO	DA	DERECHOS ADQUIRIDOS	1
2310	SUB-TIPO-CONCEPTO	OD	OTROS DESCUENTOS	0
2311	SUB-TIPO-CONCEPTO	OI	OTROS INGRESOS	0
2011	PAIS	012	ARGELIA	1
2012	PAIS	204	BENIN	1
2013	PAIS	072	BOTSUANA	1
20491	BANCO	200	FINANCIERA CREDINKA S.A	1
2010	PAIS	024	ANGOLA	1
1762	BANCO	202	FINANCIERA PROEMPRESA S.A.	1
1753	BANCO	204	FINANCIERA CONFIANZA	1
1860	BANCO	208	COMPARTAMOS FINANCIERA	1
20433	BANCO	210	FINANCIERA QAPAQ	1
375	BANCO	212	FINANCIERA TFC S.A.	1
1754	BANCO	216	AMERIKA FINANCIERA	1
370	BANCO	802	CAJA MUNICIPAL DE AHORRO Y CREDITO TRUJILLO	1
368	BANCO	805	CAJA MUNICIPAL DE AHORRO Y CREDITO SULLANA	1
369	BANCO	813	CAJA MUNICIPAL DE AHORRO Y CREDITO TACNA	1
363	BANCO	826	CAJA MUNICIPAL DE AHORRO Y CREDITO DE MAYNAS	1
1742	BANCO	908	CAJA RURAL DE AHORRO Y CREDITO LOS ANDES	1
2300	SUB-TIPO-CONCEPTO	AP	APORTACIONES	1
2308	SUB-TIPO-CONCEPTO	PV	PROVEEDORES	1
37012	TIPO-INST-EDUCATIVA	4	INSTITUTOS DE EDUCACIÓN SUPERIOR TECNOLÓGICA (IEST)	1
37013	TIPO-INST-EDUCATIVA	5	INSTITUTO SUPERIOR PEDAGÓGICO	1
37014	TIPO-INST-EDUCATIVA	6	UNIVERSIDAD	1
37015	TIPO-INST-EDUCATIVA	7	EDUCACIÓN SUPERIOR DE FORMACIÓN ARTÍSTICA	1
37016	TIPO-INST-EDUCATIVA	8	ESCUELAS E INSTITUTOS DE EDUCACIÓN SUPERIOR TECNOLÓGICOS DE LAS FUERZAS ARMADAS Y POLICIALES	1
37017	TIPO-INST-EDUCATIVA	9	NO ESPECIFICADO (1)	1
37018	INST-EDUCATIVA	140332361	140332361 - NACIONES UNIDAS 	1
37019	INST-EDUCATIVA	140337915	140337915 - ARGENTINA	1
37020	INST-EDUCATIVA	140337931	140337931 - DISEÑO Y COMUNICACION	1
37021	INST-EDUCATIVA	140359729	140359729 - CARLOS SALAZAR ROMERO	1
37022	INST-EDUCATIVA	140450114	140450114 - JOSE PARDO	1
37023	INST-EDUCATIVA	140478412	140478412 - MARIA ROSARIO ARAOZ PINTO	1
37024	INST-EDUCATIVA	140479048	140479048 - SANTIAGO ANTUNEZ DE MAYOLO	1
37025	INST-EDUCATIVA	140481085	140481085 - PEDRO P. DIAZ	1
37026	INST-EDUCATIVA	140481093	140481093 - JOSE CARLOS MARIATEGUI  - MARISCAL NIETO	1
37027	INST-EDUCATIVA	140481127	140481127 - TUPAC AMARU	1
37028	INST-EDUCATIVA	140481143	140481143 - PEDRO A. DEL AGUILA HIDALGO	1
37029	INST-EDUCATIVA	140481218	140481218 - JOSE ANTONIO ENCINAS 	1
37030	INST-EDUCATIVA	140481226	140481226 - MANUEL NUÑEZ BUTRON	1
37031	INST-EDUCATIVA	140508473	140508473 - VICTOR ALVAREZ HUAPAYA	1
37032	INST-EDUCATIVA	140510784	140510784 - CAP FAP JOSE ABELARDO QUIÑONES 	1
37033	INST-EDUCATIVA	140517664	140517664 - CHINCHA	1
37034	INST-EDUCATIVA	140520197	140520197 - LA SALLE	1
37035	INST-EDUCATIVA	140521682	140521682 - NOR ORIENTAL DE LA SELVA	1
37036	INST-EDUCATIVA	140532226	140532226 - HUARMACA	1
37037	INST-EDUCATIVA	140551317	140551317 - FRANCISCO DE PAULA GONZALES VIGIL	1
37038	INST-EDUCATIVA	140560615	140560615 - SAN ANDRES - AYABACA	1
37039	INST-EDUCATIVA	140563460	140563460 - PISCO	1
37040	INST-EDUCATIVA	140563619	140563619 - CATALINA BUENDIA DE PECHO	1
37041	INST-EDUCATIVA	140567313	140567313 - ADOLFO VIENRICH	1
37042	INST-EDUCATIVA	140568154	140568154 - PERU-JAPON	1
37043	INST-EDUCATIVA	140575746	140575746 - PASCO	1
37044	INST-EDUCATIVA	140584672	140584672 - ELEAZAR GUZMAN BARRON	1
37045	INST-EDUCATIVA	140584722	140584722 - SUIZA	1
37046	INST-EDUCATIVA	140586628	140586628 - APARICIO POMARES	1
37047	INST-EDUCATIVA	140588012	140588012 - TRUJILLO	1
37048	INST-EDUCATIVA	140591941	140591941 - 4 DE JUNIO DE 1821	1
37049	INST-EDUCATIVA	140597237	140597237 - SIMON BOLIVAR - CALLAO	1
37050	INST-EDUCATIVA	140605717	140605717 - GENERAL OSCAR ARTETA TERZI	1
37051	INST-EDUCATIVA	140606475	140606475 - PEDRO ORTIZ MONTOYA	1
37052	INST-EDUCATIVA	140606541	140606541 - CAJAMARCA	1
37053	INST-EDUCATIVA	140622365	140622365 - NUEVA ESPERANZA	1
37054	INST-EDUCATIVA	140622860	140622860 - SULLANA	1
37055	INST-EDUCATIVA	140623082	140623082 - JULIO CESAR TELLO	1
37056	INST-EDUCATIVA	140626192	140626192 - REPUBLICA FEDERAL DE ALEMANIA	1
37057	INST-EDUCATIVA	140630467	140630467 - JULI	1
37058	INST-EDUCATIVA	140635995	140635995 - ALMIRANTE MIGUEL GRAU	1
37059	INST-EDUCATIVA	140636050	140636050 - ALFRED NOBEL	1
37060	INST-EDUCATIVA	140644013	140644013 - VICTOR RAUL HAYA DE LA TORRE-BARRANCA	1
37061	INST-EDUCATIVA	140653493	140653493 - SAN MARCOS DISTRITO DE SAN MARCOS	1
37062	INST-EDUCATIVA	140659003	140659003 - DANIEL ALCIDES CARRION-DANIEL ALCIDES CARRION	1
37063	INST-EDUCATIVA	140660936	140660936 - MANUEL GONZALES PRADA	1
37064	INST-EDUCATIVA	140665984	140665984 - DANIEL VILLAR	1
37065	INST-EDUCATIVA	140669515	140669515 - OLMOS	1
37066	INST-EDUCATIVA	140669549	140669549 - MOTUPE	1
37067	INST-EDUCATIVA	140671107	140671107 - HUANTA	1
37068	INST-EDUCATIVA	140671115	140671115 - PERU-COREA DEL SUR	1
37069	INST-EDUCATIVA	140674614	140674614 - VICUS	1
37070	INST-EDUCATIVA	140674622	140674622 - NESTOR SAMUEL MARTOS GARRIDO	1
37071	INST-EDUCATIVA	140675850	140675850 - ALTO MAYO	1
37072	INST-EDUCATIVA	140675868	140675868 - RIOJA	1
37073	INST-EDUCATIVA	140678425	140678425 - CHOTA	1
37074	INST-EDUCATIVA	140678433	140678433 - BAMBAMARCA	1
37075	INST-EDUCATIVA	140679779	140679779 - VILCANOTA	1
37076	INST-EDUCATIVA	140680769	140680769 - SAN IGNACIO	1
37077	INST-EDUCATIVA	140680959	140680959 - LUIS E VALCARCEL	1
37078	INST-EDUCATIVA	140681601	140681601 - AIJA	1
37079	INST-EDUCATIVA	140681619	140681619 - JUAN HUARIN	1
37080	INST-EDUCATIVA	140684092	140684092 - OXAPAMPA	1
37081	INST-EDUCATIVA	140684654	140684654 - DE PISCOBAMBA	1
37082	INST-EDUCATIVA	140688051	140688051 - HUANCAVELICA	1
37083	INST-EDUCATIVA	140690545	140690545 - VICTOR ANDRES BELAUNDE - SANTIAGO DE CHUCO	1
37084	INST-EDUCATIVA	140690966	140690966 - GUADALUPE	1
37085	INST-EDUCATIVA	140691691	140691691 - CUTERVO	1
37086	INST-EDUCATIVA	140695429	140695429 - HONORIO DELGADO ESPINOZA	1
37087	INST-EDUCATIVA	140696039	140696039 - JOSE ARNALDO SABOGAL DIEGUEZ	1
37088	INST-EDUCATIVA	140696047	140696047 - FELIPE ALVA Y ALVA	1
37089	INST-EDUCATIVA	140697268	140697268 - ANDRES AVELINO CACERES DORREGARAY - HUANCAYO	1
37090	INST-EDUCATIVA	140697276	140697276 - SAN IGNACIO DE LOYOLA - JUNIN	1
37091	INST-EDUCATIVA	140697722	140697722 - RAMON COPAJA	1
37092	INST-EDUCATIVA	140697979	140697979 - CESAR AUGUSTO GUARDIA MAYORGA	1
37093	INST-EDUCATIVA	140698167	140698167 - FELIPE HUAMAN POMA DE AYALA	1
37094	INST-EDUCATIVA	140705012	140705012 - GILDA LILIANA BALLIVIAN ROSADO	1
37095	INST-EDUCATIVA	140713305	140713305 - MAX PLANCK	1
37096	INST-EDUCATIVA	140713339	140713339 - NARANJILLO	1
37097	INST-EDUCATIVA	140714451	140714451 - PALPA	1
37098	INST-EDUCATIVA	140716779	140716779 - AYAVIRI	1
37099	INST-EDUCATIVA	140719674	140719674 - HERMANOS CARCAMO	1
37100	INST-EDUCATIVA	140719807	140719807 - LA UNION	1
37101	INST-EDUCATIVA	140721688	140721688 - JOAQUIN REATEGUI MEDINA	1
37102	INST-EDUCATIVA	140721696	140721696 - MARISCAL RAMON CASTILLA	1
37103	INST-EDUCATIVA	140723775	140723775 - DE CASMA	1
37104	INST-EDUCATIVA	140723783	140723783 - DE HUARMEY	1
1931	PAIS	052	BARBADOS	1
37105	INST-EDUCATIVA	140723841	140723841 - CHOCOPE	1
37106	INST-EDUCATIVA	140724492	140724492 - ERASMO ARELLANO GUILLEN	1
37107	INST-EDUCATIVA	140724500	140724500 - BOLIVAR	1
37108	INST-EDUCATIVA	140724708	140724708 - PAIJAN	1
37109	INST-EDUCATIVA	140729533	140729533 - AGUSTIN HAYA DE LA TORRE	1
37110	INST-EDUCATIVA	140732792	140732792 - SANGARARA	1
37111	INST-EDUCATIVA	140734103	140734103 - ATALAYA	1
37112	INST-EDUCATIVA	140734731	140734731 - HUAMACHUCO	1
37113	INST-EDUCATIVA	140736256	140736256 - CANIPACO	1
37114	INST-EDUCATIVA	140741744	140741744 - UTCUBAMBA	1
37115	INST-EDUCATIVA	140743336	140743336 - PAMPAS-TAYACAJA	1
37116	INST-EDUCATIVA	140744235	140744235 - PAUCARTAMBO	1
37117	INST-EDUCATIVA	140745034	140745034 - BAGUA	1
37118	INST-EDUCATIVA	140752469	140752469 - LUIS FELIPE DE LAS CASAS GRIEVE	1
37119	INST-EDUCATIVA	140753962	140753962 - ABANCAY	1
37120	INST-EDUCATIVA	140757112	140757112 - VIRGEN DEL ROSARIO	1
37121	INST-EDUCATIVA	140757211	140757211 - CHIPAO	1
37122	INST-EDUCATIVA	140757229	140757229 - AUCARA	1
37123	INST-EDUCATIVA	140757880	140757880 - VICTOR RAUL HAYA DE LA TORRE-TRUJILLO	1
37124	INST-EDUCATIVA	140758094	140758094 - FLORENCIA DE MORA	1
37125	INST-EDUCATIVA	140760843	140760843 - DE HUALLAGA	1
37126	INST-EDUCATIVA	140760900	140760900 - BELLAVISTA	1
37127	INST-EDUCATIVA	140766766	140766766 - GUSTAVO EDUARDO LANATTA LUJAN	1
37128	INST-EDUCATIVA	140767467	140767467 - LONYA GRANDE	1
37129	INST-EDUCATIVA	140783282	140783282 - DE ESPINAR	1
37130	INST-EDUCATIVA	140787325	140787325 - JATUM YAUYOS	1
37131	INST-EDUCATIVA	140790758	140790758 - MONSEFU	1
37132	INST-EDUCATIVA	140795914	140795914 - SAUSA	1
37133	INST-EDUCATIVA	140797126	140797126 - MONSEÑOR JULIO GONZALES RUIZ	1
37134	INST-EDUCATIVA	140798090	140798090 - LA OROYA	1
37135	INST-EDUCATIVA	140803072	140803072 - JORGE DESMAISON SEMINARIO	1
37136	INST-EDUCATIVA	140803908	140803908 - CHURCAMPA	1
37137	INST-EDUCATIVA	140803981	140803981 - CONTAMANA	1
37138	INST-EDUCATIVA	140814343	140814343 - SANTA MARIA MAGDALENA	1
37139	INST-EDUCATIVA	140814723	140814723 - LA MERCED	1
37140	INST-EDUCATIVA	140814749	140814749 - MARCO	1
37141	INST-EDUCATIVA	140814798	140814798 - LIBERTAD - PATAZ	1
37142	INST-EDUCATIVA	140814848	140814848 - TAURIJA	1
37143	INST-EDUCATIVA	140814863	140814863 - PASCUAL SACO Y OLIVEROS	1
37144	INST-EDUCATIVA	140814871	140814871 - CHONGOYAPE	1
37145	INST-EDUCATIVA	140814913	140814913 - RODRIGUEZ DE MENDOZA	1
37146	INST-EDUCATIVA	140814970	140814970 - RECUAY	1
37147	INST-EDUCATIVA	140815050	140815050 - FAUSTINO B. FRANCO	1
37148	INST-EDUCATIVA	140815068	140815068 - CHUQUIBAMBA	1
37149	INST-EDUCATIVA	140815092	140815092 - CARLOS MALPICA RIVAROLA	1
37150	INST-EDUCATIVA	140815118	140815118 - ALFREDO JOSE MARIA ROCHA ZEGARRA	1
37151	INST-EDUCATIVA	140815134	140815134 - SAN AGUSTIN - JAEN	1
37152	INST-EDUCATIVA	140815217	140815217 - CURAHUASI	1
37153	INST-EDUCATIVA	140817510	140817510 - COLONIA DEL CACO	1
37154	INST-EDUCATIVA	140849364	140849364 - SAN MARCOS - HUARI	1
37155	INST-EDUCATIVA	140886499	140886499 - FERNANDO LEON DE VIVERO	1
37156	INST-EDUCATIVA	140891804	140891804 - CASTILLA	1
37157	INST-EDUCATIVA	140905349	140905349 - VICENTE FERRER	1
37158	INST-EDUCATIVA	140905372	140905372 - ANTONIO RAIMONDI - YUNGAY	1
37159	INST-EDUCATIVA	140911891	140911891 - DE LLAMELLIN	1
37160	INST-EDUCATIVA	140918136	140918136 - TSAMAJAIN	1
37161	INST-EDUCATIVA	140920116	140920116 - JOSE MARIA ARGUEDAS - HUANCAYO	1
37162	INST-EDUCATIVA	140920736	140920736 - DE CONCEPCION	1
37163	INST-EDUCATIVA	140920769	140920769 - MARIO GUTIERREZ LOPEZ	1
37164	INST-EDUCATIVA	140929497	140929497 - VILCABAMBA	1
37165	INST-EDUCATIVA	140930024	140930024 - CHALHUANCA	1
37166	INST-EDUCATIVA	140930230	140930230 - HERMENEGILDO MIRANDA SEGOVIA	1
37167	INST-EDUCATIVA	140931022	140931022 - ANTA	1
37168	INST-EDUCATIVA	140932384	140932384 - CLORINDA MATTO DE TURNER	1
37169	INST-EDUCATIVA	140934570	140934570 - MANU	1
37170	INST-EDUCATIVA	140934638	140934638 - IBERIA-TAHUAMANU	1
37171	INST-EDUCATIVA	140936096	140936096 - TEODORO RIVERA TAYPE	1
37172	INST-EDUCATIVA	140936708	140936708 - MESETA DE BOMBON	1
37173	INST-EDUCATIVA	140937417	140937417 - PICHANAKI	1
37174	INST-EDUCATIVA	140937656	140937656 - SAN MARTIN DE PANGOA	1
37175	INST-EDUCATIVA	141001783	141001783 - RIO SANTA	1
37176	INST-EDUCATIVA	141001940	141001940 - VIRGEN DE GUADALUPE-SANTA	1
37177	INST-EDUCATIVA	141016286	141016286 - RICARDO RAMOS PLATA	1
37178	INST-EDUCATIVA	141016401	141016401 - CANCHAQUE	1
37179	INST-EDUCATIVA	141016443	141016443 - SANTO DOMINGO DE GUZMAN - MORROPÓN	1
37180	INST-EDUCATIVA	141016484	141016484 - MANUEL YARLEQUE ESPINOZA	1
37181	INST-EDUCATIVA	141023514	141023514 - PEDRO VILCAPAZA	1
37182	INST-EDUCATIVA	141024785	141024785 - MACUSANI	1
37183	INST-EDUCATIVA	141025089	141025089 - DE CABANILLAS	1
37184	INST-EDUCATIVA	141025279	141025279 - ACORA	1
37185	INST-EDUCATIVA	141025691	141025691 - HUANCANE	1
37186	INST-EDUCATIVA	141025824	141025824 - MUÑANI	1
37187	INST-EDUCATIVA	141026319	141026319 - ANDRES AVELINO CACERES - SAN ANTONIO DE PUTINA- PUNO	1
37188	INST-EDUCATIVA	141027085	141027085 - ILAVE	1
37189	INST-EDUCATIVA	141028919	141028919 - SAN JUAN DEL ORO	1
37190	INST-EDUCATIVA	141029297	141029297 - DE YUNGUYO	1
37191	INST-EDUCATIVA	141029404	141029404 - DESAGUADERO	1
37192	INST-EDUCATIVA	141032440	141032440 - DE LA JOYA	1
37193	INST-EDUCATIVA	141042571	141042571 - NARCISO VILLANUEVA MANZO	1
37194	INST-EDUCATIVA	141058155	141058155 - CASTROVIRREYNA	1
37195	INST-EDUCATIVA	141058650	141058650 - TICRAPO	1
37196	INST-EDUCATIVA	141058742	141058742 - AURAHUA	1
37197	INST-EDUCATIVA	141060110	141060110 - MANUEL SCORZA TORRE	1
37198	INST-EDUCATIVA	141060425	141060425 - SEÑOR DE GUALAMITA	1
37199	INST-EDUCATIVA	141064971	141064971 - MANUEL SEOANE CORRALES	1
37200	INST-EDUCATIVA	141065010	141065010 - JUAN VELASCO ALVARADO	1
37201	INST-EDUCATIVA	141065051	141065051 - MISIONEROS MONFORTIANOS	1
37202	INST-EDUCATIVA	141065093	141065093 - SAN PEDRO DEL VALLE DE MALA	1
37203	INST-EDUCATIVA	141065135	141065135 - ANTENOR ORREGO ESPINOZA	1
37204	INST-EDUCATIVA	141065176	141065176 - LUIS NEGREIROS VEGA	1
37205	INST-EDUCATIVA	141065218	141065218 - OYON	1
37206	INST-EDUCATIVA	141065259	141065259 - RAMIRO PRIALE PRIALE	1
37207	INST-EDUCATIVA	141065291	141065291 - HUAYCAN	1
37208	INST-EDUCATIVA	141065333	141065333 - VILLA MARIA	1
37209	INST-EDUCATIVA	141065499	141065499 - ARTURO SABROSO MONTOYA	1
37210	INST-EDUCATIVA	141065531	141065531 - CAÑETE	1
37211	INST-EDUCATIVA	141065572	141065572 - CARLOS CUETO FERNANDINI	1
37212	INST-EDUCATIVA	141065614	141065614 - SAN FRANCISCO DE ASIS - LIMA	1
37213	INST-EDUCATIVA	141065655	141065655 - MANUEL AREVALO CACERES	1
37214	INST-EDUCATIVA	141065697	141065697 - PACARAN	1
37215	INST-EDUCATIVA	141065739	141065739 - AMAUTA JULIO C. TELLO	1
37216	INST-EDUCATIVA	141081116	141081116 - ALTO HUALLAGA 	1
37217	INST-EDUCATIVA	141081157	141081157 - FRANCISCO VIGO CABALLERO	1
37218	INST-EDUCATIVA	141101195	141101195 - SAN LUIS-CARLOS FERMIN FITZCARRALD	1
37219	INST-EDUCATIVA	141101633	141101633 - CARHUAZ	1
37220	INST-EDUCATIVA	141101641	141101641 - SEÑOR DE LA DIVINA MISERICORDIA	1
37221	INST-EDUCATIVA	141102722	141102722 - JAIME CERRON PALOMINO	1
37222	INST-EDUCATIVA	141102763	141102763 - 9 DE MAYO	1
37223	INST-EDUCATIVA	141114412	141114412 - ESCUELA NACIONAL DE ARCHIVEROS	1
37224	INST-EDUCATIVA	141116177	141116177 - JORGE BASADRE - ISLAY	1
37225	INST-EDUCATIVA	141116557	141116557 - NASCA	1
37226	INST-EDUCATIVA	141121789	141121789 - PADRE ABAD	1
37227	INST-EDUCATIVA	141122308	141122308 - MASISEA	1
37228	INST-EDUCATIVA	141124601	141124601 - CENFOTUR-CENTRO DE FORMACION EN TURISMO	1
37229	INST-EDUCATIVA	141124833	141124833 - PACARAOS	1
37230	INST-EDUCATIVA	141124957	141124957 - CHANCAY	1
37231	INST-EDUCATIVA	141126457	141126457 - DE LOS ANDES-MARISCAL NIETO	1
37232	INST-EDUCATIVA	141127349	141127349 - OMATE	1
37233	INST-EDUCATIVA	141128156	141128156 - JORGE BASADRE GROHMAN - TAMBOPATA	1
37234	INST-EDUCATIVA	141138270	141138270 - 24 DE JULIO DE ZARUMILLA	1
37235	INST-EDUCATIVA	141142108	141142108 - HATUN SORAS	1
37236	INST-EDUCATIVA	141144450	141144450 - CONTRALMIRANTE MANUEL VILLAR OLIVERA	1
37237	INST-EDUCATIVA	141145002	141145002 - PAUCAR DEL SARASARA	1
37238	INST-EDUCATIVA	141145309	141145309 - DAMASO LABERGE	1
37239	INST-EDUCATIVA	141145713	141145713 - JOSE MARIA ARGUEDAS - LUCANAS	1
37240	INST-EDUCATIVA	141147669	141147669 - DE EL ESTRECHO-RIO PUTUMAYO	1
37241	INST-EDUCATIVA	141148113	141148113 - LAGUNAS	1
37242	INST-EDUCATIVA	141149459	141149459 - MANOS UNIDAS	1
37243	INST-EDUCATIVA	141150861	141150861 - FERNANDO LORES TENAZOA	1
37244	INST-EDUCATIVA	141153519	141153519 - AMAZONAS - YURIMAGUAS	1
37245	INST-EDUCATIVA	141155860	141155860 - MANUEL JESUS DIAZ MURRUGARRA	1
37246	INST-EDUCATIVA	141158385	141158385 - CIUDAD ETEN	1
37247	INST-EDUCATIVA	141158914	141158914 - ENRIQUE LOPEZ ALBUJAR	1
37248	INST-EDUCATIVA	141158922	141158922 - EDILBERTO RIVAS VASQUEZ	1
37249	INST-EDUCATIVA	141160159	141160159 - ALBERTO PUMAYALLA DIAZ 	1
37250	INST-EDUCATIVA	141160175	141160175 - ALEXANDER VON HUMBOLDT	1
37251	INST-EDUCATIVA	141165349	141165349 - HECTOR VASQUEZ JIMENEZ	1
37252	INST-EDUCATIVA	141166560	141166560 - OTUZCO	1
37253	INST-EDUCATIVA	141167220	141167220 - ASCOPE	1
37254	INST-EDUCATIVA	141167923	141167923 - MACHE	1
37255	INST-EDUCATIVA	141172436	141172436 - LAREDO	1
37256	INST-EDUCATIVA	141175223	141175223 - JAVIER PULGAR VIDAL	1
37257	INST-EDUCATIVA	141175371	141175371 - RICARDO SALINAS VARA	1
37258	INST-EDUCATIVA	141175413	141175413 - TINYASH	1
37259	INST-EDUCATIVA	141175454	141175454 - PUERTO INCA	1
37260	INST-EDUCATIVA	141177336	141177336 - GLICERIO GOMEZ IGARZA	1
37261	INST-EDUCATIVA	141180363	141180363 - JUAN JOSE FARFAN CESPEDES	1
37262	INST-EDUCATIVA	141180405	141180405 - SEÑOR DE CHOCAN	1
37263	INST-EDUCATIVA	141180561	141180561 - LUCIANO CASTILLO COLONNA	1
37264	INST-EDUCATIVA	141180686	141180686 - LUIS F. AGURTO OLAYA	1
37265	INST-EDUCATIVA	141180728	141180728 - SIMON BOLIVAR - PAITA	1
1971	PAIS	634	CATAR	1
37266	INST-EDUCATIVA	141180801	141180801 - AYABACA	1
37267	INST-EDUCATIVA	141180843	141180843 - LIZARDO MONTERO FLORES	1
37268	INST-EDUCATIVA	141187830	141187830 - FEDERICO GONZALES CABEZUDO	1
37269	INST-EDUCATIVA	141193135	141193135 - VIRU	1
37270	INST-EDUCATIVA	141195890	141195890 - ILLIMO	1
37271	INST-EDUCATIVA	141198217	141198217 - MANUEL ANTONIO HIERRO POZO	1
37272	INST-EDUCATIVA	141203520	141203520 - CHALA	1
37273	INST-EDUCATIVA	141206630	141206630 - CENTRO DE FORMACION PROFESIONAL BINACIONAL	1
37274	INST-EDUCATIVA	141206671	141206671 - JUAN ESTEBAN LOPEZ CRUZ	1
37275	INST-EDUCATIVA	141208073	141208073 - MORROPON	1
37276	INST-EDUCATIVA	141214147	141214147 - HEROES DE SIERRA LUMI	1
37277	INST-EDUCATIVA	141219146	141219146 - FEDERICO URANGA	1
37278	INST-EDUCATIVA	141225325	141225325 - YATRAYWASI	1
37279	INST-EDUCATIVA	141232610	141232610 - CANTA	1
37280	INST-EDUCATIVA	141249077	141249077 - MAGDA PORTAL - CIENEGUILLA	1
37281	INST-EDUCATIVA	141249192	141249192 - SIMON SANCHEZ REYES	1
37282	INST-EDUCATIVA	141249796	141249796 - PUERTO LIBRE	1
37283	INST-EDUCATIVA	141257369	141257369 - ALIANZA RENOVADA ICHUÑA BELGICA	1
37284	INST-EDUCATIVA	141274364	141274364 - PERUANO ESPAÑOL	1
37285	INST-EDUCATIVA	141276492	141276492 - MAÑAZO	1
37286	INST-EDUCATIVA	141280668	141280668 - LA CANTUTA	1
37287	INST-EDUCATIVA	141302363	141302363 - COPACABANA	1
37288	INST-EDUCATIVA	141303502	141303502 - PURUS	1
37289	INST-EDUCATIVA	141313402	141313402 - SAN PEDRO - CORONGO	1
37290	INST-EDUCATIVA	141314061	141314061 - ASHANINKA	1
37291	INST-EDUCATIVA	141316520	141316520 - CABANA	1
37292	INST-EDUCATIVA	141327253	141327253 - ALFREDO SARMIENTO PALOMINO	1
37293	INST-EDUCATIVA	141327295	141327295 - VELILLE	1
37294	INST-EDUCATIVA	141328970	141328970 - CHALHUAHUACHO	1
37295	INST-EDUCATIVA	141328988	141328988 - HAQUIRA	1
37296	INST-EDUCATIVA	141331503	141331503 - DE CHINCHEROS	1
37297	INST-EDUCATIVA	141331628	141331628 - HUACCANA	1
37298	INST-EDUCATIVA	141335744	141335744 - EL MILAGRO	1
37299	INST-EDUCATIVA	141341759	141341759 - SAN SALVADOR	1
37300	INST-EDUCATIVA	141345073	141345073 - YANQUE	1
37301	INST-EDUCATIVA	141345115	141345115 - VALLE DE TAMBO	1
37302	INST-EDUCATIVA	141348697	141348697 - NUEVO OCCORO	1
37303	INST-EDUCATIVA	141349943	141349943 - SANTO DOMINGO DE GUZMAN - SUCRE	1
37304	INST-EDUCATIVA	141350404	141350404 - SAN PEDRO DE CHURCAMPA	1
37305	INST-EDUCATIVA	141350982	141350982 - SAN JUAN-VILCASHUAMAN	1
37306	INST-EDUCATIVA	141351527	141351527 - QUEROCOTO	1
37307	INST-EDUCATIVA	141351543	141351543 - EL DESCANSO	1
37308	INST-EDUCATIVA	141351956	141351956 - SANTA LUCIA - LAMPA	1
37309	INST-EDUCATIVA	141355676	141355676 - LURIN	1
37310	INST-EDUCATIVA	141355692	141355692 - CENTRO DE FORMACION AGRICOLA MOQUEGUA	1
37311	INST-EDUCATIVA	141359033	141359033 - KIMBIRI	1
37312	INST-EDUCATIVA	141359041	141359041 - SEÑOR DE LOCUMBA	1
37313	INST-EDUCATIVA	141364678	141364678 - SAN ANTONIO DE PADUA	1
37314	INST-EDUCATIVA	141365865	141365865 - CHALAMARCA	1
37315	INST-EDUCATIVA	141367127	141367127 - DE CHIRINOS	1
37316	INST-EDUCATIVA	141369792	141369792 - SANTOS VILLALOBOS HUAMAN	1
37317	INST-EDUCATIVA	141369842	141369842 - ANDABAMBA	1
37318	INST-EDUCATIVA	141375310	141375310 - CHUPACA	1
37319	INST-EDUCATIVA	141377126	141377126 - RODRIGO SALAZAR PALACIOS	1
37320	INST-EDUCATIVA	141379171	141379171 - PABLO BUTZ	1
37321	INST-EDUCATIVA	141380351	141380351 - DE PROGRESO	1
37322	INST-EDUCATIVA	141384478	141384478 - CHACAS	1
37323	INST-EDUCATIVA	141384486	141384486 - TODAS LAS ARTES	1
37324	INST-EDUCATIVA	141385095	141385095 - CEFOP CAJAMARCA	1
37325	INST-EDUCATIVA	141385426	141385426 - JOSE DOMINGO CHOQUEHUANCA	1
37326	INST-EDUCATIVA	141389949	141389949 - PAZOS	1
37327	INST-EDUCATIVA	141389956	141389956 - RUBEN MARAVI ROMANI	1
37328	INST-EDUCATIVA	141389972	141389972 - SANTA MARIA DE NIEVA	1
37329	INST-EDUCATIVA	141389980	141389980 - SAN JOSE	1
37330	INST-EDUCATIVA	141390004	141390004 - CHUPA	1
37331	INST-EDUCATIVA	141390608	141390608 - ENRIQUE PABLO MEJIA TUPAYACHI	1
37332	INST-EDUCATIVA	141391739	141391739 - INMACULADA CONCEPCION	1
37333	INST-EDUCATIVA	141391747	141391747 - CHOJATA	1
37334	INST-EDUCATIVA	141392695	141392695 - SAN LORENZO	1
37335	INST-EDUCATIVA	141393800	141393800 - SAN NICOLAS	1
37336	INST-EDUCATIVA	141396217	141396217 - VIRGEN DE LA NATIVIDAD	1
37337	INST-EDUCATIVA	141396290	141396290 - ZEPITA	1
37338	INST-EDUCATIVA	141403559	141403559 - LIRCAY	1
37339	INST-EDUCATIVA	141403575	141403575 - VIRGEN DE COCHARCAS - ANGARAES	1
37340	INST-EDUCATIVA	141412212	141412212 - CHILLIA	1
37341	INST-EDUCATIVA	141417203	141417203 - MARIANO BONIN	1
37342	INST-EDUCATIVA	141530971	141530971 - LOS MOROCHUCOS	1
37343	INST-EDUCATIVA	141539543	141539543 - LEONIDAS LOPEZ CHICAE	1
37344	INST-EDUCATIVA	141550789	141550789 - FERNANDO BELAUNDE TERRY	1
37345	INST-EDUCATIVA	141580034	141580034 - SANTA ROSA - MELGAR (PUNO)	1
37346	INST-EDUCATIVA	141590868	141590868 - EL DORADO	1
37347	INST-EDUCATIVA	141604206	141604206 - CARLOS LABORDE	1
37348	INST-EDUCATIVA	141614262	141614262 - NICANOR MUJICA ALVAREZ CALDERON	1
37349	INST-EDUCATIVA	150207597	150207597 - SANTA ROSA	1
37350	INST-EDUCATIVA	150207613	150207613 - LA SALLE-ABANCAY	1
37351	INST-EDUCATIVA	150239970	150239970 - JULIACA	1
37352	INST-EDUCATIVA	150262311	150262311 - TORIBIO RODRÍGUEZ DE MENDOZA	1
37353	INST-EDUCATIVA	150273979	150273979 - TARAPOTO	1
37354	INST-EDUCATIVA	150276188	150276188 - JUAN XXIII	1
37355	INST-EDUCATIVA	150290924	150290924 - MARCOS DURAN MARTEL	1
37356	INST-EDUCATIVA	150310656	150310656 - JOSÉ JIMÉNEZ BORJA	1
37357	INST-EDUCATIVA	150356972	150356972 - PIURA	1
37358	INST-EDUCATIVA	150391151	150391151 - HNO. VICTORINO ELORZ GOICOECHEA-CAJAMARCA	1
37359	INST-EDUCATIVA	150391169	150391169 - ARÍSTIDES MERINO MERINO	1
37360	INST-EDUCATIVA	150412189	150412189 - HUARAZ	1
37361	INST-EDUCATIVA	150419937	150419937 - NUESTRA SEÑORA  DE LOURDES	1
37362	INST-EDUCATIVA	150421412	150421412 - HUANCAVELICA	1
37363	INST-EDUCATIVA	150453761	150453761 - SAGRADO CORAZÓN DE JESÚS	1
37364	INST-EDUCATIVA	150453787	150453787 - NUESTRA SEÑORA DE CHOTA	1
37365	INST-EDUCATIVA	150474320	150474320 - PUNO	1
37366	INST-EDUCATIVA	150512855	150512855 - HNO. VICTORINO ELORZ GOICOECHEA-SULLANA	1
37367	INST-EDUCATIVA	150567784	150567784 - MERCEDES CABELLO DE CARBONERA	1
37368	INST-EDUCATIVA	150575126	150575126 - JOSÉ MARÍA ARGUEDAS-ANDAHUAYLAS	1
37369	INST-EDUCATIVA	150575308	150575308 - GREGORIO MENDEL	1
37370	INST-EDUCATIVA	150575779	150575779 - GAMANIEL BLANCO MURILLO	1
37371	INST-EDUCATIVA	150576553	150576553 - GENERALÍSIMO JOSÉ DE SAN MARTIN	1
37372	INST-EDUCATIVA	150584755	150584755 - HORACIO ZEBALLOS GAMEZ-CORONEL PORTILLO	1
37373	INST-EDUCATIVA	150586669	150586669 - TÚPAC  AMARU	1
37374	INST-EDUCATIVA	150591859	150591859 - PUQUIO	1
37375	INST-EDUCATIVA	150591909	150591909 - LA SALLE-URUBAMBA	1
37376	INST-EDUCATIVA	150595090	150595090 - MONSEÑOR ELÍAS OLÁZAR	1
37377	INST-EDUCATIVA	150597278	150597278 - IGNACIO AMADEO RAMOS OLIVERA-YUNGAY	1
37378	INST-EDUCATIVA	150598367	150598367 - POMABAMBA	1
37379	INST-EDUCATIVA	150604371	150604371 - JOSÉ SALVADOR CAVERO OVALLE	1
37380	INST-EDUCATIVA	150608299	150608299 - CHINCHA	1
37381	INST-EDUCATIVA	150609370	150609370 - GUSTAVO ALLENDE LLAVERIA	1
37382	INST-EDUCATIVA	150610519	150610519 - HERMILIO VALDIZAN	1
37383	INST-EDUCATIVA	150611525	150611525 - OCTAVIO MATTA CONTRERAS	1
37384	INST-EDUCATIVA	150622936	150622936 - NUESTRA SEÑORA DE LA ASUNCIÓN	1
37385	INST-EDUCATIVA	150622969	150622969 - JOSÉ FAUSTINO SÁNCHEZ CARRIÓN	1
37386	INST-EDUCATIVA	150623025	150623025 - PUBLICO TAYABAMBA	1
37387	INST-EDUCATIVA	150630558	150630558 - AZÁNGARO	1
37388	INST-EDUCATIVA	150630616	150630616 - EDUCACIÓN  FÍSICA LAMPA	1
37389	INST-EDUCATIVA	150634659	150634659 - INDOAMERICA	1
37390	INST-EDUCATIVA	150636811	150636811 - FRAY FLORENCIO PASCUAL ALEGRE GONZÁLEZ	1
37391	INST-EDUCATIVA	150637116	150637116 - FILIBERTO GARCÍA CUELLAR	1
37392	INST-EDUCATIVA	150638130	150638130 - CIRO  ALEGRÍA BAZAN	1
37393	INST-EDUCATIVA	150642090	150642090 - ANTENOR ORREGO	1
37394	INST-EDUCATIVA	150642348	150642348 - VÍCTOR ANDRÉS BELAUNDE	1
37395	INST-EDUCATIVA	150644807	150644807 - CHIQUIÁN	1
37396	INST-EDUCATIVA	150653584	150653584 - FIDEL ZÁRATE PLASENCIA	1
37397	INST-EDUCATIVA	150653592	150653592 - 13 DE JULIO DE 1882	1
37398	INST-EDUCATIVA	150666479	150666479 - YARINACOCHA	1
37399	INST-EDUCATIVA	150676312	150676312 - PUBLICO DE LAMAS	1
37400	INST-EDUCATIVA	150681627	150681627 - INSTITUTO SUPERIOR PEDAGOGICO PUBLICO	1
37401	INST-EDUCATIVA	150686618	150686618 - CHIMBOTE	1
37402	INST-EDUCATIVA	150688069	150688069 - EDUCACIÓN FÍSICA-HUANCAVELICA	1
37403	INST-EDUCATIVA	150688341	150688341 - NUESTRA SEÑORA DEL ROSARIO	1
37404	INST-EDUCATIVA	150690388	150690388 - DAVID SÁNCHEZ INFANTE	1
37405	INST-EDUCATIVA	150695452	150695452 - AREQUIPA	1
37406	INST-EDUCATIVA	150696385	150696385 - SAN MIGUEL	1
37407	INST-EDUCATIVA	150697235	150697235 - TEODORO PEÑALOZA	1
37408	INST-EDUCATIVA	150702902	150702902 - LORETO	1
37409	INST-EDUCATIVA	150708164	150708164 - CÉSAR ABRAHAM VALLEJO MENDOZA	1
37410	INST-EDUCATIVA	150713099	150713099 - JUANA MORENO	1
37411	INST-EDUCATIVA	150714725	150714725 - PÚBLICO BAMBAMARCA	1
37412	INST-EDUCATIVA	150721951	150721951 - PUBLICO CANGALLO	1
38744	NACIONALIDAD	9805	TOKELAU	1
37413	INST-EDUCATIVA	150726414	150726414 - GRAN PAJATEN	1
37414	INST-EDUCATIVA	150732370	150732370 - MANUEL  GONZALES  PRADA	1
37415	INST-EDUCATIVA	150751800	150751800 - JOSE CRESPO Y CASTILLO	1
37416	INST-EDUCATIVA	150759217	150759217 - SANTA CRUZ	1
37417	INST-EDUCATIVA	150783399	150783399 - GREGORIA SANTOS	1
37418	INST-EDUCATIVA	150811489	150811489 - CACHICADÁN	1
37419	INST-EDUCATIVA	150815084	150815084 - SAN MARCOS	1
37420	INST-EDUCATIVA	150891770	150891770 - LA INMACULADA	1
37421	INST-EDUCATIVA	150891952	150891952 - HONORIO DELGADO ESPINOZA	1
37422	INST-EDUCATIVA	150921015	150921015 - ACOLLA	1
37423	INST-EDUCATIVA	150926733	150926733 - PUCARÁ	1
37424	INST-EDUCATIVA	150926840	150926840 - JOSÉ SANTOS CHOCANO	1
37425	INST-EDUCATIVA	150926865	150926865 - RAFAEL HOYOS RUBIO	1
37426	INST-EDUCATIVA	150930057	150930057 - JOSÉ MARÍA ARGUEDAS-AYMARAES	1
37427	INST-EDUCATIVA	150931014	150931014 - VIRGEN DEL CARMEN	1
37428	INST-EDUCATIVA	150932368	150932368 - JOSÉ CARLOS MARIÁTEGUI	1
37429	INST-EDUCATIVA	150932392	150932392 - COYLLURQUI	1
37430	INST-EDUCATIVA	150932475	150932475 - ACOMAYO	1
37431	INST-EDUCATIVA	150932665	150932665 - DIVINO JESÚS (ANTES SANTO TOMAS)	1
37432	INST-EDUCATIVA	150933218	150933218 - QUILLABAMBA	1
37433	INST-EDUCATIVA	150933788	150933788 - HORACIO ZEBALLOS GAMEZ-QUISPICANCHI	1
37434	INST-EDUCATIVA	150936856	150936856 - HUMBERTO YAURI MARTÍNEZ	1
37435	INST-EDUCATIVA	151000694	151000694 - DEL SANTA	1
37436	INST-EDUCATIVA	151016328	151016328 - JOSÉ EULOGIO GARRIDO ESPINOZA	1
37437	INST-EDUCATIVA	151025683	151025683 - HUANCANÉ	1
37438	INST-EDUCATIVA	151027754	151027754 - JULI	1
37439	INST-EDUCATIVA	151028554	151028554 - NUÑOA	1
37440	INST-EDUCATIVA	151029123	151029123 - JOSÉ ANTONIO ENCINAS-PUNO	1
37441	INST-EDUCATIVA	151059245	151059245 - SAN JUAN BAUTISTA	1
37442	INST-EDUCATIVA	151061498	151061498 - POMACANCHI	1
37443	INST-EDUCATIVA	151065374	151065374 - SAN JOSEMARÍA ESCRIVA	1
37444	INST-EDUCATIVA	151065416	151065416 - EMILIA BARCIA BONIFFATTI	1
37445	INST-EDUCATIVA	151078880	151078880 - DE UCHIZA	1
37446	INST-EDUCATIVA	151093152	151093152 - AGUSTÍN BOCANEGRA Y PRADA	1
37447	INST-EDUCATIVA	151096924	151096924 - DE PICOTA	1
37448	INST-EDUCATIVA	151109396	151109396 - TEMBLADERA	1
37449	INST-EDUCATIVA	151113182	151113182 - NUESTRA SEÑORA DE LAS MERCEDES	1
37450	INST-EDUCATIVA	151124072	151124072 - MONTERRICO	1
37451	INST-EDUCATIVA	151141795	151141795 - CARLOS  MEDRANO VÁSQUEZ	1
37452	INST-EDUCATIVA	151150739	151150739 - CAYETANO ARDANZA	1
37453	INST-EDUCATIVA	151157916	151157916 - MONSEÑOR FRANCISCO GONZÁLEZ BURGA	1
37454	INST-EDUCATIVA	151160191	151160191 - FRAY ÁNGEL JOSÉ AZAGRA MURILLO	1
37455	INST-EDUCATIVA	151166057	151166057 - HUANCASPATA	1
37456	INST-EDUCATIVA	151180769	151180769 - MANUEL VEGAS CASTILLO	1
37457	INST-EDUCATIVA	151192830	151192830 - MARÍA MADRE	1
37458	INST-EDUCATIVA	151193259	151193259 - EDISLAO MERA DÁVILA	1
37459	INST-EDUCATIVA	151227982	151227982 - PEDRO MONGE CÓRDOVA	1
37460	INST-EDUCATIVA	151273911	151273911 - AYAVIRI	1
37461	INST-EDUCATIVA	151275759	151275759 - JOSÉ ANTONIO ENCINAS-TUMBES	1
37462	INST-EDUCATIVA	151396217	151396217 - VIRGEN DE LA NATIVIDAD	1
37463	INST-EDUCATIVA	151545623	151545623 - ALIANZA ICHUÑA BÉLGICA	1
37464	INST-EDUCATIVA	160000001	160000001 - UNIVERSIDAD NACIONAL MAYOR DE SAN MARCOS	1
37465	INST-EDUCATIVA	160000002	160000002 - UNIVERSIDAD NACIONAL DE SAN CRISTÓBAL DE HUAMANGA	1
37466	INST-EDUCATIVA	160000003	160000003 - UNIVERSIDAD NACIONAL DE SAN ANTONIO ABAD DEL CUSCO	1
37467	INST-EDUCATIVA	160000004	160000004 - UNIVERSIDAD NACIONAL DE TRUJILLO	1
37468	INST-EDUCATIVA	160000005	160000005 - UNIVERSIDAD NACIONAL DE SAN AGUSTÍN	1
37469	INST-EDUCATIVA	160000006	160000006 - UNIVERSIDAD NACIONAL DE INGENIERÍA	1
37470	INST-EDUCATIVA	160000007	160000007 - UNIVERSIDAD NACIONAL AGRARIA LA MOLINA	1
37471	INST-EDUCATIVA	160000009	160000009 - UNIVERSIDAD NACIONAL SAN LUIS GONZAGA	1
37472	INST-EDUCATIVA	160000010	160000010 - UNIVERSIDAD NACIONAL DEL CENTRO DEL PERÚ	1
37473	INST-EDUCATIVA	160000011	160000011 - UNIVERSIDAD NACIONAL DE LA AMAZONÍA PERUANA	1
37474	INST-EDUCATIVA	160000012	160000012 - UNIVERSIDAD NACIONAL DEL ALTIPLANO	1
37475	INST-EDUCATIVA	160000013	160000013 - UNIVERSIDAD NACIONAL DE PIURA	1
37476	INST-EDUCATIVA	160000016	160000016 - UNIVERSIDAD NACIONAL DE CAJAMARCA	1
37477	INST-EDUCATIVA	160000021	160000021 - UNIVERSIDAD NACIONAL FEDERICO VILLARREAL	1
37478	INST-EDUCATIVA	160000022	160000022 - UNIVERSIDAD NACIONAL AGRARIA DE LA SELVA	1
37479	INST-EDUCATIVA	160000023	160000023 - UNIVERSIDAD NACIONAL HERMILIO VALDIZÁN	1
37480	INST-EDUCATIVA	160000025	160000025 - UNIVERSIDAD NACIONAL DE EDUCACIÓN E.G.V.	1
37481	INST-EDUCATIVA	160000026	160000026 - UNIVERSIDAD NACIONAL DANIEL ALCIDES CARRIÓN	1
37482	INST-EDUCATIVA	160000027	160000027 - UNIVERSIDAD NACIONAL DEL CALLAO	1
37483	INST-EDUCATIVA	160000028	160000028 - UNIVERSIDAD NACIONAL JOSÉ FAUSTINO SÁNCHEZ CARRIÓN	1
37484	INST-EDUCATIVA	160000031	160000031 - UNIVERSIDAD NACIONAL PEDRO RUÍZ GALLO	1
37485	INST-EDUCATIVA	160000032	160000032 - UNIVERSIDAD NACIONAL JORGE BASADRE GROHMANN	1
37486	INST-EDUCATIVA	160000033	160000033 - UNIVERSIDAD NACIONAL SANTIAGO ANTÚNEZ DE MAYOLO	1
37487	INST-EDUCATIVA	160000034	160000034 - UNIVERSIDAD NACIONAL DE SAN MARTÍN	1
37488	INST-EDUCATIVA	160000035	160000035 - UNIVERSIDAD NACIONAL DE UCAYALI	1
37489	INST-EDUCATIVA	160000041	160000041 - UNIVERSIDAD NACIONAL DE TUMBES	1
37490	INST-EDUCATIVA	160000042	160000042 - UNIVERSIDAD NACIONAL DEL SANTA	1
37491	INST-EDUCATIVA	160000051	160000051 - UNIVERSIDAD NACIONAL DE HUANCAVELICA	1
38745	NACIONALIDAD	9810	TONGA	1
37492	INST-EDUCATIVA	160000075	160000075 - UNIVERSIDAD NACIONAL AMAZÓNICA DE MADRE DE DIOS	1
37493	INST-EDUCATIVA	160000076	160000076 - UNIVERSIDAD NACIONAL TORIBIO RODRÍGUEZ DE MENDOZA DE AMAZONAS	1
37494	INST-EDUCATIVA	160000077	160000077 - UNIVERSIDAD NACIONAL MICAELA BASTIDAS DE APURÍMAC	1
37495	INST-EDUCATIVA	160000084	160000084 - UNIVERSIDAD NACIONAL INTERCULTURAL DE LA AMAZONÍA	1
37564	INST-EDUCATIVA	240356949	240356949 - KOSMOS	1
37496	INST-EDUCATIVA	160000088	160000088 - UNIVERSIDAD NACIONAL TECNOLÓGICA DEL CONO SUR DE LIMA	1
37497	INST-EDUCATIVA	160000089	160000089 - UNIVERSIDAD NACIONAL JOSÉ MARÍA ARGUEDAS	1
37498	INST-EDUCATIVA	160000095	160000095 - UNIVERSIDAD NACIONAL DE MOQUEGUA	1
37499	INST-EDUCATIVA	160000098	160000098 - UNIVERSIDAD NACIONAL DE JULIACA	1
37500	INST-EDUCATIVA	160000101	160000101 - UNIVERSIDAD NACIONAL DE JAÉN	1
37501	INST-EDUCATIVA	160000106	160000106 - UNIVERSIDAD NACIONAL DE CAÑETE	1
37502	INST-EDUCATIVA	160000120	160000120 - UNIVERSIDAD NACIONAL AUTÓNOMA DE CHOTA	1
37503	INST-EDUCATIVA	160000121	160000121 - UNIVERSIDAD NACIONAL DE BARRANCA	1
37504	INST-EDUCATIVA	160000122	160000122 - UNIVERSIDAD NACIONAL DE FRONTERA	1
37505	INST-EDUCATIVA	160000123	160000123 - UNIVERSIDAD NACIONAL INTERCULTURAL "FABIOLA SALAZAR LEGUÍA"	1
37506	INST-EDUCATIVA	160000124	160000124 - UNIVERSIDAD NACIONAL INTERCULTURAL DE LA SELVA CENTRAL JUAN SANTOS ATAHUALPA	1
37507	INST-EDUCATIVA	160000125	160000125 - UNIVERSIDAD NACIONAL INTERCULTURAL DE QUILLABAMBA	1
37508	INST-EDUCATIVA	160000126	160000126 - UNIVERSIDAD NACIONAL AUTÓNOMA DE ALTO AMAZONAS	1
37509	INST-EDUCATIVA	160000127	160000127 - UNIVERSIDAD NACIONAL AUTÓNOMA ALTOANDINA DE TARMA	1
37510	INST-EDUCATIVA	160000128	160000128 - UNIVERSIDAD NACIONAL AUTÓNOMA DE HUANTA	1
37511	INST-EDUCATIVA	160000129	160000129 - UNIVERSIDAD NACIONAL TECNOLÓGICA DE SAN JUAN DE LURIGANCHO	1
37512	INST-EDUCATIVA	160000130	160000130 - UNIVERSIDAD AUTÓNOMA MUNICIPAL DE LOS OLIVOS	1
37513	INST-EDUCATIVA	160000138	160000138 - UNIVERSIDAD NACIONAL AUTONOMA DE TAYACAJA DANIEL HERNANDEZ MORILLO	1
37514	INST-EDUCATIVA	160000139	160000139 - UNIVERSIDAD NACIONAL CIRO ALEGRÍA	1
37515	INST-EDUCATIVA	170209858	170209858 - ACAD. MUSICA Y DANZAS	1
37516	INST-EDUCATIVA	170240135	170240135 - PUNO	1
37517	INST-EDUCATIVA	170276352	170276352 - REG BELLAS ARTES ICA	1
37518	INST-EDUCATIVA	170285973	170285973 - LEANDRO ALVIÑA	1
37519	INST-EDUCATIVA	170326108	170326108 - BELLAS ARTES DEL PERU-LIMA	1
37520	INST-EDUCATIVA	170326124	170326124 - CONSERVATORIO NACIONAL DE MÚSICA	1
37521	INST-EDUCATIVA	170326132	170326132 - NACIONAL DE BALLET	1
37522	INST-EDUCATIVA	170394098	170394098 - CARLOS VALDERRAMA	1
37523	INST-EDUCATIVA	170394106	170394106 - VIRGILIO RODRÍGUEZ NACHE	1
37524	INST-EDUCATIVA	170419960	170419960 - ESCUELA SUPERIOR DE MUSICA CONDORCUNCA	1
37525	INST-EDUCATIVA	170419978	170419978 - FELIPE GUAMÁN POMA DE AYALA	1
37526	INST-EDUCATIVA	170673061	170673061 - DANIEL ALOMÍA ROBLES	1
37527	INST-EDUCATIVA	170679746	170679746 - SÉRVULO GUTIÉRREZ ALARCÓN DE ICA	1
37528	INST-EDUCATIVA	170685164	170685164 - VICTOR MOREY PEÑA	1
37529	INST-EDUCATIVA	170695528	170695528 - CARLOS BACA FLOR	1
37530	INST-EDUCATIVA	170695536	170695536 - LUIS DUNCKER LAVALLE	1
37531	INST-EDUCATIVA	170696005	170696005 - MARIO URTEAGA ALVARADO	1
37532	INST-EDUCATIVA	170699702	170699702 - DE FORMACION ARTISTICA-HUARAZ	1
37533	INST-EDUCATIVA	170702605	170702605 - JOSÉ MARÍA VALLE RIESTRA	1
37534	INST-EDUCATIVA	170702829	170702829 - BELLAS ARTES MACEDONIO DE LA TORRE	1
37535	INST-EDUCATIVA	170702837	170702837 - JULIACA	1
37536	INST-EDUCATIVA	170768630	170768630 - ESCUELA SUPERIOR DE FORMACION ARTISTICA-BAGUA	1
37537	INST-EDUCATIVA	170817544	170817544 - EDUARDO MEZA SARAVIA	1
37538	INST-EDUCATIVA	170886549	170886549 - FRANCISCO PÉREZ ANAMPA	1
37539	INST-EDUCATIVA	170925057	170925057 - FORMACION ARTISTICA-TARMA	1
37540	INST-EDUCATIVA	171025584	171025584 - PILCUYO	1
37541	INST-EDUCATIVA	171027564	171027564 - MOHO	1
37542	INST-EDUCATIVA	171061894	171061894 - BELLAS ARTES  “DIEGO QUISPE TITO” CALCA	1
37543	INST-EDUCATIVA	171061928	171061928 - BELLAS ARTES DQT FILIAL CANCHIS	1
37544	INST-EDUCATIVA	171062439	171062439 - BELLAS ARTES  “DIEGO QUISPE TITO” DEL CUSCO	1
37545	INST-EDUCATIVA	171114693	171114693 - JOSÉ MARÍA ARGUEDAS	1
37546	INST-EDUCATIVA	171114776	171114776 - ARTE DRAMÁTICO “GUILLERMO UGARTE CHAMORRO”	1
37547	INST-EDUCATIVA	171125723	171125723 - FRANCISCO LASO	1
37548	INST-EDUCATIVA	171130210	171130210 - ERNESTO LÓPEZ MINDREAU	1
37549	INST-EDUCATIVA	171148485	171148485 - LORENZO LUJAN DARJON	1
37550	INST-EDUCATIVA	171187368	171187368 - IGNACIO MERINO DE PIURA	1
37551	INST-EDUCATIVA	171345198	171345198 - ESCUELA NACIONAL SUPERIOR AUTONOMA DE BELLAS ARTES DEL PERU-CHACHAPOYAS	1
37552	INST-EDUCATIVA	171637859	171637859 - CHABUCA GRANDA	1
37553	INST-EDUCATIVA	181000001	181000001 - ESCUELA MILITAR DEL PERÚ "CORONEL FRANCISCO BOLOGNESI"	1
37554	INST-EDUCATIVA	181000002	181000002 - ESCUELA NAVAL DEL PERÚ	1
37555	INST-EDUCATIVA	181000003	181000003 - ESCUELA DE OFICIALES DE LA FUERZA AÉREA DEL PERÚ. CAPITAN FAP "JOSÉ QUIÑONES GONZALES"	1
37556	INST-EDUCATIVA	181000004	181000004 - ESCUELA DE OFICIALES DE LA POLICÍA NACIONAL DEL PERÚ	1
37557	INST-EDUCATIVA	182000001	182000001 - INSTITUTO DE EDUCACIÓN SUPERIOR TECNOLOGICO NAVAL CITEN	1
37558	INST-EDUCATIVA	182000002	182000002 - INSTITUTO SUPERIOR TECNOLÓGICO PÚBLICO DEL EJERCITO	1
37559	INST-EDUCATIVA	182000003	182000003 - INSTITUTO DE EDUCACIÓN SUPERIOR TECNOLÓGICO AERONÁUTICO FUERZA AÉREA DEL PERÚ	1
37560	INST-EDUCATIVA	182000004	182000004 - ESCUELA TECNICA SUPERIOR DE LA POLICIA NACIONAL DEL PERÚ	1
37561	INST-EDUCATIVA	199999999	199999999 - INSTITUCIÓN NO ESPECIFICADA	1
37562	INST-EDUCATIVA	240332510	240332510 - LIMA	1
37563	INST-EDUCATIVA	240356931	240356931 - SAN JUAN-SULLANA	1
37565	INST-EDUCATIVA	240393702	240393702 - CHAN CHAN	1
37566	INST-EDUCATIVA	240413518	240413518 - SAN JOSE MARELLO	1
37567	INST-EDUCATIVA	240416123	240416123 - HIPOLITO UNANUE-HUARAZ	1
37568	INST-EDUCATIVA	240454033	240454033 - PERU FRANCIA (PERU)	1
37569	INST-EDUCATIVA	240466425	240466425 - DANIEL ALCIDES CARRION-LIMA	1
37570	INST-EDUCATIVA	240493791	240493791 - JORGE CHAVEZ	1
37571	INST-EDUCATIVA	240570234	240570234 - AMERICA	1
37572	INST-EDUCATIVA	240605147	240605147 - AMAUTA SEDE LIMA	1
37573	INST-EDUCATIVA	240605188	240605188 - CAYETANO HEREDIA DE LIMA	1
37574	INST-EDUCATIVA	240605238	240605238 - NUESTRA SEÑORA DEL CARMEN-LIMA	1
37575	INST-EDUCATIVA	240605253	240605253 - TECNOLOGICO DE LIMA - INSTTEL	1
37576	INST-EDUCATIVA	240607325	240607325 - FEDERICO VILLARREAL-LIMA	1
37577	INST-EDUCATIVA	240607341	240607341 - SAN MARCOS-LIMA	1
37578	INST-EDUCATIVA	240608232	240608232 - SAN AGUSTIN-ICA	1
37579	INST-EDUCATIVA	240669291	240669291 - SANTO TORIBIO DE MOGROVEJO	1
37580	INST-EDUCATIVA	240669309	240669309 - REPUBLICA ARGENTINA	1
37581	INST-EDUCATIVA	240669317	240669317 - ABACO - CHICLAYO	1
37582	INST-EDUCATIVA	240695445	240695445 - CAYETANO HEREDIA - AREQUIPA	1
37583	INST-EDUCATIVA	240695460	240695460 - CIENCIAS TECNOLOGICAS DE AREQUIPA	1
37584	INST-EDUCATIVA	240695486	240695486 - CESCA AREQUIPA	1
37585	INST-EDUCATIVA	240695502	240695502 - UNITEK-AREQUIPA 	1
37586	INST-EDUCATIVA	240695510	240695510 - IPSIDATA	1
37587	INST-EDUCATIVA	240697961	240697961 - UNITEK-ILO	1
37588	INST-EDUCATIVA	240699595	240699595 - SANTO CRISTO DE BAGAZAN	1
37589	INST-EDUCATIVA	240702365	240702365 - INSTITUTO PERUANO DE ADMINISTRACION DE EMPRESAS - IPAE-LIMA	1
37590	INST-EDUCATIVA	240702373	240702373 - PERUANO ALEMAN	1
37591	INST-EDUCATIVA	240702407	240702407 - SAN IGNACIO DE LOYOLA-LIMA	1
37592	INST-EDUCATIVA	240702423	240702423 - METROPOLITANO	1
37593	INST-EDUCATIVA	240702456	240702456 - DEL NORTE S.A.C.	1
37594	INST-EDUCATIVA	240702464	240702464 - SAN LUIS-TRUJILLO	1
37595	INST-EDUCATIVA	240702472	240702472 - LOS LIBERTADORES	1
37596	INST-EDUCATIVA	240702571	240702571 - INSTITUTO TECNICO DE ADMINISTRACION DE EMPRESAS-ITAE	1
37597	INST-EDUCATIVA	240702654	240702654 - TUSAN	1
37598	INST-EDUCATIVA	240702688	240702688 - CEVATUR PERU	1
37599	INST-EDUCATIVA	240702696	240702696 - CEPEA-LIMA	1
37600	INST-EDUCATIVA	240702704	240702704 - IDAT-LIMA	1
37601	INST-EDUCATIVA	240702761	240702761 - FREDERICK WINSLOW TAYLOR	1
37602	INST-EDUCATIVA	240702803	240702803 - ASESORIA DE EMPRESAS COMERCIALES ADEC	1
37603	INST-EDUCATIVA	240702811	240702811 - CHICLAYO	1
37604	INST-EDUCATIVA	240702894	240702894 - CAYETANO HEREDIA -CHICLAYO	1
37605	INST-EDUCATIVA	240709550	240709550 - MANUEL MESONES MURO - MASTER SYSTEM	1
37606	INST-EDUCATIVA	240724518	240724518 - CIMA	1
37607	INST-EDUCATIVA	240736264	240736264 - SAN PEDRO-HUANCAYO	1
37608	INST-EDUCATIVA	240736272	240736272 - CONTINENTAL	1
37609	INST-EDUCATIVA	240737544	240737544 - OTTO TONSMANN	1
37610	INST-EDUCATIVA	240745679	240745679 - MARIA MONTESSORI	1
37611	INST-EDUCATIVA	240745687	240745687 - LA RECOLETA	1
37612	INST-EDUCATIVA	240758276	240758276 - EUGENIO PACCELLY	1
37613	INST-EDUCATIVA	240780502	240780502 - BENJAMIN FRANKLIN	1
37614	INST-EDUCATIVA	240785907	240785907 - SAN PABLO	1
37615	INST-EDUCATIVA	240794602	240794602 - JAVIER PRADO	1
37616	INST-EDUCATIVA	240814285	240814285 - HUANDO	1
37617	INST-EDUCATIVA	240814657	240814657 - CEVATUR ICA	1
37618	INST-EDUCATIVA	240814699	240814699 - HUANCAYO	1
37619	INST-EDUCATIVA	240815001	240815001 - DEL SUR	1
37620	INST-EDUCATIVA	240815043	240815043 - SAN JOSE ORIOL 	1
37621	INST-EDUCATIVA	240815142	240815142 - ANTONIO LORENA	1
37622	INST-EDUCATIVA	240815159	240815159 - CATOLICA DE CUSCO	1
37623	INST-EDUCATIVA	240815175	240815175 - KHIPU	1
37624	INST-EDUCATIVA	240815183	240815183 - LUIS PASTEUR-CUSCO	1
37625	INST-EDUCATIVA	240815191	240815191 - ANTONIO RAYMONDI - CUSCO	1
37626	INST-EDUCATIVA	240817577	240817577 - TOKIO-CORONEL PORTILLO	1
37627	INST-EDUCATIVA	240846709	240846709 - JUANJUI	1
37628	INST-EDUCATIVA	240847277	240847277 - VIRGEN DE LAS NIEVES	1
37629	INST-EDUCATIVA	240886523	240886523 - JHALEBET	1
37630	INST-EDUCATIVA	240886580	240886580 - ESTUDIOS SUPERIORES DEL SUR	1
37631	INST-EDUCATIVA	240886986	240886986 - UNITEK-ICA 	1
37632	INST-EDUCATIVA	240891440	240891440 - ESADE COMPUTER CENTER MIGUEL GRAU	1
37633	INST-EDUCATIVA	240891531	240891531 - ELMER FAUCETT-AREQUIPA	1
37634	INST-EDUCATIVA	240891598	240891598 - ABACO - AREQUIPA	1
37635	INST-EDUCATIVA	240891622	240891622 - HIPOLITO UNANUE-AREQUIPA	1
37636	INST-EDUCATIVA	240891689	240891689 - TECSUP NO.2-AREQUIPA	1
37637	INST-EDUCATIVA	240891895	240891895 - SAN FELIPE	1
37638	INST-EDUCATIVA	240892257	240892257 - AGRARIO DEL SUR	1
37639	INST-EDUCATIVA	240892281	240892281 - IBEROAMERICANO	1
37640	INST-EDUCATIVA	240892315	240892315 - FLAVISUR	1
37641	INST-EDUCATIVA	240898189	240898189 - SANTIAGO RAMON Y CAJAL	1
37642	INST-EDUCATIVA	240898213	240898213 - ALBERT EINSTEIN	1
37643	INST-EDUCATIVA	240898452	240898452 - CIMAC DEL SUR	1
37644	INST-EDUCATIVA	240909697	240909697 - GRAN CHAVIN	1
37645	INST-EDUCATIVA	240911768	240911768 - LUIS LUMIERE	1
37646	INST-EDUCATIVA	240914325	240914325 - UCAYALI	1
37647	INST-EDUCATIVA	240914358	240914358 - ANTONIO RAIMONDI - CORONEL PORTILLO	1
37648	INST-EDUCATIVA	240914382	240914382 - RICARDO PALMA	1
37649	INST-EDUCATIVA	240914473	240914473 - TEC-CENTRO DE CAPACITACION TECNICA	1
44598	OCUPACION	961002	BARRENDERO	1
37650	INST-EDUCATIVA	240920512	240920512 - TECNOFUTURO 	1
37651	INST-EDUCATIVA	240920579	240920579 - FRANKLIN ROOSEVELT-HUANCAYO	1
37652	INST-EDUCATIVA	240920637	240920637 - INTERNATIONAL SYSTEM	1
37653	INST-EDUCATIVA	240920694	240920694 - MI PERU	1
37654	INST-EDUCATIVA	240920751	240920751 - SAN FRANCISCO DE ASIS-HUANCAYO	1
37655	INST-EDUCATIVA	240920785	240920785 - TECNICOS EN COSMETOLOGIA SISTEMA Y BELLEZA - TECSYB	1
37656	INST-EDUCATIVA	240921767	240921767 - CHRISTIAN BARNARD-CONCEPCION	1
37657	INST-EDUCATIVA	240921866	240921866 - CEVATUR-HUANCAYO	1
37658	INST-EDUCATIVA	240925065	240925065 - SANTA LUCIA-TARMA	1
37659	INST-EDUCATIVA	240928689	240928689 - REAL SAN FELIPE 	1
37660	INST-EDUCATIVA	240928903	240928903 - SAN AGUSTIN-ABANCAY	1
37661	INST-EDUCATIVA	240931543	240931543 - CANCHIS	1
37662	INST-EDUCATIVA	240933994	240933994 - URUSAYHUA	1
37663	INST-EDUCATIVA	240934182	240934182 - AMERICANA DEL CUSCO	1
37664	INST-EDUCATIVA	241000736	241000736 - SAN PEDRO -CHIMBOTE	1
37665	INST-EDUCATIVA	241000777	241000777 - DEL SANTA	1
37666	INST-EDUCATIVA	241000785	241000785 - LATINOAMERICANO-SANTA	1
37667	INST-EDUCATIVA	241000819	241000819 - ROSA MERINO CENTER	1
37668	INST-EDUCATIVA	241000850	241000850 - SANTA ROSA DE LIMA-CHIMBOTE	1
37669	INST-EDUCATIVA	241003763	241003763 - BITEC	1
37670	INST-EDUCATIVA	241024470	241024470 - UNITEK-PUNO	1
37671	INST-EDUCATIVA	241024512	241024512 - AMAUTA SEDE PUNO	1
37672	INST-EDUCATIVA	241024553	241024553 - DEL ALTIPLANO	1
37673	INST-EDUCATIVA	241026533	241026533 - AUGUSTO SALAZAR BONDY	1
37674	INST-EDUCATIVA	241026541	241026541 - NAZARET	1
37675	INST-EDUCATIVA	241026822	241026822 - UNITEK-JULIACA	1
37676	INST-EDUCATIVA	241027549	241027549 - ADVENTISTAS DEL TITICACA	1
37677	INST-EDUCATIVA	241027622	241027622 - CIPRODA	1
37678	INST-EDUCATIVA	241031236	241031236 - THOMAS JEFFERSON	1
37679	INST-EDUCATIVA	241060979	241060979 - GALENO	1
37680	INST-EDUCATIVA	241061407	241061407 - DIDASCALIO CRISTO REY	1
37681	INST-EDUCATIVA	241062371	241062371 - CASA TALLER MEDIO AMBIENTE Y DESARROLLO	1
37682	INST-EDUCATIVA	241062496	241062496 - IGATUR	1
37683	INST-EDUCATIVA	241064443	241064443 - ADA A. BYRON	1
37684	INST-EDUCATIVA	241064450	241064450 - PERU	1
37685	INST-EDUCATIVA	241064476	241064476 - DIVINA MISERICORDIA	1
37686	INST-EDUCATIVA	241064922	241064922 - ESCUELA SUPERIOR PARTICULAR DE ADMINISTRACION RURAL - LUIS FELIPE MASSARO GATNAU	1
37687	INST-EDUCATIVA	241065770	241065770 - MARIA DE LOS ANGELES CIMAS	1
37688	INST-EDUCATIVA	241065895	241065895 - JOSE FELIX IGUAIN	1
37689	INST-EDUCATIVA	241065937	241065937 - COMPUTRONIC TECH-LIMA	1
37690	INST-EDUCATIVA	241066018	241066018 - ARZOBISPO LOAYZA	1
37691	INST-EDUCATIVA	241066091	241066091 - NICOLAS COPERNICO 	1
37692	INST-EDUCATIVA	241066257	241066257 - FRANKLIN ROOSEVELT-LIMA	1
37693	INST-EDUCATIVA	241066570	241066570 - PAUL MULLER	1
37694	INST-EDUCATIVA	241066695	241066695 - HUGO PESCE PESCETTO	1
37695	INST-EDUCATIVA	241066737	241066737 - ALEXANDER FLEMING	1
37696	INST-EDUCATIVA	241066778	241066778 - DE LA CONSTRUCCION - CAPECO	1
37697	INST-EDUCATIVA	241066935	241066935 - INTERNACIONAL	1
37698	INST-EDUCATIVA	241067099	241067099 - LATINO-LIMA	1
37699	INST-EDUCATIVA	241100031	241100031 - SAN SANTIAGO 	1
37700	INST-EDUCATIVA	241101674	241101674 - DON BOSCO	1
37701	INST-EDUCATIVA	241101880	241101880 - INFOTRONIC	1
37702	INST-EDUCATIVA	241111921	241111921 - ISABEL LA CATOLICA-HUANUCO	1
37703	INST-EDUCATIVA	241111962	241111962 - SEÑOR DE BURGOS	1
37704	INST-EDUCATIVA	241113687	241113687 - SALESIANO	1
37705	INST-EDUCATIVA	241113695	241113695 - WERNHER VON BRAUN	1
37706	INST-EDUCATIVA	241113778	241113778 - COLUMBIA	1
37707	INST-EDUCATIVA	241113851	241113851 - NINA DESIGN	1
37708	INST-EDUCATIVA	241113927	241113927 - PROTESIS DENTAL	1
37709	INST-EDUCATIVA	241114123	241114123 - ESEFUL  	1
37710	INST-EDUCATIVA	241114206	241114206 - DE LA CLINICA RICARDO PALMA-LIMA	1
37711	INST-EDUCATIVA	241114214	241114214 - CORAZON DE JESUS	1
37712	INST-EDUCATIVA	241114339	241114339 - NORBERT WIENER	1
37713	INST-EDUCATIVA	241114370	241114370 - ALESSANDRO VOLTA	1
37714	INST-EDUCATIVA	241114487	241114487 - CENTRO DE INVESTIGACION Y CAPACITACION TECNOLOGICA-CICAT 	1
37715	INST-EDUCATIVA	241114495	241114495 - SEMINARIO BIBLICO ANDINO	1
37716	INST-EDUCATIVA	241114529	241114529 - ROCHDALE	1
37717	INST-EDUCATIVA	241114560	241114560 - EL BUEN PASTOR	1
37718	INST-EDUCATIVA	241114651	241114651 - ARTE, NEGOCIO Y TECNOLOGIA-ESANTEC	1
37719	INST-EDUCATIVA	241114685	241114685 - LA CATOLICA LIMA NORTE	1
37720	INST-EDUCATIVA	241114743	241114743 - SAN JAVIER DEL MARAÑON	1
37721	INST-EDUCATIVA	241114768	241114768 - PERUANO DE SISTEMAS SISE	1
37722	INST-EDUCATIVA	241114818	241114818 - TECCEN 	1
37723	INST-EDUCATIVA	241114842	241114842 - TOULOUSE LAUTREC	1
37724	INST-EDUCATIVA	241114974	241114974 - COMPUTRON -LIMA	1
37725	INST-EDUCATIVA	241115096	241115096 - TECSUP NO.1-LIMA	1
37726	INST-EDUCATIVA	241115179	241115179 - DE LOS ANDES-LIMA	1
37727	INST-EDUCATIVA	241115203	241115203 - HUMBERTO CAUWE	1
37728	INST-EDUCATIVA	241115286	241115286 - DE TECNICAS AGROPECUARIAS-INTAP	1
37729	INST-EDUCATIVA	241115336	241115336 - SEMINARIO EVANGELICO DE LIMA	1
37730	INST-EDUCATIVA	241115419	241115419 - CHARLES CHAPLIN	1
37731	INST-EDUCATIVA	241115492	241115492 - MONTESSORI	1
37732	INST-EDUCATIVA	241115567	241115567 - SERGIO BERNALES-LIMA	1
37733	INST-EDUCATIVA	241115575	241115575 - YACHAY WASI	1
37734	INST-EDUCATIVA	241115609	241115609 - CESCA-LIMA	1
37735	INST-EDUCATIVA	241115658	241115658 - MEGATRONIC 	1
37736	INST-EDUCATIVA	241115682	241115682 - INSTITUTO CIENTIFICO TECNOLOGICO DEL PERU - INCITEP	1
37737	INST-EDUCATIVA	241115690	241115690 - ABACO-LIMA	1
37738	INST-EDUCATIVA	241115807	241115807 - OPTICA Y OPTOMETRIA	1
37739	INST-EDUCATIVA	241115849	241115849 - ORSON WELLES	1
37740	INST-EDUCATIVA	241115856	241115856 - PERUANO DE MARKETING	1
37741	INST-EDUCATIVA	241115880	241115880 - INSTITUTO PERUANO DE PUBLICIDAD	1
37742	INST-EDUCATIVA	241115922	241115922 - SISTEMAS PERU	1
37743	INST-EDUCATIVA	241115963	241115963 - SAN AGUSTIN-LIMA	1
37744	INST-EDUCATIVA	241117431	241117431 - PERUANO CANADIENSE	1
37745	INST-EDUCATIVA	241117548	241117548 - SISTEMAS Y ADMINISTRACION MODERNA - ESSAM 	1
37746	INST-EDUCATIVA	241117670	241117670 - DATA SYSTEMS INGENIEROS	1
37747	INST-EDUCATIVA	241119577	241119577 - FELIX DE LA ROSA REATEGUI Y GAVIRIA	1
37748	INST-EDUCATIVA	241122951	241122951 - SABIO NACIONAL ANTUNEZ DE MAYOLO-TELESUP	1
37749	INST-EDUCATIVA	241123033	241123033 - ELMER FAUCETT-LIMA	1
37750	INST-EDUCATIVA	241123041	241123041 - ESCUELA SUPERIOR PRIVADA DE TECNOLOGIA SENATI	1
37751	INST-EDUCATIVA	241123116	241123116 - EUROIDIOMAS	1
37752	INST-EDUCATIVA	241123157	241123157 - PERUANO DE ARTE Y DISEÑO	1
37753	INST-EDUCATIVA	241123314	241123314 - CIBERTEC	1
37754	INST-EDUCATIVA	241123405	241123405 - DE FORMACION BANCARIA IFB	1
37755	INST-EDUCATIVA	241123439	241123439 - INTERPRETACION Y TRADUCCION DE LIMA	1
37756	INST-EDUCATIVA	241123447	241123447 - CENTRO DE ALTOS ESTUDIOS DE LA MODA - CEAM 	1
37757	INST-EDUCATIVA	241123470	241123470 - ORVAL	1
37758	INST-EDUCATIVA	241123512	241123512 - SENCICO-LIMA	1
37759	INST-EDUCATIVA	241123561	241123561 - DE OPTOMETRIA Y CIENCIAS EUROHISPANO	1
37760	INST-EDUCATIVA	241123603	241123603 - ALEXANDER GRAHAM BELL	1
37761	INST-EDUCATIVA	241123637	241123637 - SAN IGNACIO DE MONTERRICO-SIDEM	1
37762	INST-EDUCATIVA	241123686	241123686 - ELA	1
37763	INST-EDUCATIVA	241123710	241123710 - BETA COMPUTER	1
37764	INST-EDUCATIVA	241123751	241123751 - TRILCE	1
37765	INST-EDUCATIVA	241123769	241123769 - LINCOLN	1
37766	INST-EDUCATIVA	241123793	241123793 - ALEXANDER VON HUMBOLDT 	1
37767	INST-EDUCATIVA	241123843	241123843 - SANTA ROSA DE LIMA-LIMA	1
37768	INST-EDUCATIVA	241123918	241123918 - DE COMERCIO EXTERIOR	1
37769	INST-EDUCATIVA	241123926	241123926 - MARIA ELENA MOYANO	1
37770	INST-EDUCATIVA	241124114	241124114 - DE MARKETING DEL PERU	1
37771	INST-EDUCATIVA	241124163	241124163 - IDATUR	1
37772	INST-EDUCATIVA	241124205	241124205 - MASTER BYTE	1
37773	INST-EDUCATIVA	241124296	241124296 - HIPOLITO UNANUE-SAN MARTIN	1
37774	INST-EDUCATIVA	241124312	241124312 - SERGIO BERNALES GARCIA-CAÑETE	1
37775	INST-EDUCATIVA	241124338	241124338 - CIRO ALEGRIA	1
37776	INST-EDUCATIVA	241124353	241124353 - CONDORAY	1
37777	INST-EDUCATIVA	241124361	241124361 - PERU PACIFICO	1
37778	INST-EDUCATIVA	241124379	241124379 - BLAISE PASCAL	1
37779	INST-EDUCATIVA	241124403	241124403 - SELENE 	1
37780	INST-EDUCATIVA	241124411	241124411 - MARIA PARADO DE BELLIDO-SAN MARTIN	1
37781	INST-EDUCATIVA	241124437	241124437 - VALLE GRANDE	1
37782	INST-EDUCATIVA	241124486	241124486 - DE DISEÑO PUBLICITARIO LEO DESIGN	1
37783	INST-EDUCATIVA	241124510	241124510 - SANTA ROSA DE LIMA-HUAURA	1
37784	INST-EDUCATIVA	241124528	241124528 - ABC INFORMATICA	1
37785	INST-EDUCATIVA	241124569	241124569 - LATINO-SAN JUAN	1
37786	INST-EDUCATIVA	241124593	241124593 - JOSE SANTOS CHOCANO	1
37787	INST-EDUCATIVA	241124627	241124627 - BORJE LANGEFORDS	1
37788	INST-EDUCATIVA	241124643	241124643 - UNICENTER- UNIVERSAL INFORMATIC CENTER	1
37789	INST-EDUCATIVA	241124684	241124684 - ANDRE VESALIO	1
37790	INST-EDUCATIVA	241124767	241124767 - ART NOUVEAU	1
37791	INST-EDUCATIVA	241124791	241124791 - SERGIO BERNALES GARCIA-HUARAL	1
37792	INST-EDUCATIVA	241125848	241125848 - FRANCISCO ANTONIO DE ZELA	1
37793	INST-EDUCATIVA	241125889	241125889 - GUILLERMO ALMENARA MARTINS	1
37794	INST-EDUCATIVA	241126002	241126002 - JOHN VON NEUMANN	1
37795	INST-EDUCATIVA	241126135	241126135 - LORD BYRON	1
37796	INST-EDUCATIVA	241126549	241126549 - MARISCAL DOMINGO NIETO	1
37797	INST-EDUCATIVA	241126606	241126606 - DETECSUR 	1
37798	INST-EDUCATIVA	241127240	241127240 - INSTITUTO SUPERIOR DE ADMINISTRACION Y DIRECCION DE EMPRESAS - ISADE	1
37799	INST-EDUCATIVA	241127281	241127281 - SAN LUIS MARIA DE MONTFORT	1
37800	INST-EDUCATIVA	241127364	241127364 - SISTEMAS DEL SUR	1
37801	INST-EDUCATIVA	241135334	241135334 - MARIANO IBERICO RODRIGUEZ	1
37802	INST-EDUCATIVA	241135342	241135342 - SERGIO BERNALES-CAJAMARCA	1
37803	INST-EDUCATIVA	241140185	241140185 - LA PONTIFICIA-HUAMANGA	1
37804	INST-EDUCATIVA	241140227	241140227 - CESDE (CENTRO DE ENSEÑANZA SUPERIOR PARA EL DESARROLLO)	1
37805	INST-EDUCATIVA	241140268	241140268 - MARIA PARADO DE BELLIDO-HUAMANGA	1
37806	INST-EDUCATIVA	241141241	241141241 - PARACAS SISTEMS 	1
37807	INST-EDUCATIVA	241141282	241141282 - FERMIN TANGUIS	1
37808	INST-EDUCATIVA	241143023	241143023 - MODERN SYSTEMS	1
37809	INST-EDUCATIVA	241147180	241147180 - EMILIO ROMERO PADILLA	1
37810	INST-EDUCATIVA	241147222	241147222 - REYNA DE LAS AMERICAS	1
37811	INST-EDUCATIVA	241153550	241153550 - CEPEA-ALTO AMAZONAS	1
37812	INST-EDUCATIVA	241153931	241153931 - SAN FRANCISCO	1
37813	INST-EDUCATIVA	241156884	241156884 - STANFORD	1
37814	INST-EDUCATIVA	241157437	241157437 - SAN JUAN BOSCO	1
37815	INST-EDUCATIVA	241158534	241158534 - TUMAN	1
37816	INST-EDUCATIVA	241158807	241158807 - DE ALTA DIRECCION DE EMPRESAS HISPANO-AMERICANA	1
37817	INST-EDUCATIVA	241159680	241159680 - IDAT CHICLAYO	1
37818	INST-EDUCATIVA	241160134	241160134 - ANDRES AVELINO CACERES DORREGARAY - PASCO	1
37819	INST-EDUCATIVA	241162726	241162726 - JOSAFAT ROEL PINEDA	1
37820	INST-EDUCATIVA	241162841	241162841 - CRISTO REY	1
37821	INST-EDUCATIVA	241174929	241174929 - ABACO - TRUJILLO	1
37822	INST-EDUCATIVA	241174960	241174960 - LOUIS PASTEUR-TRUJILLO	1
37823	INST-EDUCATIVA	241175009	241175009 - CEVATUR TRUJILLO	1
37824	INST-EDUCATIVA	241175082	241175082 - DE CIENCIAS-INTEC (HIPOLITO UNANUE)	1
37825	INST-EDUCATIVA	241175124	241175124 - INSTITUTO DE ADMINISTRACION Y CONTABILIDAD IDAC	1
37826	INST-EDUCATIVA	241175207	241175207 - LIBERTAD-TRUJILLO	1
37827	INST-EDUCATIVA	241179191	241179191 - NUESTRA SEÑORA DEL CARMEN-TALARA	1
37828	INST-EDUCATIVA	241180520	241180520 - SANTA URSULA	1
37829	INST-EDUCATIVA	241180884	241180884 - JOSE CARLOS MARIATEGUI-TALARA	1
37830	INST-EDUCATIVA	241182625	241182625 - FLORENCE NIGHTINGALE	1
37831	INST-EDUCATIVA	241182666	241182666 - JESUS DIVINO	1
37832	INST-EDUCATIVA	241182823	241182823 - CIBERNET-CHICLAYO	1
37833	INST-EDUCATIVA	241183243	241183243 - JUAN MEJIA BACA 	1
37834	INST-EDUCATIVA	241183284	241183284 - ENRIQUE HANZ BRUNNING	1
37835	INST-EDUCATIVA	241183326	241183326 - LA CATOLICA-CHICLAYO	1
37836	INST-EDUCATIVA	241183391	241183391 - CEVATUR-CHICLAYO ( ALTOS ESTUDIOS TURISTICOS)	1
37837	INST-EDUCATIVA	241183409	241183409 - MAYSA	1
37838	INST-EDUCATIVA	241183433	241183433 - SANTA MARIA MAZZARELLO	1
37839	INST-EDUCATIVA	241183714	241183714 - AMERICAN INSTITUTE	1
37840	INST-EDUCATIVA	241185503	241185503 - SAN MARTIN DE PORRAS	1
37841	INST-EDUCATIVA	241185669	241185669 - SANTA ANGELA	1
37842	INST-EDUCATIVA	241185701	241185701 - IDAT - PIURA 	1
37843	INST-EDUCATIVA	241185743	241185743 - ATENEO DEMOSTENES	1
37844	INST-EDUCATIVA	241185784	241185784 - CHARLES ASHBEE	1
37845	INST-EDUCATIVA	241185826	241185826 - TALLAN	1
37846	INST-EDUCATIVA	241185867	241185867 - SAN ISIDRO DE PIURA	1
37847	INST-EDUCATIVA	241185909	241185909 - ABACO - PIURA	1
37848	INST-EDUCATIVA	241185941	241185941 - SOL DEL NORTE	1
37849	INST-EDUCATIVA	241185982	241185982 - ISA INTEGRAL 	1
37850	INST-EDUCATIVA	241186022	241186022 - SANTA MARIA DE LOS ANGELES - CIMAS	1
37851	INST-EDUCATIVA	241186147	241186147 - ALAS PERUANAS - PIURA 	1
37852	INST-EDUCATIVA	241186188	241186188 - PACIFICO NORTE	1
37853	INST-EDUCATIVA	241191030	241191030 - DEL ORIENTE	1
37854	INST-EDUCATIVA	241193093	241193093 - ESCUELA DE NEGOCIOS Y DESARROLLO GERENCIAL	1
37855	INST-EDUCATIVA	241195676	241195676 - CHRISTIAN BARNARD-CALLAO	1
37856	INST-EDUCATIVA	241200856	241200856 - ABACO - CUSCO	1
37857	INST-EDUCATIVA	241200864	241200864 - SENCICO CUSCO	1
37858	INST-EDUCATIVA	241203132	241203132 - CENTRO DE ESTUDIOS DE ALTA MONTAÑA	1
37859	INST-EDUCATIVA	241203553	241203553 - CEVATUR- AREQUIPA	1
37860	INST-EDUCATIVA	241203884	241203884 - SALUD Y BELLEZA	1
37861	INST-EDUCATIVA	241204759	241204759 - LA PONTIFICIA-ANDAHUAYLAS	1
37862	INST-EDUCATIVA	241204866	241204866 - TOKIO TARAPOTO	1
37863	INST-EDUCATIVA	241206523	241206523 - DE ADMINISTRACION GERENCIAL ISAG-PIURA	1
37864	INST-EDUCATIVA	241206754	241206754 - DEL NOR OESTE	1
37865	INST-EDUCATIVA	241208685	241208685 - SIGMUND FREUD	1
37866	INST-EDUCATIVA	241210640	241210640 - INFORMÁTICA, COMPUTACIÓN Y CIENCIAS EMPRESARIALES - ICCE	1
37867	INST-EDUCATIVA	241210699	241210699 - NUEVA TECNOLOGIA EDUCATIVA-NOVATEC	1
37868	INST-EDUCATIVA	241212067	241212067 - SAN EDUARDO	1
37869	INST-EDUCATIVA	241213172	241213172 - DE FORMACION EMPRESARIAL EN COMPUTACION E INFORMATICA - ITEC	1
37870	INST-EDUCATIVA	241213255	241213255 - EDUTEC	1
37871	INST-EDUCATIVA	241215540	241215540 - UNITEK-TACNA 	1
37872	INST-EDUCATIVA	241221035	241221035 - JUAN BOSCO DE HUANUCO	1
1932	PAIS	084	BELICE	1
37873	INST-EDUCATIVA	241221969	241221969 - TORIBIO RODRIGUEZ DE MENDOZA	1
37874	INST-EDUCATIVA	241222041	241222041 - COMPUTER G & L	1
37875	INST-EDUCATIVA	241223882	241223882 - EDUCACION Y SOLIDARIDAD	1
37876	INST-EDUCATIVA	241224807	241224807 - DE ADMINISTRACION GERENCIAL - ISAG-CHICLAYO	1
37877	INST-EDUCATIVA	241225135	241225135 - HUANUCO	1
37878	INST-EDUCATIVA	241225168	241225168 - SENCICO CHICLAYO	1
37879	INST-EDUCATIVA	241231877	241231877 - CELACIT-LATINOAMERICANO DE CIENCIAS Y TECNOLOGIA	1
37880	INST-EDUCATIVA	241231893	241231893 - JACQUELINE	1
37881	INST-EDUCATIVA	241232131	241232131 - INGENIERO CARLOS LISSON BEINGOLEA	1
37882	INST-EDUCATIVA	241232214	241232214 - MADRE JOSEFINA VANNINI	1
37883	INST-EDUCATIVA	241232735	241232735 - COMPLEJO HOSPITALARIO SAN PABLO	1
37884	INST-EDUCATIVA	241232776	241232776 - TECNIMEDIA 	1
37885	INST-EDUCATIVA	241232974	241232974 - SANTA ROSA-LIMA	1
37886	INST-EDUCATIVA	241233030	241233030 - ADUANEC	1
37887	INST-EDUCATIVA	241233170	241233170 - ROBERT OWEN	1
37888	INST-EDUCATIVA	241233253	241233253 - LE CORDON BLEU PERU	1
37889	INST-EDUCATIVA	241236769	241236769 - ISABEL LA CATOLICA-PIURA	1
37890	INST-EDUCATIVA	241236801	241236801 - SENCICO PIURA	1
37891	INST-EDUCATIVA	241236843	241236843 - CARLOS AUGUSTO SALAVERRY RAMIREZ	1
37892	INST-EDUCATIVA	241236884	241236884 - INTERNATIONAL AMERICAN COLLEGE I.A.C. 	1
37893	INST-EDUCATIVA	241236926	241236926 - ILP LA PONTIFICIA	1
37894	INST-EDUCATIVA	241238922	241238922 - SENCICO AREQUIPA	1
37895	INST-EDUCATIVA	241238963	241238963 - TEKNO'S 	1
37896	INST-EDUCATIVA	241239003	241239003 - ALAS PERUANAS -AREQUIPA	1
37897	INST-EDUCATIVA	241239466	241239466 - CHAMINADE MARIANISTAS	1
37898	INST-EDUCATIVA	241239508	241239508 - SAN PEDRO DEL MAR	1
37899	INST-EDUCATIVA	241244458	241244458 - LATINOAMERICANO-TRUJILLO	1
37900	INST-EDUCATIVA	241248756	241248756 - INSTITUTO DE DESARROLLO EMPRESARIAL Y ADMINISTRATIVO-IDEA	1
37901	INST-EDUCATIVA	241248830	241248830 - JOHN A. MACKAY	1
37902	INST-EDUCATIVA	241248954	241248954 - NUESTRA SEÑORA DE MONTSERRAT	1
37903	INST-EDUCATIVA	241249234	241249234 - INSTITUTO DE INVESTIGACION SOCIOECONOMICO LATINOAMERICANO - ISEL	1
37904	INST-EDUCATIVA	241249275	241249275 - TECNOTRONIC	1
37905	INST-EDUCATIVA	241249358	241249358 - AMERICAN SYSTEM	1
37906	INST-EDUCATIVA	241249390	241249390 - PABLO CASALS	1
37907	INST-EDUCATIVA	241249473	241249473 - JOSE CRISAM	1
37908	INST-EDUCATIVA	241249598	241249598 - CENTRO DE PROMOCIÓN RURAL E INTEGRAL-CEPRORUI	1
37909	INST-EDUCATIVA	241249739	241249739 - SANTA LUZMILA	1
37910	INST-EDUCATIVA	241249952	241249952 - WATERFORD	1
37911	INST-EDUCATIVA	241250091	241250091 - VICTOR ANDRES BELAUNDE-LIMA	1
37912	INST-EDUCATIVA	241250133	241250133 - VIRGEN DE GUADALUPE-LIMA	1
37913	INST-EDUCATIVA	241250257	241250257 - LIBERTADOR	1
37914	INST-EDUCATIVA	241250281	241250281 - JOHN DEWEY 	1
37915	INST-EDUCATIVA	241272038	241272038 - DE AVANCE TECNOLÓGICO Y CIENTÍFICO-ISATEC	1
37916	INST-EDUCATIVA	241302629	241302629 - CENTRO DE INSTRUCCION DE AVIACION CIVIL CORPAC	1
37917	INST-EDUCATIVA	241305556	241305556 - CIBERNET UTCUBAMBA	1
37918	INST-EDUCATIVA	241313485	241313485 - AMBROSSIA - CUSCO	1
37919	INST-EDUCATIVA	241313667	241313667 - SEÑOR DE PUMALLUCAY	1
37920	INST-EDUCATIVA	241314137	241314137 - SELVA SYSTEM	1
37921	INST-EDUCATIVA	241314400	241314400 - INSTITUTO PERUANO DE ADMINISTRACION DE EMPRESAS IPAE-ICA	1
37922	INST-EDUCATIVA	241315647	241315647 - CENFOMIN - CENTRO DE FORMACION EN MINERIA	1
37923	INST-EDUCATIVA	241316637	241316637 - NUEVO PACHACUTEC	1
37924	INST-EDUCATIVA	241317619	241317619 - INSTITUTO PERUANO DE ADMINISTRACION DE EMPRESAS IPAE-AREQUIPA	1
37925	INST-EDUCATIVA	241317650	241317650 - LOS LIDERES	1
37926	INST-EDUCATIVA	241320027	241320027 - CEVATUR - IQUITOS	1
37927	INST-EDUCATIVA	241320035	241320035 - INSTITUTO PERUANO DE ADMINISTRACION DE EMPRESAS IPAE-IQUITOS	1
37928	INST-EDUCATIVA	241321942	241321942 - DE CIENCIAS DE LA INFORMACION	1
37929	INST-EDUCATIVA	241323260	241323260 - DE INVESTIGACIONES INDUSTRIALES	1
37930	INST-EDUCATIVA	241325786	241325786 - DE INTEGRACION INTERNACIONAL - INTER	1
37931	INST-EDUCATIVA	241328046	241328046 - NUEVA AMERICA	1
37932	INST-EDUCATIVA	241328236	241328236 - ISTEPSA	1
37933	INST-EDUCATIVA	241341619	241341619 - SOUTHERN TECHNOLOGICAL INSTITUTE	1
37934	INST-EDUCATIVA	241345065	241345065 - TURISMO SAGRADOS CORAZONES DE AREQUIPA	1
37935	INST-EDUCATIVA	241345099	241345099 - ESDIT 	1
37936	INST-EDUCATIVA	241345107	241345107 - COMPUTRONIC TECH-AREQUIPA	1
37937	INST-EDUCATIVA	241345123	241345123 - AGRONEGOCIOS DEL SUR	1
37938	INST-EDUCATIVA	241346626	241346626 - VIRGEN DE COCHARCAS-JAUJA	1
37939	INST-EDUCATIVA	241350610	241350610 - SAN ANDRES-LIMA	1
37940	INST-EDUCATIVA	241350628	241350628 - TRENTINO JUAN PABLO II DE MANCHAY	1
37941	INST-EDUCATIVA	241350636	241350636 - GLOBAL INSTITUTE	1
37942	INST-EDUCATIVA	241350644	241350644 - DE ARTES VISUALES EDITH SACHS	1
37943	INST-EDUCATIVA	241350651	241350651 - CREA E INNOVA - INSTITUTO DE EMPRENDEDORES	1
37944	INST-EDUCATIVA	241350669	241350669 - ISHOTUR	1
37945	INST-EDUCATIVA	241351436	241351436 - APOLO'S	1
37946	INST-EDUCATIVA	241351444	241351444 - UNIBACT	1
1933	PAIS	068	BOLIVIA	1
37947	INST-EDUCATIVA	241351451	241351451 - MASTER'S	1
37948	INST-EDUCATIVA	241351477	241351477 - INSTITUTO PERUANO DE ADMINISTRACION DE EMPRESAS IPAE-CHICLAYO	1
37949	INST-EDUCATIVA	241351485	241351485 - EDUTEC-INSTITUTO DE FORMACION EMPRESARIAL	1
37950	INST-EDUCATIVA	241351493	241351493 - STENDHAL	1
37951	INST-EDUCATIVA	241351501	241351501 - CELENDIN	1
37952	INST-EDUCATIVA	241351519	241351519 - LA CATOLICA-CHOTA	1
37953	INST-EDUCATIVA	241351535	241351535 - SERGIO BERNALES - CHOTA	1
37954	INST-EDUCATIVA	241351550	241351550 - VIRGEN DE COPACABANA	1
37955	INST-EDUCATIVA	241351576	241351576 - BUENAVENTURA MESTANZA MORI	1
37956	INST-EDUCATIVA	241351584	241351584 - NUEVO MILENIO	1
37957	INST-EDUCATIVA	241351592	241351592 - GESTION & SALUD	1
37958	INST-EDUCATIVA	241351964	241351964 - BOULANGER	1
37959	INST-EDUCATIVA	241351972	241351972 - CAMISEA	1
37960	INST-EDUCATIVA	241355528	241355528 - DE GASTRONOMIA LE CUISINIER 	1
37961	INST-EDUCATIVA	241355643	241355643 - DE ADMINISTRACION Y PROMOTORIA EMPRESARIAL - INAPE 	1
37962	INST-EDUCATIVA	241355650	241355650 - DE LA CLINICA RICARDO PALMA - SEDE CALLAO	1
37963	INST-EDUCATIVA	241355668	241355668 - TUINEN STAR	1
37964	INST-EDUCATIVA	241355684	241355684 - DAITEC	1
37965	INST-EDUCATIVA	241364686	241364686 - DE SALUD ALBERTO BARTON THOMPSOM	1
37966	INST-EDUCATIVA	241364694	241364694 - DEL CUSCO - ANTA	1
37967	INST-EDUCATIVA	241366574	241366574 - GENOVA	1
37968	INST-EDUCATIVA	241367135	241367135 - CENTRO DE PSICOTERAPIA PSICOANALITICA DE LIMA	1
37969	INST-EDUCATIVA	241375815	241375815 - TECSUP TRUJILLO	1
37970	INST-EDUCATIVA	241380310	241380310 - SAN IGNACIO DE PEDRALBES	1
37971	INST-EDUCATIVA	241380336	241380336 - CUMBRE	1
37972	INST-EDUCATIVA	241381771	241381771 - SAN ANTONIO	1
37973	INST-EDUCATIVA	241385079	241385079 - CEFOP LA LIBERTAD	1
37974	INST-EDUCATIVA	241385509	241385509 - LATINO-CUSCO	1
37975	INST-EDUCATIVA	241385566	241385566 - REGIONAL DEL SUR	1
37976	INST-EDUCATIVA	241385574	241385574 - ESSUMIN	1
37977	INST-EDUCATIVA	241386937	241386937 - ESITUR INTERNATIONAL	1
37978	INST-EDUCATIVA	241387349	241387349 - CCAPAC	1
44597	OCUPACION	961001	BASURERO	1
37979	INST-EDUCATIVA	241389964	241389964 - APU-RIMAC	1
37980	INST-EDUCATIVA	241389998	241389998 - FUTURO DEL SUR-EL CARMEN	1
37981	INST-EDUCATIVA	241390392	241390392 - DE FORMACION BANCARIA - CHICLAYO 	1
37982	INST-EDUCATIVA	241390434	241390434 - MADRE DEL AMOR HERMOSO	1
37983	INST-EDUCATIVA	241390616	241390616 - TECNOVA	1
37984	INST-EDUCATIVA	241391713	241391713 - MOYOBAMBA	1
37985	INST-EDUCATIVA	241391721	241391721 - CHIO LECCA	1
37986	INST-EDUCATIVA	241393818	241393818 - LUCRECIA PRADO VARGAS	1
37987	INST-EDUCATIVA	241395177	241395177 - SIGNOS DE FE	1
37988	INST-EDUCATIVA	241395185	241395185 - CIENCIA, TECNOLOGIA Y DEPORTE-CITED	1
37989	INST-EDUCATIVA	241395193	241395193 - LE GOURMET DEL PERU	1
37990	INST-EDUCATIVA	241395771	241395771 - PRODUCE Y EXPORTA	1
37991	INST-EDUCATIVA	241396993	241396993 - VIRGINIA HENDERSON	1
37992	INST-EDUCATIVA	241404953	241404953 - AMAZONICO	1
37993	INST-EDUCATIVA	241407147	241407147 - TEPNUM	1
37994	INST-EDUCATIVA	241407154	241407154 - JUANA MARIA CONDESA	1
37995	INST-EDUCATIVA	241410166	241410166 - ALTOS ESTUDIOS EMPRESARIALES E IDIOMAS - BS & L	1
37996	INST-EDUCATIVA	241412469	241412469 - HESSEN	1
37997	INST-EDUCATIVA	241414010	241414010 - DE FORMACION BANCARIA - AREQUIPA 	1
37998	INST-EDUCATIVA	241421114	241421114 - ALAS PERUANAS - ICA	1
37999	INST-EDUCATIVA	241421759	241421759 - COMPUTER MASTER	1
38000	INST-EDUCATIVA	241424647	241424647 - TECNOLOGÍA E INFORMÁTICA DEL SUR	1
38001	INST-EDUCATIVA	241424688	241424688 - ALAS PERUANAS - CHINCHA	1
38002	INST-EDUCATIVA	241425008	241425008 - UNITEK-CHINCHA	1
38003	INST-EDUCATIVA	241425057	241425057 - FEDERICO VILLARREAL - CHINCHA	1
38004	INST-EDUCATIVA	241434166	241434166 - INFONET	1
38005	INST-EDUCATIVA	241437383	241437383 - INTER EXPRESS	1
38006	INST-EDUCATIVA	241440841	241440841 - DE MODA Y DISEÑO MAD	1
38007	INST-EDUCATIVA	241444876	241444876 - LEONARDO DA VINCI-COMPUMATIC-TRUJILLO	1
38008	INST-EDUCATIVA	241445006	241445006 - SENCICO TRUJILLO	1
38009	INST-EDUCATIVA	241445709	241445709 - JOHN F. KENNEDY	1
38010	INST-EDUCATIVA	241445766	241445766 - INTERAMERICANO	1
38011	INST-EDUCATIVA	241446434	241446434 - VON HUMBOLDT	1
38012	INST-EDUCATIVA	241446772	241446772 - SAN MARCOS-TRUJILLO	1
38013	INST-EDUCATIVA	241448182	241448182 - EDUCACION PARA EL DESARROLLO	1
38014	INST-EDUCATIVA	241450907	241450907 - HIPOCRATES	1
38015	INST-EDUCATIVA	241450949	241450949 - FRANCISCO RICCI	1
38016	INST-EDUCATIVA	241460492	241460492 - EL PACIFICO	1
38017	INST-EDUCATIVA	241460633	241460633 - ISA CHICLAYO	1
38018	INST-EDUCATIVA	241461334	241461334 - WILLIAM BOEING	1
38019	INST-EDUCATIVA	241464320	241464320 - CORRIENTE ALTERNA	1
38020	INST-EDUCATIVA	241468032	241468032 - S&D 	1
38021	INST-EDUCATIVA	241468040	241468040 - AVIA	1
38022	INST-EDUCATIVA	241468073	241468073 - PERUANO DE CHEFS	1
38023	INST-EDUCATIVA	241468081	241468081 - CESSAG	1
38024	INST-EDUCATIVA	241468107	241468107 - ADMINISTRACION, NEGOCIOS Y FINANZAS - AFIBAN	1
38025	INST-EDUCATIVA	241468115	241468115 - SKILL COM 	1
38026	INST-EDUCATIVA	241468123	241468123 - IPEMEC 	1
38027	INST-EDUCATIVA	241468131	241468131 - INSTITUTO DE FORMACION Y ASESORAMIENTO PROFESIONAL - INFAP NOTRE DAME	1
38028	INST-EDUCATIVA	241468149	241468149 - CENTRO DE LA IMAGEN	1
38029	INST-EDUCATIVA	241468198	241468198 - SAN VICENTE DE PAUL	1
38030	INST-EDUCATIVA	241468206	241468206 - ALAS PERUANAS - LIMA INSTITUTO DE ESTUDIOS EMPRESARIALES	1
38031	INST-EDUCATIVA	241468214	241468214 - CENTRO PERUANO DE ESTUDIOS BANCARIOS-CEPEBAN	1
38032	INST-EDUCATIVA	241468222	241468222 - CENTRO DE INVESTIGACION PARA EL DESARROLLO TECNOLOGICO-CIDET	1
38033	INST-EDUCATIVA	241468255	241468255 - TECNOLOGICO DE LIBRE COMERCIO SAN JOSE DEL SUR	1
38034	INST-EDUCATIVA	241468271	241468271 - VIVAL	1
38035	INST-EDUCATIVA	241468289	241468289 - TECNOLOGICO DE ESTUDIOS ADMINISTRATIVOS - ISEA	1
38036	INST-EDUCATIVA	241468297	241468297 - INTERNATIONAL AMERICAN COLLEGE HEADWAY COLLEGE	1
38037	INST-EDUCATIVA	241468305	241468305 - EXPRO - EXCELENCIA PROFESIONAL	1
38038	INST-EDUCATIVA	241468313	241468313 - DE TEXTILERIA Y COMERCIO - ITC  	1
38039	INST-EDUCATIVA	241468321	241468321 - DE TELEMATICA GAUSS DATA VIRTUAL	1
38040	INST-EDUCATIVA	241468347	241468347 - INSTITUTO DE PROFESIONES EMPRESARIALES - INTECI	1
38041	INST-EDUCATIVA	241468354	241468354 - ALTA COCINA D GALLIA	1
38042	INST-EDUCATIVA	241468362	241468362 - MATRIX 	1
38043	INST-EDUCATIVA	241468396	241468396 - CEVATEC-LIMA	1
38044	INST-EDUCATIVA	241468511	241468511 - DE GASTRONOMIA MARCELINO PAN Y VINO	1
38045	INST-EDUCATIVA	241468578	241468578 - DE DIRECCION INTERMEDIA CAME	1
38046	INST-EDUCATIVA	241468586	241468586 - GASTROTUR PERU	1
38047	INST-EDUCATIVA	241468628	241468628 - ADDIS	1
38048	INST-EDUCATIVA	241468636	241468636 - EDUCACION MEDICA SAN FERNANDO 	1
38049	INST-EDUCATIVA	241468644	241468644 - LA FLORIDA DEL INCA	1
38050	INST-EDUCATIVA	241468651	241468651 - LE GRAND GOURMET	1
38051	INST-EDUCATIVA	241469931	241469931 - FRANCIS COLLINS	1
38052	INST-EDUCATIVA	241469949	241469949 - NORMEDIC - CAJAMARCA	1
38053	INST-EDUCATIVA	241469956	241469956 - GABRIELA PORTO DE POWER	1
38054	INST-EDUCATIVA	241469964	241469964 - IBEROTEC	1
38055	INST-EDUCATIVA	241472257	241472257 - WALTER PEÑALOZA RAMELLA	1
38056	INST-EDUCATIVA	241472273	241472273 - ADMINISTRACION Y NEGOCIOS	1
38057	INST-EDUCATIVA	241472281	241472281 - DE SALUD FELICIANO RODRIGUEZ CRUZ	1
38058	INST-EDUCATIVA	241525856	241525856 - ESIVI	1
38059	INST-EDUCATIVA	241526045	241526045 - DE EMPRENDEDORES-LIMA	1
38060	INST-EDUCATIVA	241526052	241526052 - PERU - CATOLICA	1
38061	INST-EDUCATIVA	241528181	241528181 - MUCHIK	1
38062	INST-EDUCATIVA	241528561	241528561 - SANTA CRUZ	1
38063	INST-EDUCATIVA	241528579	241528579 - INSTITUTO DE FORMACION MINERA DEL PERU	1
38064	INST-EDUCATIVA	241528587	241528587 - BLUE RIBBON INTERNATIONAL CUSCO	1
38065	INST-EDUCATIVA	241528595	241528595 - LIDERES	1
38066	INST-EDUCATIVA	241528603	241528603 - BILL GATES	1
38067	INST-EDUCATIVA	241528728	241528728 - AMERICANA DE MADRE DE DIOS	1
38068	INST-EDUCATIVA	241528736	241528736 - CETURGH PERU	1
38069	INST-EDUCATIVA	241528751	241528751 - IDAT - TARAPOTO	1
38070	INST-EDUCATIVA	241530690	241530690 - AMERICANO	1
38071	INST-EDUCATIVA	241536606	241536606 - SECOMTUR	1
38072	INST-EDUCATIVA	241536663	241536663 - FIBONACCI	1
38073	INST-EDUCATIVA	241539840	241539840 - RUDOLF DIESEL	1
38074	INST-EDUCATIVA	241544121	241544121 - GRAN BOLIVAR	1
38075	INST-EDUCATIVA	241571314	241571314 - DE TURISMO DE PUNO	1
38076	INST-EDUCATIVA	241571504	241571504 - DE TURISMO SAN LUIS DE ALBA	1
38077	INST-EDUCATIVA	241582162	241582162 - SAN JUAN BAUTISTA LA SALLE	1
38078	INST-EDUCATIVA	241582196	241582196 - MARIO SAMAME BOGGIO	1
38079	INST-EDUCATIVA	241585819	241585819 - TECSEL	1
38080	INST-EDUCATIVA	241595438	241595438 - CENTRO DE FORMACION AGRICOLA - TACNA	1
38081	INST-EDUCATIVA	241600469	241600469 - CIENCIAS DE LA SALUD	1
38082	INST-EDUCATIVA	241600519	241600519 - TRIAL 	1
38083	INST-EDUCATIVA	241607647	241607647 - REDEMPTORIS MATER	1
38084	INST-EDUCATIVA	241608090	241608090 - ACCION COMUNITARIA	1
38085	INST-EDUCATIVA	241612753	241612753 - CIBERNETICA Y TECNOLOGÍA	1
38086	INST-EDUCATIVA	241616788	241616788 - INSTITUTO PERUANO DE ADMINISTRACION DE EMPRESAS IPAE-PIURA	1
38087	INST-EDUCATIVA	241633668	241633668 - ACIP	1
38088	INST-EDUCATIVA	241635317	241635317 - COMPUTRON CAJAMARCA	1
38089	INST-EDUCATIVA	249062610	249062610 - NUESTRO SEÑOR DE HUAMANTANGA	1
38090	INST-EDUCATIVA	250543355	250543355 - JUAN DIEGO	1
38091	INST-EDUCATIVA	250607366	250607366 - VÍCTOR ANDRÉS BELAUNDE - LIMA 	1
38092	INST-EDUCATIVA	250691121	250691121 - SAN CARLOS Y SAN MARCELO	1
38093	INST-EDUCATIVA	250784561	250784561 - MANUEL SANTANA CHIRI	1
38094	INST-EDUCATIVA	250886556	250886556 - JORGE BASADRE	1
38095	INST-EDUCATIVA	250886564	250886564 - SEÑOR DE LUREN	1
38096	INST-EDUCATIVA	250886572	250886572 - JHALEBEP  (ANTES JOSÉ MATÍAS MANZANILLA)	1
38097	INST-EDUCATIVA	250892109	250892109 - MARÍA MONTESSORI	1
38098	INST-EDUCATIVA	250898429	250898429 - FEDERICO  KAISER	1
38099	INST-EDUCATIVA	250911925	250911925 - EXPERIMENTAL CATOLICO	1
1934	PAIS	076	BRASIL	1
38540	NACIONALIDAD	9097	BOLIVIA	1
38100	INST-EDUCATIVA	250920264	250920264 - HÉROES DE LA BREÑA	1
38101	INST-EDUCATIVA	250920298	250920298 - ISABEL LA CATÓLICA	1
38102	INST-EDUCATIVA	250920322	250920322 - JUAN ENRIQUE PESTALOZZI	1
38103	INST-EDUCATIVA	250920363	250920363 - KENNETH  COOPER	1
38104	INST-EDUCATIVA	250920454	250920454 - SAN  JOSÉ-HUANCAYO	1
38105	INST-EDUCATIVA	250928655	250928655 - PUKLLASUNCHIS (RICARDO PALMA)	1
38106	INST-EDUCATIVA	250928846	250928846 - AMÉRICA-ABANCAY	1
38107	INST-EDUCATIVA	250931519	250931519 - DIVINO MAESTRO	1
38108	INST-EDUCATIVA	250931550	250931550 - AMAUTA-ESPINAR	1
38109	INST-EDUCATIVA	250933168	250933168 - BERNABÉ COBO	1
38110	INST-EDUCATIVA	250933242	250933242 - SANTA ANA	1
38111	INST-EDUCATIVA	250933622	250933622 - ARCO IRIS	1
38112	INST-EDUCATIVA	250934158	250934158 - URIEL GARCÍA	1
38113	INST-EDUCATIVA	251026806	251026806 - RICARDO PALMA SORIANO	1
38114	INST-EDUCATIVA	251026830	251026830 - FERNANDO STAHLL	1
38115	INST-EDUCATIVA	251027093	251027093 - SIMÓN BOLÍVAR	1
38116	INST-EDUCATIVA	251027473	251027473 - NUESTRA SEÑORA DE LOURDES	1
38117	INST-EDUCATIVA	251029305	251029305 - ISAAC  NEWTON	1
38118	INST-EDUCATIVA	251029313	251029313 - LIBERTADOR JOSÉ DE SAN MARTÍN	1
38119	INST-EDUCATIVA	251029669	251029669 - DANTE NAVA	1
38120	INST-EDUCATIVA	251029800	251029800 - EDUTEK-SAN ROMAN	1
38121	INST-EDUCATIVA	251029909	251029909 - ANDRÉS BELLO	1
38122	INST-EDUCATIVA	251058551	251058551 - SANTA ROSA	1
38123	INST-EDUCATIVA	251066216	251066216 - AMAUTA-LIMA	1
38124	INST-EDUCATIVA	251066414	251066414 - SAN JUAN BOSCO	1
38125	INST-EDUCATIVA	251067057	251067057 - AMÉRICA-LIMA	1
38126	INST-EDUCATIVA	251067131	251067131 - NICOLÁS COPÉRNICO	1
38127	INST-EDUCATIVA	251067172	251067172 - SAN MARCOS	1
38128	INST-EDUCATIVA	251101716	251101716 - DON BOSCO	1
38129	INST-EDUCATIVA	251112044	251112044 - ESTEBAN PAVLETICH	1
38130	INST-EDUCATIVA	251113224	251113224 - HORACIO URTEAGA	1
38131	INST-EDUCATIVA	251113729	251113729 - SALESIANO	1
38132	INST-EDUCATIVA	251114081	251114081 - SAN MARCELO	1
38133	INST-EDUCATIVA	251114131	251114131 - ERIC BERNE	1
38134	INST-EDUCATIVA	251114321	251114321 - SANTO DOMINGO	1
38135	INST-EDUCATIVA	251114362	251114362 - JESÚS EL MAESTRO	1
38136	INST-EDUCATIVA	251114404	251114404 - JOSÉ CARLOS MARIÁTEGUI	1
38137	INST-EDUCATIVA	251114446	251114446 - PAULO FREIRE	1
38138	INST-EDUCATIVA	251114701	251114701 - PAKAMUROS	1
38139	INST-EDUCATIVA	251114735	251114735 - NUESTRA SEÑORA DE LA EVANGELIZACIÓN	1
38140	INST-EDUCATIVA	251115088	251115088 - DIEGO THOMPSON	1
38141	INST-EDUCATIVA	251115120	251115120 - JOSÉ JIMÉNEZ BORJA	1
38142	INST-EDUCATIVA	251115138	251115138 - SCHILLER GOETHE	1
38143	INST-EDUCATIVA	251115328	251115328 - ANTONIO  RAIMONDI	1
38144	INST-EDUCATIVA	251115443	251115443 - MARÍA AUXILIADORA	1
38145	INST-EDUCATIVA	251123249	251123249 - MARIANNE FROSTIG	1
38146	INST-EDUCATIVA	251123397	251123397 - AUGUSTE RENOIR	1
38147	INST-EDUCATIVA	251124247	251124247 - SAN SILVESTRE	1
38148	INST-EDUCATIVA	251124270	251124270 - JESÚS DE NAZARETH	1
38149	INST-EDUCATIVA	251125111	251125111 - SAN JOSÉ-CAÑETE	1
38150	INST-EDUCATIVA	251125764	251125764 - EDUTEK-TACNA	1
38151	INST-EDUCATIVA	251132703	251132703 - TACABAMBA	1
38152	INST-EDUCATIVA	251135292	251135292 - CAJAMARCA	1
38153	INST-EDUCATIVA	251135300	251135300 - SAN FRANCISCO DE ASÍS	1
38154	INST-EDUCATIVA	251140144	251140144 - CUNA DE LA LIBERTAD AMERICANA	1
38155	INST-EDUCATIVA	251141167	251141167 - ABRAHAM VALDELOMAR	1
38156	INST-EDUCATIVA	251141209	251141209 - BALLESTAS	1
38157	INST-EDUCATIVA	251143536	251143536 - CHILIMASA	1
38158	INST-EDUCATIVA	251154210	251154210 - CENIT GALEAZA	1
38159	INST-EDUCATIVA	251158484	251158484 - PERUANO  CANADIENSE	1
38160	INST-EDUCATIVA	251172279	251172279 - MARCELINO CHAMPAGNAT	1
38161	INST-EDUCATIVA	251174424	251174424 - LIBERTAD	1
38162	INST-EDUCATIVA	251174507	251174507 - OXFORD	1
38163	INST-EDUCATIVA	251174580	251174580 - VIRGEN DE LA PUERTA	1
38164	INST-EDUCATIVA	251192954	251192954 - PAULO VI	1
38165	INST-EDUCATIVA	251192996	251192996 - PERUANO DE LA CIENCIA Y LA CULTURA IPEC	1
38166	INST-EDUCATIVA	251196336	251196336 - DEL VALLE ZAÑA	1
38167	INST-EDUCATIVA	251198019	251198019 - EL NAZARENO	1
38168	INST-EDUCATIVA	251200591	251200591 - SALESIANO DOMINGO SAVIO	1
38169	INST-EDUCATIVA	251232891	251232891 - CLARIDAD	1
38170	INST-EDUCATIVA	251243211	251243211 - ALEXANDER FLEMING	1
38171	INST-EDUCATIVA	251245380	251245380 - VIRGEN DEL CARMEN	1
38172	INST-EDUCATIVA	251254739	251254739 - ADA A. BYRON	1
38173	INST-EDUCATIVA	251255389	251255389 - JOSÉ CRISAM	1
38174	INST-EDUCATIVA	251255587	251255587 - MARYWOOD	1
38175	INST-EDUCATIVA	251255629	251255629 - DIVINO NIÑO JESÚS	1
38176	INST-EDUCATIVA	251256775	251256775 - VON BRAUN	1
38177	INST-EDUCATIVA	251257013	251257013 - DIVINO NIÑO	1
38178	INST-EDUCATIVA	251272145	251272145 - JESÚS MAESTRO	1
38179	INST-EDUCATIVA	251321769	251321769 - HEADWAY COLLEGE	1
38538	NACIONALIDAD	9091	BELARUS	1
38180	INST-EDUCATIVA	251325794	251325794 - NUESTRA SEÑORA DE FÁTIMA DIVINA PROVIDENCIA	1
38181	INST-EDUCATIVA	251345081	251345081 - JUAN PABLO VIZCARDO Y GUZMÁN	1
38182	INST-EDUCATIVA	251386531	251386531 - DIDASCALIO JESÚS MAESTRO	1
38183	INST-EDUCATIVA	251394196	251394196 - KONRAD ADENAHUER	1
38184	INST-EDUCATIVA	251421106	251421106 - SEÑOR DE LOS MILAGROS	1
38185	INST-EDUCATIVA	251450915	251450915 - LA LIBERTAD-CHEPEN	1
38186	INST-EDUCATIVA	251451608	251451608 - JULCÁN	1
38187	INST-EDUCATIVA	251461144	251461144 - CIENCIA Y LIBERTAD	1
38188	INST-EDUCATIVA	251468057	251468057 - LOUIS BAUDIN	1
38189	INST-EDUCATIVA	251468594	251468594 - EUROAMERICANO	1
38190	INST-EDUCATIVA	251468602	251468602 - MUSEO DE ARTE DE LIMA	1
38191	INST-EDUCATIVA	251468610	251468610 - CALIDAD EN REDES DE APRENDIZAJE- CREA	1
38192	INST-EDUCATIVA	251595495	251595495 - JOSÉ LUIS BUSTAMANTE Y RIVERO	1
38193	INST-EDUCATIVA	260000008	260000008 - PONTIFICIA UNIVERSIDAD CATÓLICA DEL PERÚ	1
38194	INST-EDUCATIVA	260000014	260000014 - UNIVERSIDAD PERUANA CAYETANO HEREDIA	1
38195	INST-EDUCATIVA	260000015	260000015 - UNIVERSIDAD CATÓLICA DE SANTA MARÍA	1
38196	INST-EDUCATIVA	260000017	260000017 - UNIVERSIDAD DEL PACÍFICO	1
38197	INST-EDUCATIVA	260000018	260000018 - UNIVERSIDAD DE LIMA	1
38198	INST-EDUCATIVA	260000019	260000019 - UNIVERSIDAD DE SAN MARTÍN DE PORRES	1
38199	INST-EDUCATIVA	260000020	260000020 - UNIVERSIDAD FEMENINA DEL SAGRADO CORAZÓN	1
38200	INST-EDUCATIVA	260000024	260000024 - UNIVERSIDAD INCA GARCILASO DE LA VEGA	1
38201	INST-EDUCATIVA	260000029	260000029 - UNIVERSIDAD DE PIURA	1
38202	INST-EDUCATIVA	260000030	260000030 - UNIVERSIDAD RICARDO PALMA	1
38203	INST-EDUCATIVA	260000036	260000036 - UNIVERSIDAD ANDINA NESTOR CÁCERES VELÁSQUEZ	1
38204	INST-EDUCATIVA	260000037	260000037 - UNIVERSIDAD PERUANA LOS ANDES	1
38205	INST-EDUCATIVA	260000038	260000038 - UNIVERSIDAD PERUANA UNIÓN	1
38206	INST-EDUCATIVA	260000039	260000039 - UNIVERSIDAD ANDINA DEL CUSCO	1
38207	INST-EDUCATIVA	260000040	260000040 - UNIVERSIDAD TECNOLÓGICA DE LOS ANDES	1
38208	INST-EDUCATIVA	260000043	260000043 - UNIVERSIDAD PRIVADA DE TACNA	1
38209	INST-EDUCATIVA	260000044	260000044 - UNIVERSIDAD PARTICULAR DE CHICLAYO	1
38210	INST-EDUCATIVA	260000045	260000045 - UNIVERSIDAD PRIVADA SAN PEDRO	1
38211	INST-EDUCATIVA	260000046	260000046 - UNIVERSIDAD PRIVADA ANTENOR ORREGO	1
38212	INST-EDUCATIVA	260000047	260000047 - UNIVERSIDAD DE HUÁNUCO	1
38213	INST-EDUCATIVA	260000048	260000048 - UNIVERSIDAD JOSÉ CARLOS MARIÁTEGUI	1
38214	INST-EDUCATIVA	260000049	260000049 - UNIVERSIDAD PRIVADA MARCELINO CHAMPAGNAT	1
38215	INST-EDUCATIVA	260000050	260000050 - UNIVERSIDAD CIENTÍFICA DEL PERÚ	1
38216	INST-EDUCATIVA	260000052	260000052 - UNIVERSIDAD PRIVADA CÉSAR VALLEJO	1
38217	INST-EDUCATIVA	260000053	260000053 - UNIVERSIDAD CATÓLICA LOS ÁNGELES DE CHIMBOTE	1
38218	INST-EDUCATIVA	260000054	260000054 - UNIVERSIDAD PERUANA DE CIENCIAS APLICADAS	1
38219	INST-EDUCATIVA	260000055	260000055 - UNIVERSIDAD PRIVADA DEL NORTE	1
38220	INST-EDUCATIVA	260000057	260000057 - UNIVERSIDAD PRIVADA SAN IGNACIO DE LOYOLA	1
38221	INST-EDUCATIVA	260000059	260000059 - UNIVERSIDAD ALAS PERUANAS	1
38222	INST-EDUCATIVA	260000061	260000061 - UNIVERSIDAD PRIVADA NORBERT WIENER	1
38223	INST-EDUCATIVA	260000062	260000062 - UNIVERSIDAD CATÓLICA SAN PABLO	1
38224	INST-EDUCATIVA	260000063	260000063 - UNIVERSIDAD PRIVADA DE ICA	1
38225	INST-EDUCATIVA	260000064	260000064 - ASOCIACIÓN UNIVERSIDAD PRIVADA SAN JUAN BAUTISTA	1
38226	INST-EDUCATIVA	260000065	260000065 - UNIVERSIDAD TECNOLÓGICA DEL PERÚ	1
38227	INST-EDUCATIVA	260000067	260000067 - UNIVERSIDAD CONTINENTAL	1
38228	INST-EDUCATIVA	260000068	260000068 - UNIVERSIDAD CIENTÍFICA DEL SUR	1
38229	INST-EDUCATIVA	260000069	260000069 - UNIVERSIDAD CATÓLICA SANTO TORIBIO DE MOGROVEJO	1
38230	INST-EDUCATIVA	260000070	260000070 - UNIVERSIDAD PRIVADA ANTONIO GUILLERMO URRELO	1
38231	INST-EDUCATIVA	260000071	260000071 - UNIVERSIDAD CATÓLICA SEDES SAPIENTIAE	1
38232	INST-EDUCATIVA	260000072	260000072 - UNIVERSIDAD PRIVADA SEÑOR DE SIPÁN	1
38233	INST-EDUCATIVA	260000074	260000074 - UNIVERSIDAD CATÓLICA DE TRUJILLO BENEDICTO XVI	1
38234	INST-EDUCATIVA	260000078	260000078 - UNIVERSIDAD PERUANA DE LAS AMÉRICAS	1
38235	INST-EDUCATIVA	260000079	260000079 - UNIVERSIDAD ESAN	1
38236	INST-EDUCATIVA	260000080	260000080 - UNIVERSIDAD ANTONIO RUÍZ DE MONTOYA	1
38237	INST-EDUCATIVA	260000081	260000081 - UNIVERSIDAD PERUANA DE CIENCIAS E INFORMÁTICA	1
38238	INST-EDUCATIVA	260000082	260000082 - UNIVERSIDAD PARA EL DESARROLLO ANDINO	1
38239	INST-EDUCATIVA	260000083	260000083 - UNIVERSIDAD PRIVADA TELESUP	1
38240	INST-EDUCATIVA	260000085	260000085 - UNIVERSIDAD PRIVADA SERGIO BERNALES	1
38241	INST-EDUCATIVA	260000086	260000086 - UNIVERSIDAD PRIVADA DE PUCALLPA	1
38242	INST-EDUCATIVA	260000087	260000087 - UNIVERSIDAD ADA A BYRON	1
38243	INST-EDUCATIVA	260000090	260000090 - UNIVERSIDAD PRIVADA DE TRUJILLO	1
38244	INST-EDUCATIVA	260000091	260000091 - UNIVERSIDAD PRIVADA SAN CARLOS	1
38245	INST-EDUCATIVA	260000092	260000092 - UNIVERSIDAD PERUANA SIMÓN BOLIVAR	1
38246	INST-EDUCATIVA	260000093	260000093 - UNIVERSIDAD PERUANA DE INTEGRACIÓN GLOBAL	1
38247	INST-EDUCATIVA	260000094	260000094 - UNIVERSIDAD PERUANA DEL ORIENTE	1
38248	INST-EDUCATIVA	260000096	260000096 - UNIVERSIDAD AUTÓNOMA DEL PERÚ	1
38539	NACIONALIDAD	9093	MYANMAR	1
38249	INST-EDUCATIVA	260000097	260000097 - UNIVERSIDAD DE CIENCIAS Y HUMANIDADES	1
38250	INST-EDUCATIVA	260000099	260000099 - UNIVERSIDAD PRIVADA JUAN MEJÍA BACA	1
38251	INST-EDUCATIVA	260000100	260000100 - UNIVERSIDAD JAIME BAUSATE Y MEZA	1
38252	INST-EDUCATIVA	260000102	260000102 - UNIVERSIDAD PERUANA DEL CENTRO	1
38253	INST-EDUCATIVA	260000103	260000103 - UNIVERSIDAD PRIVADA ARZOBISPO LOAYZA	1
38254	INST-EDUCATIVA	260000104	260000104 - UNIVERSIDAD LE CORDON BLEU	1
38255	INST-EDUCATIVA	260000105	260000105 - UNIVERSIDAD PARTICULAR DE HUANCAYO FRANKLIN ROOSEVELT	1
38256	INST-EDUCATIVA	260000107	260000107 - UNIVERSIDAD PRIVADA DE LAMBAYEQUE	1
38257	INST-EDUCATIVA	260000108	260000108 - UNIVERSIDAD DE CIENCIAS Y ARTES DE AMÉRICA LATINA	1
38258	INST-EDUCATIVA	260000109	260000109 - UNIVERSIDAD PERUANA DE ARTE ORVAL	1
38259	INST-EDUCATIVA	260000110	260000110 - UNIVERSIDAD PARTICULAR DE LA SELVA PERUANA	1
38260	INST-EDUCATIVA	260000111	260000111 - UNIVERSIDAD CIENCIAS DE LA SALUD	1
38261	INST-EDUCATIVA	260000112	260000112 - UNIVERSIDAD DE AYACUCHO FEDERICO FROEBEL	1
38262	INST-EDUCATIVA	260000113	260000113 - UNIVERSIDAD PERUANA DE INVESTIGACIÓN Y NEGOCIOS	1
38263	INST-EDUCATIVA	260000114	260000114 - UNIVERSIDAD PERUANA AUSTRAL DEL CUSCO	1
38264	INST-EDUCATIVA	260000115	260000115 - UNIVERSIDAD AUTÓNOMA SAN FRANCISCO	1
38265	INST-EDUCATIVA	260000116	260000116 - UNIVERSIDAD SAN ANDRÉS	1
38266	INST-EDUCATIVA	260000117	260000117 - UNIVERSIDAD INTERAMERICANA PARA EL DESARROLLO	1
38267	INST-EDUCATIVA	260000118	260000118 - UNIVERSIDAD PARTICULAR JUAN PABLO II	1
38268	INST-EDUCATIVA	260000119	260000119 - UNIVERSIDAD PARTICULAR LEONARDO DA VINCI	1
38269	INST-EDUCATIVA	260000132	260000132 - UNIVERSIDAD DE INGENIERÍA Y TECNOLOGÍA	1
38270	INST-EDUCATIVA	260000133	260000133 - UNIVERSIDAD LA SALLE	1
38271	INST-EDUCATIVA	260000134	260000134 - UNIVERSIDAD LATINOAMERICANA CIMA	1
38272	INST-EDUCATIVA	260000135	260000135 - UNIVERSIDAD PARTICULAR AUTÓNOMA DEL SUR	1
38273	INST-EDUCATIVA	260000136	260000136 - UNIVERSIDAD MARÍA AUXILIADORA	1
38274	INST-EDUCATIVA	260000137	260000137 - UNIVERSIDAD DE LA AMAZONÍA MARIO PELÁEZ BAZÁN	1
38275	INST-EDUCATIVA	260000140	260000140 - UNIVERSIDAD SANTO DOMINGO DE GUZMÁN	1
38276	INST-EDUCATIVA	260000141	260000141 - UNIVERSIDAD MARITIMA DEL PERÚ	1
38277	INST-EDUCATIVA	260000142	260000142 - UNIVERSIDAD PARTICULAR LÍDER PERUANA	1
38278	INST-EDUCATIVA	260000143	260000143 - UNIVERSIDAD PARTICULAR PERUANO ALEMANA	1
38279	INST-EDUCATIVA	260000144	260000144 - UNIVERSIDAD GLOBAL DEL CUSCO	1
38280	INST-EDUCATIVA	260000145	260000145 - UNIVERSIDAD PERUANA SANTO TOMAS DE AQUINO	1
38281	INST-EDUCATIVA	260000146	260000146 - UNIVERSIDAD PARTICULAR SISE	1
38282	INST-EDUCATIVA	260000501	260000501 - FACULTAD DE TEOLOGÍA PONTIFICIA Y CIVIL DE LIMA	1
38283	INST-EDUCATIVA	270920231	270920231 - GUDELIA ALARCO DE VARGAS	1
38284	INST-EDUCATIVA	270920488	270920488 - RICHARD WAGNER	1
38285	INST-EDUCATIVA	271114578	271114578 - JOSAFAT ROEL PINEDA	1
38286	INST-EDUCATIVA	271114933	271114933 - ANTONIO RUIZ DE MONTOYA	1
38287	INST-EDUCATIVA	271123488	271123488 - THEODORO VALCARCEL CABALLERO	1
38288	INST-EDUCATIVA	271124031	271124031 - CORRIENTE ALTERNA	1
38289	INST-EDUCATIVA	271468180	271468180 - ARTE NEGOCIOS Y TECNOLOGIA	1
38290	INST-EDUCATIVA	299999999	299999999 - INSTITUCIÓN NO ESPECIFICADA	1
40000	CONCEPTO-SISTEMA-INTERFAZ	1	MEF	1
38500	NACIONALIDAD	9001	BOUVET ISLAND	1
38501	NACIONALIDAD	9002	COTE D IVOIRE	1
38502	NACIONALIDAD	9003	FALKLAND ISLANDS (MALVINAS)	1
38503	NACIONALIDAD	9004	FRANCE, METROPOLITAN	1
38504	NACIONALIDAD	9005	FRENCH SOUTHERN TERRITORIES	1
38505	NACIONALIDAD	9006	HEARD AND MC DONALD ISLANDS	1
38506	NACIONALIDAD	9007	MAYOTTE	1
38507	NACIONALIDAD	9008	SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS	1
38508	NACIONALIDAD	9009	SVALBARD AND JAN MAYEN ISLANDS	1
38509	NACIONALIDAD	9010	UNITED STATES MINOR OUTLYING ISLANDS	1
38510	NACIONALIDAD	9011	OTROS PAISES O LUGARES	1
38511	NACIONALIDAD	9013	AFGANISTAN	1
38512	NACIONALIDAD	9017	ALBANIA	1
38513	NACIONALIDAD	9019	ALDERNEY	1
38514	NACIONALIDAD	9023	ALEMANIA	1
38515	NACIONALIDAD	9026	ARMENIA	1
38516	NACIONALIDAD	9027	ARUBA	1
38517	NACIONALIDAD	9028	ASCENCION	1
38518	NACIONALIDAD	9029	BOSNIA-HERZEGOVINA	1
38519	NACIONALIDAD	9031	BURKINA FASO	1
38520	NACIONALIDAD	9037	ANDORRA	1
38521	NACIONALIDAD	9040	ANGOLA	1
38522	NACIONALIDAD	9041	ANGUILLA	1
38523	NACIONALIDAD	9043	ANTIGUA Y BARBUDA	1
38524	NACIONALIDAD	9047	ANTILLAS HOLANDESAS	1
38525	NACIONALIDAD	9053	ARABIA SAUDITA	1
38526	NACIONALIDAD	9059	ARGELIA	1
38527	NACIONALIDAD	9063	ARGENTINA	1
38528	NACIONALIDAD	9069	AUSTRALIA	1
38529	NACIONALIDAD	9072	AUSTRIA	1
38530	NACIONALIDAD	9074	AZERBAIJÁN	1
38531	NACIONALIDAD	9077	BAHAMAS	1
38532	NACIONALIDAD	9080	BAHREIN	1
38533	NACIONALIDAD	9081	BANGLA DESH	1
38534	NACIONALIDAD	9083	BARBADOS	1
38535	NACIONALIDAD	9087	BÉLGICA	1
38536	NACIONALIDAD	9088	BELICE	1
38537	NACIONALIDAD	9090	BERMUDAS	1
38541	NACIONALIDAD	9101	BOTSWANA	1
38542	NACIONALIDAD	9105	BRASIL	1
38543	NACIONALIDAD	9108	BRUNEI DARUSSALAM	1
38544	NACIONALIDAD	9111	BULGARIA	1
38545	NACIONALIDAD	9115	BURUNDI	1
38546	NACIONALIDAD	9119	BUTÁN	1
38547	NACIONALIDAD	9127	CABO VERDE	1
38548	NACIONALIDAD	9137	CAIMÁN, ISLAS	1
38549	NACIONALIDAD	9141	CAMBOYA	1
38550	NACIONALIDAD	9145	CAMERÚN, REPUBLICA UNIDA DEL	1
38551	NACIONALIDAD	9147	CAMPIONE D TALIA	1
38552	NACIONALIDAD	9149	CANADÁ	1
38553	NACIONALIDAD	9155	CANAL (NORMANDAS), ISLAS	1
38554	NACIONALIDAD	9157	CANTÓN Y ENDERBURRY	1
38555	NACIONALIDAD	9159	SANTA SEDE	1
38556	NACIONALIDAD	9165	COCOS (KEELING),ISLAS	1
38557	NACIONALIDAD	9169	COLOMBIA	1
38558	NACIONALIDAD	9173	COMORAS	1
38559	NACIONALIDAD	9177	CONGO	1
38560	NACIONALIDAD	9183	COOK, ISLAS	1
38561	NACIONALIDAD	9187	COREA (NORTE), REPUBLICA POPULAR DEMOCRATICA DE	1
38562	NACIONALIDAD	9190	COREA (SUR), REPUBLICA DE	1
38563	NACIONALIDAD	9193	COSTA DE MARFIL	1
38564	NACIONALIDAD	9196	COSTA RICA	1
38565	NACIONALIDAD	9198	CROACIA	1
38566	NACIONALIDAD	9199	CUBA	1
38567	NACIONALIDAD	9203	CHAD	1
38568	NACIONALIDAD	9207	CHECOSLOVAQUIA	1
38569	NACIONALIDAD	9211	CHILE	1
38570	NACIONALIDAD	9215	CHINA	1
38571	NACIONALIDAD	9218	TAIWAN (FORMOSA)	1
38572	NACIONALIDAD	9221	CHIPRE	1
38573	NACIONALIDAD	9229	BENIN	1
38574	NACIONALIDAD	9232	DINAMARCA	1
38575	NACIONALIDAD	9235	DOMINICA	1
38576	NACIONALIDAD	9239	ECUADOR	1
38577	NACIONALIDAD	9240	EGIPTO	1
38578	NACIONALIDAD	9242	EL SALVADOR	1
38579	NACIONALIDAD	9243	ERITREA	1
38580	NACIONALIDAD	9244	EMIRATOS ARABES UNIDOS	1
38581	NACIONALIDAD	9245	ESPAÑA	1
38582	NACIONALIDAD	9246	ESLOVAQUIA	1
38583	NACIONALIDAD	9247	ESLOVENIA	1
38584	NACIONALIDAD	9249	ESTADOS UNIDOS	1
38585	NACIONALIDAD	9251	ESTONIA	1
38586	NACIONALIDAD	9253	ETIOPIA	1
38587	NACIONALIDAD	9259	FEROE, ISLAS	1
38588	NACIONALIDAD	9267	FILIPINAS	1
38589	NACIONALIDAD	9271	FINLANDIA	1
38590	NACIONALIDAD	9275	FRANCIA	1
38591	NACIONALIDAD	9281	GABON	1
38592	NACIONALIDAD	9285	GAMBIA	1
38593	NACIONALIDAD	9286	GAZA Y JERICO	1
38594	NACIONALIDAD	9287	GEORGIA	1
38595	NACIONALIDAD	9289	GHANA	1
38596	NACIONALIDAD	9293	GIBRALTAR	1
38597	NACIONALIDAD	9297	GRANADA	1
38598	NACIONALIDAD	9301	GRECIA	1
38599	NACIONALIDAD	9305	GROENLANDIA	1
38600	NACIONALIDAD	9309	GUADALUPE	1
38601	NACIONALIDAD	9313	GUAM	1
38602	NACIONALIDAD	9317	GUATEMALA	1
38603	NACIONALIDAD	9325	GUAYANA FRANCESA	1
38604	NACIONALIDAD	9327	GUERNSEY	1
38605	NACIONALIDAD	9329	GUINEA	1
38606	NACIONALIDAD	9331	GUINEA ECUATORIAL	1
38607	NACIONALIDAD	9334	GUINEA-BISSAU	1
38608	NACIONALIDAD	9337	GUYANA	1
38609	NACIONALIDAD	9341	HAITI	1
38610	NACIONALIDAD	9345	HONDURAS	1
38611	NACIONALIDAD	9348	HONDURAS BRITANICAS	1
38612	NACIONALIDAD	9351	HONG KONG	1
38613	NACIONALIDAD	9355	HUNGRIA	1
38614	NACIONALIDAD	9361	INDIA	1
38615	NACIONALIDAD	9365	INDONESIA	1
38616	NACIONALIDAD	9369	IRAK	1
38617	NACIONALIDAD	9372	IRAN, REPUBLICA ISLAMICA DEL	1
38618	NACIONALIDAD	9375	IRLANDA (EIRE)	1
38619	NACIONALIDAD	9377	ISLA AZORES	1
38620	NACIONALIDAD	9378	ISLA DEL MAN	1
38621	NACIONALIDAD	9379	ISLANDIA	1
38622	NACIONALIDAD	9380	ISLAS CANARIAS	1
38623	NACIONALIDAD	9381	ISLAS DE CHRISTMAS	1
38624	NACIONALIDAD	9382	ISLAS QESHM	1
38625	NACIONALIDAD	9383	ISRAEL	1
38626	NACIONALIDAD	9386	ITALIA	1
38627	NACIONALIDAD	9391	JAMAICA	1
38743	NACIONALIDAD	9800	TOGO	1
38628	NACIONALIDAD	9395	JONSTON, ISLAS	1
38629	NACIONALIDAD	9399	JAPON	1
38630	NACIONALIDAD	9401	JERSEY	1
38631	NACIONALIDAD	9403	JORDANIA	1
38632	NACIONALIDAD	9406	KAZAJSTAN	1
38633	NACIONALIDAD	9410	KENIA	1
38634	NACIONALIDAD	9411	KIRIBATI	1
38635	NACIONALIDAD	9412	KIRGUIZISTAN	1
38636	NACIONALIDAD	9413	KUWAIT	1
38637	NACIONALIDAD	9418	LABUN	1
38638	NACIONALIDAD	9420	LAOS, REPUBLICA POPULAR DEMOCRATICA DE	1
38639	NACIONALIDAD	9426	LESOTHO	1
38640	NACIONALIDAD	9429	LETONIA	1
38641	NACIONALIDAD	9431	LIBANO	1
38642	NACIONALIDAD	9434	LIBERIA	1
38643	NACIONALIDAD	9438	LIBIA	1
38644	NACIONALIDAD	9440	LIECHTENSTEIN	1
38645	NACIONALIDAD	9443	LITUANIA	1
38646	NACIONALIDAD	9445	LUXEMBURGO	1
38647	NACIONALIDAD	9447	MACAO	1
38648	NACIONALIDAD	9448	MACEDONIA	1
38649	NACIONALIDAD	9450	MADAGASCAR	1
38650	NACIONALIDAD	9453	MADEIRA	1
38651	NACIONALIDAD	9455	MALAYSIA	1
38652	NACIONALIDAD	9458	MALAWI	1
38653	NACIONALIDAD	9461	MALDIVAS	1
38654	NACIONALIDAD	9464	MALI	1
38655	NACIONALIDAD	9467	MALTA	1
38656	NACIONALIDAD	9469	MARIANAS DEL NORTE, ISLAS	1
38657	NACIONALIDAD	9472	MARSHALL, ISLAS	1
38658	NACIONALIDAD	9474	MARRUECOS	1
38659	NACIONALIDAD	9477	MARTINICA	1
38660	NACIONALIDAD	9485	MAURICIO	1
38661	NACIONALIDAD	9488	MAURITANIA	1
38662	NACIONALIDAD	9493	MEXICO	1
38663	NACIONALIDAD	9494	MICRONESIA, ESTADOS FEDERADOS DE	1
38664	NACIONALIDAD	9495	MIDWAY ISLAS	1
38665	NACIONALIDAD	9496	MOLDAVIA	1
38666	NACIONALIDAD	9497	MONGOLIA	1
38667	NACIONALIDAD	9498	MONACO	1
38668	NACIONALIDAD	9501	MONTSERRAT, ISLA	1
38669	NACIONALIDAD	9505	MOZAMBIQUE	1
38670	NACIONALIDAD	9507	NAMIBIA	1
38671	NACIONALIDAD	9508	NAURU	1
38672	NACIONALIDAD	9511	NAVIDAD (CHRISTMAS), ISLA	1
38673	NACIONALIDAD	9517	NEPAL	1
38674	NACIONALIDAD	9521	NICARAGUA	1
38675	NACIONALIDAD	9525	NIGER	1
38676	NACIONALIDAD	9528	NIGERIA	1
38677	NACIONALIDAD	9531	NIUE, ISLA	1
38678	NACIONALIDAD	9535	NORFOLK, ISLA	1
38679	NACIONALIDAD	9538	NORUEGA	1
38680	NACIONALIDAD	9542	NUEVA CALEDONIA	1
38681	NACIONALIDAD	9545	PAPUASIA NUEVA GUINEA	1
38682	NACIONALIDAD	9548	NUEVA ZELANDA	1
38683	NACIONALIDAD	9551	VANUATU	1
38684	NACIONALIDAD	9556	OMAN	1
38685	NACIONALIDAD	9566	PACIFICO, ISLAS DEL	1
38686	NACIONALIDAD	9573	PAISES BAJOS	1
38687	NACIONALIDAD	9576	PAKISTAN	1
38688	NACIONALIDAD	9578	PALAU, ISLAS	1
38689	NACIONALIDAD	9579	TERRITORIO AUTONOMO DE PALESTINA.	1
38690	NACIONALIDAD	9580	PANAMA	1
38691	NACIONALIDAD	9586	PARAGUAY	1
38692	NACIONALIDAD	9589	PERÚ	1
38693	NACIONALIDAD	9593	PITCAIRN, ISLA	1
38694	NACIONALIDAD	9599	POLINESIA FRANCESA	1
38695	NACIONALIDAD	9603	POLONIA	1
38696	NACIONALIDAD	9607	PORTUGAL	1
38697	NACIONALIDAD	9611	PUERTO RICO	1
38698	NACIONALIDAD	9618	QATAR	1
38699	NACIONALIDAD	9628	REINO UNIDO	1
38700	NACIONALIDAD	9629	ESCOCIA	1
38701	NACIONALIDAD	9633	REPUBLICA ARABE UNIDA	1
38702	NACIONALIDAD	9640	REPUBLICA CENTROAFRICANA	1
38703	NACIONALIDAD	9644	REPUBLICA CHECA	1
38704	NACIONALIDAD	9645	REPUBLICA DE SWAZILANDIA	1
38705	NACIONALIDAD	9646	REPUBLICA DE TUNEZ	1
38706	NACIONALIDAD	9647	REPUBLICA DOMINICANA	1
38707	NACIONALIDAD	9660	REUNION	1
38708	NACIONALIDAD	9665	ZIMBABWE	1
38709	NACIONALIDAD	9670	RUMANIA	1
38710	NACIONALIDAD	9675	RUANDA	1
38711	NACIONALIDAD	9676	RUSIA	1
38712	NACIONALIDAD	9677	SALOMON, ISLAS	1
38713	NACIONALIDAD	9685	SAHARA OCCIDENTAL	1
38714	NACIONALIDAD	9687	SAMOA OCCIDENTAL	1
38715	NACIONALIDAD	9690	SAMOA NORTEAMERICANA	1
38716	NACIONALIDAD	9695	SAN CRISTOBAL Y NIEVES	1
38717	NACIONALIDAD	9697	SAN MARINO	1
38718	NACIONALIDAD	9700	SAN PEDRO Y MIQUELON	1
38719	NACIONALIDAD	9705	SAN VICENTE Y LAS GRANADINAS	1
38720	NACIONALIDAD	9710	SANTA ELENA	1
38721	NACIONALIDAD	9715	SANTA LUCIA	1
38722	NACIONALIDAD	9720	SANTO TOME Y PRINCIPE	1
38723	NACIONALIDAD	9728	SENEGAL	1
38724	NACIONALIDAD	9731	SEYCHELLES	1
38725	NACIONALIDAD	9735	SIERRA LEONA	1
38726	NACIONALIDAD	9741	SINGAPUR	1
38727	NACIONALIDAD	9744	SIRIA, REPUBLICA ARABE DE	1
38728	NACIONALIDAD	9748	SOMALIA	1
38729	NACIONALIDAD	9750	SRI LANKA	1
38730	NACIONALIDAD	9756	SUDAFRICA, REPUBLICA DE	1
38731	NACIONALIDAD	9759	SUDAN	1
38732	NACIONALIDAD	9764	SUECIA	1
38733	NACIONALIDAD	9767	SUIZA	1
38734	NACIONALIDAD	9770	SURINAM	1
38735	NACIONALIDAD	9773	SAWSILANDIA	1
38736	NACIONALIDAD	9774	TADJIKISTAN	1
38737	NACIONALIDAD	9776	TAILANDIA	1
38738	NACIONALIDAD	9780	TANZANIA, REPUBLICA UNIDA DE	1
38739	NACIONALIDAD	9783	DJIBOUTI	1
38740	NACIONALIDAD	9786	TERRITORIO ANTARTICO BRITANICO	1
38741	NACIONALIDAD	9787	TERRITORIO BRITANICO DEL OCEANO INDICO	1
38742	NACIONALIDAD	9788	TIMOR DEL ESTE	1
38746	NACIONALIDAD	9815	TRINIDAD Y TOBAGO	1
38747	NACIONALIDAD	9816	TRISTAN DA CUNHA	1
38748	NACIONALIDAD	9820	TUNICIA	1
38749	NACIONALIDAD	9823	TURCAS Y CAICOS, ISLAS	1
38750	NACIONALIDAD	9825	TURKMENISTAN	1
38751	NACIONALIDAD	9827	TURQUIA	1
38752	NACIONALIDAD	9828	TUVALU	1
38753	NACIONALIDAD	9830	UCRANIA	1
38754	NACIONALIDAD	9833	UGANDA	1
38755	NACIONALIDAD	9840	URSS	1
38756	NACIONALIDAD	9845	URUGUAY	1
38757	NACIONALIDAD	9847	UZBEKISTAN	1
38758	NACIONALIDAD	9850	VENEZUELA	1
38759	NACIONALIDAD	9855	VIET NAM	1
38760	NACIONALIDAD	9858	VIETNAM (DEL NORTE)	1
38761	NACIONALIDAD	9863	VIRGENES, ISLAS (BRITANICAS)	1
38762	NACIONALIDAD	9866	VIRGENES, ISLAS (NORTEAMERICANAS)	1
38763	NACIONALIDAD	9870	FIJI	1
38764	NACIONALIDAD	9873	WAKE, ISLA	1
38765	NACIONALIDAD	9875	WALLIS Y FORTUNA, ISLAS	1
38766	NACIONALIDAD	9880	YEMEN	1
38767	NACIONALIDAD	9885	YUGOSLAVIA	1
38768	NACIONALIDAD	9888	ZAIRE	1
38769	NACIONALIDAD	9890	ZAMBIA	1
38770	NACIONALIDAD	9895	ZONA DEL CANAL DE PANAMA	1
38771	NACIONALIDAD	9896	ZONA LIBRE OSTRAVA	1
38772	NACIONALIDAD	9897	ZONA NEUTRAL (PALESTINA)	1
39000	DOC-SUSTENTO	1	OFICIO	1
39001	DOC-SUSTENTO	2	MEMORANDUM	1
39002	DOC-SUSTENTO	3	PERMISO	1
39003	DOC-SUSTENTO	4	RESOLUCION RECTORAL	1
39004	DOC-SUSTENTO	5	RESOLUCION DECANAL	1
39005	DOC-SUSTENTO	6	RESOLUCION JEFATURAL	1
39006	DOC-SUSTENTO	7	EXPEDIENTE	1
39007	DOC-SUSTENTO	8	DEFUNCION	1
39008	DOC-SUSTENTO	9	PROVEIDO	1
39100	MOTIVO-QUINTA-EX	1	INGRESOS CUENTA ESPECIAL	1
39101	MOTIVO-QUINTA-EX	3	RETENCION ADICIONAL VOLUNTARIA	1
39102	MOTIVO-QUINTA-EX	2	PRINCIPAL RETENEDOR OTRA INSTITUCION	1
39103	MOTIVO-QUINTA-EX	4	INGRESO EN OTRA INSTITUCION	1
39104	MOTIVO-QUINTA-EX	5	COMPENSACION DE QUINTA	1
40021	TIPO-VIA	99	OTROS	1
40020	TIPO-VIA	22	TROCHA CARROZABLE	1
40019	TIPO-VIA	21	CAMINO AFIRMADO	1
40018	TIPO-VIA	20	PORTAL	1
40017	TIPO-VIA	19	PLAZUELA	1
40016	TIPO-VIA	18	PASEO	1
40015	TIPO-VIA	17	PROLONGACIÓN 	1
40014	TIPO-VIA	16	GALERIA 	1
40013	TIPO-VIA	15	BAJADA	1
40012	TIPO-VIA	14	CAMINO RURAL	1
40011	TIPO-VIA	13	TROCHA 	1
40010	TIPO-VIA	10	CARRETERA	1
40009	TIPO-VIA	09	PLAZA	1
40008	TIPO-VIA	08	PARQUE	1
40007	TIPO-VIA	07	OVALO	1
40006	TIPO-VIA	06	MALECÓN	1
40005	TIPO-VIA	05	ALAMEDA	1
40004	TIPO-VIA	04	PASAJE	1
40003	TIPO-VIA	03	CALLE	1
40002	TIPO-VIA	02	JIRÓN	1
40001	TIPO-VIA	01	AVENIDA	1
40033	TIPO-ZONA	99	OTROS	1
40032	TIPO-ZONA	11	FND. FUNDO	1
40031	TIPO-ZONA	10	CAS. CASERÍO	1
40030	TIPO-ZONA	09	GRU. GRUPO	1
40029	TIPO-ZONA	08	Z.I. ZONA INDUSTRIAL	1
40028	TIPO-ZONA	07	RES. RESIDENCIAL	1
40027	TIPO-ZONA	06	COO. COOPERATIVA	1
40026	TIPO-ZONA	05	A.H. ASENTAMIENTO HUMANO	1
40025	TIPO-ZONA	04	C.H. CONJUNTO HABITACIONAL	1
40024	TIPO-ZONA	03	U.V. UNIDAD VECINAL	1
40023	TIPO-ZONA	02	P.J. PUEBLO JOVEN	1
40022	TIPO-ZONA	01	URB. URBANIZACIÓN	1
40054	SIT-EDUCATIVA	21	GRADO DE DOCTOR	1
40053	SIT-EDUCATIVA	20	ESTUDIOS DE DOCTORADO COMPLETO	1
40052	SIT-EDUCATIVA	19	ESTUDIOS DE DOCTORADO INCOMPLETO	1
40051	SIT-EDUCATIVA	18	GRADO DE MAESTRÍA	1
40050	SIT-EDUCATIVA	17	ESTUDIOS DE MAESTRÍA COMPLETA	1
40049	SIT-EDUCATIVA	16	ESTUDIOS DE MAESTRÍA INCOMPLETA	1
40048	SIT-EDUCATIVA	15	TITULADO	1
40047	SIT-EDUCATIVA	14	GRADO DE BACHILLER	1
40046	SIT-EDUCATIVA	13	EDUCACIÓN UNIVERSITARIA COMPLETA (4)	1
40045	SIT-EDUCATIVA	12	EDUCACIÓN UNIVERSITARIA INCOMPLETA  (4)	1
40044	SIT-EDUCATIVA	11	EDUCACIÓN SUPERIOR (INSTITUTO SUPERIOR, ETC) COMPLETA  (3)	1
40043	SIT-EDUCATIVA	10	EDUCACIÓN SUPERIOR (INSTITUTO SUPERIOR, ETC) INCOMPLETA (3)	1
40042	SIT-EDUCATIVA	09	EDUCACIÓN TÉCNICA COMPLETA (2)	1
40041	SIT-EDUCATIVA	08	EDUCACIÓN TÉCNICA INCOMPLETA (2)	1
40040	SIT-EDUCATIVA	07	EDUCACIÓN SECUNDARIA COMPLETA	1
40039	SIT-EDUCATIVA	06	EDUCACIÓN SECUNDARIA INCOMPLETA	1
40038	SIT-EDUCATIVA	05	EDUCACIÓN PRIMARIA COMPLETA	1
40037	SIT-EDUCATIVA	04	EDUCACIÓN PRIMARIA INCOMPLETA	1
40036	SIT-EDUCATIVA	03	EDUCACIÓN ESPECIAL COMPLETA	1
40035	SIT-EDUCATIVA	02	EDUCACIÓN ESPECIAL INCOMPLETA	1
44722	OCUPACION	983002	EMPAPELADOR DE PAREDES	1
40034	SIT-EDUCATIVA	01	SIN EDUCACIÓN FORMAL	1
44807	OCUPACION	999106	PROFESOR QUE REALIZA FUNCIONES DE INNOVACIÓN E INVESTIGACIÓN	1
44806	OCUPACION	999105	PROFESOR QUE REALIZA FUNCIONES DE FORMACIÓN DOCENTE	1
44805	OCUPACION	999104	SUBDIRECTOR DE INSTITUCIÓN EDUCATIVA	1
44804	OCUPACION	999103	ESPECIALISTA EN EDUCACIÓN	1
44803	OCUPACION	999102	DIRECTOR O JEFE DE GESTIÓN PEDAGÓGICA	1
44802	OCUPACION	999101	PROFESOR QUE EJERCE CARGO JERÁRQUICO	1
44801	OCUPACION	999001	OCUPACION NO ESPECIFICADA	1
44800	OCUPACION	987025	PEON PORTUARIO	1
44799	OCUPACION	987024	PEON DE CARGA, EMPRESAS DE MUDANZAS	1
44798	OCUPACION	987023	PEON DE CARGA, BUQUES CISTERNA/LIQUIDOS	1
44797	OCUPACION	987022	PEON DE CARGA, BUQUES CISTERNA/GASES	1
44796	OCUPACION	987021	PEON DE CARGA, BUQUES	1
44795	OCUPACION	987020	PEON DE CARGA, AVIONES	1
44794	OCUPACION	987019	MANIPULADOR, TIENDA	1
44793	OCUPACION	987018	MANIPULADOR, PESCADO	1
44792	OCUPACION	987017	MANIPULADOR, MERCANCIAS	1
44791	OCUPACION	987016	MANIPULADOR, MERCADO DE ALIMENTOS	1
44790	OCUPACION	987015	MANIPULADOR, GRANDES ALMACENES	1
44789	OCUPACION	987014	MANIPULADOR, FRUTA	1
44788	OCUPACION	987013	MANIPULADOR, CARNE	1
44787	OCUPACION	987012	MANIPULADOR, CARGA	1
44786	OCUPACION	987011	MANIPULADOR, ALMACENES FRIGORIFICOS	1
44785	OCUPACION	987010	ESTIBADOR, MANUAL	1
44784	OCUPACION	987009	CARGADOR, VEHICULOS/TRANSPORTE POR CARRETERA	1
44783	OCUPACION	987008	CARGADOR, VEHICULOS/TRANSPORTE FERROVIARIO	1
44782	OCUPACION	987007	CARGADOR, MUEBLES	1
44781	OCUPACION	987006	CARGADOR, CAMIONES	1
44780	OCUPACION	987005	CARGADOR, BUQUES CISTERNA/LIQUIDO	1
44779	OCUPACION	987004	CARGADOR, BUQUES CISTERNA/GASES	1
44778	OCUPACION	987003	CARGADOR, BUQUES	1
44777	OCUPACION	987002	CARGADOR DE BULTOS	1
44776	OCUPACION	987001	CARGADOR	1
44775	OCUPACION	986019	YUNTERO DE MULAS Y BUEYES	1
44774	OCUPACION	986018	YUGUERO DE MULAS Y BUEYES	1
44773	OCUPACION	986017	YUGUERO DE MULAS	1
44772	OCUPACION	986016	YUGUERO DE BUEYES	1
44771	OCUPACION	986015	CONDUCTOR, VEHICULO DE TRACCION ANIMAL/MINAS	1
44770	OCUPACION	986014	CONDUCTOR, VEHICULO DE TRACCION ANIMAL/CARRETERAS	1
44769	OCUPACION	986013	CONDUCTOR, VEHICULO DE TRACCION ANIMAL/CANTERAS	1
44768	OCUPACION	986012	CONDUCTOR, RECUAS	1
44767	OCUPACION	986011	CONDUCTOR, MULAS, ASEMILEROS; MULERO, TRANSPORTES	1
44766	OCUPACION	986010	CONDUCTOR, MAQUINARIA AGRICOLA/NO MOTORIZADA	1
44765	OCUPACION	986009	CONDUCTOR DE ANIMALES DE CARGA	1
44764	OCUPACION	986008	CONDUCTOR, ANIMALES/MINAS	1
44763	OCUPACION	986007	CONDUCTOR, ANIMALES/CANTERAS, CARRETERAS	1
44762	OCUPACION	986006	COCHERO DE PUNTO	1
44761	OCUPACION	986005	CARRETERO, CONDUCTOR DE VEHICULOS DE TRACCION	1
44760	OCUPACION	986004	CARAVANERO	1
44759	OCUPACION	986003	CABALLISTA, ARRASTRE DE VAZONETAS EN MINAS Y CANTERAS	1
44758	OCUPACION	986002	BURRERO, TRANSPORTE	1
44757	OCUPACION	986001	ARRIERO, CONDUCTOR DE VEHICULOS DE TRACCION ANIMAL	1
44756	OCUPACION	985007	CONDUCTOR, VELOCIPEDO DE TRANSPORTE	1
44755	OCUPACION	985006	CONDUCTOR, VEHICULO A PEDALES	1
44754	OCUPACION	985005	CONDUCTOR, TRICICLO/NO MOTORIZADO	1
44753	OCUPACION	985004	CONDUCTOR, SILLA DE MANOS	1
44752	OCUPACION	985003	CONDUCTOR, CARRO DE MANO	1
44751	OCUPACION	985002	CONDUCTOR, BICICLETA	1
44750	OCUPACION	985001	CARRETILLERO, CARGADOR AMBULANTE DE MERCANCIAS	1
44749	OCUPACION	984024	PEON, OPERACIONES DE MONTAJE MANUAL	1
44748	OCUPACION	984023	PEON, INDUSTRIAS MANUFACTURERAS	1
44747	OCUPACION	984022	PEON, INDUSTRIA VINICOLA	1
44746	OCUPACION	984021	PEON, ENROLLADOR DE RESORTES/A MANO	1
44745	OCUPACION	984020	PEON, ENROLLADOR DE FILAMENTOS/A MANO	1
44744	OCUPACION	984019	PEON, ENROLLADOR DE BOBINAS/A MANO	1
44743	OCUPACION	984018	PEÓN, LIMPIADOR DE PESCADO	1
44742	OCUPACION	984017	PEON, CLASIFICACION/BOTELLAS	1
44741	OCUPACION	984016	PEON, ARMADO	1
44740	OCUPACION	984015	LAVADOR, TALLER DE FABRICACION/A MANO	1
44739	OCUPACION	984014	LAVADOR, RESES/CARNICERIA(A MANO)	1
44738	OCUPACION	984013	LAVADOR, CUEROS Y PIELES/A MANO	1
44737	OCUPACION	984012	LAVADOR, ARTICULOS TEXTILES/A MANO	1
44736	OCUPACION	984011	ETIQUETADOR, A MANO	1
44735	OCUPACION	984010	ESCAMADOR DE PESCADO	1
44734	OCUPACION	984009	ENVASADOR, A MANO	1
44733	OCUPACION	984008	ENSACADOR, A MANO	1
44732	OCUPACION	984007	EMPAQUETADOR, MANUAL	1
44731	OCUPACION	984006	EMBOTELLADOR MANUAL	1
44730	OCUPACION	984005	EMBALADOR, INDUSTRIA CONSERVERA/ENLATADO	1
44729	OCUPACION	984004	EMBALADOR, A MANO/CAJAS	1
44728	OCUPACION	984003	EMBALADOR, A MANO	1
44727	OCUPACION	984002	DESCABEZADOS DE PESCADO	1
44726	OCUPACION	984001	COSEDOR A MANO, ENCUADERNACION	1
44725	OCUPACION	983005	PEON, TAREAS DIVERSAS	1
44724	OCUPACION	983004	PEON, DEMOLICION	1
44723	OCUPACION	983003	PEON, ALBAÐILERIA Y AYUDANTE DE ALBAÐIL	1
44721	OCUPACION	983001	APILADOR DE MATERIAL, CONSTRUCCION/EDIFICIOS, A MANO	1
44720	OCUPACION	982018	VACIADOR DE POZOS  NEGROS	1
44719	OCUPACION	982017	PORTAMIRAS, TOPOGRAFIA	1
44718	OCUPACION	982016	PEON EN GENERAL	1
44717	OCUPACION	982015	PEON, DE BRIGADA FERROCARRILES	1
44716	OCUPACION	982014	PEON, DE BREGA	1
44715	OCUPACION	982013	PEON CONSTRUCCION/DIQUES	1
44714	OCUPACION	982012	PEON CONSTRUCCION/CARRETERAS	1
44713	OCUPACION	982011	PEON CONSTRUCCION	1
44712	OCUPACION	982010	PEON FERROCARRILLERO, BALASTO	1
44711	OCUPACION	982009	PEON CAVADOR, SEPULTURAS, SEPULTURERO, ENTERRADOR	1
44710	OCUPACION	982008	PEON CAVADOR, POZOS DE AGUA	1
44709	OCUPACION	982007	PEON CAVADOR, FOSOS	1
44708	OCUPACION	982006	PEON CAMINERO	1
44707	OCUPACION	982005	PEON BRACERO	1
44706	OCUPACION	982004	OBREROS DEL BALASTO, FERROCARRIL	1
44705	OCUPACION	982003	LIMPIABARROS	1
44704	OCUPACION	982002	DESBROZADOR DE TIERRA	1
44703	OCUPACION	982001	CAVADOR, ZANJAS Y ACEQUIAS	1
44702	OCUPACION	981011	PICAPEDRERO	1
44701	OCUPACION	981010	PICADOR, MINAS	1
44700	OCUPACION	981009	PEON, CANTERAS	1
44699	OCUPACION	981008	PEON, MINAS O CANTERAS	1
43346	OCUPACION	767030	VINAGRERO	1
44698	OCUPACION	981007	PEON, SUMINISTRO DE ELECTRICIDAD, GAS Y AGUA	1
44697	OCUPACION	981006	PEDRERO	1
44696	OCUPACION	981005	OBRERO DE MINERIA DE LAVADO	1
44695	OCUPACION	981004	MINERO EN GENERAL	1
44694	OCUPACION	981003	PEÓN, LAVADOR DE MINERALES	1
44693	OCUPACION	981002	PEÓN, LAVADOR DE ORO	1
44692	OCUPACION	981001	AHOYADOR, CANTERAS	1
44691	OCUPACION	973006	PESCADOR ARTESANAL	1
44690	OCUPACION	973005	RASTRILLADOR, PLAYAS	1
44689	OCUPACION	973004	PEON TRAMPERO	1
44688	OCUPACION	973003	PEON CAZADOR	1
44687	OCUPACION	973002	ENCEBADOR, CAZA CON TRAMPA	1
44686	OCUPACION	973001	BATIDOR DE CAZA	1
44685	OCUPACION	972002	PEON FORESTAL	1
44684	OCUPACION	972001	DESCUAJADOR	1
44683	OCUPACION	971078	VIGILANTE DE MONTE	1
44682	OCUPACION	971077	VAREADOR	1
44681	OCUPACION	971076	TROPERO	1
44680	OCUPACION	971075	TRABAJADOR AGRICOLA	1
44679	OCUPACION	971074	TORNERO	1
44678	OCUPACION	971073	REZADOR	1
44677	OCUPACION	971072	RESINERO (OBRERO)	1
44676	OCUPACION	971071	RECOLECTOR DE FRUTOS, HOJAS DE TE, CAFE, ETC.	1
44675	OCUPACION	971070	RECOLECTOR DE MIEL	1
44674	OCUPACION	971069	RECOGEDOR DE FRUTAS (OBRERO)	1
44673	OCUPACION	971068	PORQUERIZO	1
44672	OCUPACION	971067	PEON DE LABRANZA	1
44671	OCUPACION	971066	PEON DE LABRANZA, CULTIVO EXTENSIVO	1
44670	OCUPACION	971065	PEON DE LABRANZA, GANADO	1
44669	OCUPACION	971064	PEON DE LABRANZA, GANADO BOVINO	1
44668	OCUPACION	971063	PEON DE LABRANZA, GANADO OVINO	1
44667	OCUPACION	971062	PEON DE LABRANZA, CRIA DE GANADO	1
44666	OCUPACION	971061	PEON DE LABRANZA, COSECHADOR/TE	1
44665	OCUPACION	971060	PEON DE LABRANZA, CITRICOS	1
44664	OCUPACION	971059	PEON DE LABRANZA, COSECHADOR	1
44663	OCUPACION	971058	PEON DE LABRANZA, COSECHADOR/ALGODON	1
44662	OCUPACION	971057	PEON DE LABRANZA, COSECHADOR/HUERTOS	1
44661	OCUPACION	971056	PEON DE LABRANZA, COSECHADOR/FRUTOS	1
44660	OCUPACION	971055	PEON AGRICOLA EN GENERAL	1
44659	OCUPACION	971054	PEON AGRICOLA, COSECHADOR/ALGODON	1
44658	OCUPACION	971053	PEON AGROPECUARIO, GUSANOS DE SEDA	1
44657	OCUPACION	971052	PEON AGROPECUARIO, GANADO EQUINO	1
44656	OCUPACION	971051	PEON AGROPECUARIO, MIGRANTE	1
44655	OCUPACION	971050	PEON AGROPECUARIO, ORDEÐADOR/GANADO LECHERO	1
44654	OCUPACION	971049	PEON DE LABRANZA, ARBORICULTOR	1
44653	OCUPACION	971048	PEON DE ESTANCIA O HACIENDA	1
44652	OCUPACION	971047	PEON AGROPECUARIO, TEMPORERO	1
44651	OCUPACION	971046	PEON AGROPECUARIO, GANADO	1
44650	OCUPACION	971045	PEON AGROPECUARIO, ESTACIONAL	1
44649	OCUPACION	971044	PEON AGRICOLA, CULTIVO EXTENSIVO	1
44648	OCUPACION	971043	PEON AGRICOLA, COSECHADOR/TE	1
44647	OCUPACION	971042	PEON AGRICOLA, COSECHADOR/FRUTAS	1
44646	OCUPACION	971041	PEON AGRICOLA, HORTALIZAS	1
44645	OCUPACION	971040	PEON AGRICOLA, PAPERO	1
44644	OCUPACION	971039	PEON AGROPECUARIO, CRIA DE ANIMALES DE PIEL	1
44643	OCUPACION	971038	PEON AGROPECUARIO, ANIMALES DE PELETERIA	1
44642	OCUPACION	971037	PEON AGROPECUARIO	1
44641	OCUPACION	971036	PASTOR MOCHILERO	1
44640	OCUPACION	971035	PALMERO, OBRERO AGRICOLA	1
44639	OCUPACION	971034	OBRERO FORESTAL, AYUDANTE	1
44638	OCUPACION	971033	OBRERO AGRICOLA, AYUDANTE	1
44637	OCUPACION	971032	OBRERO AGRICOLA DE ARBOLES FRUTALES	1
44636	OCUPACION	971031	OBRERO AVICULTOR, AYUDANTE	1
44635	OCUPACION	971030	OBRERO CRIADOR, AYUDANTE	1
44634	OCUPACION	971029	OBRERO GANADERO, AYUDANTE	1
44633	OCUPACION	971028	MOZO DE CUADRA (OBRERO)	1
44632	OCUPACION	971027	MARRONERO (OBRERO)	1
44631	OCUPACION	971026	LEÐADOR	1
44630	OCUPACION	971025	JORNALERO AGRICOLA	1
44629	OCUPACION	971024	JARDINERO (OBRERO)	1
44628	OCUPACION	971023	INSEMINADOR (OBRERO)	1
44627	OCUPACION	971022	INJERTADOR DE ARBOLES FRUTALES (OBRERO)	1
44626	OCUPACION	971021	GOLONDRINO	1
44625	OCUPACION	971020	GAÐAN	1
44624	OCUPACION	971019	ESTABLERO, CABALLOS REPRODUCTORES	1
44623	OCUPACION	971018	ESQUILADOR (OBRERO)	1
44622	OCUPACION	971017	ENGANCHADOR AGRICOLA	1
44621	OCUPACION	971016	DIMIDOR	1
44620	OCUPACION	971015	CULTIVADOR: ALGODON, CAÐA, AZUCAR, ETC.	1
44619	OCUPACION	971014	CRIADOR DE GUSANOS DE SEDA (OBRERO)	1
44618	OCUPACION	971013	CRIADOR DE RANAS, PAJAROS (OBRERO)	1
44617	OCUPACION	971012	COSECHADOR: MANI, ALGODON, PAJAS, ETC.	1
44616	OCUPACION	971011	CORTADOR DE CAÐA DE AZUCAR	1
44615	OCUPACION	971010	CONDUCTOR, BOVINOS	1
44614	OCUPACION	971009	CAPADOR (OBRERO)	1
44613	OCUPACION	971008	CAMPESINO	1
44612	OCUPACION	971007	CABALLERIZO (OBRERO)	1
44611	OCUPACION	971006	BRACERO AGRICOLA	1
44610	OCUPACION	971005	BOYERO	1
44609	OCUPACION	971004	ARRIERO	1
44608	OCUPACION	971003	ARBORICULTOR	1
44607	OCUPACION	971002	APANADOR/COSECHADOR DE ALGODON	1
44606	OCUPACION	971001	AGRICULTOR, AYUDANTE	1
44605	OCUPACION	961009	RECOGEDOR, BASURAS/CAMION O TRICICLO	1
44604	OCUPACION	961008	PEON, RECOLECCION DE DESECHOS	1
44603	OCUPACION	961007	PEON GENERAL	1
44602	OCUPACION	961006	PEON CARBONERO	1
44601	OCUPACION	961005	BARRENDERO, PLAZAS Y PARQUES/JARDINES	1
44600	OCUPACION	961004	BARRENDERO, FABRICAS	1
44599	OCUPACION	961003	BARRENDERO, CALLES	1
44596	OCUPACION	953001	LECTOR DE MEDIDORES	1
44595	OCUPACION	952022	VIGILANTE, NOCTURNO	1
44594	OCUPACION	952021	VIGILANTE, MUSEO	1
44593	OCUPACION	952020	VIGILANTE, HORARIOS DE TRABAJO	1
44592	OCUPACION	952019	VIGILANTE	1
44591	OCUPACION	952018	UJIER	1
44590	OCUPACION	952017	SERENO	1
44589	OCUPACION	952016	PORTERO, HOTEL/VESTIBULO DE RECEPCION	1
44588	OCUPACION	952015	PORTERO, HOTEL	1
44587	OCUPACION	952014	PORTERO	1
44586	OCUPACION	952013	GUARDIAN, VESTUARIO	1
44585	OCUPACION	952012	GUARDIAN, SALON DE DESCANSO	1
44584	OCUPACION	952011	GUARDIAN, PARQUES Y JARDINES PUBLICOS	1
44583	OCUPACION	952010	GUARDIAN, PARQUE DE ATRACCIONES	1
44582	OCUPACION	952009	GUARDIAN, MUSEO	1
44581	OCUPACION	952008	GUARDIAN, GUARDARROPA	1
44580	OCUPACION	952007	GUARDIAN, GALERIA DE ARTE	1
44579	OCUPACION	952006	GUARDIAN, FERIA	1
44578	OCUPACION	952005	GUARDIAN, ESTACIONAMIENTO	1
44577	OCUPACION	952004	GUARDIAN	1
44576	OCUPACION	952003	ENCARGADO, LOCAL DE ASEO	1
44575	OCUPACION	952002	CONSERJE, HOTEL	1
44574	OCUPACION	952001	ACOMODADOR	1
44573	OCUPACION	951011	REPARTIDOR, PERIODICOS	1
44572	OCUPACION	951010	REPARTIDOR, DIARIOS	1
44571	OCUPACION	951009	REPARTIDOR	1
44570	OCUPACION	951008	MOZO DE CUERDA	1
44569	OCUPACION	951007	MENSAJERO, TELEGRAMAS	1
44568	OCUPACION	951006	MENSAJERO	1
44567	OCUPACION	951005	MANDADERO	1
44566	OCUPACION	951004	MALETERO, HOTEL	1
44565	OCUPACION	951003	CADDIE, O PORTEADOR DE PALOS DE GOLF	1
44564	OCUPACION	951002	BOTONES	1
44563	OCUPACION	951001	ASENSORISTA	1
44562	OCUPACION	945047	CUIDADO DE NIÐOS EN VIVIENDAS PARTICULARES	1
44561	OCUPACION	945046	ZAPATERO REMENDON (AMBULANTE)	1
44560	OCUPACION	945045	COBRADOR DE AUTOS	1
44559	OCUPACION	945044	VENDEDORES POR TELEFONO	1
44558	OCUPACION	945043	TRAMITADOR AMBULANTE	1
44557	OCUPACION	945042	TRABAJADOR DE CASINO, PIN-BALL, BOWLING, BINGO Y SALAS DE J	1
44556	OCUPACION	945041	TRABAJADOR EN FERIAS Y PARQUES MECANICOS DE DIVERSIONES	1
44555	OCUPACION	945040	TINTERILLERO	1
44554	OCUPACION	945039	SERVICIO DE ALQUILER DE VIDEOS, EQUIPOS DE SONIDO	1
44553	OCUPACION	945038	SERVICIO DE ALQUILER DE VEHICULOS	1
44552	OCUPACION	945037	RECOGEDOR DE PELOTAS	1
44551	OCUPACION	945036	RECEPCIONISTA-ACOMPAÐANTE, CABARET, CLUB ETC.	1
44550	OCUPACION	945035	PROMOTORES DE JUEGO EN LA CALLE (AJEDREZ, DAMAS, ETC.)	1
44549	OCUPACION	945034	PINTOR DE BANDAS SOBRE CALLES Y CAMINOS	1
44548	OCUPACION	945033	PELADOR DE POLLOS, GALLINAS Y OTRAS AVES	1
44547	OCUPACION	945032	PAREJA DE BAILE	1
44546	OCUPACION	945031	OBRERO PORTUARIO	1
44545	OCUPACION	945029	MOZO DE EQUIPAJES, EXCEPTO EN LOS HOTELES	1
44544	OCUPACION	945028	MOZO DE CUERDA, EXCEPTO EN LOS HOTELES	1
44543	OCUPACION	945027	MOZO DE ALMACEN	1
44542	OCUPACION	945026	MOZO DE TRANSPORTE DE MUEBLES	1
44541	OCUPACION	945025	MOZO DE MERCADOS DE ABASTOS	1
44540	OCUPACION	945024	MOZO DE MUDANZA	1
1935	PAIS	124	CANADÁ	1
1970	PAIS	116	CAMBOYA	1
44539	OCUPACION	945023	MERETRICES, PROSTITUTAS, COPETINERAS	1
44538	OCUPACION	945022	MECANOGRAFOS AMBULANTES	1
44537	OCUPACION	945021	LLENADO O ENVASADOR DE PRODUCTOS	1
44536	OCUPACION	945020	JARDINERO	1
44535	OCUPACION	945019	FOTOGRAFO AMBULANTE	1
44534	OCUPACION	945018	ESTIBADOR CARGADOR DE BARCOS	1
44533	OCUPACION	945017	ENVASADOR A MANO O Y/O MAQUINA	1
44532	OCUPACION	945016	ESCOGEDOR DE BOTELLAS	1
44531	OCUPACION	945015	ENSACADOR A MANO	1
44530	OCUPACION	945014	EMPAQUETADOR A MANO Y/O MAQUINA	1
44529	OCUPACION	945013	EMBALADOR A MANO Y/O MAQUINA	1
44528	OCUPACION	945012	DESCARGADOR DE BARCOS	1
44527	OCUPACION	945011	DESCARGADOR DE AVIONES	1
44526	OCUPACION	945010	DECORADOR DE IGLESIAS	1
44525	OCUPACION	945009	COMPRADOR, VENDEDOR AMBULANTE DE MONEDAS Y BILLETES	1
44524	OCUPACION	945008	CARTONERO A MANO	1
44523	OCUPACION	945006	AYUDANTE, BAÐOS SAUNA	1
44522	OCUPACION	945005	AYUDANTE, BAÐOS TURCOS	1
44521	OCUPACION	945004	AYUDANTE DE CAMION	1
44520	OCUPACION	945003	ARMADOR DE CAJAS DE CARTON A MANO	1
44519	OCUPACION	945002	ANOTADOR DE APUESTAS	1
44518	OCUPACION	945001	ACOMODADOR, SALA, CINE, TEATRO ETC.	1
44517	OCUPACION	944006	RECADERO	1
44516	OCUPACION	944005	PEGADOR DE CARTELES	1
44515	OCUPACION	944004	LUSTRABOTAS	1
44514	OCUPACION	944003	LIMPIADOR DE VENTANAS	1
44513	OCUPACION	944002	LIMPIABOTAS	1
44512	OCUPACION	944001	LAVADOR AMBULANTE DE AUTOS	1
44511	OCUPACION	943009	SACRISTAN	1
44510	OCUPACION	943008	PORTERO-CUIDADOR, ESTABLECIMIENTO RELIGIOSO	1
44509	OCUPACION	943007	PORTERO-CUIDADOR	1
44508	OCUPACION	943006	GUARDIAN, EDIFICIO	1
44507	OCUPACION	943005	ENCARGADO, INMUEBLE	1
44506	OCUPACION	943004	EMPLEADO, EDIFICIO/APARTAMENTOS(LIMPIEZA)	1
44505	OCUPACION	943003	CONSERJE, EDIFICIO/APARTAMENTOS	1
44504	OCUPACION	943002	CONSERJE	1
44503	OCUPACION	943001	BEDEL	1
44502	OCUPACION	942012	QUITAMANCHAS, A MANO	1
44501	OCUPACION	942011	PLANCHADOR, A MANO	1
44500	OCUPACION	942010	PEON DE LIMPIEZA DE: AERONAVES, AUTOBUSES, FABRICAS ETC.	1
44499	OCUPACION	942009	MUJER DE LIMPIEZA DE: HOTELES, OFICINAS ETC.	1
43340	OCUPACION	767024	PISADOR DE UVA	1
44498	OCUPACION	942008	LIMPIADOR DE: FABRICAS, HOTELES, OFICINAS Y RESTAURANTES	1
44497	OCUPACION	942007	LIMPIADOR, EN SECO/A MANO	1
44496	OCUPACION	942006	LAVAPLATOS DE: CANTINA, HOTEL, RESTAURANTE	1
44495	OCUPACION	942005	LAVAPISOS	1
44494	OCUPACION	942004	LAVANDERO, A MANO/LAVANDERIA	1
44493	OCUPACION	942003	CLASIFICADOR, ROPA/LAVANDERIA	1
44492	OCUPACION	942002	CAMARERO, HOTELERIA	1
44491	OCUPACION	942001	ALMIDONADOR, LAVANDERIA	1
44490	OCUPACION	941023	SIRVIENTE (A), SALON	1
44489	OCUPACION	941022	SIRVIENTE (A), COCINA	1
44488	OCUPACION	941021	SIRVIENTA (E), SALON	1
44487	OCUPACION	941020	SIRVIENTA (E), COCINA	1
44486	OCUPACION	941019	SIRVIENTA (E)	1
44485	OCUPACION	941018	NIÐERA	1
44484	OCUPACION	941017	NANA	1
44483	OCUPACION	941016	MUCAMA	1
44482	OCUPACION	941015	MOZO (PERSONAL DOMESTICO)	1
44481	OCUPACION	941014	MESERO	1
44480	OCUPACION	941013	MAYORDOMO, HOGAR PARTICULAR	1
44479	OCUPACION	941012	MUJER DE LIMPIEZA, HOGARES	1
44478	OCUPACION	941011	LAVANDERO	1
44477	OCUPACION	941010	EMPLEADO DEL HOGAR	1
44476	OCUPACION	941009	DAMA DE COMPAÐIA	1
44475	OCUPACION	941008	CRIADO	1
44474	OCUPACION	941007	COCINERO	1
44473	OCUPACION	941006	CAMARERO	1
44472	OCUPACION	941005	CANTINERO	1
44471	OCUPACION	941004	AYUDA DE CAMARA	1
44470	OCUPACION	941003	AYA MAMA	1
44469	OCUPACION	941002	AMA DE LLAVES	1
44468	OCUPACION	941001	AMA DE CRIA O SECA O LECHE O NIÐOS	1
44467	OCUPACION	931007	VENDEDOR DE BOLETOS Y PASAJES DE VIAJE AEREO	1
44466	OCUPACION	931006	VENDEDOR DE BOLETOS, CAMIONETA RURAL, MICROBUSES, OMNIBUS,	1
44465	OCUPACION	931005	COBRADOR, TRANSPORTE POR CARRETERA	1
44464	OCUPACION	931004	COBRADOR, PASAJE/ FERROCARRIL	1
44463	OCUPACION	931003	COBRADOR, PASAJE/ CAMIONETA RURAL (COMBI)	1
44462	OCUPACION	931002	COBRADOR, PASAJE/ MICROBUS Y OMNIBUS	1
44461	OCUPACION	931001	COBRADOR, AUTOBUSES Y MICROBUSES	1
44460	OCUPACION	927007	VENDEDOR AMBULANTE, OTROS	1
44459	OCUPACION	927006	VENDEDOR AMBULANTE, REPUESTO Y/O ART. DE FERRETERIA	1
44458	OCUPACION	927005	VENDEDOR AMBULANTE, RELOJES	1
44457	OCUPACION	927004	VENDEDOR AMBULANTE, MALETAS Y MALETINES / CARTERAS	1
44456	OCUPACION	927003	VENDEDOR AMBULANTE, HULES Y/O MARROQUINES	1
44455	OCUPACION	927002	VENDEDOR AMBULANTE, CASSETTES (BLANCOS Y GRABADOS) Y DISCOS	1
44454	OCUPACION	927001	VENDEDOR AMBULANTE, ANTEOJOS Y LUNAS	1
44453	OCUPACION	926002	VENDEDOR AMBULANTE, JUGUETES	1
44452	OCUPACION	926001	VENDEDOR AMBULANTE, ARTICULOS DEPORTIVOS	1
44451	OCUPACION	925006	VENDEDOR AMBULANTE, CUADROS Y ESCULTURAS	1
44377	OCUPACION	886004	JEFE DE PUERTO.DIQUE SECO	1
44450	OCUPACION	925005	VENDEDOR AMBULANTE, ARTICULOS PARA FIESTAS Y DISFRACES	1
44449	OCUPACION	925004	VENDEDOR AMBULANTE, ARTICULOS RELIGIOSOS	1
44448	OCUPACION	925003	VENDEDOR AMBULANTE, ARTICULOS DE PLATA	1
44447	OCUPACION	925002	VENDEDOR AMBULANTE, ARTICULOS ARTESANALES	1
44446	OCUPACION	925001	VENDEDOR AMBULANTE, ANTIGUEDADES	1
44445	OCUPACION	924003	VENDEDOR AMBULANTE, UTLES DE ESCRITORIO: BORRADORES, CUADER	1
44444	OCUPACION	924002	VENDEDOR AMBULANTE, LIBROS Y NOVELAS	1
44443	OCUPACION	924001	VENDEDOR AMBULANTE, DIARIOS Y REVISTAS / CANILLITAS	1
44442	OCUPACION	923006	VENDEDOR AMBULANTE, ART. DE MESA: MANTELES, INDIVIDUALES, P	1
44441	OCUPACION	923005	VENDEDOR AMBULANTE, UTENSILIOS DE COCINA: CACEROLAS, CUCHIL	1
44440	OCUPACION	923004	VENDEDOR AMBULANTE, MUEBLES PARA EL HOGAR	1
44439	OCUPACION	923003	VENDEDOR AMBULANTE, CATRES Y COLCHONES/ CAMAS	1
44438	OCUPACION	923002	VENDEDOR AMBULANTE, ART. DOMEST.: COCINA, LAVADORA, REFRIGE	1
44437	OCUPACION	923001	VENDEDOR AMBULANTE, ALFOMBRAS. CORTINAS, TAPICES Y ARTICULO	1
44436	OCUPACION	922006	VENDEDOR AMBULANTE PASAMANERIA, LENCERIA, MERCERIA	1
44435	OCUPACION	922005	VENDEDOR AMBULANTE, SOMBREROS	1
44434	OCUPACION	922004	VENDEDOR AMBULANTE, TELAS Y/O TEJIDOS	1
44433	OCUPACION	922003	VENDEDOR AMBULANTE, PRENDAS DE VESTIR: CAMISAS, CARTERAS, P	1
44432	OCUPACION	922002	VENDEDOR AMBULANTE, MERCERIA: AGUJAS, ADORNOS DE VESTIDO, B	1
44431	OCUPACION	922001	VENDEDOR AMBULANTE, CALZADOS, ZAPATILLAS, SANDALIAS, SLAPS,	1
44430	OCUPACION	921003	VENDEDOR AMBULANTE, LEÐA O CARBON	1
44429	OCUPACION	921002	VENDEDOR AMBULANTE; GAS / REPARTIDOR EN CAMIONETA O TRICICL	1
44428	OCUPACION	921001	VENDEDOR AMBULANTE; ACEITE PARA AUTOS, LUBRICANTES (ENVASAD	1
44427	OCUPACION	919005	VENDEDOR AMBULANTE; PRODUCTOS DE: ORNELLA, UNIQUE, YAMBAL,	1
44426	OCUPACION	919004	VENDEDOR AMBULANTE; PASTA DENTRIFICA, PAPEL HIGIENICO, ETC.	1
44425	OCUPACION	919003	VENDEDOR AMBULANTE; JABONES, DETERGENTES, ETC.	1
44424	OCUPACION	919002	VENDEDOR AMBULANTE; ESCOBAS, ESCOBILLAS, ESCOBILLONES, ETC.	1
44423	OCUPACION	919001	VENDEDOR AMBULANTE; COSMETICOS, PERFUMES, LOCION, ETC.	1
44422	OCUPACION	918002	VENDEDOR AMBULANTE, AGUA MINERAL, GASEOSAS, VINO, ETC.	1
44421	OCUPACION	918001	VENDEDOR AMBULANTE, CIGARRO, TABACO, PIPAS E IMPLEMENTOS PA	1
44420	OCUPACION	917008	VENDEDOR AMBULANTE, ABARROTES	1
44419	OCUPACION	917007	VENDEDOR AMBULANTE, PRODUCTOS ALIMENTICIOS PARA ANIMALES/ A	1
44418	OCUPACION	917006	VENDEDOR AMBULANTE, PRODUCTOS LACTEOS, FIDEOS, HARINAS, AZU	1
44417	OCUPACION	917005	VENDEDOR AMBULANTE, PAN, PASTELES	1
44416	OCUPACION	917004	VENDEDOR AMBULANTE, HELADOS, HIELO, MARCIANOS, ETC.	1
44415	OCUPACION	917003	VENDEDOR AMBULANTE, CARAMELOS, CONFITES, CHOCOLATES, GALLET	1
44414	OCUPACION	917002	VENDEDOR AMBULANTE, CAFE TOSTADO, MOLIDO, ENVASADO Y/O GRAN	1
44413	OCUPACION	917001	VENDEDOR AMBULANTE, ACEITE COMESTIBLE	1
44412	OCUPACION	916003	VENDEDOR AMBULANTE, RAICES DE PLANTAS/ USO MEDICINAL	1
44411	OCUPACION	916002	VENDEDOR AMBULANTE, CORTEZAS Y HIERBAS/ USO MEDICINAL	1
44410	OCUPACION	916001	VENDEDOR AMBULANTE, PRODUCTOS FARMACEUTICOS: ALCOHOL, ALGOD	1
44409	OCUPACION	915004	VENDEDOR AMBULANTE, REPARTIDOR DE LECHE	1
44408	OCUPACION	915003	VENDEDOR AMBULANTE, CARNES: PORCINO, VACUNO, ETC.	1
44407	OCUPACION	915002	VENDEDOR AMBULANTE, AVES VIVOS Y/O SUS CARNES	1
44406	OCUPACION	915001	VENDEDOR AMBULANTE, ANIMALES VIVOS: CONEJOS, GATOS, PERROS,	1
44405	OCUPACION	914004	VENDEDOR AMBULANTE, PESCADOS: BONITO, JUREL, PEJERREY, TRUC	1
44404	OCUPACION	914003	VENDEDOR AMBULANTE, MARISCOS: CHOROS, CONCHAS, ETC.	1
44403	OCUPACION	914002	VENDEDOR AMBULANTE, CARNE DE: BALLENA, LOBO MARINO, TORTUGA	1
44402	OCUPACION	914001	VENDEDOR AMBULANTE, CAMARONES Y LANGOSTINOS	1
44401	OCUPACION	913005	VENDEDOR AMBULANTE, COCHINILLA	1
44400	OCUPACION	913004	VENDEDOR AMBULANTE, PLANTAS Y SEMILLAS	1
44399	OCUPACION	913003	VENDEDOR AMBULANTE, FLORES	1
44398	OCUPACION	913002	VENDEDOR AMBULANTE, COCA	1
44397	OCUPACION	913001	VENDEDOR AMBULANTE, ALFALFA Y FORRAJE	1
44396	OCUPACION	912010	VENDEDOR AMBULANTE, COMIDAS PREPARADAS EN LA CALLE, OTROS	1
44395	OCUPACION	912009	VENDEDOR AMBULANTE, SANDWICH	1
44394	OCUPACION	912008	VENDEDOR AMBULANTE, SALCHIPAPAS	1
44393	OCUPACION	912007	VENDEDOR AMBULANTE, RASPADILLAS	1
44392	OCUPACION	912006	VENDEDOR AMBULANTE, PICANTES	1
44391	OCUPACION	912005	VENDEDOR AMBULANTE, JUGOS Y REFRESCOS	1
44390	OCUPACION	912004	VENDEDOR AMBULANTE, EMOLIENTE	1
44389	OCUPACION	912003	VENDEDOR AMBULANTE, CHURROS	1
44388	OCUPACION	912002	VENDEDOR AMBULANTE, CEBICHES Y DERIVADOS	1
44387	OCUPACION	912001	VENDEDOR AMBULANTE, ANTICUCHOS	1
44386	OCUPACION	911006	VENDEDOR AMBULANTE, TUBERCULOS: CAMOTE, PAPA, YUCA, ETC.	1
44385	OCUPACION	911005	VENDEDOR AMBULANTE, MENESTRAS: FRIJOLES, GARBANZOS, LENTEJA	1
44384	OCUPACION	911004	VENDEDOR AMBULANTE, HORTALIZAS: AJO, CEBOLLA, CHOCLO, VAINI	1
44383	OCUPACION	911003	VENDEDOR AMBULANTE, FRUTA FRESCA	1
44382	OCUPACION	911002	VENDEDOR AMBULANTE, ESPECERIAS: CANELA, CLAVO DE OLOR, PIMI	1
44381	OCUPACION	911001	VENDEDOR AMBULANTE, CEREALES: AVENA, CEBADA, TRIGO, ETC.	1
44380	OCUPACION	886007	TORRERO DE FARO,AEROPUERTO Y PUERTOS	1
44379	OCUPACION	886006	PATRON DE PUERTO,DIQUE SECO	1
44378	OCUPACION	886005	OBRERO DE COMPUERTAS DE EVACUACION,EXCLUSAS EN DIQUE SECO	1
44376	OCUPACION	886003	JEFE DE DIQUE O VARADERO	1
44375	OCUPACION	886002	GUARDA DE ESCLUSA,CANALES O PUERTOS	1
44374	OCUPACION	886001	GUARDA BARRERA,FERROCARRILES	1
44373	OCUPACION	885008	CONDUCTORES DE CAMIONES PESADOS	1
44372	OCUPACION	885007	TAXISTA	1
44371	OCUPACION	885006	MICROBUSERO/CONDUCTOR DE MICROBUS	1
44370	OCUPACION	885005	CONDUCTOR DE AUTOBUS, AUTOMOVIL, CAMIONETA, CAMION O FURGON	1
44369	OCUPACION	885004	CONDUCTOR DE MOTOCICLETA	1
44368	OCUPACION	885003	CHOFER PARTICULAR	1
44367	OCUPACION	885002	CHOFER DE ENTREGA DE COCHES NUEVOS	1
44366	OCUPACION	885001	CHOFER DE TAXI	1
44365	OCUPACION	884010	JEFE DE TREN DE MERCANCIAS	1
44364	OCUPACION	884009	GUARDAGUJAS-ENGANCHADOR,(MINAS Y CANTERAS)	1
44363	OCUPACION	884008	GUARDAGUJAS/CONTROLADOR DE TRAFICO FERROVIARIO	1
44362	OCUPACION	884007	GUARDAFRENOS,TREN DE MERCANCIA	1
44361	OCUPACION	884006	ENGANCHADOR DE VAGONES,FERROCARRILES	1
44360	OCUPACION	884005	DERIVADOR, FERROCARRILES	1
44359	OCUPACION	884004	CONDUCTOR,AGENTE DE MANIOBRAS	1
44358	OCUPACION	884003	CLASIFICADOR DE TRENES	1
44357	OCUPACION	884002	BREQUERO DE FERROCARRIL	1
44356	OCUPACION	884001	AGENTES DE MANIOBRAS	1
44355	OCUPACION	883006	MAQUINISTA DE TREN DE MINA O CANTERA	1
44354	OCUPACION	883005	MAQUINISTA DE TREN O LOCOMOTORA	1
44353	OCUPACION	883004	FOGONERO DE LOCOMOTORA DE VAPOR	1
44352	OCUPACION	883003	CONDUCTOR DE LOCOMOTORAS DE MANIOBRAS	1
44351	OCUPACION	883002	CONDUCTOR DE LOCOMOTORA EN MINAS Y CANTERAS	1
44350	OCUPACION	883001	AYUDANTE DE MAQUINISTAS DE TREN	1
44349	OCUPACION	882005	MECANICOS ENGRASADOR,BARCOS	1
44348	OCUPACION	882004	LIMPIADOR DE MAQUINAS.BARCOS	1
44347	OCUPACION	882003	FOGONERO DE BARCO	1
44346	OCUPACION	882002	ENGRASADOR DE BARCOS	1
44345	OCUPACION	882001	AUXILIAR DE LA CAMARA DE MAQUINAS,BARCOS	1
44344	OCUPACION	881010	VAPORINO	1
44343	OCUPACION	881009	MARINERO(MARINERO MERCANTE)	1
44342	OCUPACION	881008	MANIOBRISTA DE BARCO	1
44341	OCUPACION	881007	TIMONEL DE BARCO	1
44340	OCUPACION	881006	PANOLERO DE CUBIERTA	1
44339	OCUPACION	881005	MARINERO EN GRAL, DE PRIMERA,SGDA,DE REMOLCADOR DE YATE,DE	1
44338	OCUPACION	881004	LANCHERO	1
44337	OCUPACION	881003	GRUMETE	1
44336	OCUPACION	881002	CONTRAMAESTRE DE BARCO	1
44335	OCUPACION	881001	BALSEROS	1
44334	OCUPACION	877011	VOLQUETERO	1
44333	OCUPACION	877010	ELEVADORISTA DE CARGA	1
44332	OCUPACION	877009	CHOFER DE MONTACARGAS(EXCEPTO CONSTRUCCION)	1
44331	OCUPACION	877008	OBREROS DE LA MANIPULACION DE MERCANCIA Y MATERIALES O DE M	1
44330	OCUPACION	877007	CONDUCTOR DE VAGONERA LANZADERA,MINAS	1
44329	OCUPACION	877006	CONDUCTOR DE ELEVADOR  DE CARGA	1
44328	OCUPACION	877005	CONDUCTOR DE CINTA TRANSPORTADORA	1
44327	OCUPACION	877004	CONDUCTOR DE CARRETA DE TRANSPORTE TRONCOS, ROLLIZOS Y FUST	1
44326	OCUPACION	877003	CONDUCTOR DE CAMION VOLQUETE	1
44325	OCUPACION	877002	CONDUCTOR DE CARRETON DE HORQUILLA ELEVADORA	1
44324	OCUPACION	877001	CONDUCTOR DE CARRETILLA ELEVADORA	1
44323	OCUPACION	876029	PICADOR CON MARTILLO NEUMATICO, CONSTRUCCION	1
44322	OCUPACION	876028	OTROS CONDUCTORES DE MAQUINA PARA EL MOVIMIENTO DE TIERRAS	1
44321	OCUPACION	876027	OPERADOR DE ZANJADORA DE CANGILONES	1
44320	OCUPACION	876026	OPERADOR DE INSTALCIONES PARA MEZCLAR HORMIGON	1
44319	OCUPACION	876025	CONDUCTOR DE PERFORAD.DE AIRE COMPRIMIDO,CONST.	1
44318	OCUPACION	876024	CONDUCTOR DE PAVIMENTADORA EN HORMIGON	1
44317	OCUPACION	876023	CONDUCTOR DE PALA MECANICA	1
44316	OCUPACION	876022	CONDUCTOR DE NIVELADORA Y ESCRAPER	1
44315	OCUPACION	876021	CONDUCTOR DE NIVELADORA CON CUCHILLA FRONTAL,BULLDOZER	1
44314	OCUPACION	876020	CONDUCTOR DE MAQUINA DE ABRIR HOYOS	1
44313	OCUPACION	876019	CONDUCTOR DE MAQUINA DE ABRIR TUNELES	1
44312	OCUPACION	876018	CONDUCTOR DE MAQUINA HINCADORA DE PILOTES	1
44311	OCUPACION	876017	CONDUCTOR DE MARTINETE	1
44310	OCUPACION	876016	CONDUCTOR DE MAQUINAS DE EXCAVAR ZANJAS	1
44309	OCUPACION	876015	CONDUCTOR DE MAQUINAS DE ABRIR ZANJAS	1
44308	OCUPACION	876014	CONDUCTOR DE INSTALACION DISTRIBUIDORA PARA LA PREPARACION	1
44307	OCUPACION	876013	CONDUCTOR DE HORMIGONERA	1
44306	OCUPACION	876012	CONDUCTOR DE ESPARCIDORA ACABADORA PARA CAMINO	1
44305	OCUPACION	876011	CONDUCTOR DE EXPLANADORA Y DE ESCRAPER	1
44304	OCUPACION	876010	CONDUCTOR DE EXCAVADORA	1
44303	OCUPACION	876009	CONDUCTOR DE DRAGA	1
44302	OCUPACION	876008	CONDUCTOR DE DRAGALINA	1
44301	OCUPACION	876007	CONDUCTOR DE CANGILON DE ARRASTRE	1
44300	OCUPACION	876006	CONDUCTOR DE BULLDOZER	1
44299	OCUPACION	876005	CONDUCTOR DE ATACADOR MECANICO CONSTRUCCION	1
44298	OCUPACION	876004	CONDUCTOR DE ALQUITRANADORA ASFALTADORA	1
44297	OCUPACION	876003	CONDUCTOR DE ASFALTADORA	1
44296	OCUPACION	876002	CONDUCTOR DE APISONADORA	1
44295	OCUPACION	876001	CONDUCTOR DE APLANADORA DE CAMINOS	1
44294	OCUPACION	875025	MANIOBRISTA DE MUELLE	1
44293	OCUPACION	875024	CONDUCTORES DE GRUAS Y OPERADORES DE INSTALACIONES DE ELEVA	1
44292	OCUPACION	875023	OPERADOR DE CABRESTANTE DE VAPOR	1
44291	OCUPACION	875022	OPERADOR DE TORNO DE VAPOR, CABRESTANTE	1
44290	OCUPACION	875021	OPERADOR DE PUENTE GIRATORIO	1
44289	OCUPACION	875020	OPERADOR DE PUENTE LEVADIZO	1
44288	OCUPACION	875019	OPERADOR DE PONTON DE GRUA	1
44287	OCUPACION	875018	OPERADOR DE MONTACARGAS,CONSTRUCCION	1
44286	OCUPACION	875017	OPERADOR DE GRUA DE CUBIERTA	1
44285	OCUPACION	875016	OPERADOR DE CABRESTANTE	1
44284	OCUPACION	875015	MAQUINISTAS DE PUENTE GIRATORIO	1
44283	OCUPACION	875014	MAQUINISTA DE EXTRACCION,MINAS	1
44282	OCUPACION	875013	MAQUINISTA DE TORRE GRUA	1
44281	OCUPACION	875012	GRUISTA,CONDUCTOR DE GRUA DE PORTICO O PTE GRUA	1
44280	OCUPACION	875011	CONDUCTOR DE GRUA,SOBRE VAGON DE FERROCARRILES	1
44279	OCUPACION	875010	CONDUCTOR DE TORRE GRUA	1
44278	OCUPACION	875009	CONDUCTOR DE PUENTE GRUA O GRUA DE PORTICO	1
44277	OCUPACION	875008	CHOFER DE MONTACARGAS(CONSTRUCCION)	1
44276	OCUPACION	875007	CONDUCTOR DE JAULAS,MINAS	1
44275	OCUPACION	875006	CONDUCTOR DE GRUA SOBRE PLATAFORMA MOVIL.FERRC.	1
44274	OCUPACION	875005	CONDUCTOR DE GRUA FLOTANTE	1
44273	OCUPACION	875004	CONDUCTOR DE GRUA LOCOMOVIL	1
44272	OCUPACION	875003	CONDUCTOR DE GRUA MOVIL	1
44271	OCUPACION	875002	CONDUCTOR DE GRUA FIJA	1
44270	OCUPACION	875001	CONDUCTOR DE GRUA APILADORA	1
44269	OCUPACION	874015	OTROS APAREJADORES Y EMPALMADORES DE CABLES,EXCEPTO DE TELE	1
44268	OCUPACION	874014	MONTADOR DE CABLES DE TRANSPORTE AEREO	1
44267	OCUPACION	874013	MONTADOR DE CABLES DE GUAROS AEREOS	1
44266	OCUPACION	874012	MONTADOR DE CABLES DE PUENTES COLGANTES	1
44265	OCUPACION	874011	MONTADOR DE CABLES,PERFOR.DE POZOS DE PETR.GAS	1
44264	OCUPACION	874010	MONTADOR DE CABLES DE AVIACION	1
44263	OCUPACION	874009	MONTADOR DE APARATOS DE ELEVACION(FUNICULAR)	1
44262	OCUPACION	874008	EMPALMADOR DE ESTROBOS	1
44261	OCUPACION	874007	EMPALMADOR DE CUERDAS Y CABLES EN GRAL, EN EXCEPTO ELECTRIC	1
44260	OCUPACION	874006	APAREJADOR, SONDEOS DE PETROLEO Y DE GAS	1
44259	OCUPACION	874005	APAREJADOR, PERFORACION DE POZOS DE PETROL.Y GAS	1
44258	OCUPACION	874004	APAREJADOR, FONDEOS DE PETROLEO Y DE GAS	1
44257	OCUPACION	874003	APAREJADOR DE AVIONES	1
44256	OCUPACION	874002	APAREJADOR DE BARCOS	1
44255	OCUPACION	874001	APAREJADOR DE APARATOS DE ELEVACION	1
44254	OCUPACION	873016	MAQUINISTAS DE MAQUINAS FIJAS N.E.O.P	1
44253	OCUPACION	873015	VIGILANTES DE COMPUERTAS,SERVICIOS DE AGUA	1
44252	OCUPACION	873014	OTROS OPERADOR DE MAQUINAS FIJAS Y DE INSTALACIONES SIMILAR	1
44251	OCUPACION	873013	OPERADOR DE MAQUINAS FIJAS N.E.O.P	1
44250	OCUPACION	873012	OPERADOR DE INSTALACIONES DE CALEF.Y VENTILACION	1
44249	OCUPACION	873011	OPERADOR DE INSTALACIONES DE REFRIGERACION	1
44248	OCUPACION	873010	OPERADOR DE INSTALACIONES DE INCINERACION DE RESIDUOS	1
44247	OCUPACION	873009	OPERADOR DE INSTALACIONES DE TRATAMIENTO DEL AGUA,ABASTECIM	1
44246	OCUPACION	873008	OPERADOR DE INSTALACIONES DE BOMBEO,EXC REFINO DE PETROLEO	1
44245	OCUPACION	873007	OPERADOR DE ESTACION DE BOMBEO	1
44244	OCUPACION	873006	OPERADOR DE COMPRESOR DE AIRE, DE GAS	1
44243	OCUPACION	873005	GUARDA DE VALVULAS DE DESAGUE, EMBALSE	1
44242	OCUPACION	873004	GUARDA DE PRENSA DE EMBALSE	1
44241	OCUPACION	873003	FOGONERO DE CALDERA DE VAPOR, EXCEPTO FOGONERO DE BARCO O L	1
44240	OCUPACION	873002	CONDUCTOR DE INSTALACIONES DEPURADORA DE AGUA	1
44239	OCUPACION	873001	CONDUCTOR DE COMPRESAS DE AIRE, DE GAS	1
44238	OCUPACION	872006	OPERADOR - COSECHADORA	1
44237	OCUPACION	872004	TRACTORISTA	1
44236	OCUPACION	872003	OPERADOR DE MAQUINARIA DE IRRIGACION ARTIFICIAL	1
44235	OCUPACION	872002	FUNIGADOR - CONDUCTOR	1
44234	OCUPACION	872001	CONDUCTOR - CHOFER DE MAQUINARIA AGRICOLA	1
44233	OCUPACION	871014	REPARTIDOR DE CARGAS,ENERGIA ELECTRICA	1
44232	OCUPACION	871013	OTROS OPERADORES DE INSTALACIONES DE PRODUCCION DE ENERGIA	1
44231	OCUPACION	871012	OPERADOR DE PLANTA TERMOELECTRICA E HIDROELECTRICAS	1
44230	OCUPACION	871011	OPERADOR DE TURBINA DE CENTRAL ELECTRICA, PLANTA DE FUERZA	1
44229	OCUPACION	871010	OPERADOR DE REACTOR NUCLEAR	1
44228	OCUPACION	871009	OPERADOR DE PLANTA DE FUERZA ENERGIA ELECTRICA	1
44227	OCUPACION	871008	OPERADOR DE INSTALACION DE CENTRAL TERMOELECTRICA E HIDROEL	1
44226	OCUPACION	871007	OPERADOR DE GENERADOR DE ENERGIA ELECTRICA, INST. PARTICULA	1
44225	OCUPACION	871006	OPERADOR DE EQUIPO ELECTROGENO PARTICULAR	1
44224	OCUPACION	871005	OPERADOR DE CUADRO DE DISTRIBUCION DE CONTROL	1
44223	OCUPACION	871004	OPERADOR DE CENTRAL TERMOELECTRICA E HIDROELECTRICAS	1
44222	OCUPACION	871003	ELECTRICO,DE GENERADOR	1
44221	OCUPACION	871002	DISPATCHER DE ENERGIA ELECTRICA,REPARTIDOR DE CARGAS	1
44220	OCUPACION	871001	CARGAS DE ENERGIA ELECTRICA	1
44219	OCUPACION	868022	OFICIAL DE CONSTRUCCIÓN	1
44218	OCUPACION	868021	CAPATAZ DE CONSTRUCCIÓN	1
44217	OCUPACION	868020	TRABAJADOR EN LA CONSTRUCCION Y REPACIONES	1
44216	OCUPACION	868019	SOLADOR,LADRILLOS Y BALDOSAS DE MATERIAL SINTETICO	1
44215	OCUPACION	868018	REPARADOR DE CHIMINEAS Y TORRES	1
44214	OCUPACION	868017	POCERO	1
1936	PAIS	152	CHILE	1
44213	OCUPACION	868016	OBRERO ESPECIALIZADO EN APEOS	1
44212	OCUPACION	868015	OBRERO ESPECIALIZADO EN SUELO REVESTIDOS CON ASFALTO	1
44211	OCUPACION	868014	OBRERO DE REVEST.DE SUELOS DE BALDOSAS SINTETICAS	1
44210	OCUPACION	868013	OBRERO DE CONSERVACION, REPARACION Y MANTENIMIENTO DE EDIFI	1
44209	OCUPACION	868012	MONTADOR,EDIFICACION CON ELEMENTOS PREFABRICADO	1
44208	OCUPACION	868011	MONTADOR DE ELEMENTOS PREFABRIC.DE LA EDIFICAC.	1
44207	OCUPACION	868010	MONTADOR DE ANDAMIOS	1
44206	OCUPACION	868009	MAESTRO DE OBRAS EN GENERAL	1
44205	OCUPACION	868008	CONSTRUCTOR DE CANALIZACION POR TUBOS	1
44204	OCUPACION	868007	COLOCADOR DE TUBOS, CONDUCCIONES	1
44203	OCUPACION	868006	COLOCADOR DE CABLES GRUESOS SUBTERRANEOS	1
44202	OCUPACION	868005	COLOCADOR DE CAÐERIAS PRINCIPALES DE AGUA	1
44201	OCUPACION	868004	COLOCADOR DE BALDOSAS SINTETICAS	1
44200	OCUPACION	868002	BUZO (CONSTR. Y REPARA CIMIENTO DE LOS PUENTES, Y DIQUES, M	1
44199	OCUPACION	868001	ASFALTO, GRANO DE ARENA Y MATERIALES SIMILARES	1
44198	OCUPACION	867005	VIDRIERO, COLOCADOR DE VIDRIOS	1
44197	OCUPACION	867004	COLOCADOR DE LUNAS DE VEHICULOS	1
44196	OCUPACION	867003	COLOCADOR DE VIDRIOS EN VENTANAS	1
44195	OCUPACION	867002	CRISTALERO DE CLAROBOYAS	1
44194	OCUPACION	867001	CRISTALERO DE EDIFICIO	1
44193	OCUPACION	866008	OTROS INSTALADORES DE MATER.AISLANTES DE INSONORIZACION	1
44192	OCUPACION	866007	INSTALADOR DE MATERIAL DE INSONORIZACION	1
44191	OCUPACION	866006	IONADO, EQUIPOS DE REGRIGERACION, ETC.	1
44190	OCUPACION	866005	SONIDOS;EN CALDERAS Y TUBERIAS, DE AIRE ACONDICIONADO	1
44189	OCUPACION	866004	INSTALADOR DE MATER.AISLANTE,EN EDIFIC,DE INSONORIZACION	1
44188	OCUPACION	866003	AISLADOR DE TURBINA	1
44187	OCUPACION	866002	AISLADOR DE INST.DE REFRIG. Y DE CLIMATIZACION	1
44186	OCUPACION	866001	AISLADOR DE EDIFICIO	1
44185	OCUPACION	865008	YESERO EN GENERAL	1
44184	OCUPACION	865007	REVOCADOR	1
44183	OCUPACION	865006	LISTONERO	1
44182	OCUPACION	865005	ESTUQUISTA-DECORADOR,ESCOYOLISTA	1
44181	OCUPACION	865004	ESCAYOLISTA-DECORADOR, ESCAYOLISTA	1
44180	OCUPACION	865003	ENLUCIDOR EN YESO, EN GENERAL	1
44179	OCUPACION	865002	ENLISTONADOR	1
44178	OCUPACION	865001	DECORADOR EN YESO FIBROSO	1
44177	OCUPACION	864015	PORTAVENTANERO	1
44176	OCUPACION	864014	PARQUETERO, COLOCA PISOS DE PARQUET	1
44175	OCUPACION	864013	MONTADOR DE EBANISTERIA, EDIFICACION	1
44174	OCUPACION	864012	ENTARUGADOR DE PAVIMENTOS	1
44173	OCUPACION	864011	COLOCADOR DE PARQUET	1
44172	OCUPACION	864010	CARPINTERO DE PUERTA Y VENTANAS	1
44171	OCUPACION	864009	CARPINTERO DE RIVERA	1
44170	OCUPACION	864008	CARPINTERO NAVAL O CALAFATERO	1
44169	OCUPACION	864007	CARPINTERO-ARMADOR DE EMBARCACIONES	1
44168	OCUPACION	864006	CARPINTERO EBANISTA, CONSTRUCCION DE BARCOS	1
44167	OCUPACION	864005	CARPINTERO EBANISTA, CONSTRUCCION DE EDIFICIOS	1
44166	OCUPACION	864004	CARPINTERO DE AVIACION	1
44165	OCUPACION	864003	CARPINTERO-EBANISTA DE CONSTRUCCION	1
44164	OCUPACION	864002	CALAFATERO,CARPINTERO	1
44163	OCUPACION	864001	CARPINTERO EN CONSTRUC EN GRAL,EXC:ARMA,TRAB.DE ENCOFRADO	1
44162	OCUPACION	863005	EN METAL DE PAJA Y SIMILARES	1
44161	OCUPACION	863004	TECHADOR EN GENERAL, PIZARRA, TEJA, ASFALTO, MATERIALES SIN	1
44160	OCUPACION	863003	OTROS TECHADORES	1
44159	OCUPACION	863002	COLOCADOR DE TEJAS, TECHADOR	1
44158	OCUPACION	863001	COLOCADOR DE CUBIERTAS DE ASFALTO, DE JUNCO DE METAL	1
44157	OCUPACION	862011	VESTIMIENTOS CON HORMIGON	1
44156	OCUPACION	862010	SOLADOR EN TERRAZO, PAVIMENTO CONTINUO	1
44155	OCUPACION	862009	OPERADOR DE MAQ DE AIRE COMPRIM PARA REVEST. CON HORMIGON	1
44154	OCUPACION	862008	OBRERO DEL CURADO DEL HORMIGON	1
44153	OCUPACION	862007	EN TERRAZO	1
44152	OCUPACION	862006	ENFOSCADOR	1
44151	OCUPACION	862005	ENCOFRADOR EN MADERA	1
44150	OCUPACION	862004	CEMENTERO,TRABAJO DE ACABADO	1
42391	OCUPACION	551001	AMORTAJADOR	1
44149	OCUPACION	862003	CEMENTERO DE HORMIGON ARMADO,EN GENERAL	1
44148	OCUPACION	862002	CARPINTERO DE ARMA, TRABAJO DE ENCOFRADO	1
44147	OCUPACION	862001	ARMADOR DE HORMIGON	1
44146	OCUPACION	861020	SOLADOR EN MATERIALES PLASTICAS, SINTASOL	1
44145	OCUPACION	861019	SOLADOR DE LABRILLOS O BALDOSAS	1
44144	OCUPACION	861018	SOLADOR EN MOSAICO	1
44143	OCUPACION	861017	RESTAURADOR DE MAMPOSTERIA DE CONSTRUC.HISTORIC.,ALBAÐIL	1
44142	OCUPACION	861016	REJUNTADOR DE MAMPOSTERIA CAREADA Y CONCERTADA	1
44141	OCUPACION	861015	PAVIMENTADOR	1
44140	OCUPACION	861014	MOSAISTA,COLOCADOR DE MOSAICOS	1
44139	OCUPACION	861013	MARMOLISTA, CONSTRUCCION	1
44138	OCUPACION	861012	MAMPOSTERO	1
44137	OCUPACION	861011	ESTUFISTA,FUMISTA ALBAÐIL EN LA INDUSTRIA	1
44136	OCUPACION	861010	ENLOSADOR	1
44135	OCUPACION	861009	CONSTRUCTOR DE ALCANTARILLAS, ALBAÐIL	1
44134	OCUPACION	861008	CONSTRUCTOR DE CASAS, ALBANIL	1
44133	OCUPACION	861007	COLOCADOR DE LABRILLOS EN GENERAL	1
44132	OCUPACION	861006	COLOCACION DE LOSAS,SUELO, SOLADOR	1
44131	OCUPACION	861005	ALBAÐIL EN GENERAL	1
44130	OCUPACION	861004	ALBAÐILERO	1
44129	OCUPACION	861003	ALBAÐIL	1
44128	OCUPACION	861002	ADOQUINADOR-PAVIMENTADOR	1
44127	OCUPACION	861001	ADOQUINEROS	1
44126	OCUPACION	852012	LAQUEADOR,EXCEPTO CONSTRUCCION	1
44125	OCUPACION	852011	BARNIZADOR,EXCEPTO CONSTRUCCION	1
44124	OCUPACION	852010	RETOCADOR DE AUTOMOVILES,CARROCERIA	1
44123	OCUPACION	852009	REPARACION DE AUTOMOVILES,PINTOR RETOCADOR	1
44122	OCUPACION	852008	PINTOR RETOCADOR DE AUTOMOV., CARROC. DE PRODUCTOS EN SERIE	1
44121	OCUPACION	852007	PINTOR-PULVERIZADOR,FABRICACION DE AUTOMOVILES	1
44120	OCUPACION	852006	PINTOR POR INMERSION	1
44119	OCUPACION	852005	PINTOR DE ROTULOS	1
44118	OCUPACION	852004	PINTOR DE LETREROS Y ROTULOS	1
44117	OCUPACION	852003	PINTOR DE AUTOMOVILES	1
44116	OCUPACION	852002	PINTOR A PISTOLA,EXCEPTO DE EDIF.Y CONSTRUCION	1
44115	OCUPACION	852001	PINTOR A PINCEL Y RODILLO,EXCEPTO EDIFICIO Y CONSTRUC.	1
44114	OCUPACION	851009	PINTOR DE DECORADOR DE FONDO,TEATRO,CINE	1
44113	OCUPACION	851008	BARNIZADOR,CONSTRUCCION	1
44112	OCUPACION	851007	PINTOR DE CONSTRUCCION ESCENICAS,CINEMATOGRAFIA	1
44111	OCUPACION	851006	PINTOR DE CONSTRUC.METALICAS Y CASCOS Y BUQUES	1
44110	OCUPACION	851005	PINTOR DE CONSTRUCCION, CONSERVACION	1
44109	OCUPACION	851004	PINTOR DE COCHES DE VIAJEROS Y VAGONES, FERROCARRILES	1
44108	OCUPACION	851003	ENCALLADOR	1
44107	OCUPACION	851002	DECORADOR DE ABORDO, BARCOS	1
44106	OCUPACION	851001	BARNIZADOR, CONSTRUCCION	1
44105	OCUPACION	844033	TEJEDOR DE DISFRACES	1
44104	OCUPACION	844032	MAQUINISTA EN LA FABRICACION DE CABLES	1
44103	OCUPACION	844031	PREPARADOR DE PLACAS FOTOGRAFICAS	1
44102	OCUPACION	844030	OPERADOR DE PRENSA DE FAB. TIZAS BLANCAS Y COLOR	1
44101	OCUPACION	844029	OPERADOR DE MAQUINA DE FABRICAR LAPICES	1
44100	OCUPACION	844028	OBRERO EN LA FABRICACION DE ADORNOS ARTIFICIALES	1
44099	OCUPACION	844027	OBRERO EN LA FABRICACION DE BOTONES	1
44098	OCUPACION	844026	OBRERO EN LA ELABORACION DE TELAS ACEITADAS	1
44097	OCUPACION	844025	OBRERO DE TRAT. Y REVEST. DE ALQUITRAN O ASFALTO DEL PAPEL	1
44096	OCUPACION	844024	OBRERO DE FABRICACION DE JUGUETE METALICOS	1
44095	OCUPACION	844023	OBRERO DE LA FABRICACION DE JUGUETES DE MADERA	1
44094	OCUPACION	844022	OBRERO DE LA FABRIC.DE PELICULAS Y PAPEL FOTOGRAFICO	1
44093	OCUPACION	844021	OBRERO DE LA FABRICACION DE LINOLEO	1
44092	OCUPACION	844020	OBRERO DE LA ELABORACION DE CUERDAS DE TRIPA	1
44091	OCUPACION	844019	OBRERO DE LA ELABORACION DE PRODUCTOS DE CORCHO	1
44090	OCUPACION	844018	OBRERO DE IMPERMEABILIZACION DE TELAS AL ACEITE	1
44089	OCUPACION	844017	GRABADOR DE HIERRO, MARFIL,PLASTICO O HUESO	1
44088	OCUPACION	844016	GRABADOR DE MARFIL, HUESO Y PLASTICO	1
44087	OCUPACION	844015	CORTADOR DE CORCHO, FABRICACION DE ARTICULOS	1
44086	OCUPACION	844014	CONFECCIONADOR DE CIERRES	1
44085	OCUPACION	844013	CONFECCIONADOR DE DIENTES ARTIFICIALES	1
44084	OCUPACION	844012	CONFECCIONADOR DE POSTIZOS	1
44083	OCUPACION	844011	CONFECCIONADOR DE ARTESANIA CON FIBRA ACRILICA	1
44082	OCUPACION	844010	CONFECCIONADOR DE FELPUDOS DE JEBE O LLANTA	1
44081	OCUPACION	844009	CONFECCIONADOR DE OJOTAS O LLANQUES	1
44080	OCUPACION	844008	CONFECC.DE ZAPATOS DE RAFIA Y FIBRAS SEMEJANTES	1
44079	OCUPACION	844007	CONFECCIONADOR DE PELUCAS	1
44078	OCUPACION	844006	CONFECCIONADOR DE VELAS Y BUJIAS	1
44077	OCUPACION	844005	CONFECCIONADOR DE SELLOS DE CAUCHO	1
44076	OCUPACION	844004	CONFECCIONADOR DE MUNECOS Y JUGUETES DE TRAPO	1
44075	OCUPACION	844003	CERERO	1
44074	OCUPACION	844002	CANDELERO	1
44073	OCUPACION	844001	ABANIQUERO,CONFECCIONADOR DE ABANICOS	1
44072	OCUPACION	843013	OTROS OBREROS DE LA FABRICACION DE PROD. DERIVADOS	1
44071	OCUPACION	843012	OBRERO DE LA PREPARACION DE ARENAS SILICEAS PARA FILTROS	1
44070	OCUPACION	843011	LOSETERO FABRICACION DE LOCETAS Y MOSAICOS	1
44069	OCUPACION	843010	OBRERO DE LA FAB. DE TELAS Y PAPELES PREVESTIDOS	1
44068	OCUPACION	843009	OBRERO DE LA FABRICACION DE PAPEL Y TELA DE ESMERIL(LIJA)	1
44067	OCUPACION	843008	OBRERO DE LA FABRIC. DE AGLOMERADOS DE PIEDRA ARTIFICIAL	1
44066	OCUPACION	843007	OBRERO DE LA FABRICACION DE PIEDRA ARTIFICIAL	1
44065	OCUPACION	843006	OBRERO DE LA ELABORACION DE FIBROCEMENTO DE AMIANTO	1
44064	OCUPACION	843005	OBRERO DE LA ELABORACION DE PROD.HORMIGON ARMADO	1
44063	OCUPACION	843004	OBRERO DE LA ELABOR. DE PREFABRICADOS DE HORMIGON ARMADO	1
44062	OCUPACION	843003	FABRICANTE DE PRODUCTOS DE PIEDRA ARTIFICIAL	1
44061	OCUPACION	843002	FABRICANTE DE PRODUCTOS DE ASBESTOS-CEMENTO	1
44060	OCUPACION	843001	FABRICANTE DE PIEZAS EN HORMIGON ARMADO	1
44059	OCUPACION	842020	TEJEDORES DE ESTERAS Y FUNCOS	1
44058	OCUPACION	842019	TRENZADOR DE CESTAS,DE SARRIAS	1
44057	OCUPACION	842018	TEJEDOR MUEBLES DE MIMBRE	1
44056	OCUPACION	842017	TEJEDOR DE SERAS Y SERONES	1
44055	OCUPACION	842016	TEJEDOR DE CESTOS	1
44054	OCUPACION	842015	TEJEDOR DE CAPAZOS DE JUNCO O ESPARTO	1
44053	OCUPACION	842014	TEJEDOR DE CAPAZOS	1
44052	OCUPACION	842013	ESTERERO EN JUNCO,PITA Y FIBRA DE COCO	1
44051	OCUPACION	842012	ESCOBERO	1
44050	OCUPACION	842011	COSEDOR DE ESCOBAS	1
44049	OCUPACION	842010	CONFECCIONADOR DE TAPIAS DE JUNCO FINO	1
44048	OCUPACION	842009	CONFECCIONADOR A MAQUINA DE BROCHAS Y CEPILLOS	1
44047	OCUPACION	842008	CONFECC ALFOMBRAS JUNCO,PITA,ESPARTO,FIBRA COCO	1
44046	OCUPACION	842007	CONFECCIONADOR DE MUEBLES DE CANA,JUNCO,MIMBRE	1
44045	OCUPACION	842006	CONFECCIONADOR DE ESTERAS,ESTERONES	1
44044	OCUPACION	842005	CONFECCIONADOR DE ESCOBAS A MANO	1
44043	OCUPACION	842004	CONFECCIONADOR DE PINCELES FINOS	1
44042	OCUPACION	842003	CONFECCIONADOR DE BROCHAS	1
44041	OCUPACION	842002	CONFECCIONADOR A MANO DE CEPILLO	1
44040	OCUPACION	842001	BRUCEROS	1
44039	OCUPACION	841007	VIOLENERO,CONSTRUCTOR Y AFINADOR	1
44038	OCUPACION	841006	ORGANERO,CONSTRUCTOR Y AFINADOR	1
44037	OCUPACION	841005	GUITARRERO, FABRICANTE DE INSTRUMENTOS DE CUERDA	1
44036	OCUPACION	841004	FABRICANTES DE INSTRUMENTOS MUSIC., ARPAS, GUITARRA, VIENTO	1
44035	OCUPACION	841003	CONST INSTRUM VIENTO DE MADERA O DE METAL	1
44034	OCUPACION	841002	AFINADOR DE INSTRUM. MUSICALES, PIANOS, ORGANOS, ACORDEONES	1
44033	OCUPACION	841001	ACORDEONERO,CONSTRUCTOR	1
44032	OCUPACION	839008	SERICIGRAFO,IMPRESOR	1
44031	OCUPACION	839007	PREPARADOR DE ESTARCIDORES,SERICIGRAFIA	1
44030	OCUPACION	839006	PICADOR DE ESTARCIDORES,SERICIGRAFIA	1
44029	OCUPACION	839005	OPERADOR DE PRENSA ESTAMPAR EN RELIEVE O SECO	1
44028	OCUPACION	839004	IMPRESOR,SERICIGRAFIA	1
44027	OCUPACION	839003	IMPRESOR DE TELAS A MAQUINA	1
44026	OCUPACION	839002	IMPRESOR A LA PLANCHA,DE TELAS Y PAPELES PINTADOS	1
44025	OCUPACION	839001	ESTAMPADOR TEXTILES Y PAPELES PINTADOS MEDIANTE PLANCHAS	1
44024	OCUPACION	837011	SECADOR DE PELICULAS CINEMATOGRAFICAS	1
44023	OCUPACION	837010	SACADOR DE COPIAS DE FOTOGRAFIAS	1
44022	OCUPACION	837009	REVELADOR DE RADIOGRAFIAS	1
44021	OCUPACION	837008	REVELADOR DE PELICULAS FOTOGRAFICAS	1
44020	OCUPACION	837007	REDUCTOR DE FOTOGRAFIAS	1
44019	OCUPACION	837006	FOTOGRAFO-SACADOR DE COPIAS	1
44018	OCUPACION	837005	FOTOGRAFO-REVELADOR	1
44017	OCUPACION	837004	FOTOGRAFO-AMPLIADOR	1
44016	OCUPACION	837003	COPIADOR DE FOTOGRAFIAS	1
44015	OCUPACION	837002	CONDUCTOR MAQ DE REVELAR Y SECAR PELICULA CINEMATOGRAFICA	1
44014	OCUPACION	837001	AMPLIADOR DE FOTOGRAFIAS	1
44013	OCUPACION	836008	REPUJADOR O GRABADOR A MANO O A MAQ,ENCUADERNACION	1
44012	OCUPACION	836007	RECORTADOR, ENCUADERNACION	1
44011	OCUPACION	836006	GUILLOTINERO, ENCUADERNACION	1
44010	OCUPACION	836005	GRABADOR A MANO O A MAQUINA,ENCUADERNACION	1
44009	OCUPACION	836004	ENCUADERNADOR	1
44008	OCUPACION	836003	ENCOLADOR,ENCUADERNACION	1
44007	OCUPACION	836002	DORADOR A MANO,ENCUADERNACION	1
44006	OCUPACION	836001	COSEDOR DE PLEIGOS A MAQUINA, ENCUADERNACION	1
44005	OCUPACION	835015	TRANSPORTADOR,FOTOGRABADO	1
44004	OCUPACION	835014	TIRADOR DE PRUEBAS DE CLISES GRABADOS	1
44003	OCUPACION	835013	RETOCADOR DE PLANCHAS DE IMPRESION,FOTOGRABADO	1
44002	OCUPACION	835012	RETOCADOR DE NEGATIVOS,FOTOGRABADO	1
44001	OCUPACION	835011	PASADOR, IMPRENTA	1
44000	OCUPACION	835010	MONTADOR DE CLISES SOBRE SOPORTE	1
43999	OCUPACION	835009	INSOLADOR DE FOTOGRABADO	1
43998	OCUPACION	835008	HUECOGRABADORES	1
43997	OCUPACION	835007	GRANEADOR DE PLANCHAS PARA CLISES	1
43996	OCUPACION	835006	GRABADOR, FOTOGRABADO	1
43995	OCUPACION	835005	FOTOMECANICO, FOTOGRABADO EN GENERAL	1
43994	OCUPACION	835004	FOTOGRAFO, FOTOGRAB., IMPRESION O REPROD. EN OFFSET	1
43993	OCUPACION	835003	FOTOGRABADOR EN GENERAL	1
43992	OCUPACION	835002	FOTO-IMPRESOR PLANCHAS IMPRESION, FOTOGRABADO	1
43991	OCUPACION	835001	CLISADOR, FOTOGRABADOR	1
43990	OCUPACION	834009	XILOGRAFO	1
43989	OCUPACION	834008	TRANSPORTADOR, LITOGRAFIA	1
43988	OCUPACION	834007	PANTOGRAFISTA, IMPRENTA	1
43987	OCUPACION	834006	GRABADOR, BURILISTA, LITOGRAFISTA, GRABADO IMPRENTA	1
43986	OCUPACION	834005	GRABADOR PLANCHAS, CILINDROS Y MATRICES METALICO	1
43985	OCUPACION	834004	GRABADOR DE PIEDRAS LITOGRAFICAS	1
43984	OCUPACION	834003	GRABADOR DE IMPRENTA	1
43983	OCUPACION	834002	GRABADOR CON PANTOGRAFO	1
43982	OCUPACION	834001	GRABADOR A MANO CLISES MADERA, CAUCHO O LINOLEO	1
43981	OCUPACION	833009	REPRODUCTOR DE CLISES, REPRODUCCION EN PLASTICO	1
43980	OCUPACION	833008	MOLDEADOR DE CLISES POR GALVANOPLASTIA, IMPRENTA	1
43979	OCUPACION	833007	MATRICEROS, IMPRENTA	1
43978	OCUPACION	833006	GALVANOPLASTISTA O CLISADOR	1
43977	OCUPACION	833005	FUNDIDOR ESTEREOTIPISTA	1
43976	OCUPACION	833004	ESTEREOTIPISTA, IMPRENTA	1
43975	OCUPACION	833003	ESTEREOTIPADOR, IMPRENTA	1
43974	OCUPACION	833002	ELECTROTIPISTA, IMPRENTA	1
43973	OCUPACION	833001	CLISADOR-ELECTROTIPISTA	1
43972	OCUPACION	832009	TIPOGRAFO OPERADOR DE PRENSAS DE IMPRIMIR	1
43971	OCUPACION	832008	OTROS OPERADORES DE PRENSA DE IMPRIMIR	1
43970	OCUPACION	832007	OPERAD PRENSA ROTATIVA, OFFSET, CILINDRO, PLATINA, LITOGRAF	1
43969	OCUPACION	832006	MARCADOR, INTRODUC. HOJAS EN MAQ. DE IMPRIMIR	1
43968	OCUPACION	832005	MAQUINISTA PLATINERO	1
43967	OCUPACION	832004	MAQUINISTA DE OFFSET	1
43966	OCUPACION	832003	MAQUINISTA DE ROTATIVA A COLORES,IMPRENTA	1
43965	OCUPACION	832002	IMPRESOR DE PAPELES	1
43964	OCUPACION	832001	CONDUCTOR DE PRENSA DE HELIOGRABADO	1
43963	OCUPACION	831022	EMPLEADO O AYUDANTE DE IMPRENTA EN GENERAL	1
43962	OCUPACION	831021	TIPOGRAFO EN GENERAL	1
43961	OCUPACION	831020	TECLISTA MONOTIPISTA	1
43960	OCUPACION	831019	PREPARADOR DE PLANCHAS DE IMPRENTA BRAILLE	1
43959	OCUPACION	831018	PREPARADOR DE BRAILLE, PLANCHAS DE IMPRENTA	1
43958	OCUPACION	831017	PLATINERO, COMPAGINACION	1
43957	OCUPACION	831016	OPERADOR DE TECLADO DE MONOTIPIA	1
43956	OCUPACION	831015	OPERADOR DE MONOTIPIA DE FUNDIR	1
43955	OCUPACION	831014	OPERADOR DE MAQUINA DE FOTOTIPIA, IMPRENTA	1
43954	OCUPACION	831013	OPERADOR DE MAQUINA FUNDIDORA DE TIPOS	1
43953	OCUPACION	831012	MONOTIPISTA	1
43952	OCUPACION	831011	MINERVISTA	1
43951	OCUPACION	831010	MAQUINISTA DE FOTO-COMPOSICION	1
43950	OCUPACION	831009	LINOTIPISTA	1
43949	OCUPACION	831008	IMPRESOR EN GENERAL	1
43948	OCUPACION	831007	IMPRESOR DE PRUEBAS	1
43947	OCUPACION	831006	IMPONEDOR	1
43946	OCUPACION	831005	FUNDIDOR DE MONOTIPIA Y TIPOS SUELTOS	1
43945	OCUPACION	831004	COMPOSITOR,IMPOSICION	1
43944	OCUPACION	831003	COMPAGINADOR DE FOTO-COMPOSICION	1
43943	OCUPACION	831002	CAJISTA, IMPRENTA	1
43942	OCUPACION	831001	ARMADOR DE PAGINAS, IMPOSICION	1
43941	OCUPACION	821021	OPERADOR DE PRENSA DE EMBUTIR CARTON	1
43940	OCUPACION	821020	OPERADOR MAQ. CONFECCIONAR BOLSAS Y SOBRES PAPEL	1
43939	OCUPACION	821019	OPERAD MAQ. PEGADORA Y CERRADORA BOLSAS Y SOBRES	1
43938	OCUPACION	821018	OPERADOR DE MAQUINA PRENSADORA DE CARTON	1
43937	OCUPACION	821017	OPERADOR DE MAQUINA DE CORTAR Y PEGAR CARTON	1
43936	OCUPACION	821016	OPERADOR DE MAQUINA PEGADORA DE PAPEL EN CARTON	1
43935	OCUPACION	821015	OPERADOR DE MAQUINA DE FORRAR CARTON	1
43934	OCUPACION	821014	MONTADOR DE CAJAS DE CARTON A MANO O A MAQUINA	1
43933	OCUPACION	821013	EMSAMBLADOR DE NAIPES	1
43932	OCUPACION	821012	CONFECCIONADOR DE PAPEL	1
43931	OCUPACION	821011	CONFECCIONADOR DE MALETAS DE CARTON	1
43930	OCUPACION	821010	CONFECC. ARTIC. ADORNOS Y FANTASIA EN PAPEL	1
43929	OCUPACION	821009	CONFECCIONADOR DE SOBRES A MANO	1
43928	OCUPACION	821008	CONFECCIONADOR DE BOLSAS DE CELOFAN	1
43927	OCUPACION	821007	CONFECCIONADOR A MAQ. DE BOLSAS Y SOBRES DE PAPEL	1
43926	OCUPACION	821006	CONFECCIONADOR DE CAJAS DE CARTON	1
43925	OCUPACION	821005	CONDUCTOR DE PRENSA DE EMBUTIR EL CARTON	1
43924	OCUPACION	821004	CONDUCTOR DE MAQUINAS DE FABRICAR TUBOS PAPEL	1
43923	OCUPACION	821003	CARTONERO A MAQUINA	1
43922	OCUPACION	821002	CAPATAZ O CONTAMESTRE DE LA CONFECCION DE PRODUCTOS DE PAPE	1
43921	OCUPACION	821001	ARMADOR DE CAJAS DE CARTON A MAQUINA	1
43920	OCUPACION	813009	VULCANIZADOR Y MOLDEADOR DE NEUMATICOS	1
43919	OCUPACION	813008	RENCAUCHADOR DE NEUMATICOS	1
43918	OCUPACION	813007	MOLDEADOR Y VULCANIZADOR DE NEUMATICOS	1
43917	OCUPACION	813006	MOLDEADOR DE NEUMATICOS	1
43916	OCUPACION	813005	FABRICANTE DE NEUMATICOS,PRIMERA FASE	1
43915	OCUPACION	813004	CORTADOR DE ESTUAS EN NEUMATICOS	1
43914	OCUPACION	813003	CORTADOR DE ACANALADURAS EN NEUMATICOS	1
43913	OCUPACION	813002	CONFECCIONADOR DE NEUMATICOS,PRIMERA FASE	1
43912	OCUPACION	813001	AYUDANTE DE REENCAUCHADOR DE NEUMATICOS	1
43911	OCUPACION	812016	TALADRADORA DE PRODUCTOS DE PLASTICO	1
43910	OCUPACION	812015	RECORTADOR A MAQUINA DE PROD. DE PLASTICO	1
43909	OCUPACION	812014	PULIDOR DE PRODUCTOS DE PLASTICO	1
43908	OCUPACION	812013	PREPARADOR DE PANELES DE PLASTICO	1
43907	OCUPACION	812012	OPERADOR DE MAQUINA DE SELLAR PLASTICOS	1
43906	OCUPACION	812011	OPERADOR MAQUINA ESTIRADORA DE PLASTICO	1
43905	OCUPACION	812010	OPERADOR DE MAQUINA DE FABRICAR BOLSAS PLASTICO	1
43904	OCUPACION	812009	OPERAR MAQ. DE MOLDEAR MATERIAS PLASTICAS POR COMPRESION	1
43903	OCUPACION	812008	OPERAD MAQ. DE MOLDEAR MATERIAS PLASTICAS POR INYECCION	1
43902	OCUPACION	812007	MONTADOR DE PRODUCTOS DE PLASTICO	1
43901	OCUPACION	812006	MOLDEADOR DE PLASTICO POR COMPRESION	1
43900	OCUPACION	812005	MOLDEADOR DE PLASTICO POR INYECCION	1
43899	OCUPACION	812004	EXTRUSOR DE PLASTICO	1
43898	OCUPACION	812003	ENSAMBLADOR DE PRODUCTOS DE PLASTICO	1
43897	OCUPACION	812002	CONFECCIONADOR DE PRODUCTOS DE PLASTICO	1
43896	OCUPACION	812001	ARMADOR DE PRODUCTOS DE PLASTICO	1
43895	OCUPACION	811024	VULCANIZADOR ARTIC. CAUCHO, EXCEPTO NEUMATICOS	1
43894	OCUPACION	811023	OPERADOR DE PRENSA DE MOLDEAR CAUCHO	1
43893	OCUPACION	811022	OPERADOR DE MAQUINA ESTIRADORA DE CAUCHO	1
43892	OCUPACION	811021	OPERADOR DE MAQUINA CALANDRADORA DE CAUCHO	1
43891	OCUPACION	811020	OPERADOR DE MAQUINA AMASADORA DE CAUCHO	1
43890	OCUPACION	811019	OPERADOR DE CALANDRIA DE CAUCHO	1
43889	OCUPACION	811018	OBRERO EN LA FABRIC. DE ARTICULOS DE CAUCHO	1
43888	OCUPACION	811017	OBRERO DEL APOMAZADO DEL CAUCHO	1
1937	PAIS	170	COLOMBIA	1
43887	OCUPACION	811016	MONTADOR DE PRODUCTOS DE CAUCHO	1
43886	OCUPACION	811015	MEZCLADOR DE CAUCHO	1
43885	OCUPACION	811014	LUSTRADOR DE CAUCHO	1
43884	OCUPACION	811013	IMPREGNADOR DE CAUCHO	1
43883	OCUPACION	811012	EXTRUSOR DE CAUCHO	1
43882	OCUPACION	811011	ENSAMBLADOR DE PRODUCTOS DE CAUCHO	1
43881	OCUPACION	811010	ENGOMADOR DE TEJIDOS DE CAUCHO	1
43880	OCUPACION	811009	CORTADOR DE CAUCHO	1
43879	OCUPACION	811008	CONFECCIONADOR-MONTADOR DE ARTICULOS DE CAUCHO	1
43878	OCUPACION	811007	CONDUCTOR DE MAQUINA DE ESTIRADO DE CAUCHO	1
43877	OCUPACION	811006	CAPATAZ O CONTRAMAESTRE DE LA FAB. DE PRODUCTOS DE CAUCHO	1
43876	OCUPACION	811005	CALANDRADOR DE CAUCHO	1
43875	OCUPACION	811004	ARMADOR DE PRODUCTOS DE CAUCHO	1
43874	OCUPACION	811003	AMASADOR DE CAUCHO	1
43873	OCUPACION	811002	ALISADOR DE PRODUCTOS DE CAUCHO	1
43872	OCUPACION	811001	ABARQUERO	1
43871	OCUPACION	799006	PREPARADOR DE FIBRA DE VIDRIO	1
43870	OCUPACION	799005	OPERADOR DE MAQUINA PARA FABRICAR LANA DE VIDRIO	1
43869	OCUPACION	799004	OPERADOR DE MAQUINA PARA FABRICAR FIBRA VIDRIO	1
43868	OCUPACION	799003	MEZCLADOR DE MATERIALES,FABRICACION DE VIDRIO	1
43867	OCUPACION	799002	HILADOR DE VIDRIO	1
43866	OCUPACION	799001	EXTRUSOR DE HILOS DE FIBRA DE VIDRIO	1
43865	OCUPACION	798012	VIDRIADOR DE CERAMICA	1
43864	OCUPACION	798011	TRAZADOR, DECORADO DE CERAMICA	1
43863	OCUPACION	798010	RETOCADOR, DECORADO DE CERAMICA	1
43862	OCUPACION	798009	PULIDOR DE CERAMICA DORADA	1
43861	OCUPACION	798008	PINTOR A PISTOLA,DE LOZA Y PORCELANA	1
43860	OCUPACION	798007	ILUMINADOR DE LOZA Y PORCELANA	1
43859	OCUPACION	798006	FILETERO, DECORADO DE CERAMICA	1
43858	OCUPACION	798005	ESMALTADOR DE CERAMICA	1
43857	OCUPACION	798004	ESMALTADOR DE VIDRIO	1
43856	OCUPACION	798003	DECORADOR DE VIDRIO	1
43855	OCUPACION	798002	DECORADOR DE CERAMICA	1
43854	OCUPACION	798001	AZOGADOR	1
43853	OCUPACION	797009	TALLADOR DE VIDRIO O CRISTAL	1
43852	OCUPACION	797008	TALLADOR DE CRISTALES-VIDRIOS,TALLA DECORATIVA	1
43851	OCUPACION	797007	PULIDOR DE VIDRIO O CRISTAL EN BAÐO DE ACIDO	1
43850	OCUPACION	797006	GRABADOR DE VIDRIO EN GENERAL	1
43849	OCUPACION	797005	GRABADOR DE CRISTAL EN GENERAL	1
43848	OCUPACION	797004	GRABADOR DE CERAMICA VIDRIADA	1
43847	OCUPACION	797003	GRABADOR DE AGUA FUERTE,CRISTAL	1
43846	OCUPACION	797002	ESMERILADOR VIDRIO O CRISTAL CON CHORRO DE ARENA	1
43845	OCUPACION	797001	ESMERILADOR CON CHORROS DE ARENA,VIDRIO	1
43844	OCUPACION	796016	TEMPLADOR DE VIDRIO	1
43843	OCUPACION	796015	PREPARADOR DE CAJA DE SECADO,HORNO DE CERAMICA	1
43842	OCUPACION	796014	OPERADOR DE SECADOR DE BRIQUETAS	1
43841	OCUPACION	796013	MOLDEADOR DE CRISOLES	1
43840	OCUPACION	796012	HORNERO,TEMPLADO DEL VIDRIO	1
43839	OCUPACION	796011	HORNERO,TEJAS Y LADRILLOS	1
43838	OCUPACION	796010	HORNERO,RECOCIDO DEL VIDRIO	1
43837	OCUPACION	796009	HORNERO,PORCELANA	1
43836	OCUPACION	796008	HORNERO,MATERIAL REFRACTARIO EXCEPTO TEJAS Y LADRILLOS	1
43835	OCUPACION	796007	HORNERO,LOZA Y PORCELANA	1
43834	OCUPACION	796006	HORNERO,FABRICACION DE VIDRIO	1
43833	OCUPACION	796005	HORNERO,CERAMICA	1
43832	OCUPACION	796004	HORNERO,BRIQUETAS	1
43831	OCUPACION	796003	FUNDIDOR VIDRIERO	1
43830	OCUPACION	796002	CARGADOR-DESCARGADOR DE HORNO,DE CERAMICA	1
43829	OCUPACION	796001	AYUDANTE DE HORNO DE CERAMICA,ENCENDIDO	1
43828	OCUPACION	795008	TEJERO Y ADOBERO A MANO	1
43827	OCUPACION	795007	PRENSADOR DE ADOBES CON TROQUEL	1
43826	OCUPACION	795006	PREPARADOR DE ADOBES	1
43825	OCUPACION	795005	OPERADOR PRENSA ALTA PRESION PARA LADRILLOS ESPECIALES	1
43824	OCUPACION	795004	OPERADOR DE MAQUINA DE CORTAR LADRILLOS Y TEJAS	1
43823	OCUPACION	795003	MOLDEADOR DE LADRILLOS Y BALDOSAS	1
43822	OCUPACION	795002	COLADOR DE LADRILLOS Y TEJAS	1
43821	OCUPACION	795001	ADOBERO	1
43820	OCUPACION	794027	VACIADOR DE CERAMICA EN MOLDES	1
43819	OCUPACION	794026	TORNERO EN TORNO DE PEDAL, LOZA Y PORCELANA	1
43818	OCUPACION	794025	TORNERO-ALFARERO EN TORNO DE PEDAL	1
43817	OCUPACION	794024	TAMIZADOR DE TIERRAS, CERAMICA	1
43816	OCUPACION	794023	TALADRADOR DE PIEZAS DE CERAMICA	1
43815	OCUPACION	794022	PREPARADOR CERAMICA EN MOLDES, PASTA DE ARCILLA	1
43814	OCUPACION	794021	PREPARADOR DE MOLDES, CERAMICA, LOZA Y PORCELANA	1
43813	OCUPACION	794020	PREPARADOR DE BARBOTIN	1
43812	OCUPACION	794019	PRENSADOR DE CERAMICA, CON TROQUEL	1
43811	OCUPACION	794018	OPERADOR DE PRENSA GALLETERA, CERAMICA	1
43810	OCUPACION	794017	OPERADOR DE PRENSA DE CERAMICA	1
43809	OCUPACION	794016	OPERADOR DE FILTRO PRENSA PARA ARCILLA(CERAMICA)	1
43808	OCUPACION	794015	MOLINERO,TIERRA DE LOZA	1
43807	OCUPACION	794014	MOLDEADOR MACHERO DE CERAMICA	1
43806	OCUPACION	794013	MOLDEADOR DE MUELAS ABRASIVAS	1
43805	OCUPACION	794012	MODELISTA DE CERAMICA	1
43804	OCUPACION	794011	MODELADOR AL TORNO CON TERRAJA,CERAMICA	1
43803	OCUPACION	794010	MEZCLADOR DE PASTA DE ABRASIVOS	1
43802	OCUPACION	794009	MACHERO-MOLDEADOR,CERAMICA	1
43801	OCUPACION	794008	EXTRUSOR DE ARCILLA,CERAMICA	1
43800	OCUPACION	794007	COLADOR DE CERAMICA,EXCEPTO DE ADOBE Y LADRILLO	1
43799	OCUPACION	794006	CINCELADOR DE PIEZAS DE CERAMICA	1
43798	OCUPACION	794005	CERAMISTA EN GRAL,EXCEPTO ADOBES,LADRILLOS,TEJAS	1
43797	OCUPACION	794004	CRIBADOR DE TIERRA, CERAMICA	1
43796	OCUPACION	794003	CERAMISTA MOLDES, A MANO EXCEPTO LADRILLOS, ADOBES, TEJAS	1
43795	OCUPACION	794002	AMASADOR DE CAOLIN,PORCELANA	1
43794	OCUPACION	794001	ALFARERO,EN GRAL,EXCEPTO LADRILLOS,ADOBES,TEJAS	1
43793	OCUPACION	793023	TALLADOR DE CRISTALES DE OPTICA	1
43792	OCUPACION	793022	SOPLADOR VIDRIO,MATERIAL LABORATORIO A MAQUINA	1
43791	OCUPACION	793021	PULIDOR DE LENTES	1
43790	OCUPACION	793020	PULIDOR DE CRISTALES	1
43789	OCUPACION	793019	PULIDOR A MAQUINA DE CRISTALES DE OPTICA	1
43788	OCUPACION	793018	OPERADOR VERTIDO VIDRIO FUNDIDO/VERTIDOR VIDRIO FUNDIDO	1
43787	OCUPACION	793017	OPERADOR EN PRENSA DE MOLDEAR VIDRIO	1
43786	OCUPACION	793016	OPERADOR MAQUINA ESTIRAR VIDRIO PLANO,VARILLAS O TUBO	1
43785	OCUPACION	793015	OPERADOR DE MAQUINA DE MOLDEAR O SOPLAR VIDRIO	1
43784	OCUPACION	793014	OPERADOR DE BANO METALICO POR FLOTACION VIDRIO	1
43783	OCUPACION	793013	MODELADOR DE LENTES	1
43782	OCUPACION	793012	LAMINADOR DE LUNAS DE VIDRIO	1
43781	OCUPACION	793011	ESMERILADOR DE LENTES A MAQUINA	1
43780	OCUPACION	793010	ESMERILADOR DE BORDES,VIDRIO	1
43779	OCUPACION	793009	DESBASTADOR, OPTICA EN ANTEOJERIA	1
43778	OCUPACION	793008	CURVADOR DE TUBOS DE VIDRIO	1
43777	OCUPACION	793007	CORTADOR DE VIDRIO	1
43776	OCUPACION	793006	CORTADOR, TALLADOR DE CRISTALES DE OPTICA	1
43775	OCUPACION	793005	CONDUCTOR DE MAQUINA DE ESTIRAR VIDRIO PLANO	1
43774	OCUPACION	793004	BISELADOR DE CRISTALES	1
43773	OCUPACION	793003	AFINADOR DE VIDRIO,OPTICA DE ANTEOJERIA	1
43772	OCUPACION	793002	AFINADOR A MAQUINA DE CRISTALES DE OPTICA	1
43771	OCUPACION	793001	ACABADOR DE BORDES,CRISTAL	1
43770	OCUPACION	792023	TREFILADOR DE METALES PRECIOSOS	1
43769	OCUPACION	792022	TORNERO-REPUJADOR ORFEBRERIA	1
43768	OCUPACION	792021	TALLADOR Y PULIDOR DE PIEDRAS PRECIOSAS	1
43767	OCUPACION	792020	REPUJADOR, OTRO JOYERO O PLATERO	1
43766	OCUPACION	792019	REPARADOR, DE JOYAS	1
43765	OCUPACION	792018	RECALCADOR DE METALES PRECIOSOS	1
43764	OCUPACION	792017	PLATERO Y ORFEBRE	1
43763	OCUPACION	792016	PLATERIA, GRABADOR	1
43762	OCUPACION	792015	ORFEBRERIA, CINCELADOR (JOYERO O PLATERO)	1
43761	OCUPACION	792014	ORFEBRE, JOYERO O PLATERO	1
43760	OCUPACION	792013	MONTADOR, ORFEBRERIA	1
43759	OCUPACION	792012	MONTADOR DE PIEDRAS PRECIOSAS	1
43758	OCUPACION	792011	MARTILLADOR DE METALES PRECIOSOS	1
43757	OCUPACION	792010	LAPIDARIO, TALLADOR Y PULIDOR DE PIEDRAS PRECIOSAS	1
43756	OCUPACION	792009	LAMINADOR DE METALES PRECIOSOS	1
43755	OCUPACION	792008	GRABADOR DE PLATERIA Y JOYERIA	1
43754	OCUPACION	792007	GRABADOR DE METALES PRECIOSOS	1
43753	OCUPACION	792006	FILIGRANISTA,JOYERO O PLATERO	1
43752	OCUPACION	792005	ESMALTADOR DE METALES PRECIOSOS	1
43751	OCUPACION	792004	ENGASTADOR	1
43750	OCUPACION	792003	DIAMANTISTA-PULIDOR Y TALLADOR DE PIEDRAS PRECIOSAS	1
43749	OCUPACION	792002	CINCELADOR-ORFEBRE	1
43748	OCUPACION	792001	BATIHOJA,JOYERO O PLATERO	1
43747	OCUPACION	791028	REPARADOR DE RELOJES	1
43746	OCUPACION	791027	RELOJERO	1
43745	OCUPACION	791026	MONTADOR DE INSTRUMENTOS DE PRECISION	1
43744	OCUPACION	791025	MONTADOR DE APARATOS FOTOGRAFICOS	1
43743	OCUPACION	791024	MECANICOS DE INSTRUMENTOS DE PRECISION	1
43742	OCUPACION	791023	MECANICO ORTOPEDISTA	1
43741	OCUPACION	791022	MECANICO DENTISTA	1
43740	OCUPACION	791021	MECANICO DE PROTESIS DENTALES	1
43739	OCUPACION	791020	MECANICO DE PROTESIS ORTOPEDICAS	1
43738	OCUPACION	791019	MECANICO DE INSTRUMENTO QUIRURGICOS	1
43737	OCUPACION	791018	MECANICO DE INSTRUMENTOS DE ODONTOLOGIA	1
43736	OCUPACION	791017	MECANICO DE INSTRUMENTOS DE LABORATORIO	1
43735	OCUPACION	791016	MECANICO DE INSTRUMENTOS DE OPTICA	1
43734	OCUPACION	791015	MECANICO DE CAMARAS FOTOGRAFICAS	1
43733	OCUPACION	791014	MECANICO DE BALANZAS	1
43732	OCUPACION	791013	MECANICO, AJUSTADOR DE MAQUINARIA EN GENERAL	1
43731	OCUPACION	791012	MECANICO-MONTADOR MAQUINA, EQUIPO INDUSTRIAL, AIRE ACONDICI	1
43730	OCUPACION	791011	INSTRUMENTISTA, INSTRUMENTOS DE PRECISION	1
43729	OCUPACION	791010	CONSTRUCTOR DE BAROMETROS, TERMOMETROS	1
43728	OCUPACION	791009	CONSTRUCTOR DE BALANZAS	1
43727	OCUPACION	791008	CONSTRUCTOR DE BRUJULAS	1
43726	OCUPACION	791007	AJUSTADOR-MONTADOR EXCEPTO MOTORES COMBUS. INTERNA	1
43725	OCUPACION	791006	AJUSTADOR-MONTADOR DE MOTORES AVION,REACCION	1
43724	OCUPACION	791005	AJUSTADOR-MONTADOR DE MOTORES MARINOS	1
43723	OCUPACION	791004	AJUSTADOR, MONTADOR DE MOTORES DE COMBUST.INT.(EX.MOT.AVION	1
43722	OCUPACION	791003	AJUSTADOR, MONTADOR DE MOTORES DIESEL	1
43721	OCUPACION	791002	AJUSTADOR, MONTADOR DE MOTORES A GASOLINA	1
43720	OCUPACION	791001	ARREGLO DE MAQUINA DE ESCRIBIR, CALCULADORAS, ETC.	1
43719	OCUPACION	785043	TUBERO EN GENERAL, DISTRIBUCION GAS, AIRE A PRESION, VAPOR	1
43718	OCUPACION	785042	TRAZADOR DE GALIBOS, ASTILLEROS	1
43717	OCUPACION	785041	TRAZADOR DE ESTRUCTURAS METALICAS	1
43716	OCUPACION	785040	TRAZADOR DE PLANCHAS Y CHAPAS METALICAS	1
43715	OCUPACION	785039	TRAZADOR DE CALDERERIA Y CHAPAS	1
43714	OCUPACION	785038	SOLDADOR DE CAUTIN (CAUTIL)	1
43713	OCUPACION	785037	SOLDADOR N.E.O.P.	1
43712	OCUPACION	785036	SOPLETISTA SOLDADOR	1
43711	OCUPACION	785035	SOPLETISTA DE CORTE, A MANO	1
43710	OCUPACION	785034	SOLDADOR CON SOPLETE Y POR ARCO ELECTRICO,GRAL	1
43709	OCUPACION	785033	SOLDADOR-PLOMERO	1
43708	OCUPACION	785032	REPLANTEADOR DE ESTRUCTURAS, METALICAS	1
43707	OCUPACION	785031	REMACHADOR, MANO O MAQ. PLANCHAS MET., MARTILLO NEU.	1
43706	OCUPACION	785030	REBLONADOR PLANCHAS METAL, A MANO O MAQ., PLANCHA	1
43705	OCUPACION	785029	PREPARADOR DE ESTRUCTURAS DE ACERO EN TALLER	1
43704	OCUPACION	785028	PLOMERO	1
43703	OCUPACION	785027	PLANCHADOR DE CARROCERIAS DE VEHICULOS	1
43702	OCUPACION	785026	OPERARIO DE OXICORTE	1
43701	OCUPACION	785025	OPERARIO DE MESA DE CORTE, OXICORTADOR	1
43700	OCUPACION	785024	OXICORTADOR EN GENERAL, A MANO O A MAQUINA	1
43699	OCUPACION	785023	OPERADOR DE GASOMETRO	1
43698	OCUPACION	785022	MONTADOR DE PLANCHAS,ASTILLEROS	1
43697	OCUPACION	785021	MONTADOR ESTRUCTURAS DE ACERO,EXCEPTO BUQUES	1
43696	OCUPACION	785020	MONTADOR CONSTRUCC. METALICAS, EXCEPTO BUQUES	1
43695	OCUPACION	785019	MONTADOR DE CALDERAS	1
43694	OCUPACION	785018	INSTALADOR TUBERIAS,EN GRAL,GAS,BARCOS,AVIONES	1
43693	OCUPACION	785017	HOJALATERO O CHAPISTA	1
43692	OCUPACION	785016	GASFITERO	1
43691	OCUPACION	785015	FONTANERO,EN GENERAL	1
43690	OCUPACION	785014	CHAPISTA EN GRAL., CALDERO, HOJALATERO, DECORACION	1
43689	OCUPACION	785013	CORTADOR DE METALES CON SOPLETE	1
43688	OCUPACION	785012	CONDUCTOR DE MAQUINA DE SOLDAR POR ARCO ELECTRICO	1
43687	OCUPACION	785011	CORROCERO DE AUTOMOVILES	1
43686	OCUPACION	785010	CARROCERO, AUTOMOVILES, AVIONES Y OTROS	1
43685	OCUPACION	785009	CALENTADOR AL ROJO DE REMACHES	1
43684	OCUPACION	785008	CALDERERO, COBRE Y ALEACIONES LIGERAS CHAPAS ACERO	1
43683	OCUPACION	785007	AYUDANTE DE REMACHADOR DE ESTRUCTURAS METALICAS	1
43682	OCUPACION	785006	AYUDANTE DE HOJALATERIA	1
43681	OCUPACION	785005	ARMADOR DE BARCOS	1
43680	OCUPACION	785004	ARMADOR HIERRO Y ACERO, BLINDAJE, CONSTRUC NAVALES	1
43679	OCUPACION	785003	ARMADOR DE ESTRUCTURAS DE ACERO	1
43678	OCUPACION	785002	ARMADOR DE CAJAS DE ACERO EN TALLER	1
43677	OCUPACION	785001	AJUSTADOR DE TUBERIAS EN GENERAL, DE GAS, EN AVIONES	1
43676	OCUPACION	784014	OPERADOR DE VIDEO O BETAMAX	1
43675	OCUPACION	784013	OPERADOR EQUIPO DE AMPLIFICACION DE SONIDO	1
43674	OCUPACION	784012	OPERADOR DE EQUIPO DE GRABACION O REG. DE SONIDO	1
43673	OCUPACION	784011	OPERADOR DE CABINA, CINEMATOGRAFICA, SALAS CINE	1
43672	OCUPACION	784010	OPERADOR DE APARATO DE PROYECCION,CINE	1
43671	OCUPACION	784009	OPERADOR DE VIDEO	1
43670	OCUPACION	784008	OPERADOR DE RADIO Y TELEVISION	1
43669	OCUPACION	784007	OPERADOR DE IMAGEN DE TELEVISION	1
43668	OCUPACION	784006	OPERADOR DE ESTACION EMISORA RADIO Y TV,DE EQUIPO	1
43667	OCUPACION	784005	OPERADOR ESTACION EMISORA DE RADIO Y TV	1
43666	OCUPACION	784004	OPERADOR EQUIPO ESTUDIOS RADIODIFUSION O TV	1
43665	OCUPACION	784003	OPERADOR DE EQUIPO DE TRANSMISION DE RADIO Y TV	1
43664	OCUPACION	784002	OPERADOR DE APARATOS DE ESTUDIOS DE RADIO Y TV	1
43663	OCUPACION	784001	CONTROLADOR DE SONIDO,ESTUDIOS DE RADIO Y TV	1
43662	OCUPACION	783052	REPARADOR INSTALACIONES DE TELEFONICOS Y TELEGRAFOS	1
43661	OCUPACION	783051	REPARADOR ELECTRICISTA DE APARATOS ELECTRODOMESTICOS	1
43660	OCUPACION	783050	REPARADOR DE APARATOS ELECTRODOMESTICOS	1
43659	OCUPACION	783049	RADIO TECNICO REPARACIONES DE RADIO Y TV	1
43658	OCUPACION	783048	REPARADOR DE RECEPTORES DE RADIO Y TV	1
43657	OCUPACION	783047	MONTADOR DE LINEAS SUBTERRANEOS	1
43656	OCUPACION	783046	MONTADOR DE LINEAS TELEFONICAS Y TELEGRAFICAS	1
43655	OCUPACION	783045	MONTADOR DE LINEAS CATENARIAS	1
43654	OCUPACION	783044	MONTADOR LINEAS AEREAS PARA TRANSPORTE DE CORRIENTE	1
43653	OCUPACION	783043	MONTADOR DE CABLES SUBTERRANEAS	1
43652	OCUPACION	783042	MONTADOR CABLES DE TRANSPORTE DE ENERGIA ELECTRICA	1
43651	OCUPACION	783041	MONTADOR DE TUBOS ELECTRONICOS	1
43650	OCUPACION	783040	MONTADOR DE RADIOS	1
43649	OCUPACION	783039	MONTADOR O ENSAMBLADOR APARATOS ELECT. Y ELECTRO.	1
43648	OCUPACION	783038	MONTADOR, ASCENSORES Y EQUIPO SIMILAR	1
43647	OCUPACION	783037	MONTADOR ELECTRICISTA, AJUSTADOR EN GENERAL	1
43646	OCUPACION	783036	MONTADOR DE INSTALACIONES TELEFONICAS Y TELEGRAFO	1
43645	OCUPACION	783035	MECANICO REPARADOR DE TELEFONOS Y TELEGRAFOS	1
43644	OCUPACION	783034	MECANICO DE TELEFONO Y TELEGRAFOS	1
43643	OCUPACION	783033	MECANICO-REPARADOR DE RECEPTORES RADIO Y TV	1
43642	OCUPACION	783032	INSTALADOR DE LINEAS DE TELECOMUNICACIONES	1
1938	PAIS	188	COSTA RICA	1
43641	OCUPACION	783031	INSTALADOR LINEAS ELECTRICAS Y TELECOMUNICACIONES	1
43640	OCUPACION	783030	INSTALADOR DE LINEAS SUBTERRANEOS	1
43639	OCUPACION	783029	INSTALADOR DE CABLES DE TELEFONOS Y TELEGRAFOS	1
43638	OCUPACION	783027	INSTALADOR CABLES PARA TRACCION VEHICULOS ELECT.	1
43637	OCUPACION	783026	INSTALADOR DE CABLES	1
43636	OCUPACION	783025	INSTALADOR DE LINEAS ELECTRICAS PARA TRACCION	1
43635	OCUPACION	783024	INSTALADOR DE CABLES DE ENERGIA ELECTRICA	1
43634	OCUPACION	783023	INSTALADOR LINEAS ENERGIA ELECTRICA, TENDIDO AEREO	1
43633	OCUPACION	783022	INSTALADOR CABLES PARA LA ELECTRIFICACION FERROCARRILES	1
43632	OCUPACION	783021	INSTALADOR DE TELEFONOS Y TELEGRAFOS	1
43631	OCUPACION	783020	INSTALADOR DE ANTENAS DE RADIO Y TELEVISION	1
43630	OCUPACION	783019	INSTALADOR ELECTRICISTA,ASCENSORES Y EQUIPO SIMILAR	1
43629	OCUPACION	783018	INSPECTOR DE DISTINTIVO DE CALIDAD	1
43628	OCUPACION	783017	INSPECTOR CALIDAD APARAT. ELECTRIC. Y ELECTRONICOS	1
43627	OCUPACION	783016	INSPECTOR CONTROL CALIDAD, EQUIPO. ELECTRIC. Y ELECTRONICOS	1
43626	OCUPACION	783015	EMPALMADOR DE CABLES ELECTRICOS	1
43625	OCUPACION	783014	ELECTRICISTA DE VEHICULOS	1
43624	OCUPACION	783013	ELECTRICISTA DE BARCOS Y AVIONES	1
43623	OCUPACION	783012	ELECTRICISTAS GRAL., CONSTRUC. INSTAL. ELEC., CINE	1
43622	OCUPACION	783011	ELECTRICISTA-MONTADOR,AIRE ACONDICIONADO	1
43621	OCUPACION	783010	ELECTRICISTA BOBINADOR	1
43620	OCUPACION	783009	DEBANADOR, ELECTRICISTA	1
43619	OCUPACION	783008	CONTROLADOR CALIDAD APARAT. ELECTRIC. Y ELECTRONICOS	1
43618	OCUPACION	783007	BOBINADOR ELECTRICISTA	1
43617	OCUPACION	783006	AJUSTADOR ELECTRONICISTA	1
43616	OCUPACION	783005	AJUSTADORES ELECTRICISTAS ASCENSORES Y SIMILARES	1
43615	OCUPACION	783004	AJUSTADORES ELECTRICISTAS EQUIPOS CENTRALES ELECTRICOS	1
43614	OCUPACION	783003	AJUSTADORES ELECTRICISTAS DE TRANSFORMADORES	1
43613	OCUPACION	783002	AJUSTADORES ELECTRICISTAS DE MOTORES Y DINAMOS	1
43612	OCUPACION	783001	AJUSTADOR ELECTRICISTA EN GENERAL	1
43611	OCUPACION	782017	SAMUELLES-MUELLERO	1
43610	OCUPACION	782016	REVISOR Y PROBADOR DE MAQUINARIA	1
43609	OCUPACION	782015	REPARADOR DE BICICLETAS	1
43608	OCUPACION	782014	PROBADOR DE AUTOMOVILES,REPARACIONES	1
43607	OCUPACION	782013	MONTADOR DE MANUFACTURAS METALICAS	1
43606	OCUPACION	782012	MECANICO REPARADOR DE BICICLETAS	1
43605	OCUPACION	782011	MECANICO ENGRASADOR,EXCEPTO BARCOS	1
43604	OCUPACION	782010	MECANICO DE TURBINAS,EXCEPTO TURBINAS DE AVION	1
43603	OCUPACION	782009	MECANICO MOTORES DIESEL,EXCEPTO MOTOR AUTOMOVILES Y CAMIONE	1
43602	OCUPACION	782008	MECANICO DE MAQUINAS EN GENERAL: AGRICULTURA, OFICINA, TEXT	1
43601	OCUPACION	782007	MECANICO DE SALA DE MAQUINAS DE BARCOS	1
43600	OCUPACION	782006	MECANICO NAVAL	1
43599	OCUPACION	782005	MECANICO DE MOTORES DE BARCOS,EN GENERAL	1
43598	OCUPACION	782004	MECANICO DE MOTORES DE AVION,EN GENERAL	1
43597	OCUPACION	782003	MECANICO DE DIRECCION Y FRENOS DE AUTOMOVILES	1
43596	OCUPACION	782002	MECANICO AUTOMOVILES, CAMIONES, MOTOCICLETAS, AUTOBUS, TRAC	1
43595	OCUPACION	782001	AYUDANTE DE MECANICO DE VEHICULOS DE MOTOR	1
43594	OCUPACION	781069	CARPINTERO MECANICO	1
43593	OCUPACION	781068	TORNERO DE EMBUTIR	1
43592	OCUPACION	781067	TORNERO,LABRA DE METALES	1
43591	OCUPACION	781066	TRAZADOR EN METALES	1
43590	OCUPACION	781065	TALADRISTA	1
43589	OCUPACION	781064	REGULADOR-OPERADOR DE TORNO AUTOMATICO DE METAL	1
43588	OCUPACION	781063	REGUL-OPERAD REVOLVERES PARA EL TRABAJO DE METALES	1
43587	OCUPACION	781062	REGULADORES DE MAQUINA HERRAMIENTAS, EN GENERAL	1
43586	OCUPACION	781061	RECTIFICADOR DE CILINDROS,TRABAJO DE METALES	1
43585	OCUPACION	781060	RECTIFICADOR DE METALES	1
43584	OCUPACION	781059	PULIDOR DE METALES, A MANO	1
43583	OCUPACION	781058	PULIDOR DE METALES, A MAQUINA	1
43582	OCUPACION	781057	OPERADOR DE TORNO DE EMBUTIR	1
43581	OCUPACION	781056	OPERADOR DE TIJERA MECANICA	1
43580	OCUPACION	781055	OPERADOR DE PRENSA MECANICA,DE METALES	1
43579	OCUPACION	781054	OPERADOR DE MAQUINA DE CURVAR METALES	1
43578	OCUPACION	781053	OPERADOR DE CIZALLA MECANICA	1
43577	OCUPACION	781052	OBREROS FCION MUELLES, CLAVOS, TORNILLOS, CABLES	1
43576	OCUPACION	781051	OBREROS DE LA MANUFACTURA A MANO DE PZAS METAL	1
43575	OCUPACION	781050	OPERADOR DE MAQUINAS PARA FABRICAR TORNILLOS	1
43574	OCUPACION	781049	OPERADOR DE TALADRADORA DE METAL	1
43573	OCUPACION	781048	OPERADOR DE SIERRA MECANICA DE METALES	1
43572	OCUPACION	781047	OPERADOR DE MAQUINA LAPIADORA DE METALES	1
43571	OCUPACION	781046	OPERADOR DE MAQUINA DE TALLAR ENGRANAJES	1
43570	OCUPACION	781045	OPERADOR DE MAQUINA DE TRANSFERENCIA AUTOMATICA	1
43569	OCUPACION	781044	OPERADOR DE MAQUINA DE FUNCION MULTIPLE	1
43568	OCUPACION	781043	OPERADOR DE MAQUINAS HERRAMIENTAS EN GENERAL	1
43567	OCUPACION	781042	OPERADOR DE ESCOPLEADORA	1
43566	OCUPACION	781041	OPERADOR DE ESMERILADORA	1
43565	OCUPACION	781040	OPERADOR MAQUINAS HERRAMIENTA AUTOMATICA MANDO NUMERICO	1
43564	OCUPACION	781039	MODELISTA-AJUSTADOR, FUNDICION	1
43563	OCUPACION	781038	MECANICO ESPECIALISTA EN HERRAMIENTAS Y MATRICES	1
43562	OCUPACION	781037	MECANICO-AJUSTADOR	1
43561	OCUPACION	781036	MARTILLADOR-HERRERIA	1
43560	OCUPACION	781035	MANDRILERO	1
43559	OCUPACION	781034	MANDRILADOR	1
43558	OCUPACION	781033	LLAVERERO	1
43557	OCUPACION	781032	HERRERO,EN GENERAL	1
43556	OCUPACION	781031	HERRADOR,HERRERO	1
43555	OCUPACION	781030	HERRAMENTISTA	1
43554	OCUPACION	781029	FORJADOR	1
43553	OCUPACION	781028	FRESADOR	1
43552	OCUPACION	781027	ESCOPETERO	1
43551	OCUPACION	781026	CONFECCIONADOR A MANO DE PIEZAS DE METAL	1
43550	OCUPACION	781025	COMBERO	1
43549	OCUPACION	781024	CERRAJERO	1
43548	OCUPACION	781023	CEPILLADOR DE METALES	1
43547	OCUPACION	781022	CARPINTERIA METALICA	1
43546	OCUPACION	781021	ARMERO	1
43545	OCUPACION	781020	AMOLADOR DE SIERRAS	1
43544	OCUPACION	781019	AFILADOR EN GENERAL	1
43543	OCUPACION	781018	AYUDANTE DE HERRERO	1
43542	OCUPACION	781017	AJUSTADOR-OPERADOR DE MAQUINAS DE MECANISMO NUMERICO DE CON	1
43541	OCUPACION	781016	AJUSTADOR-OPERADOR DE MAQUINA MORTAJADORA	1
43540	OCUPACION	781015	AJUSTADOR-OPERADOR DE MAQ. DE TALLAR ENGRANAJES	1
43539	OCUPACION	781014	AJUSTADOR-OPERADOR DE TORNO DE ROSCAR	1
43538	OCUPACION	781013	AJUSTADOR-OPERADOR DE ESCOPLEADORA DE METALES	1
43537	OCUPACION	781012	AJUSTADOR-OPERADOR DE MAQUINA DE LAPIDAR	1
43536	OCUPACION	781011	AJUSTADOR-OPERADOR DE ESMERILADORA DE METALES	1
43535	OCUPACION	781010	AJUSTADOR-OPERADOR RECTIFICADORA, INCLUYE CILINDROS Y METAL	1
43534	OCUPACION	781009	AJUSTADOR-OPERADOR DE TALADRADORA	1
43533	OCUPACION	781008	AJUSTADOR-OPERADOR MANDRILADORA DE METALES	1
43532	OCUPACION	781007	AJUSTADOR-OPERADOR CEPILLADORA, INCLUYE METALES	1
43531	OCUPACION	781006	AJUSTADOR-OPERADOR DE FRESADORA,INCLUYE DE METAL	1
43530	OCUPACION	781005	AJUSTADOR-OPERADOR DE TORNO	1
43529	OCUPACION	781004	AJUSTADOR-OPERADOR MAQ. HERRAMIENTAS, EN GENERAL	1
43528	OCUPACION	781003	AJUSTADOR-MODELISTAS Y TRAZADORES MATRICES EN METAL	1
43527	OCUPACION	781002	AJUSTADOR DE MANDRILES Y CALIBRADORES	1
43526	OCUPACION	781001	AJUSTADOR-MODELISTA,FUNDICION	1
43525	OCUPACION	779009	PARAGUERO	1
43524	OCUPACION	779008	GUARNECEDOR CON PLUMAS DE ADORNO	1
43523	OCUPACION	779007	CONFECCIONADOR DE PLUMEROS DE TELA	1
43522	OCUPACION	779006	CONFECCIONADOR DE FLORES ARTIFICIALES(DE TELA)	1
43521	OCUPACION	779005	CONFECCIONADOR DE CALZADO DE LONA	1
43520	OCUPACION	779004	CONFECCIONADOR DE CALZADO DE CAÐAMO	1
43519	OCUPACION	779003	CONFECCIONADOR DE BOLSAS DE HILO	1
43518	OCUPACION	779002	CONFECCIONADOR DE ALFOMBRAS DE NUDOS A MANO	1
43517	OCUPACION	779001	CONFECCIONADOR DE VELAS,CARPAS Y TOLDOS	1
43516	OCUPACION	778040	TUPISTA, LABRA DE MADERA	1
43515	OCUPACION	778039	TRAZADOR, LABRADO DE MADERA	1
43514	OCUPACION	778038	TRAZADOR DE EBANISTERIA	1
43513	OCUPACION	778037	TORNERO,LABRA DE MADERA	1
43512	OCUPACION	778036	TONELERO	1
43511	OCUPACION	778035	TALLISTA, MADERA	1
43510	OCUPACION	778034	TALLADOR DE MADERA	1
43509	OCUPACION	778033	RESTAURADOR DE ARTICULOS DE MADERA	1
43508	OCUPACION	778032	PIPERO, PIPAS DE FUMAR	1
43507	OCUPACION	778031	OPERADOR DE MAQUINAS DE LABRAR, EN GENERAL	1
43506	OCUPACION	778030	OPERADOR DE MAQ. DE LABRAR MADERA,EN GENERAL	1
43505	OCUPACION	778029	MUEBLISTA DE MADERA EN GENERAL	1
43504	OCUPACION	778028	MODELISTA EN MADERA	1
43503	OCUPACION	778027	MAQUETISTA EN MADERA	1
43502	OCUPACION	778026	LAQUEADOR DE MUEBLES DE MADERA	1
43501	OCUPACION	778025	EBANISTA O CARPINTERO EN MADERA, EXCEPTO CONSTRUCCION	1
43500	OCUPACION	778024	EBANISTAS DE ESTUCHES PARA INSTRUMENTOS	1
43499	OCUPACION	778023	EBANISTA DE PIANOS	1
43498	OCUPACION	778022	EBANISTA DE MESA DE BILLAR	1
43497	OCUPACION	778021	EBANISTA, MARQUETERIA	1
43496	OCUPACION	778020	CURVADOR DE MADERA	1
43495	OCUPACION	778019	CONSTRUCTOR DE KIOSCOS DE MADERA	1
43494	OCUPACION	778018	CONSTRUCTOR DE ATAUDES	1
43493	OCUPACION	778017	CONSTRUCTOR DE CARRETAS O CARRETILLAS(MADERA)	1
43492	OCUPACION	778016	CONFECCIONADOR DE ARTICULOS MADERA PARA DEPORTE	1
43491	OCUPACION	778015	CONFECCIONADOR MUEBLES MADERA PARA EL HOGAR U OFICINA	1
43490	OCUPACION	778014	CHAROLADOR	1
43489	OCUPACION	778013	CHAPEADOR DE MUEBLES DE MADERA	1
43488	OCUPACION	778012	CEPILLADOR DE MADERA	1
43487	OCUPACION	778011	CARROCERO, CARROCERIAS DE MADERA	1
43486	OCUPACION	778010	ACABADOR DE MUEBLES DE MADERA	1
43485	OCUPACION	778009	AJUSTADOR DE MAQ. DE LABRAR MADERA EN GENERAL	1
43484	OCUPACION	778008	AJUST-OPERAD FRESADORA-GRABADORA, LABRA DE MADERA	1
43483	OCUPACION	778007	AJUSTADOR-OPERADOR TORNO AUTOMATICO, LABRA MADERA	1
43482	OCUPACION	778006	AJUSTADOR-OPERADOR DE SIERRA MECANICA DE PRECISION	1
43481	OCUPACION	778005	AJUSTADOR-OPERADOR DE MAQ. LABRAR MADERA EN GRAL	1
43480	OCUPACION	778004	AJUSTADOR-OPERADOR TORNO, LABRA DE MADERA	1
43479	OCUPACION	778003	AJUSTADOR-OPERADOR RANURADORA, LABRA DE MADERA	1
43392	OCUPACION	769027	PRENSADOR DE TABACO DE MASCAR	1
43478	OCUPACION	778002	AJUSTADOR-OPERADOR MOLDURADORA, LABRA DE MADERA	1
43477	OCUPACION	778001	AJUSTADOR-OPERADOR DE CEPILLADORA, LABRA MADERA	1
43476	OCUPACION	777017	ZAPATERO ORTOPEDISTA	1
43475	OCUPACION	777016	PREPARADOR DE SUELAS	1
43474	OCUPACION	777015	PREPARADOR DE PALAS DE CALZADO	1
43473	OCUPACION	777014	PATRONISTA DEL CALZADO	1
43472	OCUPACION	777013	MONTADOR DE SUELAS	1
43471	OCUPACION	777012	MONTADOR DE PALAS DE CALZADO	1
43470	OCUPACION	777011	LIJADOR DE CANTOS, CALZADO	1
43469	OCUPACION	777010	HORMERO, ARMADOR DE CALZADO	1
43468	OCUPACION	777009	GUARNECEDOR DE CALZADO	1
43467	OCUPACION	777008	DESPUNTADOR DE SUELAS	1
43466	OCUPACION	777007	COSEDOR DE CALZADO, A MAQUINA	1
43465	OCUPACION	777006	CORTADOR DE SUELAS	1
43464	OCUPACION	777005	CORTADOR DE PALAS DE CALZADO, A MAQUINA O A MANO	1
43463	OCUPACION	777004	CORTADOR EMPEINES CALZADO, A MAQUINA O A MANO	1
43462	OCUPACION	777003	ARMADOR DE CALZADO	1
43461	OCUPACION	777002	APARADOR DE CALZADO	1
43460	OCUPACION	777001	ACABADOR DE CALZADO	1
43459	OCUPACION	776012	TROQUILADOR DE CUEROS	1
43458	OCUPACION	776011	TALABARTERO	1
43457	OCUPACION	776010	REPUJADOR DE CUEROS	1
43456	OCUPACION	776009	MONTADOR DE ARTICULOS DE CUERO	1
43455	OCUPACION	776008	MARROQUINERO, FABRICACION DE ARTICULOS DE CUERO	1
43454	OCUPACION	776006	MALETERO, CUERO O MARROQUIN	1
43453	OCUPACION	776005	GUARNICIONERO	1
43452	OCUPACION	776004	CORTADOR DE CUEROS, CONFECCIONES DE ARTICULOS	1
43451	OCUPACION	776003	COSEDOR DE CUERO (MALETAS, CARTERAS, BOLSAS)	1
43450	OCUPACION	776002	ARTESANO DEL CUERO, EN GENERAL	1
43449	OCUPACION	776001	ABORNADOR DE CUEROS	1
43448	OCUPACION	775007	TAPICERO DE VEHICULOS	1
43447	OCUPACION	775006	TAPICERO DE MUEBLES	1
43446	OCUPACION	775005	CONFECCIONADOR DE EDREDONES	1
43445	OCUPACION	775004	CONFECCIONADOR DE ROPA DE TAPICERIA	1
43444	OCUPACION	775003	CONFECCIONADOR DE CORTINAS	1
43443	OCUPACION	775002	CONFECCIONADOR DE COLCHAS	1
43442	OCUPACION	775001	COLCHONERO	1
43441	OCUPACION	774013	TRAZADOR DE PRENDAS DE VESTIR, LENCERIA	1
43440	OCUPACION	774012	PATRONISTA DE TELA DE PARAGUAS	1
43439	OCUPACION	774011	PATRONISTA DE VELAS DE EMBARCACIONES	1
43438	OCUPACION	774010	PATRONISTA TIENDAS CAMPAÐA,TOLDOS,SOMBRILLAS	1
43437	OCUPACION	774009	PATRONISTA DE ROPA BLANCA	1
43436	OCUPACION	774008	PATRONISTA PRENDAS VESTIR, LENCERIA, SOMBREROS, GORROS	1
43435	OCUPACION	774007	CORTADOR, SASTRERIA	1
43434	OCUPACION	774006	CORTADOR DE VELAS DE EMBARCACIONES	1
43433	OCUPACION	774005	CORTADOR DE VESTIDOS, INCLUSIVE DE CUERO Y PIEL	1
43432	OCUPACION	774004	CORTADOR DE TOLDOS Y SOMBRILLAS, TIENDAS CAMPAÐA	1
43431	OCUPACION	774003	CORTADOR ROPA BLANCA, TAPICERIA, TELAS PARAGUAS	1
43430	OCUPACION	774002	CORTADOR PRENDAS VESTIR,INCLUSIVE CUERO Y PIEL	1
43429	OCUPACION	774001	CORTADOR DE GUANTES	1
43428	OCUPACION	773003	SOMBRERERO,INCLUSIVE DE SOMBREROS DE PAJA	1
43427	OCUPACION	773002	OPERADOR DE MAQUINAS DE SOMBREROS DE FIELTRO	1
43426	OCUPACION	773001	ACABADOR Y ADORNADOR DE SOMBREROS	1
43425	OCUPACION	772011	PELETERO	1
43424	OCUPACION	772010	MANGUITERO O PELETERO	1
43423	OCUPACION	772009	ESCOGEDOR Y COMBINADOR DE PIELES VALIOSAS	1
43422	OCUPACION	772008	COSEDOR A MAQUINA-REMALLADORES	1
43421	OCUPACION	772007	COSEDOR A MANO DE PRENDAS DE PELETERIA	1
43420	OCUPACION	772006	COSEDOR A MANO PRENDAS VESTIR,EXCEPTO CALZADO CUERO	1
43419	OCUPACION	772005	COSEDOR A MANO Y A MAQUINA, EN GENERAL	1
43418	OCUPACION	772004	COMBINADOR DE PIELES VALIOSAS	1
43417	OCUPACION	772003	CLAVADOR DE PIELES	1
43416	OCUPACION	772002	BORDADORES A MANO O A MAQUINA EN GENERAL	1
43415	OCUPACION	772001	ACABADOR DE TRABAJOS DE PELETERIA	1
43414	OCUPACION	771011	SASTRE, CORTADOR	1
43413	OCUPACION	771010	SASTRE, A MEDIDA	1
43412	OCUPACION	771009	SASTRE, CONFECCION EN SERIE	1
43411	OCUPACION	771008	PANTALONERO, CONFECCION EN SERIE	1
43410	OCUPACION	771007	MODISTON, MODISTO	1
43409	OCUPACION	771006	MODISTA DE TEATRO	1
43408	OCUPACION	771005	MAESTRO DE AGUJA Y MESA,SASTRE	1
43407	OCUPACION	771004	CHALEQUERO,CONFECCION EN SERIE	1
43406	OCUPACION	771003	COSTURERA-MODISTA	1
43405	OCUPACION	771002	CORSETERA	1
43404	OCUPACION	771001	CAMISERA	1
43403	OCUPACION	769038	TORCEDOR DE TABACO A MAQ. ELABORACION DE CIGARROS	1
43402	OCUPACION	769037	TORCEDOR DE TABACO A MANO,ELABORACION CIGARROS	1
43401	OCUPACION	769036	TERREFACTOR DE TABACO	1
43400	OCUPACION	769035	TENDEDOR DE TABACO	1
43399	OCUPACION	769034	REZAGADOR DE CAPA, ELABORACION DE CIGARROS	1
43398	OCUPACION	769033	REZAGADOR DE CAPOTE, ELABORACION DE CIGARRILLOS	1
43397	OCUPACION	769032	REZAGADOR, FERMENTADO DEL TABACO	1
43396	OCUPACION	769031	REFRESCADOR DE TABACO	1
43395	OCUPACION	769030	PURERO A MANO	1
43394	OCUPACION	769029	PREPARADOR DE PICADURA DE TABACO PARA PIPA	1
43393	OCUPACION	769028	PREPARADOR DE RAPE	1
43391	OCUPACION	769026	PRENSADOR DE CIGARRILLOS	1
43390	OCUPACION	769025	PICADOR DE TABACO	1
43389	OCUPACION	769024	OREADOR DE TABACO	1
43388	OCUPACION	769023	OPERADOR DE MAQUINA DE EMBOLSAR CIGARRILLOS	1
43387	OCUPACION	769022	OPERADOR MAQ. ESTAMPAR MARCAS DE LOS CIGARRILLOS	1
43386	OCUPACION	769021	OPERADOR DE MAQUINA DE HACER FILTROS CIGARRILLOS	1
43385	OCUPACION	769020	OPERADOR DE MAQUINA DE HACER CIGARRILLOS	1
43384	OCUPACION	769019	OPERADOR DE MAQUINA SECADORA DE TABACO	1
43383	OCUPACION	769018	OPERADOR DE MAQUINA DE PICAR TABACO	1
43382	OCUPACION	769017	MOJADOR DE TABACO	1
43381	OCUPACION	769016	MEZCLADOR DE TABACO	1
43380	OCUPACION	769015	LIGADOR DE TABACO	1
43379	OCUPACION	769014	LAMINADOR DE VENA,TABACO	1
43378	OCUPACION	769013	HUMECTADOR DE TABACO	1
43377	OCUPACION	769012	ESCOGEDOR DE TABACO	1
43376	OCUPACION	769011	ENFRIADOR DE TABACO	1
43375	OCUPACION	769010	DESVENADOR DE TABACO A MAQUINA	1
43374	OCUPACION	769009	DESVENADOR DE TABACO A MANO	1
43373	OCUPACION	769008	DESPALILLADOR DE TABACO A MAQUINA	1
43372	OCUPACION	769007	DESPALILLADOR DE TABACO A MANO	1
43371	OCUPACION	769006	CLASIFICADOR DE TABACO	1
43370	OCUPACION	769005	CLASIFICADOR DE CIGARROS	1
43369	OCUPACION	769004	CIGARRERO A MAQUINA	1
43368	OCUPACION	769003	CIGARRERO A MANO	1
43367	OCUPACION	769002	ACONDICIONADOR DE TABACO	1
43366	OCUPACION	769001	ABRIDOR DE CAPA Y CAPILLOS,ELABORACION CIGARRO	1
43365	OCUPACION	768019	PREPARADOR DE TAMALES	1
43364	OCUPACION	768018	TOSTADOR DE CACAHUATES O ALMENDRAS	1
43363	OCUPACION	768017	REFINADOR DE ACEITES Y GRASAS	1
43362	OCUPACION	768016	PREPARADOR DE MARGARINA	1
43361	OCUPACION	768015	PESCADERO, LIMPIADOR DE PESCADO	1
43360	OCUPACION	768014	PELADOR DE MANI	1
43359	OCUPACION	768013	PELADOR DE CAMARONES	1
43358	OCUPACION	768012	OPERADOR DE MAQ. COAGULADORA, GRASA VEGETALES	1
43357	OCUPACION	768011	OPERADOR DE HIDROGENADORA, ACEITE Y DERIVADOS	1
43356	OCUPACION	768010	OPERADOR DE DESDOBLADORA, ACEITE Y DERIVADOS	1
43355	OCUPACION	768009	LIMPIADOR DE PEJERREYES Y OTROS PESCADOS	1
43354	OCUPACION	768008	LIMPIADOR DE CAMARONES	1
43353	OCUPACION	768007	HIDROGENADOR DE ACEITES Y GRASAS	1
43352	OCUPACION	768006	EXTRACTOR DE ACEITE DE ORUJO	1
43351	OCUPACION	768005	DESPINADOR DE PEJERREYES Y OTROS PESCADOS	1
43350	OCUPACION	768004	DESCASCARADOR DE NUECES	1
43349	OCUPACION	768003	DESCASCARADOR DE FRUTAS SECAS	1
43348	OCUPACION	768002	DESCASCARADOR O TOSTADOR DE MANI	1
43347	OCUPACION	768001	ALMAZARERO	1
43345	OCUPACION	767029	TRASEGADOR DE VINOS	1
43344	OCUPACION	767028	SIDRERO	1
43343	OCUPACION	767027	SECADOR DE MALTA	1
43342	OCUPACION	767026	PREPARADOR DE BEBIDAS CARBONICAS Y JARABES	1
43341	OCUPACION	767025	PRENSADOR DE UVA	1
43339	OCUPACION	767023	OPERADOR DE PRENSAS DE FRUTAS	1
43338	OCUPACION	767022	OBRERO ELABORACION SODAS, GASEOSAS Y OTRAS BEBIDAS NO ALCOH	1
43337	OCUPACION	767021	OBRERO DE VINOS ACHAMPANADOS	1
43336	OCUPACION	767020	OBRERO DE LA GERMINACION DE GRANOS,CERVEZA	1
43335	OCUPACION	767019	OBRERO DE LA FABRICACION DE LEVADURA	1
43334	OCUPACION	767018	OBRERO DE LA ELABORACION DE VINOS	1
43333	OCUPACION	767017	MEZCLADOR DE VINOS	1
43332	OCUPACION	767016	MALTERO, GERMINACION	1
43331	OCUPACION	767015	LAVADOR DE PASTA,SIDRA	1
43330	OCUPACION	767014	LAGARERO, VINOS	1
43329	OCUPACION	767013	GASEADOR DE SIDRA	1
43328	OCUPACION	767012	FILTRADOR DE CERVEZA	1
43327	OCUPACION	767011	FERMENTADOR DE VINOS	1
43326	OCUPACION	767010	FERMENTADOR	1
43325	OCUPACION	767009	DESECADOR DE MALTA	1
43324	OCUPACION	767008	COCEDOR DE MOSTO, CERVEZA	1
43323	OCUPACION	767007	COCEDOR DE MALTA	1
43322	OCUPACION	767006	ENFRASCADOR DE VINOS	1
43321	OCUPACION	767005	CLASIFICADOR DE VINOS	1
43320	OCUPACION	767004	CERVECERO, GERMINACION	1
43319	OCUPACION	767003	CATADOR DE VINOS Y LICORES	1
43318	OCUPACION	767002	CAPATAZ O CONTRAMAESTRE DE ELABORACION DE BEBIDAS	1
43317	OCUPACION	767001	ACETIFICADOR	1
43316	OCUPACION	766044	TURRONERO, PREPARADOR	1
43315	OCUPACION	766043	TOSTADOR DE CACAO	1
43314	OCUPACION	766042	TOSTADOR DE CAFE	1
43313	OCUPACION	766041	TORREFACTOR DE ACHICORIA Y OTROS SUCEDANEOS	1
43312	OCUPACION	766040	TORREFACTOR DE CAFE	1
43311	OCUPACION	766039	REPOSTERO,ELABORACION DE PASTELES Y OTROS	1
43310	OCUPACION	766038	PREPARADOR DE PASTAS ALIMENTICIAS	1
43309	OCUPACION	766037	PREPARADOR PASTAS PASTELERIA EN MOLDES A MAQUINA	1
43308	OCUPACION	766036	PRENSADOR DE CACAO, FABRICACION DE CHOCOLATE	1
43307	OCUPACION	766035	PASTELERO, PREPARADOR	1
43306	OCUPACION	766034	PANADERO-PASTELERO,EN GENERAL	1
43305	OCUPACION	766033	OPERADOR DE TROQUEL DE GALLETAS	1
43304	OCUPACION	766032	OPERADOR MAQ.SOBADORA MASA, FABRICACION GALLETAS	1
43303	OCUPACION	766031	OPERADOR MAQ.CALIBRADORA-CORTADORA MASA, FABRIC. DE GALLETA	1
43302	OCUPACION	766030	OPERADOR DE MAQUINA DE GOMA DE MASCAR,CHICLE	1
43301	OCUPACION	766029	OPERADOR DE MAQUINA DE FABRICAR PASTAS ALIMENTICIAS	1
43300	OCUPACION	766028	OFICIAL DE MASA O DE PALA,PANADERIA	1
43299	OCUPACION	766027	MOLINERO DE CACAO,FABRICACION DE CHOCOLATES	1
43298	OCUPACION	766026	MOLINERO DE CACAO	1
43297	OCUPACION	766025	MOLINERO DE CAFE	1
43296	OCUPACION	766024	MEZCLADOR DE TE	1
43295	OCUPACION	766023	MEZCLADOR DE CAFE	1
43294	OCUPACION	766022	MELCOCHERO, PREPARADOR	1
43293	OCUPACION	766021	MEZCLADOR DE INGREDIENTES, FABRICACION CHOCOLATE	1
43292	OCUPACION	766020	MAZAPAN, CONFECCIONADOR	1
43291	OCUPACION	766019	LAMINADOR DE GALLETAS	1
43290	OCUPACION	766018	LAMINADOR DE CHOCOLATES	1
43289	OCUPACION	766017	HORNERO DE PAN	1
43288	OCUPACION	766016	HOJALDRISTA	1
43287	OCUPACION	766015	GOMA MASCAR, CHICLE, OPERADOR MAQUINAS DE FABRICAR	1
43286	OCUPACION	766014	GALLETAS, OPERADOR DE TROQUEL	1
43285	OCUPACION	766013	GALLETAS, FABRICACION, OPERADOR MAQUINAS SOBADORA DE MASA	1
43284	OCUPACION	766012	FIDERO	1
43283	OCUPACION	766011	ESCARCHADOR DE FRUTAS	1
43282	OCUPACION	766010	DULCERO, PREPARADOR	1
43281	OCUPACION	766009	CONFITERO, PREPARADOR	1
43280	OCUPACION	766008	COLOCADOR DE TABLAS, PANADERIA	1
43279	OCUPACION	766007	CHURRERO, PREPARADOR	1
43278	OCUPACION	766006	CHOCOLATERO, PREPARADOR	1
43277	OCUPACION	766005	CHANCAQUERO, ELABORADOR DE CHANCACA	1
43276	OCUPACION	766004	CLASIFICADOR DE CAFE O DE TE	1
43275	OCUPACION	766003	CATADOR DE CAFE O DE TE	1
43274	OCUPACION	766002	ARROPIERO	1
43273	OCUPACION	766001	AMASADOR DE PAN	1
43272	OCUPACION	765019	SALADOR DE QUESO	1
43271	OCUPACION	765018	REQUESONERO	1
43270	OCUPACION	765017	REFRIGERADOR DE LECHE O PRODUCTOS LACTEOS	1
43269	OCUPACION	765016	QUESERO	1
43268	OCUPACION	765015	PREPARADOR DE YOUGURT Y CREMAS	1
43267	OCUPACION	765014	PREPARADOR DE LECHE CONDENSADA	1
43266	OCUPACION	765013	PREPARADOR DE MANJARBLANCO Y NATILLAS	1
43265	OCUPACION	765012	PASTEURIZADOR DE LECHE Y PRODUCTOS LACTEOS	1
43264	OCUPACION	765011	OPERADOR DE MAQUINA DE HOMOGENIZACION DE LA LECHE	1
43263	OCUPACION	765010	OPERADOR DE BATIDORA DE HELADOS	1
43262	OCUPACION	765009	MOLDEADOR DE MANTEQUILLA	1
43261	OCUPACION	765008	MANTEQUILLERO O MAZADOR	1
43260	OCUPACION	765007	LECHE CONDENSADA, PREPARADOR	1
43259	OCUPACION	765006	HORCHATERO	1
43258	OCUPACION	765005	HIGIENIZADOR DE LECHE	1
43257	OCUPACION	765004	HELADERO,FABRICACION	1
43256	OCUPACION	765003	ESTERILIZADOR DE PRODUCTOS LACTEOS	1
43255	OCUPACION	765002	DESECADOR-PULVERIZADOR DE LECHE EN POLVO	1
43254	OCUPACION	765001	CULTIVADOR DE FERMENTOS LACTEOS	1
43253	OCUPACION	764028	TONELERO-SALADOR, PESCA	1
43252	OCUPACION	764027	SECADOR DE PESCADO AL SOL	1
43251	OCUPACION	764026	SALCHICHERO	1
43250	OCUPACION	764025	SALAZONERO	1
43249	OCUPACION	764024	SALADOR DE ALIMENTOS,CARNES Y PESCADO	1
43248	OCUPACION	764023	RELLENADOR DE ACEITUNAS	1
43247	OCUPACION	764022	PREPARADOR DE CHARQUI	1
43246	OCUPACION	764021	PREPARADOR DE ALIMENTOS CONCENTRADOS	1
43245	OCUPACION	764020	PREPARADOR DE BOCADITOS ENVASADOS(PAPA FRITA,CAMOTE,ETC)	1
43244	OCUPACION	764019	PREPARADOR DE JAMONES O JAMONERO	1
43243	OCUPACION	764018	PREPARADOR DE MERMELADAS	1
43242	OCUPACION	764017	PELADOR DE FRUTAS Y HORTALIZAS,PARA CONSERVAS	1
43241	OCUPACION	764016	OPERADOR DE EVAPORADORA, EXTRACTOS ALIMENTICIOS	1
43240	OCUPACION	764015	OBRERO DE LA PREPAC. Y CONSERV.  DE FRUTAS SECAS	1
43239	OCUPACION	764014	LIMPIADOR DE FRUTAS Y HORTALIZAS,PARA CONSERVAS	1
43238	OCUPACION	764013	ESCABECHERO	1
43237	OCUPACION	764012	ENLATADOR DE PESCADO	1
43236	OCUPACION	764011	DESHIDRATADOR DE ALIMENTOS	1
43235	OCUPACION	764010	CURADOR DE CARNE O PESCADO	1
43234	OCUPACION	764009	CONGELADOR DE ALIMENTOS	1
43233	OCUPACION	764008	COCEDOR-ESTERILIZADOR	1
43232	OCUPACION	764007	COCEDOR DE SALSAS Y CONDIMENTOS	1
43231	OCUPACION	764006	COCEDOR-CONSERVERO, EN GENERAL	1
43230	OCUPACION	764005	CAPATAZ O CONTRAMAESTRE DE LA CONSERVACION DE ALIMENTOS	1
43229	OCUPACION	764004	AHUMADOR DE CARNES Y PESCADO	1
43228	OCUPACION	764003	ADEREZADOR DE ACEITUNAS	1
43227	OCUPACION	764002	ACEITADOR DE LLENO Y VACIO, CONSERVAS DE PESCADO	1
43226	OCUPACION	764001	ACECINADOR	1
43225	OCUPACION	763019	TRIPERO	1
43224	OCUPACION	763018	TABLAJERO, CARNES	1
43223	OCUPACION	763017	PUNTILLERO,MATADEROS	1
43222	OCUPACION	763016	MATARIFE	1
43221	OCUPACION	763015	MATANCERO EN GENERAL	1
43220	OCUPACION	763014	MATANCERO	1
43219	OCUPACION	763013	MANTEQUERO (MANTECA)	1
43218	OCUPACION	763012	FIAMBRERO, CARNES	1
43217	OCUPACION	763011	ESCARGADO DE MATADERO	1
43216	OCUPACION	763010	DESPOJERO, MATADEROS	1
43215	OCUPACION	763009	DESPOSTADOR, CARNES	1
43214	OCUPACION	763008	DESHUESADOR	1
43213	OCUPACION	763007	DESCUARTIZADOR DE RESES, MATARIFE	1
43212	OCUPACION	763006	DEGOLLADOR DE RESES	1
43211	OCUPACION	763005	CORTADOR DE CARNE	1
43210	OCUPACION	763004	CHORICERO	1
43209	OCUPACION	763003	CHARCUTERO	1
43208	OCUPACION	763002	CHACINERO	1
43207	OCUPACION	763001	CAMALERO, MATARIFE	1
43206	OCUPACION	762009	TRAPICHERO, CAÐA DE AZUCAR	1
43205	OCUPACION	762008	OPERADOR DE MAQUINA PULVERIZADORA DE AZUCAR	1
43204	OCUPACION	762007	OPERAD. INSTALACIONES PROCESO CONTINUO, REFIN. AZUCAR	1
43203	OCUPACION	762006	OPERADOR DE DIFUSOR, AZUCAR DE REMOLACHA	1
43110	OCUPACION	747004	TEJEDOR DE PUNTO A MANO	1
43202	OCUPACION	762005	OPERADOR DE CRISTALIZADORA, REFINACION DE AZUCAR	1
43201	OCUPACION	762004	MACERADOR DE REMOLACHA	1
43200	OCUPACION	762003	COMPORTERO, REFINACION DE AZUCAR	1
43199	OCUPACION	762002	COCEDOR, REFINACION DE AZUCAR	1
43198	OCUPACION	762001	CARBONADOR, REFINACION DE AZUCAR	1
43197	OCUPACION	761013	SEMOLERO	1
43196	OCUPACION	761012	SECADOR DE ARROZ	1
43195	OCUPACION	761011	SALVADERO	1
43194	OCUPACION	761010	REVOLVEDOR DE GRANOS	1
43193	OCUPACION	761009	PULIDOR DE ARROZ	1
43192	OCUPACION	761008	PESADOR DE GRANOS	1
43191	OCUPACION	761007	OPERADOR DE PILON DE MAIZ	1
43190	OCUPACION	761006	MOLINERO DE GRANOS	1
43189	OCUPACION	761005	MOLINERO DE ESPECIAS	1
43188	OCUPACION	761004	MOLINERO DE CEREALES	1
43187	OCUPACION	761003	MOLINERO DE ARROZ	1
43186	OCUPACION	761002	DESPOLVADOR DE GRANOS	1
43185	OCUPACION	761001	AVENTADOR DE GRANOS,MOLINO	1
43184	OCUPACION	752011	TINTORERO DE PIELES A MANO	1
43183	OCUPACION	752010	TEÐIDOR DE PIELES A MANO	1
43182	OCUPACION	752009	SUAVIZADOR DE PIELES	1
43181	OCUPACION	752008	RASURADOR DE PIELES	1
43180	OCUPACION	752007	IGUALADOR DE PELO,PIELES	1
43179	OCUPACION	752006	ESTIRADOR DE PIELES	1
43178	OCUPACION	752005	ESCOGEDOR DE PIELES SIN TRATAR	1
43177	OCUPACION	752004	DESCARNADOR DE PIELES	1
43176	OCUPACION	752003	DEPILADOR DE PIELES	1
43175	OCUPACION	752002	CLASIFICADOR DE PIELES	1
43174	OCUPACION	752001	ADOBADOR DE PIELES	1
43173	OCUPACION	751017	TINTORERO DE CUEROS	1
43172	OCUPACION	751016	TEÐIDOR DE CUEROS	1
43171	OCUPACION	751015	PELLEJERO, CURTIDOR	1
43170	OCUPACION	751014	PELAMBRERO	1
43169	OCUPACION	751013	PELADOR DE CUEROS Y PELLEJOS A MAQUINA	1
43168	OCUPACION	751012	PELADOR DE CUEROS A MANO	1
43167	OCUPACION	751011	OPERADOR DE REBANADORA DE CUEROS	1
43166	OCUPACION	751010	OPERADOR DE MAQUINAS DE DIVIDIR CUEROS	1
43165	OCUPACION	751009	LUSTRADOR DE CUEROS	1
43164	OCUPACION	751008	LAVADOR DE CUEROS	1
43163	OCUPACION	751007	HENDEDOR DE CUEROS O CORTADOR DE CUEROS	1
43162	OCUPACION	751006	DESCARNADOR DE CUEROS A MAQUINA	1
43161	OCUPACION	751005	DESCARNADOR DE CUEROS A MANO	1
43160	OCUPACION	751004	CURTIDOR DE CUEROS	1
43159	OCUPACION	751003	CORTADOR DE CUEROS,CURTIDORES	1
43158	OCUPACION	751002	CLASIFICADOR DE CUEROS Y PELLEJOS	1
43157	OCUPACION	751001	ADOBADOR DE CUEROS	1
43156	OCUPACION	749018	TEJE PULSERAS	1
43155	OCUPACION	749017	TEJEDOR DE REDES A MANO	1
43154	OCUPACION	749016	FEDERO A MANO	1
43153	OCUPACION	749015	PREPARADOR DE FIELTRO, A MAQUINA	1
43152	OCUPACION	749014	PASAMANERO A MAQUINA	1
43151	OCUPACION	749013	PASAMANERO A MANO	1
43150	OCUPACION	749012	HILANDEROS, TEJEDORES, TINTOREROS, TRABAJADORES ASIMILADOS	1
43149	OCUPACION	749011	MONTADOR DE REDES A MANO	1
43148	OCUPACION	749010	MALLERO	1
43147	OCUPACION	749009	HORMADOR DE BOINAS	1
43146	OCUPACION	749008	GANCHILLERO A MANO	1
41708	OCUPACION	346001	CONTACTOLOGO	1
43145	OCUPACION	749007	GALONERO A MAQUINA	1
43144	OCUPACION	749006	FLEQUERO A MANO	1
43143	OCUPACION	749005	FLEQUERO A MAQUINA	1
43142	OCUPACION	749004	ENCAJADERO A MANO	1
43141	OCUPACION	749003	CORDONERO A MAQUINA	1
43140	OCUPACION	749002	CORDONERO A MANO	1
43139	OCUPACION	749001	CONFECCIONADOR DE CONOS DE FIELTRO PARA SOMBREROS	1
43138	OCUPACION	748028	TINTORERO DE TEJIDOS	1
43137	OCUPACION	748027	TINTORERO DE ROPAS	1
43136	OCUPACION	748026	TINTORERO DE HILADOS	1
43135	OCUPACION	748025	TINTORERO DE FIBRAS	1
43134	OCUPACION	748024	SECADOR,FABRICACION DE TEXTILES	1
43133	OCUPACION	748023	SANFORIZADOR	1
43132	OCUPACION	748022	PULIDOR,TEXTILES	1
43131	OCUPACION	748021	PREPARADOR DE APRESTOS TEXTILES	1
43130	OCUPACION	748020	PLANCHADOR DE GENEROS ACABADOS	1
43129	OCUPACION	748019	PILATERO O BATANERO	1
43128	OCUPACION	748018	PERCHADOR DE TEXTILES	1
43127	OCUPACION	748017	OPERADOR DE CALANDRIAS,TEJIDOS	1
43126	OCUPACION	748016	LAVADOR DE HILADOS Y PRODUCTOS TEXTILES	1
1913	PAIS	492	MÓNACO	1
43125	OCUPACION	748015	IMPREGNADOR DE PRODUCTOS TEXTILES	1
43124	OCUPACION	748014	IMPERMEABILIZADOR DE PRODUCTOS TEXTILES	1
43123	OCUPACION	748013	GASEADOR, TEXTILES	1
43122	OCUPACION	748012	ENCOLADOR, TEXTILES	1
43121	OCUPACION	748011	ENCOGEDOR DE PRODUCTOS TEXTILES	1
43120	OCUPACION	748010	DESGOMADOR DE SEDA	1
43119	OCUPACION	748009	DESCRUDADOR DE PRODUCTOS TEXTILES	1
43118	OCUPACION	748008	DESBORRADOR DE TEXTILES	1
43117	OCUPACION	748007	CEPILLADOR DE PANA	1
43116	OCUPACION	748006	CARGADOR DE SEDA	1
43115	OCUPACION	748005	CARBONIZADOR DE LANA	1
43114	OCUPACION	748004	BLANQUEADOR	1
43113	OCUPACION	748003	APRESTADOR DE TEJIDOS	1
43112	OCUPACION	748002	ADEREZADOR DE SEDA	1
43111	OCUPACION	748001	ACABADOR DE TEJIDOS	1
43109	OCUPACION	747003	TEJEDOR DE PUNTO EN MAQUINA ACCIONADA A MANO	1
43108	OCUPACION	747002	TEJEDOR DE PUNTO EN BASTIDOR MANUAL	1
43107	OCUPACION	747001	CALCETERO A MANO	1
43106	OCUPACION	746007	TEJEDOR DE PUNTO EN MAQUINA HILAN O RASCHEL	1
43105	OCUPACION	746006	TEJEDOR DE CALCETERIA, CON BASTIDOR MECANICO	1
43104	OCUPACION	746005	TEJEDOR A MAQUINA, CALCETERIA	1
43103	OCUPACION	746004	TEJEDOR A MAQUINA, GENEROS DE PUNTO	1
43102	OCUPACION	746003	OPERADOR DE MAQUINA DE TRICOT	1
43101	OCUPACION	746002	CONFECCIONADOR DE TEJIDOS DE PUNTO	1
43100	OCUPACION	746001	CALCETERO,TEJEDOR A MAQUINA	1
43099	OCUPACION	745015	ZURCIDOR DE TEJIDOS	1
43098	OCUPACION	745014	URDIDOR	1
43097	OCUPACION	745013	TEJEDOR DE TELAR JACQUARD	1
43096	OCUPACION	745012	TEJEDOR DE TELAR MECANICO	1
43095	OCUPACION	745011	TEJEDOR DE TUL	1
43094	OCUPACION	745010	TEJEDOR DE REDES	1
43093	OCUPACION	745009	TEJEDOR DE ALFOMBRA A MAQUINA	1
43092	OCUPACION	745008	REVISOR DE TEJIDOS, OBREROS	1
43091	OCUPACION	745007	REPARADORA DE ALFOMBRAS	1
43090	OCUPACION	745006	REMENDADOR DE TEJIDOS	1
43089	OCUPACION	745005	RECONTADORA DE ALFOMBRAS	1
43088	OCUPACION	745004	CONTROLADOR DE MAQUINA LECTORA TEJEDORA(ALFOMBRAS)	1
43087	OCUPACION	745003	CONTROLADOR DE TEJIDOS	1
43086	OCUPACION	745002	COMPROBADOR DE TEJIDOS	1
43085	OCUPACION	745001	CONFECCIONADOR DE VELOS Y MANTILLAS A MAQUINA	1
43084	OCUPACION	744005	TEJEDOR PONCHOS O MANTAS TELAR ACCIONADO A MANO	1
43083	OCUPACION	744004	TEJEDOR DE TELAR A MANO	1
43082	OCUPACION	744003	TEJEDOR DE TAPICES,EN TELAR ACCIONADO A MANO	1
43081	OCUPACION	744002	TEJEDOR DE ALFOMBRAS EN TELAR ACCIONADO A MANO	1
43080	OCUPACION	744001	TEJEDOR DE ALFOMBRAS A MANO	1
43079	OCUPACION	743008	PICADOR DE CARTONES JACQUARD	1
43078	OCUPACION	743007	OPERADOR DE MAQUINAS DE REPRODUCCION CARTONES PARA TEJIDOS	1
43077	OCUPACION	743006	ENLAZADOR DE CARTONES JACQUARD	1
43076	OCUPACION	743005	COPISTA DE DISEÐOS PARA CARTONES JACQUARD	1
43075	OCUPACION	743004	AJUSTADOR DE TELAR JACQUARD	1
43074	OCUPACION	743003	AJUSTADOR DE TELARES	1
43073	OCUPACION	743002	AJUSTADOR DE PEINES, TELARES	1
43072	OCUPACION	743001	AJUSTADOR DE MAQUINA PARA TEJIDOS DE PUNTO	1
43071	OCUPACION	742014	OBRERO TEXTIL	1
43070	OCUPACION	742013	TRASCANADOR DE MADEJAS	1
43069	OCUPACION	742012	TORCEDOR DE HILO O HILAZA	1
43068	OCUPACION	742011	RODETERO, TEXTIL	1
43067	OCUPACION	742010	RETORCEDOR DE HILO O HILAZA	1
43066	OCUPACION	742009	PLEGADOR DE HILOS	1
43065	OCUPACION	742008	PELOTERO, TEXTIL	1
43064	OCUPACION	742007	OVILLADOR, TEXTIL	1
43063	OCUPACION	742006	HILANDERO, HILO E HILAZA	1
43062	OCUPACION	742005	HILADOR DE TORNO	1
43061	OCUPACION	742004	ENCARRETADOR, TEXTIL	1
43060	OCUPACION	742003	DEVANADOR, TEXTIL	1
43059	OCUPACION	742002	BOBINADOR, TEXTIL	1
43058	OCUPACION	742001	ASPEADOR, TEXTIL	1
43057	OCUPACION	741022	TRIADOR DE FIBRA	1
43056	OCUPACION	741021	TORCEDOR DE MECHAS	1
43055	OCUPACION	741020	RASTRILLADOR DE LINO	1
43054	OCUPACION	741019	PEINADOR DE FIBRA	1
43053	OCUPACION	741018	NAPADOR DE FIBRA	1
43052	OCUPACION	741017	MOTOSA O RAPARADORA, SEDA	1
43051	OCUPACION	741016	MEZCLADOR DE FIBRA	1
43050	OCUPACION	741015	MANUARERA	1
43049	OCUPACION	741014	LAVADOR DE LANA	1
43048	OCUPACION	741013	ESTIRADOR DE FIBRA	1
43047	OCUPACION	741012	ESPAPADOR	1
43046	OCUPACION	741011	ESCOGEDOR DE FIBRA	1
43045	OCUPACION	741010	EMBORRADOR DE LANA	1
43044	OCUPACION	741009	DIABLERO	1
43043	OCUPACION	741008	DESPEPITADOR, ALGODON	1
43042	OCUPACION	741007	DESMOTADOR, TEXTIL	1
43041	OCUPACION	741006	DESFIBRADOR DE LINO O YUTE	1
43040	OCUPACION	741005	CLASIFICADOR DE FIBRA	1
43039	OCUPACION	741004	CARDADOR DE FIBRAS	1
43038	OCUPACION	741003	CANALERO TEXTIL	1
43037	OCUPACION	741002	BATIDOR DE FIBRA	1
43036	OCUPACION	741001	ALIMENTADORES DE CARDAS	1
43035	OCUPACION	737022	PREPARADOR DE PIGMENTOS	1
43034	OCUPACION	737021	PREPARADOR DE GLUCOSA	1
43033	OCUPACION	737020	PREPARADOR DE ALMIDON	1
43032	OCUPACION	737019	OPERADOR DE PLANTA PARA LICUEFACCION DE GAS	1
43031	OCUPACION	737018	OPERADOR DE EQUIPO ELECTRONICO,TRATAMIENTOS QUIMICOS	1
43030	OCUPACION	737017	OPERADOR DE COQUERIA, CARBON DE COQUE	1
43029	OCUPACION	737016	OPERADOR DE BATERIA DE GAS DE HULLA	1
43028	OCUPACION	737015	OBRERO, FABRICACION DE COMPRIMIDOS Y GRAGEAS	1
43027	OCUPACION	737014	OBRERO, FABRICACION DE EXPLOSIVOS	1
43026	OCUPACION	737013	OBRERO, FABRICACION HIDROGENO, OXIGENO, ACETILENO, OTROS	1
43025	OCUPACION	737012	OBRERO, FABRICACION DE MINIO	1
43024	OCUPACION	737011	OBRERO, FABRICACION DE CARUSA	1
43023	OCUPACION	737010	OBRERO, FABRICACION COLORANTES, TINTES, PINTURAS, BARNICES	1
43022	OCUPACION	737009	OBREROS EN LA FABRICACION DE ACIDOS	1
43021	OCUPACION	737008	OBREROS EN LA FABRICACION DE ABONOS	1
43020	OCUPACION	737007	OBREROS DEL TRATAMIENTO DE DESECHOS RADIACTIVOS	1
43019	OCUPACION	737006	OBREROS TRATAMIENTO QUIMICO DE MATERIALES RADIACTIVOS	1
43018	OCUPACION	737005	OBREROS DE LA COAGULACION DE LATEX	1
43017	OCUPACION	737004	LAVADOR DE MATERIAS QUIMICAS	1
43016	OCUPACION	737003	HORNERO, COQUERIA	1
43015	OCUPACION	737001	AHUMADOR DE LATEX	1
43014	OCUPACION	736002	HILADOR DE RAYON Y SIMILARES	1
43013	OCUPACION	736001	HILADOR DE NYLON	1
43012	OCUPACION	735009	REFINO DEL PETROLEO,BOMBERO	1
43011	OCUPACION	735008	OPERADOR DE TURBINAS, REFINO DEL PETROLEO	1
43010	OCUPACION	735007	OPERADOR DE FILTROS DE PARAFINA	1
43009	OCUPACION	735006	OPERADOR DE CUADRO DE CONTROL REFINO DEL PETROLEO	1
43008	OCUPACION	735005	MEZCLADOR, REFINO DEL PETROLEO	1
43007	OCUPACION	735004	DESULFURADOR HIDROCABUROS	1
43006	OCUPACION	735003	DESULFURADOR, REFINO DEL PETROLEO	1
43005	OCUPACION	735002	DESTILADOR DEL PETROLEO	1
43004	OCUPACION	735001	BOMBERO, REFINO DEL PETROLEO	1
43003	OCUPACION	734010	REFINADOR DE TREMENTINA	1
43002	OCUPACION	734009	OPERADOR DE EVAPORADOR	1
43001	OCUPACION	734008	OPERADOR DE APARATOS REACCION, CONVERSION PRODUCTOS QUIMICO	1
43000	OCUPACION	734007	LICORISTA, DESTILACION	1
42999	OCUPACION	734006	DESTILADOR, BEBIDAS ALCOHOL, PERFUMERIA, GLICERINA	1
42998	OCUPACION	734005	DESTILADOR DE RESINA DE TREMENTINA	1
42997	OCUPACION	734004	DESTILADOR DE TREMENTINA DE MADERA	1
42996	OCUPACION	734003	DESTILADOR DE MADERA	1
42995	OCUPACION	734002	DESTILADOR PRODUCTOS QUIMICOS, EXCEPTO PETROLEO, ALAMBIQUE	1
42994	OCUPACION	734001	DESTILADOR PRODUCTOS QUIMICOS, EXCEPTO PETROLEO	1
42993	OCUPACION	733008	TAMIZADOR, TRATAMIENTOS QUIMICOS Y AFINES	1
42992	OCUPACION	733007	OPERAD SEPARADORA CENTRIFUGADORA, TRATAMIENTO QUIMICO Y AFI	1
42991	OCUPACION	733006	OPERADOR DE FILTRO DE TAMBOR GIRATORIO	1
42990	OCUPACION	733005	OPERADOR DE FILTRO-PRENSA	1
42989	OCUPACION	733004	OPERADOR DE CENTRIFUGADORA	1
42988	OCUPACION	733003	OBRERO TRATAM. PETROLEO CRUDO, CAMPOS EXTRACCION	1
42987	OCUPACION	733002	DESHIDRATADOR PETROLEO CRUDO, CAMPOS EXTRACCION	1
42986	OCUPACION	733001	CRIBADOR DE PRODUCTOS QUIMICOS	1
42985	OCUPACION	732014	TOSTADOR, TRATAMIENTOS QUIMICOS Y AFINES	1
42984	OCUPACION	732013	SECADOR PRODUCTOS QUIMICOS, SECADOR CINTA TRANSPORTADORA	1
42983	OCUPACION	732012	PULVERIZADOR,DESHIDRATADOR DE DISOLUCIONES QUIMICAS	1
42982	OCUPACION	732011	OPERADOR DE SECADOR, TRATAMIENTOS QUIMICOS Y AFINES	1
42981	OCUPACION	732010	OPERADOR DE MARMITA, TRATAMIENTOS QUIMICOS Y AFINES	1
42980	OCUPACION	732009	OPERADOR HORNOS CALCINACION, TRATAMIENTOS QUIMICOS Y AFINES	1
42979	OCUPACION	732008	OPERADOR DE CALDERA, TRATAMIENTOS QUIMICOS Y AFINES	1
42978	OCUPACION	732007	OPERADOR DE AUTOCLAVE, TRATAMIENTOS QUIMICOS Y AFINES	1
42977	OCUPACION	732006	HORNERO, HORNOS CALCINACION, TRATAMIENTOS QUIMICOS Y AFINES	1
42976	OCUPACION	732005	HORNERO, FABRICACION DE ELECTRODOS	1
42975	OCUPACION	732004	DESHIDRATADOR DE DISOLUCIONES QUIMICOS POR PULVERIZACION	1
42974	OCUPACION	732003	CUADRISTA (DE SISTESIS, GAS)	1
42973	OCUPACION	732002	COCEDOR, TRATAMIENTOS QUIMICOS Y AFINES	1
42972	OCUPACION	732001	CALCINADOR, TRATAMIENTOS QUIMICOS Y AFINES	1
42971	OCUPACION	731006	TRITURADOR-PULPERIZADOR, PROCEDIMIENTOS QUIMICOS Y AFINES	1
42970	OCUPACION	731005	OPERADOR DE QUEBRANTADORA, TRATAMIENTO QUIMICOS AFINES	1
42969	OCUPACION	731004	OPERADOR DE MAQUINA MEZCLADORA, TRATAMIENTO QUIMICO AFINES	1
42968	OCUPACION	731003	OPERADOR DE BATIDORA DE HELICE	1
42967	OCUPACION	731002	MOLINERO, TRATAMIENTO DE PRODUCTOS QUIMICOS AFINES	1
42966	OCUPACION	731001	MOLEDOR, PROCEDIMIENTOS QUIMICOS AFINES	1
42965	OCUPACION	724012	SATINADOR-CALANDRADOR DE PAPEL	1
42964	OCUPACION	724011	PLISADOR DE PAPEL	1
42963	OCUPACION	724010	PAPELERO, FABRICACION A MANO	1
42962	OCUPACION	724009	OPERADOR DE MAQUINA PARA SECADO Y ENROLLADO, PAPEL	1
42961	OCUPACION	724008	OPERADOR DE MAQUINA DE APRESTAR PAPEL	1
42960	OCUPACION	724007	OPERADOR MAQUINA DE FABRICAR PAPEL, FASE HUMEDA, FASE SECA	1
42959	OCUPACION	724006	OPERADOR DE CALANDRIA DE PAPEL	1
42958	OCUPACION	724005	CONDUCTOR DE PARAFINADORA, PAPEL	1
42957	OCUPACION	724004	CONDUCTOR DE ONDULADORA, PAPEL	1
42956	OCUPACION	724003	CONDUCTOR DE GOFRADORA, PAPEL	1
42955	OCUPACION	724002	CONDUCTOR DE ENGOMADORA, PAPEL	1
42954	OCUPACION	724001	CONDUCTOR DE CHAROLADORA, PAPEL	1
42953	OCUPACION	723015	TRAPERO,PREPARACION DE PASTA PARA PAPEL	1
42952	OCUPACION	723014	REFINADOR DE PASTA DE PAPEL	1
42951	OCUPACION	723013	PASTA DE PAPEL LAURENTE	1
42950	OCUPACION	723012	OPERADOR DE PASTA PARA PAPEL EN GENERAL	1
42949	OCUPACION	723011	OPERADOR DE MAQUINA DE TRITURAR MADERA	1
42948	OCUPACION	723010	OPERADOR DE CALDERA, PASTA PARA PAPEL	1
42947	OCUPACION	723009	OPERADOR DE BATIDORA, PULPA DE MADERA	1
42946	OCUPACION	723008	LEJIADOR, PASTA PARA PAPEL	1
42945	OCUPACION	723007	DESFIBRADOR RASPADOR DE MADERA	1
42944	OCUPACION	723006	CORTADOR DE VIRUTA PARA PULPA DE MADERA	1
42943	OCUPACION	723005	CORTADOR DE TRAPOS, PASTA DE PAPEL	1
42942	OCUPACION	723004	CONDUCTOR DE TRITURADORAS, PULPA DE MADERA	1
42941	OCUPACION	723003	CONDUCTOR DE MOJADORAS, PASTA DE PAPEL	1
42940	OCUPACION	723002	CONDUCTOR DE DESFIBRADORA DE MADERA	1
42939	OCUPACION	723001	BLANQUEADOR DE PASTA PARA PAPEL	1
42938	OCUPACION	722014	SERRUCHADOR,ASERRADERO	1
42937	OCUPACION	722013	OPERADOR DE SIERRAS DE RECORTAR TABLAS	1
42936	OCUPACION	722012	OPERADOR DE SIERRA DE CINTA	1
42935	OCUPACION	722011	OPERADOR DE PRENSA DE MADERA TERCIADA	1
42934	OCUPACION	722010	OPERADOR DE PRENSA DE CONTRACHAPADO	1
42933	OCUPACION	722009	OPERADOR DE MAQUINA INTERCALADORA DE CHAPAS, CONTRACHAPADO	1
42932	OCUPACION	722008	OPERADOR DE MAQUINA PELADORA PARA CHAPAS	1
42931	OCUPACION	722007	ENCOLADOR DE CHAPAS DE MADERA	1
42930	OCUPACION	722006	DESCORTEZADOR A MAQUINA	1
42929	OCUPACION	722005	CORTADOR DE PAJA DE MADERA	1
42928	OCUPACION	722004	CORTADOR  DE CHAPA DE MADERA	1
42927	OCUPACION	722003	CONDUCTOR DE DESCORTEZADORA	1
42926	OCUPACION	722002	CLASIFICADOR DE MADERA	1
42925	OCUPACION	722001	ASERRADOR EN GENERAL, SERRERIAS	1
42924	OCUPACION	721003	SECADOR DE MADERA	1
42923	OCUPACION	721002	OPERADOR DE HORNO DE SECADO DE MADERA	1
42922	OCUPACION	721001	IMPREGNADOR DE MADERA	1
42921	OCUPACION	719009	PULIDOR DE PIEZAS DE MOLDEO	1
42920	OCUPACION	719008	PULIDOR DE PIEZAS DE METAL COLADO	1
42919	OCUPACION	719007	PAVONADOR DE METALES	1
42918	OCUPACION	719006	OPERADOR DE SOPLADOR DE ARENA, PARA LIMPIAR METALES	1
42917	OCUPACION	719005	LIMPIADOR POR CHORRO DE ARENA, METALES	1
42916	OCUPACION	719004	LIMPIADOR DE METALES POR ONDAS ULTRASONICAS	1
42915	OCUPACION	719003	LIMPIADOR DE METALES	1
42914	OCUPACION	719002	DESBASTADOR DE PIEZAS DE MOLDEO	1
42913	OCUPACION	719001	DECAPADOR DE METALES	1
42912	OCUPACION	718027	ZINCADOR EN BAÐO CALIENTE	1
42911	OCUPACION	718026	TREFILADOR A MAQUINA	1
42910	OCUPACION	718025	TREFILADOR A MANO	1
42909	OCUPACION	718024	TEMPLADOR DE METALES	1
42908	OCUPACION	718023	REVESTIDOR EN BAÐO CALIENTE	1
42907	OCUPACION	718022	RECOCEDOR DE METALES	1
42906	OCUPACION	718021	PUNTERO, METALES	1
42905	OCUPACION	718020	PULVERIZADOR DE METAL A PISTOLA	1
42904	OCUPACION	718019	PLATEADOR	1
42903	OCUPACION	718018	OTROS GALVANIZADORES Y RECUBRIDORES DE METALES	1
42902	OCUPACION	718017	OPERADOR DE MAQUINA RECUBRIDORA DE ALAMBRE	1
42901	OCUPACION	718016	NORMALIZADOR DE METALES	1
42900	OCUPACION	718015	NIQUELADOR	1
42899	OCUPACION	718014	METALIZADOR EN BAÐO CALIENTE	1
42898	OCUPACION	718013	METALIZADOR A PISTOLA	1
42897	OCUPACION	718012	GALVANIZADOR EN BAÐO CALIENTE	1
42896	OCUPACION	718011	EXTRUSOR DE METALES	1
42895	OCUPACION	718010	ESTIRADOR DE TUBOS SIN SOLDADURA	1
42894	OCUPACION	718009	EMENTADOR DE METALES	1
42893	OCUPACION	718008	ELECTROPLASTIA, GALVANIZADOR	1
42892	OCUPACION	718007	CROMADOR	1
42891	OCUPACION	718006	CONDUCTOR DE PRENSA DE ESTIRAR METALES	1
42890	OCUPACION	718005	CEMENTADOR DE METALES POR CARBONIZACION	1
42889	OCUPACION	718004	CEMENTADOR DE METALES POR CIANURIZACION	1
42888	OCUPACION	718003	CEMENTADOR DE METALES POR NUTRICION	1
42887	OCUPACION	718002	CEMENTADOR DE METALES	1
42886	OCUPACION	718001	BRONCEADOR	1
42885	OCUPACION	717010	PREPARADOR DE MOLDES A MAQUINA	1
42884	OCUPACION	717009	PREPARADOR DE MOLDES EN EL SUELO Y EN FOSAS	1
42883	OCUPACION	717008	MOLDEADOR DE CAJA	1
42882	OCUPACION	717007	MOLDEADOR DE ARTESA	1
42881	OCUPACION	717006	MOLDEADOR A MAQUINA	1
42880	OCUPACION	717005	MACHERO A MAQUINA	1
42879	OCUPACION	717004	MACHERO A MANO	1
42878	OCUPACION	717003	CONSTRUCTOR DE MACHOS A MAQUINA	1
42877	OCUPACION	717002	CONSTRUCTOR DE MACHOS A MANO	1
42876	OCUPACION	717001	PREPARADOR DE MOLDES SOBRE BANCO	1
42875	OCUPACION	716009	OPERARIO DE COLADA CONTINUA	1
42874	OCUPACION	716008	OPERARIO DE NAVE DE COLADA	1
42873	OCUPACION	716007	OPERADOR DE MAQUINA COLADA CONTINUA DE TUBOS Y VARILLAS	1
42872	OCUPACION	716006	OPERADOR DE MAQUINA DE COLAR DE PRESION	1
42871	OCUPACION	716005	OPERADOR DE MAQUINA CENTRIFUGADORA DE COLADA	1
42870	OCUPACION	716004	FUNDIDOR DE PIEZAS DE MOLDES	1
42869	OCUPACION	716003	COLADOR EN MOLDES, PIEZAS DE METAL	1
42868	OCUPACION	716002	COLADOR DE MOLDES A MAQUINA CENTRIFUGADORA	1
42867	OCUPACION	716001	COLADOR DE HORNO A PRESION	1
42866	OCUPACION	715010	OPERADOR DE HORNO DE RECALENTAR	1
42865	OCUPACION	715009	HORNERO DE SEGUNDA FUSION	1
42864	OCUPACION	715008	FUNDIDOR EN SEGUNDA FUSION	1
42863	OCUPACION	715007	FUNDIDOR EN HORNO ELECTRICO, SEGUNDA FUSION	1
42862	OCUPACION	715006	FUNDIDOR DE HORNO DE HOGAR ABIERTO, SEG. FUSION	1
42861	OCUPACION	715005	FUNDIDOR EN HORNO DE REVERBERO, SEGUNDA FUSION	1
42860	OCUPACION	715004	FUNDIDOR DE CUBILOTE	1
42859	OCUPACION	715003	FUNDIDOR DE CRISOLES, SEGUNDA FUSION	1
42858	OCUPACION	715002	COLADOR DE HORNO DE SEGUNDA FUSION	1
42595	OCUPACION	615006	CAMPESINO, TRABAJADOR INDEPENDIENTE	1
42857	OCUPACION	715001	AYUDANTE DE HORNO DE SEGUNDA FUSION O DE RECALENTADO	1
42856	OCUPACION	714012	OPERARIO DE LAMINADO REVERSIBLE	1
42855	OCUPACION	714011	OPERARIO DE LAMINADO DE REVESTIMIENTO	1
42854	OCUPACION	714010	OPERARIO DE TREN DE LAMINACION	1
42853	OCUPACION	714009	MAQUINISTA DE TREN DE LAMINACION	1
42852	OCUPACION	714008	LAMINADOR DE TUBOS SIN SOLDADURA	1
42851	OCUPACION	714007	LAMINADOR DE PRODUCTOS SEMIACABADOS DE ACERO	1
42850	OCUPACION	714006	LAMINADOR DE METALES NO FERREOS	1
42849	OCUPACION	714005	LAMINADOR DE ACERO EN FRIO	1
42848	OCUPACION	714004	LAMINADOR DE ACERO EN TREN CONTINUO	1
42847	OCUPACION	714003	LAMINADOR DE ACERO EN CALIENTE	1
42846	OCUPACION	714002	AYUDANTE DE TREN DE LAMINACION	1
42845	OCUPACION	714001	AUXILIAR DE TREN DE LAMINACION	1
42844	OCUPACION	713016	HORNERO DE HORNO THOMAS O ELKEM	1
42843	OCUPACION	713015	HORNERO DE CONVERSION Y AFINACION DE METALES  NO FERREOS	1
42842	OCUPACION	713014	HORNERO DE CONVERTIDOR BASSEMER	1
42841	OCUPACION	713013	HORNERO DE ALTO HORNO	1
42840	OCUPACION	713012	FUNDIDOR EN HORNO DE CONVER. Y AFINADO DE METAL.NO FERREOS	1
42839	OCUPACION	713011	FUNDIDOR EN HORNO ELECTRICO DE ARCO, REFINO DE ACERO	1
42838	OCUPACION	713010	FUNDIDOR EN HORNO THOMAS	1
42837	OCUPACION	713009	FUNDIDOR EN HORNO DE ACERO MARTIN SIEMENS	1
42836	OCUPACION	713008	FUNDIDOR EN HORNOS	1
42835	OCUPACION	713007	FUNDIDOR EN EL AFINO Y REFINO DE METALES NO FERREOS	1
42834	OCUPACION	713006	FUNDIDOR DE CONVERTIDOR BESSEMER, DE ACERO	1
42833	OCUPACION	713005	FUNDIDOR DE CONVERTIDOR DE ACERO, AL OXIGENO	1
42832	OCUPACION	713004	FUNDIDOR DE ALTO HORNO, FUSION DE MINERAL	1
42831	OCUPACION	713003	COLADOR DE HORNO ALTO	1
42830	OCUPACION	713002	CARGADOR DE HORNO ALTO	1
42829	OCUPACION	713001	AYUDANTE, HORNO ALTO	1
42828	OCUPACION	712019	TUBEROS DE SONDEO	1
42827	OCUPACION	712018	SONDISTA, CONDUCTORES DE TREN DE SONDEO POR ROTACION,	1
42826	OCUPACION	712017	SONDISTA, RECUPERACION Y MANTENIMIENTO DE CILINDROS DE PETR	1
42825	OCUPACION	712016	SONDISTA, POZOS DE PETROLEO Y GAS	1
42824	OCUPACION	712015	SONDISTA, EXCEPTO POZOS DE PETROLEO Y GAS	1
42823	OCUPACION	712014	SONDISTA, CONDUCTOR DE PERFORADORA DE PERCUSION, PETROLEO Y	1
42822	OCUPACION	712013	SONDISTA DE POZOS EN EXPLOTACION	1
42821	OCUPACION	712012	PERFORADOR DE POZOS PETROLIFEROS	1
42820	OCUPACION	712011	PERFORADOR DE POZOS ARTESIANOS	1
42819	OCUPACION	712010	PERFORADOR DE POZOS DE AGUA	1
42818	OCUPACION	712009	PERFORADOR CON APARATO ROTATIVO, POZOS DE PETROLEO Y GAS	1
42817	OCUPACION	712008	PEON DE TORRE, PETROLEO	1
42816	OCUPACION	712007	OTROS SONDISTAS Y TRABAJADORES ASIMILADOS	1
42815	OCUPACION	712006	OPERADOR DE ACIDIFICACION DE POZOS DE PETROLEO	1
42814	OCUPACION	712005	MECANICO DE SONDAS, POZOS DE PETROLEO Y GAS	1
42813	OCUPACION	712004	DESINCRUSTADOR DE POZOS DE PETROLEO Y GAS	1
42812	OCUPACION	712003	CONDUCTORES DE TREN DE SONDEO POR ROTACION, POZOS DE PETROL	1
42811	OCUPACION	712002	CONDUCTORES DE PERFORADORA DE PERCUSION, POZOS DE PETROLEO	1
42810	OCUPACION	712001	CEMENTADOR, POZOS DE PETROLEO Y GAS	1
42809	OCUPACION	711058	TRONZADOR DE PIEDRAS	1
42808	OCUPACION	711057	TRITURADOR, MINERALES	1
42807	OCUPACION	711056	TRECHEADOR DE MINAS Y CANTERAS	1
42806	OCUPACION	711055	TRAZADOR SOBRE PIEDRA	1
42805	OCUPACION	711054	TORNERO, LABRA  DE PIEDRA	1
42804	OCUPACION	711053	TOMADOR DE MUESTRAS,MINAS	1
42803	OCUPACION	711052	TOLVERO,MINAS Y CANTERAS	1
42802	OCUPACION	711051	TERRERISTA, MINAS	1
42801	OCUPACION	711050	TERRAPLENISTA,MINAS	1
42800	OCUPACION	711049	TALLADOR DE PIEDRA	1
42799	OCUPACION	711048	TALLADOR DE LAMINAS	1
42798	OCUPACION	711047	SACAMUESTRAS, MINAS	1
42797	OCUPACION	711046	PULIDOR DE PIEDRA A MAQUINA	1
42796	OCUPACION	711045	PULIDOR DE PIEDRA A MANO	1
42795	OCUPACION	711044	PRENSADOR DE BRIQUETAS DE CARBON	1
42794	OCUPACION	711043	PERFORADOR DE PIEDRAS	1
42793	OCUPACION	711042	PERFORADORES DE MINAS	1
42792	OCUPACION	711041	PEGADOR, MINAS Y CANTERAS	1
42791	OCUPACION	711040	PALERO, MINAS	1
42790	OCUPACION	711039	OPERADOR DE TRITURADORA DE MINERALES	1
1919	PAIS	826	REINO UNIDO	1
42789	OCUPACION	711038	OPERADOR DE QUEBRANTADORA DE ROCAS	1
42788	OCUPACION	711037	OPERADOR DE QUEBRANTADORA DE MINERAL	1
42787	OCUPACION	711036	OPERADOR DE PRENSA DE PELLETS DE MINERAL	1
42786	OCUPACION	711035	OPERADOR DE INSTALACIONES DE FLOTACION	1
42785	OCUPACION	711034	OPERADOR DE CRIBAS HIDRAULICAS	1
42784	OCUPACION	711033	OPERADOR DE CONO DE SEPARACION, MINAS	1
42783	OCUPACION	711032	OPERADOR DE APARATO DE PRECIPITACION	1
42782	OCUPACION	711031	MOLINERO DE MINERAL	1
42781	OCUPACION	711030	MANIOBRISTA, MINAS	1
42780	OCUPACION	711029	MACHACADOR, TRITURADOR, MINERALES	1
42779	OCUPACION	711028	LAVADOR DE MINERALES	1
42778	OCUPACION	711027	LAVADOR DE ORO	1
42777	OCUPACION	711026	HENDEDOR DE PIEDRAS	1
42776	OCUPACION	711025	GRABADOR DE RELIEVE EN PIEDRA A MANO	1
42775	OCUPACION	711024	GRABADOR DE PIEDRA CON ESTARCIDORES	1
42774	OCUPACION	711023	GRABADOR MOTIVOS SIMPLES EN BLOQUES DE PIEDRAS	1
42773	OCUPACION	711022	GRABADOR DE INSCRIPCIONES Y PIEDRA A MANO	1
42772	OCUPACION	711021	ENTIBADOR, ENMADERADOR DE MINA O DE GALERIA	1
42771	OCUPACION	711020	ESTRIBADOR DE MINERALES	1
42770	OCUPACION	711019	ESCOGEDOR DE PIEDRAS	1
42769	OCUPACION	711018	ESCOGEDOR DE MINERALES	1
42768	OCUPACION	711017	ENGANCHADOR, MINAS	1
42767	OCUPACION	711016	DOLADOR, PIEDRAS	1
42766	OCUPACION	711015	DINAMITERO, PEGADOR, MINAS Y CANTERAS	1
42765	OCUPACION	711014	DESMUESTRADOR O COLECTOR DE MUESTRAS	1
42764	OCUPACION	711013	CRIBADOR DE CARBON O MINERALES	1
42763	OCUPACION	711012	CONDUCTOR DE MAQUINA CONTINUA DE ARRANQUE	1
42762	OCUPACION	711011	CONDUCTOR DE MAQUINA ROZADORA, CORTADORA, PERFORADORA,ETC	1
42761	OCUPACION	711010	COLECTOR DE MUESTRAS,MINAS	1
42760	OCUPACION	711009	CLASIFICADOR DE PIEDRA	1
42759	OCUPACION	711008	CAPATAZ O CONTRAMAESTRE DE MINAS Y CANTERAS	1
42758	OCUPACION	711007	BARRENERO, DINAMITERO	1
42757	OCUPACION	711006	ASERRADOR DE PIEDRA	1
42756	OCUPACION	711005	APURADOR-LAVADOR DE MINERAL	1
42755	OCUPACION	711004	ARTILLERO, MINAS Y CANTERAS	1
42754	OCUPACION	711003	APUNTALADOR, ADEMADOR, ALADERO, ENTIBADOR, MINAS	1
42753	OCUPACION	711002	APIRI	1
42752	OCUPACION	711001	ADORNISTAS	1
42751	OCUPACION	641004	TRABAJADOR, PESCADOR CALIFICADO, PESCA DE SUBSISTENCIA	1
42750	OCUPACION	641003	PESCADOR, SUBSISTENCIA	1
42749	OCUPACION	641002	TRABAJADOR AGRICOLA CALIFICADO, CULTIVOS DE SUBSISTENCIA	1
42748	OCUPACION	641001	AGRICULTOR, SUBSISTENCIA	1
42747	OCUPACION	637008	TRAMPEROS	1
42746	OCUPACION	636007	CAZADOR, OTROS	1
42745	OCUPACION	636006	CAZADOR DE SERPIENTES	1
42744	OCUPACION	636005	CAZADOR DE ANIMALES DE PIELES	1
42743	OCUPACION	636004	CAZADOR DE MONOS	1
42742	OCUPACION	636003	CAZADOR DE AVES	1
42741	OCUPACION	636002	CAZADOR DE VENADO, CHINCHILLA	1
42740	OCUPACION	636001	CAZADOR DE ANIMALES SALVAJES	1
42739	OCUPACION	635008	CRIADOR DE OSTRAS	1
42738	OCUPACION	635007	CHORERO	1
42737	OCUPACION	635006	CAZADORES DE OTROS ANIMALES ACUATICOS (FOCAS, LOBOS MARINOS	1
42736	OCUPACION	635005	CONCHERO	1
42735	OCUPACION	635004	CAZADORES DE TORTUGAS MARINAS	1
42734	OCUPACION	635003	CARACOLERO	1
42733	OCUPACION	635002	RECOLECTOR DE ALGAS, ESPONJAS O MUSGO MARINO	1
42732	OCUPACION	635001	CAMARONERO	1
42731	OCUPACION	634004	DESCUARTIZADOR, BALLENAS	1
42730	OCUPACION	634003	CAZADOR, BALLENAS	1
42729	OCUPACION	634002	BALLENERO	1
42728	OCUPACION	634001	ARPONERO	1
42727	OCUPACION	633009	TRIPULACION DE BARCOS PESQUEROS, OTROS	1
42726	OCUPACION	633008	REDERO DE MAR	1
42725	OCUPACION	633007	PESCADOR, ATUNERO	1
42724	OCUPACION	633006	PESCADOR, RASTRA	1
42723	OCUPACION	633005	PESCADOR DE BOLICHERA	1
42722	OCUPACION	633004	PESCADOR DE BAJURA	1
42721	OCUPACION	633003	PESCADOR DE ALTURA	1
42720	OCUPACION	633002	ANCHOVETERO	1
42719	OCUPACION	633001	ALMADRABERO	1
42718	OCUPACION	632010	PESCADOR, OSTRAS PERLIFERAS	1
42717	OCUPACION	632009	PESCADOR, MEJILLONERO	1
42716	OCUPACION	632008	PESCADOR, MARISCADOR	1
42715	OCUPACION	632007	PESCADOR, ESPONJAS	1
42714	OCUPACION	632006	PESCADOR, COSTERO	1
42713	OCUPACION	632005	PESCADOR, AGUA DULCE	1
42712	OCUPACION	632004	PESCADOR DE LAGO	1
42711	OCUPACION	632003	PESCADOR DE RIO	1
42710	OCUPACION	632002	BUZO, PESCADOR/OSTRAS	1
42709	OCUPACION	632001	BUZO, PESCADOR/ESPONJAS	1
42708	OCUPACION	631010	LARVERO	1
42707	OCUPACION	631009	OSTRERO	1
42706	OCUPACION	631008	MEJILLONERO	1
42705	OCUPACION	631007	MARISCADOR/MARISQUERO	1
42704	OCUPACION	631006	OSTRICULTOR	1
42703	OCUPACION	631005	LANGOSTERO	1
42702	OCUPACION	631004	TRABAJADOR DE PISCIGRANJAS	1
42701	OCUPACION	631003	PISICULTOR DE TRUCHAS	1
42700	OCUPACION	631002	PISCICULTOR CRIADORES DE ESPECIES ACUATICAS	1
42699	OCUPACION	631001	ENCARGADO DE ACUARIO	1
42698	OCUPACION	625017	TRABAJADOR, ZOOLOGICO	1
42697	OCUPACION	625016	TRABAJADOR, CRIA DE PAJAROS SALVAJES	1
42696	OCUPACION	625015	TRABAJADOR, ANIMALES SALVAJES/PIELES FINAS	1
42695	OCUPACION	625014	TRABAJADOR CALIFICADO, AVES Y PAJAROS SALVAJES	1
42694	OCUPACION	625013	GUARDIAN, PARQUE ZOOLOGICO	1
42693	OCUPACION	625012	GUARDIAN, PAJARERA	1
42692	OCUPACION	625011	GUARDIAN, GANADO	1
42691	OCUPACION	625010	ENTRENADOR, CABALLOS DE CARRERA	1
42690	OCUPACION	625009	CRIADOR DE PERROS	1
42689	OCUPACION	625008	CRIADOR DE GATOS	1
42688	OCUPACION	625007	CUIDADOR, ANIMALES/RESERVAS NATURALES	1
42687	OCUPACION	625006	CUIDADOR, ANIMALES/PARQUES ZOOLOGICOS	1
42686	OCUPACION	625005	CRIADOR, ANIMALES/RESERVAS NATURALES	1
42685	OCUPACION	625004	CRIADOR, ANIMALES SALVAJES/PIELES FINAS	1
41280	OCUPACION	272042	TENOR	1
42684	OCUPACION	625003	CRIADOR, ANIMALES NO DOMESTICOS/PIELES FINAS	1
42683	OCUPACION	625002	CRIADOR, ANIMALES DE LABORATORIO/COBAYOS	1
42682	OCUPACION	625001	ADIESTRADOR, PERROS	1
42681	OCUPACION	624005	TRABAJADOR CALIFICADO, SERICICULTURA	1
42680	OCUPACION	624004	TRABAJADOR CALIFICADO, APICULTURA	1
42679	OCUPACION	624003	SERICICULTOR	1
42678	OCUPACION	624002	CRIADOR, GUSANO DE SEDA	1
42677	OCUPACION	624001	APICULTOR (CRIADOR DE ABEJAS)	1
42676	OCUPACION	623016	TRABAJADOR CALIFICADO, INCUBADORAS	1
42675	OCUPACION	623015	TRABAJADOR CALIFICADO, AVICULTURA	1
42674	OCUPACION	623014	SEXADOR, POLLOS	1
42673	OCUPACION	623013	INSEMINADOR, AVES	1
42672	OCUPACION	623012	GRANJERO, AVICULTOR	1
42671	OCUPACION	623011	CRIADOR, AVES DE CORRAL	1
42670	OCUPACION	623010	CRIADOR, AVES DE CAZA	1
42669	OCUPACION	623009	CLASIFICADOR, POLLOS	1
42668	OCUPACION	623008	AVICULTOR, POLLOS	1
42667	OCUPACION	623007	AVICULTOR, PAVOS	1
42666	OCUPACION	623006	AVICULTOR, PATOS	1
42665	OCUPACION	623005	AVICULTOR, OCAS	1
42664	OCUPACION	623004	AVICULTOR, INCUBACION ARTIFICIAL	1
42663	OCUPACION	623003	AVICULTOR, HUEVOS	1
42662	OCUPACION	623002	AVICULTOR, CRIA/CRIADERO	1
42661	OCUPACION	623001	AVICULTOR	1
42660	OCUPACION	622002	CRIADOR DE CABRAS PARA LA PRODUCCION DE LECHE	1
42659	OCUPACION	622001	CRIADOR DE VACAS LECHERAS	1
42658	OCUPACION	621031	TRABAJADOR PECUARIO CALIFICADO, GANADO PORCINO	1
42657	OCUPACION	621030	TRABAJADOR PECUARIO CALIFICADO, GANADO LANAR	1
42656	OCUPACION	621029	TRABAJADOR PECUARIO CALIFICADO, GANADO VACUNO	1
42655	OCUPACION	621028	TRABAJADOR PECUARIO CALIFICADO, GANADERIA	1
42654	OCUPACION	621027	TRABAJADOR PECUARIO CALIFICADO, CRIADERO DE ANIMALES	1
42653	OCUPACION	621026	TRABAJADOR PECUARIO CALIFICADO	1
42652	OCUPACION	621025	ORDEÐADOR	1
42651	OCUPACION	621024	INSEMINADOR, GANADO	1
42650	OCUPACION	621023	GANADERO PORCINO	1
42649	OCUPACION	621022	GANADERO LANAL	1
42648	OCUPACION	621021	GANADERO CABALLO	1
42647	OCUPACION	621020	GANADERO VACUNO (EXECPTO GANADO LECHERO)	1
42646	OCUPACION	621019	GANADERO, TORO DE LIDIA	1
42645	OCUPACION	621018	GANADERO, CUYES	1
42644	OCUPACION	621017	GANADERO, CUNICULTOR/CONEJO	1
42643	OCUPACION	621016	GANADERO, AUQUENIDOS	1
42642	OCUPACION	621015	GANADERO	1
42641	OCUPACION	621014	JEFE DE CUADRA	1
42640	OCUPACION	621013	ESQUILADOR	1
42639	OCUPACION	621012	CRIADOR, REPRODUCTORES	1
42638	OCUPACION	621011	CRIADOR, GANADO PORCINO	1
42637	OCUPACION	621010	CRIADOR, GANADO OVINO (LANA)	1
42636	OCUPACION	621009	CRIADOR, GANADO CAPRINO/CABRAS (LANA)	1
42635	OCUPACION	621008	CRIADOR, GANADO CABALLAR	1
42634	OCUPACION	621007	CRIADOR, GANADO BOVINO	1
42633	OCUPACION	621006	CRIADOR, GANADO VACUNO (EXCEPTO GANADO LECHERO)	1
42632	OCUPACION	621005	CRIADOR, CUYES	1
42631	OCUPACION	621004	CRIADOR, CORDEROS DE ASTRACAN	1
42630	OCUPACION	621003	CRIADOR, CONEJOS	1
42629	OCUPACION	621002	CRIADOR, CABALLOS	1
42628	OCUPACION	621001	CRIADOR, AUQUENIDOS	1
42627	OCUPACION	617004	TRABAJADOR FORESTAL CALIFICADO, DESTILACION DE MADERA/TECNI	1
42626	OCUPACION	617003	TRABAJADOR CARBONERO CALIFICADO, CARBON VEGETAL/TECNICAS TR	1
42625	OCUPACION	617002	DESTILADOR, MADERA	1
42624	OCUPACION	617001	CARBONERO, CARBON VEGETAL	1
42623	OCUPACION	616026	TROZADOR, VIGAS	1
42622	OCUPACION	616025	TROZADOR, TRAVIESAS DE FERROCARRIL	1
42621	OCUPACION	616024	TROZADOR, ARBOLES	1
42620	OCUPACION	616023	TRABAJADOR FORESTAL CALIFICADO, SILVICULTURA	1
42619	OCUPACION	616022	TRABAJADOR FORESTAL CALIFICADO, REPOBLACION FORESTAL	1
42618	OCUPACION	616021	TRABAJADOR FORESTAL CALIFICADO	1
42617	OCUPACION	616020	TALADOR EN GENERAL (CORTADOR DE ARBOLES)	1
42616	OCUPACION	616019	SECADOR, CORCHO	1
42615	OCUPACION	616018	PODADOR, SILVICULTURA	1
42614	OCUPACION	616017	PLANTADOR, ARBOLES/SILVICULTURA	1
42613	OCUPACION	616016	MARCADOR, ARBOLES	1
42612	OCUPACION	616015	GUARDABOSQUES	1
42611	OCUPACION	616014	GANCHERO FORESTAL	1
42610	OCUPACION	616013	GABARRERO	1
42609	OCUPACION	616012	FLOTADOR, TRONCOS	1
42608	OCUPACION	616011	SUPERVISOR, FORESTAL	1
42607	OCUPACION	616010	ESCUADRADOR, TRONCOS	1
42606	OCUPACION	616009	ESCALADOR-PODADOR, ARBOLES	1
42605	OCUPACION	616008	DESCORTEZADOR, ARBOLES	1
42604	OCUPACION	616007	DESCORCHADOR, ALCORNOQUES	1
42603	OCUPACION	616006	CUBICADOR, MADERA	1
42602	OCUPACION	616005	CORTADOR DE TRAVIESAS DE FERROCARRIL Y/O POSTES	1
42601	OCUPACION	616004	CLASIFICADOR, TRONCOS	1
42600	OCUPACION	616003	ASERRADOR, MONTE	1
42599	OCUPACION	616002	ALMADIERO	1
42598	OCUPACION	616001	EXPLOTADOR, FORESTAL O BOSQUES	1
42597	OCUPACION	615008	TRABAJADOR AGRICOLA CALIFICADO, POLICULTIVOS	1
42596	OCUPACION	615007	GANADERO FORESTAL, TRABAJADOR INDEPENDIENTE	1
42594	OCUPACION	615005	EXPLOTADOR AGROPECUARIO, TRABAJADOR INDEPENDIENTE	1
42593	OCUPACION	615004	EXPLOTADOR AGRICOLA, TRABAJADOR INDEPENDIENTE	1
42592	OCUPACION	615003	AGRICULTOR GANADERO, TRABAJADOR INDEPENDIENTE	1
42591	OCUPACION	615002	AGRICULTOR FORESTAL, TRABAJADOR INDEPENDIENTE	1
42590	OCUPACION	615001	AGRICULTOR (EXPLOTADOR), POLICULTIVOS	1
42589	OCUPACION	614019	TRABAJADOR AGRICOLA CALIFICADO, VIVERO	1
42588	OCUPACION	614018	TRABAJADOR AGRICOLA CALIFICADO, HORTICULTURA	1
42587	OCUPACION	614017	TRABAJADOR AGRICOLA CALIFICADO, CULTIVO DE HONGOS	1
42586	OCUPACION	614016	TRABAJADOR AGRICOLA CALIFICADO, CESPED	1
42585	OCUPACION	614015	JARDINERO, VIVEROS	1
42584	OCUPACION	614014	JARDINERO, SEMILLERO	1
42583	OCUPACION	614013	HORTICULTOR, VIVEROS	1
42582	OCUPACION	614012	HORTICULTOR	1
42581	OCUPACION	614011	HORTELANO	1
42580	OCUPACION	614010	FLORICULTOR, TULIPANES	1
42579	OCUPACION	614009	FLORICULTOR, ROSAS	1
42578	OCUPACION	614008	FLORICULTOR	1
42577	OCUPACION	614007	CULTIVADOR, VIVEROS/SEMILLAS	1
42576	OCUPACION	614006	CULTIVADOR, VIVEROS/HORTALIZAS	1
42575	OCUPACION	614005	CULTIVADOR, VIVEROS/ESPECIAS	1
42574	OCUPACION	614004	CULTIVADOR, VIVEROS/BULBOS	1
42573	OCUPACION	614003	CULTIVADOR, VIVEROS	1
42572	OCUPACION	614002	CULTIVADOR, SETAS Y CHAMPIÐONES	1
42571	OCUPACION	614001	CULTIVADOR, HONGOS	1
42570	OCUPACION	613044	VITICULTOR	1
42569	OCUPACION	613043	VINICULTOR	1
42568	OCUPACION	613042	TRABAJADOR AGRICOLA CALIFICADO, VITICULTURA	1
42567	OCUPACION	613041	TRABAJADOR AGRICOLA CALIFICADO, PLANTACIONES/TE	1
42566	OCUPACION	613040	TRABAJADOR AGRICOLA CALIFICADO, PLANTACIONES/ARBUSTOS	1
42565	OCUPACION	613039	TRABAJADOR AGRICOLA CALIFICADO, LUPULO	1
42564	OCUPACION	613038	TRABAJADOR AGRICOLA CALIFICADO, HUERTOS	1
42563	OCUPACION	613037	TRABAJADOR AGRICOLA CALIFICADO, HEVEA	1
42562	OCUPACION	613036	TRABAJADOR AGRICOLA CALIFICADO, COSECHA/ARBUSTOS	1
42561	OCUPACION	613035	TRABAJADOR AGRICOLA CALIFICADO, CAFE	1
42560	OCUPACION	613034	TRABAJADOR AGRICOLA CALIFICADO, CACAO	1
42559	OCUPACION	613033	TRABAJADOR AGRICOLA CALIFICADO, ARBUSTOS	1
42558	OCUPACION	613032	TRABAJADOR AGRICOLA CALIFICADO, ARBOLES FRUTALES	1
42557	OCUPACION	613031	SHIVINGERO	1
42556	OCUPACION	613030	SANGRADOR, JARABE DE ARCE	1
42555	OCUPACION	613029	SANGRADOR, CAUCHO	1
42554	OCUPACION	613028	SANGRADOR, ARBOLES/EXCEPTO HEVEA	1
42553	OCUPACION	613027	RESINERO	1
42552	OCUPACION	613026	PODADOR-INJERTADOR, ARBUSTOS	1
42551	OCUPACION	613025	PODADOR, ARBOLES FRUTALES	1
42550	OCUPACION	613024	INJERTADOR	1
42549	OCUPACION	613023	FRUTICULTOR	1
42548	OCUPACION	613022	CULTIVADOR EXPLOTADOR, CAUCHO	1
42547	OCUPACION	613021	CULTIVADOR, PLANTACIONES/TE	1
42546	OCUPACION	613020	CULTIVADOR, LUPULO	1
42545	OCUPACION	613019	ARBORICULTOR, PLANTACIONES/TE	1
42544	OCUPACION	613018	ARBORICULTOR, PLANTACIONES/HEVEA	1
42543	OCUPACION	613017	ARBORICULTOR, PLANTACIONES/COPRA	1
42542	OCUPACION	613016	ARBORICULTOR, OLEAGINOSAS	1
42541	OCUPACION	613015	ARBORICULTOR, NOGALES	1
42540	OCUPACION	613014	ARBORICULTOR, LUPULO	1
42539	OCUPACION	613013	ARBORICULTOR, FRUTALES EN GENERAL	1
42538	OCUPACION	613012	ARBORICULTOR, COCOTEROS	1
42537	OCUPACION	613011	ARBORICULTOR, CAFETALES	1
42536	OCUPACION	613010	ARBORICULTOR, CACAO	1
42535	OCUPACION	613009	ARBORICULTOR, ARBUSTOS	1
42534	OCUPACION	613008	ARBORICULTOR, ALMENDROS	1
42533	OCUPACION	613007	AGRICULTOR EXPLOTADOR DE VIA	1
42532	OCUPACION	613006	AGRICULTOR EXPLOTADOR, PLANTACION/HEVEA	1
42531	OCUPACION	613005	AGRICULTOR EXPLOTADOR, PLANTACION/COCOTEROS	1
42530	OCUPACION	613004	AGRICULTOR EXPLOTADOR, PLANTACION/CAFE,TE	1
42529	OCUPACION	613003	AGRICULTOR EXPLOTADOR, PLANTACION/CACAO	1
42528	OCUPACION	613002	AGRICULTOR EXPLOTADOR, CULTIVO/CITRICOS	1
42527	OCUPACION	613001	AGRICULTOR EXPLOTADOR, ALMENDRAS	1
42526	OCUPACION	612035	TRABAJADOR AGRICOLA CALIFICADO, YUTE	1
42525	OCUPACION	612034	TRABAJADOR AGRICOLA CALIFICADO, TRIGO	1
1920	PAIS	642	RUMANIA	1
42524	OCUPACION	612033	TRABAJADOR AGRICOLA CALIFICADO, TABACO	1
42523	OCUPACION	612032	TRABAJADOR AGRICOLA CALIFICADO, REMOLACHA	1
42522	OCUPACION	612031	TRABAJADOR AGRICOLA CALIFICADO, PATATAS	1
42521	OCUPACION	612030	TRABAJADOR AGRICOLA CALIFICADO, LINO	1
42520	OCUPACION	612029	TRABAJADOR AGRICOLA CALIFICADO, IRRIGACION	1
42519	OCUPACION	612028	TRABAJADOR AGRICOLA CALIFICADO, HORTALIZAS	1
42518	OCUPACION	612027	TRABAJADOR AGRICOLA CALIFICADO, CULTIVO EXTENSIVO	1
42517	OCUPACION	612026	TRABAJADOR AGRICOLA CALIFICADO, CAÐA DE AZUCAR	1
42516	OCUPACION	612025	TRABAJADOR AGRICOLA CALIFICADO, CACAHUETES	1
42515	OCUPACION	612024	TRABAJADOR AGRICOLA CALIFICADO, ARROZ	1
42514	OCUPACION	612023	TRABAJADOR AGRICOLA CALIFICADO, ALGODON	1
42513	OCUPACION	612022	PRODUCTOR, SOYA	1
42512	OCUPACION	612021	PRODUCTOR, REMOLACHA AZUCARERA	1
42511	OCUPACION	612020	PRODUCTOR, HORTALIZAS/CULTIVO EXTENSIVO	1
42510	OCUPACION	612019	PRODUCTOR, CULTIVOS EXTENSIVOS	1
42509	OCUPACION	612018	AGRICULTOR EXPLOTADOR, CULTIVO/YUTE	1
42508	OCUPACION	612017	AGRICULTOR EXPLOTADOR, CULTIVO/TRIGO	1
42507	OCUPACION	612016	AGRICULTOR EXPLOTADOR, CULTIVO/TABACO	1
42506	OCUPACION	612015	AGRICULTOR EXPLOTADOR, CULTIVO/SOJA	1
42505	OCUPACION	612014	AGRICULTOR EXPLOTADOR, CULTIVO/SISAL	1
42504	OCUPACION	612013	AGRICULTOR EXPLOTADOR, CULTIVO/REMOLACHA	1
42503	OCUPACION	612012	AGRICULTOR EXPLOTADOR, CULTIVO/MAIZ	1
42502	OCUPACION	612011	AGRICULTOR EXPLOTADOR, CULTIVO/LINO	1
42501	OCUPACION	612010	AGRICULTOR EXPLOTADOR, CULTIVO/HORTALIZAS (CULTIVO EXTENSIV	1
42500	OCUPACION	612009	AGRICULTOR EXPLOTADOR, CULTIVO/GRANO	1
42499	OCUPACION	612008	AGRICULTOR EXPLOTADOR, CULTIVO/FLORES	1
42498	OCUPACION	612007	AGRICULTOR EXPLOTADOR, CULTIVO/CEREALES	1
42497	OCUPACION	612006	AGRICULTOR EXPLOTADOR, CULTIVO/CAÐA DE AZUCAR	1
42496	OCUPACION	612005	AGRICULTOR EXPLOTADOR, CULTIVO/CACAHUETE	1
42495	OCUPACION	612004	AGRICULTOR EXPLOTADOR, CULTIVO/ARROZ	1
42494	OCUPACION	612003	AGRICULTOR EXPLOTADOR, CULTIVO/ALGODON	1
42493	OCUPACION	612002	AGRICULTOR EXPLOTADOR, CULTIVO/ALFALFA	1
42492	OCUPACION	612001	AGRICULTOR	1
42491	OCUPACION	611004	JEFE DE MAQUINARIA AGRICOLA	1
41338	OCUPACION	284010	MONJA	1
42490	OCUPACION	611003	CAPORAL, MAYORDOMO DE HACIENDA	1
42489	OCUPACION	611002	CAPATAZ DE CAMPO DE HACIENDA	1
42488	OCUPACION	611001	CAPATAZ FORESTAL	1
42487	OCUPACION	583001	COMERCIO N.E.	1
42486	OCUPACION	582002	COMPRA VENTA DE MONEDAS Y BILLETES	1
42485	OCUPACION	582001	COMPRADOR VENDEDOR DE ORO, PLATA	1
42484	OCUPACION	581002	VENDEDORES DE LIBROS	1
42483	OCUPACION	581001	VENDEDORES DE ARTEFACTOS ELECTRICOS	1
42482	OCUPACION	575002	VENDEDOR, COMERCIO NEP	1
42481	OCUPACION	575001	EMPLEADO, DEPENDIENTE DE TIENDA, COMERCIO NEP	1
42480	OCUPACION	574002	VENDEDOR EN KIOSCO	1
42479	OCUPACION	574001	VENDEDOR EN PUESTO DE MERCADO	1
42478	OCUPACION	573002	DEMOSTRADOR (A) DE PRODUCTOS PARA LA VENTA EN ESTABLECIMIEN	1
42477	OCUPACION	573001	DEMOSTRADOR (A) DE ARTICULOS	1
42476	OCUPACION	572042	OTROS, COMERCIANTES VENDEDORES AL POR MENOR (NO AMBULATORIO	1
42475	OCUPACION	572041	VENDEDOR, ZAPATERIA	1
42474	OCUPACION	572040	VENDEDOR, SOMBREROS	1
42473	OCUPACION	572039	VENDEDOR, REPUESTOS EN GENERAL	1
42472	OCUPACION	572038	VENDEDOR, PULPA	1
42471	OCUPACION	572037	VENDEDOR, PRENDAS DE VESTIR	1
42470	OCUPACION	572036	VENDEDOR, PELETERO	1
42469	OCUPACION	572035	VENDEDOR, PERFUMERIA	1
42468	OCUPACION	572034	VENDEDOR, PASAMANERIA/MERCERIA	1
42467	OCUPACION	572033	VENDEDOR, MUEBLERIA	1
42466	OCUPACION	572032	VENDEDOR, MATERIALES DE CONSTRUCCION	1
42465	OCUPACION	572031	VENDEDOR, MADERAS/TRIPLAY	1
42464	OCUPACION	572030	VENDEDOR, LOZA/CRISTALERIA Y PORCELANA	1
42463	OCUPACION	572029	VENDEDOR, LIBROS/UTILES ESCOLARES	1
42462	OCUPACION	572028	VENDEDOR, LICORERIA	1
42461	OCUPACION	572027	VENDEDOR, LECHE	1
42460	OCUPACION	572026	VENDEDOR, HERBOLARIOS/HIERBAS	1
42459	OCUPACION	572025	VENDEDOR, FRUTAS	1
42458	OCUPACION	572024	VENDEDOR, FLORES	1
42457	OCUPACION	572023	VENDEDOR, FERRETERIA	1
42456	OCUPACION	572022	VENDEDOR, CIGARRILLOS	1
42455	OCUPACION	572021	VENDEDOR, FARMACIA	1
42454	OCUPACION	572020	VENDEDOR, CARTON/PAPEL	1
42453	OCUPACION	572019	VENDEDOR, CARNE	1
42452	OCUPACION	572018	VENDEDOR, CARBON	1
42451	OCUPACION	572017	VENDEDOR, ARTESANIA	1
42450	OCUPACION	572016	VENDEDOR, ABARROTES/ABACERO (BODEGUERO)	1
42449	OCUPACION	572015	DESPACHADOR, MERCADERIA/COMERCIO AL POR MENOR	1
42448	OCUPACION	572014	COMERCIANTE, REPUESTOS EN GENERAL	1
42447	OCUPACION	572013	COMERCIANTE, PRENDAS DE VESTIR	1
42446	OCUPACION	572012	COMERCIANTE, OPTICA	1
42445	OCUPACION	572011	COMERCIANTE, MUEBLES	1
42444	OCUPACION	572010	COMERCIANTE, LOZA Y PORCELANA	1
42443	OCUPACION	572009	COMERCIANTE, LICORES	1
42442	OCUPACION	572008	COMERCIANTE, JUGUETES	1
42441	OCUPACION	572007	COMERCIANTE, JOYERIA Y RELOJERIA	1
42440	OCUPACION	572006	COMERCIANTE, COMBUSTIBLE/GRIFERO (DESPACHADOR DE GASOLINA)	1
42439	OCUPACION	572005	COMERCIANTE, CARROS	1
42438	OCUPACION	572004	COMERCIANTE, CALZADO	1
42437	OCUPACION	572003	COMERCIANTE, BOUTIQUE	1
42436	OCUPACION	572002	COMERCIANTE, ARTICULOS ELECTRODOMESTICOS	1
42435	OCUPACION	572001	COMERCIANTE, ARTICULOS DEPORTIVOS	1
42434	OCUPACION	571006	VENDEDOR, COMERCIO AL POR MAYOR	1
42433	OCUPACION	571005	VENDEDOR, PROVEEDOR/COMERCIO AL POR MAYOR	1
42432	OCUPACION	571004	VENDEDOR, ABARROTES/COMERCIO AL POR MAYOR	1
42431	OCUPACION	571003	MAYORISTA, COMERCIO AL POR MAYOR	1
42430	OCUPACION	571002	DESPACHADOR, MERCADERIAS/COMERCIO AL POR MAYOR	1
42429	OCUPACION	571001	COMERCIANTE, COMERCIO AL POR MAYOR	1
42428	OCUPACION	565001	DETECTIVE PRIVADO	1
42427	OCUPACION	564005	VIGILANTE DE SEGURIDAD (PRIVADOS)	1
42426	OCUPACION	564004	POLICIA PARTICULAR	1
42425	OCUPACION	564003	GUARDIA DE SEGURIDAD (PRIVADOS)	1
42424	OCUPACION	564002	GUARDAESPALDA	1
42423	OCUPACION	564001	CUSTODIO	1
42422	OCUPACION	563004	VIGILANTE DE ESTABLECIMIENTO PENAL Y OTROS CENTROS TUTELARE	1
42421	OCUPACION	563003	GUARDIAN, PRISION, ESTABLECIMIENTO PENAL	1
42420	OCUPACION	563002	GUARDIAN, CARCEL	1
42419	OCUPACION	563001	CARCELERO	1
42418	OCUPACION	562003	SERENAZGO	1
42417	OCUPACION	562002	POLICIA MUNICIPAL	1
42416	OCUPACION	562001	ALGUACILES	1
42415	OCUPACION	561006	ESPECIALISTA, SALVAMENTO/INCENDIOS (DESASTRES)	1
42414	OCUPACION	561004	BOMBERO, FORESTAL	1
42413	OCUPACION	561003	BOMBERO, AEROPUERTOS	1
42412	OCUPACION	561002	BOMBERO, ACCIDENTES DE AVIACION	1
42411	OCUPACION	561001	BOMBERO	1
42410	OCUPACION	553007	QUIROMANTICO	1
42409	OCUPACION	553006	ONIROMANTICO	1
42408	OCUPACION	553005	NUMEROMANTICO	1
42407	OCUPACION	553004	NUMEROLOGO	1
42406	OCUPACION	553003	GEOMANTICO	1
42405	OCUPACION	553002	CARTOMANTICO	1
42404	OCUPACION	553001	ASTROLOGO	1
42403	OCUPACION	552007	MODELO, PUBLICIDAD	1
42402	OCUPACION	552006	MODELO, PINTORES	1
42401	OCUPACION	552005	MODELO, MODAS	1
42400	OCUPACION	552004	MODELO, ESCULTORES	1
42399	OCUPACION	552003	MODELO, ARTISTA	1
42398	OCUPACION	552002	MODELO DE FOTOGRAFIA	1
42397	OCUPACION	552001	MANIQUI	1
42396	OCUPACION	551006	TRAMITADOR DE DOCUMENTOS PARA SEPELIO	1
42395	OCUPACION	551005	ORGANIZADOR DE POMPAS FUNEBRES	1
42394	OCUPACION	551004	EMPRESARIO, POMPAS FUNEBRES	1
42393	OCUPACION	551003	EMPLEADO, POMPAS FUNEBRES/AGENCIA FUNERARIA	1
42392	OCUPACION	551002	EMBALSAMADOR	1
42390	OCUPACION	541015	PELUQUERO-BARBERO	1
42389	OCUPACION	541014	PELUQUERO, SEÐORAS	1
42388	OCUPACION	541013	PELUQUERO, CABALLEROS	1
42387	OCUPACION	541012	PEINADORA	1
42386	OCUPACION	541011	PEDICURISTA	1
42385	OCUPACION	541010	MASAJISTA ESTETICO	1
42384	OCUPACION	541009	MAQUILLADOR, TEATRO	1
42383	OCUPACION	541008	MAQUILLADOR, SALON	1
42382	OCUPACION	541007	MAQUILLADOR, CINE	1
42381	OCUPACION	541006	MANICURISTA	1
42380	OCUPACION	541005	ESTILISTA	1
42379	OCUPACION	541004	ESPECIALISTA, TRATAMIENTOS DE BELLEZA	1
42378	OCUPACION	541003	COSMETOLOGO	1
42377	OCUPACION	541002	CAPILICULTOR	1
42376	OCUPACION	541001	CALLISTA	1
42375	OCUPACION	531012	AYUDANTE, CONSULTORIO DENTAL	1
42374	OCUPACION	531011	AYUDANTE, ENFERMERIA/DOMICILIO	1
42373	OCUPACION	531010	ENFERMERO, AMBULANCIA	1
42372	OCUPACION	531009	CAMILLERO	1
42371	OCUPACION	531008	AYUDANTE, ENFERMERIA/HOSPITAL	1
42370	OCUPACION	531007	AYUDANTE, ENFERMERIA/CLINICA	1
42369	OCUPACION	531006	AYUDANTE, ENFERMERIA/AMBULANCIA	1
42368	OCUPACION	531005	AYUDANTE, ENFERMERIA	1
42367	OCUPACION	531004	AYUDANTE, AMBULANCIA	1
42366	OCUPACION	531003	AUXILIAR, HOSPITALARIO	1
42365	OCUPACION	531002	AUXILIAR, ENFERMERIA/PRIMEROS AUXILIOS	1
42364	OCUPACION	531001	AUXILIAR, ENFERMERIA	1
42363	OCUPACION	523003	MOZO	1
42362	OCUPACION	523002	BARMAN	1
42361	OCUPACION	523001	AZAFATA, SERVICIO DE COMIDAS/PERSONAL	1
42360	OCUPACION	522005	COCINERO, VEGETALES	1
42359	OCUPACION	522004	COCINERO, DIETAS ESPECIALES	1
42358	OCUPACION	522003	COCINERO, CONSERVACION DE ALIMENTOS	1
42357	OCUPACION	522002	COCINERO, CHEF	1
42356	OCUPACION	522001	COCINERO, BARCO	1
42355	OCUPACION	521006	MAYORDOMO, EXCEPTO HOGAR PARTICULAR	1
42354	OCUPACION	521005	MAESTRESALA	1
42353	OCUPACION	521004	MAITRE	1
42352	OCUPACION	521003	JEFE DE CAMAREROS	1
42351	OCUPACION	521002	JEFE DE PERSONAL DE SERVIDUMBRE, BARCO	1
42350	OCUPACION	521001	ECONOMO, HOSTELERIA	1
42349	OCUPACION	512017	GUIA, VIAJES/TEATRO Y MONUMENTOS	1
42348	OCUPACION	512016	GUIA, VIAJES/SAFARI	1
42347	OCUPACION	512015	GUIA, VIAJES/RESERVA DE CAZA	1
42346	OCUPACION	512014	GUIA, VIAJES/PESCA	1
42345	OCUPACION	512013	GUIA, VIAJES/PARQUES NATURALES Y RESERVAS NACIONALES	1
42344	OCUPACION	512012	GUIA, VIAJES/MUSEOS	1
42343	OCUPACION	512011	GUIA, VIAJES/MONTAÐISMO	1
42342	OCUPACION	512010	GUIA, VIAJES/LOCAL	1
42341	OCUPACION	512009	GUIA, VIAJES/GALERIA DE ARTE	1
42340	OCUPACION	512008	GUIA, VIAJES/ESTABLECIMIENTOS INDUSTRIALES	1
42339	OCUPACION	512007	GUIA, VIAJES/AUTOBUS	1
42338	OCUPACION	512006	GUIA, VIAJES/ANDINISMO	1
42337	OCUPACION	512005	GUIA, TURISMO	1
42336	OCUPACION	512004	GUIA, MUSEOS	1
42335	OCUPACION	512003	GUIA, GALERIA DE ARTE	1
42334	OCUPACION	512002	GUIA, EXPEDICION DE CAZA	1
42333	OCUPACION	512001	GUIA, EXCURSIONES	1
42332	OCUPACION	511009	TRIPULANTE, CABINA/PASAJEROS	1
42331	OCUPACION	511008	PURSERS	1
42330	OCUPACION	511007	FLY HOSTESS, AEROMOZA	1
42329	OCUPACION	511006	CAMARERO, BARCO	1
42328	OCUPACION	511005	AZAFATA, INFORMACION/AEROPUERTO	1
42327	OCUPACION	511004	AZAFATA, AVION	1
42326	OCUPACION	511003	AZAFATA, AEROPUERTO	1
42325	OCUPACION	511002	AEROMOZA, CAMARERA DE AVION	1
42324	OCUPACION	511001	AYUDANTE, VUELO	1
42323	OCUPACION	462007	SEGMENTISTA	1
42322	OCUPACION	462006	EMPLEADO DE OFICINA, OTROS	1
42321	OCUPACION	462005	EMPLEADO, OPERADOR DE MAQUINA MULTICOPISTA	1
42320	OCUPACION	462004	EMPLEADO, OPERADOR DE MAQUINA REPRODUCTORA DE DOCUMENTOS	1
42319	OCUPACION	462003	EMPLEADO, OPERADOR DE FOTOCOPIADORA	1
42318	OCUPACION	462002	EMPLEADO, OPERADOR DE MAQUINA AUTOCOPISTA	1
42317	OCUPACION	462001	AUXILIAR DE OFICINA	1
42316	OCUPACION	461005	SUPERVISOR DE CAMPO	1
42315	OCUPACION	461004	REGISTRADORES	1
42314	OCUPACION	461003	RECOPILADOR DE INFORMACION ESTADISTICA	1
42313	OCUPACION	461002	EMPADRONADORES	1
42312	OCUPACION	461001	ENCUESTADORES	1
42311	OCUPACION	456002	RECIBIDOR DE APUESTAS	1
42310	OCUPACION	456001	CRUPIER, SALA DE JUEGO	1
42309	OCUPACION	455003	TELEFONISTA, PUBLICA O PRIVADA	1
42308	OCUPACION	455002	RADIO-TELEFONISTA, ESTACIONES TERRESTRES	1
42307	OCUPACION	455001	OPERADORA, CENTRAL TELEFONICA	1
42306	OCUPACION	454013	RECEPCIONISTA, MEDICO	1
42305	OCUPACION	454012	RECEPCIONISTA, HOTEL	1
42304	OCUPACION	454011	RECEPCIONISTA, HOSPITAL/CONSULTORIO MEDICO	1
42303	OCUPACION	454010	RECEPCIONISTA, DENTISTA	1
42302	OCUPACION	454009	RECEPCIONISTA	1
42301	OCUPACION	454008	EMPLEADO, INFORMES	1
42300	OCUPACION	454007	EMPLEADO, CONCERTACION DE ENTREVISTAS	1
42299	OCUPACION	454006	EMPLEADO, VIAJES/LINEAS AEREAS	1
42298	OCUPACION	454005	EMPLEADO, VIAJES/FERROCARRILES	1
42297	OCUPACION	454004	EMPLEADO, VIAJES	1
42296	OCUPACION	454003	EMPLEADO, EMISION DE BILLETES/VIAJES	1
42295	OCUPACION	454002	EMPLEADO, AGENCIA DE VIAJES/VENTAS DE BILLETES	1
42294	OCUPACION	454001	EMPLEADO, AGENCIA DE VIAJES	1
42293	OCUPACION	453009	COBRADOR, SEGUROS	1
42292	OCUPACION	453008	COBRADOR, PEAJE	1
42291	OCUPACION	453007	COBRADOR, IMPUESTOS	1
42290	OCUPACION	453006	COBRADOR, FACTURAS	1
42289	OCUPACION	453005	COBRADOR ESPECTACULOS	1
42288	OCUPACION	453004	COBRADOR, DEUDAS	1
42287	OCUPACION	453003	COBRADOR CONTRIBUCIONES	1
42286	OCUPACION	453002	COBRADOR, ALQUILERES	1
42285	OCUPACION	453001	COBRADOR A DOMICILIO, VENTAS A PLAZOS	1
42284	OCUPACION	452002	PRESTAMISTA, PRENDARIO	1
42283	OCUPACION	452001	PRESTAMISTA, DINERO	1
42282	OCUPACION	451021	VENDEDOR DE ESTAMPILLAS	1
42281	OCUPACION	451020	TESORERO	1
42280	OCUPACION	451019	TAQUILLERO	1
42279	OCUPACION	451018	EXPENDEDOR DE GIROS POSTALES	1
42278	OCUPACION	451017	EMPLEADO, VENTANILLA DE CORREOS	1
42277	OCUPACION	451016	EMPLEADO, VENTANILLA DE BANCO	1
42276	OCUPACION	451015	EMPLEADO, OPERACIONES DE CAMBIO	1
42275	OCUPACION	451014	EMPLEADO, EMISION DE BILLETES/EXCEPTO DE VIAJE	1
42274	OCUPACION	451013	CAMBISTA, COMPRA-VENTA  DE DOLARES	1
42273	OCUPACION	451012	CAJERO, VENTA DE BILLETES	1
42272	OCUPACION	451011	CAJERO, TIENDA	1
42271	OCUPACION	451010	CAJERO, RESTAURANTE	1
42270	OCUPACION	451009	CAJERO, OFICINA	1
42269	OCUPACION	451008	CAJERO, MOSTRADOR	1
42268	OCUPACION	451007	CAJERO, HOTEL	1
42267	OCUPACION	451006	CAJERO, EMPRESA/ALMACEN	1
42266	OCUPACION	451005	CAJERO, CONTABILIDAD DE CAJA	1
42265	OCUPACION	451004	CAJERO, COBRADOR DE PEAJES	1
42264	OCUPACION	451003	CAJERO, BANCO	1
42263	OCUPACION	451002	CAJERO, APUESTAS	1
42262	OCUPACION	451001	CAJERO, ALMACEN/AUTOSERVICIO	1
42261	OCUPACION	444006	EMPLEADO, MAQUINA FRANQUEADORA	1
42260	OCUPACION	444005	EMPLEADO, CLASIFICADOR DE DOCUMENTOS	1
42259	OCUPACION	444004	EMPLEADO, ESCRITURAS	1
42258	OCUPACION	444003	EMPLEADO, ELABORACION DE LISTAS	1
42257	OCUPACION	444002	EMPLEADO, CORRECCION DE PRUEBAS/IMPRENTA	1
42256	OCUPACION	444001	CORRECTOR, PRUEBAS DE IMPRENTA	1
42255	OCUPACION	443011	SUPERVISOR, CORREO	1
42254	OCUPACION	443010	PORTAPLIEGO DE OFICINA	1
42253	OCUPACION	443009	MENSAJERO, CORRESPONDENCIA	1
42252	OCUPACION	443008	MANDADERO, OFICINA/CONSERJE DE OFICINA	1
42251	OCUPACION	443007	ESTAFETERO, RECIBIDOR DE CARGAS/CORREO	1
42250	OCUPACION	443006	ENCOMENDERO, REPARTO DE ENCOMIENDAS	1
42249	OCUPACION	443005	ENCARGADO, ENTREGA DE ENCOMIENDAS A DOMICILIO	1
42248	OCUPACION	443004	EMPLEADO, DISTRIBUCION/CORRESPONDENCIA	1
42247	OCUPACION	443003	EMPLEADO DE CORREOS, CORRESPONDENCIA/CLASIFICACION	1
42246	OCUPACION	443002	CLASIFICADOR, CORRESPONDENCIA	1
42245	OCUPACION	443001	CARTERO	1
42244	OCUPACION	442009	EMPLEADO, BIBLIOTECA/PRESTAMO DE LIBROS	1
42243	OCUPACION	442008	EMPLEADO, BIBLIOTECA/INDICE	1
42242	OCUPACION	442007	EMPLEADO, BIBLIOTECA/CLASIFICACION	1
42241	OCUPACION	442006	EMPLEADO, BIBLIOTECA/ADQUISICIONES	1
42240	OCUPACION	442005	EMPLEADO, BIBLIOTECA	1
42239	OCUPACION	442004	EMPLEADO, ARCHIVO/SERVICIOS	1
42238	OCUPACION	442003	AYUDANTE DE BIBLIOTECA	1
42237	OCUPACION	442002	ASISTENTE, BIBLIOTECA	1
42236	OCUPACION	442001	ARCHIVERO, DE MUSEO	1
42235	OCUPACION	441004	JEFE DE SERVICIOS DE TELECOMUNICACIONES	1
42234	OCUPACION	441003	JEFE DE SERVICIOS DE POSTALES	1
42233	OCUPACION	441002	JEFE DE SERVICIOS DE CORREO	1
42232	OCUPACION	441001	JEFE DE OFICINA DE CORREO	1
42231	OCUPACION	436036	INSPECTOR, SERVICIOS/TRANSPORTE POR FERROCARRIL	1
42230	OCUPACION	436035	INSPECTOR, SERVICIOS/TRANSPORTE POR CARRETERA	1
42229	OCUPACION	436034	INSPECTOR, SERVICIOS/CARGA	1
42228	OCUPACION	436033	INSPECTOR, SERVICIOS/BARCAZA	1
42227	OCUPACION	436032	ENCARGADO, SERVICIOS/TRANSPORTE POR CARRETERA (TRAFICO)	1
42226	OCUPACION	436031	ENCARGADO, SERVICIOS/TRANSBORDADOR	1
42225	OCUPACION	436030	ENCARGADO, SERVICIOS/MUELLE	1
42224	OCUPACION	436029	ENCARGADO, SERVICIOS/FERROCARRIL (DEPOSITO)	1
42223	OCUPACION	436028	EMPLEADO, TRANSPORTE POR CARRETERA/TRAFICO	1
42222	OCUPACION	436027	EMPLEADO, TRANSPORTE MARITIMO/MUELLE	1
42221	OCUPACION	436026	EMPLEADO, TRANSPORTE MARITIMO/ESTACION TERMINAL	1
42220	OCUPACION	436025	EMPLEADO, TRANSPORTE AEREO/MOVIMIENTO	1
42219	OCUPACION	436024	EMPLEADO, TRANSPORTE AEREO/EXPEDICION	1
42218	OCUPACION	436023	EMPLEADO, TRANSPORTE	1
42217	OCUPACION	436022	EMPLEADO, OPERACIONES/TRANSPORTE AEREO	1
42216	OCUPACION	436021	EMPLEADO, MOVIMIENTOS/TRENES	1
42215	OCUPACION	436020	EMPLEADO, FERROCARRIL/DEPOSITO	1
42214	OCUPACION	436019	EMPLEADO, DESPACHO/TRANSPORTE POR CARRETERA (EXCEPTO AUTOBU	1
42213	OCUPACION	436018	EMPLEADO, DESPACHO/TRANSPORTE MARITIMO	1
42212	OCUPACION	436017	EMPLEADO, DESPACHO/TRANSPORTE FLUVIAL Y TRANSBORDADOR	1
42211	OCUPACION	436016	EMPLEADO, DESPACHO/TRANSPORTE CARGA	1
42210	OCUPACION	436015	EMPLEADO, DESPACHO/TRANSPORTE AEREO	1
42209	OCUPACION	436014	EMPLEADO, DESPACHO/OLEODUCTO	1
42208	OCUPACION	436013	EMPLEADO, DESPACHO/MUELLES	1
42207	OCUPACION	436012	EMPLEADO, DESPACHO/GASODUCTO	1
42206	OCUPACION	436011	EMPLEADO, DESPACHO/FERROCARRIL	1
42205	OCUPACION	436010	EMPLEADO, DESPACHO/CAMIONES	1
42204	OCUPACION	436009	EMPLEADO, DESPACHO/BARCOS	1
42203	OCUPACION	436008	EMPLEADO, DESPACHO/AUTOBUSES	1
42202	OCUPACION	436007	CONTROLADOR ADMINISTRATIVO, TRANSPORTE POR CARRETERA	1
42201	OCUPACION	436006	CONTROLADOR ADMINISTRATIVO, TRANSPORTE MARITIMO	1
42200	OCUPACION	436005	CONTROLADOR ADMINISTRATIVO, TRANSPORTE FERROVIARIO (CARGAS)	1
42199	OCUPACION	436004	CONTROLADOR ADMINISTRATIVO, TRANSPORTE AEREO	1
42198	OCUPACION	436003	CONTROLADOR ADMINISTRATIVO, TRAFICO AEREO	1
42197	OCUPACION	436002	CONTROLADOR ADMINISTRATIVO, FERROCARRIL/MERCANCIAS	1
41337	OCUPACION	284009	MISIONERO	1
42196	OCUPACION	436001	AGENTE, FERROCARRIL/MERCANCIAS	1
42195	OCUPACION	435004	OTROS JEFES DE TREN, COBRADORES.	1
42194	OCUPACION	435003	CONTROLADOR DE VAGONES DE LUJO Y PULLMAN	1
42193	OCUPACION	435002	CONTROLADORES DE COCHE-CAMA	1
42192	OCUPACION	435001	JEFE DE TREN DE PASAJEROS	1
42191	OCUPACION	434002	JEFE DE OPERACIONES DE VUELO TRANSPORTE AEREO	1
42190	OCUPACION	434001	JEFE DE ESCALA DE TRANSPORTE AEREO	1
42189	OCUPACION	433001	JEFE DE SERVICIOS DE TRANSPORTE POR CARRETERA	1
42188	OCUPACION	432004	JEFE DE TRAFICO, FERROCARRILES	1
42187	OCUPACION	432003	JEFE DE MOVIMIENTO DE TRENES	1
42186	OCUPACION	432002	AGENTE DE LOS SERVICIOS DE TRANSPORTE DE CARGA, FERROCARRIL	1
42185	OCUPACION	432001	AGENTE DE LOS SERVICIOS DE MERCANCIAS, FERROCARRILES	1
42184	OCUPACION	431001	JEFE DE ESTACION DE FERROCARRIL	1
42183	OCUPACION	423015	TRAMITADOR DE OFICINA	1
42182	OCUPACION	423014	CONTROLADOR DE TARJETAS DE PERSONAL	1
42181	OCUPACION	423013	TRAMITADORES (REDACTAN CARTAS, LLENADOR FORMULARIOS, ETC)	1
42180	OCUPACION	423012	SECRETARIO DE JUZGADO, EMPLEADO DE OFICINA	1
42179	OCUPACION	423011	RECOPILADOR DE DIRECTORIOS Y GUIAS	1
42178	OCUPACION	423010	ESCRIBIENTE PUBLICO	1
42177	OCUPACION	423009	ESCRIBIENTE DE PROCURADOR	1
42176	OCUPACION	423008	ESCRIBIENTE DE NOTARIO	1
42175	OCUPACION	423007	ESCRIBIENTE DE ABOGADO	1
42174	OCUPACION	423006	EMPLEADO DE SERVICIOS DE PERSONAL	1
42173	OCUPACION	423005	EMPLEADO DE SERVICIOS ADMINISTRATIVOS, OTROS	1
42172	OCUPACION	423004	EMPLEADO DE OFICINA PUBLICA O PARTICULAR	1
42171	OCUPACION	423003	EMPLEADO DE OFICINA EN GENERAL	1
42170	OCUPACION	423002	EMPLEADO DE CORRESPONDENCIA	1
42169	OCUPACION	423001	EMPLEADO DE AGENCIA DE SEGUROS	1
42168	OCUPACION	422007	EMPLEADO, PROGRAMA DE ABASTECIMIENTO/MATERIALES	1
42167	OCUPACION	422006	EMPLEADO, PLANIFICACION/MATERIALES	1
42166	OCUPACION	422005	EMPLEADO, PLANIFICACION DE LA PRODUCCION/PROGRAMA	1
42165	OCUPACION	422004	EMPLEADO, PLANIFICACION DE LA PRODUCCION/COORDINACION	1
42164	OCUPACION	422003	EMPLEADO, PLANIFICACION DE LA PRODUCCION	1
42163	OCUPACION	422002	EMPLEADO, CALCULO DE MATERIALES	1
42162	OCUPACION	422001	EMPLEADO, ABASTECIMIENTO/MATERIALES	1
42161	OCUPACION	421024	EMPLEADO, KARDISTA/TARJADOR	1
42160	OCUPACION	421023	EMPLEADO, SUMINISTROS	1
42159	OCUPACION	421022	EMPLEADO, SERVICIO DE ALMACENAJE	1
42158	OCUPACION	421021	EMPLEADO, REGISTRADOR/ENTRADAS Y SALIDAS DE MERCADERIAS	1
42157	OCUPACION	421020	EMPLEADO, RECEPCION/MERCADERIA (ALMACEN)	1
42156	OCUPACION	421019	EMPLEADO, MOVIMIENTO/MERCADERIAS	1
42155	OCUPACION	421018	EMPLEADO, MERCADERIAS	1
42154	OCUPACION	421017	EMPLEADO, INTERVENTOR ALMACENISTA	1
42153	OCUPACION	421016	EMPLEADO, HERRAMIENTAS/ALMACEN	1
42152	OCUPACION	421015	EMPLEADO, GUARDAMUEBLES	1
42151	OCUPACION	421014	EMPLEADO, EXPEDICION Y RECEPCION DE MERCADERIA	1
42150	OCUPACION	421013	EMPLEADO, EXISTENCIAS/MERCADERIA	1
42149	OCUPACION	421012	EMPLEADO, EXISTENCIAS/INVENTARIO	1
42148	OCUPACION	421011	EMPLEADO, EXISTENCIAS/CONTROL (REGISTROS)	1
42147	OCUPACION	421010	EMPLEADO, EXISTENCIAS/CONTROL	1
42146	OCUPACION	421009	EMPLEADO, EXISTENCIAS/REGISTRADOR	1
42145	OCUPACION	421008	EMPLEADO, EMBARQUE/MERCADERIA	1
42144	OCUPACION	421007	EMPLEADO, DESPACHO	1
42143	OCUPACION	421006	EMPLEADO, DEPOSITO	1
42142	OCUPACION	421005	EMPLEADO, CONTROL DE PESO	1
42141	OCUPACION	421004	EMPLEADO, CONTABILIDAD/EXISTENCIAS	1
42140	OCUPACION	421003	EMPLEADO, ALMACENAJE Y APROVISIONAMIENTO	1
42139	OCUPACION	421002	EMPLEADO, ABASTECIMIENTO	1
42138	OCUPACION	421001	ALMACENERO	1
42137	OCUPACION	419021	EMPLEADO, VALORES	1
42136	OCUPACION	419020	EMPLEADO, TRANSACCIONES	1
42135	OCUPACION	419019	EMPLEADO, SERVICIOS JURIDICOS	1
42134	OCUPACION	419018	EMPLEADO, SEGUROS/POLIZAS	1
42133	OCUPACION	419017	EMPLEADO, SEGUROS/PAGO DE SUMINISTROS	1
42132	OCUPACION	419016	EMPLEADO, SEGUROS/MODIFICACIONES DE COBERTURA	1
42131	OCUPACION	419015	EMPLEADO, SEGUROS	1
42130	OCUPACION	419014	EMPLEADO, SERVICIOS FINANCIEROS	1
42129	OCUPACION	419013	EMPLEADO, REGISTRO DE TITULOS Y ACCIONES	1
42128	OCUPACION	419012	EMPLEADO, OFICINA DE IMPUESTOS/SELLOS Y TIMBRES	1
42127	OCUPACION	419011	EMPLEADO, INVERSIONES	1
42126	OCUPACION	419010	EMPLEADO, HIPOTECAS	1
42125	OCUPACION	419009	EMPLEADO, FINANZAS	1
42124	OCUPACION	419008	EMPLEADO, ESTADISTICA	1
42123	OCUPACION	419007	EMPLEADO, CREDITOS	1
42122	OCUPACION	419006	EMPLEADO, BOLSA	1
42121	OCUPACION	419005	EMPLEADO, BANCO/PRESTAMOS	1
42120	OCUPACION	419004	EMPLEADO, BANCOS	1
42119	OCUPACION	419003	EMPLEADO ACTUARIAL	1
42118	OCUPACION	419002	CRITICO-CODIFICADOR	1
42117	OCUPACION	419001	AMANUENSE, ESTADISTICA	1
42116	OCUPACION	418021	LISTERO	1
42115	OCUPACION	418020	EMPLEADO, TENEDURIA DE LIBROS	1
42114	OCUPACION	418019	EMPLEADO, SUBASTAS	1
42113	OCUPACION	418018	EMPLEADO, SERVICIO DEL PERSONAL	1
42112	OCUPACION	418017	EMPLEADO, PAGO DE SALARIOS	1
42111	OCUPACION	418016	EMPLEADO, PAGO DE NOMINAS	1
42110	OCUPACION	418015	EMPLEADO, PLANILLERO	1
42109	OCUPACION	418014	EMPLEADO, PAGADOR DE PLANILLAS DE PAGO	1
42108	OCUPACION	418013	EMPLEADO, FACTURAS	1
42107	OCUPACION	418012	EMPLEADO, CONTABILIDAD/VERIFICACION	1
42106	OCUPACION	418011	EMPLEADO, CONTABILIDAD/ESTIMACIONES	1
42105	OCUPACION	418010	EMPLEADO, CONTABILIDAD/DESCUENTOS	1
42104	OCUPACION	418009	EMPLEADO, CONTABILIDAD/CUENTAS CORRIENTES	1
42103	OCUPACION	418008	EMPLEADO, CONTABILIDAD/CALCULO DE INTERESES	1
42102	OCUPACION	418007	EMPLEADO, CONTABILIDAD/CALCULO DE COSTOS	1
42101	OCUPACION	418006	EMPLEADO, CONTABILIDAD	1
42100	OCUPACION	418005	EMPLEADO, CALCULO DE SALARIOS	1
42099	OCUPACION	418004	EMPLEADO, CALCULO DE PRESUPUESTOS	1
42098	OCUPACION	418003	EMPLEADO, CALCULO DE COSTOS	1
42097	OCUPACION	418002	EMPLEADO, CAJA	1
42096	OCUPACION	418001	EMPLEADOS DE CONTABILIDAD Y CALCULO DE COSTOS	1
42095	OCUPACION	417003	OTROS OPERADORES DE MAQUINAS PARA EL TRATAMIENTO AUTOMATICO	1
42094	OCUPACION	417002	OPERADOR,  ORDENADOR ELECTRONICO	1
42093	OCUPACION	417001	OPERADOR, MAQUINA CLASIFICADORA Y TABULADOS	1
42092	OCUPACION	416009	OPERADOR, MAQUINA DE SUMAR	1
42091	OCUPACION	416008	OPERADOR, MAQUINA DE LLEVAR LIBROS	1
42090	OCUPACION	416007	OPERADOR, MAQUINA CONTABLE	1
42089	OCUPACION	416006	OPERADOR, MAQUINA FRANQUEADORA	1
42088	OCUPACION	416005	OPERADOR, MAQUINA DE PREPARAR FACTURAS	1
42087	OCUPACION	416004	OPERADOR, MAQUINA DE CONTABILIDAD	1
42086	OCUPACION	416003	OPERADOR, COMPUTADORA	1
42085	OCUPACION	416002	OPERADOR, CALCULADORA	1
42084	OCUPACION	416001	CALCULISTA A MAQUINA	1
42083	OCUPACION	415014	TIPEO POR COMPUTADORA	1
42082	OCUPACION	415013	VERIFICADOR DEL OPERADOR DE MAQUINA PERFORADORA DE TARJETAS	1
42081	OCUPACION	415012	OPERADOR, ENTRADA DE DATOS/TRANSCRIPCION DE PERFORACIONES (	1
42080	OCUPACION	415011	OPERADOR, ENTRADA DE DATOS/TABULADORA	1
42079	OCUPACION	415010	OPERADOR, ENTRADA DE DATOS/MAQUINA PERFORADORAS (TECLADO)	1
42078	OCUPACION	415009	OPERADOR, ENTRADA DE DATOS/MAQUINA PERFORADORAS (TARJETAS Y	1
42077	OCUPACION	415008	OPERADOR, ENTRADA DE DATOS/MAQUINA PERFORADORAS (CINTAS)	1
42076	OCUPACION	415007	OPERADOR, ENTRADA DE DATOS/MAQUINA CONVERTIDORA (DE TARJETA	1
42075	OCUPACION	415006	OPERADOR, ENTRADA DE DATOS/MAQUINA CONVERTIDORA (DE CINTAS	1
42074	OCUPACION	415005	OPERADOR, ENTRADA DE DATOS/CONVERTIDOR (DE CINTAS A TARJETA	1
42073	OCUPACION	415004	OPERADOR, ENTRADA DE DATOS/COMPUTADORAS	1
42072	OCUPACION	415003	OPERADOR, ENTRADA DE DATOS/CLASIFICADORA	1
42071	OCUPACION	415002	CONTROLADOR, PERFORACIONES	1
42070	OCUPACION	415001	DIGITADOR	1
42069	OCUPACION	414005	TELETIPISTA, TELEX	1
42068	OCUPACION	414004	OPERADOR, TELEIMPRESORA	1
42067	OCUPACION	414003	OPERADOR, TELEGRAFO	1
42066	OCUPACION	414002	OPERADOR, TELEFAX	1
42065	OCUPACION	414001	OPERADOR DE MAQUINA, TRATAMIENTO DE TEXTO	1
42064	OCUPACION	413021	MECANOGRAFICA EN DOMICILIO	1
42063	OCUPACION	413020	TAQUIMECANOGRAFA	1
42062	OCUPACION	413019	TAQUIGRAFA	1
42061	OCUPACION	413018	SECRETARIA-TAQUIMECANOGRAFA	1
42060	OCUPACION	413017	SECRETARIA-TAQUIGRAFA	1
42059	OCUPACION	413016	SECRETARIA, OTROS	1
42058	OCUPACION	413015	SECRETARIA-MECANOGRAFA	1
42057	OCUPACION	413014	SECRETARIA, MEDICO	1
42056	OCUPACION	413012	SECRETARIA, EJECUTIVA/BILINGUE	1
42055	OCUPACION	413011	SECRETARIA, COMERCIAL	1
42054	OCUPACION	413010	SECRETARIA, BILINGUE	1
42053	OCUPACION	413009	SECRETARIA	1
42052	OCUPACION	413008	OFICINISTA-MECANOGRAFA	1
42051	OCUPACION	413007	MECANOGRAFA, TEXTOS	1
42050	OCUPACION	413006	MECANOGRAFA, TAQUIGRAFIA	1
42049	OCUPACION	413005	MECANOGRAFA, MAQUINA PERFORADORA	1
42048	OCUPACION	413004	MECANOGRAFA, FACTURAS	1
42047	OCUPACION	413003	MECANOGRAFA, ESTENOGRAFIA	1
42046	OCUPACION	413002	MECANOGRAFA, ESTADISTICAS	1
42045	OCUPACION	413001	MECANOGRAFA - DACTILOGRAFA	1
42044	OCUPACION	412004	EMPLEADO DE OTROS REGISTROS (ADM. PUBLICA)	1
42043	OCUPACION	412003	EMPLEADO DE REGISTRO PUBLICOS	1
42042	OCUPACION	412002	EMPLEADO DE REGISTRO ELECTORAL	1
42041	OCUPACION	412001	EMPLEADO DE  REGISTRO CIVIL	1
42040	OCUPACION	411009	ENCARGADO DEL SERVICIO DE MANTENIMIENTO DE TRAMITES, ETC.	1
42039	OCUPACION	411008	COORDINADOR	1
42038	OCUPACION	411007	JEFE DE REGISTROS PUBLICOS	1
42037	OCUPACION	411006	JEFE DE PERSONAL ADMINISTRATIVO	1
42036	OCUPACION	411005	JEFE DE EMPLEADOS DE OFICINA, OTROS	1
42035	OCUPACION	411004	JEFE DE BIENESTAR SOCIAL	1
42034	OCUPACION	411003	JEFE DE ARCHIVO Y CORRESPONDENCIA	1
42033	OCUPACION	411002	JEFE DE ALMACEN	1
42032	OCUPACION	411001	JEFE DE ABASTECIMIENTO	1
42031	OCUPACION	396007	CANTOR AMBULANTE	1
42030	OCUPACION	396005	MUSICO AMBULANTE	1
42029	OCUPACION	396004	MUSICO, PEÐAS, SALSODROMOS, RESTAURANTES TURISTICOS	1
42028	OCUPACION	396003	DIRECTOR, ORQUESTA/BAILE	1
42027	OCUPACION	396001	BAILARIN, PEÐAS, SALSODROMOS, RESTAURANTES TURISTICOS	1
42026	OCUPACION	395010	PREDICADOR, SEGLAR	1
42025	OCUPACION	395009	MONJE, NIVEL MEDIO	1
42024	OCUPACION	395008	MONJA, NIVEL MEDIO	1
42023	OCUPACION	395007	MIEMBRO, EJERCITO DE SALVACION	1
42022	OCUPACION	395006	FRAILE	1
42021	OCUPACION	395005	EVANGELIZADOR	1
42020	OCUPACION	395004	DIACONO	1
42019	OCUPACION	395003	DIACONISA	1
42018	OCUPACION	395002	AYUDANTE, CULTO	1
42017	OCUPACION	395001	ACOLITO	1
42016	OCUPACION	394029	OTROS, ATLETAS, DEPORTISTAS Y AFINES	1
42015	OCUPACION	394028	VOLEIBOLISTA	1
42014	OCUPACION	394027	TORERO	1
42013	OCUPACION	394026	PROFESOR, BILLAR	1
42012	OCUPACION	394025	PROFESOR, AJEDREZ	1
42011	OCUPACION	394024	PILOTO, CARRERAS/AUTOMOVILES	1
42010	OCUPACION	394023	PICADOR, TOROS	1
42009	OCUPACION	394022	MONITOR, CULTURA FISICO	1
42008	OCUPACION	394021	LUCHADOR	1
42007	OCUPACION	394020	JUEZ, SALIDA/CARRERAS	1
42006	OCUPACION	394019	JUEZ, CANCHA	1
42005	OCUPACION	394018	JUEZ, BOXEO	1
42004	OCUPACION	394017	JOCKEY	1
42003	OCUPACION	394016	FUTBOLISTA	1
42002	OCUPACION	394015	ENTRENADOR, YOGA	1
42001	OCUPACION	394014	ENTRENADOR, LUCHA	1
42000	OCUPACION	394013	ENTRENADOR, GOLF	1
41999	OCUPACION	394012	ENTRENADOR, BOXEO	1
1921	PAIS	643	RUSIA	1
41998	OCUPACION	394011	ENTRENADOR, ATLETISMO	1
41997	OCUPACION	394010	ENTRENADOR, ARTES MARCIALES	1
41996	OCUPACION	394009	DEPORTISTA, PROFESIONAL	1
41995	OCUPACION	394008	CORREDOR, CICLISTA	1
41994	OCUPACION	394007	CATCHASCANISTA	1
41993	OCUPACION	394006	BOXEADOR	1
41992	OCUPACION	394005	BASKETBOLISTA	1
41991	OCUPACION	394004	BANDERILLERO	1
41990	OCUPACION	394003	AUTOMOVILISTA, CARRERAS	1
41989	OCUPACION	394002	ATLETA	1
41988	OCUPACION	394001	ARBITRO, DEPORTIVO	1
41987	OCUPACION	393030	OTROS, PAYASOS, ACROBATAS Y AFINES	1
41986	OCUPACION	393029	VOLATINERO	1
41985	OCUPACION	393028	VENTRILOCUO	1
41984	OCUPACION	393027	VEDETTE	1
41983	OCUPACION	393026	TRAPECISTA	1
41982	OCUPACION	393025	TITIRITERO	1
41981	OCUPACION	393024	PRESTIDIGITADOR	1
41980	OCUPACION	393023	PAYASO	1
41979	OCUPACION	393022	MALABARISTA	1
41978	OCUPACION	393021	MAGO	1
41977	OCUPACION	393020	IMITADOR, RUIDOS DE ANIMALES	1
41976	OCUPACION	393019	IMITADOR	1
41975	OCUPACION	393018	ILUSIONISTA	1
41974	OCUPACION	393017	HIPNOTIZADOR	1
41973	OCUPACION	393016	FUNAMBULO	1
41972	OCUPACION	393015	EXTRAS, DOBLES	1
41971	OCUPACION	393014	EQUILIBRISTA	1
41970	OCUPACION	393013	ENCANTADOR, SERPIENTES	1
41969	OCUPACION	393012	DOMADOR, FIERAS	1
41968	OCUPACION	393011	DOMADOR, CIRCO	1
41967	OCUPACION	393010	CONTORSIONISTA	1
41966	OCUPACION	393009	COMICO, CIRCO	1
41965	OCUPACION	393008	COMICO	1
41964	OCUPACION	393007	CABALLISTA, CIRCO	1
41963	OCUPACION	393006	ARTISTA, TRAPECIO	1
41962	OCUPACION	393005	ARTISTA, STRIP-TEASE	1
41961	OCUPACION	393004	ARTISTA, MARIONETAS	1
41960	OCUPACION	393003	AMAESTRADOR, FIERAS	1
41959	OCUPACION	393002	AMAESTRADOR, ELEFANTES	1
41958	OCUPACION	393001	ACROBATA	1
41957	OCUPACION	392009	TECNICO EN COMUNICACION	1
41956	OCUPACION	392008	PRESENTADOR-ANIMADOR, ESPECTACULOS PUBLICOS	1
41955	OCUPACION	392007	PRESENTADOR-ANIMADOR	1
41954	OCUPACION	392006	LOCUTOR, TELEVISION	1
41953	OCUPACION	392005	LOCUTOR, RADIO	1
41952	OCUPACION	392004	LOCUTOR, NOTICIAS	1
41951	OCUPACION	392003	CRONISTA, NOTICIARIOS	1
41950	OCUPACION	392002	COMENTARISTA-ENTREVISTADOR, TELEVISION - RADIO	1
41949	OCUPACION	392001	ANFITRION	1
41948	OCUPACION	391033	PINTOR, TATUAJES	1
41947	OCUPACION	391032	HERALDISTA	1
41946	OCUPACION	391031	ESCAPARATISTA DECORADOR	1
41945	OCUPACION	391030	DISEÐADOR, TELAS Y TEJIDOS	1
41944	OCUPACION	391029	DISEÐADOR, PRODUCTOS INDUSTRIALES	1
41943	OCUPACION	391028	DISEÐADOR, PRODUCTOS COMERCIALES	1
41942	OCUPACION	391027	DISEÐADOR, PRENDAS DE VESTIR	1
41941	OCUPACION	391026	DISEÐADOR, PIEZAS DE CERAMICA	1
41940	OCUPACION	391025	DISEÐADOR, ORFEBRERIA	1
41939	OCUPACION	391024	DISEÐADOR, MUEBLES	1
41938	OCUPACION	391023	DISEÐADOR, MODA	1
41937	OCUPACION	391022	DISEÐADOR, JOYAS	1
41936	OCUPACION	391021	DISEÐADOR, INDUSTRIAL	1
41935	OCUPACION	391020	DISEÐADOR, HERRERIA ARTISTICA	1
41934	OCUPACION	391019	DISEÐADOR, HERALDISTA	1
41933	OCUPACION	391018	DISEÐADOR, GRAFICO	1
41932	OCUPACION	391017	DISEÐADOR, EXPOSICIONES	1
41931	OCUPACION	391016	DISEÐADOR, ESCAPARATISTA	1
41930	OCUPACION	391015	DISEÐADOR, ENVASES	1
41929	OCUPACION	391014	DISEÐADOR, DECORADOR/ESCENARIOS DE TEATRO	1
41928	OCUPACION	391013	DISEÐADOR, DECORADOR	1
41927	OCUPACION	391012	DISEÐADOR, DECORACION DE INTERIORES	1
41926	OCUPACION	391011	DISEÐADOR, ALFOMBRAS	1
41925	OCUPACION	391010	DIBUJANTE, MODA	1
41924	OCUPACION	391009	DIBUJANTE, INTERIORES	1
41923	OCUPACION	391008	DIBUJANTE, ILUSTRACIONES	1
41922	OCUPACION	391007	DIBUJANTE, CARTELES	1
41921	OCUPACION	391006	DECORADOR, INTERIORES	1
41920	OCUPACION	391005	DECORADOR EXPOSICIONES	1
41919	OCUPACION	391004	DECORADOR, ESCAPARATES	1
41918	OCUPACION	391003	DECORADOR PROYECTISTA, CINE Y TEATRO	1
41917	OCUPACION	391002	DECORADOR DE AMBIENTE	1
41916	OCUPACION	391001	BLASONISTAS	1
41915	OCUPACION	383007	FUNCIONARIO, PERMISOS DE CONSTRUCCION	1
41914	OCUPACION	383006	FUNCIONARIO, INMIGRACION	1
41913	OCUPACION	383005	FUNCIONARIO, EXPEDICION DE PASAPORTES	1
41912	OCUPACION	383004	FUNCIONARIO, EXPEDICION DE LICENCIAS/IMPORTACION	1
41911	OCUPACION	383003	FUNCIONARIO, EXPEDICION DE LICENCIAS/EXPORTACION	1
41910	OCUPACION	383002	FUNCIONARIO, EXPEDICION DE LICENCIAS Y PERMISOS	1
41909	OCUPACION	383001	FUNCIONARIO, PRESTACIONES SOCIALES Y OTROS	1
41908	OCUPACION	382003	RECAUDADOR, IMPUESTOS	1
41907	OCUPACION	382002	INSPECTOR, HACIENDA	1
41906	OCUPACION	382001	EMPLEADO, FISCO	1
41905	OCUPACION	381015	TENEDOR DE LIBROS	1
41904	OCUPACION	381014	SECRETARIO, JUZGADO, TECNICO	1
41903	OCUPACION	381013	REDACTOR, POLIZAS/SEGUROS	1
41902	OCUPACION	381012	PASANTE, NOTARIO	1
41901	OCUPACION	381011	PASANTE, ESCRIBANO	1
41900	OCUPACION	381010	PASANTE, ABOGADO	1
41899	OCUPACION	381009	EVALUADOR, SEGUROS/PRIMAS	1
41898	OCUPACION	381008	AYUDANTE, CONTABLE	1
41897	OCUPACION	381007	AUXILIAR MATEMATICO	1
41896	OCUPACION	381006	AUXILIAR ESTADISTICO (EMPLEADO ESTADISTICO)	1
41895	OCUPACION	381005	AUXILIAR, CONTADOR	1
41894	OCUPACION	381004	AUXILIAR, BUFETE/ABOGADO	1
41893	OCUPACION	381003	AUXILIAR, AGENTE DE BOLSA	1
41892	OCUPACION	381002	AUXILIAR, ACTUARIO	1
41891	OCUPACION	381001	AUXILIAR, ABOGACIA	1
41890	OCUPACION	379019	REPRESENTANTE, SERVICIOS A LAS EMPRESAS/ESPACIOS PUBLICITAR	1
41889	OCUPACION	379018	REPRESENTANTE, SERVICIOS A LAS EMPRESAS	1
41888	OCUPACION	379017	PROMOTOR, DEPORTES	1
41887	OCUPACION	379016	ORGANIZADOR DE ESPECTACULO, VARIOS	1
41886	OCUPACION	379015	FUNCIONARIO, SERVICIO DEL EMPLEO/JOVENES	1
41885	OCUPACION	379014	FUNCIONARIO, SERVICIO DEL EMPLEO	1
41884	OCUPACION	379013	EMPRESARIO, TEATRO	1
41883	OCUPACION	379012	EMPRESARIO, MUSICA	1
41882	OCUPACION	379011	EMPRESARIO, CIRCO	1
41881	OCUPACION	379010	CONTRATISTA, MANO DE OBRA	1
41880	OCUPACION	379009	AGENTE, VENTA DE PUBLICIDAD/ESPACIOS	1
41879	OCUPACION	379008	AGENTE, TEATRO	1
41878	OCUPACION	379007	AGENTE, SERVICIOS A LAS EMPRESAS	1
41877	OCUPACION	379006	AGENTE, PUBLICIDAD	1
41876	OCUPACION	379005	AGENTE, MUSICAL	1
41875	OCUPACION	379004	AGENTE, LITERARIO	1
41874	OCUPACION	379003	AGENTE, DEPORTIVO	1
41873	OCUPACION	379002	AGENTE, OFICINA DE COLOCACION	1
41872	OCUPACION	379001	AGENTE TRANSPORTE Y/O MUDANZA	1
41871	OCUPACION	378003	AGENTE DE SERVICIO DE ADUANA, NO EMPLEADO PUBLICO	1
41870	OCUPACION	378002	AGENTES DE VENTAS, SERVICIO DE ILUMINACION Y LIMPIEZA	1
41869	OCUPACION	378001	AGENTE DE VENTAS, SERVICIO DE PROTECCION  CONTRA ROBOS E IN	1
41868	OCUPACION	377014	VISTA DE ADUANAS	1
41867	OCUPACION	377013	OFICIAL DE RESGUARDO DE ADUANA	1
41866	OCUPACION	377012	INSPECTOR, POLICIA DE FRONTERAS	1
41865	OCUPACION	377011	INSPECTOR, PASAPORTES	1
41864	OCUPACION	377010	FUNCIONARIO, CONSULADO	1
41863	OCUPACION	377009	CORREO DIPLOMATICO	1
41862	OCUPACION	377008	AGENTE, SERVICIOS DE ALMACENAMIENTO	1
41861	OCUPACION	377007	AGENTE, INMIGRACION Y MIGRACION	1
41860	OCUPACION	377006	AGENTE, FISCAL/ARANCELES	1
41859	OCUPACION	377005	AGENTE, ADUANA	1
41858	OCUPACION	377004	AGENTES DE ADUANAS E INSPECTORES DE FRONTERA	1
41857	OCUPACION	377003	AGENTE ADMINISTRATIVO, CONSULADO/ADUANAS	1
41856	OCUPACION	377002	AGENTE ADMINISTRATIVO, ADMINISTRACION PUBLICA/IMPUESTOS	1
41855	OCUPACION	377001	ADUANERO	1
41854	OCUPACION	376015	VERIFICADOR, SOLICITUDES DE INDEMNIZACION	1
41853	OCUPACION	376014	TASADOR, SINIESTROS	1
41852	OCUPACION	376013	TASADOR, SEGUROS	1
41851	OCUPACION	376012	TASADOR	1
41850	OCUPACION	376011	SUBASTADOR	1
41849	OCUPACION	376010	REMATADOR	1
41848	OCUPACION	376009	MARTILLERO, SUBASTAS PUBLICAS	1
41847	OCUPACION	376008	LIQUIDADOR, RECLAMACIONES/SEGUROS	1
41846	OCUPACION	376007	INSPECTOR, SINIESTROS	1
41845	OCUPACION	376006	EVALUADOR	1
41844	OCUPACION	376005	COMPRADOR, MERCANCIAS/COMERCIO MINORISTA	1
41843	OCUPACION	376004	COMPRADOR, MERCANCIAS/COMERCIO MAYORISTA	1
41842	OCUPACION	376003	COMPRADOR	1
41841	OCUPACION	376002	AGENTE, SUMINISTROS	1
41840	OCUPACION	376001	AGENTE, COMPRAS/SUMINISTROS	1
41839	OCUPACION	375020	VISITADOR MEDICO	1
41838	OCUPACION	375019	VIAJANTE, COMERCIO/AGENTE	1
41837	OCUPACION	375018	VENDEDOR, TECNICO	1
41836	OCUPACION	375017	VENDEDOR, INDUSTRIA MANUFACTURERA	1
41835	OCUPACION	375016	VENDEDOR, COMERCIO	1
41834	OCUPACION	375015	REPRESENTANTE, VENTAS/TECNICO	1
41833	OCUPACION	375014	REPRESENTANTE, VENTAS/INDUSTRIA MANUFACTURERA	1
41832	OCUPACION	375013	REPRESENTANTE, VENTAS/COMERCIO	1
41831	OCUPACION	375012	REPRESENTANTE, INSTITUCION COMERCIAL	1
41830	OCUPACION	375011	REPRESENTANTE, FIRMAS EXTRANJERAS	1
41829	OCUPACION	375010	REPRESENTANTE, FABRICA/CONCESIONARIO	1
41828	OCUPACION	375009	REPRESENTANTE,  COMPAÐIA NACIONAL	1
41827	OCUPACION	375008	INSPECTOR TECNICO, VENTAS	1
41826	OCUPACION	375007	CORREDOR, FABRICA	1
41825	OCUPACION	375006	CONSEJERO, SERVICIO POSTVENTA	1
41824	OCUPACION	375005	AGENTE, VENTAS/TECNICO	1
41823	OCUPACION	375004	AGENTE, VENTAS/INDUSTRIA MANUFACTURERA	1
41822	OCUPACION	375003	AGENTE, VENTAS/COMERCIO	1
41821	OCUPACION	375002	AGENTE, VENTAS	1
41820	OCUPACION	375001	AGENTE DISTRIBUIDOR	1
41819	OCUPACION	374006	ORGANIZADOR, VIAJES	1
41818	OCUPACION	374005	CONSEJERO, TURISMO	1
41817	OCUPACION	374004	AGENTE, VIAJES	1
41816	OCUPACION	374003	AGENTE, TURISMO	1
1922	PAIS	674	SAN MARINO	1
41815	OCUPACION	374002	AGENTE ADMINISTRATIVO, CONSULADO/SERVICIO DE TURISMO	1
41814	OCUPACION	374001	AGENTE ADMINISTRATIVO, ADMINISTRACION PUBLICA/SERVICIO DE TURISMO	1
41813	OCUPACION	373005	VENDEDOR, PROPIEDADES INMUEBLES	1
41812	OCUPACION	373004	VENDEDOR, BIENES RAICES	1
41811	OCUPACION	373003	CORREDOR, FINCAS	1
41810	OCUPACION	373002	AGENTE INMOBILIARIO	1
41809	OCUPACION	373001	ADMINISTRADOR, PROPIEDADES INMUEBLES	1
41808	OCUPACION	372006	VENDEDOR DE POLIZAS DE SEGUROS	1
41807	OCUPACION	372005	NEGOCIADOR, SEGUROS	1
41806	OCUPACION	372004	CORREDOR, SEGUROS	1
41805	OCUPACION	372003	ASEGURADOR, MARITIMO	1
41804	OCUPACION	372002	ASEGURADOR	1
41803	OCUPACION	372001	AGENTE, SEGUROS	1
41802	OCUPACION	371005	CORREDOR, VALORES	1
41801	OCUPACION	371004	CORREDOR, BOLSA	1
41800	OCUPACION	371003	ASESOR, INVERSIONES	1
41799	OCUPACION	371002	AGENTE, CAMBIO	1
41798	OCUPACION	371001	AGENTE, BOLSA	1
41797	OCUPACION	367002	PROMOTOR SOCIAL (TECNICO ASIMILADO)	1
41796	OCUPACION	367001	TECNICO EN CIENCIAS SOCIALES	1
41795	OCUPACION	366006	TECNICOS CONTABLES, OTROS	1
41794	OCUPACION	366005	TECNICO EN TENEDURIA DE LIBROS	1
41793	OCUPACION	366004	TECNICO CONTABLE GUBERNAMENTAL	1
41792	OCUPACION	366003	TECNICO CONTABLE EMPRESARIAL	1
41791	OCUPACION	366002	TECNICO CONTABLE EN COSTOS	1
41790	OCUPACION	366001	CONTADOR MERCANTIL	1
41789	OCUPACION	365005	TECNICO, PLANIFICACION	1
41788	OCUPACION	365004	TECNICO, MERCADOTECNIA (MARKETTING)	1
41787	OCUPACION	365003	TECNICO, ECONOMIA	1
41786	OCUPACION	365002	TECNICO, COOPERATIVISMO	1
41785	OCUPACION	365001	TECNICO, COMERCIO	1
41784	OCUPACION	364006	TECNICOS EN RACIONALIZACION ADMINISTRATIVA	1
41783	OCUPACION	364005	TECNICOS ADMINISTRADORES, OTROS	1
41782	OCUPACION	364004	ADMINISTRADOR, PERSONAL	1
41781	OCUPACION	364003	ADMINISTRADOR, MATERIAL CONTABLE	1
41780	OCUPACION	364002	ADMINISTRADOR, HOGAR/ECONOMOS	1
41779	OCUPACION	364001	ADMINISTRADOR, ABASTECIMIENTO	1
41778	OCUPACION	363001	SUPERVISOR, COMERCIO N.E.P	1
41777	OCUPACION	362002	SUPERVISOR DE VENTAS, COMERCIO AL POR MENOR	1
41776	OCUPACION	362001	INSPECTOR JEFE, COMERCIO AL POR MENOR	1
41775	OCUPACION	361002	SUPERVISOR DE VENTAS, COMERCIO AL POR MAYOR	1
41774	OCUPACION	361001	INSPECTOR JEFE, COMERCIO AL POR MAYOR	1
41773	OCUPACION	356002	TECNICO DE SALUD	1
41772	OCUPACION	356001	TECNICO EN LABORATORIO CLINICO	1
41771	OCUPACION	355004	TECNOLOGO MEDICO	1
41770	OCUPACION	355003	TECNICO RADIOLOGO	1
41769	OCUPACION	355002	TECNOLOGO PROTESIS	1
41768	OCUPACION	355001	TECNICO ORTOPEDICO	1
41767	OCUPACION	354008	NATUROPATA	1
41766	OCUPACION	354007	HUESERO	1
41765	OCUPACION	354006	HERBOLARIO	1
41764	OCUPACION	354005	ESPECIALISTA EN ORTOPTIA Y/O ORTOFONIA	1
41763	OCUPACION	354004	CURANDERO, SUGESTION	1
41762	OCUPACION	354003	CURANDERO, RELIGIOSO	1
41761	OCUPACION	354002	CURANDERO-NATURISTA, ALDEA	1
41760	OCUPACION	354001	CURANDERO	1
41759	OCUPACION	353004	PARTERA PRACTICA	1
41758	OCUPACION	353003	MATRONA (PARTERA PRACTICA)	1
41757	OCUPACION	353002	COMADRONA (PARTERA PRACTICA)	1
41756	OCUPACION	353001	AUXILIAR DE PARTERA	1
41755	OCUPACION	352014	PARAMEDICOS	1
41754	OCUPACION	352013	HERMANA, ENFERMERA/NIVEL MEDIO	1
41753	OCUPACION	352012	ENFERMERO, NIVEL MEDIO/PEDIATRIA	1
41752	OCUPACION	352011	ENFERMERO, NIVEL MEDIO/ORTOPEDIA	1
41751	OCUPACION	352010	ENFERMERO, NIVEL MEDIO/OBSTETRICIA	1
41750	OCUPACION	352009	ENFERMERO, NIVEL MEDIO/CLINICA	1
41749	OCUPACION	352008	ENFERMERO, NIVEL MEDIO	1
41748	OCUPACION	352007	ENFERMERA, NIVEL MEDIO/PEDIATRIA	1
41747	OCUPACION	352006	ENFERMERA, NIVEL MEDIO/ORTOPEDIA	1
41746	OCUPACION	352005	ENFERMERA, NIVEL MEDIO/OBSTETRICIA	1
41745	OCUPACION	352004	ENFERMERA, NIVEL MEDIO/MATERNIDAD	1
41744	OCUPACION	352003	ENFERMERA, NIVEL MEDIO/CLINICA, CENTRO DE SALUD, ETC.	1
41743	OCUPACION	352002	ENFERMERA, NIVEL MEDIO	1
41742	OCUPACION	352001	ENFERMERA, NIVEL SUPERIOR (DIPLOMADOS)	1
41741	OCUPACION	351004	PRACTICO EN FARMACIA	1
41740	OCUPACION	351003	PRACTICANTE DE FARMACIA	1
41739	OCUPACION	351002	AUXILIAR FARMACEUTICO	1
41738	OCUPACION	351001	ASISTENTE, FARMACEUTICO	1
41737	OCUPACION	349006	VETERINARIO EN SALUD PUBLICA, TECNICO	1
41736	OCUPACION	349005	VACUNADOR, VETERINARIO/AVES DE GRANJA	1
41735	OCUPACION	349004	VACUNADOR, VETERINARIO	1
41734	OCUPACION	349003	TECNICO VETERINARIO, INSEMINACION ARTIFICIAL	1
41733	OCUPACION	349002	AUXILIAR VETERINARIO	1
41732	OCUPACION	349001	ASISTENTE, VETERINARIO	1
41731	OCUPACION	348015	TERAPEUTA, READAPTACION PROFESIONAL	1
41730	OCUPACION	348014	TERAPEUTA, READAPTACION FISICA	1
41729	OCUPACION	348013	TECNICO, READAPTACION PROFESIONAL	1
41728	OCUPACION	348012	TECNICO, GIMNASIA MEDICA	1
41727	OCUPACION	348011	QUIROPRACTICO	1
41726	OCUPACION	348010	QUIROPODISTA	1
41725	OCUPACION	348009	PODOLOGO	1
41724	OCUPACION	348008	OSTEOPATA	1
41723	OCUPACION	348007	MASAJISTA	1
41722	OCUPACION	348006	KINESITERAPEUTA (KINESIOLOGOS)	1
41721	OCUPACION	348005	HIDROTERAPEUTA	1
41720	OCUPACION	348004	FISIOTERAPEUTA (TERAPEUTA)	1
41719	OCUPACION	348003	ERGOTERAPEUTA	1
41718	OCUPACION	348002	ELECTROTERAPEUTA	1
41717	OCUPACION	348001	BAÐOS MEDICINALES, TRATAMIENTO	1
41716	OCUPACION	347005	PRACTICANTE DE ODONTOLOGIA	1
41715	OCUPACION	347004	HIGIENISTA, PROFILAXIA	1
41714	OCUPACION	347003	HIGIENISTA, BUCODENTAL	1
41713	OCUPACION	347002	AUXILIAR, DENTISTA	1
41712	OCUPACION	347001	ASISTENTE DENTISTA, ESCUELAS	1
41711	OCUPACION	346004	OPTOMETRISTA	1
41710	OCUPACION	346003	OPTICO, OFTALMOLOGIA	1
41709	OCUPACION	346002	OPTICO, ANTEOJOS	1
41707	OCUPACION	345005	TECNICO NUTRICIONISTA, SALUD PUBLICA	1
41706	OCUPACION	345004	TECNICO DIETISTA, DIETETICO MEDICA	1
41705	OCUPACION	345003	TECNICO DIETISTA	1
41704	OCUPACION	345002	TECNICO CONSEJERO DIETETICO, INDUSTRIA DE ALIMENTOS	1
41703	OCUPACION	345001	TECNICO BROMATOLOGO	1
41702	OCUPACION	344002	INSPECTOR, SANIDAD	1
41701	OCUPACION	344001	HIGIENISTA	1
41700	OCUPACION	343006	TOPIQUERO	1
41699	OCUPACION	343005	SANITARIO	1
41698	OCUPACION	343004	PRACTICANTE EN MEDICINA	1
41697	OCUPACION	343003	AUXILIAR MEDICO	1
41696	OCUPACION	343002	ASISTENTE MEDICO, PLANIFICACION FAMILIAR	1
41695	OCUPACION	343001	ASISTENTE MEDICO	1
41694	OCUPACION	342016	TECNICO, ZOOLOGIA EN AGRONOMIA, ZOOTECNIA Y SILVICULTURA	1
41693	OCUPACION	342015	TECNICO, SILVICULTURA	1
41692	OCUPACION	342014	TECNICO, POMOLOGIA	1
41691	OCUPACION	342013	TECNICO, OLEICULTURA	1
41690	OCUPACION	342012	TECNICO, HORTICULTURA	1
41689	OCUPACION	342011	TECNICO, GANADERIA (PECUARIO)	1
41688	OCUPACION	342010	TECNICO, FORESTAL	1
41687	OCUPACION	342009	TECNICO, AGROPECUARIO	1
41686	OCUPACION	342008	TECNICO AGRONOMO, SUELO	1
41685	OCUPACION	342007	TECNICO AGRONOMO	1
41684	OCUPACION	342006	PERITO AGRICOLA	1
41683	OCUPACION	342005	EXTENSIONISTA AGRICOLA, VULGARIZADOR, AGRICOLA	1
41682	OCUPACION	342004	CONSEJERO, FORESTAL	1
41681	OCUPACION	342003	CONSEJERO, AGRICOLA	1
41680	OCUPACION	342002	DEMOSTRADOR, PRACTICAS AGRICOLAS	1
41679	OCUPACION	342001	ANIMADOR RURAL	1
41678	OCUPACION	341020	TECNICO, ZOOLOGIA EN CIENCIAS BIOLOGICAS	1
41677	OCUPACION	341019	TECNICO, TEJIDOS	1
41676	OCUPACION	341018	TECNICO, SEROLOGIA	1
41675	OCUPACION	341017	TECNICO, PATOLOGIA	1
41674	OCUPACION	341016	TECNICO, LABORATORIO BIOLOGICO	1
41673	OCUPACION	341015	TECNICO, HISTOLOGIA	1
41672	OCUPACION	341014	TECNICO, FISIOLOGIA	1
41671	OCUPACION	341013	TECNICO, FARMACOLOGIA	1
41670	OCUPACION	341012	TECNICO, ECOLOGIA	1
41669	OCUPACION	341011	TECNICO, CITOLOGIA	1
41668	OCUPACION	341010	TECNICO, CIENCIAS BIOLOGICAS/OTROS	1
41667	OCUPACION	341009	TECNICO, BOTANICA	1
41666	OCUPACION	341008	TECNICO, BIOQUIMICA	1
41665	OCUPACION	341007	TECNICO, BIOLOGIA (ANALISTA)	1
41664	OCUPACION	341006	TECNICO, BIOFISICA	1
41663	OCUPACION	341005	TECNICO, BANCOS DE SANGRE	1
41662	OCUPACION	341004	TECNICO, BACTERIOLOGIA	1
41661	OCUPACION	341003	TECNICO, ANATOMIA	1
41660	OCUPACION	341002	TAXIDERMISTA (NATURALISTA-PREPARADOR)	1
41659	OCUPACION	341001	DISECADOR-TAXIDERMISTA	1
41658	OCUPACION	335032	TECNICO, PREVENCION DE INCENDIOS	1
41657	OCUPACION	335031	REVISOR-PROBADOR, MAQUINA	1
41656	OCUPACION	335030	REVISOR-INSPECTOR, CALIDAD	1
41655	OCUPACION	335029	REVISOR/TELAS	1
41654	OCUPACION	335028	REVISOR, TEJIDOS, TECNICOS	1
41653	OCUPACION	335027	INSPECTOR, VEHICULOS/ESPECIFICACIONES TECNICAS	1
41652	OCUPACION	335026	INSPECTOR, SEGURIDAD/PRODUCTOS	1
41651	OCUPACION	335025	INSPECTOR, SEGURIDAD Y SALUD/VEHICULOS	1
41650	OCUPACION	335024	INSPECTOR, SEGURIDAD Y SALUD/TRATAMIENTO DE DESECHOS INDUST	1
41649	OCUPACION	335023	INSPECTOR, SEGURIDAD Y SALUD/TRABAJO	1
41648	OCUPACION	335022	INSPECTOR, SEGURIDAD Y SALUD/TIENDAS Y COMERCIOS	1
41647	OCUPACION	335021	INSPECTOR, SEGURIDAD Y SALUD/SEGURIDAD INDUSTRIAL	1
41646	OCUPACION	335020	INSPECTOR, SEGURIDAD Y SALUD/PROTECCION DE LOS CONSUMIDORES	1
41645	OCUPACION	335019	INSPECTOR, SEGURIDAD Y SALUD/FABRICA	1
41644	OCUPACION	335018	INSPECTOR, SEGURIDAD Y SALUD/ESTABLECIMIENTOS	1
41643	OCUPACION	335017	INSPECTOR, SEGURIDAD Y SALUD/ELECTRICIDAD	1
41642	OCUPACION	335016	INSPECTOR, SEGURIDAD Y SALUD/CUIDADOS A LOS NIÐOS	1
41641	OCUPACION	335015	INSPECTOR, SEGURIDAD Y SALUD/CONTAMINACION DEL MEDIO AMBIEN	1
41640	OCUPACION	335014	INSPECTOR, SEGURIDAD Y SALUD	1
41639	OCUPACION	335013	INSPECTOR, CONTROL DE CALIDAD/TEJIDOS	1
41638	OCUPACION	335012	INSPECTOR, CONTROL DE CALIDAD/SERVICIOS	1
41637	OCUPACION	335011	INSPECTOR, CONTROL DE CALIDAD/PRODUCTOS MECANICOS	1
41636	OCUPACION	335010	INSPECTOR, CONTROL DE CALIDAD/PROCESOS INDUSTRIALES	1
41635	OCUPACION	335009	INSPECTOR, CONTROL DE CALIDAD/MAQUINAS	1
41634	OCUPACION	335008	INSPECTOR, CONTROL DE CALIDAD/EQUIPOS ELECTRONICOS	1
41633	OCUPACION	335007	INSPECTOR, CONTROL DE CALIDAD/EQUIPOS ELECTRICOS	1
41632	OCUPACION	335006	INSPECTOR, CONTROL DE CALIDAD/ELECTRICIDAD	1
41631	OCUPACION	335005	INSPECTOR, CONTROL DE CALIDAD	1
41630	OCUPACION	335004	INVESTIGADOR, INCENDIOS	1
41629	OCUPACION	335003	INSPECTOR, OBRAS Y EDIFICIOS	1
41628	OCUPACION	335002	INSPECTOR, INCENDIOS	1
41627	OCUPACION	335001	ESPECIALISTA, PREVENCION DE INCENDIOS	1
41626	OCUPACION	334002	TECNICO, SEGURIDAD/TRAFICO AEREO	1
41625	OCUPACION	334001	CONTROLADOR, TRAFICO AEREO	1
41624	OCUPACION	333011	PILOTO, PRUEBAS/AERONAUTICA	1
41623	OCUPACION	333010	PILOTO, INSTRUCTOR	1
41622	OCUPACION	333009	PILOTO, HIDROAVION	1
41621	OCUPACION	333008	PILOTO, HELICOPTERO	1
41620	OCUPACION	333007	PILOTO, FUMIGACION	1
41619	OCUPACION	333006	PILOTO, AERONAVE/TRANSPORTE AEREO	1
41618	OCUPACION	333005	OFICIAL NAVEGANTE, AERONAVE	1
41617	OCUPACION	333004	OFICIAL MECANICO, VUELO/MECANICO NAVEGANTE	1
41616	OCUPACION	333003	INSTRUCTOR DE VUELO	1
41615	OCUPACION	333002	COPILOTO, AERONAVE	1
41614	OCUPACION	333001	COMANDANTE, AERONAVE	1
41226	OCUPACION	271017	IMAGINERO	1
41613	OCUPACION	332027	SUPERINTENDENTE, ARMAMENTO/CUBIERTA (BUQUES)	1
41612	OCUPACION	332026	PRACTICO, PUERTO	1
41611	OCUPACION	332025	PILOTO-PRACTICO NAVEGACION	1
41610	OCUPACION	332024	PILOTO, HIDROPLANO	1
41609	OCUPACION	332023	PILOTO, DESLIZADOR	1
41608	OCUPACION	332022	PILOTO, COSTERO	1
41607	OCUPACION	332021	PILOTO, AERODESLIZADOR	1
41606	OCUPACION	332020	PATRON, YATE	1
41605	OCUPACION	332019	PATRON, REMOLCADOR	1
41604	OCUPACION	332018	PATRON, PUERTO	1
41603	OCUPACION	332017	PATRON, BARCO/NAVEGACION MARITIMA	1
41602	OCUPACION	332016	PATRON, BARCO/NAVEGACION INTERIOR	1
41601	OCUPACION	332015	PATRON, BOLICHERA	1
41600	OCUPACION	332014	OFICIAL, NAVEGACION	1
41599	OCUPACION	332013	OFICIAL, CUBIERTA	1
41598	OCUPACION	332012	COMANDANTE, BARCO/NAVEGACION INTERIOR (LAGOS, RIOS)	1
41597	OCUPACION	332011	COMANDANTE, BARCO/NAVEGACION MARITIMA	1
41596	OCUPACION	332010	CAPITAN, YATE	1
41595	OCUPACION	332009	CAPITAN, REMOLCADOR	1
41594	OCUPACION	332008	CAPITAN, PUERTO	1
41593	OCUPACION	332007	CAPITAN, PESCA	1
41592	OCUPACION	332006	CAPITAN, MARINA MERCANTE/BARCO	1
41591	OCUPACION	332005	CAPITAN, BUQUE	1
41590	OCUPACION	332004	CAPITAN, BARCO/NAVEGACION MARITIMA	1
41589	OCUPACION	332003	CAPITAN, BARCO/NAVEGACION FLUVIAL O LACUSTRE	1
41588	OCUPACION	332002	CAPITAN, ALTURA	1
41587	OCUPACION	332001	ALFEREZ DE FRAGATA, RESERVA NAVAL/MARINA MERCANTE	1
41586	OCUPACION	331010	TERCER OFICIAL, MAQUINISTA/MARINA MERCANTE	1
41585	OCUPACION	331009	SUPERINTENDENTE TECNICO, MARINA MERCANTE	1
41584	OCUPACION	331008	SEGUNDO OFICIAL, MAQUINISTA/BARCO	1
41583	OCUPACION	331007	PRIMER OFICIAL, MAQUINISTA/BARCO	1
41582	OCUPACION	331006	OFICIAL MAQUINISTA, BARCO	1
41581	OCUPACION	331005	MOTORISTA, LANCHA/BOLICHERA	1
41580	OCUPACION	331004	JEFE DE MAQUINAS, BARCO	1
41579	OCUPACION	331003	INSTRUCTOR NAVEGACION/VELA	1
41578	OCUPACION	331002	INSPECTOR TECNICO, MARINA/MERCANTE	1
41577	OCUPACION	331001	CUARTO OFICIAL, MAQUINISTA/BARCO	1
41576	OCUPACION	324007	OPERADOR DE RAYOS X	1
41575	OCUPACION	324006	OPERADOR DE RADIOGRAFIA	1
41574	OCUPACION	324005	OPERADOR DE SCANER (OPTICA)	1
41573	OCUPACION	324004	OPERADOR DE SCANER	1
41572	OCUPACION	324003	OPERADOR DE ELECTROENCEFOLOGRAFIA	1
41571	OCUPACION	324002	OPERADOR DE ELECTROCARDIOGRAFIA	1
41570	OCUPACION	324001	OPERADOR DE AUDIOMETRIA	1
41569	OCUPACION	323028	TELEGRAFISTA	1
41568	OCUPACION	323027	TECNICO SALA DE CONTROL/TELEVISION	1
41567	OCUPACION	323026	TECNICO SALA DE CONTROL/RADIO	1
41566	OCUPACION	323025	RADIOTELEGRAFISTA, NAVEGACION MARITIMA	1
41565	OCUPACION	323024	RADIOTELEGRAFISTA	1
41564	OCUPACION	323023	RADIONAVEGANTE	1
41563	OCUPACION	323022	OPERADOR-JEFE, TELECOMUNICACIONES/TRAFICO	1
41562	OCUPACION	323021	OPERADOR-JEFE, TELECOMUNICACIONES/ESTACION	1
41561	OCUPACION	323020	OPERADOR, TRANSMISORES/TELEVISION	1
41560	OCUPACION	323019	OPERADOR, TRANSMISORES/RADIO	1
41559	OCUPACION	323018	OPERADOR, TELECOMUNICACIONES	1
41558	OCUPACION	323017	OPERADOR, RADIO/NAVEGACION MARITIMA	1
41557	OCUPACION	323016	OPERADOR, RADIO/NAVEGACION AEREA	1
41556	OCUPACION	323015	OPERADOR, RADAR	1
41555	OCUPACION	323014	OPERADOR, MICROFONOS	1
41554	OCUPACION	323013	OPERADOR, ESTUDIOS DE TELEVISION	1
41553	OCUPACION	323012	OPERADOR, ESTUDIOS DE RADIO	1
41552	OCUPACION	323011	OPERADOR, ESTACION EMISORA DE TELEVISION	1
41551	OCUPACION	323010	OPERADOR, ESTACION EMISORA DE RADIO	1
41550	OCUPACION	323009	OPERADOR, EQUIPO MOVILES DE RADIODIFUSION Y TELEVISION	1
41549	OCUPACION	323008	OPERADOR, EQUIPO DE RADIOTELEFONIA/ESTACIONES TERRESTRES	1
41548	OCUPACION	323007	OPERADOR, EQUIPO DE RADIODIFUSION	1
41547	OCUPACION	323006	OPERADOR, EQUIPO DE DIFUSION/VIDEO	1
41546	OCUPACION	323005	OPERADOR, EQUIPO DE DIFUSION/TELEVISION	1
41545	OCUPACION	323004	OPERADOR, EQUIPO DE DIFUSION/TELEFILMES	1
41544	OCUPACION	323003	OPERADOR, EQUIPO DE AMPLIFICACION DE SONIDO	1
41543	OCUPACION	323002	OPERADOR, CABINA DE PROYECCION/CINEMATOGRAFIA	1
41542	OCUPACION	323001	LUMINOTECNICO, TELEVISION	1
41541	OCUPACION	322044	TECNICO, PRUEBAS DE SONIDO/SONIDISTA	1
41540	OCUPACION	322043	TECNICO, MATERIAL DE DOBLAJE	1
41539	OCUPACION	322042	TECNICO, EQUIPO DE RADIO Y TELEVISION	1
41538	OCUPACION	322041	TECNICO, EQUIPO DE GRABACION/VIDEO	1
41537	OCUPACION	322040	TECNICO, EQUIPO DE GRABACION/SONIDO	1
41536	OCUPACION	322039	TECNICO, EQUIPO DE GRABACION/HILO MAGNETICO	1
41535	OCUPACION	322038	TECNICO, EQUIPO DE GRABACION/EFECTOS SONOROS	1
41534	OCUPACION	322037	TECNICO, EQUIPO DE GRABACION/DISCOS DIGITALES	1
41533	OCUPACION	322036	TECNICO, EQUIPO DE GRABACION/CINTA MAGNETICA	1
41532	OCUPACION	322035	TECNICO, EQUIPO DE SONORIZACION/TELEVISION	1
41531	OCUPACION	322034	TECNICO, EQUIPO DE SONORIZACION/RADIO	1
41530	OCUPACION	322033	TECNICO, EFECTOS SONOROS/CINE	1
41529	OCUPACION	322032	TECNICO EN AUDIO VISUALES	1
41528	OCUPACION	322031	REPORTERO GRAFICO/FOTOGRAFO REPORTERO	1
41527	OCUPACION	322030	OPERADOR, GRABACION DE SONIDO/TELEVISION	1
41526	OCUPACION	322029	OPERADOR, GRABACION DE SONIDO/RADIO	1
41525	OCUPACION	322028	OPERADOR, GRABACION DE SONIDO/DISCOS	1
41524	OCUPACION	322027	OPERADOR, GRABACION DE SONIDO	1
41523	OCUPACION	322026	OPERADOR, EQUIPO DE RADIO Y TELEVISION	1
41522	OCUPACION	322025	OPERADOR, EQUIPO DE SONORIZACION, CINE	1
2401	PERSONAL-ESTADO	2	CONTRATADO	1
41521	OCUPACION	322024	OPERADOR, EQUIPO AUDIO/TELEVISION	1
41520	OCUPACION	322023	OPERADOR, EQUIPO AUDIO/RADIO	1
41519	OCUPACION	322022	OPERADOR, CAMARA DE TELEVISION	1
41518	OCUPACION	322021	OPERADOR, CAMARA DE CINE	1
41517	OCUPACION	322020	MONTAJISTA	1
41516	OCUPACION	322019	FOTOGRAFO, PRENSA	1
41515	OCUPACION	322018	FOTOGRAFO, POLICIA	1
41514	OCUPACION	322017	FOTOGRAFO, MODAS	1
41513	OCUPACION	322016	FOTOGRAFO, MICROFOTOGRAFIA	1
41512	OCUPACION	322015	FOTOGRAFO, ILUSTRACION COMERCIAL	1
41511	OCUPACION	322014	FOTOGRAFO, ARQUITECTURA	1
41510	OCUPACION	322013	FOTOGRAFO RETRATISTA	1
41509	OCUPACION	322012	FOTOGRAFO PUBLICITARIO	1
41508	OCUPACION	322011	FOTOGRAFO MEDICO	1
41507	OCUPACION	322010	FOTOGRAFO INDUSTRIAL	1
41506	OCUPACION	322009	FOTOGRAFO COMERCIAL	1
41505	OCUPACION	322008	FOTOGRAFO AEREO	1
41504	OCUPACION	322007	FOTOGRAFO	1
41503	OCUPACION	322006	CINEASTA	1
41502	OCUPACION	322005	CAMAROGRAFO, TELEVISION	1
41501	OCUPACION	322004	CAMAROGRAFO, CINEMATOGRAFO	1
41500	OCUPACION	322003	CAMAROGRAFO	1
41499	OCUPACION	322002	AYUDANTE, DIRECCION CINEMATOGRAFICA	1
41498	OCUPACION	322001	AYUDANTE DE DIRECCION, CINE	1
41497	OCUPACION	321005	TECNICO, CONTROL DE EQUIPOS INFORMATICOS	1
41496	OCUPACION	321004	OPERADOR, PROCESO DE APLICACIONES CATALOGADAS	1
41495	OCUPACION	321003	OPERADOR, ALMACENAMIENTO DE DATOS	1
41494	OCUPACION	321002	OPERADOR, EQUIPOS INFORMATICOS/UNIDADES PERIFERICAS (IMPRES	1
41493	OCUPACION	321001	OPERADOR, EQUIPOS INFORMATICOS/COMPUTADORAS	1
41492	OCUPACION	319012	TECNICO, SERVICIOS INFORMATICOS PARA USUARIOS	1
41491	OCUPACION	319011	TECNICO, PROGRAMACION POR COMPUTADORAS	1
41490	OCUPACION	319010	TECNICO, ANALISIS INFORMATICO	1
41489	OCUPACION	319009	PROGRAMADOR, PRUEBA Y EJECUCION DEL PROGRAMA EN COMPUTADORA	1
41488	OCUPACION	319008	PROGRAMADOR, INFORMATICA/ANALISIS DE SISTEMAS	1
41487	OCUPACION	319007	PROGRAMADOR, INFORMATICA/ANALISIS DE BASE DE DATOS	1
41486	OCUPACION	319006	PROGRAMADOR, INFORMATICA/POR COMPUTADORA	1
41485	OCUPACION	319005	PROGRAMADOR, DESARROLLO DE LA LOGICA DEL PROCESO	1
41484	OCUPACION	319004	PROGRAMADOR, CODIFICADOR DE LOS PROGRAMAS	1
41483	OCUPACION	319003	TECNICO EN ESTADISTICA O MATEMATICA, OTROS	1
41482	OCUPACION	319002	TECNICO, EN MATEMATICA	1
41481	OCUPACION	319001	TECNICO EN ESTADISTICA	1
41480	OCUPACION	318016	TECNICO EN LA INDUSTRIA, OTROS	1
41479	OCUPACION	318015	TECNICO, SISTEMAS/EXCEPTO INFORMATICOS	1
41478	OCUPACION	318014	TECNICO, PESQUERIA	1
41477	OCUPACION	318013	TECNICO, PAPEL	1
41476	OCUPACION	318012	TECNICO, INGENIERIA/PRODUCCION	1
41475	OCUPACION	318011	TECNICO, INGENIERIA/SEGURIDAD E HIGIENE INDUSTRIAL	1
41474	OCUPACION	318010	TECNICO, INGENIERIA/PLANIFICACION	1
41473	OCUPACION	318009	TECNICO, INGENIERIA/ORGANIZACION INDUSTRIAL	1
41472	OCUPACION	318008	TECNICO, INGENIERIA/METODOS	1
41471	OCUPACION	318007	TECNICO, INGENIERIA/ESTUDIO DE TIEMPOS Y MOVIMIENTOS	1
41470	OCUPACION	318006	TECNICO, ESTUDIO DEL TRABAJO	1
41469	OCUPACION	318005	TECNICO, EFICIENCIA INDUSTRIAL	1
41468	OCUPACION	318004	TECNICO, CUEROS Y PIELES	1
41467	OCUPACION	318003	TECNICO, CERAMICA	1
41466	OCUPACION	318002	TECNICO, CALCULO DE COSTOS Y CANTIDADES	1
41465	OCUPACION	318001	TECNICO, ALIMENTOS	1
41464	OCUPACION	317021	SUPERVISOR DE ARTES GRAFICAS	1
41463	OCUPACION	317020	DELINEANTE, DIBUJANTES/OTROS	1
41462	OCUPACION	317019	DIBUJANTE, PROYECTISTA/ARTES GRAFICAS	1
41461	OCUPACION	317018	DIBUJANTE, ILUSTRACIONES TECNICAS	1
41460	OCUPACION	317017	DELINEANTE, TECNICO	1
41459	OCUPACION	317016	DELINEANTE, MATRICES Y HERRAMIENTAS	1
41458	OCUPACION	317015	DELINEANTE, LITOGRAFIA	1
41457	OCUPACION	317014	DELINEANTE, INGENIERIA NAVAL	1
41456	OCUPACION	317013	DELINEANTE, INGENIERIA MECANICA	1
41455	OCUPACION	317012	DELINEANTE, INGENIERIA ELECTRONICA	1
41454	OCUPACION	317011	DELINEANTE, INGENIERIA ELECTRICA	1
41453	OCUPACION	317010	DELINEANTE, INGENIERIA DE SISTEMAS DE CALEFACCION Y VENTILA	1
41452	OCUPACION	317009	DELINEANTE, INGENIERIA DE EDIFICIOS	1
41451	OCUPACION	317008	DELINEANTE, INGENIERIA CIVIL	1
41450	OCUPACION	317007	DELINEANTE, INGENIERIA AERONAUTICA	1
41449	OCUPACION	317006	DELINEANTE, INDUSTRIAL	1
41448	OCUPACION	317005	DELINEANTE, ILUSTRACIONES TECNICAS	1
41447	OCUPACION	317004	DELINEANTE, GEOLOGIA	1
41446	OCUPACION	317003	DELINEANTE, CARTOGRAFIA	1
41445	OCUPACION	317002	DELINEANTE, ARQUITECTURA	1
41444	OCUPACION	317001	DELINEANTE	1
41443	OCUPACION	316016	TECNICO, SONDEO/POZOS DE PETROLEO Y GAS	1
41442	OCUPACION	316015	TECNICO, MINERIA	1
41441	OCUPACION	316014	TECNICO, METALURGIA/TRATAMIENTO Y/O PRODUCCION DE METALES	1
41440	OCUPACION	316013	TECNICO, METALURGIA/FUNDICION	1
41439	OCUPACION	316012	TECNICO, METALURGIA/SIDERURGICA	1
41438	OCUPACION	316011	TECNICO, METALURGIA/EXTRACCION	1
41437	OCUPACION	316010	TECNICO, METALURGIA/ENSAYADOR DE METALES	1
41436	OCUPACION	316009	TECNICO, EXTRACCION/PETROLEO Y GAS NATURAL	1
41435	OCUPACION	316008	TECNICO, EXTRACCION/METALES	1
41434	OCUPACION	316007	TECNICO, EXTRACCION/GAS (SONDEO DE POZOS)	1
41433	OCUPACION	316006	TECNICO, EXTRACCION/CARBON	1
41432	OCUPACION	316005	TECNICO, ACIDIFICACION/POZOS	1
41431	OCUPACION	316004	PEGADOR, POZOS DE PETROLEO Y GAS	1
41430	OCUPACION	316003	DESINCRUSTADOR, POZOS DE PETROLEO Y GAS	1
2400	PERSONAL-ESTADO	1	PERMANENTE	1
41429	OCUPACION	316002	TÉCNICO, CEMENTADOR, POZOS DE PETROLEO Y GAS	1
41428	OCUPACION	316001	ACIDIFICADOR, POZOS DE PETROLEO Y GAS	1
41427	OCUPACION	315011	TECNICO, QUIMICA INDUSTRIAL/REFINACION DEL PETROLEO	1
41426	OCUPACION	315010	TECNICO, QUIMICA INDUSTRIAL/PRODUCCION Y DISTRIBUCION DE GA	1
41425	OCUPACION	315009	TECNICO, QUIMICA INDUSTRIAL/PROCESOS QUIMICOS	1
41424	OCUPACION	315008	TECNICO, QUIMICA INDUSTRIAL/PETROLEO	1
41423	OCUPACION	315007	TECNICO, QUIMICA INDUSTRIAL/PLASTICOS	1
41422	OCUPACION	315006	TECNICO, QUIMICA INDUSTRIAL/GAS	1
41421	OCUPACION	315005	TECNICO, QUIMICO INDUSTRIAL/CAUCHO	1
41420	OCUPACION	315004	TECNICO, QUIMICA INDUSTRIAL	1
41419	OCUPACION	315003	TECNICO, PETROQUIMICA	1
41418	OCUPACION	315002	TECNICO, FIBRA TEXTIL (DE ING. TEXTIL)	1
41417	OCUPACION	315001	ESTIMADOR, QUIMICA INDUSTRIAL	1
41416	OCUPACION	314026	VERIFICADOR, NAVAL	1
41415	OCUPACION	314025	TECNICO, ACONDICIONAMIENTO DE AIRE	1
41414	OCUPACION	314024	TECNICO MECANICO, TURBINAS DE GAS	1
41413	OCUPACION	314023	TECNICO MECANICO, SISTEMAS HIDRAULICOS	1
41412	OCUPACION	314022	TECNICO MECANICO, MOTORES DIESEL	1
41411	OCUPACION	314021	TECNICO MECANICO, MOTORES DE PROPULSION A CHORRO	1
41410	OCUPACION	314020	TECNICO MECANICO, MOTORES DE LOCOMOTORAS	1
41409	OCUPACION	314019	TECNICO MECANICO, MOTORES DE COMBUSTION INTERNA	1
41408	OCUPACION	314018	TECNICO MECANICO, MOTORES	1
41407	OCUPACION	314017	TECNICO MECANICO, MANTENIMIENTO DE AVION	1
41406	OCUPACION	314016	TECNICO MECANICO, MAQUINARIA Y HERRAMIENTAS INDUSTRIALES	1
41405	OCUPACION	314015	TECNICO MECANICO, LUBRICACION	1
41404	OCUPACION	314014	TECNICO MECANICO, INSTRUMENTOS	1
41403	OCUPACION	314013	TECNICO MECANICO, INSTRUCTOR DE VEHICULOS AUTOMOTORES	1
41402	OCUPACION	314012	TECNICO MECANICO, ENERGIA NUCLEAR	1
41401	OCUPACION	314011	TECNICO MECANICO, CONSTRUCCION NAVAL	1
41400	OCUPACION	314010	TECNICO MECANICO, CALEFACCION, REFRIGERACION Y VENTILACION	1
41399	OCUPACION	314009	TECNICO MECANICO, AUTOMOVILES	1
41398	OCUPACION	314008	TECNICO MECANICO, AGRICULTURA	1
41397	OCUPACION	314007	TECNICO MECANICO, AERONAUTICA	1
41396	OCUPACION	314006	TECNICO MECANICO, ACONDICIONAMIENTO DE AIRE	1
41395	OCUPACION	314005	TECNICO MECANICO	1
41394	OCUPACION	314004	TECNICO INSPECTOR, NAVAL/BUQUES	1
41393	OCUPACION	314003	TECNICO INSPECTOR, NAVAL	1
41392	OCUPACION	314002	TECNICO AERONAUTICO	1
41391	OCUPACION	314001	TECNICO CALCULISTA, CONSTRUCCION MECANICA	1
41390	OCUPACION	313017	TECNICO, TELECOMUNICACIONES/TELEVISION	1
41389	OCUPACION	313016	TECNICO, TELECOMUNICACIONES/TELEGRAFO	1
41388	OCUPACION	313015	TECNICO, TELECOMUNICACIONES/TELEFONO	1
41387	OCUPACION	313014	TECNICO, TELECOMUNICACIONES/SISTEMAS DE SEÐALES	1
41386	OCUPACION	313013	TECNICO, TELECOMUNICACIONES/RADIO	1
41385	OCUPACION	313012	TECNICO, OPERADOR DE RADAR	1
41384	OCUPACION	313011	TECNICO, TELECOMUNICACIONES	1
41383	OCUPACION	313010	TECNICO, SISTEMAS ELECTRICOS DE AERONAVES	1
41382	OCUPACION	313009	TECNICO, INGENIERIA ELECTRONICA	1
41381	OCUPACION	313008	TECNICO CALCULISTA, INGENIERIA ELECTRONICA	1
41380	OCUPACION	313007	TECNICO, INGENIERIA ELECTRICA	1
41379	OCUPACION	313006	TECNICO ELECTRICISTA, SONIDO	1
41378	OCUPACION	313005	TECNICO ELECTRICISTA, ILUMINACION	1
41377	OCUPACION	313004	TECNICO ELECTRICISTA, RADIO Y/O T.V.	1
41376	OCUPACION	313003	TECNICO ELECTRICISTA, ENERGIA ELECTRICA/DISTRIBUCION	1
41375	OCUPACION	313002	TECNICO ELECTRICISTA, ALTA TENSION	1
41374	OCUPACION	313001	TECNICO, ELECTRICISTA	1
41373	OCUPACION	312014	TECNICO, INGENIERIA CIVIL/SANITARIA	1
41372	OCUPACION	312013	TECNICO, INGENIERIA CIVIL/MECANICA DE SUELOS	1
41371	OCUPACION	312012	TECNICO, INGENIERIA CIVIL/IRRIGACION	1
41370	OCUPACION	312011	TECNICO, INGENIERIA CIVIL/HIDRAULICA	1
41369	OCUPACION	312010	TECNICO, INGENIERIA CIVIL/ESTRUCTURAS	1
41368	OCUPACION	312009	TECNICO, INGENIERIA CIVIL/CONTRATISTA (CONSTRUCCION)	1
41367	OCUPACION	312008	TECNICO, INGENIERIA CIVIL/CONSTRUCCION DE VIVIENDAS Y EDIFI	1
41366	OCUPACION	312007	TECNICO, INGENIERIA CIVIL	1
41365	OCUPACION	312006	TECNICO, FOTOGRAMETRISTA Y AEROFOTOGRAMETRISTA	1
41364	OCUPACION	312005	TECNICO, CARTOGRAFO	1
41363	OCUPACION	312004	TECNICO, AUXILIAR DE ARQUITECTURA	1
41362	OCUPACION	312003	TECNICO, AGRIMENSOR	1
41361	OCUPACION	312002	TECNICO CALCULISTA, INGENIERIA CIVIL/COSTO DE CONSTRUCCION	1
41360	OCUPACION	312001	APAREJADOR, INGENIERIA CIVIL	1
41359	OCUPACION	311010	TECNICO, ESPECIALISTA EN FISICO-QUIMICA	1
41358	OCUPACION	311009	TECNICO, QUIMICA/INVESTIGACION (CIENCIAS QUIMICAS)	1
41357	OCUPACION	311008	TECNICO, OCEANOGRAFIA	1
41356	OCUPACION	311007	TECNICO, METEOROLOGIA	1
41355	OCUPACION	311006	TECNICO, LABORATORISTA FISICO O QUIMICO	1
41354	OCUPACION	311005	TECNICO, GEOLOGIA	1
41353	OCUPACION	311004	TECNICO, GEOFISICA	1
41352	OCUPACION	311003	TECNICO, FISICA/INVESTIGACION (CIENCIAS FISICAS)	1
41351	OCUPACION	311002	TECNICO, ASTRONOMIA	1
41350	OCUPACION	311001	TECNICO, ANALISTA QUIMICO	1
41349	OCUPACION	284021	VICARIO	1
41348	OCUPACION	284020	TEOLOGO	1
41347	OCUPACION	284019	SACERDOTE BUDISTA	1
41346	OCUPACION	284018	SACERDOTE	1
41345	OCUPACION	284017	RABINO	1
41344	OCUPACION	284016	PRIOR	1
41343	OCUPACION	284015	POOJARI	1
41342	OCUPACION	284014	PASTOR PROTESTANTE	1
41341	OCUPACION	284013	PARROCO	1
41340	OCUPACION	284012	OBISPO	1
41339	OCUPACION	284011	MONJE	1
41336	OCUPACION	284008	MINISTRO DEL CULTO	1
41335	OCUPACION	284007	IMAN	1
41334	OCUPACION	284006	CURA	1
41333	OCUPACION	284005	CAPELLAN	1
41332	OCUPACION	284004	CANONIGO	1
41331	OCUPACION	284003	BONZO	1
41330	OCUPACION	284002	ARZOBISPO	1
41329	OCUPACION	284001	ARCIPRESTE	1
41328	OCUPACION	283003	REPRESENTANTES DE ORGANISMOS INTERNACIONALES	1
41327	OCUPACION	283002	DIPLOMATICOS, PERUANOS (EXCEPTO EMBAJADORES Y CONSULES EN F	1
41326	OCUPACION	283001	DIPLOMATICOS, EXTRANJEROS	1
41325	OCUPACION	282004	RELACIONISTA, OTROS	1
41324	OCUPACION	282003	RELACIONISTA, PUBLICO	1
41323	OCUPACION	282002	RELACIONISTA, LABORAL	1
41322	OCUPACION	282001	RELACIONISTA, INDUSTRIAL	1
41321	OCUPACION	281002	PROFESIONAL EN TURISMO	1
41320	OCUPACION	281001	PROFESIONAL EN HOTELERIA	1
41319	OCUPACION	274025	OTROS, ACTORES Y DIRECTORES DE CINE, RADIO, TEATRO, TELEVIS	1
41318	OCUPACION	274024	TRAGICO	1
41317	OCUPACION	274023	REGENTE, ESCENA	1
41316	OCUPACION	274022	RECITADOR, RADIO O TELEVISION	1
41315	OCUPACION	274021	RECITADOR, EXCEPTO RADIO O TELEVISION	1
41314	OCUPACION	274020	REALIZADOR, RADIODIFUSION O TELEVISION	1
41313	OCUPACION	274019	MIMO	1
41312	OCUPACION	274018	LECTOR, RADIO O TELEVISION	1
41311	OCUPACION	274017	IMITADOR, CABARET	1
41310	OCUPACION	274016	EMPRESARIO, CINE	1
41309	OCUPACION	274015	DIRECTOR, TEATRO	1
41308	OCUPACION	274014	DIRECTOR, FOTOGRAFIA/CINE	1
41307	OCUPACION	274013	DIRECTOR, ESCENA/TEATRO	1
41306	OCUPACION	274012	DIRECTOR, ESCENA/CINE	1
41305	OCUPACION	274011	DIRECTOR DE PRODUCCION (RADIO Y T.V.)	1
41304	OCUPACION	274010	DIRECTOR ARTISTICO, TEATRO	1
41303	OCUPACION	274009	DIRECTOR ARTISTICO, CINE	1
41302	OCUPACION	274008	COMEDIANTE	1
41301	OCUPACION	274007	CARICATO	1
41300	OCUPACION	274006	ACTRIZ, TEATRO	1
41299	OCUPACION	274005	ACTRIZ, CINE	1
41298	OCUPACION	274004	ACTRIZ	1
41297	OCUPACION	274003	ACTOR, TEATRO	1
41296	OCUPACION	274002	ACTOR, CINE	1
41295	OCUPACION	274001	ACTOR	1
41294	OCUPACION	273009	MAESTRO DE BALLET	1
41293	OCUPACION	273008	DIRECTOR, COREOGRAFIA	1
41292	OCUPACION	273007	DIRECTOR, DANZA	1
41291	OCUPACION	273006	COREOGRAFO	1
41290	OCUPACION	273005	BAILARINA	1
41289	OCUPACION	273004	BAILARIN, SOLISTA	1
41288	OCUPACION	273003	BAILARIN, BALLET	1
41287	OCUPACION	273002	BAILARINES DE DANZA CLASICA Y MODERNA	1
41286	OCUPACION	273001	BAILARIN	1
41285	OCUPACION	272047	OTROS, COMPOSITORES, MUSICOS Y CANTANTES	1
41284	OCUPACION	272046	VIOLONCHELISTA	1
41283	OCUPACION	272045	VIOLINISTA	1
41282	OCUPACION	272044	TROMPETISTA	1
41281	OCUPACION	272043	TROMBONISTA	1
41279	OCUPACION	272041	TAMBORILERO	1
41278	OCUPACION	272040	SOPRANO	1
41277	OCUPACION	272039	SAXOFONISTA	1
41276	OCUPACION	272038	PIANISTA	1
41275	OCUPACION	272037	PERCUSIONISTA	1
41274	OCUPACION	272036	ORQUESTADOR	1
41273	OCUPACION	272035	ORGANISTA	1
41272	OCUPACION	272034	OBOISTA	1
41271	OCUPACION	272033	MEZZO-SOPRANO	1
41270	OCUPACION	272032	INSTRUMENTISTA	1
41269	OCUPACION	272031	GUITARRISTA	1
41268	OCUPACION	272030	FLAUTISTA	1
41267	OCUPACION	272029	FAGOTISTA	1
41266	OCUPACION	272028	EJECUTANTE, MUSICO	1
41265	OCUPACION	272027	DIRECTOR, ORQUESTA SINFONICA	1
41264	OCUPACION	272026	DIRECTOR, COROS	1
41263	OCUPACION	272025	CORISTA	1
41262	OCUPACION	272024	COPISTA, MUSICA	1
41261	OCUPACION	272023	CONTRALTO	1
41260	OCUPACION	272022	CONTRABAJO	1
41259	OCUPACION	272021	CONCERTISTA INSTRUMENTISTA	1
41258	OCUPACION	272020	CONCERTISTA CANTANTE	1
41257	OCUPACION	272019	CONCERTADOR, COROS	1
41256	OCUPACION	272018	COMPOSITOR	1
41255	OCUPACION	272017	CLAVECINISTA	1
41254	OCUPACION	272016	CLARINETISTA	1
41253	OCUPACION	272015	CITARISTA	1
41252	OCUPACION	272014	CANTANTE, OPERA	1
41251	OCUPACION	272013	CANTANTE, MUSICA POPULAR	1
41250	OCUPACION	272012	CANTANTE, JAZZ	1
41249	OCUPACION	272011	CANTANTE, CORAL	1
41248	OCUPACION	272010	CANTANTE, CONCIERTO	1
41247	OCUPACION	272009	CANTANTE	1
41246	OCUPACION	272008	BATERISTA	1
41245	OCUPACION	272007	BARITONO	1
41244	OCUPACION	272006	BAJONISTA	1
41243	OCUPACION	272005	BAJO	1
41242	OCUPACION	272004	ARTISTA LIRICO	1
41241	OCUPACION	272003	ARPISTA	1
41240	OCUPACION	272002	ARMONISTA	1
41239	OCUPACION	272001	ADAPTADOR MUSICAL	1
41238	OCUPACION	271029	RETRATISTA	1
41237	OCUPACION	271028	RESTAURADOR, OBRAS DE ARTE	1
41236	OCUPACION	271027	RESTAURADOR, CUADROS	1
41235	OCUPACION	271026	PUBLICISTA, RESPONSABLE DE CAMPAÐA PUBLICITARIA	1
41234	OCUPACION	271025	PINTOR, PINTURA FIGURATIVA	1
41233	OCUPACION	271024	PINTOR, PINTURA ABSTRACTA	1
41232	OCUPACION	271023	PINTOR, AGUA FUERTE	1
41231	OCUPACION	271022	PASTELISTA	1
41230	OCUPACION	271021	PAISAJISTA	1
41229	OCUPACION	271020	ORFEBRE ARTISTA	1
41228	OCUPACION	271019	MINIATURISTA	1
41227	OCUPACION	271018	MAQUETISTA	1
41225	OCUPACION	271016	GRABADOR ARTISTICO	1
41224	OCUPACION	271015	ESTATUARIO	1
41223	OCUPACION	271014	ESCULTOR	1
41222	OCUPACION	271013	DIBUJANTE, PUBLICIDAD	1
41221	OCUPACION	271012	DIBUJANTE, JOYERIA Y ORFEBRERIA	1
41220	OCUPACION	271011	DIBUJANTE, DISEÐO INDUSTRIAL	1
41219	OCUPACION	271010	DIBUJANTE, DIBUJOS ANIMADOS	1
41218	OCUPACION	271009	DIBUJANTE, CARICATURISTA	1
41217	OCUPACION	271008	CREADOR, MODELOS/JOYERIA Y ORFEBRERIA	1
41216	OCUPACION	271007	CREADOR, DIBUJOS ANIMADOS	1
41215	OCUPACION	271006	CERAMISTA ARTISTICO	1
41214	OCUPACION	271005	CARICATURISTA	1
41213	OCUPACION	271004	ARTISTA PINTOR	1
41212	OCUPACION	271003	ARTISTA CREATIVO	1
41211	OCUPACION	271002	ARTISTA COMERCIAL	1
41210	OCUPACION	271001	ACUARELISTA	1
41209	OCUPACION	269019	VISITADOR, PRISIONES	1
41208	OCUPACION	269018	VISITADOR SOCIAL	1
41207	OCUPACION	269017	ASISTENTE SOCIAL, SERVICIOS SOCIALES	1
41206	OCUPACION	269016	ASISTENTE SOCIAL, SERVICIOS DE AYUDA FAMILIAR	1
41205	OCUPACION	269015	ASISTENTE SOCIAL, SERVICIOS CULTURALES	1
41204	OCUPACION	269014	ASISTENTE SOCIAL, SERVICIOS COMUNITARIOS	1
41203	OCUPACION	269013	ASISTENTE SOCIAL, REHABILITACION/INCAPACITADOS FISICOS	1
41202	OCUPACION	269012	ASISTENTE SOCIAL, PSIQUIATRIA	1
41201	OCUPACION	269011	ASISTENTE SOCIAL, PROTECCION DE LA INFANCIA	1
41200	OCUPACION	269010	ASISTENTE SOCIAL, PROTECCION DE LA FAMILIA	1
41199	OCUPACION	269009	ASISTENTE SOCIAL, PRISIONES	1
41198	OCUPACION	269008	ASISTENTE SOCIAL, HOSPITAL	1
41197	OCUPACION	269007	ASISTENTE SOCIAL, EMPRESA	1
41196	OCUPACION	269006	ASISTENTE SOCIAL, DELINCUENCIA/PREVENCION Y REHABILITACION	1
41195	OCUPACION	269005	ASISTENTE SOCIAL, DELINCUENCIA/LIBERTAD CONDICIONAL	1
41194	OCUPACION	269004	ASISTENTE SOCIAL, DELINCUENCIA	1
41193	OCUPACION	269003	ASISTENTE SOCIAL, BIENESTAR SOCIAL	1
41192	OCUPACION	269002	ASISTENTE SOCIAL	1
41191	OCUPACION	269001	ASISTENTE MEDICO SOCIAL	1
41190	OCUPACION	268008	PSICOLOGO, TRABAJO	1
41189	OCUPACION	268007	PSICOLOGO, PROBLEMAS SOCIALES	1
41188	OCUPACION	268006	PSICOLOGO, PEDAGOGIA	1
41187	OCUPACION	268005	PSICOLOGO, OCUPACIONES	1
41186	OCUPACION	268004	PSICOLOGO, INDUSTRIAS	1
41185	OCUPACION	268003	PSICOLOGO, EXPERIMENTOS	1
41184	OCUPACION	268002	PSICOLOGO CLINICO	1
41183	OCUPACION	268001	PSICOLOGO	1
41182	OCUPACION	267018	TRADUCTOR	1
41181	OCUPACION	267017	MORFOLOGO	1
41180	OCUPACION	267016	LINGUISTA	1
41179	OCUPACION	267015	LEXICOGRAFO	1
41178	OCUPACION	267014	INTERPRETE	1
41177	OCUPACION	267013	GRAFOLOGO	1
41176	OCUPACION	267012	FILOLOGO, SEMANTICA	1
41175	OCUPACION	267011	FILOLOGO, MORFOLOGIA	1
41174	OCUPACION	267010	FILOLOGO, LINGUISTICA	1
41173	OCUPACION	267009	FILOLOGO, LEXICOGRAFIA	1
41172	OCUPACION	267008	FILOLOGO, GRAFOLOGIA	1
41171	OCUPACION	267007	FILOLOGO, FONOLOGIA	1
41170	OCUPACION	267006	FILOLOGO, FONETICA	1
41169	OCUPACION	267005	FILOLOGO, ETIMOLOGIA	1
41168	OCUPACION	267004	FILOLOGO	1
41167	OCUPACION	267003	ETIMOLOGISTA	1
41166	OCUPACION	267002	ESPECIALISTA, SEMANTICA	1
41165	OCUPACION	267001	ESPECIALISTA, FONETICA	1
41164	OCUPACION	266062	JEFE DE REDACCION/REVISTA	1
41163	OCUPACION	266061	JEFE DE REDACCION/DIARIO	1
41162	OCUPACION	266060	REPORTERO, PRENSA/T.V. O RADIO	1
41161	OCUPACION	266059	REPORTERO, MODA	1
41160	OCUPACION	266058	REPORTERO	1
41159	OCUPACION	266057	REDACTOR, TECNICO/MANUALES	1
41158	OCUPACION	266056	REDACTOR, TECNICO	1
41157	OCUPACION	266055	REDACTOR, REVISTAS	1
41156	OCUPACION	266054	REDACTOR, PUBLICIDAD	1
41155	OCUPACION	266053	REDACTOR, PRENSA/EXTRANJERO	1
41154	OCUPACION	266052	REDACTOR, PRENSA/T.V.	1
41153	OCUPACION	266051	REDACTOR, MODAS	1
41152	OCUPACION	266050	REDACTOR, INFORMACION PUBLICA	1
41151	OCUPACION	266049	REDACTOR, ARTICULOS DE FONDO	1
41150	OCUPACION	266048	REDACTOR JEFE, REVISTAS	1
41149	OCUPACION	266047	REDACTOR JEFE, GUIONES/RADIO Y TELEVISION	1
41148	OCUPACION	266046	REDACTOR JEFE, FINANZAS	1
41147	OCUPACION	266045	REDACTOR JEFE, DIARIOS	1
41146	OCUPACION	266044	REDACTOR	1
41145	OCUPACION	266043	POETA	1
41144	OCUPACION	266042	PERIODISTA, TELEVISION	1
41143	OCUPACION	266041	PERIODISTA, RADIO	1
41142	OCUPACION	266040	PERIODISTA REPORTERO	1
41141	OCUPACION	266039	PERIODISTA	1
41140	OCUPACION	266038	NOVELISTA	1
41139	OCUPACION	266037	LITERATO	1
41138	OCUPACION	266036	LIBRETISTA	1
41137	OCUPACION	266035	HOMBRES DE LETRAS	1
41136	OCUPACION	266034	GUIONISTA	1
41135	OCUPACION	266033	GACETILLERO	1
41134	OCUPACION	266032	FOLLETINISTA	1
41133	OCUPACION	266031	ESCRITOR, TEATRO	1
41132	OCUPACION	266030	ESCRITOR, POESIA	1
41131	OCUPACION	266029	ESCRITOR, NOVELAS	1
41130	OCUPACION	266028	ESCRITOR, LIBRETOS	1
41129	OCUPACION	266027	ESCRITOR	1
41128	OCUPACION	266026	ENSAYISTA	1
41127	OCUPACION	266025	EDITORIALISTA	1
41126	OCUPACION	266024	EDITOR, LIBROS/REVISTAS	1
41125	OCUPACION	266023	DIALOGUISTA	1
41124	OCUPACION	266022	CRONISTA, TRIBUNALES	1
41123	OCUPACION	266021	CRONISTA, DEPORTES	1
41122	OCUPACION	266020	CRONISTA	1
41121	OCUPACION	266019	CRITICO, TELEVISION	1
41120	OCUPACION	266018	CRITICO, TEATRO	1
41119	OCUPACION	266017	CRITICO, RADIO	1
41118	OCUPACION	266016	CRITICO, MUSICA	1
41117	OCUPACION	266015	CRITICO, LITERARIO	1
41116	OCUPACION	266014	CRITICO, CINEMATOGRAFICO	1
41115	OCUPACION	266013	CRITICO, ARTES PLASTICAS	1
41114	OCUPACION	266012	CRITICO, ARTE	1
41113	OCUPACION	266011	CRITICO	1
41112	OCUPACION	266010	CORRESPONSAL, MEDIOS DE INFORMACION	1
41111	OCUPACION	266009	COMENTARISTA, RADIO Y TELEVISION	1
41110	OCUPACION	266008	COMENTARISTA, DEPORTES	1
41109	OCUPACION	266007	COMENTARISTA, ACTUALIDADES	1
41108	OCUPACION	266006	BIOGRAFO	1
41107	OCUPACION	266005	AUTOR, TEATRO	1
41106	OCUPACION	266004	AUTOR, LETRA DE CANCIONES	1
41105	OCUPACION	266003	AUTOR, DRAMA	1
41104	OCUPACION	266002	AUTOR	1
41103	OCUPACION	266001	ARGUMENTISTA, TEATRO O CINE	1
41102	OCUPACION	265004	FILOSOFO, CIENCIAS POLITICAS	1
41101	OCUPACION	265003	FILOSOFO	1
41100	OCUPACION	265002	ESPECIALISTA, CIENCIAS POLITICAS	1
41099	OCUPACION	265001	CIENTIFICO, CIENCIAS POLITICAS	1
41098	OCUPACION	264003	GEOGRAFO, GEOGRAFIA POLITICO	1
41097	OCUPACION	264002	GEOGRAFO, GEOGRAFIA FISICA	1
41096	OCUPACION	264001	GEOGRAFO, GEOGRAFIA ECONOMICA	1
41095	OCUPACION	263013	SOCIOLOGO, PATOLOGIA SOCIAL	1
41094	OCUPACION	263012	SOCIOLOGO, INDUSTRIA	1
41093	OCUPACION	263011	SOCIOLOGO, CRIMINOLOGIA	1
41092	OCUPACION	263010	POLITOLOGO	1
41091	OCUPACION	263009	HISTORIADOR, HISTORIA POLITICA	1
41090	OCUPACION	263008	HISTORIADOR, HISTORIA ECONOMICA	1
41089	OCUPACION	263007	HISTORIADOR, CIENCIAS SOCIALES	1
41088	OCUPACION	263006	HISTORIADOR	1
41087	OCUPACION	263005	GENEOLOGISTA	1
41086	OCUPACION	263004	ETNOLOGO	1
41085	OCUPACION	263003	ETNOGRAFO	1
41084	OCUPACION	263002	ARQUEOLOGO	1
41083	OCUPACION	263001	ANTROPOLOGO	1
41082	OCUPACION	262009	PLANIFICADORES	1
41081	OCUPACION	262008	ECONOMISTA, OTROS	1
41080	OCUPACION	262007	ECONOMISTA, ESPECIALISTA EN MERCADOTECNIA	1
41079	OCUPACION	262006	ECONOMISTA, ECONOMETRIA	1
41078	OCUPACION	262005	ECONOMISTA, DESARROLLO	1
41077	OCUPACION	262004	ECONOMISTA, COMERCIO INTERNACIONAL	1
41076	OCUPACION	262003	ECONOMISTA, AGRICULTURA	1
41075	OCUPACION	262002	ECONOMISTA (INGENIERO)	1
41074	OCUPACION	262001	ECONOMETRISTA	1
41073	OCUPACION	261005	ESPECIALISTA, BIBLIOTECONOMIA	1
41072	OCUPACION	261004	DOCUMENTALISTA, MATERIAS TECNICAS	1
41071	OCUPACION	261003	DOCUMENTALISTA, MATERIAS ECONOMICAS	1
41070	OCUPACION	261002	DOCUMENTALISTA	1
41069	OCUPACION	261001	BIBLIOTECARIO	1
41068	OCUPACION	259004	CONSERVADOR, MUSEO	1
41067	OCUPACION	259003	CONSERVADOR, GALERIA DE ARTE	1
41066	OCUPACION	259002	ARCHIVERO, PALEOLOGO	1
41065	OCUPACION	259001	ARCHIVERO, DE BIBLIOTECA Y SERVICIOS DE ARCHIVOS	1
41064	OCUPACION	258010	TRABAJADORES Y PRACTICANTES DE DERECHO, OTROS	1
41063	OCUPACION	258009	SECRETARIO DE JUZGADO, PROFESIONAL	1
41062	OCUPACION	258008	SECRETARIO DE CORTE	1
41061	OCUPACION	258007	RELATORES	1
41060	OCUPACION	258006	REDACTOR PARLAMENTARIO	1
41059	OCUPACION	258005	PROCURADOR	1
41058	OCUPACION	258004	JUECES NO LETRADOS	1
41057	OCUPACION	258003	ESCRIBANO DE ESTADO	1
41056	OCUPACION	258002	CONSEJERO JURIDICO, IMPUESTOS	1
41055	OCUPACION	258001	CONSEJERO JURIDICO, EMPRESA	1
41054	OCUPACION	257001	NOTARIO PUBLICO	1
41053	OCUPACION	256002	FISCAL DE LA CORTE SUPERIOR O SUPREMA	1
41052	OCUPACION	256001	AGENTE FISCAL	1
41051	OCUPACION	255012	VOCAL DE LA CORTE SUPERIOR O SUPREMA	1
41050	OCUPACION	255011	PRESIDENTE, TRIBUNAL DE JUSTICIA	1
41049	OCUPACION	255010	JUEZ SIN ROSTRO	1
41048	OCUPACION	255009	JUEZ, TRABAJO	1
41047	OCUPACION	255008	JUEZ, PRIMERA INSTANCIA/TIERRAS, MENORES, OTROS	1
41046	OCUPACION	255007	JUEZ, PENAL	1
41045	OCUPACION	255006	JUEZ DE PAZ LETRADO	1
41044	OCUPACION	255005	JUEZ INSTRUCTOR	1
41043	OCUPACION	255004	JUEZ DE LA CORTE SUPREMA	1
41042	OCUPACION	255003	JUEZ DE LA CORTE SUPERIOR	1
41041	OCUPACION	255002	JUEZ CIVIL	1
41040	OCUPACION	255001	JUEZ	1
41039	OCUPACION	254009	ASESOR, LEGAL O JURIDICO	1
41038	OCUPACION	254008	ABOGADOS Y OTROS	1
41037	OCUPACION	254007	ABOGADO, DERECHO INTERNACIONAL	1
41036	OCUPACION	254006	APODERADO	1
41035	OCUPACION	254005	ABOGADO, CRIMINALISTA/DERECHO PUBLICO (CONSTIT.PENAL, ADMIN	1
41034	OCUPACION	254004	ABOGADO, CIVIL-LABORAL/DERECHO PRIVADO	1
41033	OCUPACION	254003	ABOGADO PENALISTA	1
41032	OCUPACION	254002	ABOGADO PATROCINANTE	1
41031	OCUPACION	254001	ABOGADO	1
41030	OCUPACION	253013	ESPECIALISTA, SEGURIDAD EN EL TRABAJO	1
41029	OCUPACION	253012	ESPECIALISTA, RELACIONES PROFESIONALES	1
41028	OCUPACION	253011	ESPECIALISTA, FORMACION DEL PERSONAL	1
41027	OCUPACION	253010	ESPECIALISTA CUESTIONES DE PERSONAL	1
41026	OCUPACION	253009	ENTREVISTADOR, COLOCACION	1
41025	OCUPACION	253008	CONSEJERO, PERSPECTIVAS DE CARRERA	1
41024	OCUPACION	253007	CONSEJERO, ORIENTACION PROFESIONAL	1
41023	OCUPACION	253006	CONSEJERO, EMPLEO	1
41022	OCUPACION	253005	CONCILIADOR, RELACIONES LABORALES	1
41021	OCUPACION	253004	CONCILIADOR, LABORAL	1
2057	PAIS	\N	SUDÁN DEL SUR	0
41020	OCUPACION	253003	ANALISTA, PUESTOS DE TRABAJO	1
41019	OCUPACION	253002	ANALISTA, PROFESIONES	1
41018	OCUPACION	253001	ANALISTA, OCUPACIONES	1
41017	OCUPACION	252003	ADMINISTRADORES, OTROS	1
41016	OCUPACION	252002	ESPECIALISTA EN COOPERATIVAS	1
41015	OCUPACION	252001	ADMINISTRADOR DE EMPRESAS	1
41014	OCUPACION	251010	PERITO CONTABLE	1
41013	OCUPACION	251009	INTERVENTOR, CUENTAS	1
41012	OCUPACION	251008	CONTADOR, EMPRESA	1
41011	OCUPACION	251007	CONTADOR, COSTOS Y PRECIOS	1
41010	OCUPACION	251006	CONTADOR, COSTOS	1
1923	PAIS	688	SERBIA	1
41009	OCUPACION	251005	CONTADOR, CONTABILIDAD MUNICIPAL	1
41008	OCUPACION	251004	CONTADOR, AUDITORIA DE EMPRESAS	1
41007	OCUPACION	251003	CONTADOR	1
41006	OCUPACION	251002	AUDITOR	1
41005	OCUPACION	251001	ASESOR CONTABLE	1
41004	OCUPACION	247012	PROFESORES, OTROS	1
41003	OCUPACION	247011	PROFESOR DE IDIOMAS	1
41002	OCUPACION	247010	PROFESOR DE BAILE	1
41001	OCUPACION	247009	PROFESOR ALFABETIZADOR	1
41000	OCUPACION	247008	INSTRUCTOR DE MANEJO DE APARATOS ELECTRICOS, ELECTRONICOS,	1
40999	OCUPACION	247007	INSTITUTRIZ	1
40998	OCUPACION	247006	INSPECTOR, ESCUELAS	1
40997	OCUPACION	247005	ESPECIALISTA, ENSEÐANZA/METODOS AUDIOVISUALES	1
40996	OCUPACION	247004	CONSEJERO VOCACIONAL	1
40995	OCUPACION	247003	CONSEJERO DE EDUCACION	1
40994	OCUPACION	247002	AUXILIAR DE EDUCACION (ENCARGADO DE CURSO)	1
40993	OCUPACION	247001	ASESOR, METODOS DE ENSEÐANZA	1
40992	OCUPACION	246004	PROFESOR DE TALLERES, OTROS	1
40991	OCUPACION	246003	PROFESOR DE SENATI Y TECSUP	1
40990	OCUPACION	246002	PROFESOR DE CENECAPE	1
40989	OCUPACION	246001	PROFESOR DE ACADEMIA	1
40988	OCUPACION	245006	PROFESOR DE SORDOS	1
40987	OCUPACION	245005	PROFESOR DE NIÐOS EXCEPCIONALES	1
40986	OCUPACION	245004	PROFESOR DE MUDOS	1
40985	OCUPACION	245003	PROFESOR DE CIEGOS	1
40984	OCUPACION	245002	PROFESOR DE ALUMNOS MENTALMENTE DEFICIENTES	1
40983	OCUPACION	245001	PROFESOR DE ALUMNOS FISICAMENTE DEFICIENTES	1
40982	OCUPACION	244004	PROFESOR DE EDUCACION INICIAL (PRE-ESCOLAR)	1
40981	OCUPACION	244003	PROFESOR(A) DE PARVULOS	1
40980	OCUPACION	244002	PROFESOR(A) DE JARDIN DE INFANCIA	1
40979	OCUPACION	244001	PROFESOR(A) DE ESCUELA MATERNAL O CUNA (GUARDERIA)	1
40978	OCUPACION	243004	PROFESOR DE ENSEÐANZA PRIMARIA	1
40977	OCUPACION	243003	NORMALISTA	1
40976	OCUPACION	243002	MAESTRO DE ESCUELA	1
40975	OCUPACION	243001	MAESTRO DE ENSEÐANZA PRIMARIA	1
40974	OCUPACION	242047	PROFESOR, EDUCACION SECUNDARIA/OTROS	1
40973	OCUPACION	242046	PROFESOR, EDUCACION SECUNDARIA/ZOOLOGIA	1
40972	OCUPACION	242045	PROFESOR, EDUCACION SECUNDARIA/TECNOLOGICA	1
40971	OCUPACION	242044	PROFESOR, EDUCACION SECUNDARIA/TECNICA	1
40970	OCUPACION	242043	PROFESOR, EDUCACION SECUNDARIA/TAQUIGRAFIA	1
40969	OCUPACION	242042	PROFESOR, EDUCACION SECUNDARIA/TALLA (MADERA)	1
40968	OCUPACION	242041	PROFESOR, EDUCACION SECUNDARIA/SOCIOLOGIA	1
40967	OCUPACION	242040	PROFESOR, EDUCACION SECUNDARIA/SECRETARIADO	1
40966	OCUPACION	242039	PROFESOR, EDUCACION SECUNDARIA/RELIGION	1
40965	OCUPACION	242038	PROFESOR, EDUCACION SECUNDARIA/QUIMICA	1
40964	OCUPACION	242037	PROFESOR, EDUCACION SECUNDARIA/PROGRAMACION DE COMPUTADORAS	1
40963	OCUPACION	242036	PROFESOR, EDUCACION SECUNDARIA/PEDAGOGIA	1
40962	OCUPACION	242035	PROFESOR, EDUCACION SECUNDARIA/MUSICA	1
40961	OCUPACION	242034	PROFESOR, EDUCACION SECUNDARIA/MECANOGRAFIA	1
40960	OCUPACION	242033	PROFESOR, EDUCACION SECUNDARIA/MECANICA	1
40959	OCUPACION	242032	PROFESOR, ENSEÐANZA SECUNDARIA/MATEMATICAS	1
40958	OCUPACION	242031	PROFESOR, EDUCACION SECUNDARIA/LITERATURA	1
40957	OCUPACION	242030	PROFESOR, EDUCACION SECUNDARIA/LENGUA Y LITERATURA	1
40956	OCUPACION	242029	PROFESOR, EDUCACION SECUNDARIA/LABRA (METALES)	1
40955	OCUPACION	242028	PROFESOR, EDUCACION SECUNDARIA/LABORES	1
40954	OCUPACION	242027	PROFESOR, EDUCACION SECUNDARIA/HISTORIA DEL ARTE	1
40953	OCUPACION	242026	PROFESOR, EDUCACION SECUNDARIA/HISTORIA	1
40952	OCUPACION	242025	PROFESOR, EDUCACION SECUNDARIA/GEOLOGIA	1
40951	OCUPACION	242024	PROFESOR, EDUCACION SECUNDARIA/GEOGRAFIA	1
40950	OCUPACION	242023	PROFESOR, EDUCACION SECUNDARIA/FORMACION PROFESIONAL	1
40949	OCUPACION	242022	PROFESOR, EDUCACION SECUNDARIA/FISICA	1
40948	OCUPACION	242021	PROFESOR, EDUCACION SECUNDARIA/FILOSOFIA	1
40947	OCUPACION	242020	PROFESOR, EDUCACION SECUNDARIA/ENFERMERIA BASICA	1
40946	OCUPACION	242019	PROFESOR, EDUCACION SECUNDARIA/EDUCACION FISICA	1
40945	OCUPACION	242018	PROFESOR, EDUCACION SECUNDARIA/EDUCACION CIVICA	1
40944	OCUPACION	242017	PROFESOR, EDUCACION SECUNDARIA/ECONOMIA DOMESTICA	1
40943	OCUPACION	242016	PROFESOR, EDUCACION SECUNDARIA/EBANISTERIA	1
40942	OCUPACION	242015	PROFESOR, EDUCACION SECUNDARIA/DIBUJO TECNICO	1
40941	OCUPACION	242014	PROFESOR, EDUCACION SECUNDARIA/COSTURA	1
40940	OCUPACION	242013	PROFESOR, EDUCACION SECUNDARIA/CONTABILIDAD MERCANTIL	1
40939	OCUPACION	242012	PROFESOR, EDUCACION SECUNDARIA/COMERCIO Y SECRETARIADO	1
40938	OCUPACION	242011	PROFESOR, EDUCACION SECUNDARIA/CIENCIAS SOCIALES	1
40937	OCUPACION	242010	PROFESOR, EDUCACION SECUNDARIA/CIENCIAS NATURALES	1
40936	OCUPACION	242009	PROFESOR, EDUCACION SECUNDARIA/BOTANICA	1
40935	OCUPACION	242008	PROFESOR, EDUCACION SECUNDARIA/BIOLOGIA	1
40934	OCUPACION	242007	PROFESOR, EDUCACION SECUNDARIA/BELLAS ARTES	1
40933	OCUPACION	242006	PROFESOR, EDUCACION SECUNDARIA/ARTESANIA	1
40932	OCUPACION	242005	PROFESOR, EDUCACION SECUNDARIA/ARTE-OFICIOS	1
40931	OCUPACION	242004	PROFESOR, EDUCACION SECUNDARIA/ARTES MANUALES	1
40930	OCUPACION	242003	PROFESOR, EDUCACION SECUNDARIA/ALFABETIZACION DE ADULTOS	1
40929	OCUPACION	242002	PROFESOR, EDUCACION SECUNDARIA/AGRICULTURA	1
40928	OCUPACION	242001	PROFESOR, EDUCACION SECUNDARIA	1
40927	OCUPACION	241122	PROFESOR, UNIVERSIDAD, OTROS	1
40926	OCUPACION	241121	PROFESOR, EDUCACION SUPERIOR/ZOOLOGIA	1
40925	OCUPACION	241120	PROFESOR, EDUCACION SUPERIOR/TURISMO (ESCUELA DE TURISMO)	1
40924	OCUPACION	241119	PROFESOR, EDUCACION SUPERIOR/TRATAMIENTOS MEDICOS	1
40923	OCUPACION	241118	PROFESOR, EDUCACION SUPERIOR/TERAPEUTICA PARAMEDICA	1
40922	OCUPACION	241117	PROFESOR, EDUCACION SUPERIOR/TEORIA Y PRACTICA BANCARIA	1
40921	OCUPACION	241116	PROFESOR, EDUCACION SUPERIOR/TEOLOGIA	1
40920	OCUPACION	241115	PROFESOR, EDUCACION SUPERIOR/SOCIOLOGIA	1
40919	OCUPACION	241114	PROFESOR, EDUCACION SUPERIOR/SILVICULTURA	1
40918	OCUPACION	241113	PROFESOR, EDUCACION SUPERIOR/SERVICIOS DE TELECOMUNICACIONE	1
40917	OCUPACION	241112	PROFESOR, EDUCACION SUPERIOR/RELACIONES PUBLICAS	1
40916	OCUPACION	241111	PROFESOR, EDUCACION SUPERIOR/RADIOLOGIA	1
40915	OCUPACION	241110	PROFESOR, EDUCACION SUPERIOR/QUIROPRACTICA	1
40914	OCUPACION	241109	PROFESOR, EDUCACION SUPERIOR/QUIMICA	1
40913	OCUPACION	241108	PROFESOR, EDUCACION SUPERIOR/PUBLICIDAD E INFORMACION PUBLI	1
40912	OCUPACION	241107	PROFESOR, EDUCACION SUPERIOR/PSICOLOGIA	1
40911	OCUPACION	241106	PROFESOR, EDUCACION SUPERIOR/PROGRAMACION DE COMPUTADORAS	1
40910	OCUPACION	241105	PROFESOR, EDUCACION SUPERIOR/PROGRAMA DE URBANISMO	1
40909	OCUPACION	241104	PROFESOR, EDUCACION SUPERIOR/PREHISTORIA	1
40908	OCUPACION	241103	PROFESOR, EDUCACION SUPERIOR/PLANIFICACION INDUSTRIAL	1
40907	OCUPACION	241102	PROFESOR, EDUCACION SUPERIOR/PLANIFICACION FAMILIAR	1
40906	OCUPACION	241101	PROFESOR, EDUCACION SUPERIOR/PINTURA ARTISTICA	1
40905	OCUPACION	241100	PROFESOR, EDUCACION SUPERIOR/PESCA	1
40904	OCUPACION	241099	PROFESOR, EDUCACION SUPERIOR/PERIODISMO	1
40903	OCUPACION	241098	PROFESOR, EDUCACION SUPERIOR/PEDAGOGIA	1
40902	OCUPACION	241097	PROFESOR, EDUCACION SUPERIOR/PATOLOGIA	1
40901	OCUPACION	241096	PROFESOR, EDUCACION SUPERIOR/OSTEOPATIA	1
40900	OCUPACION	241095	PROFESOR, EDUCACION SUPERIOR/OPTOMETRIA	1
40899	OCUPACION	241094	PROFESOR, EDUCACION SUPERIOR/ODONTOLOGIA	1
40898	OCUPACION	241093	PROFESOR, EDUCACION SUPERIOR/OBSTETRICIA	1
40897	OCUPACION	241092	PROFESOR, EDUCACION SUPERIOR/OBSERVACION METEOROLOGICA	1
40896	OCUPACION	241091	PROFESOR, EDUCACION SUPERIOR/NAVEGACION MARITIMA	1
40895	OCUPACION	241090	PROFESOR, EDUCACION SUPERIOR/NAVEGACION AEREA	1
40894	OCUPACION	241089	PROFESOR, EDUCACION SUPERIOR/MUSICA	1
40893	OCUPACION	241088	PROFESOR, EDUCACION SUPERIOR/MINERIA	1
40892	OCUPACION	241087	PROFESOR, EDUCACION SUPERIOR/METODOS DE VENTA	1
40891	OCUPACION	241086	PROFESOR, EDUCACION SUPERIOR/METEOROLOGIA	1
40890	OCUPACION	241085	PROFESOR, EDUCACION SUPERIOR/METALURGIA	1
40889	OCUPACION	241084	PROFESOR, EDUCACION SUPERIOR/MEDICINA VETERINARIA	1
40888	OCUPACION	241083	PROFESOR, EDUCACION SUPERIOR/MEDICINA FORENSE	1
40887	OCUPACION	241082	PROFESOR, EDUCACION SUPERIOR/MEDICINA	1
40886	OCUPACION	241081	PROFESOR, EDUCACION SUPERIOR/MATEMATICAS	1
40885	OCUPACION	241080	PROFESOR, EDUCACION SUPERIOR/LITERATURA	1
40884	OCUPACION	241079	PROFESOR, EDUCACION SUPERIOR/LINGUISTICA	1
40883	OCUPACION	241078	PROFESOR, EDUCACION SUPERIOR/LETRAS	1
40882	OCUPACION	241077	PROFESOR, EDUCACION SUPERIOR/LENGUA Y LITERATURA	1
40881	OCUPACION	241076	PROFESOR, EDUCACION SUPERIOR/INGENIERIA Y ARQUITECTURA	1
40880	OCUPACION	241075	PROFESOR, EDUCACION SUPERIOR/INFORMATICA	1
40879	OCUPACION	241074	PROFESOR, EDUCACION SUPERIOR/IDIOMAS Y LINGUISTICA	1
40878	OCUPACION	241073	PROFESOR, EDUCACION SUPERIOR/HORTICULTURA	1
40877	OCUPACION	241072	PROFESOR, EDUCACION SUPERIOR/HISTORIA DEL ARTE	1
40876	OCUPACION	241071	PROFESOR, EDUCACION SUPERIOR/HISTORIA	1
40875	OCUPACION	241070	PROFESOR, EDUCACION SUPERIOR/GEOLOGIA	1
40874	OCUPACION	241069	PROFESOR, EDUCACION SUPERIOR/GEOGRAFIA	1
40873	OCUPACION	241068	PROFESOR, EDUCACION SUPERIOR/GEOFISICA	1
40872	OCUPACION	241067	PROFESOR, EDUCACION SUPERIOR/GEODESIA	1
40871	OCUPACION	241066	PROFESOR, EDUCACION SUPERIOR/FISIOTERAPIA	1
40870	OCUPACION	241065	PROFESOR, EDUCACION SUPERIOR/FISICA	1
40869	OCUPACION	241064	PROFESOR, EDUCACION SUPERIOR/FINANZAS	1
40868	OCUPACION	241063	PROFESOR, EDUCACION SUPERIOR/FILOSOFIA	1
40867	OCUPACION	241062	PROFESOR, EDUCACION SUPERIOR/FILOLOGIA	1
40866	OCUPACION	241061	PROFESOR, EDUCACION SUPERIOR/FARMACOLOGIA	1
40865	OCUPACION	241060	PROFESOR, EDUCACION SUPERIOR/FARMACIA	1
40864	OCUPACION	241059	PROFESOR, EDUCACION SUPERIOR/ESTUDIOS INTERNACIONALES	1
40863	OCUPACION	241058	PROFESOR, EDUCACION SUPERIOR/ESTUDIOS COMERCIALES	1
40862	OCUPACION	241057	PROFESOR, EDUCACION SUPERIOR/ESTADISTICA	1
40861	OCUPACION	241056	PROFESOR, EDUCACION SUPERIOR/ESPECIALIZADO EN COOP.AGRARIA,	1
40860	OCUPACION	241055	PROFESOR, EDUCACION SUPERIOR/ESCULTURA	1
40859	OCUPACION	241054	PROFESOR, EDUCACION SUPERIOR/ESCUELA DE POLICIA	1
40858	OCUPACION	241053	PROFESOR, EDUCACION SUPERIOR/ERGOTERAPIA	1
40857	OCUPACION	241052	PROFESOR, EDUCACION SUPERIOR/ENTOMOLOGIA	1
40856	OCUPACION	241051	PROFESOR, EDUCACION SUPERIOR/ENFERMERIA	1
40855	OCUPACION	241050	PROFESOR, EDUCACION SUPERIOR/ELABORACION DE ALIMENTOS	1
40854	OCUPACION	241049	PROFESOR, EDUCACION SUPERIOR/EDUCACION FISICA	1
40853	OCUPACION	241048	PROFESOR, EDUCACION SUPERIOR/ECONOMIA Y COMERCIO	1
40852	OCUPACION	241047	PROFESOR, EDUCACION SUPERIOR/ECONOMIA DOMESTICA	1
40851	OCUPACION	241046	PROFESOR, EDUCACION SUPERIOR/ECONOMIA	1
40850	OCUPACION	241045	PROFESOR, EDUCACION SUPERIOR/DIETETICA	1
40849	OCUPACION	241044	PROFESOR, EDUCACION SUPERIOR/DIBUJO INDUSTRIAL	1
40848	OCUPACION	241043	PROFESOR, EDUCACION SUPERIOR/DERECHO	1
40847	OCUPACION	241042	PROFESOR, EDUCACION SUPERIOR/DEMOGRAFIA	1
40846	OCUPACION	241041	PROFESOR, EDUCACION SUPERIOR/CRIA DE GANADO	1
40845	OCUPACION	241040	PROFESOR, EDUCACION SUPERIOR/COOPERATIVISMO	1
40844	OCUPACION	241039	PROFESOR, EDUCACION SUPERIOR/CONTABILIDAD	1
40843	OCUPACION	241038	PROFESOR, EDUCACION SUPERIOR/CONSERVATORIO	1
40842	OCUPACION	241037	PROFESOR, EDUCACION SUPERIOR/COMERCIALIZACION	1
40841	OCUPACION	241036	PROFESOR, EDUCACION SUPERIOR/CIENCIAS TECNICAS (TELECOMUNIC	1
40840	OCUPACION	241035	PROFESOR, EDUCACION SUPERIOR/CIENCIAS TECNICAS (TECNOLOGIA)	1
40839	OCUPACION	241034	PROFESOR, EDUCACION SUPERIOR/CIENCIAS TECNICAS (TECNOLOGIA	1
40838	OCUPACION	241033	PROFESOR, EDUCACION SUPERIOR/CIENCIAS TECNICAS (QUIMICA)	1
40837	OCUPACION	241032	PROFESOR, EDUCACION SUPERIOR/CIENCIAS TECNICAS (INGENIERIA	1
40836	OCUPACION	241031	PROFESOR, EDUCACION SUPERIOR/CIENCIAS TECNICAS (ELECTRONICA	1
40835	OCUPACION	241030	PROFESOR, EDUCACION SUPERIOR/CIENCIAS TECNICAS (ELECTRICIDA	1
40834	OCUPACION	241029	PROFESOR, EDUCACION SUPERIOR/CIENCIAS TECNICAS	1
40833	OCUPACION	241028	PROFESOR, EDUCACION SUPERIOR/CIENCIAS SOCIALES	1
40832	OCUPACION	241027	PROFESOR, EDUCACION SUPERIOR/CIENCIAS POLITICAS	1
40831	OCUPACION	241026	PROFESOR, EDUCACION SUPERIOR/CIENCIAS MILITARES	1
40830	OCUPACION	241025	PROFESOR, EDUCACION SUPERIOR/CIENCIAS MEDICAS	1
40829	OCUPACION	241024	PROFESOR, EDUCACION SUPERIOR/CIENCIAS MECANICAS	1
40828	OCUPACION	241023	PROFESOR, EDUCACION SUPERIOR/CIENCIAS MATEMATICAS	1
40827	OCUPACION	241022	PROFESOR, EDUCACION SUPERIOR/CIENCIAS FORENSES	1
40826	OCUPACION	241021	PROFESOR, EDUCACION SUPERIOR/CIENCIAS FISICAS Y QUIMICAS	1
40825	OCUPACION	241020	PROFESOR, EDUCACION SUPERIOR/CIENCIAS ECONOMICAS	1
40824	OCUPACION	241019	PROFESOR, EDUCACION SUPERIOR/CIENCIAS BIOLOGICAS	1
40823	OCUPACION	241018	PROFESOR, EDUCACION SUPERIOR/CIENCIAS AGRONOMICAS	1
40822	OCUPACION	241017	PROFESOR, EDUCACION SUPERIOR/BOTANICA	1
40821	OCUPACION	241016	PROFESOR, EDUCACION SUPERIOR/BIOQUIMICA	1
40820	OCUPACION	241015	PROFESOR, EDUCACION SUPERIOR/BIOLOGIA	1
40819	OCUPACION	241014	PROFESOR, EDUCACION SUPERIOR/BIBLIOTECONOMIA	1
40818	OCUPACION	241013	PROFESOR, EDUCACION SUPERIOR/BELLAS ARTES	1
40817	OCUPACION	241012	PROFESOR, EDUCACION SUPERIOR/BACTERIOLOGIA	1
40816	OCUPACION	241011	PROFESOR, EDUCACION SUPERIOR/ASTRONOMIA	1
40815	OCUPACION	241010	PROFESOR, EDUCACION SUPERIOR/ARTES INDUSTRIALES	1
40814	OCUPACION	241009	PROFESOR, EDUCACION SUPERIOR/ARTE DRAMATICO	1
40813	OCUPACION	241008	PROFESOR, EDUCACION SUPERIOR/ARQUITECTURA	1
40812	OCUPACION	241007	PROFESOR, EDUCACION SUPERIOR/ARQUEOLOGIA	1
40811	OCUPACION	241006	PROFESOR, EDUCACION SUPERIOR/ANTROPOLOGIA	1
40810	OCUPACION	241005	PROFESOR, EDUCACION SUPERIOR/ANATOMIA	1
40809	OCUPACION	241004	PROFESOR, EDUCACION SUPERIOR/AGRONOMIA	1
40808	OCUPACION	241003	PROFESOR, EDUCACION SUPERIOR/AGRICULTURA	1
40807	OCUPACION	241002	PROFESOR, EDUCACION SUPERIOR/ADMINISTRACION	1
40806	OCUPACION	241001	PROFESOR, EDUCACION SUPERIOR	1
40805	OCUPACION	239011	ENFERMERO, NIVEL SUPERIOR/HOSPITAL	1
40804	OCUPACION	239010	ENFERMERO, NIVEL SUPERIOR/CLINICA	1
40803	OCUPACION	239009	ENFERMERO, NIVEL SUPERIOR	1
40802	OCUPACION	239008	ENFERMERO, NIVEL SUPERIOR (DIPLOMADOS)	1
40801	OCUPACION	239007	ENFERMERA, NIVEL SUPERIOR/OBSTETRICIA	1
40800	OCUPACION	239006	ENFERMERA, NIVEL SUPERIOR/MATERNIDAD	1
40799	OCUPACION	239005	ENFERMERA, NIVEL SUPERIOR/HOSPITAL	1
40798	OCUPACION	239004	ENFERMERA, NIVEL SUPERIOR/CONSULTORIO	1
40797	OCUPACION	239003	ENFERMERA, NIVEL SUPERIOR/CLINICA	1
40796	OCUPACION	239002	ENFERMERA, TECMICO	1
40795	OCUPACION	239001	ENFERMERA, TECNICO	1
40794	OCUPACION	238004	QUIMICO-FARMACEUTICO	1
40793	OCUPACION	238003	FARMACEUTICO, HOSPITAL	1
40792	OCUPACION	238002	FARMACEUTICO, COMERCIO	1
40791	OCUPACION	238001	FARMACEUTICO	1
40790	OCUPACION	237005	VETERINARIO, OTROS	1
40789	OCUPACION	237004	VETERINARIO, SALUD PUBLICA, PROFESIONAL	1
40788	OCUPACION	237003	VETERINARIO, EPIDEMIOLOGIA	1
40787	OCUPACION	237002	VETERINARIO, CIRUGIA	1
40786	OCUPACION	237001	VETERINARIO	1
40785	OCUPACION	236010	ODONTOLOGO, PERIODONCIA	1
40784	OCUPACION	236009	ODONTOLOGO, PEDODONCIA	1
40783	OCUPACION	236008	ODONTOLOGO, ORTODONCIA	1
40782	OCUPACION	236007	ODONTOLOGO, ENDODONCIA	1
40781	OCUPACION	236006	ODONTOLOGO	1
40780	OCUPACION	236005	MEDICO, ODONTOLOGO	1
40779	OCUPACION	236004	DENTISTA, PROTESIS DENTALES	1
40778	OCUPACION	236003	DENTISTA	1
40777	OCUPACION	236002	CIRUJANO, DENTISTA	1
40776	OCUPACION	236001	CIRUJANO, BUCODENTAL	1
1924	PAIS	752	SUECIA	1
40775	OCUPACION	235049	PSIQUIATRA	1
40774	OCUPACION	235048	PEDIATRA	1
40773	OCUPACION	235047	OTORRINOLARINGOLOGO	1
40772	OCUPACION	235046	ORTOPTIA, ESPECIALISTA	1
40771	OCUPACION	235045	ORTOFONIA, ESPECIALISTA	1
40770	OCUPACION	235044	OFTALMOLOGO	1
40769	OCUPACION	235043	NEUROCIRUJANO	1
40768	OCUPACION	235042	MEDICO, VENEREOLOGO	1
40767	OCUPACION	235041	MEDICO, UROLOGO	1
40766	OCUPACION	235040	MEDICO, RADIOLOGIA	1
40765	OCUPACION	235039	MEDICO, PUERICULTOR	1
40764	OCUPACION	235038	MEDICO, PSIQUIATRIA	1
40763	OCUPACION	235037	MEDICO, PEDIATRIA	1
40762	OCUPACION	235036	MEDICO, PATOLOGO	1
40761	OCUPACION	235035	MEDICO, OTORRINOLARINGOLOGIA	1
40760	OCUPACION	235034	MEDICO, OSTEOPATIA	1
40759	OCUPACION	235033	MEDICO, OFTALMOLOGIA (OCULISTA)	1
40758	OCUPACION	235032	MEDICO, OBSTETRA/OBSTETRICES	1
40757	OCUPACION	235031	MEDICO, NEUROLOGO	1
40756	OCUPACION	235030	MEDICO, NEUMOLOGO	1
40755	OCUPACION	235029	MEDICO, NEFROLOGO	1
40754	OCUPACION	235028	MEDICO, MEDICINA GENERAL	1
40753	OCUPACION	235027	MEDICO, LARINGOLOGO	1
40752	OCUPACION	235026	MEDICO, GINECOLOGIA	1
40751	OCUPACION	235025	MEDICO, GERIATRA	1
40750	OCUPACION	235024	MEDICO, GASTROENTEROLOGO	1
40749	OCUPACION	235023	MEDICO FORENSE	1
40748	OCUPACION	235022	MEDICO, ESTOMATOLOGIA	1
40747	OCUPACION	235021	MEDICO, ENDOCRINOLOGO	1
40746	OCUPACION	235020	MEDICO, DERMATOLOGIA	1
40745	OCUPACION	235019	MEDICO, CARDIOLOGIA	1
40744	OCUPACION	235018	MEDICO, ANESTESIA	1
40743	OCUPACION	235017	MEDICO, ACUPUNTURA	1
40742	OCUPACION	235016	MEDICO	1
40741	OCUPACION	235015	GINECOLOGO	1
40740	OCUPACION	235014	DERMATOLOGO	1
40739	OCUPACION	235013	CIRUJANO, TORAX	1
40738	OCUPACION	235012	CIRUJANO PLASTICO	1
40737	OCUPACION	235011	CIRUJANO, OSTEOPATA	1
40736	OCUPACION	235010	CIRUJANO, ORTOPEDIA	1
40735	OCUPACION	235009	CIRUJANO, NEUROCIRUGIA	1
40734	OCUPACION	235008	CIRUJANO, CIRUGIA PLASTICA	1
40733	OCUPACION	235007	CIRUJANO, CIRUGIA GENERAL	1
40732	OCUPACION	235006	CIRUJANO, CARDIOLOGIA	1
40731	OCUPACION	235005	CIRUJANO	1
40730	OCUPACION	235004	CARDIOLOGO	1
40729	OCUPACION	235003	ANESTESISTA	1
40728	OCUPACION	235002	ALOPATA	1
40727	OCUPACION	235001	ALIENISTA	1
40726	OCUPACION	234015	ZOOTECNICO (INCLUYE INGENIEROS)	1
40725	OCUPACION	234014	INGENIERO FORESTAL	1
40724	OCUPACION	234013	INGENIERO EDAFOLOGO	1
40723	OCUPACION	234012	INGENIERO AGRONOMO	1
40722	OCUPACION	234011	INGENIERO AGROINDUSTRIAL	1
40721	OCUPACION	234010	AGRONOMO, SILVICULTURA	1
40720	OCUPACION	234009	AGRONOMO, OLEICULTOR	1
40719	OCUPACION	234008	AGRONOMO, HORTICULTURA	1
40718	OCUPACION	234007	AGRONOMO, FLORICULTOR	1
40717	OCUPACION	234006	AGRONOMO, EDAFOLOGIA	1
40716	OCUPACION	234005	AGRONOMO, ECOLOGO	1
40715	OCUPACION	234004	AGRONOMO, CONSERVACION DE LA NATURALEZA	1
40714	OCUPACION	234003	AGRONOMO, ARBORICULTOR	1
40713	OCUPACION	234002	AGRONOMO	1
40712	OCUPACION	234001	AGROLOGO	1
40711	OCUPACION	233002	DIETISTAS-NUTRICIONISTAS	1
40710	OCUPACION	233001	BROMATOLOGOS	1
40709	OCUPACION	232012	NEUROPATOLOGO	1
40708	OCUPACION	232011	HISTOPATOLOGO	1
40707	OCUPACION	232010	FISIOLOGO, OTROS	1
40706	OCUPACION	232009	FISIOLOGO, EPIDEMIOLOGIA	1
40705	OCUPACION	232008	FISIOLOGO, ENDOCRINOLOGIA	1
40704	OCUPACION	232007	FISIOLOGO, ANIMALES	1
40703	OCUPACION	232006	FISIOLOGO	1
40702	OCUPACION	232005	FARMACOLOGO	1
40701	OCUPACION	232004	EPIDEMIOLOGO	1
40700	OCUPACION	232003	BIOQUIMICO	1
40699	OCUPACION	232002	BIOFISICO	1
40698	OCUPACION	232001	ANATOMISTA	1
40697	OCUPACION	231058	ZOOLOGO, TAXONOMIA	1
40696	OCUPACION	231057	ZOOLOGO, PISCICULTURA	1
40695	OCUPACION	231056	ZOOLOGO, PARASITOLOGIA	1
40694	OCUPACION	231055	ZOOLOGO, ORNITOLOGIA	1
40693	OCUPACION	231054	ZOOLOGO, MAMALOGISTA	1
40692	OCUPACION	231053	ZOOLOGO, ICTIOLOGIA	1
40691	OCUPACION	231052	ZOOLOGO, HISTOLOGIA	1
40690	OCUPACION	231051	ZOOLOGO, ENTOMOLOGIA	1
40689	OCUPACION	231050	ZOOLOGO, EMBRIOLOGIA	1
40688	OCUPACION	231049	ZOOLOGO	1
40687	OCUPACION	231048	TAXONOMISTA, PLANTAS	1
40686	OCUPACION	231047	TAXONOMISTA, ANIMALES	1
40685	OCUPACION	231046	TAXONOMISTA	1
40684	OCUPACION	231045	PISCICULTOR DE LAS CIENCIAS BIOLOGICAS	1
40683	OCUPACION	231044	PARASITOLOGO	1
40682	OCUPACION	231043	ORNITOLOGO	1
40681	OCUPACION	231042	MICROBIOLOGO	1
40680	OCUPACION	231041	MICOLOGO	1
40679	OCUPACION	231040	ICTIOLOGO	1
40678	OCUPACION	231039	HISTOLOGO, PLANTAS	1
40677	OCUPACION	231038	HISTOLOGO, ANIMALES	1
40676	OCUPACION	231037	HISTOLOGO	1
40675	OCUPACION	231036	HIDROBIOLOGO	1
40674	OCUPACION	231035	GENETISTA, ZOOLOGO	1
40673	OCUPACION	231034	GENETISTA, BOTANICA	1
40672	OCUPACION	231033	GENETISTA	1
40671	OCUPACION	231032	ENTOMOLOGO	1
40670	OCUPACION	231031	EMBRIOLOGO	1
40669	OCUPACION	231030	ECOLOGISTA, ZOOLOGIA	1
40668	OCUPACION	231029	ECOLOGISTA, BOTANICA	1
40667	OCUPACION	231028	ECOLOGISTA	1
40666	OCUPACION	231027	CITOLOGO, ZOOLOGIA	1
40665	OCUPACION	231026	CITOLOGO, BOTANICA	1
40664	OCUPACION	231025	CITOLOGO	1
40663	OCUPACION	231024	BOTANICO, TAXONOMIA	1
40662	OCUPACION	231023	BOTANICO, SUELOS	1
40661	OCUPACION	231022	BOTANICO, MICOLOGIA	1
40660	OCUPACION	231021	BOTANICO, HISTOLOGIA	1
40659	OCUPACION	231020	BOTANICO, GENETICA	1
40658	OCUPACION	231019	BOTANICO, ECONOMISTA	1
40657	OCUPACION	231018	BOTANICO, ECOLOGIA	1
40656	OCUPACION	231017	BOTANICO	1
40655	OCUPACION	231016	BIOLOGO, HIDROBIOLOGIA	1
40654	OCUPACION	231015	BIOLOGO, GENETICA	1
40653	OCUPACION	231014	BIOLOGO, FAUNA MARINA	1
40652	OCUPACION	231013	BIOLOGO, FAUNA DE AGUA DULCE	1
40651	OCUPACION	231012	BIOLOGO MOLECULAR	1
40650	OCUPACION	231011	BIOLOGO	1
40649	OCUPACION	231010	BACTERIOLOGO, SUELOS	1
40648	OCUPACION	231009	BACTERIOLOGO, PESCA	1
40647	OCUPACION	231008	BACTERIOLOGO, MEDICINA/VETERINARIA	1
40646	OCUPACION	231007	BACTERIOLOGO, MEDICINA	1
40645	OCUPACION	231006	BACTERIOLOGO, INDUSTRIA, LACTEAS	1
40644	OCUPACION	231005	BACTERIOLOGO, INDUSTRIA	1
40643	OCUPACION	231004	BACTERIOLOGO, FARMACIA	1
40642	OCUPACION	231003	BACTERIOLOGO, ALIMENTACION	1
40641	OCUPACION	231002	BACTERIOLOGO, AGRICULTURA	1
40640	OCUPACION	231001	BACTERIOLOGO	1
40639	OCUPACION	229011	INGENIERO (NO CLASIFICADO EN OTRAS CLASIFICACIONES)	1
40638	OCUPACION	229010	INGENIERO, DE VUELO	1
40637	OCUPACION	229009	INGENIERO, TOPOGRAFO	1
40636	OCUPACION	229008	INGENIERO, PLANIFICADOR DE TRAFICO	1
40635	OCUPACION	229007	INGENIERO, PRODUCCION	1
40634	OCUPACION	229006	INGENIERO, MEDIO AMBIENTE	1
40633	OCUPACION	229005	INGENIERO, INDUSTRIAS DE PAPEL	1
40632	OCUPACION	229004	INGENIERO, INDUSTRIAS ALIMENTARIAS	1
40631	OCUPACION	229003	INGENIERO, CONTROL DE CALIDAD	1
40630	OCUPACION	229002	INGENIERO, CERAMICA Y VIDRIOS	1
40629	OCUPACION	229001	INGENIERO, CUERO Y CALZADO	1
40628	OCUPACION	228001	INGENIERO PESQUERO	1
40627	OCUPACION	227011	INGENIERO, ORGANIZACION Y PLANIFICACION DE EMPRESAS	1
40626	OCUPACION	227010	INGENIERO, ORGANIZACION CALCULO DE COSTOS	1
40625	OCUPACION	227009	INGENIERO, ORGANIZACION Y METODOS	1
40624	OCUPACION	227008	INGENIERO, ORGANIZACION INDUSTRIAL	1
40623	OCUPACION	227007	INGENIERO, ORGANIZACION DE ESTUDIO DE TIEMPOS Y MOVIMIENTOS	1
40622	OCUPACION	227006	INGENIERO INDUSTRIAL, HIGIENE Y SEGURIDAD INDUSTRIAL	1
40621	OCUPACION	227005	INGENIERO INDUSTRIAL	1
40620	OCUPACION	227004	INGENIERO CONSULTOR, ORGANIZACION INDUSTRIAL	1
40619	OCUPACION	227003	CREADOR, SISTEMAS/EXCEPTO INFORMATICOS	1
40618	OCUPACION	227002	INGENIERO, SISTEMAS/EXCEPTO INFORMATICOS	1
40617	OCUPACION	227001	INGENIERO, ADMINISTRATIVO	1
40616	OCUPACION	226014	TOPOGRAFO, (SUELOS)	1
40615	OCUPACION	226013	TOPOGRAFO, HIDROGRAFICO	1
40614	OCUPACION	226012	TOPOGRAFO, FOTOGEOMETRIA	1
40613	OCUPACION	226011	FOTOGRAMETRISTA Y AEROFOTOGRAMETISTA	1
40612	OCUPACION	226010	CARTOGRAFO, MARINA	1
40611	OCUPACION	226009	CARTOGRAFO	1
40610	OCUPACION	226008	AGRIMENSOR, TOPOGRAFIA AEREA	1
40609	OCUPACION	226007	AGRIMENSOR, TOPOGRAFIA	1
40608	OCUPACION	226006	AGRIMENSOR, MINAS	1
40607	OCUPACION	226005	AGRIMENSOR, HIDROGRAFICO	1
40606	OCUPACION	226004	AGRIMENSOR, GEODESICO	1
40605	OCUPACION	226003	AGRIMENSOR, MARINA	1
40604	OCUPACION	226002	AGRIMENSOR, AEROFOTOGRAFO	1
40603	OCUPACION	226001	AGRIMENSOR	1
40602	OCUPACION	225008	INGENIERO DE MINAS, OTROS	1
40601	OCUPACION	225007	INGENIERO, SIDERURGICO	1
40434	OCUPACION	214001	ESTRATIGRAFISTA	1
40600	OCUPACION	225006	INGENIERO, PERFORACION/POZOS DE PETROLEO Y DE GAS	1
40599	OCUPACION	225005	INGENIERO, MINAS/PETROLEO Y GAS NATURAL	1
40598	OCUPACION	225004	INGENIERO, MINAS/MINERALES NO METALICOS	1
40597	OCUPACION	225003	INGENIERO, MINAS/MINERALES METALICOS	1
40596	OCUPACION	225002	INGENIERO, MINAS/CARBON	1
40595	OCUPACION	225001	INGENIERO, MINAS	1
40594	OCUPACION	224005	INGENIERO, METALURGICO/OTROS	1
40593	OCUPACION	224004	INGENIERO METALURGICO, TRATAMIENTO DE LOS METALES	1
40592	OCUPACION	224003	INGENIERO METALURGICO, PRODUCCION Y AFINO/METALES	1
40591	OCUPACION	224002	INGENIERO METALURGICO, MINERALES RADIACTIVOS Y FUNDICION	1
40590	OCUPACION	224001	INGENIERO METALURGICO	1
40589	OCUPACION	223018	INGENIERO, PETROQUIMICO	1
40588	OCUPACION	223017	INGENIERO QUIMICO, OTROS	1
40587	OCUPACION	223016	INGENIERO QUIMICO, TECNOLOGIA DE LOS COMBUSTIBLES	1
40586	OCUPACION	223015	INGENIERO QUIMICO, PETROLEO Y GAS NATURAL	1
40585	OCUPACION	223014	INGENIERO QUIMICO, PERFUMISTA	1
40584	OCUPACION	223013	INGENIERO QUIMICO, PAPEL	1
40583	OCUPACION	223012	INGENIERO QUIMICO, MATERIAL PLASTICO	1
40582	OCUPACION	223011	INGENIERO QUIMICO, GAS/PRODUCCION Y DISTRIBUCION	1
40581	OCUPACION	223010	INGENIERO QUIMICO, FIBRAS TEXTILES (ING. TEXTIL)	1
40580	OCUPACION	223009	INGENIERO QUIMICO, FABRICACION	1
40579	OCUPACION	223008	INGENIERO QUIMICO, COLORES Y PINTURAS	1
40578	OCUPACION	223007	INGENIERO QUIMICO, CAUCHO	1
40407	OCUPACION	211017	FISICO, OTRO	1
40577	OCUPACION	223006	INGENIERO QUIMICO, CARBURANTES/REFINERIA DE PETROLEO	1
40576	OCUPACION	223005	INGENIERO QUIMICO, EXPLOSIVOS	1
40575	OCUPACION	223004	INGENIERO QUIMICO, ANTIBIOTICOS	1
40574	OCUPACION	223003	INGENIERO QUIMICO, ALIMENTOS Y BEBIDAS	1
40573	OCUPACION	223002	INGENIERO QUIMICO EN INDUSTRIA QUIMICA	1
40572	OCUPACION	223001	INGENIERO BIOQUIMICO INDUSTRIAL	1
40571	OCUPACION	222027	INGENIERO, MAQUINARIA Y HERRAMIENTAS INDUSTRIALES	1
40570	OCUPACION	222026	INGENIERO, FRIO INDUSTRIAL	1
40569	OCUPACION	222025	INGENIERO, CONSTRUCCION NAVAL	1
40568	OCUPACION	222024	INGENIERO, CONSTRUCCION DE AUTOMOVILES	1
40567	OCUPACION	222023	INGENIERO, CONSTRUCCION AERONAUTICA	1
40566	OCUPACION	222022	INGENIERO, CLIMATIZACION	1
40565	OCUPACION	222021	INGENIERO, CALEFACCION, VENTILACION Y REFRIGERACION	1
40564	OCUPACION	222020	INGENIERO MECANICO, TURBINAS DE GAS	1
40563	OCUPACION	222019	INGENIERO MECANICO, DE FLUIDOS	1
40562	OCUPACION	222018	INGENIERO MECANICO, MOTORES/LOCOMOTORAS A VAPOR	1
40561	OCUPACION	222017	INGENIERO MECANICO, MOTORES/EXCEPTO LOS MARINOS	1
40560	OCUPACION	222016	INGENIERO MECANICO, MOTORES/EQUIPO PARA BARCOS	1
40559	OCUPACION	222015	INGENIERO MECANICO, MOTORES MARINOS	1
40558	OCUPACION	222014	INGENIERO MECANICO, MOTORES DE COMBUSTION INTERNA	1
40557	OCUPACION	222013	INGENIERO MECANICO, MOTORES DIESEL Y/O PROPULSION A CHORRO	1
40556	OCUPACION	222012	INGENIERO MECANICO, MOTORES A REACCION	1
40555	OCUPACION	222011	INGENIERO MECANICO, MAQUINARIA Y HERRAMIENTAS INDUSTRIALES	1
40554	OCUPACION	222010	INGENIERO MECANICO Y ELECTRICISTA	1
40553	OCUPACION	222009	INGENIERO MECANICO, ENERGIA NUCLEAR	1
40552	OCUPACION	222008	INGENIERO MECANICO, CONSTRUCCION NAVAL	1
40551	OCUPACION	222007	INGENIERO MECANICO, CLIMATIZACION	1
40550	OCUPACION	222006	INGENIERO MECANICO, CALEFACCION, VENTILACION Y REFRIGERACIO	1
40549	OCUPACION	222005	INGENIERO MECANICO, AUTOMOVILES	1
40548	OCUPACION	222004	INGENIERO MECANICO, AUTOMOTORES	1
40547	OCUPACION	222003	INGENIERO MECANICO, AGRICULTURA (ING. AGRICOLA)	1
40546	OCUPACION	222002	INGENIERO MECANICO, AERONAUTICA	1
40545	OCUPACION	222001	INGENIERO MECANICO	1
40544	OCUPACION	221026	INGENIERO TELECOMUNICACIONES/TELEVISION	1
40543	OCUPACION	221025	INGENIERO TELECOMUNICACIONES/TELEGRAFOS	1
40542	OCUPACION	221024	INGENIERO TELECOMUNICACIONES/TELEFONOS	1
40541	OCUPACION	221023	INGENIERO TELECOMUNICACIONES/SISTEMAS DE SEÐALES	1
40540	OCUPACION	221022	INGENIERO TELECOMUNICACIONES/RADIO	1
40539	OCUPACION	221021	INGENIERO TELECOMUNICACIONES/RADAR	1
40538	OCUPACION	221020	INGENIERO TELECOMUNICACIONES	1
40537	OCUPACION	221019	INGENIERO ELECTRONICO	1
40536	OCUPACION	221018	INGENIERO DE CALCULADORAS ELECTRONICAS	1
40535	OCUPACION	221017	INGENIERO ELECTRONICO, SEMICONDUCTORES	1
40534	OCUPACION	221016	INGENIERO DE CONTROLES INDUSTRIALES Y ELECTRONICA	1
40533	OCUPACION	221015	INGENIERO DE ORDENADORES ELECTRONICOS	1
40532	OCUPACION	221014	INGENIERO ELECTRONICO, CONSTRUCCION DE COMPUTADORAS	1
40531	OCUPACION	221013	TECNOLOGO ELECTRICIDAD	1
40530	OCUPACION	221012	INGENIERO ELECTRICISTA, TRANSPORTE Y DISTRIBUCION ENERGIA	1
40529	OCUPACION	221011	INGENIERO ELECTRICISTA, TRANSPORTE DE CORRIENTE ELECTRICA	1
40528	OCUPACION	221010	INGENIERO ELECTRICISTA, TRACCION ELECTRICA	1
40527	OCUPACION	221009	INGENIERO ELECTRICISTA, PRODUCCION DE ENERGIA ELECTRICA	1
40526	OCUPACION	221008	INGENIERO ELECTRICISTA, PRODUCCION DE ENERGIA	1
40525	OCUPACION	221007	INGENIERO ELECTRICISTA, LINEAS ELECTRICAS	1
40524	OCUPACION	221006	INGENIERO ELECTRICISTA, ILUMINACION	1
40523	OCUPACION	221005	INGENIERO ELECTRICISTA, EQUIPO ELECTROMECANICO DE BAJA POTE	1
40522	OCUPACION	221004	INGENIERO ELECTRICISTA, EQUIPO ELECTROMECANICO	1
40521	OCUPACION	221003	INGENIERO ELECTRICISTA, ALTO VOLTAJE	1
40520	OCUPACION	221002	INGENIERO ELECTRICISTA	1
40519	OCUPACION	221001	ELECTROTECNICO SUPERIOR	1
40518	OCUPACION	219027	INGENIERO, SANITARIO	1
40517	OCUPACION	219026	INGENIERO, IRRIGACION	1
40516	OCUPACION	219025	INGENIERO, HIDROLOGIA	1
40515	OCUPACION	219024	INGENIERO, HIDRAULICO	1
40514	OCUPACION	219023	INGENIERO, CANALES Y PUERTOS	1
40513	OCUPACION	219022	INGENIERO CIVIL, TRABAJOS MARITIMOS	1
40512	OCUPACION	219021	INGENIERO CIVIL, MECANICA/SUELOS	1
40511	OCUPACION	219020	INGENIERO CIVIL, IRRIGACION	1
1925	PAIS	756	SUIZA	1
40510	OCUPACION	219019	INGENIERO CIVIL, INSPECTOR DE OBRAS	1
40509	OCUPACION	219018	INGENIERO CIVIL, CONTRATISTAS DE OBRAS	1
40508	OCUPACION	219017	INGENIERO CIVIL, CONSTRUCCION/TUNELES	1
40507	OCUPACION	219016	INGENIERO CIVIL, CONSTRUCCION/TORRES	1
40506	OCUPACION	219015	INGENIERO CIVIL, CONSTRUCCION/PUENTES	1
40505	OCUPACION	219014	INGENIERO CIVIL, CONSTRUCCION/MUELLES Y PUERTOS	1
40504	OCUPACION	219013	INGENIERO CIVIL, CONSTRUCCION/INSTALACIONES PORTUARIAS	1
40503	OCUPACION	219012	INGENIERO CIVIL, CONSTRUCCION/VIAS FERREAS	1
40502	OCUPACION	219011	INGENIERO CIVIL, CONSTRUCCION/ESTRUCTURAS METALICAS	1
40501	OCUPACION	219010	INGENIERO CIVIL, CONSTRUCCION/ESTRUCTURAS DE EDIFICIOS	1
40500	OCUPACION	219009	INGENIERO CIVIL, CONSTRUCCION/EDIFICIOS Y/O VIVIENDAS	1
40499	OCUPACION	219008	INGENIERO CIVIL, CONSTRUCCION/CHIMENEAS DE FABRICAS	1
40498	OCUPACION	219007	INGENIERO CIVIL, CONSTRUCCION/CARRETERAS Y AUTOPISTAS	1
40497	OCUPACION	219006	INGENIERO CIVIL, CONSTRUCCION/CALLES	1
40496	OCUPACION	219005	INGENIERO CIVIL, CONSTRUCCION/AEROPUERTOS	1
40495	OCUPACION	219004	INGENIERO CIVIL, CONSTRUCCION/AERODROMOS	1
40494	OCUPACION	219003	INGENIERO CIVIL, CONSTRUCCION Y OBRAS PUBLICAS	1
40493	OCUPACION	219002	INGENIERO CIVIL, CONSTRUCCION	1
40492	OCUPACION	219001	INGENIERO CIVIL	1
40491	OCUPACION	218005	URBANISTA	1
40490	OCUPACION	218004	PLANIFICADOR, TRANSITO	1
40489	OCUPACION	218003	INGENIERO, DE TRANSPORTE	1
40488	OCUPACION	218002	ARQUITECTO, INTERIORES DE EDIFICIOS	1
40487	OCUPACION	218001	ARQUITECTO, EDIFICIOS	1
40486	OCUPACION	217008	INGENIERO, APLICACIONES DE LA INFORMATICA	1
40485	OCUPACION	217007	INGENIERO, SISTEMAS INFORMATICOS	1
40484	OCUPACION	217006	ANALISTAS, TRANSMISIONES/SISTEMAS INFORMATICOS	1
40483	OCUPACION	217005	ANALISTA, SISTEMAS INFORMATICOS/TELECOMUNICACIONES	1
40482	OCUPACION	217004	ANALISTA, SISTEMAS INFORMATICOS/COMPUTADORAS	1
40481	OCUPACION	217003	ANALISTA, SISTEMAS INFORMATICOS/BANCO DE DATOS	1
40480	OCUPACION	217002	ANALISTA, SISTEMAS INFORMATICOS	1
40479	OCUPACION	217001	ADMINISTRADOR, BANCO DE DATOS	1
40478	OCUPACION	216016	INGENIERO, ESTADISTICO	1
40477	OCUPACION	216015	ESTADISTICO, MUESTRISTA	1
40476	OCUPACION	216014	ESTADISTICO, MATEMATICO	1
40475	OCUPACION	216013	ESTADISTICO, INVESTIGACION	1
40474	OCUPACION	216012	ESTADISTICO, FINANZAS	1
40473	OCUPACION	216011	ESTADISTICO, ESTADISTICA APLICADA	1
40472	OCUPACION	216010	ESTADISTICO, ENCUESTAS POR SONDEO	1
40471	OCUPACION	216009	ESTADISTICO, ENCUESTAS	1
40470	OCUPACION	216008	ESTADISTICO, ECONOMIA	1
40469	OCUPACION	216007	ESTADISTICO, BIOMETRIA	1
40468	OCUPACION	216006	ESTADISTICO, BIOESTADISTICA	1
40467	OCUPACION	216005	ESTADISTICO, AGRICULTURA	1
40466	OCUPACION	216004	ESTADISTICO	1
40465	OCUPACION	216003	DEMOGRAFO	1
40464	OCUPACION	216002	BIOMETRISTA	1
40463	OCUPACION	216001	BIOESTADISTICO	1
40462	OCUPACION	215005	MATEMATICO-ANALISTA, INVESTIGACION OPERATIVA	1
40461	OCUPACION	215004	MATEMATICO, MATEMATICA PURA	1
40460	OCUPACION	215003	MATEMATICO, MATEMATICA APLICADA	1
40459	OCUPACION	215002	MATEMATICO, ANALISIS ACTUARIAL	1
40458	OCUPACION	215001	ACTUARIO	1
40457	OCUPACION	214024	VULCANOLOGO	1
40456	OCUPACION	214023	SISMOLOGO	1
40455	OCUPACION	214022	PETROLOGO	1
40454	OCUPACION	214021	PALEONTOLOGO	1
40453	OCUPACION	214020	OCEANOGRAFO, GEOLOGIA	1
40452	OCUPACION	214019	OCEANOGRAFO, GEOFISICA	1
40451	OCUPACION	214018	MINERALOGISTA	1
40450	OCUPACION	214017	MICROPALEONTOLOGO	1
40449	OCUPACION	214016	HIDROLOGO	1
40448	OCUPACION	214015	GEOMORFOLOGO	1
40447	OCUPACION	214014	GEOLOGO, PETROLEO	1
40446	OCUPACION	214013	GEOLOGO, PALEONTOLOGIA	1
40445	OCUPACION	214012	GEOLOGO, OCEANOGRAFIA	1
40444	OCUPACION	214011	GEOLOGO, MINAS	1
40443	OCUPACION	214010	GEOLOGO, ESTRATIGRAFIA	1
40442	OCUPACION	214009	GEOLOGO (INCLUYE INGENIEROS)	1
40441	OCUPACION	214008	GEOFISICO, VULCANOLOGIA	1
40440	OCUPACION	214007	GEOFISICO, SISMOLOGIA	1
40439	OCUPACION	214006	GEOFISICO, OCEANOGRAFIA	1
40438	OCUPACION	214005	GEOFISICO, HIDROLOGIA	1
40437	OCUPACION	214004	GEOFISICO, GEOMORFOLOGIA	1
40436	OCUPACION	214003	GEOFISICO (INCLUYE INGENIEROS)	1
40435	OCUPACION	214002	GEODESIA	1
40433	OCUPACION	213020	QUIMICO, OTROS (NO INCLUYE ING. QUIMICO)	1
40432	OCUPACION	213019	QUIMICO, TINTURAS	1
40431	OCUPACION	213018	QUIMICO, TEXTILES	1
40430	OCUPACION	213017	QUIMICO, QUIMICA ORGANICA	1
40429	OCUPACION	213016	QUIMICO, QUIMICA MINERAL	1
40428	OCUPACION	213015	QUIMICO, QUIMICA INORGANICA	1
40427	OCUPACION	213014	QUIMICO, QUIMICA ANALITICA	1
40426	OCUPACION	213013	QUIMICO, INDUSTRIA METALURGICA	1
40425	OCUPACION	213012	QUIMICO, INDUSTRIA DEL VIDRIO	1
40424	OCUPACION	213011	QUIMICO, FISICA/OTROS	1
40423	OCUPACION	213010	QUIMICO, FARMACIA/ INDUSTRIA	1
40422	OCUPACION	213009	QUIMICO, FARMACIA	1
40421	OCUPACION	213008	QUIMICO, ELECTROQUIMICA	1
40420	OCUPACION	213007	QUIMICO, DETERGENTES	1
40419	OCUPACION	213006	QUIMICO, CUEROS Y PIELES	1
40418	OCUPACION	213005	QUIMICO, CORROSION	1
40417	OCUPACION	213004	QUIMICO, CONTROL DE CALIDAD	1
40416	OCUPACION	213003	QUIMICO, COLORANTES	1
40415	OCUPACION	213002	QUIMICO ANALISTA	1
40414	OCUPACION	213001	QUIMICO	1
40413	OCUPACION	212006	METEOROLOGO, PREVISION DEL TIEMPO	1
40412	OCUPACION	212005	METEOROLOGO, CLIMATOLOGIA	1
40411	OCUPACION	212004	METEOROLOGO	1
40410	OCUPACION	212003	CLIMATOLOGO	1
40409	OCUPACION	212002	COSMOLOGO	1
40408	OCUPACION	212001	COSMOGRAFO	1
40406	OCUPACION	211016	FISICO, TERMODINAMICA	1
40405	OCUPACION	211015	FISICO, SONIDO	1
40404	OCUPACION	211014	FISICO, OPTICA	1
40403	OCUPACION	211013	FISICO, MECANICA	1
40402	OCUPACION	211012	FISICO, MATEMATICO	1
40401	OCUPACION	211011	FISICO, FISICA TEORICA	1
40400	OCUPACION	211010	FISICO, FISICA NUCLEAR	1
40399	OCUPACION	211009	FISICO, ENERGIA NUCLEAR	1
40398	OCUPACION	211008	FISICO, ENERGIA SOLAR (NO CONVENCIONAL)	1
40397	OCUPACION	211007	FISICO, ESTATICA	1
40396	OCUPACION	211006	FISICO, ELECTRONICA	1
40395	OCUPACION	211005	FISICO, ELECTRICIDAD Y MAGNETISMO	1
40394	OCUPACION	211004	FISICO, ACUSTICA	1
40393	OCUPACION	211003	FISICO	1
40392	OCUPACION	211002	ASTRONOMO	1
40391	OCUPACION	211001	ASTROFISICO	1
40390	OCUPACION	148010	GEREN.-ADM., TALLERES/MEDIANOS Y PEQUEÐOS	1
40389	OCUPACION	148009	GEREN.-ADM., LAVANDERIA	1
40388	OCUPACION	148008	GEREN.-ADM., GIMNASIO	1
40387	OCUPACION	148007	GEREN.-ADM., CENTRO DE RECREACION	1
40386	OCUPACION	148006	GEREN.-ADM., CENTRO DE ESTETICA	1
40385	OCUPACION	148005	GEREN.-ADM., AGENCIA DE SERVICIOS/EXCEPTO:BARES, HOTEL Y SI	1
40384	OCUPACION	148004	GEREN.-ADM., AGENCIA DE TURISMO/EXCURSIONES	1
40383	OCUPACION	148003	GEREN.-ADM., AGENCIA DE PROTECCION Y SEGURIDAD	1
40382	OCUPACION	148002	GEREN.-ADM., AGENCIA DE POMPAS FUNEBRES	1
40381	OCUPACION	148001	GEREN.-ADM., AGENCIA DE LIMPIEZA Y DESINFECCION	1
40380	OCUPACION	147003	GERENTE, TRANSPORTE	1
40379	OCUPACION	147002	GERENTE, COMUNICACIONES	1
40378	OCUPACION	147001	GERENTE, ALMACENAMIENTO	1
40377	OCUPACION	146019	GERENTE, TABERNA	1
40376	OCUPACION	146018	GERENTE, SNACK-BAR	1
40375	OCUPACION	146017	GERENTE, RESTAURANTE/ AUTOSERVICIO	1
40374	OCUPACION	146016	GERENTE, RESTAURANTE-BAR	1
40373	OCUPACION	146015	GERENTE, RESTAURANTE	1
40372	OCUPACION	146014	GERENTE, PEÐA	1
40371	OCUPACION	146013	GERENTE, PENSION	1
40370	OCUPACION	146012	GERENTE, PARQUE DE CARAVANAS	1
40369	OCUPACION	146011	GERENTE, MOTEL	1
40368	OCUPACION	146010	GERENTE, HOTEL	1
40367	OCUPACION	146009	GERENTE, HOSTELERIA	1
40366	OCUPACION	146008	GERENTE, FONDA	1
40365	OCUPACION	146007	GERENTE, CASA DE HUESPEDES	1
40364	OCUPACION	146006	GERENTE, CANTINA/ EMPRESA	1
40363	OCUPACION	146005	GERENTE, CAMPAMENTO/ VACACIONES	1
40362	OCUPACION	146004	GERENTE, CAFETERIA	1
40361	OCUPACION	146003	GERENTE, CAFE-TEATRO	1
40360	OCUPACION	146002	GERENTE, BAR/DISCOTECA Y SNACK BAR	1
40359	OCUPACION	146001	GERENTE, ALBERGUE/ JOVENES	1
40358	OCUPACION	145005	GERENTE, COMERCIO NEP	1
40357	OCUPACION	145004	CONCESIONARIO-ADM., REST. Y BAR/CAFETERIA (TREN, BARCO, AVI	1
40356	OCUPACION	145003	CONCESIONARIO-ADM., REST. Y CAFETERIA (FAB. Y OFIC.)	1
40355	OCUPACION	145002	DIRECTOR, COMERCIO NEP	1
40354	OCUPACION	145001	ADMINISTRADOR, COMERCIO NEP	1
40353	OCUPACION	144013	GERENTE, TIENDA	1
40352	OCUPACION	144012	GERENTE REPARACION DE VEHICULOS, AUTO MOTORES, MOTOCICLETAS	1
40351	OCUPACION	144011	GERENTE, COMERCIO MINORISTA/ TIENDAS (VENTAS POR CORREO)	1
40350	OCUPACION	144010	GERENTE, COMERCIO MINORISTA/ TIENDAS (VENTAS CON DESCUENTOS	1
40349	OCUPACION	144009	GERENTE, COMERCIO MINORISTA/ TIENDAS (AUTOSERVICIO)	1
40348	OCUPACION	144008	GERENTE, COMERCIO MINORISTA/ TIENDAS	1
40347	OCUPACION	144007	GERENTE, COMERCIO MINORISTA/ CADENA DE ALMACENES	1
40346	OCUPACION	144006	GERENTE, COMERCIO MINORISTA	1
40345	OCUPACION	144005	GERENTE, COMERCIO MAYORISTA/ IMPORTACION	1
40344	OCUPACION	144004	GERENTE, COMERCIO MAYORISTA/ EXPORTACION	1
40343	OCUPACION	144003	GERENTE, COMERCIO MAYORISTA	1
40342	OCUPACION	144002	COMERCIANTE, MINORISTA	1
40341	OCUPACION	144001	COMERCIANTE, MAYORISTA	1
40340	OCUPACION	143001	GERENTE, CONSTRUCCION	1
40339	OCUPACION	142003	GERENTE, SUMINISTRO DE ELECTRICIDAD, GAS Y AGUA	1
40338	OCUPACION	142002	GERENTE, INDUSTRIA MANUFACTURERA	1
40337	OCUPACION	142001	GERENTE, EXPLOTACION DE MINAS Y CANTERAS	1
40336	OCUPACION	141005	GERENTE, SILVICULTURA	1
40335	OCUPACION	141004	GERENTE, PESCA	1
40334	OCUPACION	141003	GERENTE, EXPLOTACION: AGRICOLA, FORESTAL Y PECUARIA	1
40333	OCUPACION	141002	GERENTE, CAZA	1
40332	OCUPACION	141001	GERENTE, AGRICULTURA	1
40331	OCUPACION	139011	GERENTE DE VENTAS	1
40330	OCUPACION	139010	GERENTE DE COMERCIALIZACION	1
40329	OCUPACION	139009	DIRECTOR DE DEPARTAMENTO, VENTAS/ ORGANIZACION	1
40328	OCUPACION	139008	DIRECTOR DE DEPARTAMENTO, VENTAS	1
40327	OCUPACION	139007	DIRECTOR DE DEPARTAMENTO, INVESTIGACION Y DESARROLLO	1
40326	OCUPACION	139006	DIRECTOR DE DEPARTAMENTO, INFORMATICA	1
40325	OCUPACION	139005	DIRECTOR DE DEPARTAMENTO, DISTRIBUCION	1
40324	OCUPACION	139004	DIRECTOR DE DEPARTAMENTO, COMPRAS/ADQUISICION	1
40323	OCUPACION	139003	DIRECTOR DE DEPARTAMENTO, COMERCIALIZACION	1
40322	OCUPACION	139002	DIRECTOR DE DEPARTAMENTO, ALMACENAMIENTO	1
40321	OCUPACION	139001	DIRECTOR DE DEPARTAMENTO, ABASTECIMIENTO/SUMINISTRO	1
40320	OCUPACION	138005	DIRECTOR DE DEPARTAMENTO, RELACIONES PUBLICAS	1
40319	OCUPACION	138004	DIRECTOR DE DEPARTAMENTO, RELACIONES LABORALES	1
40318	OCUPACION	138003	DIRECTOR DE DEPARTAMENTO, RELACIONES INDUSTRIALES	1
40317	OCUPACION	138002	DIRECTOR DE DEPARTAMENTO, PUBLICIDAD	1
40316	OCUPACION	138001	DIRECTOR DE DEPARTAMENTO, PERSONAL	1
40315	OCUPACION	137006	GERENTE DE CREDITOS	1
40314	OCUPACION	137005	GERENTE DE ADMINISTRACION	1
40313	OCUPACION	137004	DIRECTOR DE DEPARTAMENTO, PRESUPUESTO	1
40312	OCUPACION	137003	DIRECTOR DE DEPARTAMENTO, FINANZAS/GERENTE	1
40311	OCUPACION	137002	DIRECTOR DE DEPARTAMENTO, CONTABILIDAD	1
40310	OCUPACION	137001	DIRECTOR DE DEPARTAMENTO, ADMINISTRACION	1
40309	OCUPACION	136013	VICE-RECTOR	1
40308	OCUPACION	136012	RECTOR	1
40307	OCUPACION	136011	DIRECTOR UNIVERSITARIO	1
40306	OCUPACION	136010	DIRECTOR DEPARTAMENTAL DE EDUCACION	1
40305	OCUPACION	136009	DIRECTOR DE UNIDAD DE GESTIÓN EDUCATIVA LOCAL O DIRECTOR DE UNIDAD DE SERVICIOS EDUCATIVOS	1
40304	OCUPACION	136008	DIRECTOR DE NUCLEOS EDUCATIVOS COMUNALES	1
40303	OCUPACION	136007	DIRECTOR DE INSTITUTO ACADEMICO	1
40302	OCUPACION	136006	DIRECTOR DE ESTUDIOS	1
40301	OCUPACION	136005	DIRECTOR DE ESEP/SENATI, ETC.	1
40300	OCUPACION	136004	DIRECTOR DE ESCUELA PROFESIONAL	1
40299	OCUPACION	136003	DIRECTOR DE INSTITUCIÓN EDUCATIVA O DIRECTOR DE CENTRO EDUCATIVO	1
40298	OCUPACION	136002	DECANO DE FACULTAD	1
40297	OCUPACION	136001	DECANO	1
40296	OCUPACION	135018	REGIDOR, TEATRO	1
40295	OCUPACION	135017	PRODUCTOR, TELEVISION	1
40294	OCUPACION	135016	PRODUCTOR, TEATRO	1
40293	OCUPACION	135015	PRODUCTOR, RADIO	1
40292	OCUPACION	135014	PRODUCTOR, CINE	1
40291	OCUPACION	135013	DIRECTOR, MUSICAL	1
40290	OCUPACION	135012	DIRECTOR TEATRAL	1
40289	OCUPACION	135011	DIRECTOR DE PLATO, CINE	1
40288	OCUPACION	135010	DIRECTOR DE DEPARTAMENTO, PRODUCCION Y OPERACIONES/TRABAJO	1
40287	OCUPACION	135009	DIRECTOR DE DEPARTAMENTO, PRODUCCION Y OPERACIONES/SERVICIO	1
40286	OCUPACION	135008	DIRECTOR DE DEPARTAMENTO, PRODUCCION Y OPERACIONES/SALUD	1
40285	OCUPACION	135007	DIRECTOR DE DEPARTAMENTO, PRODUCCION Y OPERACIONES/INSTITUC	1
40284	OCUPACION	135006	DIRECTOR DE DEPARTAMENTO, PRODUCCION Y OPERACIONES/ESPECTAC	1
1905	PAIS	380	ITALIA	1
40283	OCUPACION	135005	DIRECTOR DE DEPARTAMENTO, PRODUCCION Y OPERACIONES/AGENCIAS	1
40282	OCUPACION	135004	DIRECTOR DE DEPARTAMENTO, PRODUCCION Y OPERACIONES/ADMINIST	1
40281	OCUPACION	135003	DIRECTOR DE DEPARTAMENTO, PRODUCCION Y OPERACIONES/ACTIVIDADES RECREATIVAS	1
40280	OCUPACION	135002	DIRECTOR DE DEPARTAMENTO, PRODUCCION Y OPERACIONES/ACTIVIDADES DEPORTIVAS	1
40279	OCUPACION	135001	DIRECTOR DE DEPARTAMENTO, PRODUCCION Y OPERACIONES/ACTIVIDADES CULTURALES	1
40278	OCUPACION	134008	DIRECTOR DE DEPARTAMENTO, PRODUCCION Y OPERACIONES/TRANSPORTE PASAJEROS	1
40277	OCUPACION	134007	DIRECTOR DE DEPARTAMENTO, PRODUCCION Y OPERACIONES/TRANSPORTE MERCANCÍAS	1
40276	OCUPACION	134006	DIRECTOR DE DEPARTAMENTO, PRODUCCION Y OPERACIONES/TRANSPORTE GASODUCTOS Y OLEODUCTOS	1
40275	OCUPACION	134005	DIRECTOR DE DEPARTAMENTO, PRODUCCION Y OPERACIONES/TRANSPORTE	1
40274	OCUPACION	134004	DIRECTOR DE DEPARTAMENTO, PRODUCCION Y OPERACIONES/COMUNICACIONES TELECOMUNICACIONES	1
40273	OCUPACION	134003	DIRECTOR DE DEPARTAMENTO, PRODUCCION Y OPERACIONES/COMUNICACIONES CORREOS	1
40272	OCUPACION	134002	DIRECTOR DE DEPARTAMENTO, PRODUCCION Y OPERACIONES/COMUNICACIONES	1
40271	OCUPACION	134001	DIRECTOR DE DEPARTAMENTO, PRODUCCION Y OPERACIONES/ALMACENA	1
40270	OCUPACION	133002	DIRECTOR DE DEPARTAMENTO, PRODUCCION Y OPERACIONES/RESTAURA	1
40269	OCUPACION	133001	DIRECTOR DE DEPARTAMENTO, PRODUCCION Y OPERACIONES/HOTELES	1
40268	OCUPACION	132007	DIRECTOR DE DEPARTAMENTO, PRODUCCION Y OPERACIONES/REPARAC.	1
40267	OCUPACION	132006	DIRECTOR DE DEPARTAMENTO, PRODUCCION Y OPERACIONES/COMERCIO MINORISTA TIENDAS	1
40266	OCUPACION	132005	DIRECTOR DE DEPARTAMENTO, PRODUCCION Y OPERACIONES/COMERCIO MINORISTA SUPERMERCADOS	1
40265	OCUPACION	132004	DIRECTOR DE DEPARTAMENTO, PRODUCCION Y OPERACIONES/COMERCIO MINORISTA	1
40264	OCUPACION	132003	DIRECTOR DE DEPARTAMENTO, PRODUCCION Y OPERACIONES/COMERCIO MAYORISTA IMPORTACIÓN	1
40263	OCUPACION	132002	DIRECTOR DE DEPARTAMENTO, PRODUCCION Y OPERACIONES/COMERCIO MAYORISTA EXPORTACIÓN	1
40262	OCUPACION	132001	DIRECTOR DE DEPARTAMENTO, PRODUCCION Y OPERACIONES/COMERCIO MAYORISTA	1
40261	OCUPACION	131001	DIRECTOR DE DEPARTAMENTO, PRODUCCION Y OPERACIONES/CONSTRUC	1
40260	OCUPACION	129009	SUPERVISOR DE PRODUCCION	1
1926	PAIS	804	UCRANIA	1
40259	OCUPACION	129008	SUPER INTENDENTE DE PRODUCCION	1
40258	OCUPACION	129007	SUPER INTENDENTE DE PLANTA	1
40257	OCUPACION	129006	GERENTE INDUSTRIAL	1
40256	OCUPACION	129005	GERENTE DE PRODUCCION	1
40255	OCUPACION	129004	GERENTE DE PLANTA	1
40254	OCUPACION	129003	DIRECTOR DE EXPLOTACION DE MINAS Y CANTERAS	1
40253	OCUPACION	129001	DIRECTOR DE DEPARTAMENTO, PRODUCCION Y OPERACIONES/INDUSTRI	1
40252	OCUPACION	128003	DIRECTOR DE DEPARTAMENTO, PRODUCCION Y OPERACIONES/SILVICUL	1
40251	OCUPACION	128002	DIRECTOR DE DEPARTAMENTO, PRODUCCION Y OPERACIONES/PESCA	1
40250	OCUPACION	128001	DIRECTOR DE DEPARTAMENTO, PRODUCCION Y OPERACIONES/AGRICULT	1
40249	OCUPACION	127041	SUB DIRECTOR DE EMPRESA, SERVICIOS PUBLICOS Y FINANCIEROS	1
40248	OCUPACION	127040	PRESIDENTE DEL DIRECTORIO, SERVICIOS PUBLICOS Y FINANCIEROS	1
40247	OCUPACION	127039	MIEMBRO DEL DIRECTORIO, SERVICIOS PUBLICOS Y FINANCIEROS	1
40246	OCUPACION	127038	GERENTE GENERAL, ORGANIZACION/TRABAJO SOCIAL	1
40245	OCUPACION	127037	GERENTE GENERAL, ORGANIZACION/SERVICIO DE SANIDAD	1
40244	OCUPACION	127036	GERENTE GENERAL, ORGANIZACION/SERVICIO DE EMPRESA	1
40243	OCUPACION	127035	GERENTE GENERAL, ORGANIZACION/LIMPIEZA	1
40242	OCUPACION	127034	GERENTE GENERAL, ORGANIZACION/INTERMEDIACION FINANCIERA	1
40241	OCUPACION	127033	GERENTE GENERAL, ORGANIZACION/AGENCIA DE VIAJES	1
40240	OCUPACION	127032	GERENTE GENERAL, ORGANIZACION/ACTIVIDADES RECREATIVAS	1
40239	OCUPACION	127031	GERENTE GENERAL, ORGANIZACION/ACTIVIDADES DEPORTIVAS	1
40238	OCUPACION	127030	GERENTE GENERAL, ORGANIZACION/ACTIVIDADES CULTURALES	1
40237	OCUPACION	127029	GERENTE GENERAL, EMPRESA/TRABAJO SOCIAL	1
40236	OCUPACION	127028	GERENTE GENERAL, EMPRESA/SERVICIO DE SANIDAD	1
40235	OCUPACION	127027	GERENTE GENERAL, EMPRESA/SERVICIO DE EMPRESA	1
40234	OCUPACION	127026	GERENTE GENERAL, EMPRESA/LIMPIEZA	1
40233	OCUPACION	127025	GERENTE GENERAL, EMPRESA/INTERMEDIACION FINANCIERA	1
40232	OCUPACION	127024	GERENTE GENERAL, EMPRESA/AGENCIA DE VIAJES	1
40231	OCUPACION	127023	GERENTE GENERAL, EMPRESA/ACTIVIDADES RECREATIVAS	1
40230	OCUPACION	127022	GERENTE GENERAL, EMPRESA/ACTIVIDADES DEPORTIVAS	1
40229	OCUPACION	127021	GERENTE GENERAL, EMPRESA/ACTIVIDADES CULTURALES	1
40228	OCUPACION	127020	DIRECTOR GENERAL, ORGANIZACION/TRABAJO SOCIAL	1
40227	OCUPACION	127019	DIRECTOR GENERAL, ORGANIZACION/SERVICIO DE SANIDAD	1
40226	OCUPACION	127018	DIRECTOR GENERAL, ORGANIZACION/SERVICIO DE EMPRESA	1
40225	OCUPACION	127017	DIRECTOR GENERAL, ORGANIZACION/LIMPIEZA	1
40224	OCUPACION	127016	DIRECTOR GENERAL, ORGANIZACION/INTERMEDIACION FINANCIERA	1
40223	OCUPACION	127015	DIRECTOR GENERAL, ORGANIZACION/AGENCIA DE VIAJES	1
40222	OCUPACION	127014	DIRECTOR GENERAL, ORGANIZACION/ACTIVIDADES RECREATIVAS	1
40221	OCUPACION	127013	DIRECTOR GENERAL, ORGANIZACION/ACTIVIDADES DEPORTIVAS	1
40220	OCUPACION	127012	DIRECTOR GENERAL, ORGANIZACION/ACTIVIDADES CULTURALES	1
40219	OCUPACION	127011	DIRECTOR GENERAL, EMPRESA/TRABAJO SOCIAL	1
40218	OCUPACION	127010	DIRECTOR GENERAL, EMPRESA/SERVICIO DE SANIDAD	1
40217	OCUPACION	127009	DIRECTOR GENERAL, EMPRESA/SERVICIO DE EMPRESA	1
40216	OCUPACION	127008	DIRECTOR GENERAL, EMPRESA/LIMPIEZA	1
40215	OCUPACION	127007	DIRECTOR GENERAL, EMPRESA/INTERMEDIACION FINANCIERA	1
40214	OCUPACION	127006	DIRECTOR GENERAL, EMPRESA/AGENCIA DE VIAJES	1
40213	OCUPACION	127005	DIRECTOR GENERAL, EMPRESA/ACTIVIDADES RECREATIVAS	1
40212	OCUPACION	127004	DIRECTOR GENERAL, EMPRESA/ACTIVIDADES DEPORTIVAS	1
40211	OCUPACION	127003	DIRECTOR GENERAL, EMPRESA/ACTIVIDADES CULTURALES	1
40210	OCUPACION	127002	DIRECTOR EJECUTIVO, EMPRESA, DE SERVICIOS PUBLICOS Y FINANC	1
40209	OCUPACION	127001	DIRECTOR DE EMPRESAS, DE SERVICIOS PUBLICOS Y FINANCIEROS	1
40208	OCUPACION	126013	SUB DIRECTOR DE EMPRESA, TRANSPORTE, ALMACENAMIENTO Y COMUN	1
40207	OCUPACION	126012	PRESIDENTE DEL DIRECTORIO, TRANSPORTE, ALMACENAMIENTO Y COM	1
40206	OCUPACION	126011	MIEMBRO DEL DIRECTORIO, TRANSPORTE, ALMACENAMIENTO Y COMUNI	1
40205	OCUPACION	126010	GERENTE GENERAL, ORGANIZACION/TRANSPORTE	1
40204	OCUPACION	126009	GERENTE GENERAL, EMPRESA/TRANSPORTE	1
40203	OCUPACION	126008	GERENTE GENERAL, EMPRESA/COMUNICACIONES	1
40202	OCUPACION	126007	GERENTE GENERAL, EMPRESA/ALMACENAMIENTO	1
40201	OCUPACION	126006	DIRECTOR GENERAL, ORGANIZACION/TRANSPORTE	1
40200	OCUPACION	126005	DIRECTOR GENERAL, EMPRESA/TRANSPORTE	1
40199	OCUPACION	126004	DIRECTOR GENERAL, EMPRESA/COMUNICACIONES	1
40198	OCUPACION	126003	DIRECTOR GENERAL, EMPRESA/ALMACENAMIENTO	1
40197	OCUPACION	126002	DIRECTOR EJECUTIVO, EMPRESA, DE TRANSPORTE, ALMACENAMIENTO	1
40196	OCUPACION	126001	DIRECTOR DE EMPRESAS, DE TRANSPORTE, ALMACENAMIENTO Y COMUN	1
40195	OCUPACION	125013	SUB DIRECTOR DE EMPRESA, RESTAURANTES Y HOTELERIA	1
40194	OCUPACION	125012	PRESIDENTE DEL DIRECTORIO, RESTAURANTES Y HOTELERIA	1
40193	OCUPACION	125011	MIEMBRO DEL DIRECTORIO, RESTAURANTES Y HOTELERIA	1
40192	OCUPACION	125010	GERENTE GENERAL, ORGANIZACION/RESTAURANTES	1
40191	OCUPACION	125009	GERENTE GENERAL, ORGANIZACION/HOTELERIA	1
40190	OCUPACION	125008	GERENTE GENERAL, EMPRESA/RESTAURANTE	1
40189	OCUPACION	125007	GERENTE GENERAL, EMPRESA/HOTELERIA	1
40188	OCUPACION	125006	DIRECTOR GENERAL, ORGANIZACION/RESTAURANTE	1
40187	OCUPACION	125005	DIRECTOR GENERAL, ORGANIZACION/HOTELERIA	1
40186	OCUPACION	125004	DIRECTOR GENERAL, EMPRESA/RESTAURANTE	1
40185	OCUPACION	125003	DIRECTOR GENERAL, EMPRESA/HOTELERIA	1
40184	OCUPACION	125002	DIRECTOR EJECUTIVO, EMPRESA, DE RESTAURANTES Y HOTELERIA	1
40183	OCUPACION	125001	DIRECTOR DE EMPRESAS, DE RESTAURANTES Y HOTELERIA	1
40182	OCUPACION	124014	SUB DIRECTOR DE EMPRESA, COIMERCIO MAYORISTA Y MINORISTA, R	1
40181	OCUPACION	124013	PRESIDENTE DEL DIRECTORIO, COMERCIO MAYORISTA Y MINORISTA,	1
40180	OCUPACION	124012	MIEMBRO DEL DIRECTORIO, COMERCIO MAYORISTA Y MINORISTA, REP	1
40179	OCUPACION	124011	GERENTE ORGANIZACION, EMPRESA/COMERCIO MINORISTA	1
40178	OCUPACION	124010	GERENTE ORGANIZACION, EMPRESA/COMERCIO MAYORISTA	1
40177	OCUPACION	124009	GERENTE GENERAL, EMPRESA/COMERCIO MINORISTA	1
40176	OCUPACION	124008	GERENTE GENERAL, EMPRESA/COMERCIO MAYORISTA	1
40175	OCUPACION	124007	DIRECTOR GENERAL, REPARACION/VEHICULOS, AUTOMOTORES, ETC.	1
40174	OCUPACION	124006	DIRECTOR GENERAL, ORGANIZACION/COMERCIO MINORISTA	1
40173	OCUPACION	124005	DIRECTOR GENERAL, ORGANIZACION/COMERCIO MAYORISTA	1
40172	OCUPACION	124004	DIRECTOR GENERAL, EMPRESA/COMERCIO MINORISTA	1
40171	OCUPACION	124003	DIRECTOR GENERAL, EMPRESA/COMERCIO MAYORISTA	1
40170	OCUPACION	124002	DIRECTOR EJECUTIVO, EMPRESA, DE COMERCIO MAYORISTA Y MINORI	1
40169	OCUPACION	124001	DIRECTOR DE EMPRESAS, DE COMERCIO MAYORISTA Y MINORISTA, RE	1
40168	OCUPACION	123007	SUB DIRECTOR DE EMPRESA, CONSTRUCCION Y OBRAS PUBLICAS	1
40167	OCUPACION	123006	PRESIDENTE DEL DIRECTORIO, CONTRUCCION Y OBRAS PUBLICAS	1
40166	OCUPACION	123005	MIEMBRO DEL DIRECTORIO, CONSTRUCCION Y OBRAS PUBLICAS	1
40165	OCUPACION	123004	GERENTE GENERAL, EMPRESA/CONSTRUCCION Y OBRAS PUBLICAS	1
40164	OCUPACION	123003	DIRECTOR GENERAL, EMPRESA/CONSTRUCCION Y OBRAS PUBLICAS	1
40163	OCUPACION	123002	DIRECTOR EJECUTIVO, EMPRESA, DE CONSTRUCCION Y OBRAS PUBLIC	1
40162	OCUPACION	123001	DIRECTOR DE EMPRESAS, DE CONSTRUCCION Y OBRAS PUBLICAS	1
40161	OCUPACION	122009	SUB DIRECTOR DE EMPRESA, INDUSTRIAS MANUFACTURERAS, MINAS Y	1
40160	OCUPACION	122008	PRESIDENTE DEL DIRECTORIO, INDUSTRIAS MANUFACTURERAS, MINAS	1
40159	OCUPACION	122007	MIEMBRO DEL DIRECTORIO, INDUSTRIAS MANUFACTURERAS, MINAS Y	1
40158	OCUPACION	122006	GERENTE GENERAL, EMPRESA/SUMINISTRO DE ELECTRICIDAD, GAS Y	1
40157	OCUPACION	122005	GERENTE GENERAL, EMPRESA/INDUSTRIA MANUFACTURERA	1
40156	OCUPACION	122004	DIRECTOR GENERAL, EMPRESA/SUMINISTRO DE ELECTRICIDAD, GAS Y	1
40155	OCUPACION	122003	DIRECTOR GENERAL, EMPRESA/INDUSTRIA MANUFACTURERA	1
40154	OCUPACION	122002	DIRECTOR EJECUTIVO, EMPRESA, INDUSTRIA MANUFACTURERA, MINAS	1
40153	OCUPACION	122001	DIRECTOR DE EMPRESAS, DE INDUSTRIAS MANUFACTURERAS, MINAS Y	1
40152	OCUPACION	121021	SUB DIRECTOR DE EMPRESA, AGRICULTURA, CAZA, SILVICULTURA Y	1
40151	OCUPACION	121020	PRESIDENTE DEL DIRECTORIO, AGRICULTURA, CAZA, SILVICULTURA	1
40150	OCUPACION	121019	MIEMBRO DEL DIRECTORIO, CONSEJO ADMINISTRATIVO/COOP. AGRARI	1
40149	OCUPACION	121018	MIEMBRO DEL DIRECTORIO, ASESOR TECNICO/EXPLOTACION: AGRICOL	1
40148	OCUPACION	121017	GERENTE GENERAL, ORGANIZACION/SILVICULTURA	1
40147	OCUPACION	121016	GERENTE GENERAL, ORGANIZACION/PESCA	1
40146	OCUPACION	121015	GERENTE GENERAL, ORGANIZACION/CAZA	1
40145	OCUPACION	121014	GERENTE GENERAL, EMPRESA/SILVICULTURA	1
40144	OCUPACION	121013	GERENTE GENERAL, EMPRESA/PESCA	1
40143	OCUPACION	121012	GERENTE GENERAL, EMPRESA/CAZA	1
40142	OCUPACION	121011	GERENTE GENERAL, EMPRESA/AGRICULTURA	1
40141	OCUPACION	121010	DIRECTOR GENERAL, ORGANIZACION/SILVICULTURA	1
40140	OCUPACION	121009	DIRECTOR GENERAL, ORGANIZACION/PESCA	1
40139	OCUPACION	121008	DIRECTOR GENERAL, ORGANIZACION/ CAZA	1
40138	OCUPACION	121007	DIRECTOR GENERAL, EMPRESA/SILVICULTURA	1
40137	OCUPACION	121006	DIRECTOR GENERAL, EMPRESA/PESCA	1
40136	OCUPACION	121005	DIRECTOR GENERAL, EMPRESA/EXPLOTACION: AGRICOLA, FORESTAL Y	1
40135	OCUPACION	121004	DIRECTOR GENERAL, EMPRESA/CAZA	1
40134	OCUPACION	121003	DIRECTOR GENERAL, EMPRESA/AGRICULTURA	1
40133	OCUPACION	121002	DIRECTOR EJECUTIVO, EMPRESA, AGRICULTURA, CAZA, SILVICULTUR	1
40132	OCUPACION	121001	DIRECTOR DE EMPRESAS, DE AGRICULTURA, CAZA, SILVICULTURA Y	1
40131	OCUPACION	116003	SECRETARIO GENERAL, ORGANIZACION DE PROTECCION DEL MEDIO AM	1
40130	OCUPACION	116002	SECRETARIO GENERAL, ORGANIZACION DE PROTECCION DE LA FAUNA	1
40129	OCUPACION	116001	DIRIGENTE, ORGANIZACION ESPECIALIZADA	1
40128	OCUPACION	115004	SECRETARIO GENERAL, SINDICATO DE TRABAJADORES	1
40127	OCUPACION	115003	SECRETARIO GENERAL, ORGANIZACION DE EMPLEADORES	1
40126	OCUPACION	115002	DIRIGENTE, SINDICATO DE TRABAJADORES	1
40125	OCUPACION	115001	DIRIGENTE, ORGANIZACION DE EMPLEADORES	1
40124	OCUPACION	114003	SECRETARIO, PARTIDO POLITICO	1
40123	OCUPACION	114002	SECRETARIO GENERAL, PARTIDO POLITICO	1
40122	OCUPACION	114001	DIRIGENTE, PARTIDO POLITICO	1
40121	OCUPACION	113002	JEFE TRADICIONAL, PEQUEÐA POBLACION	1
40120	OCUPACION	113001	JEFE DE PUEBLO	1
40119	OCUPACION	112021	SUB DIRECTOR DE LA ADMINISTRACION PUBLICA	1
40118	OCUPACION	112020	SECRETARIO GENERAL, ADMINISTRACION PUBLICA	1
40117	OCUPACION	112019	SECRETARIO GENERAL ADJUNTO, ADMINISTRACION PUBLICA	1
40116	OCUPACION	112018	SECRETARIO DE EMBAJADA	1
40115	OCUPACION	112017	PAGADOR GENERAL, ADMINISTRACION PUBLICA	1
40114	OCUPACION	112016	JEFE DE ORGANISMO PUBLICO	1
40113	OCUPACION	112015	INTERVENTOR GENERAL DE ECONOMIA DE LA ADMINISTRACION PÚBLICA	1
40112	OCUPACION	112014	INTENDENTE GENERAL DE LA ADMINISTRACION PUBLICA	1
40111	OCUPACION	112013	ENCARGADO DE NEGOCIOS, EMBAJADA	1
40110	OCUPACION	112012	DIRECTOR GENERAL, CANCILLERIA	1
40109	OCUPACION	112011	DIRECTOR GENERAL, ADMINISTRACION PUBLICA/REGION	1
40108	OCUPACION	112010	DIRECTOR GENERAL, ADMINISTRACION PUBLICA/MINISTERIO	1
40107	OCUPACION	112009	DIRECTOR GENERAL, ADMINISTRACION PUBLICA	1
40106	OCUPACION	112008	DIRECTOR GENERAL, ADMINISTRACION PENITENCIARIA	1
40105	OCUPACION	112007	DIRECTOR GENERAL, ADMINISTRACION DE CORREOS	1
40104	OCUPACION	112006	DIRECTOR EJECUTIVO DE LA ADMINISTRACION PUBLICA	1
40103	OCUPACION	112005	DIRECTOR DE LA ADMINISTRACION PUBLICA	1
40102	OCUPACION	112004	DIRECTOR	1
40101	OCUPACION	112003	AUDITOR GENERAL, ADMINISTRACION PUBLICA	1
40100	OCUPACION	112002	ALCALDE	1
40099	OCUPACION	112001	ADMINISTRADOR, ADMINISTRACION PUBLICA	1
40098	OCUPACION	111027	VICE-PRESIDENTE DEL CONGRESO CONSTITUYENTE DEMOCRATICO (CCD	1
40097	OCUPACION	111026	VICE-PRESIDENTE DE LA REPUBLICA	1
40096	OCUPACION	111025	VICE-MINISTRO (DIRECTOR SUPERIOR)	1
40095	OCUPACION	111024	SUB-PREFECTO	1
40094	OCUPACION	111023	SENADOR	1
40093	OCUPACION	111022	SECRETARIO DE ESTADO	1
40092	OCUPACION	111021	PROCURADOR GENERAL	1
40091	OCUPACION	111020	PRIMER MINISTRO	1
40090	OCUPACION	111019	PRESIDENTE DE LA CORTE SUPREMA	1
40089	OCUPACION	111018	PRESIDENTE, CONGRESO CONSTITUYENTE DEMOCRATICO (CCD)	1
40088	OCUPACION	111017	PRESIDENTE, CAMARA DE SENADORES	1
40087	OCUPACION	111016	PRESIDENTE, CAMARA DE DIPUTADOS	1
40086	OCUPACION	111015	PRESIDENTE DE LA REPUBLICA	1
40085	OCUPACION	111014	PREFECTO	1
40084	OCUPACION	111013	MINISTRO PLENIPOTENCIARIO	1
40083	OCUPACION	111012	MINISTRO, DE ESTADO	1
40082	OCUPACION	111011	LEGISLADOR	1
40081	OCUPACION	111010	JEFE DE ORGANISMO DE DESARROLLO	1
40080	OCUPACION	111009	PRESIDENTE DE GOBIERNO REGIONAL	1
40079	OCUPACION	111008	FISCAL DE LA NACION	1
40078	OCUPACION	111007	EMBAJADORES EN FUNCION (PERUANOS)	1
40077	OCUPACION	111006	DIPUTADO	1
40076	OCUPACION	111005	CONTRALOR GENERAL	1
40075	OCUPACION	111004	CONSULES EN FUNCION (PERUANOS)	1
40074	OCUPACION	111003	CONSEJERO, GOBIERNO	1
40073	OCUPACION	111002	CONGRESISTA	1
40072	OCUPACION	111001	CANCILLER	1
40071	OCUPACION	024001	POLICIA NO ESPECIFICADO	1
40070	OCUPACION	023001	POLICIA NACIONAL, SUB OFICIALES	1
40069	OCUPACION	022001	POLICIA NACIONAL, TECNICOS	1
40068	OCUPACION	021001	POLICIA NACIONAL, OFICIALES	1
40067	OCUPACION	015001	MILITAR NO ESPECIFICADO	1
40066	OCUPACION	014003	AVIACION, PERSONAL DE SERVICIO MILITAR	1
40065	OCUPACION	014002	EJERCITO, PERSONAL DE SERVICIO MILITAR	1
40064	OCUPACION	014001	MARINA, PERSONAL DE SERVICIO MILITAR	1
40063	OCUPACION	013003	AVIACION, SUB OFICIALES	1
40062	OCUPACION	013002	EJERCITO, SUB OFICIALES	1
40061	OCUPACION	013001	MARINA, SUB OFICIALES	1
40060	OCUPACION	012003	AVIACION, TECNICOS	1
40059	OCUPACION	012002	EJERCITO, TECNICOS	1
40058	OCUPACION	012001	MARINA, TECNICOS	1
40057	OCUPACION	011003	AVIACION, OFICIAL	1
40056	OCUPACION	011002	EJERCITO,OFICIALES	1
40055	OCUPACION	011001	MARINA, OFICIALES	1
44853	MOTIVO-BAJA-PERSONAL	20	INHABILITACIÓN PARA EL EJERCICIO PROFESIONAL O DE LA FUNCIÓN PÚBLICA POR MÁS DE TRES MESES - LEY 30057	1
44852	MOTIVO-BAJA-PERSONAL	19	OTRAS CAUSALES RÉGIMEN PÚBLICO GENERAL SERVICIO CIVIL - LEY 30057	1
44851	MOTIVO-BAJA-PERSONAL	18	LÍMITE DE EDAD 70 AÑOS	1
44928	PRESTADOR-SERVICIOS	31	TRABAJADOR DE LA INDUSTRIA DE CUERO	0
44850	MOTIVO-BAJA-PERSONAL	17	NO SE INICIÓ LA RELACIÓN LABORAL O PRESTACIÓN EFECTIVA DE SERVICIOS	1
44849	MOTIVO-BAJA-PERSONAL	16	OTROS MOTIVOS DE CADUCIDAD DE LA PENSIÓN (1)	1
44848	MOTIVO-BAJA-PERSONAL	15	EXTINCIÓN O LIQUIDACIÓN DEL EMPLEADOR	1
44847	MOTIVO-BAJA-PERSONAL	14	BAJA POR SUCESIÓN EN POSICIÓN DEL EMPLEADOR	1
44846	MOTIVO-BAJA-PERSONAL	13	TRANSFERENCIA SERVIDOR DE LA ADMINISTRACIÓN PÚBLICA (2)	1
44833	COND-LABORAL	99	OTROS NO PREVISTOS	1
44845	MOTIVO-BAJA-PERSONAL	12	PERMUTA SERVIDOR DE LA ADMINISTRACIÓN PÚBLICA (2)	1
44844	MOTIVO-BAJA-PERSONAL	11	REASIGNACIÓN SERVIDOR DE LA ADMINISTRACIÓN PÚBLICA(2)	1
44843	MOTIVO-BAJA-PERSONAL	10	SUSPENSIÓN DE LA PENSIÓN (1)	1
44842	MOTIVO-BAJA-PERSONAL	09	FALLECIMIENTO	1
44841	MOTIVO-BAJA-PERSONAL	08	MUTUO DISENSO	1
44840	MOTIVO-BAJA-PERSONAL	07	TERMINACIÓN DE LA OBRA O SERVICIO, CUMPLIMIENTO CONDICIÓN RESOLUTORIA O VENCIMIENTO DEL PLAZO	1
44839	MOTIVO-BAJA-PERSONAL	06	INVALIDEZ ABSOLUTA PERMANENTE	1
44838	MOTIVO-BAJA-PERSONAL	05	JUBILACIÓN	1
44837	MOTIVO-BAJA-PERSONAL	04	CESE COLECTIVO	1
44836	MOTIVO-BAJA-PERSONAL	03	DESPIDO O DESTITUCIÓN	1
44835	MOTIVO-BAJA-PERSONAL	02	RENUNCIA CON INCENTIVOS	1
44834	MOTIVO-BAJA-PERSONAL	01	RENUNCIA	1
44861	MOD-FORMATIVA	10	SECIGRISTA (1)	1
44860	MOD-FORMATIVA	7	ACTUALIZACIÓN PARA LA REINSERCIÓN LABORAL	1
44859	MOD-FORMATIVA	6	PASANTÍA DE DOCENTES Y CATEDRÁTICOS	1
44858	MOD-FORMATIVA	5	PASANTÍA EN LA EMPRESA	1
44857	MOD-FORMATIVA	4	CAPACITACIÓN LABORAL JUVENIL	1
44856	MOD-FORMATIVA	3	PRÁCTICAS PROFESIONALES	1
44855	MOD-FORMATIVA	2	APRENDIZAJE CON PREDOMINIO EN EL CFP - PRÁCTICAS PRE PROFESIONALES	1
44854	MOD-FORMATIVA	1	APRENDIZAJE CON PREDOMINIO EN LA EMPRESA	1
44869	MOTIVO-BAJA-HABIENTE	09	DERECHOHABIENTE ADQUIERE CONDICIÓN DE ASEGURADO REGULAR	1
44868	MOTIVO-BAJA-HABIENTE	08	ERROR EN EL REGISTRO	1
44867	MOTIVO-BAJA-HABIENTE	07	HIJO ADQUIERE MAYORÍA DE EDAD	1
44866	MOTIVO-BAJA-HABIENTE	06	FIN DE LA GESTACIÓN	1
44865	MOTIVO-BAJA-HABIENTE	05	FIN DE CONCUBINATO	1
44864	MOTIVO-BAJA-HABIENTE	04	DIVORCIO O DISOLUCIÓN DE VÍNCULO MATRIMONIAL	1
44863	MOTIVO-BAJA-HABIENTE	03	OTROS MOTIVOS NO PREVISTOS	1
44862	MOTIVO-BAJA-HABIENTE	02	FALLECIMIENTO	1
44895	TIPO-SUSPENSION-LAB	33	S.I. ASUMIR REPRESENTACIÓN OFICIAL DEL ESTADO PERUANO EN EVENTOS CIENTÍFICOS, EDUCATIVOS, CULTURALES Y DEPORTIVOS	1
44894	TIPO-SUSPENSION-LAB	32	S.I. FALLECIMIENTO DE PADRES, CÓNYUGE O HIJOS	1
44893	TIPO-SUSPENSION-LAB	31	S.I. CITACIÓN EXPRESA JUDICIAL, MILITAR, POLICIAL U OTRAS CITACIONES DERIVADAS DE ACTOS DE ADMINISTRACIÓN INTERNA	1
44892	TIPO-SUSPENSION-LAB	30	S.I. IMPOSICIÓN DE MEDIDA CAUTELAR	1
44891	TIPO-SUSPENSION-LAB	29	S.I. DIAS LICENCIA POR ADOPCIÓN 	1
44890	TIPO-SUSPENSION-LAB	28	S.I. DÍAS LICENCIA POR PATERNIDAD	1
44889	TIPO-SUSPENSION-LAB	27	S.I. DÍAS COMPENSADOS POR HORAS TRABAJADAS EN SOBRETIEMPO	1
44888	TIPO-SUSPENSION-LAB	26	S.I. LICENCIA U OTROS MOTIVOS CON GOCE DE HABER	1
44887	TIPO-SUSPENSION-LAB	25	S.I. PERMISO Y LICENCIA PARA EL DESEMPEÑO DE CARGOS SINDICALES	1
44886	TIPO-SUSPENSION-LAB	24	S.I. LICENCIA PARA DESEMPEÑAR CARGO CÍVICO Y PARA CUMPLIR CON EL SERVICIO MILITAR OBLIGATORIO	1
44885	TIPO-SUSPENSION-LAB	23	S.I. DESCANSO VACACIONAL	1
44884	TIPO-SUSPENSION-LAB	22	S.I. MATERNIDAD DURANTE EL DESCANSO PRE Y POST NATAL	1
44883	TIPO-SUSPENSION-LAB	21	S.I. INCAPACIDAD TEMPORAL (INVALIDEZ, ENFERMEDAD Y ACCIDENTES)	1
44882	TIPO-SUSPENSION-LAB	20	S.I. ENFERMEDAD O ACCIDENTE (PRIMEROS VEINTE DÍAS)	1
44881	TIPO-SUSPENSION-LAB	12	S.P. ENFERMEDAD GRAVE DEL PADRE, CÓNYUGE, CONVIVIENTE RECONOCIDO JUDICIALMENTE O HIJOS.	1
44880	TIPO-SUSPENSION-LAB	11	S.P. IMPOSICIÓN DE MEDIDA CAUTELAR.	1
44879	TIPO-SUSPENSION-LAB	10	S.P. SENTENCIA DE PRIMERA INSTANCIA POR DELITOS DE TERRORISMO, NARCOTRÁFICO, CORRUPCIÓN O VIOLACIÓN DE LA LIBERTAD SEXUAL.	1
44878	TIPO-SUSPENSION-LAB	9	S.P. MATERNIDAD DURANTE EL DESCANSO PRE Y POST NATAL	1
44877	TIPO-SUSPENSION-LAB	8	S.P. POR TEMPORADA O INTERMITENTE	1
44876	TIPO-SUSPENSION-LAB	7	S.P. FALTA NO JUSTIFICADA	1
44875	TIPO-SUSPENSION-LAB	6	S.P. CASO FORTUITO O FUERZA MAYOR	1
44874	TIPO-SUSPENSION-LAB	5	S.P. PERMISO, LICENCIA U OTROS MOTIVOS SIN GOCE DE HABER	1
44873	TIPO-SUSPENSION-LAB	4	S.P. INHABILITACIÓN ADMINISTRATIVA, JUDICIAL  O PENA PRIVATIVA DE LA LIBERTAD EFECTIVA POR DELITO CULPOSO, POR PERIODO NO SUPERIOR A TRES MESES	1
44872	TIPO-SUSPENSION-LAB	3	S.P. DETENCIÓN DEL TRABAJADOR, SALVO EL CASO DE CONDENA PRIVATIVA DE LA LIBERTAD	1
44871	TIPO-SUSPENSION-LAB	2	S.P. EJERCICIO DEL DERECHO DE HUELGA	1
44870	TIPO-SUSPENSION-LAB	1	S.P. SANCIÓN DISCIPLINARIA	1
44906	DOC-SUS-VINCULO-FAM	11	DECLARACIÓN JURADA EXISTENCIA DE  UNIÓN DE HECHO	1
44905	DOC-SUS-VINCULO-FAM	10	ACTA DE NACIMIENTO O DOCUMENTO ANALOGO QUE SUSTENTA FILIACIÓN.	1
44904	DOC-SUS-VINCULO-FAM	09	RESOLUCIÓN JUDICIAL - RECONOC. DE UNIÓN DE HECHO	1
44903	DOC-SUS-VINCULO-FAM	08	ESCRITURA PÚBLICA - RECONOC. DE UNIÓN DE HECHO - LEY N.° 29560	1
44902	DOC-SUS-VINCULO-FAM	07	ACTA O PARTIDA DE MATRIMONIO REALIZADO EN EL EXTERIOR E INSCRITO EN RENIEC O MUNICIPALIDAD. 	1
1927	PAIS	336	VATICANO	1
44901	DOC-SUS-VINCULO-FAM	06	ACTA O PARTIDA DE MATRIMONIO INSCRITO EN REG CONSULAR PERUANO.	1
44900	DOC-SUS-VINCULO-FAM	05	ACTA O PARTIDA DE MATRIMONIO CIVIL	1
44899	DOC-SUS-VINCULO-FAM	04	RESOLUCIÓN DE INCAPACIDAD	1
44898	DOC-SUS-VINCULO-FAM	03	TESTAMENTO	1
44897	DOC-SUS-VINCULO-FAM	02	SENTENCIA DE DECLARATORIA DE PATERNIDAD	1
44896	DOC-SUS-VINCULO-FAM	01	ESCRITURA PÚBLICA	1
44915	SITUACION-ESPECIAL	8	TELETRABAJO COMPLETO	1
44914	SITUACION-ESPECIAL	7	TELETRABAJO MIXTO	1
44913	SITUACION-ESPECIAL	6	TRABAJADOR DE CONFIANZA - TELETRABAJO COMPLETO	1
44912	SITUACION-ESPECIAL	5	TRABAJADOR DE DIRECCIÓN - TELETRABAJO COMPLETO	1
44911	SITUACION-ESPECIAL	4	TRABAJADOR DE CONFIANZA - TELETRABAJO MIXTO	1
44910	SITUACION-ESPECIAL	3	TRABAJADOR DE DIRECCIÓN - TELETRABAJO MIXTO	1
44909	SITUACION-ESPECIAL	2	TRABAJADOR DE CONFIANZA - PRESENCIAL	1
44908	SITUACION-ESPECIAL	1	TRABAJADOR DE DIRECCIÓN – PRESENCIAL	1
44907	SITUACION-ESPECIAL	0	NINGUNA	1
44956	PRESTADOR-SERVICIOS	98	PERSONA QUE GENERA INGRESOS DE CUARTA - QUINTA CATEGORÍA	1
44955	PRESTADOR-SERVICIOS	96	MAGISTERIO - LEY 29944	1
44954	PRESTADOR-SERVICIOS	95	SERVIDOR DE ACTIVIDADES COMPLEMENTARIAS - LEY 30057	1
44953	PRESTADOR-SERVICIOS	94	SERVIDOR CIVIL DE CARRERA - LEY 30057	1
44952	PRESTADOR-SERVICIOS	93	DIRECTIVO PÚBLICO - LEY 30057	1
44951	PRESTADOR-SERVICIOS	92	FUNCIONARIO PUBLICO - LEY 30057	1
44950	PRESTADOR-SERVICIOS	91	MIIEMBROS DE OTROS REG. ESPECIALES DEL SECTOR PÚBLICO	1
44949	PRESTADOR-SERVICIOS	90	GERENTES PÚBLICOS  - D. LEG. 1024	1
44948	PRESTADOR-SERVICIOS	89	PERSONAL DE LAS FUERZAS ARMADAS Y POLICIALES (1)	1
44947	PRESTADOR-SERVICIOS	88	PERSONAL DE LA ADMIN. PÚBLICA - ASIGNACIÓN ESPECIAL - D.U. 126-2001	1
44946	PRESTADOR-SERVICIOS	87	SERVIDOR PÚBLICO - DE APOYO	1
44945	PRESTADOR-SERVICIOS	86	SERVIDOR PÚBLICO - ESPECIALISTA	1
44944	PRESTADOR-SERVICIOS	85	SERVIDOR PÚBLICO - EJECUTIVO	1
44943	PRESTADOR-SERVICIOS	84	SERVIDOR PÚBLICO - DIRECTIVO  SUPERIOR	1
44942	PRESTADOR-SERVICIOS	83	EMPLEADO DE CONFIANZA	1
44941	PRESTADOR-SERVICIOS	82	FUNCIONARIO PÚBLICO	1
44940	PRESTADOR-SERVICIOS	73	SOCIO DE COOPERATIVA AGRARIA – LEY N.° 29972	0
44939	PRESTADOR-SERVICIOS	71	CONDUCTOR DE MICROEMPRESA REMYPE - D.LEG.1086	0
44938	PRESTADOR-SERVICIOS	67	REGIMEN  ESPECIAL D. LEG.1057 - CAS	1
44937	PRESTADOR-SERVICIOS	66	PESCADOR Y PROCESADOR ARTESANAL INDEPENDIENTE  - LEY 27177 	0
44936	PRESTADOR-SERVICIOS	65	TRABAJADOR ACTIVIDAD ACUÍCOLA - LEY 27460	1
44935	PRESTADOR-SERVICIOS	64	AGRARIO DEPENDIENTE - LEY 27360	1
44934	PRESTADOR-SERVICIOS	56	ARTISTA -  LEY 28131	0
44933	PRESTADOR-SERVICIOS	39	TRABAJADOR PESQUERO – LEY 30003	0
44932	PRESTADOR-SERVICIOS	38	MINERO DE INDUSTRIA MINERA METALÚRGICA Y/O SIDERÚRGICA	0
44931	PRESTADOR-SERVICIOS	37	MINERO DE TAJO ABIERTO	0
44930	PRESTADOR-SERVICIOS	36	TRABAJADOR PESQUERO 	0
44929	PRESTADOR-SERVICIOS	32	MINERO DE MINA DE SOCAVÓN	0
20484	BANCO	206	CAJA RURAL DE AHORRO Y CREDITO RAIZ S.A.A. CRAC RAIZ S.A.A.	1
1760	BANCO	214	FINANCIERA EFECTIVA S.A.	1
44927	PRESTADOR-SERVICIOS	30	PERIODISTA	0
44926	PRESTADOR-SERVICIOS	29	MARÍTIMO, FLUVIAL O LACUSTRE	0
44925	PRESTADOR-SERVICIOS	28	PILOTO Y COPILOTO DE AVIACIÓN COMERCIAL	0
44924	PRESTADOR-SERVICIOS	27	CONSTRUCCIÓN CIVIL	1
44923	PRESTADOR-SERVICIOS	26	PENSIONISTA - LEY 28320	0
44922	PRESTADOR-SERVICIOS	25	BENEFICIARIO DE TRANSF DIRECTA EX PESCADPRES	1
44921	PRESTADOR-SERVICIOS	24	PENSIONISTA O CESANTE	1
44920	PRESTADOR-SERVICIOS	23	PRACTICANTE SENATI - DEC. LEY 20151	0
44919	PRESTADOR-SERVICIOS	22	TRABAJADOR PORTUARIO - LEY 27866	0
44918	PRESTADOR-SERVICIOS	21	EMPLEADO	0
44917	PRESTADOR-SERVICIOS	20	OBRERO	1
44916	PRESTADOR-SERVICIOS	19	EJECUTIVO	0
44981	REGIMEN-SALUD	21	SIS – MICROEMPRESA(2)	1
44980	REGIMEN-SALUD	20	SANIDAD DE FFAA Y POLICIALES (1)	1
44979	REGIMEN-SALUD	05	ESSALUD PENSIONISTAS	1
44978	REGIMEN-SALUD	04	ESSALUD AGRARIO/ACUÍCOLA	1
44977	REGIMEN-SALUD	03	ESSALUD TRABAJADORES PESQUEROS Y EPS(SERV.PROPIOS)	1
1929	PAIS	032	ARGENTINA	1
44976	REGIMEN-SALUD	02	ESSALUD TRABAJADORES PESQUEROS	1
44975	REGIMEN-SALUD	01	ESSALUD REGULAR Y EPS/SERV. PROPIOS	1
44974	REGIMEN-SALUD	00	ESSALUD REGULAR (Exclusivamente)	1
44986	CONV-TRIBUTACION	4	BRASIL	1
44985	CONV-TRIBUTACION	3	CAN 	1
44984	CONV-TRIBUTACION	2	CHILE	1
44983	CONV-TRIBUTACION	1	CANADA	1
44982	CONV-TRIBUTACION	0	NINGUNO	1
45012	REG-LABORAL	99	OTROS NO PREVISTOS	1
45011	REG-LABORAL	25	SERVIDORES PENITENCIARIOS - LEY 29709	1
45010	REG-LABORAL	24	POLICÍA NACIONAL DEL PERÚ - D.LEG.1149	1
45009	REG-LABORAL	23	MAGISTERIO - LEY 29944	1
45008	REG-LABORAL	22	PÚBLICO GENERAL SERVICIO CIVIL - LEY 30057	1
45007	REG-LABORAL	21	CONSTRUCCION CIVIL	1
45006	REG-LABORAL	20	MINEROS	1
45005	REG-LABORAL	19	EXPORTACION NO TRADICIONAL D. LEY 22342	1
45004	REG-LABORAL	18	AGRARIO LEY 27360	1
45003	REG-LABORAL	17	PEQUEÑA EMPRESA D. LEG. 1086 (1)	0
45002	REG-LABORAL	16	MICROEMPRESA D. LEG. 1086 (1)	0
45001	REG-LABORAL	15	CONTRATO ADMINISTRATIVO DE SERVICIOS - D.LEG. N.° 1057	1
45000	REG-LABORAL	14	ESPECIAL GER. PÚBLICOS DECRETO LEGISLATIVO N.° 1024 (2)	1
44999	REG-LABORAL	13	POLICIA NACIONAL DEL PERÚ - LEY N.° 27238	1
44998	REG-LABORAL	12	MILITARES	1
44997	REG-LABORAL	11	SERVICIO DIPLOMÁTICO DE LA REPÚBLICA - LEY N.° 28091	1
44996	REG-LABORAL	10	FISCALES - D. LEG.  N.° 052	1
44995	REG-LABORAL	09	JUECES - CARRERA JUDICIAL - LEY N.° 29277	1
44994	REG-LABORAL	08	SERUM - LEY N.° 23330	1
44993	REG-LABORAL	07	TECNICOS Y AUXILIARES ASIST. DE LA SALUD - LEY N.° 28561	1
44992	REG-LABORAL	06	PROFESIONALES DE LA SALUD LEY N.° 23536	1
44991	REG-LABORAL	05	DOCENTES UNIVERSITARIOS - LEY N.° 23733	1
44990	REG-LABORAL	04	MAGISTERIO - LEY N.° 29062	1
44989	REG-LABORAL	03	PROFESORADO - LEY N.° 24029	1
44988	REG-LABORAL	02	PÚBLICO GENERAL - DECRETO LEGISLATIVO N.° 276	1
44987	REG-LABORAL	01	PRIVADO GENERAL -DECRETO LEGISLATIVO N.° 728	1
2309	SUB-TIPO-CONCEPTO	RI	REINTEGRO	1
2303	SUB-TIPO-CONCEPTO	DJ	DESCUENTO JUDICIAL	1
378	BANCO	003	INTERBANK	1
372	BANCO	007	CITIBANK DEL PERU S.A.	0
2304	SUB-TIPO-CONCEPTO	ED	EN DINERO	1
2305	SUB-TIPO-CONCEPTO	EE	EN ESPECIES	1
2306	SUB-TIPO-CONCEPTO	OC	OCASIONAL	1
2407	PERSONAL-ESTADO	6	AMC	1
2406	PERSONAL-ESTADO	7	CAS	1
2405	PERSONAL-ESTADO	5	CONTRATO PERSONAL	1
2404	PERSONAL-ESTADO	0	SIN ESTADO	1
2403	PERSONAL-ESTADO	4	SNP	1
2402	PERSONAL-ESTADO	3	CESANTE	1
44832	COND-LABORAL	25	CONTRATADO - CARRERAS ESPECIALES DEL SECTOR PÚBLICO 	1
44831	COND-LABORAL	24	NOMBRADO - CARRERAS ESPECIALES DEL SECTOR PÚBLICO	1
44830	COND-LABORAL	23	A PLAZO FIJO - LEY 30057	1
44829	COND-LABORAL	22	A PLAZO INDETERMINADO - LEY 30057	1
1930	PAIS	044	BAHAMAS	1
44828	COND-LABORAL	21	MIGRANTE ANDINO DECISIÓN 545	1
44827	COND-LABORAL	20	AGRARIO - LEY 27360	1
44826	COND-LABORAL	19	FUTBOLISTAS PROFESIONALES	1
44825	COND-LABORAL	18	A DOMICILIO	1
44824	COND-LABORAL	17	GERENTE PÚBLICO - D.LEG. 1024 (1)	1
44823	COND-LABORAL	16	SERVICIOS PERSONALES  - APLICABLES A LOS REGÍM. DE CARRERA (1)	1
44822	COND-LABORAL	15	NOMBRADO - D.LEG. N.° 276 (1)	1
44821	COND-LABORAL	14	ADMINISTRATIVO DE SERVICIOS - D.LEG 1057 (1)	1
44820	COND-LABORAL	13	DE EXTRANJERO - D.LEG.689	1
44819	COND-LABORAL	12	DE EXPORTACIÓN NO TRADICIONAL D.LEY 22342	1
44818	COND-LABORAL	11	DE TEMPORADA	1
44817	COND-LABORAL	10	INTERMITENTE	1
44816	COND-LABORAL	09	PARA OBRA DETERMINADA O SERVICIO ESPECÍFICO	1
44815	COND-LABORAL	08	DE EMERGENCIA	1
44814	COND-LABORAL	07	DE SUPLENCIA	1
44813	COND-LABORAL	06	OCASIONAL	1
2079	DOC-IDENTIDAD	07	PASAPORTE	1
115	DOC-IDENTIDAD	04	CARNET DE EXTRANJERIA	1
44812	COND-LABORAL	05	POR RECONVERSIÓN EMPRESARIAL	1
44811	COND-LABORAL	04	POR NECESIDADES DEL MERCADO	1
44810	COND-LABORAL	03	POR INICIO O INCREMENTO DE ACTIVIDAD	1
44809	COND-LABORAL	02	A TIEMPO PARCIAL	1
44808	COND-LABORAL	01	A PLAZO INDETERMINADO - D.LEG. 728	1
386	BANCO	009	SCOTIABANK PERU S.A.A.	0
365	BANCO	803	CAJA MUNICIPAL DE AHORRO Y CREDITO AREQUIPA	1
354	BANCO	002	BANCO DE CREDITO DEL PERU (BCP)	1
44958	REGIMEN-PENSION	03	DECRETO LEY 20530 	1
44973	REGIMEN-PENSION	99	SIN REGIMEN PENSIONARIO/NO APLICA	1
44972	REGIMEN-PENSION	98	PENDIENTE DE ELECCIÓN DE REGIMEN PENSIONARIO	0
44971	REGIMEN-PENSION	25	SPP HABITAT	1
44970	REGIMEN-PENSION	24	SPP PRIMA	1
44969	REGIMEN-PENSION	23	SPP PROFUTURO	1
44968	REGIMEN-PENSION	22	SPP HORIZONTE	1
44967	REGIMEN-PENSION	21	SPP INTEGRA	1
44966	REGIMEN-PENSION	16	LEY 30003 TRANSFERENCIA DIRECTA EX PESC	1
44965	REGIMEN-PENSION	15	LEY 30003 - RÉGIMEN ESPECIAL DE PENSIONES -PESQUEROS	0
44964	REGIMEN-PENSION	14	LEY 29903 - SISTEMA NACIONAL DE PENSIONES -INDEPENDIENTES	1
44963	REGIMEN-PENSION	13	RÉGIMEN DEL SERVICIO DIPLOMÁTICO DE LA REPÚBLICA 	1
44962	REGIMEN-PENSION	12	OTROS REGIMENES PENSIONARIOS (1)	1
44961	REGIMEN-PENSION	11	CAJA DE PENSIONES POLICIAL	1
44960	REGIMEN-PENSION	10	CAJA DE PENSIONES MILITAR 	1
44959	REGIMEN-PENSION	09	CAJA DE BENEFICIOS DE SEGURIDAD SOCIAL DEL PESCADOR	0
44957	REGIMEN-PENSION	02	DECRETO LEY 19990 - SISTEMA NACIONAL DE PENSIONES - ONP	1
45017	TIPO-PARENTESCO	06	HIJO MAYOR DE EDAD INCAPACITADO PERMANENTE	1
45016	TIPO-PARENTESCO	05	HIJO MENOR DE EDAD	1
45015	TIPO-PARENTESCO	04	GESTANTE	1
45014	TIPO-PARENTESCO	03	CONCUBINA(O)	1
45013	TIPO-PARENTESCO	02	CÓNYUGE	1
1906	PAIS	\N	LETONIA	0
1951	PAIS	\N	MÉXICO	0
2019	PAIS	\N	CHAD	0
1883	PAIS	020	ANDORRA	1
1885	PAIS	040	AUSTRIA	1
1890	PAIS	100	BULGARIA	1
1891	PAIS	203	REPÚBLICA CHECA	1
1892	PAIS	191	CROACIA	1
1894	PAIS	703	ESLOVAQUIA	1
1895	PAIS	705	ESLOVENIA	1
1896	PAIS	724	ESPAÑA	1
1897	PAIS	233	ESTONIA	1
1899	PAIS	250	FRANCIA	1
1900	PAIS	268	GEORGIA	1
1901	PAIS	300	GRECIA	1
1902	PAIS	348	HUNGRÍA	1
1903	PAIS	372	IRLANDA	1
1904	PAIS	352	ISLANDIA	1
1907	PAIS	438	LIECHTENSTEIN	1
1908	PAIS	440	LITUANIA	1
1909	PAIS	442	LUXEMBURGO	1
1910	PAIS	807	REPÚBLICA DE MACEDONIA	1
1911	PAIS	470	MALTA	1
1912	PAIS	498	MOLDAVIA	1
1914	PAIS	499	MONTENEGRO	1
1915	PAIS	578	NORUEGA	1
1917	PAIS	616	POLONIA	1
1918	PAIS	620	PORTUGAL	1
2014	PAIS	854	BURKINA FASO	1
2024	PAIS	818	EGIPTO	1
2056	PAIS	736	SUDÁN DEL NORTE	1
2058	PAIS	834	TANZANIA	1
2059	PAIS	768	TOGO	1
20268	PAIS	484	MEXICO	1
2023	PAIS	\N	COSTA DE MARFIL	0
2047	PAIS	\N	REPÚBLICA SAHARAUI	0
2068	PAIS	\N	ISLAS MARSHALL	0
1884	PAIS	051	ARMENIA	1
1886	PAIS	031	AZERBAIYÁN	1
1888	PAIS	112	BIELORRUSIA	1
1889	PAIS	070	BOSNIA Y HERZEGOVINA	1
1893	PAIS	208	DINAMARCA	1
1898	PAIS	246	FINLANDIA	1
1939	PAIS	192	CUBA	1
1940	PAIS	212	DOMINICA	1
1941	PAIS	214	REPÚBLICA DOMINICANA	1
1942	PAIS	218	ECUADOR	1
1943	PAIS	222	EL SALVADOR	1
1944	PAIS	840	ESTADOS UNIDOS	1
1945	PAIS	308	GRANADA	1
1946	PAIS	320	GUATEMALA	1
1947	PAIS	328	GUYANA	1
1948	PAIS	332	HAITÍ	1
1950	PAIS	388	JAMAICA	1
1952	PAIS	558	NICARAGUA	1
1953	PAIS	591	PANAMÁ	1
1954	PAIS	600	PARAGUAY	1
1955	PAIS	604	PERÚ	1
1956	PAIS	630	PUERTO RICO	1
1957	PAIS	659	SAN CRISTÓBAL Y NIEVES	1
1958	PAIS	662	SANTA LUCÍA	1
1959	PAIS	670	SAN VICENTE Y LAS GRANADINAS	1
1960	PAIS	740	SURINAM	1
1961	PAIS	780	TRINIDAD Y TOBAGO	1
1962	PAIS	858	URUGUAY	1
1963	PAIS	862	VENEZUELA	1
1964	PAIS	004	AFGANISTÁN	1
1965	PAIS	682	ARABIA SAUDITA	1
1966	PAIS	048	BARÉIN	1
1968	PAIS	096	BRUNEI	1
1969	PAIS	064	BUTÁN	1
1972	PAIS	156	CHINA	1
1973	PAIS	196	CHIPRE	1
1974	PAIS	408	COREA DEL NORTE	1
1975	PAIS	410	COREA DEL SUR	1
1976	PAIS	784	EMIRATOS ARABES UNIDOS	1
1977	PAIS	608	FILIPINAS	1
1978	PAIS	356	INDIA	1
1979	PAIS	360	INDONESIA	1
1980	PAIS	364	IRÁN	1
1981	PAIS	368	IRAQ	1
1982	PAIS	376	ISRAEL	1
1983	PAIS	392	JAPÓN	1
1985	PAIS	398	KAZAJISTÁN	1
1986	PAIS	417	KIRGUISTÁN	1
1987	PAIS	414	KUWAIT	1
1988	PAIS	418	LAOS	1
1989	PAIS	422	LÍBANO	1
1990	PAIS	458	MALASIA	1
1991	PAIS	462	MALDIVAS	1
1992	PAIS	496	MONGOLIA	1
1993	PAIS	104	MYANMAR (BIRMANIA)	1
1994	PAIS	524	NEPAL	1
1995	PAIS	512	OMÁN	1
1996	PAIS	586	PAKISTÁN	1
1997	PAIS	275	PALESTINA	1
1998	PAIS	702	SINGAPUR	1
1999	PAIS	760	SIRIA	1
2000	PAIS	144	SRI LANKA	1
2006	PAIS	792	TURQUÍA	1
2015	PAIS	108	BURUNDI	1
2018	PAIS	140	REPÚBLICA CENTROAFRICANA	1
2020	PAIS	174	COMORAS	1
2021	PAIS	178	REPÚBLICA DEL CONGO	1
2022	PAIS	180	REPÚBLICA DEMOCRÁTICA DEL CONGO	1
2025	PAIS	232	ERITREA	1
2026	PAIS	231	ETIOPÍA	1
2027	PAIS	266	GABÓN	1
2028	PAIS	270	GAMBIA	1
2029	PAIS	288	GHANA	1
2030	PAIS	324	GUINEA	1
2031	PAIS	624	GUINEA-BISSAU	1
2032	PAIS	226	GUINEA ECUATORIAL	1
2033	PAIS	404	KENIA	1
2034	PAIS	426	LESOTO	1
2036	PAIS	434	LIBIA	1
2037	PAIS	450	MADAGASCAR	1
2038	PAIS	454	MALAUI	1
2039	PAIS	466	MALI	1
2040	PAIS	504	MARRUECOS	1
2041	PAIS	480	MAURICIO	1
2042	PAIS	478	MAURITANIA	1
2043	PAIS	508	MOZAMBIQUE	1
2044	PAIS	516	NAMIBIA	1
2045	PAIS	562	NÍGER	1
2046	PAIS	566	NIGERIA	1
2055	PAIS	710	SUDÁFRICA	1
1881	PAIS	008	ALBANIA	1
1882	PAIS	276	ALEMANIA	1
1887	PAIS	056	BÉLGICA	1
1928	PAIS	028	ANTIGUA V BARBUDA	1
1949	PAIS	340	HONDURAS	1
1967	PAIS	050	BANGLADÉS	1
1984	PAIS	400	JORDANIA	1
2001	PAIS	764	TAILANDIA	1
2002	PAIS	158	TAIWAN	1
2003	PAIS	762	TAYIKISTÁN	1
2004	PAIS	626	TIMOR ORIENTAL	1
2005	PAIS	795	TURKMENISTÁN	1
2007	PAIS	860	UZBEKISTÁN	1
2008	PAIS	704	VIETNAM	1
2009	PAIS	887	YEMEN	1
2016	PAIS	132	CABO VERDE	1
2017	PAIS	120	CAMERÚN	1
2035	PAIS	430	LIBERIA	1
2048	PAIS	646	RUANDA	1
2049	PAIS	678	SANTO TOMÉ Y PRÍNCIPE	1
2050	PAIS	686	SENEGAL	1
2051	PAIS	690	SEYCHELLES	1
2052	PAIS	694	SIERRA LEONA	1
2053	PAIS	706	SOMALIA	1
2054	PAIS	748	SUAZILANDIA	1
2060	PAIS	788	TÚNEZ	1
2061	PAIS	800	UGANDA	1
2062	PAIS	262	YIBUTI	1
2063	PAIS	894	ZAMBIA	1
2064	PAIS	716	ZIMBABUE	1
2065	PAIS	036	AUSTRALIA	1
2066	PAIS	242	FIYI	1
2067	PAIS	296	KIRIBATI	1
2069	PAIS	583	MICRONESIA	1
2070	PAIS	520	NAURU	1
2071	PAIS	554	NUEVA ZELANDA	1
2072	PAIS	585	PALAOS	1
2073	PAIS	598	PAPÚA NUEVA GUINEA	1
2074	PAIS	090	ISLAS SALOMÓN	1
2075	PAIS	882	SAMOA	1
2076	PAIS	776	TONGA	1
2077	PAIS	798	TUVALU	1
2078	PAIS	548	VANUATU	1
45042	COD-DEP-CESANTES	3751	PEN-SOB-IVITA PUCALLPA	1
45054	COD-DEP-CESANTES	3600	PEN-SOB-DOCENTES	1
45053	COD-DEP-CESANTES	3650	PEN-SOB-DOC-ORFANDAD	1
45051	COD-DEP-CESANTES	3700	PEN-SOB- ADMINISTRATIVOS	1
45050	COD-DEP-CESANTES	3750	PEN-SOB-ADM-ORFANDAD	1
45048	COD-DEP-CESANTES	4400	PEN-N-N-SOB-DOCENTES	1
45047	COD-DEP-CESANTES	4500	PEN-N-N-SOB-ADMINISTRATIVOS	1
45046	COD-DEP-CESANTES	4601	PENSIONISTAS IVITA LA RAYA	1
45043	COD-DEP-CESANTES	4802	PENS. ALICUOTAS SOB-ADMINISTRATIVOS	1
45044	COD-DEP-CESANTES	4801	PENS. ALICUOTAS SOB-DOCENTES	1
45049	COD-DEP-CESANTES	4200	PEN-N-NIV-DOCENTES	1
45052	COD-DEP-CESANTES	3500	PENSIONISTAS ADMINISTRATIVOS	1
45055	COD-DEP-CESANTES	3400	PENSIONISTAS DOCENTES	1
45056	COD-DEP-CESANTES	4701	PENSIONISTAS IVITA IQUITOS	1
205	LICENCIA	\N	HORA DE LACTANCIA	1
184	LICENCIA	\N	LICENCIA POR GRAVIDEZ PRE-, POST NATAL	1
206	LICENCIA	\N	SUSPENSION POR TARDANZA	1
185	LICENCIA	\N	VACACIONES PROGRAMADAS	1
204	LICENCIA	\N	LICENCIA POR MATERNIDAD	1
203	LICENCIA	\N	LICENCIA POR PATERNIDAD	1
202	LICENCIA	\N	LICENCIA POR INCAPACIDAD  TEMPORAL	1
201	LICENCIA	\N	LICENCIA SIN GOCE DE HABER	1
200	LICENCIA	\N	TRABAJOS DE INVESTIGACION	1
199	LICENCIA	\N	LICENCIA POR COMISION DE SERVICIO	1
198	LICENCIA	\N	PERMISO POR ENFERMEDAD	1
197	LICENCIA	\N	PERMISO POR ASUNTOS PARTICULRES	1
196	LICENCIA	\N	PERMISO POR ESTUDIOS SUPERIORES	1
195	LICENCIA	\N	PERMISO POR DOCENCIA UNIVERSITARIA	1
208	LICENCIA	\N	SUSPENSION POR CONDUCTA LABORAL	1
207	LICENCIA	\N	SUSPENSION POR FALTA INJUSTIFICADA	1
194	LICENCIA	\N	LICENCIA ASUNTOS PARTICULARES	1
193	LICENCIA	\N	LICENCIA POR FUNCION EDIL	1
192	LICENCIA	\N	LICENCIA POR CAPACITACION	1
191	LICENCIA	\N	LICENCIA POR DUELO	1
190	LICENCIA	\N	LICENCIA POR GRAVIDEZ POST-NATAL	1
189	LICENCIA	\N	LICENCIA POR GRAVIDEZ PRE-NATAL	1
188	LICENCIA	\N	LICENCIA POR ENFERMEDAD	1
187	LICENCIA	\N	LICENCIA POR ESTUDIO	1
186	LICENCIA	\N	VACACIONES FISICAS	1
45041	COD-DEP-CESANTES	4602	PEN-SOB-IVITA LA RAYA	1
45045	COD-DEP-CESANTES	4800	PENS-SOB-IVITA-HUANCAYO	1
45057	COD-DEP-CESANTES	4900	PENSIONISTAS IVITA PUCALLPA	1
2900	TIPO-CUENTA-BANCO	CA	CUENTA DE AHORRO	1
2901	TIPO-CUENTA-BANCO	CC	CUENTA CORRIENTE	1
2499	PERSONAL-ESTADO	9	ACTIVOS	1
113	DOC-IDENTIDAD	02	DOCUMENTO NACIONAL DE IDENTIDAD	1
39009	DOC-SUSTENTO	10	CONTRATO	1
2950	REGIMEN-PENSION	97	SIN OBLIGACIÓN	1
114	DOC-IDENTIDAD	06	REGISTRO UNICO DE CONTRIBUYENTE	1
\.


--
-- Data for Name: mes; Type: TABLE DATA; Schema: qubytss_core; Owner: qubytss_core
--

COPY qubytss_core.mes (id_mes, nomb_mes, nomb_cort_mes) FROM stdin;
01	ENERO	ENE
02	FEBRERO	FEB
03	MARZO	MAR
04	ABRIL	ABR
05	MAYO	MAY
06	JUNIO	JUN
07	JULIO	JUL
08	AGOSTO	AGO
09	SETIEMBRE	SET
10	OCTUBRE	OCT
11	NOVIEMBRE	NOV
12	DICIEMBRE	DIC
\.


--
-- Data for Name: persona; Type: TABLE DATA; Schema: qubytss_core; Owner: qubytss_core
--

COPY qubytss_core.persona (id_persona, tipo_per, tipo_doc_per, nro_doc_per, ape_pat_per, ape_mat_per, nomb_per, direc_per, sex_per, fech_nac_per, id_pais_nac, aud_fech_crea, est_civil_per, id_ubigeo_nac, nro_ruc, id_pais_emisor_doc) FROM stdin;
69	2	101		wqewqe	wweewq	wqewqe	ewqew	M	\N	2079	2024-01-29	S	\N	2132321	\N
52	2	100	11223344	Rodriguez	Lopez	Carlos	Av. Principal 456	F	1978-03-25	2087	2024-01-15	 	\N		\N
48	N	100	77657768	VALDIVIA	QUISPE	CHRISTIAN	av canta callao	M	2024-01-14	2087	2024-01-15	\N	\N	\N	\N
65	 	100	32432324	Rodriguez	Lopez	Carlos	Av. Principal 456	M	1978-03-25	2079	2024-01-17	C	\N	45435435	\N
59	1	100	543543345	Martinez	García	Javier	sadsad	M	\N	2015	2024-01-15	C	\N	dsasa	\N
58	1	100	435435453	Cabrera	García	Javier	sadsadsad	M	\N	2012	2024-01-15	C	\N	dsadsa	\N
45	N	100	45674345	Santillan	Messi	nn		 	\N	2054	2024-01-14	 	\N		\N
62	N	100	32434234324	López	Tako	Javier	435435	F	\N	2014	2024-01-15	D	\N	4543543	\N
55	N	100	99887766	Díaz	Pérez	Lucía	Calle Progreso 456	M	\N	2016	2024-01-15	C	\N	44432434324	\N
70	1	101	435435435	erewr	ewrwe	ewrwe	ewrew	M	\N	2087	2024-02-01	C	\N	wrewrewr	\N
51	N	100	123643435	Gomez	Perez	Maria	Calle 123, Ciudad	F	1985-08-10	2080	2024-01-15	 	\N		\N
93	2	100	54345	54353543	54354353	5435435	4353534	F	\N	2078	2024-02-03	C	\N	4354354	\N
6	1	113	324324	Tako	Valdivia	Christian	av canta callao AH san Martin	M	2024-01-14	1935	2024-01-13	C	\N	43243243	2087
71	1	100	12345678	Tako	Valdivia Quispe	Christian	av universitaria	M	\N	1955	2024-02-03	C	\N	43243243	\N
75	1	100	32423432	Tako	fdsds	Christian	av universitaria	M	\N	1955	2024-02-03	C	\N	43243243	\N
73	1	100	56464654	Rodriguez	Valdivia Quispe	Christian Guillermo Arturo	av canta callao AH san Martin	M	\N	1955	2024-02-03	C	\N	45435435	\N
94	2	100	3432432	Rodriguez	32432	fdgfgfdgfdg	ewrew	M	\N	2079	2024-02-08	C	\N	324324	\N
95	2	115	43432	fdsfds	dfsfds	dfsfds	fdsf	M	\N	1935	2024-02-17	S	\N	324324	\N
\.


--
-- Data for Name: concepto; Type: TABLE DATA; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COPY qubytss_rrhh.concepto (id_concepto, cod_conc, nomb_conc, tipo_conc, fech_reg_conc, id_sub_tipo_conc, afecto_essalud, afecto_previsional, afecto_impuesto, bonif_ext, est_conc) FROM stdin;
1	D161	Uniforme Cc. Adm.	2	\N	2308	t	t	t	f	1
5	D165	Adeudo Dscto. Judicial	2	\N	2308	t	t	t	f	1
6	D167	Dscto. AFP Integra AGO.00	2	\N	2308	t	t	t	f	1
7	D168	Recup. CC. Adm.	2	\N	2308	t	t	t	f	1
84	D228	Canasta Navidad SUOSM	2	\N	2308	t	t	t	f	1
87	D235	INABEC	2	\N	2308	t	t	t	f	1
88	D238	Club Deportivo UNMSM	2	\N	2308	t	t	t	f	1
89	D241	Adeudo Unidad Fincas	2	\N	2308	t	t	t	f	1
90	D242	Bienvenida Cachimbos	2	\N	2308	t	t	t	f	1
93	D248	Dcto. Fac. Cs. Administrativas	2	2006-04-11	2308	t	t	t	f	1
94	D249	Fundac. por los Niños del Perú	2	\N	2308	t	t	t	f	1
95	D250	Pago Ind. D.S. 044-2003	2	2007-04-16	2307	t	t	t	f	1
96	D252	IPSS (servidor)	2	\N	2308	t	t	t	f	1
97	D253	Recuperacion FEDU	2	\N	2308	t	t	t	f	1
131	D259	Curso Calidad y Acred. Univ.	2	\N	2308	t	t	t	f	1
133	D262	Recuperacion CAFAE	2	\N	2308	t	t	t	f	1
134	D264	Recup. prestamo CAFAE	2	\N	2308	t	t	t	f	1
135	D265	Post Grado Fac. Quimica	2	2006-06-09	2308	t	t	t	f	1
137	D269	Recup. Tesoreria Quinta Categ.	2	\N	2308	t	t	t	f	1
140	D323	Reg.Cuota Sindical Dic 07-Ene 08	2	2008-02-08	2308	t	t	t	f	1
159	D011	FEAS	2	\N	2308	t	t	t	f	1
164	D300	Recup.Ctas Cobrar-Tesoreria	2	2006-04-11	2307	f	f	f	f	1
165	D301	Dscto Servicio Telefónico	2	2006-04-12	2308	f	f	f	f	1
166	D302	Pago Ind. Homolog. Trans.(DU 033-06)	2	2006-04-17	2307	f	f	f	f	1
167	D305	Regularización ESSALUD	2	2006-05-10	2308	f	f	f	f	1
168	D200	I ENC UNIV FOLK	2	\N	2308	t	t	t	f	1
170	D272	Campa±a Osteoporosis	2	\N	2308	t	t	t	f	1
171	D113	LACAME 96	2	\N	2308	t	t	t	f	1
179	D297	Regularizacion AFP-Ene.06	2	2006-02-15	2308	t	t	t	f	1
180	D298	Uniforme Fac. CC. Sociales	2	2006-02-15	2308	f	f	f	f	1
181	D299	Post Grado Fac. Psicologia	2	2006-02-15	2308	f	f	f	f	1
184	D304	Canasta Navideña -FISI	2	2006-05-08	2308	f	f	f	f	1
185	D307	Pago Ind.  R. Basica/Jornal Basico	2	2006-06-08	2307	f	f	f	f	1
188	D309	Pago Ind. DS 110-2006-EF	2	2006-10-05	2307	t	t	t	f	1
189	D174	Curso Bas. Informatica	2	\N	2308	t	t	t	f	1
248	D070	Uniforme F.C. Fisicas	2	\N	2308	t	t	t	f	1
249	D072	Navidad Fac. Medicina	2	\N	2308	t	t	t	f	1
250	D074	Teleamor	2	\N	2308	t	t	t	f	1
251	D077	Juan Quispe	2	\N	2308	t	t	t	f	1
252	D079	Uniforme Farmacia	2	\N	2308	t	t	t	f	1
253	D081	Uniforme Biologia	2	\N	2308	t	t	t	f	1
256	D088	Reintegro a la Universidad	2	\N	2308	t	t	t	f	1
257	D091	Navidad CCFF	2	\N	2308	t	t	t	f	1
259	D095	Navidad O.G.P.	2	\N	2308	t	t	t	f	1
260	D098	Navidad (Of. Operac. y Mant)	2	\N	2308	t	t	t	f	1
261	D101	Uniforme Fac. Economia	2	\N	2308	t	t	t	f	1
262	D102	Desc. varios	2	2018-10-25	2308	t	t	t	f	1
263	D105	Boutique Magia	2	\N	2308	t	t	t	f	1
264	D108	Cent.Prod.Fondo Editorial	2	\N	2308	t	t	t	f	1
265	D109	Unif. Post Grado	2	\N	2308	t	t	t	f	1
266	D116	Dscto. Fac. Psicologia	2	\N	2308	t	t	t	f	1
330	D024	INDICO S.A.	2	\N	2308	t	t	t	f	1
334	D029	AFP ProFuturo (sin prima)	2	\N	2308	t	t	t	f	1
336	D031	AFP Integra (sin prima)	2	\N	2308	t	t	t	f	1
337	D149	Pago Indebido D.U.073-97	2	2007-04-16	2307	t	t	t	f	1
338	D150	Pago Indebido D.U.011-99	2	\N	2307	t	t	t	f	1
339	D151	Dscto. Palma Magisterial	2	\N	2307	t	t	t	f	1
340	D152	Dcto EAP Estadistica	2	\N	2308	t	t	t	f	1
341	D153	Devolucion Herramientas	2	\N	2308	t	t	t	f	1
342	D154	Dscto. Indebido AFP	2	\N	2308	t	t	t	f	1
344	D156	Adeudo SPP - Horizonte	2	\N	2308	t	t	t	f	1
345	D157	Adeudo SPP - Profuturo	2	\N	2308	t	t	t	f	1
346	D158	Adeudo SPP - Integra	2	\N	2308	t	t	t	f	1
347	D159	Adeudo SPP - Union Vida	2	\N	2308	t	t	t	f	1
348	D160	Ayuda Mutua	2	\N	2308	t	t	t	f	1
360	D350	SINDUSM-Cursos	2	2009-12-01	2308	f	f	f	f	1
361	D351	Regularizacion de Cuarta Categoria	2	2009-12-18	2308	f	f	f	f	1
366	D313	Navidad( TRANS. Y MAESTR.)	2	2007-04-12	2308	f	f	f	f	1
370	D315	Reg. Credito Clin. Universitaria	2	2007-07-06	2308	f	f	f	f	1
371	D316	FONGRASAM	2	2007-07-12	2308	f	f	f	f	1
373	D317	Incremento Prueba	2	2007-08-03	2308	f	f	f	f	1
416	D310	Post Grado Fac.Ciencias Biológicas	2	2006-11-09	2308	f	f	f	f	1
418	D338	OGBU-Global Medica	2	2009-01-19	2308	f	f	f	f	1
420	D339	Fdo.Pro Cerco Perimetral	2	2009-02-13	2308	f	f	f	f	1
421	D340	Pago Ind. Cargo	2	2009-02-16	2307	t	t	t	f	1
423	D341	Canasta-Fac Ing Sist e Inf	2	2009-02-26	2308	f	f	f	f	1
427	D343	Dictado de Cursos -FMV	2	2009-04-15	2308	f	f	f	f	1
534	I026	FEDU	1	\N	2301	t	t	t	f	1
428	D344	Dictado de Cursos -Derecho	2	2009-04-15	2308	f	f	f	f	1
431	D346	Descuentos Varios	2	2009-06-23	2308	f	f	f	f	1
438	D359	Pago Ind.D.S. 077-2010-EF	2	2010-10-05	2307	t	t	t	f	1
439	D205	IV Cong. Cc. Farmaceuticas	2	\N	2308	t	t	t	f	1
440	D208	Uniforme Quimica	2	\N	2308	t	t	t	f	1
442	D213	Pago indebido (NO USAR)	2	\N	2308	t	t	t	f	1
443	D215	Dscto. Fac. CC.Sociales	2	\N	2308	t	t	t	f	1
445	D220	Dscto. Ivita. Iquitos	2	\N	2308	t	t	t	f	1
448	D360	Clinica-Global Medica	2	2010-10-15	2308	f	f	f	f	1
449	D361	Visita Inopinada-Adm Central	2	2010-11-09	2308	f	f	f	f	1
450	D230	Dcto Quinta Categ. Feb.02	2	\N	2308	t	t	t	f	1
451	D234	Dcto Unif. Fac. Educacion	2	\N	2308	t	t	t	f	1
468	D195	Uniforme-Fac IGMMG	2	2008-11-05	2308	t	t	t	f	1
471	D258	Curso crianza de caracoles	2	\N	2308	t	t	t	f	1
489	D080	Uniforme Derecho	2	\N	2308	t	t	t	f	1
490	D083	Uniforme CC. Contables	2	\N	2308	t	t	t	f	1
491	D087	Panetones Farmacia	2	\N	2308	t	t	t	f	1
492	D090	Pro Nav. Ing Electronica	2	\N	2308	t	t	t	f	1
493	D094	Reg. 5ta. Categoria 2009	2	2006-01-18	2308	t	t	t	f	1
494	D097	IVITA Huancayo	2	\N	2308	t	t	t	f	1
495	D099	Navidad Fac. Quimica	2	\N	2308	t	t	t	f	1
496	D104	Computacion Niños	2	\N	2308	t	t	t	f	1
498	D111	Maquicentro	2	\N	2308	t	t	t	f	1
499	D115	Asignacion Voluntaria	2	\N	2308	t	t	t	f	1
501	D120	Adeudo Universidad	2	\N	2308	t	t	t	f	1
502	D123	Ivita el Mantaro	2	\N	2308	t	t	t	f	1
505	D130	Cena FIE	2	\N	2308	t	t	t	f	1
507	D135	Cta. FINBANCO	2	\N	2308	t	t	t	f	1
508	D137	Servicio Dental	2	\N	2308	t	t	t	f	1
509	D140	Curso FORTRAN 77	2	\N	2308	t	t	t	f	1
510	D142	Dscto. refrigerio/movilidad	2	2006-08-14	2307	t	t	t	f	1
511	D145	Descuento D.S. 051-91	2	2006-08-14	2307	t	t	t	f	1
513	D237	Duplicado Fotocheck	2	\N	2308	t	t	t	f	1
519	D352	C.EU.P.S. CC.Económicas	2	2010-02-11	2308	f	f	f	f	1
521	D356	Fac. C.C.-ALAFEC 2010	2	2010-09-07	2308	f	f	f	f	1
529	D012	Honorario de Asesor	2	\N	2308	t	t	t	f	1
544	D008	Met. Estad. Epidemiologia	2	\N	2308	t	t	t	f	1
545	D013	Sastreria Quiroz	2	\N	2308	t	t	t	f	1
546	D293	Academia de Futbol- Club UNMSM	2	2006-01-17	2308	t	t	t	f	1
547	D294	SOPERFI-Curso de Esp.	2	2006-01-17	2308	t	t	t	f	1
574	D388	Clinica-Campaña de Salud Visual	2	2012-07-02	2308	f	f	f	f	1
576	D395	Fac.Farm y Bioq-Ofic. Cal. Acad y Acred	2	2013-05-08	2308	f	f	f	f	1
578	D401	ODBS-Econovisión	2	2013-07-22	2308	f	f	f	f	1
579	D402	ODBS-Nutrimedic Salud	2	2013-07-22	2308	f	f	f	f	1
587	D381	Examen Pre-UNMSM	2	2012-03-14	2308	f	f	f	f	1
589	D383	OGBU-Nutrimedic Salud	2	2012-04-03	2308	f	f	f	f	1
596	D386	Inasist. Examen Admisión	2	2012-05-16	2308	f	f	f	f	1
598	D405	OGBU-Optica Valeria	2	2014-04-08	2308	f	f	f	f	1
603	D369	Fac. Ing. Industrial	2	2011-08-15	2308	f	f	f	f	1
604	D373	Fac. Odontologia-Cena	2	2011-10-07	2308	f	f	f	f	1
608	D364	Libre	2	2011-04-04	2308	f	f	f	f	1
609	D367	Fac. Quim. e I.Q. - U.Post Grado	2	2011-06-21	2308	f	f	f	f	1
612	D363	OGBU-Odontofresh	2	2011-02-09	2308	f	f	f	f	1
614	D371	Dscto. Fac. Educación	2	2011-09-12	2308	t	t	t	f	1
617	D370	Fac. Med Vet-Conejo y Cuy	2	2011-09-05	2308	f	f	f	f	1
619	D376	Fac. Quim. e I.Q. - Bellavista 20 & 20	2	2012-01-16	2308	f	f	f	f	1
620	D377	Quinta Categoria-Regularización	2	2012-01-16	2308	f	f	f	f	1
657	D379	Simulacro Admision	2	2012-02-15	2308	f	f	f	f	1
660	D397	Pago Indeb-Resp. Directiva	2	2013-06-06	2307	t	t	t	f	1
677	D390	Pago Ind Subs x Fall	2	2012-12-04	2307	t	t	t	f	1
678	D392	Fac. Med. ASPEFAM	2	2013-02-25	2308	f	f	f	f	1
679	D404	OGBU-Oculaser	2	2013-08-12	2308	f	f	f	f	1
755	D435	Pag. Ind. D.S. 009-2019-EF	2	2019-06-04	2307	t	t	t	f	1
756	D0437	ESSALUD	2	2019-08-05	2308	t	t	t	f	1
762	D440	Pago Ind. Bonif.Diferenc/Otr Emp.Perm	2	2020-09-09	2307	t	t	t	f	1
763	D441	Pago Ind. D.U 37-94	2	2020-09-09	2307	t	t	t	f	1
773	D442	Prueba Proveedor	2	2020-12-30	2308	t	t	t	f	1
777	D0444	ESSALUD	2	2022-01-20	2308	f	f	f	f	1
98	R002	Reintegro RGA.	3	\N	2309	t	t	t	f	1
111	R031	Reintegro Art. 18	3	\N	2309	t	t	t	f	1
112	R032	Reintegro Palma Magisterial	3	\N	2309	t	t	t	f	1
113	R035	Reint.Calc.AFP	3	\N	2309	t	t	t	f	1
114	R038	ADMISION	3	\N	2309	t	t	t	f	1
122	R039	Otros ingresos	3	\N	2309	t	t	t	f	1
123	R043	Dev. Dscto SUTUSM	3	\N	2309	t	t	t	f	1
129	I058	Remuneracion Vacac. Proporc.	1	\N	2302	t	t	t	f	1
151	I046	Monto a Favor	1	\N	2302	t	t	t	f	1
193	I112	D.U. 072-2009	1	2009-12-23	2302	f	f	f	t	1
228	I083	Subvención por Admisión	1	2007-03-01	2301	f	f	f	f	1
229	EE01	Bolsa de Viveres	1	2007-03-05	2305	t	t	t	f	1
230	ER01	Incentivo Academico	1	2007-03-05	2304	t	t	t	f	1
269	ER009	Indemnización	1	2009-12-18	2304	f	f	f	f	1
305	R033	Reint. Otras Pensiones	3	\N	2309	t	t	t	f	1
306	R040	Reintegro D.L. 817	3	\N	2309	t	t	t	f	1
307	R044	Dev. Responsabilidad Fiscal	3	\N	2309	t	t	t	f	1
308	I013	Subvencion	1	\N	2302	t	t	t	f	1
312	I038	D.L. 25697-92 (NO USAR)	1	\N	2302	t	t	t	f	1
349	ER02	Incentivo Laboral -Función Técnica	1	2007-03-05	2304	t	t	t	f	1
350	ER06	Incentivo por Navidad (CAFAE)	1	2007-03-05	2304	t	t	t	f	1
351	ER07	Productividad	1	2007-03-05	2304	t	t	t	f	1
352	O001	C.T.S	1	2007-03-05	2306	t	t	t	f	1
354	O002	Asignacion 25 años	1	2007-03-12	2306	t	t	t	f	1
355	O003	Asignacion 30 años	1	2007-03-12	2306	t	t	t	f	1
356	O004	Escolaridad	1	2007-03-12	2306	t	t	t	f	1
357	O005	Reemplazo Cheque Judicial	1	2007-03-12	2306	t	t	t	f	1
358	O006	Pension Alicuota	1	2007-03-12	2306	t	t	t	f	1
362	I082	Pago Plla. Directivo	1	2007-02-28	2301	f	f	f	f	1
363	O007	Subvencion por Sepelio y Luto	1	2007-03-12	2306	t	t	t	f	1
364	O008	Subvencion por Fallecimiento	1	2007-03-12	2306	t	t	t	f	1
372	I085	D.S.153-91-EF (NO USAR)	1	\N	2301	t	t	t	f	1
374	I086	Incremento Prof. Salud	1	2007-08-15	2302	f	f	f	f	1
385	I092	Bono D.S. 002-2008-EF	1	2008-01-22	2302	f	f	f	t	1
388	ER08	Pago Plla Investigacion	1	2008-05-29	2304	f	f	f	f	1
391	I093	Remuneracion Proporcional	1	2008-08-06	2302	t	t	t	f	1
404	I098	D.S. 008-2009-EF	1	2009-01-21	2301	f	f	f	f	1
406	I097	Pension Proporcional	1	2009-01-12	2302	t	t	t	f	1
412	I109	Deveng. D.S. 153-91-EF	1	2009-05-28	2302	f	f	f	f	1
415	I115	Devengado D.U.112-2009	1	2010-01-26	2302	f	f	f	t	1
422	I107	Deveng. D.S. 120-2008-EF	1	2009-02-25	2302	t	t	t	f	1
426	R089	Reint. L. 29289-2008	3	2009-03-24	2309	f	f	f	f	1
429	I108	Deveng. L. 29289-2008	1	2009-04-28	2302	f	f	f	f	1
434	R061	Reint. D.S. 153-91-EF	3	2009-05-28	2309	f	f	f	f	1
437	I111	D.U.112-2009	1	2009-12-11	2302	f	f	f	t	1
455	R013	Reint. Pens. Alicuota	3	\N	2309	t	t	t	f	1
461	R034	Reint. Adeudo FP 20530	3	\N	2309	f	f	f	f	1
462	R036	Dev. Dcto. (NO USAR)	3	\N	2309	t	t	t	f	1
465	I113	D.Leg. 1057-2008 - aporte opcional	1	\N	2301	t	t	t	f	1
470	I059	Subsidio	1	\N	2302	t	t	t	f	1
480	I003	Remun.suspendida	1	\N	2302	t	t	t	f	1
515	R001	Reintegro inasistencia	3	\N	2309	t	t	t	f	1
520	I117	D.S. 0105-2010-EF	1	2010-04-26	2302	f	f	f	f	1
533	I022	Remuneracion Neta	1	\N	2302	t	t	t	f	1
539	I044	Asignacion por 25/30 Años	1	\N	2302	t	t	t	f	1
540	I047	Vacaciones Truncas	1	\N	2302	t	t	t	f	1
552	I070	Regularizacion de Subsidio	1	2005-12-21	2302	t	t	t	f	1
557	R046	Reint. Rem. (NO USAR)	3	\N	2309	t	t	t	f	1
558	R048	Reintegro Cambio Categoria	3	\N	2309	t	t	t	f	1
566	I014	Aguinaldo	1	2009-08-27	2302	t	t	t	t	1
571	I127	Devengado D.S. 024-2012-EF	1	2012-02-08	2302	t	t	t	f	1
575	I134	D.S. 0104-2012-EF	1	2012-10-03	2302	f	f	f	f	1
593	I137	L.29951 - Incentivo Único	1	2013-04-16	2302	f	f	f	f	1
13	D175	Solidaridad Docente	2	\N	2308	t	t	t	f	1
597	ER011	Reint. DS 004-2013-EF    (NO USAR)	1	2013-02-14	2304	t	t	t	f	1
599	ER03	Incentivo Laboral -Función Educativa	1	2007-03-05	2304	t	t	t	f	1
600	ER04	Bonificación por Admisión	1	2007-03-05	2304	t	t	t	f	1
601	ER05	Subvención	1	2007-03-05	2304	t	t	t	f	1
611	I125	Devol. aportes S.N.P.	1	2011-12-19	2302	f	f	f	f	1
616	I124	Devolucion Deposito Anulado	1	2011-08-24	2302	f	f	f	f	1
625	O009	Vacaciones truncas-Ley 29849	1	2013-03-21	2306	f	f	f	f	1
628	I139	Aguinaldo - DU 001-14	1	2014-07-14	2302	f	f	f	t	1
638	ER010	LIBRE	1	2012-03-12	2304	f	f	f	f	1
642	O011	Vacaciones truncas - CAS	1	2013-11-26	2306	t	t	t	f	1
643	R098	Reint.Aguinaldo - DU 001-14	3	2014-08-04	2309	f	f	f	t	1
645	I174	Dev. D.S. 016-2005-EF	1	2015-02-15	2302	t	t	t	f	1
646	I175	Dev. L. 27617-02  PMV	1	2015-02-15	2302	t	t	t	f	1
647	I176	Dev. Bonif. Inc.B Art.34 Ley 28449	1	2015-02-15	2302	t	t	t	f	1
648	R110	Reint. Bonif. Inc.B Art.34 Ley 28449	3	2015-02-15	2309	t	t	t	f	1
649	R111	Reint. D.S. 017-2005-EF	3	2015-02-15	2309	t	t	t	f	1
650	I177	Dev. D.S. 017-2005-EF	1	2015-02-15	2302	t	t	t	f	1
652	I179	Dev. D.S. 040-92	1	2015-02-15	2302	t	t	t	f	1
653	R112	Reint. D.S. 040-92	3	2015-02-15	2309	t	t	t	f	1
654	I180	Dev. D.L. 817	1	2015-02-15	2302	t	t	t	f	1
663	R105	Reint. L. 27617-02  PMV	3	2015-02-05	2309	t	t	t	f	1
667	I157	Dev. D.S. 014-2009-EF	1	2015-02-05	2302	t	t	t	f	1
669	I159	Dev. Art.18	1	2015-02-05	2302	t	t	t	f	1
670	I160	Dev. D.S.077-2010-EF	1	2015-02-05	2302	t	t	t	f	1
671	I161	Dev. D.S.039-2007-EF	1	2015-02-05	2302	t	t	t	f	1
673	I163	Dev. D.L. 559-1990	1	2015-02-05	2302	t	t	t	f	1
674	R108	Reint. D.L. 559-1990	3	2015-02-05	2309	t	t	t	f	1
675	I164	Dev. L. 28449-2005	1	2015-02-05	2302	t	t	t	f	1
680	O010	Uniforme UNMSM	1	2013-11-15	2306	f	f	f	f	1
149	I041	D.U. 011-99	1	\N	2302	t	t	t	f	1
698	I167	Dev. D.S.002-2015-EF	1	2015-02-06	2302	t	t	t	f	1
699	I168	Dev. D.S. 110-2006-EF	1	2015-02-06	2302	t	t	t	f	1
700	I169	Dev. D.S.004-2013-EF	1	2015-02-06	2302	t	t	t	f	1
701	I170	Dev. D.S.031-2011-EF	1	2015-02-06	2302	t	t	t	f	1
702	R109	Reint. R. Minima Vital-Art 32	3	2015-02-06	2309	t	t	t	f	1
703	I171	Dev. R. Minima Vital-Art 32	1	2015-02-06	2302	t	t	t	f	1
704	I172	Dev. D.S.003-2014-EF	1	2015-02-06	2302	t	t	t	f	1
710	ER013	OGBU-T	1	2018-01-31	2304	f	f	f	f	1
712	ER012	Reg. Aporte SNP	1	2015-08-17	2304	t	t	t	f	1
719	R117	Reint. DS 350-2017-EF	3	2018-04-18	2309	t	t	t	f	1
728	I192	Deveng. D.S. 005-2016-EF	1	2018-10-19	2302	t	t	t	f	1
729	I193	Deveng. D.S. 020-2017-EF	1	2018-10-19	2302	t	t	t	f	1
735	ER014	EPS Sanitas Peru	1	2018-12-04	2304	t	t	t	f	1
750	I187	Ley 30372 - Octogésima Novena	1	2017-11-08	2302	t	t	t	f	1
754	I196	Devol.Dscto. DS.040-92 y 081-93	1	2019-04-05	2302	f	f	f	f	1
764	I199	Aguinaldo Autoridad	1	2019-12-13	2302	f	f	f	t	1
768	ER015	Bono Extraordinario	1	2020-12-29	2304	t	t	t	t	1
769	ER016	Prueba Proveedor	1	2020-12-30	2304	f	f	f	f	1
771	I203	Ley 31084 Nonagésima Segunda Disp.Compl - ACTIVOS	1	2020-03-11	2302	t	t	t	t	1
772	I204	Ley 31084 Nonagésima Segunda Disp.Compl - CAS	1	2020-03-11	2302	t	t	t	t	1
775	R121	Reint. DS 006-2021-EF	3	2021-02-13	2309	t	t	t	f	1
776	R120	Reint.Aguinaldo Aut.	3	2020-12-11	2309	f	f	f	t	1
407	I099	L. 29289-2008	1	2009-01-22	2302	f	f	f	f	1
795	R131	Reint.Aguinaldo Fiestas Patrias (NO AFECTO)	3	2023-10-31	2309	f	f	f	f	1
796	I229	Dev. Aguinaldo Fiestas Patrias (NO AFECTO)	1	2023-10-31	2302	f	f	f	f	1
10	D171	Confecciones	2	\N	2308	t	t	t	f	1
11	D172	Calzado	2	\N	2308	t	t	t	f	1
14	D177	CECADI	2	\N	2308	t	t	t	f	1
15	D178	Ropa Dep. FIE	2	\N	2308	t	t	t	f	1
17	D034	AFP Union Vida (sin prima)	2	\N	2308	t	t	t	f	1
18	D035	Clinica UNMSM	2	\N	2308	t	t	t	f	1
19	D037	ANA S.A.	2	\N	2308	t	t	t	f	1
20	D280	Campaña Optica	2	\N	2308	t	t	t	f	1
21	D281	Curso OGBU	2	\N	2308	t	t	t	f	1
22	D283	Codorniz y Derivados	2	\N	2308	t	t	t	f	1
27	D285	Club Deportivo Leones UNMSM	2	\N	2308	t	t	t	f	1
30	D289	Pago Indebido. 106-2005	2	2005-11-09	2307	f	f	f	f	1
31	D292	Academia de Futbol - Club Deportivo UNMSM	2	\N	2308	f	f	f	f	1
32	D027	AFP Horizonte (sin prima)	2	\N	2308	t	t	t	f	1
34	D043	Loc. Davila	2	\N	2308	t	t	t	f	1
35	D046	Pro Local	2	\N	2308	t	t	t	f	1
36	D050	Util. Escol. CACTUSM	2	\N	2308	t	t	t	f	1
38	D057	Pago Ind. FEDU	2	2006-08-14	2307	t	t	t	f	1
40	D064	Dscto. Uniforme Psicologia	2	\N	2308	t	t	t	f	1
41	D068	INTERBANC	2	\N	2308	t	t	t	f	1
42	D071	Canasta Navideña OGRRHH	2	2007-02-13	2308	t	t	t	f	1
43	D075	SERVISUD	2	\N	2308	t	t	t	f	1
44	D078	ELAPRIN - Ing. Industrial	2	\N	2308	t	t	t	f	1
45	D082	Uniforme Geologia	2	\N	2308	t	t	t	f	1
47	D089	Rec. Gastos Anter. 2/10	2	\N	2308	t	t	t	f	1
48	D096	Curso Leng. Prog.	2	\N	2308	t	t	t	f	1
49	D100	Navidad (Of. Bienestar)	2	\N	2308	t	t	t	f	1
50	D107	Curs.Inv. Matem.	2	\N	2308	t	t	t	f	1
51	D114	Uniforme Matematicas	2	\N	2308	t	t	t	f	1
57	D112	Ind. Pension Orfandad	2	\N	2308	t	t	t	f	1
59	D181	Clinica Fac. Odontologia	2	2009-07-06	2308	t	t	t	f	1
60	D182	D'PROMART	2	\N	2308	t	t	t	f	1
61	D184	Actividad OGP	2	\N	2308	t	t	t	f	1
62	D186	Titulacion Extraord. CC.FF.	2	\N	2308	t	t	t	f	1
63	D188	GEMARUY S.A.	2	\N	2308	t	t	t	f	1
64	D189	MASTER MODA S.A.C.	2	\N	2308	t	t	t	f	1
65	D191	C. IBAÑEZ M.	2	\N	2308	t	t	t	f	1
66	D193	Dscto. Unif. Letras CC.HH	2	\N	2308	t	t	t	f	1
67	D194	Cancelacion Curso Inform.	2	\N	2308	t	t	t	f	1
68	D197	Curso Teorico-Pract. Medicina	2	\N	2308	t	t	t	f	1
69	D199	DIREC.SUP.INV	2	\N	2308	t	t	t	f	1
70	D201	GEST EDUC SALUD	2	\N	2308	t	t	t	f	1
71	D204	I Festival de la Esperanza	2	\N	2308	t	t	t	f	1
72	D206	Modulo Estrateg. Aprendizaje	2	\N	2308	t	t	t	f	1
73	D207	Credito Clin. Universitaria	2	\N	2308	t	t	t	f	1
74	D209	Uniforme Clinica Univ.	2	\N	2308	t	t	t	f	1
76	D212	Navidad Cs. Matematicas	2	\N	2308	t	t	t	f	1
77	D214	Coop CACTUSM-Credito	2	2006-04-28	2308	t	t	t	f	1
79	D217	Adeudo Tesoreria General	2	\N	2308	t	t	t	f	1
80	D219	Dscto. Ivita. Marangani	2	\N	2308	t	t	t	f	1
82	D224	Dcto. Fac. Cs. Contables	2	\N	2308	t	t	t	f	1
190	D176	Queso IVITA	2	\N	2308	t	t	t	f	1
194	D354	OGBU-REFASA	2	2010-08-05	2308	f	f	f	f	1
196	D357	Regularizacion AFP Horizonte	2	2010-09-22	2308	f	f	f	f	1
197	D358	Regularizacion S.N.P.	2	2010-09-22	2308	f	f	f	f	1
199	D036	Solucion	2	\N	2308	t	t	t	f	1
202	D284	OGBU-Circus	2	2008-08-07	2308	t	t	t	f	1
208	D291	Dsct. Ofic. Calidad Académica	2	2006-01-06	2308	f	f	f	f	1
209	D093	Ivita Pucallpa	2	\N	2308	t	t	t	f	1
210	D103	Moneda Conmemorativa 450 años	2	\N	2308	t	t	t	f	1
211	D110	R.G.A  Fac. Admin.	2	\N	2308	t	t	t	f	1
213	D243	Dcto Fac. Cc. Economicas	2	\N	2308	t	t	t	f	1
216	D276	Pro Local - FENTUP	2	\N	2308	t	t	t	f	1
217	D180	DSCTO AFP HORIZONTE JUL99	2	\N	2308	t	t	t	f	1
220	D187	Matricula Maestria CC.FF.	2	\N	2308	t	t	t	f	1
221	D190	BRUNO SPORT S.A.	2	\N	2308	t	t	t	f	1
222	D192	DCTO.PLLA DIRECTIVO	2	\N	2308	t	t	t	f	1
223	D196	Sem. Taller Medicina	2	\N	2308	t	t	t	f	1
224	D198	Cong. Cc. Farmaceuticas	2	\N	2308	t	t	t	f	1
231	D041	B. Junior	2	\N	2308	t	t	t	f	1
232	D042	C. Silvia	2	\N	2308	t	t	t	f	1
233	D044	R.G.P.A.	2	\N	2308	t	t	t	f	1
236	D048	Adeudo al Sist Pensiones	2	\N	2308	t	t	t	f	1
239	D052	Dscto. Reunificada	2	2006-08-14	2307	t	t	t	f	1
240	D053	Dscto. T.P.H.	2	2006-08-14	2307	t	t	t	f	1
241	D055	Dscto. Bonif. Familiar	2	2006-08-14	2307	t	t	t	f	1
243	D058	Pago Ind. Encargatura	2	2007-04-16	2307	t	t	t	f	1
270	D121	Escuela Andina Fisica	2	\N	2308	t	t	t	f	1
271	D122	Didactica Universitaria	2	\N	2308	t	t	t	f	1
272	D124	Uniforme Ing. Industrial	2	\N	2308	t	t	t	f	1
273	D126	PRES. DIGA	2	\N	2308	t	t	t	f	1
275	D129	Reaj. mes anterior	2	\N	2308	t	t	t	f	1
276	D131	Uniforme Geologia	2	\N	2308	t	t	t	f	1
277	D132	Turismo Centro Cultural	2	\N	2308	t	t	t	f	1
278	D134	Pago Matricula Letras	2	\N	2308	t	t	t	f	1
280	D138	Almuerzo Ingenieria Industrial	2	\N	2308	t	t	t	f	1
281	D139	Regularizacion AFP Integra	2	\N	2308	t	t	t	f	1
282	D141	Regularización AFP Profuturo	2	\N	2308	t	t	t	f	1
283	D143	Asoc. Trab. Quimica	2	\N	2308	t	t	t	f	1
284	D144	Dscto. Libro Ginec. y Obstetr.	2	\N	2308	t	t	t	f	1
285	D146	Descuento D.S. 227	2	2006-08-14	2307	t	t	t	f	1
286	D148	Pago Indebido D.U.090-96	2	\N	2307	t	t	t	f	1
287	D275	ADUNMSMHH	2	\N	2308	t	t	t	f	1
288	D277	Pago Indebido L. 28449-2005	2	\N	2307	t	t	t	f	1
289	D278	Pago Ind. D.S. 017-2005-EF	2	2018-10-19	2307	t	t	t	f	1
293	D222	Fac. Quim. e I.Q. - Dsctos.	2	2012-01-16	2308	t	t	t	f	1
295	D229	Pago Ind. Taller CEA	2	\N	2307	t	t	t	f	1
299	D251	Arrendatario	2	\N	2308	t	t	t	f	1
315	D009	Retencion Universidad	2	\N	2308	t	t	t	f	1
317	D023	Adeudo FP 20530	2	\N	2307	t	t	t	f	1
322	D355	Dscto-Visita Inopinada	2	2010-08-11	2308	f	f	f	f	1
323	D014	Libreria UNMSM	2	\N	2308	t	t	t	f	1
324	D015	G. Cespedes	2	\N	2308	t	t	t	f	1
327	D019	Seguros de Vida	2	\N	2308	t	t	t	f	1
328	D021	R. Torres	2	\N	2308	t	t	t	f	1
329	D022	Descuento Veterinaria	2	\N	2308	t	t	t	f	1
378	D318	Fondo Pro Damnificados del Sur	2	2007-09-12	2308	f	f	f	f	1
379	D319	Apoyo Damnif. del Sur - F.MEDICINA	2	2007-09-13	2308	f	f	f	f	1
381	D320	Apoyo Damnif. del Sur - FCCSS	2	2007-12-07	2308	f	f	f	f	1
383	D321	Pag.Ind.Ley 29137	2	2007-12-12	2307	f	f	f	f	1
384	D322	Descuento SUOSM	2	2007-12-12	2308	f	f	f	f	1
386	D325	Dcto. Fac. Cs. Sociales	2	2008-05-08	2308	f	f	f	f	1
387	D324	OGBU-Cvo. RPM Movistar	2	2008-04-30	2308	f	f	f	f	1
389	D326	Reg. Asoc.Prof.Emeritos	2	2008-06-05	2308	f	f	f	f	1
394	D330	Solidaridad-Fac Ing Ind	2	2008-08-26	2308	f	f	f	f	1
399	D333	Fac. CCSS-Post Grado	2	2008-10-15	2308	f	f	f	f	1
401	D334	Regularizacion AFP Prima	2	2008-11-11	2308	f	f	f	f	1
403	D336	Fac. CC.Admins-Post Grado	2	2008-12-11	2308	f	f	f	f	1
473	D263	Adeudo Ex- IPSS	2	\N	2308	t	t	t	f	1
475	D268	Asoc.Doc.Fac. C.Contables	2	\N	2308	t	t	t	f	1
476	D271	Seminario Intern.Vicerrec.Acad	2	\N	2308	t	t	t	f	1
477	D273	Seguros Rimac Intern. SOAT	2	\N	2308	t	t	t	f	1
479	D274	Retenc. Judicial Admision 2004	2	\N	2308	t	t	t	f	1
484	D062	Acuerdo Extra-Judicial	2	\N	2308	t	t	t	f	1
485	D066	Dscto  leche Ivita Pucallpa	2	\N	2308	t	t	t	f	1
486	D069	Uniforme Institucional	2	\N	2308	t	t	t	f	1
487	D073	Uniforme Fac. Medicina	2	\N	2308	t	t	t	f	1
488	D076	M. Ccorahua	2	\N	2308	t	t	t	f	1
549	D295	Pago Ind. Remuneracion Vacacional	2	2007-04-16	2307	t	t	t	f	1
555	D296	Pago Ind. L. 28254-2004	2	2006-01-18	2307	f	f	f	f	1
556	D270	Pago Indebido D.S. 020-2004	2	\N	2307	t	t	t	f	1
569	D040	Bazar Universitario	2	\N	2308	t	t	t	f	1
627	D403	Pago Indeb-Recursos Liberados	2	2013-08-08	2307	t	t	t	f	1
639	D380	OBSERVACION OCI	2	2012-03-12	2307	t	t	t	f	1
158	D007	Coop. Capac Yupanqui	2	\N	2308	t	t	t	f	1
255	D086	Coop CSETUNMSM-Prev Social	2	2010-02-02	2308	t	t	t	f	1
91	D245	Rimac Seguros y Reaseguros	2	2013-08-08	2308	t	t	t	f	1
92	D246	Interseguro Compañia de Seguros S.A.	2	2012-12-06	2308	t	t	t	f	1
121	D365	Cvo. CM Cuzco	2	2011-05-04	2308	f	f	f	f	1
124	D254	ESSALUD	4	\N	2300	t	t	t	f	1
172	D005	Dsct. Inasistencias	2	\N	2308	t	t	t	f	1
3	D163	Responsabilidad Fiscal	2	\N	2307	t	t	t	f	1
85	D231	Dcto. Fac. Ing. de Sistemas	2	\N	2308	t	t	t	f	1
86	D232	Fac. Matematicas-U.Post Grado	2	2006-04-12	2308	t	t	t	f	1
169	D239	Colegio de Psicologos	2	\N	2308	t	t	t	f	1
156	D003	Quinta Categoria	2	\N	2308	t	t	t	f	1
187	D308	Cvo. Bco. Pichincha	2	2006-08-10	2308	f	f	f	f	1
120	D362	Asoc.Ces.Doc.-FAER	2	2011-01-21	2308	f	f	f	f	1
254	D084	OGBU-Vacaciones Utiles	2	2011-06-01	2308	t	t	t	f	1
2	D162	Dscto. Fac. Medicina	2	\N	2308	t	t	t	f	1
127	D203	FII-Diversos Cursos	2	2007-08-14	2308	t	t	t	f	1
258	D092	Pago Ind. DL. 26504	2	2007-04-16	2307	t	t	t	f	1
173	D306	Post Grado FISI	2	2006-05-17	2308	f	f	f	f	1
132	D260	Sancion de Multa Comite Elect.	2	\N	2308	t	t	t	f	1
343	D155	Dscto. Pago Indebido	2	2017-06-21	2307	t	t	t	f	1
441	D210	Asoc Cayna-Prestamo	2	2010-06-25	2308	t	t	t	f	1
417	D337	Cvo. Bco. Interbank	2	2009-01-06	2308	f	f	f	f	1
430	D345	Cvo. CM Arequipa	2	2009-06-19	2308	f	f	f	f	1
413	D347	Cvo. Bco. Scotia Bank	2	2009-09-09	2308	f	f	f	f	1
267	D117	Coleg. Medico Gremial	2	\N	2308	t	t	t	f	1
444	D218	Pago Ind. Cambio de Clase	2	2007-04-16	2307	t	t	t	f	1
447	D227	SUTUSM	2	\N	2308	t	t	t	f	1
353	D311	SINDUSM-Cuota Sindical	2	2007-03-20	2308	f	f	f	f	1
367	D314	Pago Indebido (LCGH por ENF.)	2	2007-04-16	2307	t	t	t	f	1
433	D353	Inst. Desarrollo Gerencial	2	2010-04-26	2308	f	f	f	f	1
359	D349	L I B U N	2	2009-10-21	2308	f	f	f	f	1
525	I027	Tesoro AFP	1	\N	2302	t	t	t	f	1
424	D342	Fac. Med Vet-PATOS	2	2009-03-05	2308	t	t	t	f	1
472	D261	Congreso - Fac.Matematicas	2	2018-02-12	2308	t	t	t	f	1
446	D223	Dcto. Fac. Cs. Matematicas	2	\N	2308	t	t	t	f	1
530	D020	Colegio Medico-SEMEFA	2	2014-11-12	2308	t	t	t	f	1
606	D375	Pago Indeb. Incent. Invest.	2	2011-10-12	2307	f	f	f	f	1
659	D396	Examen Especial Viáticos	2	2013-05-15	2307	f	f	f	f	1
577	D399	Libre Desafiliación ONP	2	2013-07-05	2308	t	t	t	f	1
582	D406	Pago Indeb. Activ. Invest.	2	2014-05-12	2307	f	f	f	f	1
503	D125	FII-CEUPS Panaderia	2	2011-02-02	2308	t	t	t	f	1
658	D394	Retencion Coactiva	2	2013-04-17	2308	f	f	f	f	1
605	D374	SITRAUSM	2	2011-10-07	2308	f	f	f	f	1
506	D133	Fac. Letras y CCHH	2	2010-02-09	2308	t	t	t	f	1
586	D408	OCA-Seminario Admisión	2	2015-02-27	2308	f	f	f	f	1
705	D409	Infordata-Credito Informatico	2	2015-05-25	2308	f	f	f	f	1
497	D106	Cena Aniversario UNMSM	2	2019-05-27	2308	t	t	t	f	1
618	D372	CAFAE-Multa de elecciones	2	2011-09-12	2308	f	f	f	f	1
573	D387	Fac. Med Vet-Pollos	2	2012-06-04	2308	f	f	f	f	1
512	D147	Descuento D.U. 37	2	2006-08-14	2307	t	t	t	f	1
595	D385	Dscto. Examen Especial UNMSM	2	2012-05-15	2307	f	f	f	f	1
713	D416	UNMSM-Recup.Subv.OCA	2	2016-07-05	2308	f	f	f	f	1
706	D417	Fac. Med Vet-Codorniz	2	2016-08-24	2308	t	t	t	f	1
588	D382	OGBU-LentCenter	2	2012-04-03	2308	f	f	f	f	1
707	D418	Fac. CC Fisicas-CERSEU	2	2017-03-08	2308	f	f	f	f	1
714	D420	UNMSM-Recup.Subv.FE	2	2017-04-10	2308	f	f	f	f	1
504	D128	Dscto. por Susp. de Hab.	2	2006-07-07	2307	t	t	t	f	1
708	D428	Curso - Fac.Matematicas	2	2017-11-10	2308	f	f	f	f	1
610	D368	Fac. FIGMMG	2	2011-08-11	2308	f	f	f	f	1
711	D434	Fac. Ing.Sistemas - CENPRO ETIS	2	2019-01-10	2308	f	f	f	f	1
500	D118	Reversion Tesoro Publico	2	\N	2308	t	t	t	f	1
143	I028	D.S. 051-91	1	\N	2302	t	t	t	f	1
99	R003	Reintegro Remun. Basica	3	\N	2309	t	t	t	f	1
109	R025	Reintegro D.U. 80-94	3	2015-02-19	2309	t	t	t	f	1
53	R042	Reintegro Encargatura	3	\N	2309	t	t	t	f	1
110	R028	Reintegro D.U. 073-97	3	2006-10-23	2309	t	t	t	f	1
105	R017	Reintegro FEDU	3	\N	2309	t	t	t	f	1
106	R018	Reintegro D.S. 051-91	3	2015-02-04	2309	t	t	t	f	1
100	R004	Reint. Basica D.U.105-2001	3	\N	2309	t	t	t	f	1
107	R021	Reintegro D.S. 227-93	3	\N	2309	t	t	t	f	1
102	R010	Reint. Cheque Anulado	3	\N	2309	f	f	f	f	1
104	R014	Reintegro Remuneracion	3	2005-11-02	2309	t	t	t	f	1
115	I118	Deveng. Basica DU 105-01-EF	1	2010-12-09	2302	t	t	t	f	1
24	I065	Devengados 020-2004	1	2005-11-03	2302	f	f	f	f	1
23	I064	Devengados 044-2003	1	2005-11-03	2302	f	f	f	f	1
116	I119	Devengado D.U. 090-96	1	2010-12-15	2302	t	t	t	f	1
117	I120	Devengado D.U. 073-97	1	2010-12-15	2302	t	t	t	f	1
118	I121	Devengado D.U. 011-99	1	2010-12-15	2302	t	t	t	f	1
147	I037	D.L. 25671-92	1	\N	2302	t	t	t	f	1
54	I012	Cheque Anulado	1	2006-02-21	2302	f	f	f	f	1
146	I035	D.S. 19-94	1	\N	2302	t	t	t	f	1
148	I039	D.U. 090-96	1	\N	2302	t	t	t	f	1
130	R047	Reint. Remun. Vacac. Proporc.	3	\N	2309	t	t	t	f	1
144	I030	D.S. 194-92	1	\N	2302	t	t	t	f	1
145	I032	D.U. 37-94	1	2015-05-05	2302	t	f	f	f	1
761	D439	Dscto Voluntario - COVID	2	2020-06-02	2308	f	f	t	f	0
103	R011	Reintegro Aguinaldo	3	\N	2309	t	t	t	f	1
738	D414	Proy. Estudio CON-CON	2	2016-02-10	2307	f	f	f	f	1
722	D415	Fac. Med. Veterinaria	2	2016-02-24	2308	f	f	f	f	1
739	D419	UNMSM-Recup.Subv.EPG	2	2017-03-13	2308	f	f	f	f	1
716	D423	Contr.Serv - Fac.Odontología	2	2017-08-01	2308	f	f	f	f	1
717	D424	Symposium - Fac.Matematicas	2	2017-08-04	2308	f	f	f	f	1
749	D426	Pension Pre-UNMSM	2	2017-09-11	2308	f	f	f	f	1
748	D422	UNMSM-Recup.Subv.FD	2	2017-07-10	2308	f	f	f	f	1
723	D425	Fac. Ing.Sistemas-CERSEU	2	2017-09-06	2308	f	f	f	f	1
733	D427	Coop. Ahorro y Crédito San Miguel Ltda.	2	2017-09-18	2308	f	f	f	f	1
150	I043	Palmas Mag.	1	\N	2302	t	t	t	f	1
734	D430	UNMSM-Recup.Subv.FLCH	2	2018-02-12	2308	f	f	f	f	1
740	D431	Conferencia - Fac. Cs. Contables	2	2018-03-12	2308	f	f	f	f	1
752	D429	OGBU-Tai Loy	2	2018-01-31	2308	f	f	f	f	1
736	D433	EPS Sanitas Peru	2	2018-12-04	2308	f	f	f	f	1
152	I048	D.L. 817	1	2006-10-23	2302	t	t	t	f	1
742	D436	Regularizacion AFP	2	2019-06-13	2308	f	f	f	f	1
757	D437	Dscto.Fac.Matematica Evento	2	2019-10-11	2308	f	f	f	f	1
760	D438	Cong. Fac. Ing. de Sistemas	2	2019-12-06	2308	f	f	t	f	0
774	D443	Regular. AFP Prima	2	2021-11-03	2308	f	f	f	f	1
26	I069	Pension Orfandad	1	\N	2302	t	t	t	f	1
153	I050	Pension San Marcos	1	\N	2302	t	t	t	f	1
154	I054	L. 27617-02  PMV	1	2006-10-23	2302	t	t	t	f	1
142	I025	D.L. 25697-92	1	2006-10-23	2302	t	t	t	f	1
139	I106	D.S. 014-2009-EF	1	2009-02-24	2301	t	t	t	f	1
290	R051	Reint. L. 28449-2005	3	\N	2309	t	t	t	f	1
206	R054	Reint. D.S. 0106-2005-EF	3	2005-11-03	2309	t	t	t	f	1
178	R060	Reint. Tesoro AFP	3	2006-08-28	2309	t	t	t	f	1
300	R005	Reintegro Remun. Reunificada	3	\N	2309	t	t	t	f	1
377	R085	Reint. Hom.Trans.( D.U. 033-05) 3º Inc.	3	2007-08-28	2309	t	t	t	f	1
195	R091	REINT. D.S.077-2010-EF	3	2010-03-12	2309	t	t	t	t	1
369	R084	Reint.DS 039-2007-EF	3	2007-04-26	2309	t	t	t	f	1
162	R055	Reint. Homolog. Trans. (D.U. 033-05)	3	2006-03-20	2309	t	t	t	f	1
302	R015	Reintegro D.S. 276	3	\N	2309	f	f	f	f	1
177	R059	Reint. D.S. 106-2005-EF CONT	3	2006-08-25	2309	f	f	f	f	1
301	R008	Reintegro Bonific. Familiar	3	\N	2309	t	t	t	f	1
291	R052	Reint. D.S. 016-2005-EF	3	2006-10-23	2309	t	t	t	f	1
304	R026	Reintegro D.L. 25671-92	3	2015-03-18	2309	t	t	t	f	1
175	R057	Reint. D.S. 021-92	3	2006-07-25	2309	f	f	f	f	1
303	R023	Reintegro D.S. 081-93	3	2015-02-05	2309	t	t	t	f	1
227	I081	Devengado D.S. 106-2005-EF CONT	1	2007-01-29	2302	f	f	f	f	1
226	I074	Devengado D.S. 021-92	1	2006-02-25	2302	f	f	f	f	1
319	I017	Devengados	1	2006-05-29	2302	t	t	t	f	1
321	I021	Compensacion Vacacional	1	2006-10-23	2302	t	t	t	f	1
313	I045	Devol. Dscto. Indebido	1	2011-05-26	2302	f	f	f	f	1
320	I019	D.S. 19-90	1	\N	2302	t	t	t	f	1
311	I031	D.S. 227-93	1	\N	2302	t	t	t	f	1
182	I076	Hom.Transitoria ( D.U. 033-05)	1	2006-03-13	2302	t	t	t	f	1
174	I078	Hom.Trans.(DU.033-05) 2ºInc.	1	2006-06-22	2302	t	t	t	f	1
375	I087	D.L. 559-1990	1	2007-08-17	2302	t	t	t	f	1
435	D348	 D940 Asoc.Ces.Adm.Cuota Excepcional	2	2009-10-02	2308	f	f	f	f	1
314	I053	ENCARGATURA	1	\N	2302	t	t	t	f	1
382	I091	Hom.Tran.DU.033-05 3º-Ley.29137	1	2007-12-14	2302	t	t	t	f	1
203	I066	Reajuste Minima Vital-Art 32	1	\N	2302	t	t	t	f	1
292	I060	L. 28449-2005	1	\N	2302	t	t	t	f	1
397	I095	Bonif. Inc.B Art. 34 Ley 28449	1	2008-09-29	2302	t	t	t	f	1
318	I063	Pension Definitiva Sobrev.Viudez	1	2010-11-10	2302	t	t	t	f	1
212	I062	Pension Definitiva por Cesantia	1	\N	2302	t	t	t	f	1
785	D445	EPS RIMAC INTERNACIONAL	2	2023-07-21	2308	f	f	f	f	1
794	D448	Dsct. Pago Indebido Sepelio y Luto	2	2023-09-18	2307	t	t	t	t	1
380	I090	Pensión Provisional de Cesantía	1	2007-10-03	2301	t	t	t	f	1
176	I080	D.S. 110-2006-EF	1	2006-08-16	2302	t	t	t	f	1
368	I084	D.S.039-2007-EF	1	2007-04-26	2301	t	t	t	f	1
119	I122	Homol.Ultimo Tramo (EXP.)	1	2011-01-14	2302	t	t	t	f	1
309	I020	Remuneracion Vacacional	1	2019-01-29	2302	t	t	t	f	1
400	I096	D.S. 120-2008-EF	1	2008-11-06	2301	t	t	t	f	1
456	R016	Reintegro Refrigerio/Movilidad	3	\N	2309	t	t	t	f	1
522	R037	Reintegro Pension	3	2007-11-29	2309	t	t	t	f	1
516	R012	Reintegro Escolaridad	3	\N	2309	f	f	f	f	1
478	R049	Reint. D.S. 020-2004-EF	3	\N	2309	f	f	f	f	1
457	R020	Reintegro D.S. 194-92	3	\N	2309	t	t	t	f	1
458	R022	Reintegro D.U. 37-94	3	\N	2309	f	f	f	f	1
554	R083	Reintegro DS 110-2006-EF	3	2006-09-27	2309	t	t	t	f	1
460	R029	Reintegro D.U. 011-99	3	2006-10-23	2309	t	t	t	f	1
551	R058	Reint.Hom.Trans.(D.U.033-05)2º Incr.	3	2006-07-25	2309	t	t	t	f	1
453	R006	Reintegro T.P.H.	3	\N	2309	t	t	t	f	1
517	R019	Reintegro D.L. 26504	3	\N	2309	t	t	t	f	1
463	R041	Reintegro Cambio de Clase	3	2014-05-20	2309	t	t	t	f	1
459	R027	Reintegro D.U. 090-96	3	2006-10-23	2309	t	t	t	f	1
454	R009	Reintegro Bonific. Diferencial	3	\N	2309	t	t	t	f	1
425	R088	Reintegro D.S. 014-2009-EF	3	2009-03-11	2309	t	t	t	f	1
414	I114	Dev. Aguinaldo (NO AFECTO)	1	2010-01-26	2302	f	f	f	t	1
419	I105	Devengado Escolaridad	1	2009-01-28	2302	f	f	f	f	1
548	I073	Devengado D.S. 106-2005-EF	1	2006-01-31	2302	t	t	t	f	1
408	I103	Devengado Hom.Trans.(D.U. 033-05)2º Inc.	1	2009-01-28	2302	t	t	t	f	1
550	I075	Devengado D.S. 276	1	2006-02-28	2302	f	f	f	f	1
526	I034	D.S. 081-93	1	\N	2302	t	t	t	f	1
537	I036	D.U. 80-94	1	\N	2302	t	t	t	f	1
518	R030	Reint. Comp. Vacacional	3	2009-03-26	2309	t	t	t	f	1
482	I008	Bonificacion Familiar	1	\N	2302	t	t	t	f	1
481	I005	Remun. Reunificada	1	\N	2301	t	t	t	f	1
561	I002	Basica D.U.105-2001	1	2005-11-02	2301	t	t	t	f	1
780	I221	D.L. 25981-1992	1	2023-03-13	2301	t	\N	\N	\N	1
538	I040	D.U. 073-97	1	\N	2302	t	t	t	f	1
541	I052	Pension No Nivelable	1	\N	2302	t	t	t	f	1
560	I001	R. Basica/Jornal Basico	1	2005-10-09	2301	t	t	t	f	1
563	I006	Trans. para Homologar	1	\N	2301	t	t	t	f	1
564	I007	Bonificacion Personal	1	\N	2302	t	t	t	f	1
535	I029	D.L. 26504	1	2006-10-23	2302	t	t	t	f	1
567	I015	Escolaridad	1	\N	2302	f	f	f	t	1
527	I049	Pension M. Salud	1	\N	2302	t	t	t	f	1
524	I016	Pension Alicuota	1	\N	2302	t	t	t	f	1
469	I051	Pension INEI	1	\N	2302	t	t	t	f	1
562	I004	Otras Pensiones	1	\N	2302	t	t	t	f	1
536	I033	D.S. 040-92	1	\N	2302	t	t	t	f	1
436	I100	Pensión Provisional de Orfandad	1	2009-01-27	2301	t	t	t	f	1
553	I077	D.S. 017-2005-EF	1	2006-05-09	2302	t	t	t	f	1
523	I009	Remuneracion Mensual	1	\N	2302	t	t	t	f	1
565	I010	Bonif. Diferenc./Otr Emp.Perm	1	\N	2302	t	t	t	f	1
466	I116	D.S.077-2010-EF	1	2010-03-12	2301	t	t	t	f	1
585	R104	Reint. D.S. 19-94	3	2015-02-01	2309	t	t	t	f	1
683	R102	Reint. D.L. 25697-92	3	2015-02-04	2309	t	t	t	f	1
602	R092	Reintegro Homol.Ultimo Tramo (EXP.)	3	2011-02-23	2309	t	t	t	f	1
581	R097	Reint. DS 003-2014-EF	3	2014-01-27	2309	t	t	t	f	1
570	R094	Reint. DS 024-2012-EF	3	2012-02-08	2309	t	t	t	f	1
590	R095	Restit. Pension	3	2012-08-13	2309	f	f	f	f	1
666	R107	Reint. D.S. 120-2008-EF	3	2015-02-05	2309	t	t	t	f	1
681	R100	Reint. Basica/Jornal Basico	3	2015-02-04	2309	t	t	t	f	1
682	R101	Reint. Trans. para Homologar	3	2015-02-04	2309	t	t	t	f	1
664	R106	Reint. Remuneracion al Cargo	3	2015-02-05	2309	t	t	t	f	1
684	R103	Reint. D.L. 26504	3	2015-02-04	2309	t	t	t	f	1
685	I142	Dev. R. Basica/Jornal Basico	1	2015-02-04	2302	t	t	t	f	1
630	I166	Dev. Homol.Ultimo Tramo (EXP.)	1	2015-02-06	2302	t	t	t	f	1
672	I162	Dev. D.S. 19-90	1	2015-02-05	2302	t	t	t	f	1
655	I181	Dev. D.U. 80-94	1	2015-02-15	2302	t	t	t	f	1
668	I158	Dev. D.S. 081-93	1	2015-02-05	2302	t	t	t	f	1
651	I178	Dev. D.L. 25671-92	1	2015-02-15	2302	t	t	t	f	1
621	I130	Deveng. Pension Definitiva	1	2012-03-23	2302	t	t	t	f	1
665	I156	Dev. Remuneracion al Cargo	1	2015-02-05	2302	t	t	t	f	1
644	I173	Dev. D.S. 19-94	1	2015-02-15	2302	t	t	t	f	1
662	I155	Dev. Tesoro AFP	1	2015-02-04	2302	t	t	t	f	1
633	I132	Dev. Encargatura	1	2012-04-26	2302	t	t	t	f	1
629	I165	Dev. Hom.Trans. ( D.U. 033-05) 3º Inc.	1	2015-02-06	2302	t	t	t	f	1
572	I128	Deveng. Bonif. Diferenc./Otr. Emp.Perm	1	2012-02-10	2302	t	t	t	f	1
781	I226	Reaj. Pension Mandato Judicial	1	2023-04-19	2301	t	\N	\N	\N	1
661	I140	Aguinaldo - DU 004-14	1	2014-11-27	2302	f	f	f	t	1
676	I133	Bonif. R.M.V.	1	2012-08-02	2302	t	t	t	f	1
615	I123	D.S.031-2011-EF	1	2011-03-04	2301	t	t	t	f	1
624	I136	D.S.004-2013-EF	1	2013-01-18	2301	t	t	t	f	1
583	I141	D.S.002-2015-EF	1	2015-01-12	2301	t	t	t	f	1
580	I138	D.S.003-2014-EF	1	2014-01-16	2301	t	t	t	f	1
745	R114	Reint. DS 020-2017-EF	3	2017-02-14	2309	t	t	t	f	1
731	R113	Reint. DS 005-2016-EF	3	2016-02-04	2309	t	t	t	f	1
696	I153	Dev. D.U. 37-94	1	2015-02-04	2302	f	f	f	f	1
694	I151	Dev. D.S. 194-92	1	2015-02-04	2302	t	t	t	f	1
690	I147	Dev. Refrigerio/Movilidad	1	2015-02-04	2302	t	t	t	f	1
691	I148	Dev. FEDU	1	2015-02-04	2302	t	t	t	f	1
688	I145	Dev. Bonificacion Personal	1	2015-02-04	2302	t	t	t	f	1
689	I146	Dev. Bonificacion Familiar	1	2015-02-04	2302	t	t	t	f	1
693	I150	Dev. D.L. 25697-92	1	2015-02-04	2302	t	t	t	f	1
141	I023	D.S. 276	1	2006-05-11	2302	f	f	f	f	1
695	I152	Dev. D.S. 227-93	1	2015-02-04	2302	t	t	t	f	1
692	I149	Dev. D.S. 051-91	1	2015-02-04	2302	t	t	t	f	1
697	I154	Dev. D.L. 26504	1	2015-02-04	2302	t	t	t	f	1
732	I183	Intereses Legales	1	2016-10-21	2302	f	f	f	f	1
746	I185	D.S. 0103-2017-EF	1	2017-04-19	2302	t	t	t	f	1
709	I189	D.S. 0350-2017-EF	1	2017-12-04	2302	t	t	t	f	1
724	I186	Devol.Dscto. D.U. 37-94	1	2017-09-15	2302	f	f	f	f	1
725	I188	D.S.208-2017-EF	1	2017-11-17	2301	t	t	t	f	1
751	I190	D.S.011-2018-EF	1	2018-01-29	2301	t	t	t	f	1
718	R116	Reint. DS 011-2018-EF	3	2018-05-14	2309	t	t	t	f	1
727	I191	D. S. 418-2017-EF	1	2018-07-03	2301	t	t	t	f	1
720	I194	D.S.009-2019-EF	1	2019-01-21	2301	t	t	t	f	1
737	I195	Dev. D.S. 011-2018-EF	1	2019-02-12	2302	t	t	t	f	1
758	I197	MUC - Docente Ordinario	1	2019-09-25	2301	t	t	t	f	1
759	I198	Comp.Econ.-DS.138-2014-EF	1	2019-10-09	2301	t	t	t	f	1
765	I200	Dev. D.S. 009-EF-2019	1	2020-01-20	2302	f	f	f	f	1
766	I201	D.S.006-2020-EF	1	2020-02-03	2301	t	t	t	f	1
741	R119	Reint. DS 009-2019-EF	3	2019-03-11	2309	t	t	t	f	1
770	I205	D.S.006-2021-EF	1	2021-01-22	2301	t	t	t	f	1
542	I055	D.S. 044-2003	1	\N	2302	f	f	f	f	1
779	I207	D.S. 014-2022-EF	1	2021-02-08	2301	t	t	t	f	1
204	I068	D.S. 0107-2005-EF	1	2005-10-14	2302	f	f	f	f	1
788	I209	MONTO ÚNICO CONSOLIDADO        (DU 320-2022)	1	2023-08-16	2301	t	t	t	f	1
784	I215	D.S. 311-2022-EF	1	2023-07-18	2302	t	t	t	f	1
783	I219	D.S.007-2023-EF	1	2023-02-01	2301	t	t	t	f	1
782	I227	Pension Inicial	1	2023-05-02	2301	t	\N	\N	\N	1
128	I057	L. 28254-2004	1	\N	2302	f	f	f	f	1
376	I088	D.S. 153-91-EF	1	2007-08-17	2302	f	f	f	f	1
186	I079	D.S. 0106-2005-EF CONT	1	2006-08-01	2301	f	f	f	f	1
532	I018	D.S. 021-92	1	2005-10-12	2302	f	f	f	f	1
744	I184	D.S.020-2017-EF	1	2017-02-14	2301	t	t	t	f	1
39	D061	Pago Ind. Escolaridad	2	2007-04-16	2307	t	t	t	f	1
8	D169	PAGO IND.DE PENSION	2	2008-02-07	2307	t	t	t	f	1
191	D179	Pago Ind. Aguinaldo	2	2007-04-16	2307	t	t	t	f	1
75	D211	Credito Capac Yupanqui	2	\N	2308	t	t	t	f	1
29	D288	Asoc. Profesores Emeritos	2	2005-11-07	2308	t	t	t	f	1
787	I210	BET FIJO NO IMPONIBLE	1	2023-08-16	2302	f	f	f	f	1
791	I217	BET V. BONIF. DIF. TEMPORAL	1	2023-08-16	2302	f	f	f	f	1
786	I220	BET V. OTROS DET. POR LA DGGFRH	1	2023-08-16	2302	f	f	f	f	1
789	I216	BET V. BONIF. FAMILIAR	1	2023-08-16	2302	f	f	f	f	1
798	R126	Reint. MONTO ÚNICO CONSOLIDADO	3	2023-10-31	2309	t	t	f	f	1
797	R127	Reint. BENEF. EXTR. TRANSITORIO	3	2023-10-31	2309	f	f	f	f	1
792	R128	Reint. BET V. BONIF. DIFERENCIAL	3	2023-08-24	2309	f	f	f	f	1
46	D085	OGBU-Comedor	2	2010-02-23	2308	t	t	t	f	1
81	D221	Post Grado Medicina	2	\N	2308	t	t	t	f	1
12	D173	Jorn. Invs. en Salud	2	\N	2308	t	t	t	f	1
56	D060	Pago Ind. Asignac. 25/30 años	2	2007-04-16	2307	t	t	t	f	1
9	D170	Adeudo SNP	2	\N	2307	t	t	t	f	1
78	D216	Fac. Derecho y CCPP	2	2010-02-09	2308	t	t	t	f	1
325	D017	Asoc.Ces.Docentes	2	2011-01-21	2308	t	t	t	f	1
234	D045	Mas Vida-EsSalud	2	2007-06-12	2308	t	t	t	f	1
247	D067	FFIP-Prestamo	2	2010-02-03	2308	t	t	t	f	1
326	D018	SUOSM-Cuota Sindical	2	2014-04-08	2308	t	t	t	f	1
237	D049	R.G.A.	2	\N	2307	t	t	t	f	1
274	D127	Dscto. LSGH (dias)	2	\N	2307	t	t	t	f	1
215	D166	Reg. Hrs. No Lab./ Tardanzas	2	\N	2308	t	t	t	f	1
294	D226	Dcto. Fac. Odontologia	2	\N	2308	t	t	t	f	1
207	D290	Post Grado Fac. Ing. GMMG	2	2005-12-09	2308	t	t	t	f	1
235	D047	CAFAE-Administrativo	2	2010-06-25	2308	t	t	t	f	1
238	D051	CEPUSM	2	\N	2308	t	t	t	f	1
246	D065	CAFAE Docente	2	\N	2308	t	t	t	f	1
279	D136	CEPUSM Extraordinario	2	\N	2308	t	t	t	f	1
296	D233	Autoseguro Accidentes Personal	2	\N	2308	t	t	t	f	1
244	D059	Dscto. Bonif. Diferencial	2	2006-08-14	2307	t	t	t	f	1
219	D185	Fac. CC Fisicas-U.Post Grado	2	2008-12-11	2308	t	t	t	f	1
225	D202	Col. Odont. Lima	2	\N	2308	t	t	t	f	1
205	D286	Dscto. Fac. Ing. Elec.	2	\N	2308	t	t	t	f	1
245	D063	Fac. Med Vet-PAVOS	2	2008-11-04	2308	t	t	t	f	1
218	D183	Reg. Mas Vida	2	2007-06-12	2308	t	t	t	f	1
242	D056	Dscto. P.I. Comp. Vac.	2	2006-08-14	2307	t	t	t	f	1
58	I042	Art.18	1	\N	2302	t	t	t	f	1
543	D004	Descuento Judicial	2	2014-09-08	2303	t	t	t	f	1
310	I024	Refrigerio/Movilidad	1	\N	2301	t	t	t	f	1
157	D006	Coop CSETUNMSM (ex CACTUSM)	2	2006-04-28	2308	t	t	t	f	1
584	R099	Reint. DS 002-2015-EF	3	2015-01-12	2309	t	t	t	f	1
464	R045	Reint. D.S. 044-2003	3	\N	2309	f	f	f	f	1
163	R056	Reint. D.S. 0107-2005-EF	3	2006-03-24	2309	f	f	f	f	1
108	R024	Reintegro D.S. 019-90	3	2015-02-05	2309	t	t	t	f	1
405	R086	Reint. Hom. Trans.3  Inc.-L29137	3	2008-12-18	2309	t	t	t	f	1
747	R115	Reint. DS 103-2017-EF	3	2017-04-21	2309	t	t	t	f	1
531	R053	Reint. Pension Sobrev.Viudez	3	2007-07-13	2309	t	t	t	f	1
192	R090	Reint.Aguinaldo          (NO AFECTO)	3	2009-08-24	2309	f	f	f	t	1
607	R093	Reint. DS 031-2011-EF	3	2011-03-18	2309	t	t	t	f	1
160	I071	Devengado L. 28254-04	1	2006-01-31	2302	f	f	f	f	1
686	I143	Dev. Remun. Reunificada	1	2015-02-04	2302	t	t	t	f	1
634	I135	Devengado Aguinaldo	1	2012-11-26	2302	t	t	t	f	1
55	D010	Asoc CAYNA	2	\N	2308	t	t	t	f	1
687	I144	Dev. Trans. para Homologar	1	2015-02-04	2302	t	t	t	f	1
161	I072	Devengado D.S. 107-2005-EF	1	2006-01-31	2302	f	f	f	f	1
316	D016	Asoc.Ces.Administrativos	2	2011-01-21	2308	t	t	t	f	1
331	D025	SOPERFI	2	\N	2308	t	t	t	f	1
568	D038	A.P.V.E.S.M.	2	\N	2308	t	t	t	f	1
33	D039	FFIP-Fondo de Fallecimiento	2	2010-02-03	2308	t	t	t	f	1
4	D164	Pago Ind. Investigacion	2	2005-11-11	2307	t	t	t	f	1
726	D432	D.G.Resp.Social Univ.	2	2018-04-04	2308	f	f	f	f	1
452	D236	Asoc.Ces.Adm-FAES	2	2010-06-25	2308	t	t	t	f	1
402	D335	Cvo. Banco GNB Perú S.A.	2	2008-12-03	2308	f	f	f	f	1
632	D378	Cvo. Caja Metropolitana Lima	2	2012-02-06	2308	f	f	f	f	1
640	D391	Obs. Homolog. - MEF	2	2013-01-15	2307	f	f	f	f	1
474	D266	Dcto. Fac. G.M.M.C.G.	2	\N	2308	t	t	t	f	1
635	D400	Cvo. Banbif	2	2013-07-10	2308	f	f	f	f	1
636	D407	RRHH-ODBS Campaña Visual	2	2014-09-04	2308	f	f	f	f	1
390	D327	Serv.Telefonia IP-Red Telematica	2	2008-06-05	2308	f	f	f	f	1
396	D331	Cuarta Categoria	2	2008-08-27	2308	f	f	f	f	1
398	D332	Vice-Invest Cursos	2	2008-10-14	2308	f	f	f	f	1
623	D384	Centro de Informatica UNMSM	2	2012-05-15	2308	f	f	f	f	1
631	D410	Resp.Economica-DREC	2	2015-07-10	2308	f	f	f	f	1
637	D411	Of.Centr. Calidad Académica y Acreditación	2	2015-07-22	2308	f	f	f	f	1
393	D329	Reg. Inasistencias	2	\N	2308	t	t	t	f	1
613	D366	Fac. CC Economicas-Post Grado	2	2011-05-13	2308	f	f	f	f	1
101	R007	Reintegro Bonific. Personal	3	\N	2309	t	t	t	f	1
743	D413	Escuela de Posgrado-Congreso	2	2015-10-13	2308	f	f	f	f	1
25	I067	D.S. 0106-2005-EF	1	2005-10-13	2301	t	t	t	f	1
214	I056	D.S. 020-2004-EF	1	2006-10-23	2301	f	f	f	f	1
559	R050	Reint. L. 28254-2004	3	\N	2309	f	f	f	f	1
411	I104	Devengado Hom.Trans. Ley 29137	1	2009-01-28	2302	t	t	t	f	1
592	R096	Reint. DS 004-2013-EF	3	2013-02-14	2309	t	t	t	f	1
622	I131	Deveng. Pension Provisional	1	2012-03-23	2302	t	t	t	f	1
656	I126	D.S.024-2012-EF	1	2012-02-08	2301	t	t	t	f	1
767	I202	Deveng. Bonificaciones Especiales	1	2020-03-11	2302	t	t	t	f	1
432	I110	Aguinaldo                                       (NO AFECTO)	1	\N	2302	f	f	f	t	1
37	D054	Dscto. Bonif. Personal	2	2006-08-14	2307	t	t	t	f	1
297	D240	Adeudo Administracion Central	2	\N	2308	t	t	t	f	1
410	I102	Devengado Hom.Trans.(D.U. 033-05)	1	2009-01-28	2302	t	t	t	f	1
753	R118	Reint. D. S. 418-2017-EF	3	2018-07-17	2309	t	t	t	f	1
201	D282	Coop. Ahorro y Credito ATLANTIS Ltda.	2	2015-01-26	2308	t	t	t	f	1
392	D328	Cvo. Bco. Comercio	2	2008-08-07	2308	f	f	f	f	1
778	I206	D.U. 105-2021-Bono Extra.	1	2021-11-26	2301	t	t	t	f	1
268	D119	Dscto hrs no laboradas/Tardanzas	2	2014-08-19	2308	t	t	t	f	1
594	I129	Compensacion Vacacional - CAS	1	2012-03-04	2302	t	t	t	f	1
183	D303	Colegio de Biólogos	2	2006-05-08	2308	f	f	f	f	1
790	I218	BET V. BONIF. DIF. PERMANENTE	1	2023-08-16	2302	f	f	f	f	1
514	D247	Cent.Prod.Edit.e Imprenta	2	\N	2308	t	t	t	f	1
641	D393	Pago Ind. Remuneracion	2	2013-04-08	2307	f	f	f	f	1
200	D279	Curso Capacitacion OGRRHH	2	2007-03-14	2308	t	t	t	f	1
83	D225	Pago Ind. D.U. 105-2001	2	2006-01-18	2307	t	t	t	f	1
483	I011	Remuneracion al Cargo	1	\N	2302	t	t	t	f	1
730	D412	Fac.Farm y Bioq-Optica Valeria	2	2015-09-24	2308	f	f	f	f	1
591	D389	Teletón	2	2012-09-26	2308	f	f	f	f	1
395	I094	D.Leg. 1057-2008	1	\N	2301	t	t	t	f	1
715	D421	San Cristobal Libros S.A.C.	2	2017-07-10	2308	f	f	f	f	1
138	I089	Hom.Trans. ( D.U. 033-05) 3º Inc.	1	2007-08-28	2302	t	t	t	f	1
298	D244	Dcto. Fac. Cs. Fisicas	2	\N	2308	t	t	t	f	1
136	D267	UNMSM - Recup. Admision	2	\N	2308	t	t	t	f	1
793	D449	Regularizacion EPS Rimac Internacional	2	2023-09-15	2308	f	f	f	f	1
409	I101	Pensión Provisional de Viudez	1	2009-01-27	2301	t	t	t	f	1
52	I061	D.S. 016-2005-EF	1	2006-10-23	2302	t	t	t	f	1
721	I182	D.S.005-2016-EF	1	2016-01-22	2301	t	t	t	f	1
799	I232	D.S. 313-2023-EF	1	2024-01-09	2302	t	t	t	f	1
16	D032	AFP Union	2	\N	2300	t	t	t	f	1
125	D256	F.Pensiones (patronal)	2	\N	2300	t	t	t	f	1
126	D257	S.N.Pensiones (patronal)	2	\N	2300	t	t	t	f	1
365	D312	ESSALUD Comp.( RS 183-05-SUNAT)	2	2007-04-04	2300	f	f	f	f	1
467	D255	FONAVI	2	\N	2300	t	t	t	f	1
155	D001	Fondo de Pensiones	2	\N	2300	t	t	t	f	1
198	D033	AFP UNion Vida	2	2006-12-12	2300	t	t	t	f	1
28	D287	AFP Prima	2	2010-06-25	2300	t	t	t	f	1
332	D026	AFP Horizonte	2	\N	2300	t	t	t	f	1
333	D028	AFP ProFuturo	2	\N	2300	t	t	t	f	1
335	D030	AFP Integra	2	\N	2300	t	t	t	f	1
626	D398	AFP Habitat	2	2013-07-01	2300	t	t	t	f	1
528	D002	Sistema Nacional de Pensiones	2	\N	2300	t	t	t	f	1
\.


--
-- Data for Name: planilla; Type: TABLE DATA; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COPY qubytss_rrhh.planilla (id_planilla, id_planilla_plantilla, id_tipo_planilla, id_tipo_trabajador, id_estado_personal_pla, id_clasificador, est_planilla, id_anio, id_mes, num_planilla, tit_planilla, obs_planilla, id_persona_registro, id_persona_proceso, id_persona_transf, id_persona_cierre, fech_cierre_pla, sys_fech_registro, fech_transf) FROM stdin;
1	\N	1	2	\N	\N	1	2024	02	PL20240201202	\N	\N	\N	\N	\N	\N	\N	2024-02-18 23:59:22.626614	\N
2	\N	1	1	\N	\N	1	2024	02	PL20240201106	\N	\N	\N	\N	\N	\N	\N	2024-02-19 00:22:08.582644	\N
3	\N	2	3	\N	\N	1	2024	02	PL20240203301	\N	\N	\N	\N	\N	\N	\N	2024-02-19 03:17:23.504114	\N
4	\N	2	3	\N	\N	1	2024	02	PL20240203304	\N	\N	\N	\N	\N	\N	\N	2024-02-19 03:17:24.953488	\N
\.


--
-- Data for Name: planilla_tipo; Type: TABLE DATA; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COPY qubytss_rrhh.planilla_tipo (id_tipo_planilla, cod_tipo_pla, nomb_tipo_pla, est_tipo_pla) FROM stdin;
8	08	SUBVENCION	1
6	06	SUBSIDIOS	1
5	02	ESPECIAL	1
4	04	JUDICIAL	1
3	07	OCASIONAL	1
2	03	ADICIONAL	1
1	01	NORMAL	1
9	09	ESSALUD	1
\.


--
-- Data for Name: planilla_trabajador; Type: TABLE DATA; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COPY qubytss_rrhh.planilla_trabajador (id_planilla, id_persona, id_corr_trab, id_unidad, id_area, id_tipo_personal_pla, id_estado_personal_pla, id_condicion_pla, id_categoria_pla, id_cargo_laboral, id_regimen_salud, id_regimen_pension, id_regimen_pension_estado, fech_ingreso, fech_cese, declaracion_jurada, tipo_pago, id_banco, num_cuenta_banco, cuspp, num_regimen_salud, situacion, observacion, id_sub_subvencion, is_monto_excedente) FROM stdin;
1	6	1	\N	\N	2	\N	\N	\N	\N	44975	44969	2603	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
1	48	9	\N	\N	2	\N	\N	\N	\N	44977	44970	2602	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
1	48	8	\N	\N	2	\N	\N	\N	\N	44979	44971	2600	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
1	48	5	\N	\N	2	\N	\N	\N	\N	44979	44972	2602	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
1	48	2	\N	\N	2	\N	\N	\N	\N	44980	44969	2602	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
2	48	7	\N	\N	1	\N	\N	\N	\N	44978	44970	2602	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
2	48	6	\N	\N	1	\N	\N	\N	\N	44978	44968	2602	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
3	48	3	\N	\N	3	\N	\N	\N	\N	44979	44971	2601	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
3	48	4	\N	\N	3	\N	\N	\N	\N	44978	44971	2600	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
4	48	3	\N	\N	3	\N	\N	\N	\N	44979	44971	2601	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
4	48	4	\N	\N	3	\N	\N	\N	\N	44978	44971	2600	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: planilla_trabajador_concepto; Type: TABLE DATA; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COPY qubytss_rrhh.planilla_trabajador_concepto (id_planilla, id_persona, id_corr_trab, id_concepto, monto_conc, tipo_conc_pla, id_registro, id_corr_fase, id_grupo, id_clasificador) FROM stdin;
1	6	1	483	1500.0000	\N	\N	\N	\N	\N
1	48	9	483	1500.0000	\N	\N	\N	\N	\N
1	48	8	483	1500.0000	\N	\N	\N	\N	\N
1	48	5	483	1500.0000	\N	\N	\N	\N	\N
1	48	2	483	1500.0000	\N	\N	\N	\N	\N
2	48	7	483	1500.0000	\N	\N	\N	\N	\N
2	48	6	483	1500.0000	\N	\N	\N	\N	\N
3	48	3	483	1500.0000	\N	\N	\N	\N	\N
3	48	4	483	1500.0000	\N	\N	\N	\N	\N
4	48	3	483	1500.0000	\N	\N	\N	\N	\N
4	48	4	483	1500.0000	\N	\N	\N	\N	\N
\.


--
-- Data for Name: trabajador; Type: TABLE DATA; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COPY qubytss_rrhh.trabajador (id_persona, id_corr_trab, cod_trab, estado_trabajador, id_tipo_trabajador, id_situacion_educativa, id_ocupacion, has_discapacidad, id_condicion_laboral, renta_quinta_exo, sujeto_a_regimen, sujeto_a_jornada, sujeto_a_horario, periodo_remuneracion, situacion, id_situacion_especial, tipo_pago, id_tipo_cuent_banco, id_banco_sueldo, num_cuenta_banco_sueldo, num_cuenta_banco_sueldo_cci, id_banco_cts, num_cuenta_banco_cts, fech_ingreso, id_doc_ingreso, fech_doc_ingreso, num_doc_ingreso, mot_ingreso, fech_registro_sis, fech_salida, id_motivo_salida, id_tipo_prestador, fech_ingreso_salud, id_regimen_salud, num_regimen_salud, id_entidad_salud, fech_ingreso_pension, id_regimen_pension, id_regimen_pension_estado, cuspp, is_cod_generado_sys, id_persona_registro, id_filefoto) FROM stdin;
6	3	0A0006	1	0	0	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	0	20296	\N	324324	342432	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	44980	32432	\N	\N	44970	2600	324324	\N	\N	\N
6	4	0A0007	1	0	0	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	0	20451	\N	3243232	324324	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	44980	324324	\N	\N	44971	2601	3243243	\N	\N	\N
6	2	0A0089	1	0	0	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	0	20451	\N	34343	43232	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	44979	43243	\N	\N	44973	2602	3243422	\N	\N	\N
6	5	0A0008	1	0	0	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	0	20450	\N	3432	32432432	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	44978	32432	\N	\N	44971	2601	324324	\N	\N	\N
6	6	0A00438	1	0	0	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	0	20450	\N	324324	43232	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	44979	3243243	\N	\N	44970	2600	4324	\N	\N	\N
6	7	435435	1	0	0	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	0	20450	\N	32432432	324324324	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	44980	32432	\N	\N	44973	2600	324324	\N	\N	\N
45	1	0A0009	0	1	0	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	0	20492	\N	324343	34343434	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	44974	323	\N	\N	44973	2602	3243242	\N	\N	\N
6	1	0A0004	1	2	0	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	0	1700	\N	323243232	4324323243232	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	44975	32432432432	\N	\N	44969	2603	3242432	\N	\N	\N
48	1	423432	0	3	0	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	0	1745	\N	34324	343243342	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	44978	3244324	\N	\N	44968	2602	324324	\N	\N	\N
65	1	32432	0	2	0	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	0	1745	\N	32424	32432432	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	44974	324324	\N	\N	44967	2602	324324	\N	\N	\N
73	1	23432	0	3	0	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	0	1699	\N	3242432	43243243324	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	44979	324432	\N	\N	44970	2601	324323243	\N	\N	\N
48	9	5466	1	2	0	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	0	1722	\N	34324	32432434	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	44977	4324324	\N	\N	44970	2602	3243243	\N	\N	\N
48	7	32434	1	1	0	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	0	1745	\N	34324	34243434	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	44978	4324324	\N	\N	44970	2602	3432432	\N	\N	\N
48	3	0A0324	1	3	0	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	0	1739	\N	32432	4324324	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	44979	4324324	\N	\N	44971	2601	4324324	\N	\N	\N
48	6	324324	1	1	0	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	0	1731	\N	343243	343243	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	44978	3243243	\N	\N	44968	2602	32432	\N	\N	\N
48	4	0A039824	1	3	0	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	0	1723	\N	324324	343243243	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	44978	4324324	\N	\N	44971	2600	4324324	\N	\N	\N
48	8	23213	1	2	0	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	0	1699	\N	34324	4324324	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	44979	324324	\N	\N	44971	2600	3243	\N	\N	\N
48	5	3243	1	2	0	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	0	1745	\N	432432432	34343432	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	44979	4324324	\N	\N	44972	2602	3243243	\N	\N	\N
48	2	0A00548	1	2	0	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	0	1723	\N	324324	3242432	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	44980	324324	\N	\N	44969	2602	4324324	\N	\N	\N
\.


--
-- Data for Name: trabajador_concepto; Type: TABLE DATA; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COPY qubytss_rrhh.trabajador_concepto (id_persona, id_corr_trab, id_concepto, monto_conc) FROM stdin;
6	3	483	1500.00
6	4	483	1500.00
6	2	483	1500.00
6	5	483	1500.00
6	6	483	1500.00
6	7	483	1500.00
45	1	483	1500.00
6	1	483	1500.00
48	1	483	1500.00
65	1	483	1500.00
73	1	483	1500.00
48	9	483	1500.00
48	7	483	1500.00
48	3	483	1500.00
48	6	483	1500.00
48	4	483	1500.00
48	8	483	1500.00
48	5	483	1500.00
48	2	483	1500.00
\.


--
-- Data for Name: trabajador_tipo; Type: TABLE DATA; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

COPY qubytss_rrhh.trabajador_tipo (id_tipo_trabajador, cod_tipo_trabajador, desc_tipo_trabajador, est_tipo_trabajador) FROM stdin;
0	0	SIN TIPO	1
6	6	DESIGNADO	1
4	4	ADM. PROF. DE LA SALUD	1
2	2	ADMINISTRATIVO	1
1	1	DOCENTE	1
7	7	DESIGNADO DOC. DEL MAGISTERIO	1
3	3	DOCENTE DEL MAGISTERIO	1
5	5	OBRERO	1
9	9	ADM. FUNCIONARIO PUBLICO	1
8	8	DOCENTE PREGRADO	1
\.


--
-- Name: id_persona_seq; Type: SEQUENCE SET; Schema: qubytss_core; Owner: qubytss_core
--

SELECT pg_catalog.setval('qubytss_core.id_persona_seq', 95, true);


--
-- Name: anio anio_pk; Type: CONSTRAINT; Schema: public; Owner: qubytss_core
--

ALTER TABLE ONLY public.anio
    ADD CONSTRAINT anio_pk PRIMARY KEY (id_anio);


--
-- Name: anio anio_pk; Type: CONSTRAINT; Schema: qubytss_core; Owner: qubytss_core
--

ALTER TABLE ONLY qubytss_core.anio
    ADD CONSTRAINT anio_pk PRIMARY KEY (id_anio);


--
-- Name: correlativo correlativo_pk; Type: CONSTRAINT; Schema: qubytss_core; Owner: qubytss_core
--

ALTER TABLE ONLY qubytss_core.correlativo
    ADD CONSTRAINT correlativo_pk PRIMARY KEY (key_corr);


--
-- Name: list lista_pk; Type: CONSTRAINT; Schema: qubytss_core; Owner: qubytss_core
--

ALTER TABLE ONLY qubytss_core.list
    ADD CONSTRAINT lista_pk PRIMARY KEY (id_lista);


--
-- Name: mes mes_pk; Type: CONSTRAINT; Schema: qubytss_core; Owner: qubytss_core
--

ALTER TABLE ONLY qubytss_core.mes
    ADD CONSTRAINT mes_pk PRIMARY KEY (id_mes);


--
-- Name: persona persona_pk; Type: CONSTRAINT; Schema: qubytss_core; Owner: qubytss_core
--

ALTER TABLE ONLY qubytss_core.persona
    ADD CONSTRAINT persona_pk PRIMARY KEY (id_persona);


--
-- Name: persona persona_uk01; Type: CONSTRAINT; Schema: qubytss_core; Owner: qubytss_core
--

ALTER TABLE ONLY qubytss_core.persona
    ADD CONSTRAINT persona_uk01 UNIQUE (tipo_doc_per, nro_doc_per);


--
-- Name: concepto concepto_cod_conc_key; Type: CONSTRAINT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

ALTER TABLE ONLY qubytss_rrhh.concepto
    ADD CONSTRAINT concepto_cod_conc_key UNIQUE (cod_conc);


--
-- Name: concepto concepto_pk; Type: CONSTRAINT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

ALTER TABLE ONLY qubytss_rrhh.concepto
    ADD CONSTRAINT concepto_pk PRIMARY KEY (id_concepto);


--
-- Name: planilla_tipo planilla_tipo_pkey; Type: CONSTRAINT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

ALTER TABLE ONLY qubytss_rrhh.planilla_tipo
    ADD CONSTRAINT planilla_tipo_pkey PRIMARY KEY (id_tipo_planilla);


--
-- Name: planilla_trabajador_concepto planilla_trabajador_concepto_pk; Type: CONSTRAINT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

ALTER TABLE ONLY qubytss_rrhh.planilla_trabajador_concepto
    ADD CONSTRAINT planilla_trabajador_concepto_pk PRIMARY KEY (id_planilla, id_persona, id_corr_trab, id_concepto);


--
-- Name: planilla_trabajador planilla_trabajador_pk; Type: CONSTRAINT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

ALTER TABLE ONLY qubytss_rrhh.planilla_trabajador
    ADD CONSTRAINT planilla_trabajador_pk PRIMARY KEY (id_planilla, id_persona, id_corr_trab);


--
-- Name: trabajador_tipo tipo_trabajador_pk; Type: CONSTRAINT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

ALTER TABLE ONLY qubytss_rrhh.trabajador_tipo
    ADD CONSTRAINT tipo_trabajador_pk PRIMARY KEY (id_tipo_trabajador);


--
-- Name: trabajador_concepto trabajador_concepto_pkey; Type: CONSTRAINT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

ALTER TABLE ONLY qubytss_rrhh.trabajador_concepto
    ADD CONSTRAINT trabajador_concepto_pkey PRIMARY KEY (id_persona, id_corr_trab, id_concepto);


--
-- Name: trabajador trabajor_pk; Type: CONSTRAINT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

ALTER TABLE ONLY qubytss_rrhh.trabajador
    ADD CONSTRAINT trabajor_pk PRIMARY KEY (id_persona, id_corr_trab);


--
-- Name: idx_cod_trab; Type: INDEX; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

CREATE UNIQUE INDEX idx_cod_trab ON qubytss_rrhh.trabajador USING btree (cod_trab) WHERE (cod_trab IS NOT NULL);


--
-- Name: persona persona_tipo_doc_per_fkey; Type: FK CONSTRAINT; Schema: qubytss_core; Owner: qubytss_core
--

ALTER TABLE ONLY qubytss_core.persona
    ADD CONSTRAINT persona_tipo_doc_per_fkey FOREIGN KEY (tipo_doc_per) REFERENCES qubytss_core.list(id_lista);


--
-- Name: concepto concepto_id_sub_tipo_conc_fkey; Type: FK CONSTRAINT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

ALTER TABLE ONLY qubytss_rrhh.concepto
    ADD CONSTRAINT concepto_id_sub_tipo_conc_fkey FOREIGN KEY (id_sub_tipo_conc) REFERENCES qubytss_core.list(id_lista);


--
-- Name: concepto sup_tipo_conc_fkper; Type: FK CONSTRAINT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

ALTER TABLE ONLY qubytss_rrhh.concepto
    ADD CONSTRAINT sup_tipo_conc_fkper FOREIGN KEY (id_sub_tipo_conc) REFERENCES qubytss_core.list(id_lista);


--
-- Name: trabajador_concepto trabajador_concepto_id_concepto_fkey; Type: FK CONSTRAINT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

ALTER TABLE ONLY qubytss_rrhh.trabajador_concepto
    ADD CONSTRAINT trabajador_concepto_id_concepto_fkey FOREIGN KEY (id_concepto) REFERENCES qubytss_rrhh.concepto(id_concepto);


--
-- Name: trabajador_concepto trabajador_concepto_id_persona_fkey; Type: FK CONSTRAINT; Schema: qubytss_rrhh; Owner: qubytss_rrhh
--

ALTER TABLE ONLY qubytss_rrhh.trabajador_concepto
    ADD CONSTRAINT trabajador_concepto_id_persona_fkey FOREIGN KEY (id_persona, id_corr_trab) REFERENCES qubytss_rrhh.trabajador(id_persona, id_corr_trab);


--
-- PostgreSQL database dump complete
--

