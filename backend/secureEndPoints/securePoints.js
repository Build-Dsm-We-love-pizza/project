const express = require("express");
const middleware = require("../firebase/authenticateUser");

const router = express.Router();

// middleware that is specific to this router
router.use(middleware.decodeToken);
// define the home page route
router.get("/", (req, res) => {
  res.send("Birds home page");
});

// define the about route
router.get("/about", (req, res) => {
  res.send("About birds");
});

module.exports = router;
