import React from 'react'
import { connect } from 'react-redux'
import { compose } from 'redux'
import { firebaseConnect, isLoaded, isEmpty } from 'react-redux-firebase'

function usersList({ firebase, users }) {
  // Build Todos list if todos exist and are loaded
  if (!isLoaded(users)) {
    return <div>Loading...</div>
  }
  if (isEmpty(users)) {
    return <div>No nearby users</div>
  }
  return (JSON.stringify(users, null, 2));
}
// let users = [
//     {id:1, user:"Keshav"},
//     {id:2, user:"Nandhan"}
//   ]
  // const registerUser_Reducer = (state = users, action) => {
  // const { user } = action
  // switch(action.type){
  //   case 'register_User':
  //    return [
  //     ...state,
  //     user
  //    ]
  //   default:
  //    return state  
  //  }
  // }

  const registerUser_Reducer = compose(
    firebaseConnect((props) => [
      { path: 'users' }
    ]),connect((state) => ({
      users: state.firebase.data.users,
    }))
  )
  
  export default registerUser_Reducer(usersList);