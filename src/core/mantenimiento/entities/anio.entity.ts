import { Column, Entity, PrimaryColumn } from 'typeorm';

@Entity({ schema: 'qubytss_core', name: 'anio' })
export class Anio {
  @PrimaryColumn()
  id_anio: number;

  @Column()
  cod_anio: string;

  @Column()
  nom_anio: string;

  @Column()
  fech_ini_anio: Date;

  @Column()
  fech_fin_anio: Date;

  @Column()
  esta_anio: string;
}
