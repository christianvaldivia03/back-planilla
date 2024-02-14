import { Column, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity({ name: 'trabajador_estado' })
export class EmployeeState {
  @PrimaryGeneratedColumn({ name: 'id_tipo_planilla' })
  id_estado_trabajador: number;

  @Column()
  cod_estado_trabajador: string;

  @Column()
  nomb_estado_trabajador: string;

  @Column()
  est_estado_trabajador: number;
}
