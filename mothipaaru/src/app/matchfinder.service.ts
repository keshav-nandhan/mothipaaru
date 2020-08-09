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
 
  
 userlist:Observable<userDetails[]>;
 userlistdoc:AngularFirestoreCollection<users>;
 userDetails:AngularFirestoreCollection<userDetails>;
 userLoggedIn:users;
 registermatch:matchdetails;
notificationdetail: AngularFirestoreCollection<matchdetails>;
 
  constructor(private readonly af:AngularFirestore,private afAuth: AngularFireAuth,private authser:AuthService) { 
    
    this.authser.userobs.subscribe(data=>{
    this.userLoggedIn=data;
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

}

}