const { Pool } = require('pg');
const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'postgres',
  password: 'password',
  port: 5432
});

pool.query('UPDATE users SET password_hash = $1 WHERE email = $2', [
  '$2b$10$h0JyYlmhmJRUWSd79l//ee7aFEqIl20n/etc/BkmReaEoFFtDAxDa',
  'admin@toeic.com'
]).then(() => {
  console.log('Update complete');
  process.exit(0);
});
