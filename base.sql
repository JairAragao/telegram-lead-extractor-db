------------------------------------
-- lead_list
------------------------------------
-- CREATE TABLE IF NOT EXISTS public.lead_list(
--     lead_list_id serial primary key,
--     user_id integer references users(user_id) NOT NULL,
-- 	name varchar(60) not null,
--     description varchar(200),
--     active boolean NOT NULL
-- )

-- CREATE OR REPLACE PROCEDURE public.create_lead_list(
-- 	in_user_id integer,
-- 	in_name varchar,
-- 	in_description varchar)
-- LANGUAGE 'sql'
-- AS $BODY$
-- 	insert into lead_list(user_id, name, description, active)
-- 	values(in_user_id, in_name, in_description, true)
-- $BODY$;

------------------------------------
-- lead ---
------------------------------------
-- CREATE TABLE IF NOT EXISTS public.lead(
--     lead_id serial primary key,
--     lead_list_id integer references lead_list(lead_list_id) NOT NULL,
-- 	extraction_id integer references extraction(extraction_id) not null,
--     user_name character varying(60) NOT NULL,
--     phone_number character varying(30),
--     group_origin_name character varying(60) NOT NULL,
--     group_origin_id integer NOT NULL,
--     status integer NOT NULL,
--     creation_date timestamp without time zone NOT NULL
-- )

-- CREATE OR REPLACE PROCEDURE public.create_lead(
-- 	IN in_lead_list_id integer,
-- 	IN in_extraction_id integer,
-- 	IN in_user_name character varying,
-- 	IN in_phone_number character varying,
-- 	IN in_group_origin_name character varying,
-- 	IN in_group_origin_id integer)
-- LANGUAGE 'sql'
-- AS $BODY$
-- 	insert into lead(lead_list_id, extraction_id, user_name, phone_number, group_origin_name, group_origin_id, status, creation_date)
-- 	values(in_lead_list_id, in_extraction_id, in_user_name, in_phone_number, in_group_origin_name, in_group_origin_id, 1, now())
-- $BODY$;

------------------------------------
-- extraction
------------------------------------

-- CREATE TABLE IF NOT EXISTS public.extraction(
--     extraction_id serial primary key,
-- 	lead_list_id integer references lead_list(lead_list_id) not null,
--     user_id integer references users(user_id) not null,
-- 	telegram_account_id integer references telegram_account(telegram_account_id) not null,
-- 	group_origin_id bigint not null,
-- 	group_origin_name varchar(60) not null,
-- 	creation_date timestamp not null,
-- 	status integer not null
-- )

-- DROP PROCEDURE IF EXISTS public.create_extraction(integer, integer, integer, bigint, character varying);
-- CREATE OR REPLACE PROCEDURE public.create_extraction(
-- 	IN in_lead_list_id integer,
-- 	IN in_user_id integer,
-- 	IN in_telegram_account_id integer,
-- 	IN in_group_origin_id bigint,
-- 	IN in_group_origin_name varchar)
-- LANGUAGE 'sql'
-- AS $BODY$
-- 	insert into extraction(lead_list_id, user_id, telegram_account_id, group_origin_id, group_origin_name, creation_date, status)
-- 	values(in_lead_list_id, in_user_id, in_telegram_account_id, in_group_origin_id, in_group_origin_name, now(), 0)
-- $BODY$;

------------------------------------
-- Execuções de adição de leads
------------------------------------

-- CREATE TABLE IF NOT EXISTS public.add_lead_execution(
--   add_lead_execution_id serial primary key,
--   user_id integer not null references users(user_id),
--   lead_list_id integer not null references lead_list(lead_list_id),
--   destine_group_name varchar not null,
--   destine_group_id bigint not null,
--   min_delay integer not null,
--   max_delay integer not null,
--   creation_date timestamp not null,
--   last_update timestamp not null,
--   status integer not null
-- )

-- CREATE OR REPLACE PROCEDURE public.create_add_lead_execution(
-- 	IN in_user_id integer,
-- 	IN in_lead_list_id integer,
-- 	IN in_destine_group_id bigint,
-- 	IN in_destine_group_name varchar,
-- 	IN in_min_delay integer,
-- 	In in_max_delay integer
-- 	)
-- LANGUAGE 'sql'
-- AS $BODY$
-- 	insert into add_lead_execution(user_id, lead_list_id, destine_group_id, destine_group_name, min_delay, max_delay, creation_date, last_update, status)
-- 	values(in_user_id, in_lead_list_id, in_destine_group_id, in_destine_group_name, in_min_delay, in_max_delay, now(), now(), 0)
-- $BODY$;


------------------------------------
-- Contas das execuções
------------------------------------

-- CREATE TABLE IF NOT EXISTS public.telegram_account_execution(
-- 	telegram_account_id integer not null references telegram_account(telegram_account_id),
-- 	add_lead_execution_id integer not null references add_lead_execution(add_lead_execution_id),
-- 	admin_destine_group boolean
-- )

