import { Module } from '@nestjs/common';
import { PlanillaService } from './planilla.service';
import { PlanillaController } from './planilla.controller';

@Module({
  controllers: [PlanillaController],
  providers: [PlanillaService],
})
export class PlanillaModule {}
