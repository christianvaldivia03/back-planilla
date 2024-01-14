import { Controller, Post, Body, Patch } from '@nestjs/common';
import { PersonaService } from './persona.service';

import { SearchPersonaDto, CreatePersonaDto, UpdatePersonaDto } from './dto';

@Controller('core/persona')
export class PersonaController {
  constructor(private readonly personaService: PersonaService) {}

  @Post('create')
  createPersona(@Body() createPersonaDto: CreatePersonaDto) {
    return this.personaService.createPersona(createPersonaDto);
  }

  @Post('search-person-data')
  buscarPersonaData(@Body() searchPersonaDto: SearchPersonaDto) {
    return this.personaService.buscarPersonaData(searchPersonaDto);
  }

  @Patch('update-person') //listo
  updatePerson(@Body() updatePersonaDto: UpdatePersonaDto) {
    return this.personaService.updatePerson(updatePersonaDto);
  }

  // @Post('search-person')
  // searchPerson(@Body() searchPersonaDto: SearchPersonaDto) {
  //   return this.personaService.findPersonOne(searchPersonaDto.id_persona);
  // }
}
