import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import {LoginauthComponent } from './loginauth/loginauth.component';
import { PageNotFoundComponent } from './page-not-found/page-not-found.component';
import { GuardService } from './guard.service';
import{ContactUsComponent} from './contact-us/contact-us.component';
import{HomeComponent} from './home/home.component';
import {InterestComponent} from './interest/interest.component';
import{NotificationComponent} from './notification/notification.component';
import { ChatComponent } from './chat/chat.component';

const routes: Routes = [
  { path: '', redirectTo: '/login', pathMatch: 'full'},
  { path:'login', component:LoginauthComponent}, 
  { path:'home', component:HomeComponent,canActivate:[GuardService],children:[
    {path:'interest',component:InterestComponent},
    {path:'notification',component:NotificationComponent},
    {path:'chat',component:ChatComponent}
  ]
  },
  { path:'ContactUS', component:ContactUsComponent,canActivate:[GuardService]},
  {path:'**',component:PageNotFoundComponent}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
