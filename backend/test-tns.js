// test-tns.js
require('dotenv').config();
const oracledb = require('oracledb');

async function testConnection() {
  try {
    await oracledb.initOracleClient({ configDir: process.env.WALLET_PATH });
    console.log('Trying to connect to:', process.env.DB_CONNECT_STRING);

    const connection = await oracledb.getConnection({
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      connectString: process.env.DB_CONNECT_STRING
    });

    console.log('✅ Successfully connected!');
    await connection.close();
  } catch (err) {
    console.error('❌ Connection failed:', err);
  }
}

testConnection();
