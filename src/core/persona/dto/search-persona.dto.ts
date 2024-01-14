import { PartialType } from '@nestjs/mapped-types';
import { CreatePersonaDto } from './create-persona.dto';

export class SearchPersonaDto extends PartialType(CreatePersonaDto) {}
