'use strict';

const express = require('express');

const PORT = 8000;
const HOST = '0.0.0.0';

const app = express();
app.get('/', (req, res) => {
  res.send(JSON.stringify({
    message: "Automate all the things!",
    timestamp: "1529729125",
    pod: process.env.HOSTNAME 
  }));
});

app.listen(PORT, HOST, () => {
  console.log(`Running on http://${HOST}:${PORT}`);
});