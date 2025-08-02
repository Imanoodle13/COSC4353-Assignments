require('dotenv').config();
const session = require('express-session');
const { Pool } = require('pg');
const { app } = require('./server');
const { url } = require('url')

const pool = new Pool({
	host: process.env.PGHOST,
	port: Number(process.env.PGPORT || 5432),
	// user:     process.env.PGUSER,
	// password: process.env.PGPASSWORD,
	// database: process.env.PGDATABASE,
	ssl: { rejectUnauthorized: false },// set to `true` in prod with a valid CA
	enableChannelBinding: true  // Only meaningful if Postgres offers SCRAM‑SHA‑256‑PLUS
});

module.exports = {
	query: (text, params) => pool.query(text, params),
	connect: () => pool.connect(),
};
