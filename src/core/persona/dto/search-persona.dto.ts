import { PartialType } from '@nestjs/mapped-types';
import { CreatePersonaDto } from './create-persona.dto';
import { IsOptional } from 'class-validator';

export class SearchPersonaDto extends PartialType(CreatePersonaDto) {
  @IsOptional()
  id_persona: number;
}
