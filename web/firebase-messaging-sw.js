importScripts('https://www.gstatic.com/firebasejs/9.22.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.22.1/firebase-messaging-compat.js');

// Firebase web config (copied from FlutterFire generated options)
firebase.initializeApp({
  apiKey: 'AIzaSyAnCC8r_sCNDzB2GnZH5rpvBlFq9FRl8Zw',
  authDomain: 'constructionmanagementsy-f19c4.firebaseapp.com',
  projectId: 'constructionmanagementsy-f19c4',
  storageBucket: 'constructionmanagementsy-f19c4.firebasestorage.app',
  messagingSenderId: '639558965546',
  appId: '1:639558965546:web:11f6b0368733307be42653',
  measurementId: 'G-JFNS50V2QF'
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage(function(payload) {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  const notificationTitle = (payload && payload.notification && payload.notification.title) || 'Background Message Title';
  const notificationOptions = {
    body: (payload && payload.notification && payload.notification.body) || 'Background Message body.',
    // Customize icon path if you have one under web/
    icon: '/icons/Icon-192.png'
  };
  self.registration.showNotification(notificationTitle, notificationOptions);
});
