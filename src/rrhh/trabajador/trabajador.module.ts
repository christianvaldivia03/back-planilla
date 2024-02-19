import { Module } from '@nestjs/common';
import { TrabajadorService } from './trabajador.service';
import { TrabajadorController } from './trabajador.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Trabajador } from './entities/trabajador.entity';
import { Persona } from 'src/core/persona/entities/persona.entity';
import { PersonaModule } from '../../core/persona/persona.module';
import { TrabajadorConcepto } from './entities/trabajadorConcepto.entity';

@Module({
  controllers: [TrabajadorController],
  providers: [TrabajadorService],
  imports: [
    TypeOrmModule.forFeature([Trabajador, Persona, TrabajadorConcepto]),
    PersonaModule,
  ],
})
export class TrabajadorModule {}
