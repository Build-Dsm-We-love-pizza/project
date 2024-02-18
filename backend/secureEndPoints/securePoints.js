const express = require("express");
const middleware = require("../firebase/authenticateUser");
const admin = require("firebase-admin");

const router = express.Router();

const db = admin.firestore();

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
    res.send({ message: "success" });
  } catch (err) {
    res.status(400).send({ error: err?.message || "Error" });
  }
});

router.post("/create-appointment", async function (req, res) {
  try {
    const userData = await middleware.getUserData(req);
    const uid = userData?.uid;
    const petId = req?.body?.["pet_id"];
    const vetId = req?.body?.["vet_id"];
    const dateTime = req?.body?.["on"];
    const dateObj = new Date(dateTime);
    const firestoreTimestamp = admin.firestore.Timestamp.fromDate(dateObj);

    if (!petId || !uid || !vetId || !on) throw Error("Provide complete data");

    await db.collection("appointments").add({
      from: uid,
      to: vetId,
      petId,
      on: firestoreTimestamp,
    });
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
