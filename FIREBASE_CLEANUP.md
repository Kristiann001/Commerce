# Firebase User Cleanup Guide

## 🧹 How to Clear All User Data

### Method 1: Firebase Console (Recommended - Most Complete)

1. **Go to Firebase Console**
   - Visit: https://console.firebase.google.com/
   - Select your project: `fast_project` (or whatever your project is named)

2. **Delete Authentication Users**
   - Navigate to **Authentication** → **Users** tab
   - Select all users (checkbox at top)
   - Click **Delete** (trash icon)
   - Confirm deletion

3. **Delete Firestore User Documents**
   - Navigate to **Firestore Database**
   - Go to the `users` collection
   - Delete all documents (or delete the entire collection)
   - Also clean up `carts` and `wishlists` collections if they exist

4. **Done!** ✨
   - Your Firebase is now clean
   - You can create fresh accounts

---

### Method 2: Using Firestore Rules (Quick Reset)

If you just want to clear Firestore data (not Auth users):

1. **Run the cleanup script**
   ```bash
   # This will be integrated into the app
   # Just navigate to a special cleanup page
   ```

2. **Or manually in Firestore Console**
   - Delete the `users` collection
   - Delete the `carts` collection  
   - Delete the `wishlists` collection

---

### Method 3: Local Development Reset

For local testing, you can simply:

1. **Clear browser data**
   - Open DevTools (F12)
   - Application → Storage → Clear site data
   - This logs you out locally

2. **Create new account**
   - Use a different email each time
   - Format: `test1@shoplon.com`, `test2@shoplon.com`, etc.

---

## 🎯 Quick Start After Cleanup

Once Firebase is clean:

1. Go to **http://localhost:8083**
2. Skip onboarding
3. Click **"Sign Up"**
4. Create your first fresh account!

---

## ⚠️ Important Notes

- **Firebase Auth users** require Firebase Console or Admin SDK to delete
- **Firestore data** can be deleted via Console or programmatically
- **Local storage** can be cleared in browser DevTools
- For development, using different emails is often easier than full cleanup

---

## 🔧 Alternative: Use Different Emails

Instead of cleaning, you can simply register with new emails:
- `user1@test.com`
- `user2@test.com`
- `demo@shoplon.com`
- `customer@example.com`

This is the fastest approach for testing!
