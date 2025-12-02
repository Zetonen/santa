import { Exclude } from 'class-transformer';
import {
  Column,
  CreateDateColumn,
  Entity,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity('user')
export class User {
  @PrimaryGeneratedColumn()
  id: number;

  @Exclude()
  @Column()
  login: string;

  @Exclude()
  @Column()
  password: string;

  @Column()
  name: string;

  @Column()
  quote: string;

  @Column()
  userImg: string;

  @Exclude()
  @Column({
    type: 'int',
    default: null,
    nullable: true,
    transformer: {
      to: (value: number) => value,
      from: (value: string): number => parseFloat(value),
    },
  })
  recipientId: number | null;

  @Exclude()
  @CreateDateColumn()
  createdAt: Date;

  @Exclude()
  @UpdateDateColumn()
  updateAt: Date;
}
