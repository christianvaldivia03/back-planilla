import { IsInt, IsOptional, IsString, MaxLength } from 'class-validator';

export class CreatePersonaDto {
  // @IsInt()
  // id_persona: number;

  @MaxLength(1)
  tipo_per: string;

  @IsInt()
  tipo_doc_per: number;

  @IsString()
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

  @IsString()
  @IsOptional()
  direc_per: string;
}
