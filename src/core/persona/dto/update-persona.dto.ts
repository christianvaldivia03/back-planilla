import { PartialType } from '@nestjs/mapped-types';
import { CreatePersonaDto } from './create-persona.dto';
import { IsInt } from 'class-validator';

export class UpdatePersonaDto extends PartialType(CreatePersonaDto) {
  @IsInt()
  id_persona: number;
}
