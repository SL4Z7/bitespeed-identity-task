# MySQL & Express Identity Reconciliation Backend

This is the pure JavaScript backend implementation using Express and MySQL as requested, ready to be paired with a frontend (MERN stack but with MySQL).

## Prerequisites
- Node.js
- A running MySQL server (e.g., XAMPP, MAMP, Docker, or standalone MySQL).

## Setup Instructions

1. **Install Dependencies:**
   ```bash
   npm install
   ```

2. **Configure Database Connection:**
   Create a `.env` file in the root directory (where `package.json` is) and add your MySQL database connection URL.
   Example:
   ```env
   DATABASE_URL="mysql://root:password@localhost:3306/identity_db"
   ```
   *(Make sure to replace `root`, `password`, and `identity_db` with your actual MySQL credentials and desired database name).*

3. **Run Migrations (Create Tables):**
   ```bash
   npx prisma db push
   ```
   *(This will connect to your MySQL database and automatically create the Contact table).*

4. **Start the Development Server:**
   ```bash
   npm run dev
   ```
   The server will start on `http://localhost:3000`.

## Testing the API
**Example Request:**
```bash
curl -X POST http://localhost:3000/identify \
-H "Content-Type: application/json" \
-d '{"email":"mcfly@hillvalley.edu", "phoneNumber":"123456"}'
```
