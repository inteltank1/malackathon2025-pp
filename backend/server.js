require('dotenv').config();
const oracledb = require('oracledb');
const fs = require('fs');

async function connect() {
  try {
    //console.log('Wallet path:', process.env.WALLET_PATH);
    //console.log('Connect string:', process.env.DB_CONNECT_STRING);

    await oracledb.initOracleClient({ configDir: process.env.WALLET_PATH });

    // Optional: check if tnsnames.ora is visible
    console.log('Files in wallet:', fs.readdirSync(process.env.WALLET_PATH));

    const connection = await oracledb.getConnection({
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      connectString: process.env.DB_CONNECT_STRING
    });

    console.log('✅ Connected successfully!');
    const result = await connection.execute('select * from SALUDMENTAL FETCH FIRST 5 ROWS ONLY;');
    console.log(result.rows);

    await connection.close();
  } catch (err) {
    console.error('❌ Connection error:', err);
  }
}

connect();
