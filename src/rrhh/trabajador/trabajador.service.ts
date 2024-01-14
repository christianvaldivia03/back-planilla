import {
  BadRequestException,
  Injectable,
  InternalServerErrorException,
  Logger,
} from '@nestjs/common';

import { Trabajador } from './entities/trabajador.entity';
import { Repository } from 'typeorm';
import { InjectRepository } from '@nestjs/typeorm';
import { Persona } from 'src/core/persona/entities/persona.entity';
import { PersonaService } from 'src/core/persona/persona.service';
import {
  CreateTrabajadorDto,
  UpdateTrabajadorDto,
  SearchTrabajadorDto,
} from './dto';

@Injectable()
export class TrabajadorService {
  private readonly logger = new Logger('TrabajadorService');
  constructor(
    @InjectRepository(Trabajador)
    private readonly trabajadorRepository: Repository<Trabajador>,
    @InjectRepository(Persona)
    private readonly personaService: PersonaService,
  ) {}

  async createEmployee(createTrabajadorDto: CreateTrabajadorDto) {
    const { id_persona } = createTrabajadorDto;
    await this.personaService.findPersonOne(id_persona);
    const employee = await this.trabajadorRepository.findOneBy({
      id_persona: id_persona,
    });
    try {
      if (employee == null) {
        const newEmployee = await this.trabajadorRepository.create({
          ...createTrabajadorDto,
          id_corr_trab: 1,
        });
        return await this.trabajadorRepository.save(newEmployee);
      } else {
        const d = await this.trabajadorRepository
          .createQueryBuilder('t')
          .select('MAX(t.id_corr_trab) + 1', 'id_corr_trab')
          .where('t.id_persona = :id_persona', { id_persona: id_persona })
          .getRawOne();
        const data = {
          ...createTrabajadorDto,
          id_corr_trab: d.id_corr_trab,
        };
        const newEmployee = await this.trabajadorRepository.create(data);
        return await this.trabajadorRepository.save(newEmployee);
      }
    } catch (error) {
      this.handleRxcepction(error);
    }
  }

  async updateEmployee(updateTrabajadorDto: UpdateTrabajadorDto) {
    const { id_persona, id_corr_trab } = updateTrabajadorDto;
    const employee = await this.findOneEmployee(id_persona, id_corr_trab);
    try {
      const employeeUpdate = Object.assign(employee, updateTrabajadorDto);
      return await this.trabajadorRepository.save(employeeUpdate);
    } catch (error) {
      this.handleRxcepction(error);
    }
  }

  async deleteEmployee(updateTrabajadorDto: UpdateTrabajadorDto) {
    const { id_persona, id_corr_trab } = updateTrabajadorDto;
    const employee = await this.findOneEmployee(id_persona, id_corr_trab);
    try {
      const employeeUpdate = Object.assign(employee, { estado_trabajador: 0 });
      return await this.trabajadorRepository.save(employeeUpdate);
    } catch (error) {
      this.handleRxcepction(error);
    }
  }

  async findEmployeeData(searchTrabajador: SearchTrabajadorDto) {
    const ob = searchTrabajador;
    let employee = [];
    let query: string = 'true';
    query += this.validador(ob.nro_doc_per)
      ? ' AND p.nro_doc_per ~* :nro_doc_per'
      : '';
    query += this.validador(ob.ape_pat_per)
      ? ' AND p.ape_pat_per ~* :ape_pat_per'
      : '';
    query += this.validador(ob.ape_mat_per)
      ? ' AND p.ape_mat_per ~* :ape_mat_per'
      : '';
    query += this.validador(ob.nomb_per) ? ' AND p.nomb_per ~* :nomb_per' : '';
    query += this.validador(ob.cod_trab) ? ' AND tr.cod_trab ~* :cod_trab' : '';

    employee = await this.trabajadorRepository
      .createQueryBuilder('tr')
      .innerJoinAndSelect('tr.persona', 'p')
      .leftJoinAndSelect('p.nomb_tipo_doc_per', 'li')
      .leftJoinAndSelect('p.nomb_id_pais_nac', 'li2')
      .leftJoinAndSelect('p.nomb_id_pais_emisor_doc', 'li3')
      .where(query, ob)
      .getMany();

    for (const data of employee) {
      data.persona.nomb_tipo_doc_per = data.persona.nomb_tipo_doc_per
        ? data.persona.nomb_tipo_doc_per.desc_lista
        : null;
      data.persona.nomb_id_pais_nac = data.persona.nomb_id_pais_nac
        ? data.persona.nomb_id_pais_nac.desc_lista
        : null;
      data.persona.nomb_id_pais_emisor_doc = data.persona
        .nomb_id_pais_emisor_doc
        ? data.persona.nomb_id_pais_emisor_doc.desc_lista
        : null;
    }

    return employee;
  }

  async findOneEmployee(id: number, id_corr_trab: number) {
    const employee = await this.trabajadorRepository.findOneBy({
      id_persona: id,
      id_corr_trab: id_corr_trab,
    });
    if (!employee)
      throw new BadRequestException('No se encontro el trabajador');
    return employee;
  }

  private validador = (word: any) => {
    return word !== undefined && word !== null && word !== '';
  };

  private handleRxcepction = (error: any) => {
    if (error.code === '23505') throw new BadRequestException(error.detail);
    this.logger.error(error);

    throw new InternalServerErrorException();
  };
}
