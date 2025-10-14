require('dotenv').config();
const oracledb = require('oracledb');
const path = require('path');

async function connect() {
  await oracledb.initOracleClient({ configDir: process.env.WALLET_PATH });

  const connection = await oracledb.getConnection({
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    connectString: process.env.DB_CONNECT_STRING
  });

  console.log('Connected!');
  await connection.close();
}

connect();
