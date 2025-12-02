import { Request } from 'express';
import { User } from 'src/user/entities/user.entity';

export interface LocalAuthRequest extends Request {
  user: LocalLoginData;
}
export interface JwtAuthRequest extends Request {
  user: User;
}

export interface LocalLoginData {
  user: User;
  token: string;
}
