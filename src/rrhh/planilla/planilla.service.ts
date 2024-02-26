import { BadRequestException, Injectable, Logger } from '@nestjs/common';
import { CreatePlanillaDto } from './dto/create-planilla.dto';
import { UpdatePlanillaDto } from './dto/update-planilla.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { Planilla } from './entities/planilla.entity';
import { DataSource, ILike, In, Repository } from 'typeorm';
import { PlanillaTrabajador } from './entities/planillaTrabajador.entity';
import { Trabajador } from '../trabajador/entities/trabajador.entity';
import { PlanillaTrabajadorConcepto } from './entities/planillaTrabajadorConcepto';
import { TrabajadorConcepto } from '../trabajador/entities/trabajadorConcepto.entity';
import { SearchPlanillaTrabajador } from './dto/search-planilla-concepto.dto';
import { SearchArrayPlanilla } from './dto/searchArrayPlanilla.dto';

@Injectable()
export class PlanillaService {
  private readonly logger = new Logger('PlanillaService');
  constructor(
    @InjectRepository(Planilla)
    private readonly planillaRepository: Repository<Planilla>,
    @InjectRepository(PlanillaTrabajador)
    private readonly planillaTrabajador: Repository<PlanillaTrabajador>,
    @InjectRepository(PlanillaTrabajadorConcepto)
    private readonly planillaTrabajadorConcepto: Repository<PlanillaTrabajadorConcepto>,
    @InjectRepository(Trabajador)
    private readonly trabajadorRepository: Repository<Trabajador>,
    @InjectRepository(TrabajadorConcepto)
    private readonly trabajadorConceptoRepository: Repository<TrabajadorConcepto>,

    private readonly dataSource: DataSource,
  ) {}

  async create(createPlanillaDto: CreatePlanillaDto) {
    const maxIdPlanilla = await this.planillaRepository
      .createQueryBuilder('planilla')
      .select('coalesce(MAX(planilla.id_planilla), 0) +1', 'maxId')
      .getRawOne();

    const planillaData = await this.planillaRepository.create({
      ...createPlanillaDto,
      id_planilla: maxIdPlanilla.maxId,
      est_planilla: 1,
    });
    await this.planillaRepository.save(planillaData);
    const numPlanilla = await this.planillaRepository
      .createQueryBuilder('a')
      .select(
        'qubytss_rrhh.get_cod_planilla(' + planillaData.id_planilla + ')',
        'num_planilla',
      )
      .getRawOne();
    const planillaUpdate = Object.assign(planillaData, numPlanilla);

    const planillaFinal = await this.planillaRepository.save(planillaUpdate);

    const trabajador = await this.trabajadorRepository.find({
      relations: {
        trabajadorConcepto: true,
      },
      where: {
        estado_trabajador: 1,
        id_tipo_trabajador: createPlanillaDto.id_tipo_trabajador,
      },
    });

    for (const iterator of trabajador) {
      const planillaEmployee = await this.planillaTrabajador.create({
        id_planilla: planillaFinal.id_planilla,
        id_persona: iterator.id_persona,
        id_corr_trab: iterator.id_corr_trab,
        id_tipo_personal_pla: iterator.id_tipo_trabajador,
        // id_estado_persona_pla: 1,
        id_regimen_salud: iterator.id_regimen_salud,
        id_regimen_pension: iterator.id_regimen_pension,
        id_regimen_pension_estado: iterator.id_regimen_pension_estado,
      });
      await this.planillaTrabajador.save(planillaEmployee);
      for (const iterator2 of iterator.trabajadorConcepto) {
        const planillaEmployeeConcepto =
          await this.planillaTrabajadorConcepto.create({
            id_planilla: planillaFinal.id_planilla,
            id_persona: iterator2.id_persona,
            id_corr_trab: iterator2.id_corr_trab,
            id_concepto: iterator2.id_concepto,
            monto_conc: iterator2.monto_conc,
          });
        await this.planillaTrabajadorConcepto.save(planillaEmployeeConcepto);
      }
    }

    return planillaFinal;
  }

  async searchList(updatePlanillaDto: UpdatePlanillaDto) {
    const search = updatePlanillaDto;
    const objWhere: {
      id_tipo_planilla?: number;
      id_anio?: number;
      id_mes?: string;
      id_tipo_trabajador?: number;
      num_planilla?: any;
    } = {};
    if (search.id_anio) objWhere.id_anio = search.id_anio;
    if (search.id_mes) objWhere.id_mes = search.id_mes;
    if (search.id_tipo_planilla)
      objWhere.id_tipo_planilla = search.id_tipo_planilla;
    if (search.id_tipo_trabajador)
      objWhere.id_tipo_trabajador = search.id_tipo_trabajador;
    if (search.num_planilla)
      objWhere.num_planilla = ILike(`%${search.num_planilla}%`);

    const planilla = await this.planillaRepository.find({
      where: objWhere,
      relations: {
        planillatipo: true,
        trabajadortipo: true,
      },
      order: {
        id_planilla: 'ASC',
      },
    });
    return planilla;
  }

