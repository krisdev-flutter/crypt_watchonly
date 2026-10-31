const coinService = require('../services/coin.service');

const getBitcoinPrice = async (req, res) => {
  try {
    const data = await coinService.getBitcoinPrice();

    return res.status(200).json({
      success: true,
      data,
    });
  } catch (error) {
    console.error('CoinGecko API error:', error.message);

    return res.status(502).json({
      success: false,
      message: 'Unable to fetch Bitcoin price',
    });
  }
};

const getMarkets = async (req, res) => {
  try {
    const data = await coinService.getMarkets(req.query);

    return res.status(200).json({
      success: true,
      data,
    });
  } catch (error) {
    console.error('CoinGecko markets error:', error.message);

    return res.status(502).json({
      success: false,
      message: 'Unable to fetch cryptocurrency markets',
    });
  }
};

const getCoinDetails = async (req, res) => {
  try {
    const data = await coinService.getCoinDetails(req.params.id);

    return res.status(200).json({
      success: true,
      data,
    });
  } catch (error) {
    console.error('Coin details error:', error.message);

    return res.status(502).json({
      success: false,
      message: 'Unable to fetch coin details',
    });
  }
};

const getCoinChart = async (req, res) => {
  try {
    const data = await coinService.getCoinChart(
      req.params.id,
      req.query,
    );

    return res.status(200).json({
      success: true,
      data,
    });
  } catch (error) {
    console.error('Coin chart error:', error.message);

    return res.status(502).json({
      success: false,
      message: 'Unable to fetch coin chart',
    });
  }
};

module.exports = {
  getBitcoinPrice,
  getMarkets,
  getCoinDetails,
  getCoinChart,
};