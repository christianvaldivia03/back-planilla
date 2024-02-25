import {
  BadRequestException,
  Injectable,
  InternalServerErrorException,
  Logger,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Persona } from './entities/persona.entity';
import { ILike, Repository } from 'typeorm';
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
    const objWhere: {
      nro_doc_per?: any;
      ape_pat_per?: any;
      ape_mat_per?: any;
      nomb_per?: any;
      tipo_per?: string;
      tipo_doc_per?: number;
      sex_per?: string;
    } = {};

    if (ob.nro_doc_per)
      objWhere.nro_doc_per = ILike('%' + ob.nro_doc_per + '%');

    if (ob.ape_pat_per)
      objWhere.ape_pat_per = ILike('%' + ob.ape_pat_per + '%');

    if (ob.ape_mat_per)
      objWhere.ape_mat_per = ILike('%' + ob.ape_mat_per + '%');

    if (ob.nomb_per) objWhere.nomb_per = ILike('%' + ob.nomb_per + '%');

    if (ob.tipo_per) objWhere.tipo_per = ob.tipo_per;

    if (ob.tipo_doc_per) objWhere.tipo_doc_per = ob.tipo_doc_per;

    if (ob.sex_per) objWhere.sex_per = ob.sex_per;

    const persona = await this.personaRepository.find({
      relations: {
        list_tipo_doc_per: true,
        list_id_pais_nac: true,
        list_id_pais_emisor_doc: true,
      },
      where: objWhere,
      order: { ape_pat_per: 'ASC', ape_mat_per: 'ASC', nomb_per: 'ASC' },
    });

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
