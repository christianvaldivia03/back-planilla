import { Module } from '@nestjs/common';
import { MantenimientoService } from './mantenimiento.service';
import { MantenimientoController } from './mantenimiento.controller';
import { Persona } from '../persona/entities/persona.entity';
import { Trabajador } from 'src/rrhh/trabajador/entities/trabajador.entity';
import { List } from './entities/list.entity';
import { TypeOrmModule } from '@nestjs/typeorm';

@Module({
  controllers: [MantenimientoController],
  providers: [MantenimientoService],
  imports: [TypeOrmModule.forFeature([Persona, List, Trabajador])],
})
export class MantenimientoModule {}
