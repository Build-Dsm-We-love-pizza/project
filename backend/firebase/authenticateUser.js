const admin = require("./config");
class Middleware {
  async getUserData(req) {
    const token = req.headers.authorization.split(" ")[1];
    const decodeValue = await admin.auth().verifyIdToken(token);
    return decodeValue;
  }
  async decodeToken(req, res, next) {
    try {
      const token = req.headers.authorization.split(" ")[1];
      const decodeValue = await admin.auth().verifyIdToken(token);
      if (decodeValue) {
        return next();
      }
      return res.json({ message: "Unauthorized" });
    } catch (e) {
      return res.json({ message: e?.message || "Internal Error" });
    }
  }
}
module.exports = new Middleware();
