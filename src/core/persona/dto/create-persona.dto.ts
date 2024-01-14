import { IsInt, IsOptional, IsString, MaxLength } from 'class-validator';

export class CreatePersonaDto {
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

  @MaxLength(1)
  @IsOptional()
  sex_per: string;

  @IsOptional()
  fech_nac_per: Date;

  @IsInt()
  @IsOptional()
  id_pais_nac: number;

  @IsOptional()
  aud_fech_crea: Date;

  @IsString()
  @IsOptional()
  est_civil_per: string;

  @IsInt()
  @IsOptional()
  id_ubigeo_nac: number;

  @IsString()
  @IsOptional()
  nro_ruc: string;

  @IsInt()
  @IsOptional()
  id_pais_emisor_doc: number;

}
