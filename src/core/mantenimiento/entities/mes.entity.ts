import { Column, Entity, PrimaryColumn } from 'typeorm';

@Entity({ schema: 'qubytss_core', name: 'mes' })
export class Mes {
  @PrimaryColumn()
  id_mes: number;

  @Column()
  nomb_mes: string;

  @Column()
  nomb_cort_mes: string;
}
