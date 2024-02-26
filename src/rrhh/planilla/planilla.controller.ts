import { Controller, Post, Body } from '@nestjs/common';
import { PlanillaService } from './planilla.service';
import { CreatePlanillaDto } from './dto/create-planilla.dto';
import { UpdatePlanillaDto } from './dto/update-planilla.dto';
import { SearchPlanillaTrabajador } from './dto/search-planilla-concepto.dto';
import { SearchArrayPlanilla } from './dto/searchArrayPlanilla.dto';

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
  async searchOne(@Body() searchPlanillaDto: UpdatePlanillaDto) {
    return {
      dataPlanilla:
        await this.planillaService.searchOnePlanilla(searchPlanillaDto),
      planillatrabajador:
        await this.planillaService.searchEmployeePlanillaDetail(
          searchPlanillaDto,
        ),
    };
  }
  @Post('search-datail-employee')
  async searchPlanillaEmployee(@Body() searchPlanillaDto: UpdatePlanillaDto) {
    return {
      dataPlanilla:
        await this.planillaService.searchOnePlanilla(searchPlanillaDto),
      planillatrabajador:
        await this.planillaService.searchEmployeePlanillaDetail(
          searchPlanillaDto,
        ),
    };
  }

  @Post('search-concepto')
  searchConcepto(
    @Body() searchPlanillaTrabajadorDto: SearchPlanillaTrabajador,
  ) {
    return this.planillaService.searchConcepto(searchPlanillaTrabajadorDto);
  }

  @Post('add-employee')
  addEmployee(@Body() searchArrayPlanilla: SearchArrayPlanilla) {
    console.log('searchPersonaDto', searchArrayPlanilla);
    return this.planillaService.addEmployee(searchArrayPlanilla);
  }
}
