// File: web/firebase-messaging-sw.js

// Scripts for Firebase
importScripts('https://www.gstatic.com/firebasejs/9.23.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.23.0/firebase-messaging-compat.js');

// Your web app's Firebase configuration
// IMPORTANT: Replace this with your actual Firebase config values
const firebaseConfig = {
  apiKey: "AIzaSyAlnjIOACLmOVeula7x9HdTkEz-PU6okR8",
  authDomain: "flutter-task-2-43f0c.firebaseapp.com",
  projectId: "flutter-task-2-43f0c",
  storageBucket: "flutter-task-2-43f0c.firebasestorage.app",
  messagingSenderId: "670823984510",
  appId: "1:670823984510:web:5da144f4522b6c442dd72f",
  measurementId: "G-DE7B2G2SMK"
};


// Initialize Firebase
const app = firebase.initializeApp(firebaseConfig);
const messaging = firebase.messaging();

// Optional: You can add a background message handler here if needed
messaging.onBackgroundMessage((payload) => {
  console.log(
    '[firebase-messaging-sw.js] Received background message ',
    payload
  );
  // Customize notification here
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/favicon.png' // Optional: path to your notification icon
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
