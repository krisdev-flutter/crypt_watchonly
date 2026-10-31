const coingecko = require('../config/coingecko');

const getBitcoinPrice = async () => {
  const response = await coingecko.get('/simple/price', {
    params: {
      ids: 'bitcoin',
      vs_currencies: 'usd',
      include_24hr_change: true,
    },
  });

  return response.data;
};

const getMarkets = async (params = {}) => {
  const response = await coingecko.get('/coins/markets', {
    params: {
      vs_currency: params.vs_currency || 'usd',
      order: params.order || 'market_cap_desc',
      per_page: params.per_page || 100,
      page: params.page || 1,
      sparkline: params.sparkline ?? false,
    },
  });

  return response.data;
};

const getCoinDetails = async (id) => {
  const response = await coingecko.get(`/coins/${encodeURIComponent(id)}`);
  return response.data;
};

const getCoinChart = async (id, params = {}) => {
  const response = await coingecko.get(
    `/coins/${encodeURIComponent(id)}/market_chart`,
    {
      params: {
        vs_currency: params.vs_currency || 'usd',
        days: params.days || 7,
      },
    },
  );

  return response.data;
};

module.exports = {
  getBitcoinPrice,
  getMarkets,
  getCoinDetails,
  getCoinChart,
};
