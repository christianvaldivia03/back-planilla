import { Controller, Post, Body } from '@nestjs/common';
import { PlanillaService } from './planilla.service';
import { CreatePlanillaDto } from './dto/create-planilla.dto';
import { UpdatePlanillaDto } from './dto/update-planilla.dto';
import { SearchPlanillaTrabajador } from './dto/search-planilla-concepto.dto';

@Controller('rrhh/planilla')
export class PlanillaController {
  constructor(private readonly planillaService: PlanillaService) {}

  @Post('create')
  create(@Body() createPlanillaDto: CreatePlanillaDto) {
    return this.planillaService.create(createPlanillaDto);
  }

  @Post('search-list')
  searchList(@Body() searchPlanillaDto: UpdatePlanillaDto) {
    return this.planillaService.searchList(searchPlanillaDto);
  }

  @Post('search-one')
  searchOne(@Body() searchPlanillaDto: UpdatePlanillaDto) {
    return this.planillaService.searchOnePlanilla(searchPlanillaDto);
  }

  @Post('search-concepto')
  searchConcepto(
    @Body() searchPlanillaTrabajadorDto: SearchPlanillaTrabajador,
  ) {
    return this.planillaService.searchConcepto(searchPlanillaTrabajadorDto);
  }
}
