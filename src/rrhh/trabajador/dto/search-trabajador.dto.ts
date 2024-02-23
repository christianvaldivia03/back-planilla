import { PartialType } from '@nestjs/mapped-types';
import { CreateTrabajadorDto } from './create-trabajador.dto';
import { IsInt, IsOptional, IsString } from 'class-validator';

export class SearchTrabajadorDto extends PartialType(CreateTrabajadorDto) {
  @IsString()
  @IsOptional()
  nro_doc_per: string;

  @IsString()
  @IsOptional()
  ape_pat_per: string;

  @IsString()
  @IsOptional()
  ape_mat_per: string;

  @IsString()
  @IsOptional()
  nomb_per: string;

  @IsInt()
  @IsOptional()
  id_corr_trab: number;
}