  async searchOnePlanilla(updatePlanillaDto: UpdatePlanillaDto) {
    const { id_planilla } = updatePlanillaDto;
    const planilla = await this.planillaRepository.findOne({
      relations: {
        mes: true,
        planillatipo: true,
        trabajadortipo: true,
      },
      where: {
        id_planilla: id_planilla,
      },
    });

    // planilla.planillatrabajador = planilla.planillatrabajador.map((per) => {
    //   const full_name = `${per.persona.ape_pat_per} ${per.persona.ape_mat_per} ${per.persona.nomb_per}`;
    //   return { ...per, full_name };
    // });

    return planilla;
  }

  async searchEmployeePlanillaDetail(updatePlanillaDto: UpdatePlanillaDto) {
    const planillaTrabajador = await this.planillaTrabajador.find({
      relations: {
        trabajador: true,
        persona: true,
        list_id_regimen_pension: true,
        list_id_regimen_salud: true,
      },
      where: {
        id_planilla: updatePlanillaDto.id_planilla,
      },
      order: {
        persona: {
          ape_pat_per: 'ASC',
          ape_mat_per: 'ASC',
          nomb_per: 'ASC',
        },
      },
    });

    const newPlanillaTrabajador = planillaTrabajador.map((per) => {
      const full_name = `${per.persona.ape_pat_per} ${per.persona.ape_mat_per} ${per.persona.nomb_per}`;
      return { ...per, full_name };
    });
    return newPlanillaTrabajador;
  }

  async addEmployee(searchArrayPlanilla: SearchArrayPlanilla) {
    for (const iterator of searchArrayPlanilla.data) {
      //buscar trabajador
      const trabajador = await this.trabajadorRepository.findOne({
        relations: {
          trabajadorConcepto: true,
        },
        where: {
          id_persona: iterator.id_persona,
          id_corr_trab: iterator.id_corr_trab,
        },
      });
      //si no se encuentra el trabajador
      if (!trabajador)
        throw new BadRequestException('No se encontro el trabajador');
      //buscar si el trabajador ya esta en la planilla
      const exist = await this.planillaTrabajador.findOne({
        where: {
          id_planilla: iterator.id_planilla,
          id_persona: iterator.id_persona,
          id_corr_trab: iterator.id_corr_trab,
        },
      });
      if (exist)
        throw new BadRequestException('El trabajador ya esta en la planilla');
      //crear planilla trabajador
      const planillaEmployee = await this.planillaTrabajador.create({
        id_planilla: iterator.id_planilla,
        id_persona: trabajador.id_persona,
        id_corr_trab: trabajador.id_corr_trab,
        id_tipo_personal_pla: trabajador.id_tipo_trabajador,
        id_regimen_salud: trabajador.id_regimen_salud,
        id_regimen_pension: trabajador.id_regimen_pension,
        id_regimen_pension_estado: trabajador.id_regimen_pension_estado,
      });
      await this.planillaTrabajador.save(planillaEmployee);
      for (const it of trabajador.trabajadorConcepto) {
        const planillaEmployeeConcepto =
          await this.planillaTrabajadorConcepto.create({
            id_planilla: iterator.id_planilla,
            id_persona: it.id_persona,
            id_corr_trab: it.id_corr_trab,
            id_concepto: it.id_concepto,
            monto_conc: it.monto_conc,
          });
        await this.planillaTrabajadorConcepto.save(planillaEmployeeConcepto);
      }
    }
    return this.searchEmployeePlanillaDetail({
      id_planilla: searchArrayPlanilla.data[0].id_planilla,
    });
  }

  async searchConcepto(searchPlanillaTrabajador: SearchPlanillaTrabajador) {
    const { id_planilla, id_persona, id_corr_trab } = searchPlanillaTrabajador;

    const Remuneracion = await this.planillaTrabajadorConcepto.find({
      relations: {
        concepto: true,
      },
      where: {
        id_planilla: id_planilla,
        id_persona: id_persona,
        id_corr_trab: id_corr_trab,
        concepto: {
          tipo_conc: In([1, 3]),
        },
      },
    });
    const Descuento = await this.planillaTrabajadorConcepto.find({
      relations: {
        concepto: true,
      },
      where: {
        id_planilla: id_planilla,
        id_persona: id_persona,
        id_corr_trab: id_corr_trab,
        concepto: {
          tipo_conc: In([2]),
        },
      },
    });
    const Aporte = await this.planillaTrabajadorConcepto.find({
      relations: {
        concepto: true,
      },
      where: {
        id_planilla: id_planilla,
        id_persona: id_persona,
        id_corr_trab: id_corr_trab,
        concepto: {
          tipo_conc: In([4]),
        },
      },
    });

    const employeeConcepto = {
      remuneracion: Remuneracion,
      descuento: Descuento,
      aporte: Aporte,
    };
    return employeeConcepto;
  }
}
