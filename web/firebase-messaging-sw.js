importScripts('https://www.gstatic.com/firebasejs/8.4.1/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.4.1/firebase-messaging.js');

   /*Update with yours config*/
  const firebaseConfig = {
    apiKey: "AIzaSyCQF-nQZSkHhklySPc2RvjHJOW2vADZxNs",
    authDomain: "spaid-7df4e.firebaseapp.com",
    projectId: "spaid-7df4e",
    storageBucket: "spaid-7df4e.appspot.com",
    messagingSenderId: "1094349639868",
    appId: "1:1094349639868:web:d684433185fb741c8c80b9",
    measurementId: "G-4GWNTLFCXE"
  };
  firebase.initializeApp(firebaseConfig);
  const messaging = firebase.messaging();

  /*messaging.onMessage((payload) => {
  console.log('Message received. ', payload);*/
 /* messaging.onBackgroundMessage(function(payload) {
    console.log('Received background message ', payload);

    const notificationTitle = payload.notification.title;
    const notificationOptions = {
      body: payload.notification.body,
    };

    self.registration.showNotification(notificationTitle,
      notificationOptions);
  });*/
  messaging.setBackgroundMessageHandler(function (payload) {
      const promiseChain = clients
          .matchAll({
              type: "window",
              includeUncontrolled: true
          })
          .then(windowClients => {
              for (let i = 0; i < windowClients.length; i++) {
                  const windowClient = windowClients[i];
                  windowClient.postMessage(payload);
              }
          })
          .then(() => {
              const title = payload.notification.title;
              const options = {
                  body: payload.notification.score
                };
              return registration.showNotification(title, options);
          });
      return promiseChain;
  });
  self.addEventListener('notificationclick', function (event) {
      console.log('notification received: ', event)
  });