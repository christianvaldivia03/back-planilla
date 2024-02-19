import { Injectable, Logger } from '@nestjs/common';
import { CreatePlanillaDto } from './dto/create-planilla.dto';
import { UpdatePlanillaDto } from './dto/update-planilla.dto';
import { InjectRepository } from '@nestjs/typeorm';
import { Planilla } from './entities/planilla.entity';
import { DataSource, ILike, In, QueryRunner, Repository } from 'typeorm';
import { max } from 'rxjs';
import { PlanillaTrabajador } from './entities/planillaTrabajador.entity';
import { Trabajador } from '../trabajador/entities/trabajador.entity';
import { PlanillaTrabajadorConcepto } from './entities/planillaTrabajadorConcepto';
import { TrabajadorConcepto } from '../trabajador/entities/trabajadorConcepto.entity';
import { SearchPlanillaTrabajador } from './dto/search-planilla-concepto.dto';

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

  async createPlanilla(createPlanillaDto: CreatePlanillaDto) {
    const queryRunner = this.dataSource.createQueryRunner();
    await queryRunner.connect();
    await queryRunner.startTransaction();
    try {
      const maxIdPlanilla = await this.planillaRepository
        .createQueryBuilder('planilla')
        .select('coalesce(MAX(planilla.id_planilla), 0) +1', 'maxId')
        .getRawOne();
      const planillaData = await this.planillaRepository.create({
        ...createPlanillaDto,
        id_planilla: maxIdPlanilla.maxId,
      });
      await queryRunner.manager.save(planillaData);
      const numPlanilla = await this.planillaRepository
        .createQueryBuilder('x')
        .select(
          'qubytss_rrhh.get_cod_planilla(' + planillaData.id_planilla + ')',
          'numPlanilla',
        )
        .getRawOne();
      await queryRunner.commitTransaction();
      await queryRunner.release();
      return 'acción completada';
    } catch (error) {
      await queryRunner.rollbackTransaction();
      await queryRunner.release();
      throw error;
    }
  }

  async searchList(updatePlanillaDto: UpdatePlanillaDto) {
    const search = updatePlanillaDto;
    let objWhere: {
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
        planillatrabajador: {
          // planillatrabajadorconcepto: true,
          list_id_regimen_pension: true,
          list_id_regimen_salud: true,
          list_id_regimen_pension_estado: true,
          persona: true,
          trabajador: true,
        },
        mes: true,
        planillatipo: true,
        trabajadortipo: true,
      },
      where: {
        id_planilla: id_planilla,
      },
    });
    return planilla;
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
