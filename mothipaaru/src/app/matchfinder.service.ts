import { Injectable } from '@angular/core';
import { AngularFirestore, AngularFirestoreDocument, AngularFirestoreCollection } from '@angular/fire/firestore';
import { users } from './user.model';
import {userDetails} from './userdetails.model';
import {Observable, of, Subject} from 'rxjs';
import {map, switchMap} from 'rxjs/operators';
import { AngularFireAuth } from '@angular/fire/auth';
import { AuthService } from './auth.service';
import { matchdetails } from './notification.model';

@Injectable({
  providedIn: 'root'
})
export class MatchfinderService {
<<<<<<< HEAD
 
=======
 userlist:Observable<users[]>;
 userlistdoc:AngularFirestoreCollection<users>;
 userDetailSearch:Observable<userDetails[]>;
 userDetails:AngularFirestoreCollection<userDetails>;
 userLoggedIn:users;
 matchedusers:Observable<users[]>;
>>>>>>> 330f034c37ef95a5a61ed500ed139c20629cd270
  
 userlist:Observable<userDetails[]>;
 userlistdoc:AngularFirestoreCollection<users>;
 userDetails:AngularFirestoreCollection<userDetails>;
 userLoggedIn:users;
 registermatch:matchdetails;
notificationdetail: AngularFirestoreCollection<matchdetails>;
 
  constructor(private readonly af:AngularFirestore,private afAuth: AngularFireAuth,private authser:AuthService) { 
    
    this.authser.userobs.subscribe(data=>{
    this.userLoggedIn=data;
<<<<<<< HEAD
    });
    this.userDetails=this.af.collection<userDetails>('register_team');
    this.userlistdoc=this.af.collection<users>('Users');
    this.notificationdetail=this.af.collection<matchdetails>('register_match');

}
addnotification(matchrequested) {
this.registermatch=<matchdetails>{
  Sport:matchrequested.favouritesport,
  location:matchrequested.citylocation,
  comments:matchrequested.descground,
  confirmed:'false',
  matchrequestedagainst:matchrequested.uid,
  matchrequestedby:this.userLoggedIn.uid,
  dateupdated:Date.now().toString()
}
this.notificationdetail.add(this.registermatch);
}



showNotifications() {
  var currentuserid=this.userLoggedIn.uid.toString();
var matchesdeclaredagainst=this.af.collection<matchdetails>('register_match',ref=>ref.where('matchrequestedagainst','==',currentuserid)).valueChanges();
    var matchesconfirmed=this.af.collection<matchdetails>('register_match',ref=>ref.where('matchrequestedby','==',currentuserid)).valueChanges();
  
  return [matchesdeclaredagainst,matchesconfirmed];

}

  matchfinder(useritem){

      const userref:userDetails={
        uid:this.userLoggedIn.uid,
        dateupdated:Date.now().toString(),
        gender:useritem.gender,
        phonenumber:useritem.phonenumber,
        favouritesport:useritem.favouritesport,
        citylocation:useritem.citylocation,
        descground:useritem.descground,
        imageurl:this.userLoggedIn.photoURL,
        mailaddress:this.userLoggedIn.email,
        username:this.userLoggedIn.displayName
      };
      this.userDetails.doc(this.userLoggedIn.uid).set(userref,{ merge: true });
  // return userref.set(data,{merge:true});
    const arr=<userDetails[]>[];
    this.userlist=this.af.collection<userDetails>("register_team",ref=>ref.where('gender','==',useritem.gender).where('citylocation','==',useritem.citylocation).where('favouritesport','==',useritem.favouritesport).orderBy('uid')).valueChanges();
    this.userlist.subscribe(actions=>{
      actions.map(data=>{
      if(data["uid"]!=this.userLoggedIn.uid)
      arr.push(data)
    });
    })
    console.log(arr);
    return arr;
=======
    this.userDetails=this.af.doc(`Users/${data.uid.toString()}`).collection<userDetails>('sportsdetails');
    this.userlistdoc=this.af.collection<users>('Users');
    this.userlist=this.af.collection<users>('Users').valueChanges();
      
  });
}

  matchfinder(useritem){
    this.authser.userobs.subscribe(data=>{
      this.userLoggedIn=data;});

   
  // const data={uid,email,displayName,photoURL}
  // return userref.set(data,{merge:true});
this.userDetails.snapshotChanges().pipe(map(actions=>{

  return actions.map(a =>{
    const userref:userDetails={
      uid:a.payload.doc.id,
      gender:useritem.gender,
      phonenumber:useritem.phonenumber,
      favouritesport:useritem.favouritesport,
      citylocation:useritem.citylocation,
      descground:useritem.descground,
      imageurl:this.userLoggedIn.photoURL,
      mailaddress:this.userLoggedIn.email,
      username:this.userLoggedIn.displayName
    };
    if(!a.payload.doc.exists){
      this.userDetails.add(userref);
    }else{
      this.userDetails.doc(a.payload.doc.id).set(userref,{ merge: true });  
    }
        const docdata  = a.payload.doc.data() as userDetails;
        docdata.uid = a.payload.doc.id;  
        return docdata;
    })  
  })
    ).subscribe(data=>{
      console.log(data);
    });


    this.af.collectionGroup("sportsdetails",ref=>ref.where('gender','==',useritem.gender).where('citylocation','==',useritem.citylocation)).snapshotChanges().subscribe(actions=>{      
      actions.map(a =>{
        const docdata  = a.payload.doc.data() as userDetails;
        docdata.uid = a.payload.doc.id; 
        console.log(docdata); 
      })
  });
    return this.userlist;
>>>>>>> 330f034c37ef95a5a61ed500ed139c20629cd270

}

}