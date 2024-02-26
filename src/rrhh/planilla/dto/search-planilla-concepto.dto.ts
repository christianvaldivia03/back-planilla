import { PartialType } from '@nestjs/mapped-types';
import { UpdatePlanillaDto } from './update-planilla.dto';
import { IsInt } from 'class-validator';
import { Transform } from 'class-transformer';

export class SearchPlanillaTrabajador extends PartialType(UpdatePlanillaDto) {
  @IsInt()
  @Transform((params) => parseInt(params.value))
  id_persona: number;

  @IsInt()
  @Transform((params) => parseInt(params.value))
  id_corr_trab: number;

}
