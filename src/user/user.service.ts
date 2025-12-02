import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { User } from './entities/user.entity';
import { Repository } from 'typeorm';

@Injectable()
export class UserService {
  constructor(
    @InjectRepository(User) private readonly userRepository: Repository<User>,
  ) {}

  async findOne(login: string, password: string) {
    const user = await this.userRepository.findOne({
      where: { login },
    });
    if (!user || user?.password !== password) {
      throw new BadRequestException('not correct login or password');
    }
    return user;
  }

  async findOneById(userId: number) {
    const user = await this.userRepository.findOneBy({ id: userId });
    if (!user) {
      throw new NotFoundException(`user with ${userId} id not fount`);
    }
    return user;
  }
}
