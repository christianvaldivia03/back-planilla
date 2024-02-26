import {
  Column,
  Entity,
  JoinColumn,
  OneToMany,
  OneToOne,
  PrimaryColumn,
} from 'typeorm';
import { PlanillaTrabajador } from './planillaTrabajador.entity';
import { Mes } from 'src/core/mantenimiento/entities/mes.entity';
import { PlanillaTipo } from './planillatipo.entity';
import { EmployeeType } from 'src/rrhh/trabajador/entities/trabajadortipo.entity';

@Entity({ name: 'planilla' })
export class Planilla {
  @PrimaryColumn({ name: 'id_planilla' })
  id_planilla: number;

  @Column({ name: 'id_planilla_plantilla', nullable: false })
  id_planilla_plantilla: number;

  @Column({ name: 'id_tipo_planilla', nullable: true })
  id_tipo_planilla: number;

  @Column({ name: 'id_tipo_trabajador', nullable: true })
  id_tipo_trabajador: number;

  @Column({ name: 'id_estado_personal_pla', nullable: true })
  id_estado_personal_pla: number;

  @Column({ name: 'id_clasificador', nullable: true })
  id_clasificador: number;

  @Column({ name: 'est_planilla', nullable: true })
  est_planilla: number;

  @Column({ name: 'id_anio', nullable: true })
  id_anio: number;

  @Column({ name: 'id_mes', length: 2, nullable: true })
  id_mes: string;

  @Column({ name: 'num_planilla', length: 20, nullable: true })
  num_planilla: string;

  @Column({ name: 'tit_planilla', length: 500, nullable: true })
  tit_planilla: string;

  @Column({ name: 'obs_planilla', length: 500, nullable: true })
  obs_planilla: string;

  @Column({ name: 'id_persona_registro', nullable: true })
  id_persona_registro: number;

  @Column({ name: 'id_persona_proceso', nullable: true })
  id_persona_proceso: number;

  @Column({ name: 'id_persona_transf', nullable: true })
  id_persona_transf: number;

  @Column({ name: 'id_persona_cierre', nullable: true })
  id_persona_cierre: number;

  @Column({ name: 'fech_cierre_pla', nullable: true })
  fech_cierre_pla: Date;

  @Column({ name: 'sys_fech_registro', default: () => 'CURRENT_TIMESTAMP' })
  sys_fech_registro: Date;

  // @Column({ name: 'fech_proceso', nullable: true })
  // fech_proceso: Date;

  @Column({ name: 'fech_transf', nullable: true })
  fech_transf: Date;

  @OneToMany(
    () => PlanillaTrabajador,
    (planillatrabajador) => planillatrabajador.planilla,
  )
  @JoinColumn([{ name: 'id_planilla', referencedColumnName: 'id_planilla' }])
  planillatrabajador: PlanillaTrabajador[];

  @OneToOne(() => Mes)
  @JoinColumn({ name: 'id_mes', referencedColumnName: 'id_mes' })
  mes: Mes;

  @OneToOne(() => PlanillaTipo)
  @JoinColumn({
    name: 'id_tipo_planilla',
    referencedColumnName: 'id_tipo_planilla',
  })
  planillatipo: PlanillaTipo;

  @OneToOne(() => EmployeeType)
  @JoinColumn({
    name: 'id_tipo_trabajador',
    referencedColumnName: 'id_tipo_trabajador',
  })
  trabajadortipo: EmployeeType;
}
