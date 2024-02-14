import { Module } from '@nestjs/common';
import { MantenimientoService } from './mantenimiento.service';
import { MantenimientoController } from './mantenimiento.controller';
import { Persona } from '../persona/entities/persona.entity';
import { Trabajador } from 'src/rrhh/trabajador/entities/trabajador.entity';
import { List } from './entities/list.entity';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PlanillaTipo } from 'src/rrhh/planilla/entities/planillatipo.entity';
import { EmployeeType } from 'src/rrhh/trabajador/entities/trabajadortipo.entity';
import { Anio } from './entities/anio.entity';
import { Mes } from './entities/mes.entity';

@Module({
  controllers: [MantenimientoController],
  providers: [MantenimientoService],
  imports: [
    TypeOrmModule.forFeature([
      Persona,
      List,
      Trabajador,
      PlanillaTipo,
      EmployeeType,
      Anio,
      Mes,  
    ]),
  ],
})
export class MantenimientoModule {}
