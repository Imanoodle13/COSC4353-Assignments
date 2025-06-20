-- Assuming PostgreSQL (pgAdmin 4) is already installed,
-- PostGIS installation:
-- 1. Install PostGIS:
-- 		Windows:	 Using Application Stack Builder (under PostgreSQL 16)
--		macOS:		`brew install postgis`
--		Linux:		`sudo apt install postgis postgresql-14-postgis-3`

-- 2. Run the following queries:
CREATE EXTENSION IF NOT EXISTS postgis;
SELECT postgis_full_version();

-- The `GEOGRAPHY(POINT,4326)` datatype should work.

-- For hashing passwords
CREATE EXTENSION IF NOT EXISTS pgcrypto;