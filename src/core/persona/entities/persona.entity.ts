import {
  Column,
  Entity,
  JoinColumn,
  ManyToOne,
  OneToMany,
  OneToOne,
  PrimaryColumn,
} from 'typeorm';
import { Trabajador } from 'src/rrhh/trabajador/entities/trabajador.entity';
import { List } from 'src/core/mantenimiento/entities/list.entity';

@Entity({ schema: 'qubytss_core' })
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

  @Column()
  sex_per: string;

  @Column()
  fech_nac_per: Date;

  @Column()
  id_pais_nac: number;

  @Column()
  aud_fech_crea: Date;

  @Column()
  est_civil_per: string;

  @Column()
  id_ubigeo_nac: number;

  @Column()
  nro_ruc: string;

  @Column()
  id_pais_emisor_doc: number;

  @OneToOne(() => List, (list) => list.persona_tipo_doc_per, {})
  @JoinColumn({ name: 'tipo_doc_per', referencedColumnName: 'id_lista' })
  nomb_tipo_doc_per: List;

  @OneToOne(() => List, (list) => list.persona_id_pais_nac, {})
  @JoinColumn({ name: 'id_pais_nac', referencedColumnName: 'id_lista' })
  nomb_id_pais_nac: List;

  @OneToOne(() => List, (list) => list.persona_id_pais_emisor_doc, {})
  @JoinColumn({ name: 'id_pais_emisor_doc', referencedColumnName: 'id_lista' })
  nomb_id_pais_emisor_doc: List;

  @OneToMany(() => Trabajador, (tra) => tra.persona, {})
  @JoinColumn({ name: 'id_persona', referencedColumnName: 'id_persona' })
  trabajador: Trabajador;
}
