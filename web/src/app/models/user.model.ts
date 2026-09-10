export interface UserModel {
  username: string;
  password?: string;
  name?: string;
  email?: string;
  dob?: string | Date;
  role?: string;
  enabled?: boolean;
}
