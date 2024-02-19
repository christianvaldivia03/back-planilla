import { PartialType } from '@nestjs/mapped-types';
import { CreatePlanillaDto } from './create-planilla.dto';
import { IsIn, IsInt, IsOptional } from 'class-validator';
import { Transform } from 'class-transformer';

export class UpdatePlanillaDto extends PartialType(CreatePlanillaDto) {
  @IsOptional()
  @IsInt()
  @Transform((params) => parseInt(params.value))
  id_planilla: number;
}
