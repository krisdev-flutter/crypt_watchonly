
const express = require('express');
const cors = require('cors');

const app = express();

app.use(cors());
app.use(express.json());

const healthRoutes = require('./routes/health.routes');
const coinRoutes = require('./routes/coin.routes');

app.use('/api/health', healthRoutes);
app.use('/api/coins', coinRoutes);

module.exports = app;
