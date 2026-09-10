import { Component, signal } from '@angular/core';
import { RouterLink } from '@angular/router';
import { FormsModule } from '@angular/forms';

@Component({
  imports: [RouterLink, FormsModule],
  selector: 'app-signup',
  styleUrl: './signup.css',
  templateUrl: './signup.html',
})
export class Signup {
  fullName = '';
  username = '';
  email = '';
  password = '';
  confirmPassword = '';
  showPassword = signal(false);

  togglePassword() {
    this.showPassword.update((val) => !val);
  }

  onSubmit() {
    console.log('Signup form submitted', {
      fullName: this.fullName,
      username: this.username,
      email: this.email,
    });
  }
}
