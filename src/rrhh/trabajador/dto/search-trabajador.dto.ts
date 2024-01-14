import { PartialType } from '@nestjs/mapped-types';
import { CreateTrabajadorDto } from './create-trabajador.dto';
import { IsIn, IsInt, IsOptional, IsString } from 'class-validator';

export class SearchTrabajadorDto extends PartialType(CreateTrabajadorDto) {
  @IsString()
  @IsOptional()
  nro_doc_per: number;

  @IsString()
  @IsOptional()
  ape_pat_per: number;

  @IsString()
  @IsOptional()
  ape_mat_per: number;

  @IsString()
  @IsOptional()
  nomb_per: number;
}
