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
import { PlanillaTrabajadorConcepto } from './planillaTrabajadorConcepto';
import { List } from 'src/core/mantenimiento/entities/list.entity';
import { Persona } from 'src/core/persona/entities/persona.entity';
import { Trabajador } from 'src/rrhh/trabajador/entities/trabajador.entity';

@Entity({ name: 'planilla_trabajador' })
export class PlanillaTrabajador {
  @PrimaryColumn()
  id_planilla: number;

  @PrimaryColumn()
  id_persona: number;

  @PrimaryColumn()
  id_corr_trab: number;

  @Column()
  id_tipo_personal_pla: number;

  @Column()
  id_estado_personal_pla: number;

  @Column()
  id_regimen_salud: number;

  @Column()
  id_regimen_pension: number;

  @Column()
  id_regimen_pension_estado: number;

  @Column()
  observacion: string;

  @ManyToOne(() => Planilla)
  @JoinColumn({ name: 'id_planilla', referencedColumnName: 'id_planilla' })
  planilla: Planilla;

  @OneToMany(
    () => PlanillaTrabajadorConcepto,
    (lanillaTrabajadorConcepto) => lanillaTrabajadorConcepto.planillatrabajador,
  )
  @JoinColumn([
    { name: 'id_planilla', referencedColumnName: 'id_planilla' },
    { name: 'id_persona', referencedColumnName: 'id_persona' },
    { name: 'id_corr_trab', referencedColumnName: 'id_corr_trab' },
  ])
  planillatrabajadorconcepto: PlanillaTrabajadorConcepto;

  @OneToOne(() => List)
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

  @ManyToOne(() => Persona)
  @JoinColumn({ name: 'id_persona', referencedColumnName: 'id_persona' })
  persona: Persona;

  @OneToOne(() => Trabajador)
  @JoinColumn([
    { name: 'id_persona', referencedColumnName: 'id_persona' },
    { name: 'id_corr_trab', referencedColumnName: 'id_corr_trab' },
  ])
  trabajador: Trabajador;
}
