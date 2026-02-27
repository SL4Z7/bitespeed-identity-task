# Identity Reconciliation Service - Bitespeed Backend Task

This is a backend web service built for FluxKart.com to consolidate customer contact information across multiple purchases. It exposes an `/identify` endpoint that links orders made with different emails and phone numbers to the same underlying customer identity.

## 🚀 Live Demo
**Hosted Endpoint:** `https://bitespeed-identity-task-1.onrender.com/identify`

## 🛠 Tech Stack
* **Backend:** Node.js, Express.js
* **Database:** MySQL (Hosted on Aiven)
* **ORM:** Prisma
* **Deployment:** Render

## 💻 Local Setup Instructions

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/SL4Z7/bitespeed-identity-task.git](https://github.com/SL4Z7/bitespeed-identity-task.git)
   cd bitespeed-identity-task

```

2. **Install dependencies:**
```bash
npm install

```


3. **Set up environment variables:**
Create a `.env` file in the root directory and add your MySQL connection string:
```env
DATABASE_URL="mysql://root:password@localhost:3306/identity_db"

```


4. **Run database migrations:**
```bash
npx prisma db push

```


5. **Start the server:**
```bash
npm run dev

```


The server will start on `http://localhost:3000`.

## 📡 API Contract

### `POST /identify`

**Request Body (JSON):**

```json
{
  "email": "mcfly@hillvalley.edu",
  "phoneNumber": "123456"
}

```

**Expected Response (200 OK):**

```json
{
  "contact": {
    "primaryContatctId": 1,
    "emails": ["lorraine@hillvalley.edu", "mcfly@hillvalley.edu"],
    "phoneNumbers": ["123456"],
    "secondaryContactIds": [23]
  }
}

```

## 👨‍💻 Author

```

### What to do next:

1. **Save it:** Press `Ctrl + S` in VS Code to save your `README.md` file.
2. **Push it:** Run these commands in your terminal to send it to GitHub:
   ```bash
   git add README.md
   git commit -m "docs: completely update README with live URL and API docs"
   git push origin main

```