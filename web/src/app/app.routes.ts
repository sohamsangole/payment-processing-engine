import { Routes } from '@angular/router';
import {Login} from './pages/login/login';
import { Home } from './pages/home/home';
import { Signup } from './pages/signup/signup';
import { Landingpage } from './pages/landingpage/landingpage';

export const routes: Routes = [
    { path: '', component: Landingpage },
    { path: 'login', component: Login },
    { path: 'home', component: Home },
    { path: 'signup', component: Signup },
];
