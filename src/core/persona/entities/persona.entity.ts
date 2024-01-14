import { Column, Entity, PrimaryColumn } from 'typeorm';

@Entity({ schema: 'qubitss_core' })
export class Persona {
  @PrimaryColumn()
  id_persona: number;

  @Column()
  tipo_per: string;

  @Column()
  tipo_doc_per: number;

  @Column()
  nro_doc_per: string;

  @Column()
  ape_pat_per: string;

  @Column()
  ape_mat_per: string;

  @Column()
  nomb_per: string;

  @Column()
  direc_per: string;
}