-- CREATE OR REPLACE PROCEDURE public.create_telegram_account_execution(
-- 	IN in_telegram_account_id integer,
-- 	IN in_add_lead_execution_id integer,
-- 	IN in_admin_destine_group boolean
-- 	)
-- LANGUAGE 'sql'
-- AS $BODY$
-- 	insert into telegram_account_execution(telegram_account_id, add_lead_execution_id, admin_destine_group)
-- 	values(in_telegram_account_id, in_add_lead_execution_id, in_admin_destine_group)
-- $BODY$;

------------------------------------
-- Log das execuções de adição
------------------------------------

-- CREATE TABLE IF NOT EXISTS public.execution_log(
--   execution_log_id serial primary key,
--   add_lead_execution_id int not null references add_lead_execution(add_lead_execution_id),
--   telegram_account_id int not null references telegram_account(telegram_account_id),
--   lead_id int not null references lead(lead_id),
--   lead_list_id integer not null references lead_list(lead_list_id),
--   destine_group_name varchar(60) not null,
--   destine_group_id bigint not null,
--   status integer not null,
--   error_msg varchar(1000)
-- )

-- CREATE OR REPLACE PROCEDURE public.create_execution_log(
--   IN in_add_lead_execution_id integer,
--   IN in_telegram_account_id integer,
--   IN in_lead_id integer,
--   IN in_lead_list_id integer,
--   IN in_destine_group_name varchar,
--   IN in_destine_group_id bigint,
--   IN in_status integer,
--   IN in_error_msg varchar)
-- LANGUAGE 'sql'
-- AS $BODY$
-- 	insert into execution_log(add_lead_execution_id, telegram_account_id, lead_id, lead_list_id, destine_group_name, destine_group_id, status, error_msg)
-- 	values(in_add_lead_execution_id, in_telegram_account_id, in_lead_id, in_lead_list_id, in_destine_group_name, in_destine_group_id, in_status, in_error_msg)
-- $BODY$;


-- CREATE OR REPLACE FUNCTION public.create_add_lead_execution(
-- 	in_user_id integer,
-- 	in_lead_list_id integer,
-- 	in_destine_group_name varchar,
-- 	in_destine_group_id bigint,
-- 	in_min_delay integer,
-- 	in_max_delay integer)
--     RETURNS TABLE(add_lead_execution_id integer) 
--     LANGUAGE 'sql'
--     COST 100
--     VOLATILE PARALLEL UNSAFE
--     ROWS 1000

-- AS $BODY$
-- insert into add_lead_execution(user_id, lead_list_id, destine_group_name, destine_group_id, min_delay, max_delay, creation_date, last_update, status)
-- values(in_user_id, in_lead_list_id, in_destine_group_name, in_destine_group_id, in_min_delay, in_max_delay, now(), now(), 0)
-- returning add_lead_execution_id;
-- $BODY$;



-- CREATE OR REPLACE PROCEDURE public.create_telegram_account_execution(
-- 	IN in_telegram_account_id integer,
-- 	IN in_add_lead_execution_id integer,
-- 	IN in_admin_destine_group boolean)
-- LANGUAGE 'sql'
-- AS $BODY$
-- 	insert into telegram_account_execution(telegram_account_id, add_lead_execution_id, admin_destine_group)
-- 	values(in_telegram_account_id, in_add_lead_execution_id, in_admin_destine_group)
-- $BODY$;


-- CREATE OR REPLACE FUNCTION public.get_add_lead_execution(
-- 	in_user_id integer)
--     RETURNS TABLE(add_lead_execution_id integer, lead_list_id integer, lead_list_name varchar, destine_group_name varchar, leads_added integer, total_leads integer, 
-- 				  percent_done decimal, creation_date timestamp, last_update timestamp, status integer) 
--     LANGUAGE 'sql'
--     COST 100
--     VOLATILE PARALLEL UNSAFE
--     ROWS 1000

-- AS $BODY$
-- select ale.add_lead_execution_id, ale.lead_list_id, ll.name, ale.destine_group_name, 
-- (select count(execution_log_id) from execution_log where lead_list_id = ale.lead_list_id and status = 1),
-- (select count(lead_id) from lead where lead_list_id = ale.lead_list_id),
-- (100 / (select count(lead_id) from lead where lead_list_id = ale.lead_list_id)) * (select count(execution_log_id) from execution_log where lead_list_id = ale.lead_list_id and status = 1),
-- ale.creation_date::timestamp(0), ale.last_update::timestamp(0), ale.status
-- from add_lead_execution ale
-- join lead_list ll on ll.lead_list_id = ale.lead_list_id
-- where ale.user_id = in_user_id
-- $BODY$;

-- CREATE OR REPLACE FUNCTION public.get_telegram_account_execution(
-- 	in_add_lead_execution_id integer)
--     RETURNS TABLE(telegram_account_id integer, name varchar, status integer) 
--     LANGUAGE 'sql'
--     COST 100
--     VOLATILE PARALLEL UNSAFE
--     ROWS 1000

-- AS $BODY$
-- select tae.telegram_account_id, ta.name, ta.status
-- from telegram_account_execution tae
-- join telegram_account ta on ta.telegram_account_id = tae.telegram_account_id
-- where tae.add_lead_execution_id = in_add_lead_execution_id
-- $BODY$;

