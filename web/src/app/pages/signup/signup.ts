import { Component, inject, signal } from '@angular/core';
import { Router, RouterLink } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { UserService } from '../../services/user.service';
import { UserModel } from '../../models/user.model';

@Component({
  imports: [RouterLink, FormsModule],
  selector: 'app-signup',
  styleUrl: './signup.css',
  templateUrl: './signup.html',
})
export class Signup {
  private readonly userService = inject(UserService);
  private readonly router = inject(Router);

  fullName = '';
  username = '';
  email = '';
  dob = '';
  password = '';
  confirmPassword = '';

  showPassword = signal(false);
  isLoading = signal(false);
  errorMessage = signal('');
  successMessage = signal('');

  togglePassword() {
    this.showPassword.update((val) => !val);
  }

  onSubmit() {
    this.errorMessage.set('');
    this.successMessage.set('');

    if (this.password !== this.confirmPassword) {
      this.errorMessage.set('Passwords do not match.');
      return;
    }

    const payload: UserModel = {
      name: this.fullName,
      username: this.username,
      email: this.email,
      dob: this.dob || undefined,
      password: this.password,
      enabled: true,
    };

    this.isLoading.set(true);

    this.userService.createUser(payload).subscribe({
      next: (createdUser) => {
        this.isLoading.set(false);
        this.successMessage.set(
          `Account created for ${createdUser.username || this.username}! Redirecting to login...`
        );
        setTimeout(() => {
          this.router.navigate(['/login']);
        }, 1500);
      },
      error: (err) => {
        this.isLoading.set(false);
        const detail =
          err?.error?.message ||
          err?.statusText ||
          'Failed to connect to Spring Boot backend';
        this.errorMessage.set(`Registration failed: ${detail}`);
      },
    });
  }
}
