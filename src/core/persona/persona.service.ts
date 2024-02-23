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
      const existingPersona = await this.personaRepository.findOneBy({
        nro_doc_per: persona.nro_doc_per,
        tipo_doc_per: persona.tipo_doc_per,
      });
      if (existingPersona)
        throw new BadRequestException(
          `La persona con numero de documento ${persona.nro_doc_per} ya existe`,
        );

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
      .leftJoinAndSelect('persona.list_tipo_doc_per', 'li')
      .leftJoinAndSelect('persona.list_id_pais_nac', 'li2')
      .leftJoinAndSelect('persona.list_id_pais_emisor_doc', 'li3')
      .where(query, ob)
      .getMany();

    return persona;
  }

  async buscarOnePersonaData(searchPersonaDto: SearchPersonaDto) {
    const ob = searchPersonaDto;
    const persona = await this.personaRepository.findOneBy({
      id_persona: ob.id_persona,
    });
    if (!persona) throw new BadRequestException('No se encontro la persona');

    Object.keys(persona).forEach((key) => {
      if (persona[key] === null) persona[key] = '';
    });
    const { id_pais_emisor_doc, fech_nac_per, id_ubigeo_nac, ...person } =
      persona;
    if (id_pais_emisor_doc && fech_nac_per && id_ubigeo_nac) {
    }

    return person;
  }

  private handleRxcepction = (error: any) => {
    if (error.code === '23505') throw new BadRequestException(error.detail);
    this.logger.error(error);

    throw new InternalServerErrorException(error.detail);
  };

  private validador = (word: any) => {
    return word !== undefined && word !== null && word !== '';
  };
}
