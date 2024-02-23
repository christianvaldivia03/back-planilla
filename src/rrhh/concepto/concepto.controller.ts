import { Controller, Post, Body } from '@nestjs/common';
import { ConceptoService } from './concepto.service';
import { CreateConceptoDto } from './dto/create-concepto.dto';
import { UpdateConceptoDto } from './dto/update-concepto.dto';

@Controller('rrhh/concepto')
export class ConceptoController {
  constructor(private readonly conceptoService: ConceptoService) {}

  @Post()
  create(@Body() createConceptoDto: CreateConceptoDto) {
    return this.conceptoService.create(createConceptoDto);
  }
  @Post('search-list')
  searchList(@Body() searchConceptoDto: UpdateConceptoDto) {
    return this.conceptoService.searchList(searchConceptoDto);
  }
}
