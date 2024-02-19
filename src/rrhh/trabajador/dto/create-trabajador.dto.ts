import {
  IsInt,
  IsOptional,
  IsString,
  Max,
  MaxLength,
  IsBoolean,
  IsDate,
  IsArray,
} from 'class-validator';
import { TrabajadorConcepto } from '../entities/trabajadorConcepto.entity';

export class CreateTrabajadorDto {
  @IsInt()
  id_persona: number;

  // @IsInt()
  // id_corr_trab: number;

  @IsString()
  @MaxLength(10)
  cod_trab: string;

  @IsInt()
  estado_trabajador: number;

  @IsInt()
  @IsOptional()
  id_tipo_trabajador: number;

  @IsInt()
  @IsOptional()
  id_situacion_educativa: number;

  @IsInt()
  @IsOptional()
  id_ocupacion: number;

  @IsOptional()
  @IsBoolean()
  has_discapacidad: boolean;

  @IsInt()
  @IsOptional()
  id_condicion_laboral: number;

  @IsOptional()
  @IsBoolean()
  renta_quinta_exo: boolean;

  @IsOptional()
  @IsBoolean()
  sujeto_a_regimen: boolean;

  @IsOptional()
  @IsBoolean()
  sujeto_a_jornada: boolean;

  @IsOptional()
  @IsBoolean()
  sujeto_a_horario: boolean;

  @IsInt()
  @IsOptional()
  periodo_remuneracion: number;

  @IsInt()
  @IsOptional()
  situacion: number;

  @IsInt()
  @IsOptional()
  id_situacion_especial: number;

  @IsInt()
  @IsOptional()
  tipo_pago: number;

  @IsInt()
  @IsOptional()
  id_tipo_cuent_banco: number;

  @IsInt()
  @IsOptional()
  id_banco_sueldo: number;

  @IsString()
  @IsOptional()
  num_cuenta_banco_sueldo: string;

  @IsString()
  @IsOptional()
  num_cuenta_banco_sueldo_cci: string;

  @IsInt()
  @IsOptional()
  id_banco_cts: number;

  @IsString()
  @IsOptional()
  num_cuenta_banco_cts: string;

  @IsDate()
  @IsOptional()
  fech_ingreso: Date;

  @IsInt()
  @IsOptional()
  id_doc_ingreso: number;

  @IsDate()
  @IsOptional()
  fech_doc_ingreso: Date;

  @IsString()
  @IsOptional()
  num_doc_ingreso: string;

  @IsString()
  @IsOptional()
  mot_ingreso: string;

  @IsDate()
  @IsOptional()
  fech_registro_sis: Date;

  @IsDate()
  @IsOptional()
  fech_salida: Date;

  @IsInt()
  @IsOptional()
  id_motivo_salida: number;

  @IsInt()
  @IsOptional()
  id_tipo_prestador: number;

  @IsDate()
  @IsOptional()
  fech_ingreso_salud: Date;

  @IsInt()
  @IsOptional()
  id_regimen_salud: number;

  @IsString()
  @IsOptional()
  num_regimen_salud: string;

  @IsInt()
  @IsOptional()
  id_entidad_salud: number;

  @IsDate()
  @IsOptional()
  fech_ingreso_pension: Date;

  @IsInt()
  @IsOptional()
  id_regimen_pension: number;

  @IsInt()
  @IsOptional()
  id_regimen_pension_estado: number;

  @IsString()
  @IsOptional()
  cuspp: string;

  @IsBoolean()
  @IsOptional()
  is_cod_generado_sys: boolean;

  @IsInt()
  @IsOptional()
  id_persona_registro: number;

  @IsInt()
  @IsOptional()
  id_filefoto: number;

  @IsOptional()
  @IsArray()
  trabajador_concepto: TrabajadorConcepto[];
}
