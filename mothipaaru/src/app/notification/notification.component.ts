import { Component, OnInit } from '@angular/core';
import { MatchfinderService } from '../matchfinder.service';
import { Router } from '@angular/router';
import { matchdetails } from '../notification.model';
import { async } from '@angular/core/testing';

@Component({
  selector: 'app-notification',
  templateUrl: './notification.component.html',
  styleUrls: ['./notification.component.scss']
})
export class NotificationComponent implements OnInit {

  constructor(private serviceobj:MatchfinderService,private router:Router) { }
notifications:matchdetails;
  Confirmnotifications:any=[];
ngOnInit(): void {
    var notificationmaster=this.serviceobj.showNotifications();
    notificationmaster[0].subscribe(data=>{});
    notificationmaster[1].subscribe(data=>{this.Confirmnotifications=data});
  }

}
