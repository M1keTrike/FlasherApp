import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Flashcard } from './flashcard.entity';
import { User } from '../users/user.entity';
import { CreateFlashcardDto } from './dto/create-flashcard.dto';
import { UpdateFlashcardDto } from './dto/update-flashcard.dto';

@Injectable()
export class FlashcardsService {
  constructor(
    @InjectRepository(Flashcard)
    private readonly flashcardsRepository: Repository<Flashcard>,
  ) {}

  findAll(user: User): Promise<Flashcard[]> {
    return this.flashcardsRepository.find({
      where: { user: { id: user.id } },
      order: { createdAt: 'DESC' },
    });
  }

  async findOne(id: string, user: User): Promise<Flashcard> {
    const flashcard = await this.flashcardsRepository.findOne({
      where: { id, user: { id: user.id } },
    });
    if (!flashcard) {
      throw new NotFoundException('Flashcard no encontrada');
    }
    return flashcard;
  }

  create(dto: CreateFlashcardDto, user: User): Promise<Flashcard> {
    const flashcard = this.flashcardsRepository.create({ ...dto, user });
    return this.flashcardsRepository.save(flashcard);
  }

  async update(
    id: string,
    dto: UpdateFlashcardDto,
    user: User,
  ): Promise<Flashcard> {
    const flashcard = await this.findOne(id, user);
    Object.assign(flashcard, dto);
    return this.flashcardsRepository.save(flashcard);
  }

  async remove(id: string, user: User): Promise<void> {
    const flashcard = await this.findOne(id, user);
    await this.flashcardsRepository.remove(flashcard);
  }
}
