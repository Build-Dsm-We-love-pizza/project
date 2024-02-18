const express = require("express");
const middleware = require("../firebase/authenticateUser");
const admin = require("firebase-admin");
const OpenAI = require("openai");
const router = express.Router();
require("dotenv").config();

const db = admin.firestore();

async function generateSuggestionsForVet(petId) {
  const openai = new OpenAI({
    apiKey: process.env.OPENAI_API_KEY,
  });

  const recordsSnapshot = await db
    .collection("pets")
    .doc(petId)
    .collection("records")
    .get();

  const records = recordsSnapshot.docs.map((doc) => ({
    id: doc.id,
    ...doc.data(),
  }));
  console.log(records);

  const response = await openai.chat.completions.create({
    model: "gpt-3.5-turbo",
    messages: [
      {
        role: "user",
        content: `I have following data for dog health. It contains values like ${JSON.stringify(
          records
        )}, generate suggenstions 
        based on this data to tell the owner of pet about his health status. activityScore is the excitement level of dog from 1 to 5,
        food is the brand of the food used, medication may contain what kind of medication is provided to the dog, symptoms are the symptoms 
        which dog might have. All the data is timebased. Please give response within 50 words. Include medical details as much as possible`,
      },
    ],
    temperature: 1,
    max_tokens: 256,
    top_p: 1,
    frequency_penalty: 0,
    presence_penalty: 0,
  });

  const suggestion = response.choices?.[0]?.message?.content;
  await db.collection("pets").doc(petId).update({
    "doctor-suggestion": suggestion,
  });
}

async function generateSuggestionsForClient(petId) {
  const openai = new OpenAI({
    apiKey: process.env.OPENAI_API_KEY,
  });

  const recordsSnapshot = await db
    .collection("pets")
    .doc(petId)
    .collection("records")
    .get();

  const records = recordsSnapshot.docs.map((doc) => ({
    id: doc.id,
    ...doc.data(),
  }));
  console.log(records);

  const response = await openai.chat.completions.create({
    model: "gpt-3.5-turbo",
    messages: [
      {
        role: "user",
        content: `I have following data for dog health. It contains values like ${JSON.stringify(
          records
        )}, generate suggenstions 
        based on this data to tell the owner of pet about his health status. activityScore is the excitement level of dog from 1 to 5,
        food is the brand of the food used, medication may contain what kind of medication is provided to the dog, symptoms are the symptoms 
        which dog might have. All the data is timebased. Please give response within 50 words`,
      },
    ],
    temperature: 1,
    max_tokens: 256,
    top_p: 1,
    frequency_penalty: 0,
    presence_penalty: 0,
  });

  const suggestion = response.choices?.[0]?.message?.content;
  await db.collection("pets").doc(petId).update({
    suggestion: suggestion,
  });
}

// middleware that is specific to this router
router.use(middleware.decodeToken);
// define the home page route
router.post("/create-pet", async (req, res) => {
  const userData = await middleware.getUserData(req);
  const uid = userData?.uid;
  try {
    if (!uid) throw Error("User not found");
    const body = req.body;
    const nameOfPet = body?.["name"];
    const typeOfPet = "dog";
    const petRef = await db.collection("pets").add({
      name: nameOfPet,
      tpye: typeOfPet,
      user_id: uid,
    });
    await petRef.update({ pet_id: petRef.id });
    await db
      .collection("users")
      .doc(uid)
      .update({
        pets: admin.firestore.FieldValue.arrayUnion(petRef.id),
      });
    res.send({ message: "Success" });
  } catch (err) {
    res.status(404).send({ error: err?.message || "Error occurred!" });
  }
});

router.post("/create-record", async function (req, res) {
  try {
    const petId = req?.body?.["pet_id"];
    if (!petId) throw Error("Pet does not exists");
    await db
      .collection("pets")
      .doc(petId)
      .collection("records")
      .add({
        ...req.body,
        dateTime: admin.firestore.Timestamp.now(),
      });
    await generateSuggestionsForClient(petId);
    res.send({ message: "success" });
  } catch (err) {
    res.status(400).send({ error: err?.message || "Error" });
  }
});

router.post("/create-appointment", async function (req, res) {
  try {
    console.log("heere");
    const userData = await middleware.getUserData(req);
    const uid = userData?.uid;
    const petId = req?.body?.["pet_id"];
    const vetId = req?.body?.["vet_id"];
    const dateTime = req?.body?.["on"];
    const dateObj = new Date(dateTime);
    const firestoreTimestamp = admin.firestore.Timestamp.fromDate(dateObj);

    if (!petId || !uid || !vetId || !dateTime)
      throw Error("Provide complete data");

    await db.collection("appointments").add({
      from: uid,
      to: vetId,
      petId,
      on: firestoreTimestamp,
    });
    await generateSuggestionsForVet(petId);
    res.send({ message: "success" });
  } catch (err) {
    res.status(400).send({ error: err?.message || "Error" });
  }
});

// define the about route
router.get("/about", (req, res) => {
  res.send("About birds");
});

module.exports = router;
