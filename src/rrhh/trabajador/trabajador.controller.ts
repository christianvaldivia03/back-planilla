import { Controller, Post, Body, Patch } from '@nestjs/common';
import { TrabajadorService } from './trabajador.service';
import { CreateTrabajadorDto } from './dto/create-trabajador.dto';
import { UpdateTrabajadorDto } from './dto/update-trabajador.dto';
import { SearchTrabajadorDto } from './dto';

@Controller('rrhh/trabajador')
export class TrabajadorController {
  constructor(private readonly trabajadorService: TrabajadorService) {}

  @Post('create')
  createEmployee(@Body() createTrabajadorDto: CreateTrabajadorDto) {
    return this.trabajadorService.createEmployee(createTrabajadorDto);
  }

  @Patch('update')
  findEmployee(@Body() updateTrabajadorDto: UpdateTrabajadorDto) {
    return this.trabajadorService.updateEmployee(updateTrabajadorDto);
  }

  @Patch('delete')
  deleteEmployee(@Body() updateTrabajadorDto: UpdateTrabajadorDto) {
    return this.trabajadorService.deleteEmployee(updateTrabajadorDto);
  }

  @Post('search')
  findEmployeeData(@Body() searchTrabajadorDto: SearchTrabajadorDto) {
    return this.trabajadorService.findEmployeeData(searchTrabajadorDto);
  }
}
