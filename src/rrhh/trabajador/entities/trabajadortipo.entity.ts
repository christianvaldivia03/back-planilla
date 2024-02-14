import { Column, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity({ name: 'trabajador_tipo' })
export class EmployeeType {
  @PrimaryGeneratedColumn()
  id_tipo_trabajador: number;

  @Column()
  cod_tipo_trabajador: string;

  @Column()
  desc_tipo_trabajador: string;

  @Column()
  est_tipo_trabajador: number;
}
