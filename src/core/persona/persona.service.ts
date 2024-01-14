import {
  BadRequestException,
  Injectable,
  InternalServerErrorException,
  Logger,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Persona } from './entities/persona.entity';
import { Repository } from 'typeorm';
import { SearchPersonaDto, CreatePersonaDto, UpdatePersonaDto } from './dto';

@Injectable()
export class PersonaService {
  private readonly logger = new Logger('PersonaService');
  constructor(
    @InjectRepository(Persona)
    private readonly personaRepository: Repository<Persona>,
  ) {}

  async createPersona(createPersonaDto: CreatePersonaDto) {
    try {
      const persona = await this.personaRepository.create(createPersonaDto);
      return await this.personaRepository.save(persona);
    } catch (error) {
      this.handleRxcepction(error);
    }
  }

  async findPersonOne(id_persona: number) {
    const person = await this.personaRepository.findOneBy({
      id_persona: id_persona,
    });
    if (!person) throw new BadRequestException('No se encontro la persona');
    return person;
  }

  async updatePerson(updatePersonaDto: UpdatePersonaDto) {
    const persona = await this.findPersonOne(updatePersonaDto.id_persona);
    if (!persona) throw new BadRequestException('No se encontro la persona');
    const personaUpdate = Object.assign(persona, updatePersonaDto);
    return await this.personaRepository.save(personaUpdate);
  }

  async buscarPersonaData(searchPersonaDto: SearchPersonaDto) {
    const ob = searchPersonaDto;
    let persona = [];
    let query: string = 'true';
    query += this.validador(ob.nro_doc_per)
      ? ' AND persona.nro_doc_per ~* :nro_doc_per'
      : '';
    query += this.validador(ob.ape_pat_per)
      ? ' AND persona.ape_pat_per ~* :ape_pat_per'
      : '';
    query += this.validador(ob.ape_mat_per)
      ? ' AND persona.ape_mat_per ~* :ape_mat_per'
      : '';
    query += this.validador(ob.nomb_per)
      ? ' AND persona.nomb_per ~* :nomb_per'
      : '';
    query += this.validador(ob.tipo_per)
      ? ' AND persona.tipo_per = :tipo_per'
      : '';
    query += this.validador(ob.tipo_doc_per)
      ? ' AND persona.tipo_doc_per = :tipo_doc_per'
      : '';
    query += this.validador(ob.sex_per)
      ? ' AND persona.sex_per = :sex_per'
      : '';

    persona = await this.personaRepository
      .createQueryBuilder('persona')
      .leftJoinAndSelect('persona.nomb_tipo_doc_per', 'li')
      .leftJoinAndSelect('persona.nomb_id_pais_nac', 'li2')
      .leftJoinAndSelect('persona.nomb_id_pais_emisor_doc', 'li3')
      .where(query, ob)
      .getMany();

    for (const data of persona) {
      data.nomb_tipo_doc_per = data.nomb_tipo_doc_per.desc_lista;
      data.nomb_id_pais_nac = data.nomb_id_pais_nac.desc_lista;
      data.nomb_id_pais_emisor_doc = data.nomb_id_pais_emisor_doc.desc_lista;
    }
    return persona;
  }

  private handleRxcepction = (error: any) => {
    if (error.code === '23505') throw new BadRequestException(error.detail);
    this.logger.error(error);

    throw new InternalServerErrorException();
  };
  
  private validador = (word: any) => {
    return word !== undefined && word !== null && word !== '';
  };
}
