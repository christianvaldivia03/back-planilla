import { List } from 'src/core/mantenimiento/entities/list.entity';
import { Persona } from 'src/core/persona/entities/persona.entity';
import {
  Column,
  Entity,
  JoinColumn,
  ManyToOne,
  OneToMany,
  OneToOne,
  PrimaryColumn,
} from 'typeorm';
import { TrabajadorConcepto } from './trabajadorConcepto.entity';

@Entity({ schema: 'qubytss_rrhh' })
export class Trabajador {
  @PrimaryColumn()
  id_persona: number;

  @PrimaryColumn()
  id_corr_trab: number;

  @Column()
  cod_trab: string;

  @Column()
  estado_trabajador: number;

  @Column({ nullable: true })
  id_tipo_trabajador: number;

  @Column({ nullable: true })
  id_situacion_educativa: number;

  @Column({ nullable: true })
  id_ocupacion: number;

  @Column({ nullable: true })
  has_discapacidad: boolean;

  @Column({ nullable: true })
  id_condicion_laboral: number;

  @Column({ nullable: true })
  renta_quinta_exo: boolean;

  @Column({ nullable: true })
  sujeto_a_regimen: boolean;

  @Column({ nullable: true })
  sujeto_a_jornada: boolean;

  @Column({ nullable: true })
  sujeto_a_horario: boolean;

  @Column({ nullable: true })
  periodo_remuneracion: number;

  @Column({ nullable: true })
  situacion: number;

  @Column({ nullable: true })
  id_situacion_especial: number;

  @Column({ nullable: true })
  tipo_pago: number;

  @Column({ nullable: true })
  id_tipo_cuent_banco: number;

  @Column({ nullable: true })
  id_banco_sueldo: number;

  @Column({ nullable: true })
  num_cuenta_banco_sueldo: string;

  @Column({ nullable: true })
  num_cuenta_banco_sueldo_cci: string;

  @Column({ nullable: true })
  id_banco_cts: number;

  @Column({ nullable: true })
  num_cuenta_banco_cts: string;

  @Column({ nullable: true })
  fech_ingreso: Date;

  @Column({ nullable: true })
  id_doc_ingreso: number;

  @Column({ nullable: true })
  fech_doc_ingreso: Date;

  @Column({ nullable: true })
  num_doc_ingreso: string;

  @Column({ nullable: true })
  mot_ingreso: string;

  @Column({ nullable: true })
  fech_registro_sis: Date;

  @Column({ nullable: true })
  fech_salida: Date;

  @Column({ nullable: true })
  id_motivo_salida: number;

  @Column({ nullable: true })
  id_tipo_prestador: number;

  @Column({ nullable: true })
  fech_ingreso_salud: Date;

  @Column({ nullable: true })
  id_regimen_salud: number;

  @Column({ nullable: true })
  num_regimen_salud: string;

  @Column({ nullable: true })
  id_entidad_salud: number;

  @Column({ nullable: true })
  fech_ingreso_pension: Date;

  @Column({ nullable: true })
  id_regimen_pension: number;

  @Column({ nullable: true })
  id_regimen_pension_estado: number;

  @Column({ nullable: true })
  cuspp: string;

  @Column({ nullable: true })
  is_cod_generado_sys: boolean;

  @Column({ nullable: true })
  id_persona_registro: number;

  @Column({ nullable: true })
  id_filefoto: number;

  @ManyToOne(() => Persona, (per) => per.trabajador, {})
  @JoinColumn({ name: 'id_persona', referencedColumnName: 'id_persona' })
  persona: Persona;

  @OneToOne(() => List, (list) => list.persona_id_pais_emisor_doc, {})
  @JoinColumn({ name: 'id_regimen_pension', referencedColumnName: 'id_lista' })
  list_id_regimen_pension: List;

  @OneToOne(() => List)
  @JoinColumn({
    name: 'id_regimen_pension_estado',
    referencedColumnName: 'id_lista',
  })
  list_id_regimen_pension_estado: List;

  @OneToOne(() => List)
  @JoinColumn({
    name: 'id_regimen_salud',
    referencedColumnName: 'id_lista',
  })
  list_id_regimen_salud: List;

  @OneToOne(() => List)
  @JoinColumn({
    name: 'id_tipo_cuent_banco',
    referencedColumnName: 'id_lista',
  })
  list_id_tipo_cuent_banco: List;

  @OneToMany(
    () => TrabajadorConcepto,
    (trabajadorConcepto) => trabajadorConcepto.trabajador,
  )
  @JoinColumn([
    { name: 'id_persona', referencedColumnName: 'id_persona' },
    { name: 'id_corr_trab', referencedColumnName: 'id_corr_trab' },
  ])
  trabajadorConcepto: TrabajadorConcepto[];
}
