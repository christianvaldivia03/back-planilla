import {
  Column,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryColumn,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { Trabajador } from './trabajador.entity';

@Entity({ name: 'trabajador_concepto' })
export class TrabajadorConcepto {
  @PrimaryColumn()
  id_persona: number;

  @PrimaryColumn()
  id_corr_trab: number;

  @PrimaryColumn()
  id_concepto: number;

  @Column()
  monto_conc: number;

  @ManyToOne(() => Trabajador)
  @JoinColumn([
    { name: 'id_persona', referencedColumnName: 'id_persona' },
    { name: 'id_corr_trab', referencedColumnName: 'id_corr_trab' },
  ])
  trabajador: Trabajador;
}
