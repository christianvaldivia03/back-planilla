import {
  BadRequestException,
  Injectable,
  InternalServerErrorException,
  Logger,
} from '@nestjs/common';

import { Trabajador } from './entities/trabajador.entity';
import { ILike, Repository } from 'typeorm';
import { InjectRepository } from '@nestjs/typeorm';
import { Persona } from 'src/core/persona/entities/persona.entity';
import { PersonaService } from 'src/core/persona/persona.service';
import {
  CreateTrabajadorDto,
  UpdateTrabajadorDto,
  SearchTrabajadorDto,
} from './dto';
import { TrabajadorConcepto } from './entities/trabajadorConcepto.entity';

@Injectable()
export class TrabajadorService {
  private readonly logger = new Logger('TrabajadorService');
  constructor(
    @InjectRepository(Trabajador)
    private readonly trabajadorRepository: Repository<Trabajador>,
    @InjectRepository(Persona)
    private readonly personaService: PersonaService,
    @InjectRepository(TrabajadorConcepto)
    private readonly trabajadorConceptoService: Repository<TrabajadorConcepto>,
  ) {}

  async updateEmployeeConcepto(
    data: TrabajadorConcepto[],
    idpersona,
    idcorrtrab,
  ) {
    let retorno = [];
    console.log(data);
    for (let i = 0; i < data.length; i++) {
      let dataTrabajadorConcepto =
        await this.trabajadorConceptoService.findOneBy({
          id_persona: idpersona,
          id_corr_trab: idcorrtrab,
          id_concepto: data[i].id_concepto,
        });
      if (!dataTrabajadorConcepto) {
        await this.trabajadorConceptoService.save({
          ...data[i],
          id_persona: idpersona,
          id_corr_trab: idcorrtrab,
        });
      } else {
        dataTrabajadorConcepto = Object.assign(dataTrabajadorConcepto, {
          monto_conc: data[i].monto_conc,
        });
        await this.trabajadorConceptoService.save(dataTrabajadorConcepto);
      }
      retorno.push(dataTrabajadorConcepto);
    }
    return retorno;
  }

  async createEmployee(createTrabajadorDto: CreateTrabajadorDto) {
    const { id_persona } = createTrabajadorDto;
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

        const employeeFinal = await this.trabajadorRepository.save(newEmployee);
        employeeFinal.trabajadorConcepto = await this.updateEmployeeConcepto(
          createTrabajadorDto.trabajador_concepto,
          id_persona,
          d.id_corr_trab,
        );
        return employeeFinal;
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

  async buscarOneEmployeeData(searchTrabajadorDto: SearchTrabajadorDto) {
    const ob = searchTrabajadorDto;
    const employee = await this.trabajadorRepository.findOneBy({
      id_persona: ob.id_persona,
      id_corr_trab: ob.id_corr_trab,
    });
    if (!employee)
      throw new BadRequestException('No se encontro al trabajador');

    Object.keys(employee).forEach((key) => {
      if (employee[key] === null) employee[key] = '';
    });
    const { ...employ } = employee;

    return employ;
  }

  async findEmployeeData(searchTrabajador: SearchTrabajadorDto) {
    const ob = searchTrabajador;
    let employee = [];
    employee = await this.trabajadorRepository.find({
      relations: {
        list_id_regimen_pension: true,
        list_id_regimen_pension_estado: true,
        list_id_regimen_salud: true,
        list_id_tipo_cuent_banco: true,
        trabajadorConcepto: true,
        persona: {
          list_tipo_doc_per: true,
          list_id_pais_nac: true,
          list_id_pais_emisor_doc: true,
        },
      },
      where: {
        persona: {
          nro_doc_per: ILike(
            `%${this.validador(ob.nro_doc_per) ? ob.nro_doc_per : ''}%`,
          ),
          ape_pat_per: ILike(
            `%${this.validador(ob.ape_pat_per) ? ob.ape_pat_per : ''}%`,
          ),
          ape_mat_per: ILike(
            `%${this.validador(ob.ape_mat_per) ? ob.ape_mat_per : ''}%`,
          ),
          nomb_per: ILike(
            `%${this.validador(ob.nomb_per) ? ob.nomb_per : ''}%`,
          ),
        },
        cod_trab: ILike(`%${this.validador(ob.cod_trab) ? ob.cod_trab : ''}%`),
      },
      order: {
        persona: {
          ape_pat_per: 'ASC',
          ape_mat_per: 'ASC',
          nomb_per: 'ASC',
        },
      },
    });

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
