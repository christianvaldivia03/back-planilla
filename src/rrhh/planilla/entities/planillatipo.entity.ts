import { Column, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity({ name: 'planilla_tipo' })
export class TipoPlanilla {
  @PrimaryGeneratedColumn({ name: 'id_tipo_planilla' })
  id_tipo_planilla: number;

  @Column({ name: 'cod_tipo_pla', length: 10 })
  cod_tipo_pla: string;

  @Column({ name: 'nomb_tipo_pla', length: 100 })
  nomb_tipo_pla: string;

  @Column({ name: 'est_tipo_pla' })
  est_tipo_pla: number;
}
