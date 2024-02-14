import { Controller, Get, Post, Body } from '@nestjs/common';
import { MantenimientoService } from './mantenimiento.service';
import { searchListaDto } from './dto';

@Controller('core/mantenimiento')
export class MantenimientoController {
  constructor(private readonly mantenimientoService: MantenimientoService) {}

  @Post('search-list')
  searchList(@Body() searchListDto: searchListaDto) {
    return this.mantenimientoService.searchList(searchListDto);
  }

  @Post('search-type-planilla')
  async searchListPlanilla() {
    return {
      planilla_tipo: await this.mantenimientoService.listTypePlanilla(),
      empleado_tipo: await this.mantenimientoService.listTypeEmployee(),
      empleado_estado: await this.mantenimientoService.listTypeEmployee(),
      anio: await this.mantenimientoService.listYear(),
      mes: await this.mantenimientoService.listMonth(),
    };
  }
}
