import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './App';
import * as serviceWorker from './serviceWorker';

import firebase from './firebase';
import {createStore,applyMiddleware} from 'redux';
import {Provider} from 'react-redux';
import thunk from 'redux-thunk';
import {getFirestore} from 'redux-firestore'
import {getFirebase} from 'react-redux-firebase'
import rootReducer from './reducers/rootreducer'

const store=createStore(rootReducer,applyMiddleware(thunk.withExtraArgument(getFirebase,getFirestore)));

ReactDOM.render(<Provider store={store}><App /></Provider>, document.getElementById('root'));

serviceWorker.register();
