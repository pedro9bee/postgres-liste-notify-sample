"use strict";

const express = require("express");
const subscriber = require("./subscriber");
const app = express();
const port = 3000;
const client = subscriber.connect();

app.get("/employees", async (req, res) => {
  const users = await client.query("select * from public.employees").rows;
  console.log(users);
  res.send(users);
});

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`);
});
