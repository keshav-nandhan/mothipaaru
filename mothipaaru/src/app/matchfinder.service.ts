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
 userlist:AngularFirestoreCollection<users>;
 userDetailSearch:Observable<userDetails[]>;
 userDetails:AngularFirestoreCollection<userDetails>;
 userLoggedIn:any;
 matchedusers:Observable<users[]>;
  
 
  constructor(private readonly af:AngularFirestore,private afAuth: AngularFireAuth,private authser:AuthService) { 
    
    this.userLoggedIn=this.afAuth.authState.pipe(switchMap(user=>{
      if(user){
        return this.afAuth.currentUser;
      }
      else{
        return null;
      }
    }))
   
    this.authser.userobs.subscribe(data=>{
      this.userDetails=this.af.doc(`Users/${data.uid.toString()}`).collection<userDetails>('sportsdetails');
      
    this.userDetailSearch=this.userDetails.snapshotChanges().pipe(map(actions => {return actions.map(a =>{
      const docdata  = a.payload.doc.data() as userDetails;
      docdata.uid = a.payload.doc.id;
      return docdata;
    })
  })
    );
  });
    
  }

  matchfinder(useritem){
    

    this.authser.userobs.subscribe(data=>{
    this.userDetails.snapshotChanges().pipe(map(actions => {return actions.map(a =>{
      this.userDetails.doc(a.payload.doc.id).set({ completed: true }, { merge: true });
    })
  })
    );
  });
    console.log(this.userDetailSearch);
    //this.userDetails.add(useritem);

    //this.userDetails.doc('').set({ completed: true }, { merge: true });
    this.matchedusers=this.af.collection<users>('Users').snapshotChanges().pipe(map(fn=>{
      return fn.map(a=>{
        const usermatch = a.payload.doc.data() as users;
        usermatch.uid = a.payload.doc.id;
        return usermatch;
      })
      })
      );
  
  return this.matchedusers;
  }

    //('sportsdetails',ref => ref.where('gender','==', useritem.gender)).snapshotChanges();
    // const queryObservable = new Subject<string>().switchMap(geneder => 
    //   this.af.doc(`Users/${data.uid.toString()}`).collection("sportsdetails",ref => ref.where("gener", "==", useritem.gender)).valueChanges()
    //   );
    
    //return this.userDetails.ref.where('gender','==',useritem.gender);
}
