import { Injectable } from '@nestjs/common';
import { UserService } from '../user/user.service';

@Injectable()
export class AuthService {
  constructor(private readonly userService: UserService) {}

  async validateUser(login: string, password: string) {
    const user = await this.userService.findOne(login, password);

    return user;
  }

  async findOneById(userId: number) {
    return await this.userService.findOneById(userId);
  }
}
