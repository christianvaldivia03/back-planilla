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
      // this.logger.error(error);
      // console.log(error);
    }
  }

  buscarPersona() {
    return this.personaRepository.find();
  }

  buscarPersonaData(searchPersonaDto: SearchPersonaDto) {
    const ob = searchPersonaDto;
    console.log(ob);
    const result: Record<string, any> = {};
    let query: string = 'true';
    query += this.validador(ob.nro_doc_per)
      ? ' AND persona.nro_doc_per = :nro_doc_per'
      : '';
    query += this.validador(ob.ape_mat_per)
      ? ' AND persona.ape_mat_per = :ape_mat_per'
      : '';
    query += this.validador(ob.ape_mat_per)
      ? ' AND persona.ape_mat_per = :ape_mat_per'
      : '';
    query += this.validador(ob.tipo_per)
      ? ' AND persona.tipo_per = :tipo_per'
      : '';
    query += this.validador(ob.tipo_doc_per)
      ? ' AND persona.tipo_doc_per = :tipo_doc_per'
      : '';
    return this.personaRepository
      .createQueryBuilder('persona')
      .where(query, ob)
      .getMany();
    return 'A';
  }

  private validador = (word: any) => {
    // console.log(word);
    return word !== undefined && word !== null && word !== '';
  };

  private handleRxcepction = (error: any) => {
    if (error.code === '23505') throw new BadRequestException(error.detail);
    this.logger.error(error);

    throw new InternalServerErrorException();
  };
}
