import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
} from '@nestjs/common';
import { PersonaService } from './persona.service';

import { SearchPersonaDto, CreatePersonaDto, UpdatePersonaDto } from './dto';

@Controller('core/persona')
export class PersonaController {
  constructor(private readonly personaService: PersonaService) {}

  @Get()
  buscarPersona() {
    return this.personaService.buscarPersona();
  }

  @Post('search')
  buscarPersonaData(@Body() searchPersonaDto: SearchPersonaDto) {
    return this.personaService.buscarPersonaData(searchPersonaDto);
  }

  @Post('create')
  createPersona(@Body() createPersonaDto: CreatePersonaDto) {
    return this.personaService.createPersona(createPersonaDto);
  }
}
