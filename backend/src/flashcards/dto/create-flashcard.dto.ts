import { IsNotEmpty, IsString } from 'class-validator';

export class CreateFlashcardDto {
  @IsString()
  @IsNotEmpty()
  question: string;

  @IsString()
  @IsNotEmpty()
  answer: string;

  @IsString()
  @IsNotEmpty()
  category: string;
}
