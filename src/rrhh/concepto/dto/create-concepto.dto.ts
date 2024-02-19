import { Transform } from 'class-transformer';
import { IsBoolean, IsInt, IsOptional, IsString } from 'class-validator';

export class CreateConceptoDto {
  @IsString()
  cod_conc: string;

  @IsString()
  nomb_conc: string;

  @IsInt()
  @Transform((params) => parseInt(params.value))
  tipo_conc: number;

  @IsInt()
  @Transform((params) => parseInt(params.value))
  id_sub_tipo_conc: number;

  @IsBoolean()
  @Transform((params) => (params.value !== '' ? params.value : null))
  @IsOptional()
  afecto_essalud: boolean;

  @IsBoolean()
  @Transform((params) => (params.value !== '' ? params.value : null))
  @IsOptional()
  afecto_previsional: boolean;

  @IsBoolean()
  @Transform((params) => (params.value !== '' ? params.value : null))
  @IsOptional()
  afecto_impuesto: boolean;

  @IsBoolean()
  @Transform((params) => (params.value !== '' ? params.value : null))
  @IsOptional()
  bonif_ext: boolean;
}
