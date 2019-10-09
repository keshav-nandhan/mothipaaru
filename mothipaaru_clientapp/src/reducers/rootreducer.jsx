import { combineReducers } from 'redux';
import registerUser_Reducer  from './userreducer'
const rootReducer = combineReducers({
users: registerUser_Reducer
});
 
export default rootReducer;