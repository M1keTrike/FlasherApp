import { IsNotEmpty, IsOptional, IsString } from 'class-validator';

// Todos los campos son opcionales en la actualización; cuando se envían,
// se validan igual que en la creación.
export class UpdateFlashcardDto {
  @IsOptional()
  @IsString()
  @IsNotEmpty()
  question?: string;

  @IsOptional()
  @IsString()
  @IsNotEmpty()
  answer?: string;

  @IsOptional()
  @IsString()
  @IsNotEmpty()
  category?: string;
}
