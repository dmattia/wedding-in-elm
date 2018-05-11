import firebase from 'firebase';

firebase.initializeApp({
  apiKey: "AIzaSyBkkgVVrKaY2tSms5KfYPY_Op--l7hXRIk",
  authDomain: "elm-wedding.firebaseapp.com",
  databaseURL: "https://elm-wedding.firebaseio.com",
  projectId: "elm-wedding",
  storageBucket: "elm-wedding.appspot.com",
  messagingSenderId: "825516479515"
});

const startWatchingContent = (sendContent) => {
  firebase.database().ref('content').on('value', snapshot => {
    sendContent(snapshot.val());
  });
}

export default startWatchingContent;
