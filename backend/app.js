var express = require("express");
const cors = require("cors");
const middleware = require("./firebase/authenticateUser");
const authenticateUser = require("./firebase/authenticateUser");
const { getAuth } = require("firebase-admin/auth");
const admin = require("firebase-admin");
const secureRoutes = require("./secureEndPoints/securePoints");

var app = express();

const db = admin.firestore();

const PORT = 3001;

const bodyParser = require("body-parser");
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

app.use(cors());

app.get("/", function (req, res) {
  res.send("Hello World!");
});
app.get("/ping", async function (req, res) {
  res.send("pong");
});

app.post("/create-user", async function (req, res) {
  const email = req?.body?.["email"];
  const pass = req?.body?.["password"];
  const isVet = req?.body?.["isVet"] || false;
  try {
    if (!email && !pass) throw Error("Give email and Password");
    const data = await getAuth().createUser({
      email: email,
      password: pass,
    });
    const uid = data.uid;

    const userRef = db.collection("users").doc(uid);
    await userRef.set({
      pets: [],
      isVet,
    });

    res.status(200).send("User record created successfully");
  } catch (err) {
    res.send({ error: err?.message || "Error" });
  }
});

app.get("/add-new-pet", function (req, res) {});

app.get("/set-pet-data", function (req, res) {});

app.use("/secure", secureRoutes);

app.listen(PORT, function () {
  console.log(`Example app listening on port ${PORT}!`);
});
