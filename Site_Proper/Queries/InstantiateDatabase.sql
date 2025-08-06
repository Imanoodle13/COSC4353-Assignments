-- Assuming PostgreSQL (pgAdmin 4) is already installed,
-- PostGIS installation:
-- 1. Install PostGIS:
-- 		Windows:	 Using Application Stack Builder (under PostgreSQL 16)
--		macOS:		`brew install postgis`
--		Linux:		`sudo apt install postgis postgresql-14-postgis-3`

-- 2. Run the following queries:
CREATE EXTENSION IF NOT EXISTS postgis;                -- Adds spatial capabilities to PostgreSQL, enabling it to store, query, and analyze geographic and geometric data.
CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;          -- Offers functions to determine similarities and differences between strings, useful for approximate matching and handling misspellings.
CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder; -- Provides geocoding capabilities by converting textual addresses into geographic coordinates using U.S. Census TIGER/Line data.

SELECT postgis_full_version();

-- The `GEOGRAPHY(POINT,4326)` datatype should work.

-- For hashing passwords
CREATE EXTENSION IF NOT EXISTS pgcrypto;
/* 
DROP TABLE IF EXISTS ROLE				CASCADE;
DROP TABLE IF EXISTS VOLUNTEER			CASCADE;
DROP TABLE IF EXISTS EVENT				CASCADE;
DROP TABLE IF EXISTS VOLUNTEER_TASK	CASCADE;
DROP TABLE IF EXISTS TASK				CASCADE;
DROP TABLE IF EXISTS VOLUNTEER_HIST	CASCADE;
*/

CREATE TABLE IF NOT EXISTS ROLE(
	ID		SERIAL,
		CONSTRAINT ROLE_pk PRIMARY KEY (ID),
		CONSTRAINT ROLE_uq UNIQUE (ID),
	Name	TEXT
);

CREATE TABLE IF NOT EXISTS VOLUNTEER(
	ID				SERIAL,
		CONSTRAINT VOLUNTEER_pk PRIMARY KEY (ID),
		CONSTRAINT VOLUNTEER_uq UNIQUE (ID),
	Role_ID			INT,
		CONSTRAINT VOLUNTEER_fk1 FOREIGN KEY (Role_ID)
			REFERENCES ROLE(ID),
	First_name		TEXT,
	Last_name		TEXT,
	Username		TEXT,
	Email			TEXT,
	Password		TEXT,
	Skill			TEXT[],
	Location		GEOGRAPHY(POINT,4326),
	Availability	TEXT[]
);

CREATE TABLE IF NOT EXISTS EVENT(
	ID			SERIAL,
		CONSTRAINT EVENT_pk PRIMARY KEY (ID),
		CONSTRAINT EVENT_qu UNIQUE (ID),
	Name		TEXT,
	Moderator	INT,
		CONSTRAINT EVENT_fk1 FOREIGN KEY (Moderator)
			REFERENCES VOLUNTEER(ID),
	Location	GEOGRAPHY(POINT,4326),
	Description	TEXT,
	Priority    INT, -- From 1 to 5
	Date		TIMESTAMP
);

CREATE TABLE IF NOT EXISTS TASK(
	ID			SERIAL,
		CONSTRAINT TASK_pk PRIMARY KEY (ID),
		CONSTRAINT TASK_uq UNIQUE (ID),
	Event_ID	INT,
		CONSTRAINT TASK_fk1 FOREIGN KEY (Event_ID)
			REFERENCES EVENT(ID),
	Name        TEXT,
	Skill		TEXT[],
	Description	TEXT
);

CREATE TABLE IF NOT EXISTS VOLUNTEER_TASK(
	ID				SERIAL,
		CONSTRAINT VOLUNTEER_TASK_pk PRIMARY KEY (ID),
		CONSTRAINT VOLUNTEER_TASK_uq UNIQUE (ID),
	Task_ID			INT,
		CONSTRAINT VOLUNTEER_TASK_fk1 FOREIGN KEY (Task_ID)
			REFERENCES TASK(ID),
	Volunteer_ID	INT,
		CONSTRAINT VOLUNTEER_TASK_fk2 FOREIGN KEY (Volunteer_ID)
			REFERENCES VOLUNTEER(ID),
	Date_accepted	TIMESTAMP
);

CREATE TABLE IF NOT EXISTS VOLUNTEER_HIST(
	ID			SERIAL,
		CONSTRAINT VOLUNTEER_HIST_pk PRIMARY KEY (ID),
		CONSTRAINT VOLUNTEER_HIST_uq UNIQUE (ID),
	V_task_ID	INT,
		CONSTRAINT VOLUNTEER_HIST_fk1 FOREIGN KEY (V_task_ID)
			REFERENCES VOLUNTEER_TASK(ID),
	Start_time	TIMESTAMP,
	End_Time	TIMESTAMP
);