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

  async randomStart() {
    const users = await this.userRepository.find();
    if (users.length < 2) {
      throw new BadRequestException('Мало учасників для гри (мінімум 2)');
    }
    const shuffledUsers = this.shuffleArray([...users]);

    for (let i = 0; i < shuffledUsers.length; i++) {
      const giver = shuffledUsers[i];
      const receiver = shuffledUsers[(i + 1) % shuffledUsers.length];

      giver.recipientId = receiver.id;
    }

    await this.userRepository.save(shuffledUsers);

    return { message: 'Жеребкування завершено успішно!' };
  }
  private shuffleArray(array: User[]): User[] {
    for (let i = array.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [array[i], array[j]] = [array[j], array[i]];
    }
    return array;
  }
}
