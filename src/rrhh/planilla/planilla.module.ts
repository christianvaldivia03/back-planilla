import { Module } from '@nestjs/common';
import { PlanillaService } from './planilla.service';
import { PlanillaController } from './planilla.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Planilla } from './entities/planilla.entity';
import { PlanillaTrabajador } from './entities/planillaTrabajador.entity';
import { PlanillaTrabajadorConcepto } from './entities/planillaTrabajadorConcepto';
import { Trabajador } from '../trabajador/entities/trabajador.entity';
import { TrabajadorConcepto } from '../trabajador/entities/trabajadorConcepto.entity';
import { Mes } from 'src/core/mantenimiento/entities/mes.entity';

@Module({
  controllers: [PlanillaController],
  providers: [PlanillaService],
  imports: [
    TypeOrmModule.forFeature([
      Planilla,
      PlanillaTrabajador,
      PlanillaTrabajadorConcepto,
      Trabajador,
      TrabajadorConcepto,
      Mes,
    ]),
  ],
})
export class PlanillaModule {}
