import { Injectable } from '@angular/core';
import { AngularFirestore, AngularFirestoreDocument, AngularFirestoreCollection } from '@angular/fire/firestore';
import { users } from './user.model';
import {userDetails} from './userdetails.model';
import {Observable, of, Subject} from 'rxjs';
import {map, switchMap} from 'rxjs/operators';
import { AngularFireAuth } from '@angular/fire/auth';
import { firestore } from 'firebase';
import { AuthService } from './auth.service';

@Injectable({
  providedIn: 'root'
})
export class MatchfinderService {
 userlist:Observable<users[]>;
 userlistdoc:AngularFirestoreCollection<users>;
 userDetailSearch:Observable<userDetails[]>;
 userDetails:AngularFirestoreCollection<userDetails>;
 userLoggedIn:users;
 matchedusers:Observable<users[]>;
  
 
  constructor(private readonly af:AngularFirestore,private afAuth: AngularFireAuth,private authser:AuthService) { 
    
    this.authser.userobs.subscribe(data=>{
    this.userLoggedIn=data;
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

    //('sportsdetails',ref => ref.where('gender','==', useritem.gender)).snapshotChanges();
    // const queryObservable = new Subject<string>().switchMap(geneder => 
    //   this.af.doc(`Users/${data.uid.toString()}`).collection("sportsdetails",ref => ref.where("gener", "==", useritem.gender)).valueChanges()
    //   );
    
    //return this.userDetails.ref.where('gender','==',useritem.gender);
}

}