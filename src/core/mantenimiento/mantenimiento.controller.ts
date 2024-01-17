import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
} from '@nestjs/common';
import { MantenimientoService } from './mantenimiento.service';
import { searchListaDto } from './dto';

@Controller('core/mantenimiento')
export class MantenimientoController {
  constructor(private readonly mantenimientoService: MantenimientoService) {}

  @Post('search-list')
  searchList(@Body() searchListDto: searchListaDto) {
    return this.mantenimientoService.searchList(searchListDto);
  }
}
