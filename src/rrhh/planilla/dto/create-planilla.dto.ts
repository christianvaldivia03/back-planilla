import { Transform } from 'class-transformer';
import { IsInt, IsOptional, IsString } from 'class-validator';

export class CreatePlanillaDto {
  // id_planilla: number;
  // id_planilla_plantilla: number;
  @IsInt()
  @Transform((params) => parseInt(params.value))
  id_tipo_planilla: number;

  @IsInt()
  @Transform((params) => parseInt(params.value))
  id_tipo_trabajador: number;

  @IsInt()
  @Transform((params) => parseInt(params.value))
  id_anio: number;

  @IsString()
  id_mes: string;

  @IsString()
  @Transform(({ value }) => (value !== '' ? value : null))
  @IsOptional()
  obs_planilla: string;
}
