import firebase from 'firebase';

const config = {
  apiKey: "AIzaSyA9OR-I8kGtL8sGiSEmh_ypradJoMs9qbU",
  authDomain: "mothi-paaru.firebaseapp.com",
  databaseURL: "https://mothi-paaru.firebaseio.com",
  projectId: "mothi-paaru",
  storageBucket: "mothi-paaru.appspot.com",
  messagingSenderId: "250627111694",
  appId: "1:250627111694:web:2db114384731940445b55f",
  measurementId: "G-TWPM9WZV2P"
};

const firebaseApp = firebase.initializeApp(config);

firebaseApp.firestore().settings({timestampsInSnapshots:true});

export default firebaseApp;

