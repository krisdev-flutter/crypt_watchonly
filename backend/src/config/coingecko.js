
const axios = require('axios');

const coingecko = axios.create({
  baseURL: process.env.COINGECKO_BASE_URL,
  timeout: 10000,
  headers: {
    'x-cg-demo-api-key': process.env.COINGECKO_API_KEY,
  },
});

module.exports = coingecko;
