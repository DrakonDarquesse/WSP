importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyCipWEdUPKCFYAe0cqjwbK5x3Bd5RU0H0s",
  authDomain: "my-fyp-40911.firebaseapp.com",
  projectId: "my-fyp-40911",
  storageBucket: "my-fyp-40911.appspot.com",
  messagingSenderId: "1026987205210",
  appId: "1:1026987205210:web:303fa3a6e7f65c6ffeae63",
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
  const notificationTitle = m.notification.title;
  const notificationOptions = {
    body: m.notification.body,
  };

  self.registration.showNotification(notificationTitle,
    notificationOptions);
});