import { PartialType } from '@nestjs/mapped-types';
import { CreateTrabajadorDto } from './create-trabajador.dto';
import { IsInt, IsOptional } from 'class-validator';

export class UpdateTrabajadorDto extends PartialType(CreateTrabajadorDto) {
  @IsInt()
  @IsOptional()
  id_corr_trab: number;
}
