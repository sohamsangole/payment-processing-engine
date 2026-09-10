import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import { UserModel } from '../models/user.model';

@Injectable({
  providedIn: 'root',
})
export class UserService {
  private readonly http = inject(HttpClient);
  private readonly apiUrl = `${environment.springbootBaseUrl}/api/users`;

  createUser(user: UserModel): Observable<UserModel> {
    return this.http.post<UserModel>(this.apiUrl, user);
  }

  getUser(username: string): Observable<UserModel> {
    return this.http.get<UserModel>(`${this.apiUrl}/${username}`);
  }

  updateUser(user: UserModel): Observable<UserModel> {
    return this.http.put<UserModel>(this.apiUrl, user);
  }

  login(credentials: UserModel): Observable<UserModel> {
    return this.http.post<UserModel>(`${this.apiUrl}/login`, credentials);
  }

  deleteUser(username: string): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}/${username}`);
  }
}
