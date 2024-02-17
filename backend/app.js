var express = require("express");
const cors = require("cors");
const middleware = require("./firebase/authenticateUser");

var app = express();

const PORT = 3001;

app.use(cors(), middleware.decodeToken);

app.get("/", function (req, res) {
  res.send("Hello World!");
});
app.get("/ping", function (req, res) {
  res.send("pong");
});

app.post("/user", async function (req, res) {
  console.log(req.body);
});

app.get("/add-new-pet", function (req, res) {});

app.get("/set-pet-data", function (req, res) {});

app.listen(PORT, function () {
  console.log(`Example app listening on port ${PORT}!`);
});
