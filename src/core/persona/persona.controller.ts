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

  @Post('search')
  buscarPersonaData(@Body() searchPersonaDto: SearchPersonaDto) {
    return this.personaService.buscarPersonaData(searchPersonaDto);
  }

  @Post('one-search')
  buscarOnePersonaData(@Body() searchPersonaDto: SearchPersonaDto) {

    return this.personaService.buscarOnePersonaData(searchPersonaDto);
  }

  @Patch('update') //listo
  updatePerson(@Body() updatePersonaDto: UpdatePersonaDto) {
    return this.personaService.updatePerson(updatePersonaDto);
  }

  // @Post('search-person')
  // searchPerson(@Body() searchPersonaDto: SearchPersonaDto) {
  //   return this.personaService.findPersonOne(searchPersonaDto.id_persona);
  // }
}
