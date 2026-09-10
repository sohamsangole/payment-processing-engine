import { Component, inject, signal } from '@angular/core';
import { Router, RouterLink } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { UserService } from '../../services/user.service';

@Component({
  imports: [RouterLink, FormsModule],
  selector: 'app-login',
  styleUrl: './login.css',
  templateUrl: './login.html',
})
export class Login {
  private readonly userService = inject(UserService);
  private readonly router = inject(Router);

  username = '';
  password = '';

  showPassword = signal(false);
  isLoading = signal(false);
  errorMessage = signal('');

  togglePassword() {
    this.showPassword.update((val) => !val);
  }

  onSubmit() {
    this.errorMessage.set('');

    if (!this.username.trim() || !this.password.trim()) {
      this.errorMessage.set('Please enter both username and password.');
      return;
    }

    this.isLoading.set(true);

    this.userService
      .login({
        username: this.username.trim(),
        password: this.password,
      })
      .subscribe({
        next: (user) => {
          this.isLoading.set(false);
          console.log('User authenticated successfully', user);
          this.router.navigate(['/home']);
        },
        error: (err) => {
          this.isLoading.set(false);
          const detail =
            err?.error?.message ||
            (err?.status === 401 || err?.status === 400 || err?.status === 500
              ? 'Invalid username or password'
              : 'Failed to connect to Spring Boot backend');
          this.errorMessage.set(detail);
        },
      });
  }
}
