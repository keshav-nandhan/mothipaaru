import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './App';
import * as serviceWorker from './serviceWorker';
// If ur ato work offline and load faster, you can change
// unregister() to register() ow. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
//import firebase from './firebase';
import {createStore,applyMiddleware} from 'redux';
import {Provider} from 'react-redux';
import thunk from 'redux-thunk';
import {getFirestore} from 'redux-firestore'
import {getFirebase} from 'react-redux-firebase'
import rootReducer from './reducers/rootreducer'

const store=createStore(rootReducer,applyMiddleware(thunk.withExtraArgument(getFirebase,getFirestore)));

ReactDOM.render(<Provider store={store}><App /></Provider>, document.getElementById('root'));

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.register();
