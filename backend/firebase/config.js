var admin = require("firebase-admin");

var serviceAccount = require("../builddsm-53a56-firebase-adminsdk-spgdj-5fc8846b57.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

module.exports = admin;
