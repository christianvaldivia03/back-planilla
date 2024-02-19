import {
  Column,
  Entity,
  JoinColumn,
  ManyToOne,
  OneToMany,
  OneToOne,
  PrimaryColumn,
} from 'typeorm';
import { Planilla } from './planilla.entity';
import { PlanillaTrabajador } from './planillaTrabajador.entity';
import { Concepto } from 'src/rrhh/concepto/entities/concepto.entity';

@Entity({ name: 'planilla_trabajador_concepto' })
export class PlanillaTrabajadorConcepto {
  @PrimaryColumn()
  id_planilla: number;

  @PrimaryColumn()
  id_persona: number;

  @PrimaryColumn()
  id_corr_trab: number;

  @PrimaryColumn()
  id_concepto: number;

  @Column()
  monto_conc: number;

  @ManyToOne(() => PlanillaTrabajador)
  @JoinColumn([
    { name: 'id_planilla', referencedColumnName: 'id_planilla' },
    { name: 'id_persona', referencedColumnName: 'id_persona' },
    { name: 'id_corr_trab', referencedColumnName: 'id_corr_trab' },
  ])
  planillatrabajador: PlanillaTrabajador;

  @OneToOne(() => Concepto)
  @JoinColumn({ name: 'id_concepto', referencedColumnName: 'id_concepto' })
  concepto: Concepto;
}
