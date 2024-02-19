import { Module } from '@nestjs/common';
import { ConceptoService } from './concepto.service';
import { ConceptoController } from './concepto.controller';
import { Concepto } from './entities/concepto.entity';
import { TypeOrmModule } from '@nestjs/typeorm';

@Module({
  controllers: [ConceptoController],
  providers: [ConceptoService],
  imports: [TypeOrmModule.forFeature([Concepto])],
})
export class ConceptoModule {}
