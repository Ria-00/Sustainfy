const express = require("express");
const admin = require("firebase-admin");
const bodyParser = require("body-parser");

// Initialize Firebase Admin SDK
const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

const app = express();
app.use(bodyParser.json());

// 🔥 API to Update Events (Uses Firestore Index)
app.post("/updateEvents", async (req, res) => {
  console.log("Checking for completed events...");
  const now = new Date();

  try {
    // Query Firestore for events that are live and have ended (Using Composite Index)
    const eventsSnapshot = await db.collection("events")
      .where("eventStatus", "==", "live")
      .where("eventEnd_date", "<=", now) // Requires a composite index
      .get();

    if (eventsSnapshot.empty) {
      console.log("No events to update.");
      return res.status(200).send("No events updated.");
    }

    const batch = db.batch();
    let updatedCount = 0;

    eventsSnapshot.docs.forEach((doc) => {
      batch.update(doc.ref, { eventStatus: "closed" });
      updatedCount++;
    });

    await batch.commit(); // Execute batch update
    console.log(`${updatedCount} events marked as closed.`);
    return res.status(200).send(`${updatedCount} events updated successfully.`);
  } catch (error) {
    console.error("Error updating events:", error);
    return res.status(500).send("Internal Server Error");
  }
});

// Start Server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
