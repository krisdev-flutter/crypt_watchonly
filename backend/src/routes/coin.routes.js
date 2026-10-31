const express = require('express');
const router = express.Router();

const coinController = require('../controllers/coin.controller');

router.get('/bitcoin/price', coinController.getBitcoinPrice);
router.get('/markets', coinController.getMarkets);
router.get('/:id/market-chart', coinController.getCoinChart);
router.get('/:id', coinController.getCoinDetails);

module.exports = router;
