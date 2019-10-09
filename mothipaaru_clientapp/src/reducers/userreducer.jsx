let users = [
    {id:1, user:"Keshav"},
    {id:2, user:"Nandhan"}
  ]
  const registerUser_Reducer = (state = users, action) => {
  const { user } = action
  switch(action.type){
    case 'register_User':
     return [
      ...state,
      user
     ]
    default:
     return state  
   }
  }
  export default registerUser_Reducer