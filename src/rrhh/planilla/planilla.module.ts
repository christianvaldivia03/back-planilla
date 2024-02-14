import { Module } from '@nestjs/common';
import { PlanillaService } from './planilla.service';
import { PlanillaController } from './planilla.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Planilla } from './entities/planilla.entity';

@Module({
  controllers: [PlanillaController],
  providers: [PlanillaService],
  imports: [TypeOrmModule.forFeature([Planilla])],
})
export class PlanillaModule {}
