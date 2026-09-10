import { Component, signal } from '@angular/core';
import { RouterLink } from '@angular/router';
import { FormsModule } from '@angular/forms';

@Component({
  imports: [RouterLink, FormsModule],
  selector: 'app-login',
  styleUrl: './login.css',
  templateUrl: './login.html',
})
export class Login {
  username = '';
  password = '';
  showPassword = signal(false);

  togglePassword() {
    this.showPassword.update((val) => !val);
  }

  onSubmit() {
    console.log('Login form submitted', {
      username: this.username,
    });
  }
}
