import { Controller, Get } from '@nestjs/common';
import { UserService } from './user.service';

@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Get('start')
  async randomStart() {
    await this.userService.randomStart();
    return 'end';
  }
}
