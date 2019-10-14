import { combineReducers } from 'redux';
import registerUser_Reducer  from './userreducer'
import { createStore,compose } from 'redux'
import { ReactReduxFirebaseProvider, firebaseReducer } from 'react-redux-firebase'
import { createFirestoreInstance, firestoreReducer } from 'redux-firestore'

const rootReducer = combineReducers({
users: registerUser_Reducer,
firebase: firebaseReducer,
firestore: firestoreReducer
});
 
export default rootReducer;