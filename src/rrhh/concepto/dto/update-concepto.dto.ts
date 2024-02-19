import { PartialType } from '@nestjs/mapped-types';
import { CreateConceptoDto } from './create-concepto.dto';
import { IsInt, IsOptional } from 'class-validator';
import { Transform } from 'class-transformer';

export class UpdateConceptoDto extends PartialType(CreateConceptoDto) {
  @IsInt()
  @Transform((params) => parseInt(params.value))
  @IsOptional()
  id_concepto: number;

  @IsInt()
  @Transform((params) => parseInt(params.value))
  @IsOptional()
  est_conc: number;
}
