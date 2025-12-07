import { Controller, Get, Post, Req, UseGuards } from '@nestjs/common';
import { AuthService } from './auth.service';
import { LocalAuthGuard } from './guards/local-auth.guards';
import { JwtAuthRequest, LocalAuthRequest } from 'src/user/types/type';
import { User } from 'src/user/entities/user.entity';
import { instanceToPlain } from 'class-transformer';
import { JwtAuthGuard } from './guards/jwt-auth.guads';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @UseGuards(LocalAuthGuard)
  @Post('login')
  async login(@Req() req: LocalAuthRequest) {
    const { user, token } = req.user;
    const { recipientId } = user;

    if (recipientId) {
      const recipient: User | null =
        await this.authService.findOneById(recipientId);
      return { user: { ...instanceToPlain(user), recipient }, token };
    }
    return { user, token };
  }

  @Post()
  logout() {}

  @UseGuards(JwtAuthGuard)
  @Get('refresh')
  async refresh(@Req() req: JwtAuthRequest) {
    const { user } = req;
    const { recipientId } = user;
    if (recipientId) {
      const recipient: User | null =
        await this.authService.findOneById(recipientId);
      return { ...instanceToPlain(user), recipient };
    }
    return { user };
  }
}
