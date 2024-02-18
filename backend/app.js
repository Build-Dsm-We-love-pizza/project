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

app.post("/create-meeting", async function (req, res) {
  // Refer to the Node.js quickstart on how to setup the environment:
  // https://developers.google.com/calendar/quickstart/node
  // Change the scope to 'https://www.googleapis.com/auth/calendar' and delete any
  // stored credentials.

  const event = {
    summary: "Google I/O 2015",
    location: "800 Howard St., San Francisco, CA 94103",
    description: "A chance to hear more about Google's developer products.",
    start: {
      dateTime: "2015-05-28T09:00:00-07:00",
      timeZone: "America/Los_Angeles",
    },
    end: {
      dateTime: "2015-05-28T17:00:00-07:00",
      timeZone: "America/Los_Angeles",
    },
    recurrence: ["RRULE:FREQ=DAILY;COUNT=2"],
    attendees: [{ email: "lpage@example.com" }, { email: "sbrin@example.com" }],
    reminders: {
      useDefault: false,
      overrides: [
        { method: "email", minutes: 24 * 60 },
        { method: "popup", minutes: 10 },
      ],
    },
  };

  calendar.events.insert(
    {
      auth: auth,
      calendarId: "primary",
      resource: event,
    },
    function (err, event) {
      if (err) {
        console.log(
          "There was an error contacting the Calendar service: " + err
        );
        return;
      }
      console.log("Event created: %s", event.htmlLink);
    }
  );
});

app.get("/add-new-pet", function (req, res) {});

app.get("/set-pet-data", function (req, res) {});

app.use("/secure", secureRoutes);

app.listen(PORT, function () {
  console.log(`Example app listening on port ${PORT}!`);
});
