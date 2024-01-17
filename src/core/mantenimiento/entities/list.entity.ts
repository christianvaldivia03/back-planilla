import { Persona } from 'src/core/persona/entities/persona.entity';
import { Column, Entity, OneToOne, PrimaryColumn } from 'typeorm';

@Entity({ schema: 'qubytss_core', name: 'list' })
export class List {
  @PrimaryColumn()
  id_lista: number;

  @Column()
  entidad: string;

  @Column()
  cod_lista: string;

  @Column()
  desc_lista: string;

  @Column()
  estado_lista: number;

  @OneToOne(() => Persona, (persona) => persona.nomb_tipo_doc_per)
  persona_tipo_doc_per: Persona;

  @OneToOne(() => Persona, (persona) => persona.nomb_id_pais_nac, {})
  persona_id_pais_nac: Persona;

  @OneToOne(() => Persona, (persona) => persona.nomb_id_pais_emisor_doc, {})
  persona_id_pais_emisor_doc: Persona;
}
