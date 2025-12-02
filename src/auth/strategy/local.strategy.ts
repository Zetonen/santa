import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { Strategy } from 'passport-local';
import { AuthService } from '../auth.service';
import { JwtService } from '@nestjs/jwt';

@Injectable()
export class LocalStrategy extends PassportStrategy(Strategy) {
  constructor(
    private authService: AuthService,
    private readonly jwtService: JwtService,
  ) {
    super({
      usernameField: 'login',
    });
  }

  async validate(login: string, password: string): Promise<any> {
    console.log(login, password);

    const user = await this.authService.validateUser(login, password);

    if (!user) {
      throw new UnauthorizedException('not found this user');
    }
    const token = this.jwtService.sign({ login, userId: user.id });

    return { user, token };
  }
}
