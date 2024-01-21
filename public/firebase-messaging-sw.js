 // Scripts for firebase and firebase messaging
 importScripts("https://www.gstatic.com/firebasejs/8.2.0/firebase-app.js");
 importScripts("https://www.gstatic.com/firebasejs/8.2.0/firebase-messaging.js");

 // Initialize the Firebase app in the service worker by passing the generated config
 const firebaseConfig = {
  apiKey: 'AIzaSyBjSrso1px3T6gqW_aHUawDUyl0WM30X44',
  authDomain: 'chat-room-api-a0399.firebaseapp.com',
  appName: 'Chat Room',
  projectId: 'chat-room-api-a0399',
  messagingSenderId: '540650753582',
  appId: '1:540650753582:android:8a69e3b63034febdaa19bf',
};

 firebase.initializeApp(firebaseConfig);

 // Retrieve firebase messaging
 const messaging = firebase.messaging();

 messaging.onBackgroundMessage(function(payload) {
   console.log("Received background message ", payload);

   const notificationTitle = payload.notification.title;
   const notificationOptions = {
     body: payload.notification.body,
   };

   self.registration.showNotification(notificationTitle, notificationOptions);
 });