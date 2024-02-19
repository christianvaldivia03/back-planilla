import { Column, Entity, PrimaryColumn } from 'typeorm';

@Entity({ name: 'concepto' })
export class Concepto {
  @PrimaryColumn()
  id_concepto: number;

  @Column()
  cod_conc: string;

  @Column()
  nomb_conc: string;

  @Column()
  tipo_conc: number;

  @Column()
  fech_reg_conc: Date;

  @Column()
  id_sub_tipo_conc: number;

  @Column()
  afecto_essalud: boolean;

  @Column()
  afecto_previsional: boolean;

  @Column()
  afecto_impuesto: boolean;

  @Column()
  bonif_ext: boolean;

  @Column()
  est_conc: number;
}
