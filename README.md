# 🌱 Sustainfy

**Sustainfy** is a full-stack Flutter-based sustainability platform that bridges the gap between individuals, NGOs, and companies. It empowers users to participate in sustainability efforts by attending events, making contributions, volunteering, and performing eco-friendly actions — all while earning redeemable points and tracking their impact.

---

## 📌 Key Features

- 🎯 **Event Participation System**: Join events with defined start and end times.
- 🔔 **Automatic Status Updates**: Event statuses are updated automatically post-completion.
- 🌍 **User Points & Leaderboards**: Earn points for participation and actions.
- 🧲 **Profile Management**: Secure login, encrypted data, account deletion, password reset, and reauthentication support.
- 🔒 **Data Encryption**: Sensitive user data encrypted with AES before Firestore storage.
- 📈 **Dashboard & Analytics**: Real-time insights into personal and global impact.
- 🌐 **Backend Integration**: Scheduled tasks to update event statuses hosted on Render.

---

## 💻 Tech Stack

| Layer       | Technology                     |
|-------------|---------------------------------|
| **Frontend**| Flutter, Dart                   |
| **Backend** | Dart              |
| **Database**| Firebase Firestore              |
| **Auth**    | Firebase Authentication         |
| **Scheduling** | Google Cloud Scheduler / In-app triggers |
| **Hosting** | Render (Backend API)            |
| **Encryption** | AES Encryption in Dart        |

---

## 🧐 Project Architecture

```
sustainfy/
│
├── backend/                  # Node.js backend server
│   ├── index.js              # Express server logic (e.g., updateEvents)
│   ├── serviceAccountKey.json
│   ├── package.json
│
├── lib/                      # Flutter frontend
│   ├── screens/              # All UI pages
│   ├── services/             # Encryption, Firebase operations
│   ├── models/
│   ├── main.dart
│
├── assets/
├── pubspec.yaml
├── .gitignore
├── README.md
```


## 🔐 Security

- Encrypted user data using AES in `EncryptionService`
- Firebase rules restrict access
- Reauthentication enforced before sensitive operations like deletion
- Cloud Function alternative available for Firebase account deletion

---
