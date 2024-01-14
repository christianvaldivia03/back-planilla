import { Module } from '@nestjs/common';
import { PersonaService } from './persona.service';
import { PersonaController } from './persona.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Persona } from './entities/persona.entity';
import { Trabajador } from 'src/rrhh/trabajador/entities/trabajador.entity';
import { List } from '../mantenimiento/entities/list.entity';

@Module({
  controllers: [PersonaController],
  providers: [PersonaService],
  imports: [TypeOrmModule.forFeature([Persona, List, Trabajador])],
  exports: [PersonaService],
})
export class PersonaModule {}
